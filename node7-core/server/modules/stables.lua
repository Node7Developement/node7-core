local function loadedCharacter(source)
    local player = Node7.GetPlayer(source)
    return player and player.character and player or nil
end

local function decodeStableRows(rows)
    for _, row in ipairs(rows) do
        row.metadata = Node7Database.Decode(row.metadata, {})
        if row.tack ~= nil then row.tack = Node7Database.Decode(row.tack, {}) end
    end
    return rows
end

function Node7.GetHorses(source)
    local player = loadedCharacter(source)
    if not player then return {} end
    return decodeStableRows(MySQL.query.await([[
        SELECT * FROM node7_horses WHERE character_id = ? ORDER BY active DESC, id ASC
    ]], { player.character.id }) or {})
end

function Node7.GetHorse(source, horseId)
    local player = loadedCharacter(source)
    if not player then return nil end
    local row = MySQL.single.await('SELECT * FROM node7_horses WHERE id = ? AND character_id = ? LIMIT 1', {
        tonumber(horseId), player.character.id
    })
    return row and decodeStableRows({ row })[1] or nil
end

function Node7.CreateHorse(source, data)
    local player = loadedCharacter(source)
    if not player or type(data) ~= 'table' then return false, 'player_not_loaded' end
    local definition, modelKey = Node7ResolveHorseModel(data.model)
    local name = Node7.SanitizeText(data.name, 32)
    if not definition then return false, 'invalid_horse_model' end
    if not name then return false, 'invalid_horse_name' end

    local id = MySQL.insert.await([[
        INSERT INTO node7_horses
            (character_id, name, model, breed, gender, health, stamina, bonding, tack, metadata)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ]], {
        player.character.id, name, definition.model, data.breed or definition.label, data.gender or 'unknown',
        tonumber(data.health) or 100, tonumber(data.stamina) or 100, tonumber(data.bonding) or 0,
        json.encode(data.tack or {}), json.encode(data.metadata or { modelKey = modelKey })
    })
    Node7.Log(player.character.id, 'horse_created', id, { name = name, model = definition.model })
    if id then
        Node7.AddItem(source, 'horse_deed', 1, { horseId = id, horseName = name, model = definition.model })
    end
    return id ~= nil, id
end

function Node7.DeleteHorse(source, horseId)
    local player = loadedCharacter(source)
    if not player then return false end
    local changed = MySQL.update.await('DELETE FROM node7_horses WHERE id = ? AND character_id = ?', {
        tonumber(horseId), player.character.id
    })
    return changed and changed > 0
end

function Node7.SetActiveHorse(source, horseId)
    local player = loadedCharacter(source)
    if not player then return false end
    local owned = Node7.GetHorse(source, horseId)
    if not owned then return false end
    MySQL.update.await('UPDATE node7_horses SET active = 0 WHERE character_id = ?', { player.character.id })
    MySQL.update.await('UPDATE node7_horses SET active = 1 WHERE id = ?', { owned.id })
    return true
end

function Node7.SpawnHorse(source, horseId)
    local horses = Node7.GetHorses(source)
    if #horses == 0 then return false, 'no_horses' end
    local horse
    if horseId then
        for _, owned in ipairs(horses) do if owned.id == tonumber(horseId) then horse = owned break end end
    else
        for _, owned in ipairs(horses) do if owned.active == 1 or owned.active == true then horse = owned break end end
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
    return decodeStableRows(MySQL.query.await([[
        SELECT * FROM node7_wagons WHERE character_id = ? ORDER BY active DESC, id ASC
    ]], { player.character.id }) or {})
end

function Node7.GetWagon(source, wagonId)
    local player = loadedCharacter(source)
    if not player then return nil end
    local row = MySQL.single.await('SELECT * FROM node7_wagons WHERE id = ? AND character_id = ? LIMIT 1', {
        tonumber(wagonId), player.character.id
    })
    return row and decodeStableRows({ row })[1] or nil
end

function Node7.CreateWagon(source, data)
    local player = loadedCharacter(source)
    if not player or type(data) ~= 'table' then return false, 'player_not_loaded' end
    local definition, modelKey = Node7ResolveWagonModel(data.model)
    local name = Node7.SanitizeText(data.name, 32)
    if not definition then return false, 'invalid_wagon_model' end
    if not name then return false, 'invalid_wagon_name' end

    local id = MySQL.insert.await([[
        INSERT INTO node7_wagons (character_id, name, model, livery, condition_value, metadata)
        VALUES (?, ?, ?, ?, ?, ?)
    ]], {
        player.character.id, name, definition.model, tonumber(data.livery) or 0,
        tonumber(data.condition) or 100, json.encode(data.metadata or { modelKey = modelKey })
    })
    Node7.Log(player.character.id, 'wagon_created', id, { name = name, model = definition.model })
    if id then
        Node7.AddItem(source, 'wagon_deed', 1, { wagonId = id, wagonName = name, model = definition.model })
    end
    return id ~= nil, id
end

function Node7.DeleteWagon(source, wagonId)
    local player = loadedCharacter(source)
    if not player then return false end
    local changed = MySQL.update.await('DELETE FROM node7_wagons WHERE id = ? AND character_id = ?', {
        tonumber(wagonId), player.character.id
    })
    return changed and changed > 0
end

function Node7.SetActiveWagon(source, wagonId)
    local player = loadedCharacter(source)
    if not player then return false end
    local owned = Node7.GetWagon(source, wagonId)
    if not owned then return false end
    MySQL.update.await('UPDATE node7_wagons SET active = 0 WHERE character_id = ?', { player.character.id })
    MySQL.update.await('UPDATE node7_wagons SET active = 1 WHERE id = ?', { owned.id })
    return true
end

function Node7.SpawnWagon(source, wagonId)
    local wagons = Node7.GetWagons(source)
    if #wagons == 0 then return false, 'no_wagons' end
    local wagon
    if wagonId then
        for _, owned in ipairs(wagons) do if owned.id == tonumber(wagonId) then wagon = owned break end end
    else
        for _, owned in ipairs(wagons) do if owned.active == 1 or owned.active == true then wagon = owned break end end
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
