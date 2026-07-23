local function clone(value, seen)
    if type(value) ~= 'table' then return value end
    seen = seen or {}
    if seen[value] then return seen[value] end
    local copy = {}
    seen[value] = copy
    for key, entry in pairs(value) do copy[clone(key, seen)] = clone(entry, seen) end
    return copy
end

local function loadedCharacter(source)
    local player = Node7.GetPlayer(source)
    if not player or not player.character then return nil end
    player.character.horses = type(player.character.horses) == 'table' and player.character.horses or {}
    player.character.wagons = type(player.character.wagons) == 'table' and player.character.wagons or {}
    return player
end

local function nextOwnedId(rows)
    local highest = 0
    for _, row in ipairs(rows or {}) do highest = math.max(highest, tonumber(row.id) or 0) end
    return highest + 1
end

local function saveStables(source)
    Node7.RefreshPlayerData(source, false, true)
    Node7.MarkPlayerDirty(source)
end

function Node7.GetHorses(source)
    local player = loadedCharacter(source)
    if not player then return {} end
    table.sort(player.character.horses, function(a, b)
        if (a.active == true) ~= (b.active == true) then return a.active == true end
        return (tonumber(a.id) or 0) < (tonumber(b.id) or 0)
    end)
    return clone(player.character.horses)
end

function Node7.GetHorse(source, horseId)
    local player = loadedCharacter(source)
    if not player then return nil end
    horseId = tonumber(horseId)
    for _, horse in ipairs(player.character.horses) do
        if tonumber(horse.id) == horseId then return clone(horse) end
    end
end

function Node7.CreateHorse(source, data)
    local player = loadedCharacter(source)
    if not player or type(data) ~= 'table' then return false, 'player_not_loaded' end
    local definition, modelKey = Node7ResolveHorseModel(data.model)
    local name = Node7.SanitizeText(data.name, 32)
    if not definition then return false, 'invalid_horse_model' end
    if not name then return false, 'invalid_horse_name' end

    local horse = {
        id = nextOwnedId(player.character.horses),
        name = name,
        model = definition.model,
        breed = data.breed or definition.label,
        gender = data.gender or 'unknown',
        health = tonumber(data.health) or 100,
        stamina = tonumber(data.stamina) or 100,
        bonding = tonumber(data.bonding) or 0,
        tack = type(data.tack) == 'table' and clone(data.tack) or {},
        metadata = type(data.metadata) == 'table' and clone(data.metadata) or { modelKey = modelKey },
        active = #player.character.horses == 0
    }

    player.character.horses[#player.character.horses + 1] = horse
    Node7.AddItem(source, 'horse_deed', 1, { horseId = horse.id, horseName = name, model = definition.model })
    Node7.Log(player.character.citizenid, 'horse_created', horse.id, { name = name, model = definition.model })
    saveStables(source)
    return true, horse.id
end

function Node7.DeleteHorse(source, horseId)
    local player = loadedCharacter(source)
    if not player then return false, 'player_not_loaded' end
    horseId = tonumber(horseId)
    for index, horse in ipairs(player.character.horses) do
        if tonumber(horse.id) == horseId then
            table.remove(player.character.horses, index)
            saveStables(source)
            return true
        end
    end
    return false, 'horse_not_found'
end

function Node7.SetActiveHorse(source, horseId)
    local player = loadedCharacter(source)
    if not player then return false, 'player_not_loaded' end
    horseId = tonumber(horseId)
    local found = false
    for _, horse in ipairs(player.character.horses) do
        horse.active = tonumber(horse.id) == horseId
        if horse.active then found = true end
    end
    if found then saveStables(source) end
    return found
end

function Node7.SpawnHorse(source, horseId)
    local horses = Node7.GetHorses(source)
    if #horses == 0 then return false, 'no_horses' end
    local horse
    if horseId then
        for _, owned in ipairs(horses) do if tonumber(owned.id) == tonumber(horseId) then horse = owned break end end
    else
        for _, owned in ipairs(horses) do if owned.active == true or owned.active == 1 then horse = owned break end end
        horse = horse or horses[1]
    end
    if not horse then return false, 'horse_not_owned' end
    Node7.SetActiveHorse(source, horse.id)
    TriggerClientEvent('node7:client:spawnHorse', source, horse)
    return true, horse
end

function Node7.GetWagons(source)
    local player = loadedCharacter(source)
    if not player then return {} end
    table.sort(player.character.wagons, function(a, b)
        if (a.active == true) ~= (b.active == true) then return a.active == true end
        return (tonumber(a.id) or 0) < (tonumber(b.id) or 0)
    end)
    return clone(player.character.wagons)
end

function Node7.GetWagon(source, wagonId)
    local player = loadedCharacter(source)
    if not player then return nil end
    wagonId = tonumber(wagonId)
    for _, wagon in ipairs(player.character.wagons) do
        if tonumber(wagon.id) == wagonId then return clone(wagon) end
    end
end

function Node7.CreateWagon(source, data)
    local player = loadedCharacter(source)
    if not player or type(data) ~= 'table' then return false, 'player_not_loaded' end
    local definition, modelKey = Node7ResolveWagonModel(data.model)
    local name = Node7.SanitizeText(data.name, 32)
    if not definition then return false, 'invalid_wagon_model' end
    if not name then return false, 'invalid_wagon_name' end

    local wagon = {
        id = nextOwnedId(player.character.wagons),
        name = name,
        model = definition.model,
        livery = tonumber(data.livery) or 0,
        condition_value = tonumber(data.condition or data.condition_value) or 100,
        metadata = type(data.metadata) == 'table' and clone(data.metadata) or { modelKey = modelKey },
        active = #player.character.wagons == 0
    }

    player.character.wagons[#player.character.wagons + 1] = wagon
    Node7.AddItem(source, 'wagon_deed', 1, { wagonId = wagon.id, wagonName = name, model = definition.model })
    Node7.Log(player.character.citizenid, 'wagon_created', wagon.id, { name = name, model = definition.model })
    saveStables(source)
    return true, wagon.id
end

function Node7.DeleteWagon(source, wagonId)
    local player = loadedCharacter(source)
    if not player then return false, 'player_not_loaded' end
    wagonId = tonumber(wagonId)
    for index, wagon in ipairs(player.character.wagons) do
        if tonumber(wagon.id) == wagonId then
            table.remove(player.character.wagons, index)
            saveStables(source)
            return true
        end
    end
    return false, 'wagon_not_found'
end

function Node7.SetActiveWagon(source, wagonId)
    local player = loadedCharacter(source)
    if not player then return false, 'player_not_loaded' end
    wagonId = tonumber(wagonId)
    local found = false
    for _, wagon in ipairs(player.character.wagons) do
        wagon.active = tonumber(wagon.id) == wagonId
        if wagon.active then found = true end
    end
    if found then saveStables(source) end
    return found
end

function Node7.SpawnWagon(source, wagonId)
    local wagons = Node7.GetWagons(source)
    if #wagons == 0 then return false, 'no_wagons' end
    local wagon
    if wagonId then
        for _, owned in ipairs(wagons) do if tonumber(owned.id) == tonumber(wagonId) then wagon = owned break end end
    else
        for _, owned in ipairs(wagons) do if owned.active == true or owned.active == 1 then wagon = owned break end end
        wagon = wagon or wagons[1]
    end
    if not wagon then return false, 'wagon_not_owned' end
    Node7.SetActiveWagon(source, wagon.id)
    TriggerClientEvent('node7:client:spawnWagon', source, wagon, false)
    return true, wagon
end

function Node7.AdminSpawnHorse(source, model)
    local definition = Node7ResolveHorseModel(model)
    if not definition then return false, 'invalid_horse_model' end
    TriggerClientEvent('node7:client:spawnHorse', source, { name = definition.label, model = definition.model, id = 0 }, true)
    return true
end

function Node7.AdminSpawnWagon(source, model)
    local definition = Node7ResolveWagonModel(model)
    if not definition then return false, 'invalid_wagon_model' end
    TriggerClientEvent('node7:client:spawnWagon', source, { name = definition.label, model = definition.model, id = 0 }, true)
    return true
end

RegisterNetEvent('node7:server:requestHorse', function(horseId) Node7.SpawnHorse(source, horseId) end)
RegisterNetEvent('node7:server:requestWagon', function(wagonId) Node7.SpawnWagon(source, wagonId) end)

Node7.RegisterCallback('stables:horses', function(source, cb) cb(Node7.GetHorses(source)) end)
Node7.RegisterCallback('stables:wagons', function(source, cb) cb(Node7.GetWagons(source)) end)

exports('GetOwnedHorses', Node7.GetHorses)
exports('GetHorse', Node7.GetHorse)
exports('CreateHorse', Node7.CreateHorse)
exports('DeleteHorse', Node7.DeleteHorse)
exports('SetActiveHorse', Node7.SetActiveHorse)
exports('SpawnHorse', Node7.SpawnHorse)
exports('GetOwnedWagons', Node7.GetWagons)
exports('GetWagon', Node7.GetWagon)
exports('CreateWagon', Node7.CreateWagon)
exports('DeleteWagon', Node7.DeleteWagon)
exports('SetActiveWagon', Node7.SetActiveWagon)
exports('SpawnWagon', Node7.SpawnWagon)
