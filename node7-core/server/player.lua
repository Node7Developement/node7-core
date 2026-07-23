local function identifiersFor(source)
    local identifiers = { license = nil, license2 = nil, fivem = nil, discord = nil, steam = nil }
    for _, identifier in ipairs(GetPlayerIdentifiers(source)) do
        local kind = identifier:match('^([^:]+):')
        if kind == 'license' and not identifiers.license then identifiers.license = identifier end
        if kind == 'license2' and not identifiers.license2 then identifiers.license2 = identifier end
        if kind == 'fivem' then identifiers.fivem = identifier end
        if kind == 'discord' then identifiers.discord = identifier end
        if kind == 'steam' then identifiers.steam = identifier end
    end
    identifiers.license = identifiers.license or identifiers.license2
    return identifiers
end

local function clone(value, seen)
    if type(value) ~= 'table' then return value end
    seen = seen or {}
    if seen[value] then return seen[value] end
    local copy = {}
    seen[value] = copy
    for key, entry in pairs(value) do copy[clone(key, seen)] = clone(entry, seen) end
    return copy
end

local function normalizeGrade(value)
    if type(value) == 'table' then
        return math.max(0, math.floor(tonumber(value.level or value.grade or value[1]) or 0))
    end
    return math.max(0, math.floor(tonumber(value) or 0))
end

local function normalizeMoney(money)
    money = type(money) == 'table' and money or {}
    return {
        cash = math.max(0, math.floor(tonumber(money.cash) or 0)),
        bank = math.max(0, math.floor(tonumber(money.bank) or 0)),
        gold = math.max(0, math.floor(tonumber(money.gold) or 0))
    }
end

local function normalizePosition(position)
    position = type(position) == 'table' and position or {}
    return {
        x = tonumber(position.x or position[1]) or 0.0,
        y = tonumber(position.y or position[2]) or 0.0,
        z = tonumber(position.z or position[3]) or 0.0,
        w = tonumber(position.w or position.h or position.heading or position[4]) or 0.0
    }
end

local function normalizeCharInfo(charinfo)
    charinfo = type(charinfo) == 'table' and charinfo or {}
    return {
        firstname = Node7.SanitizeText(charinfo.firstname or charinfo.firstName or charinfo.first_name, 50, true) or '',
        lastname = Node7.SanitizeText(charinfo.lastname or charinfo.lastName or charinfo.last_name, 50, true) or '',
        birthdate = Node7.SanitizeText(charinfo.birthdate or charinfo.dateOfBirth or charinfo.date_of_birth, 20, true) or '',
        gender = Node7.SanitizeText(charinfo.gender or charinfo.sex, 20, true) or '',
        nationality = Node7.SanitizeText(charinfo.nationality, 50, true) or '',
        backstory = Node7.SanitizeText(charinfo.backstory or charinfo.biography, 2000, true) or ''
    }
end

local function normalizeJob(job)
    job = type(job) == 'table' and job or {}
    local grade = normalizeGrade(job.grade)
    local definition = Node7Jobs[job.name] or Node7Jobs.unemployed
    return {
        name = definition and (job.name or 'unemployed') or 'unemployed',
        grade = grade,
        duty = job.duty == true or job.onduty == true
    }
end

local function normalizeGang(gang)
    gang = type(gang) == 'table' and gang or {}
    local definition = Node7Gangs[gang.name] or Node7Gangs.none
    return {
        name = definition and (gang.name or 'none') or 'none',
        grade = normalizeGrade(gang.grade)
    }
end

local function fullName(charinfo)
    local first = charinfo.firstname ~= '' and charinfo.firstname or 'Unknown'
    local last = charinfo.lastname ~= '' and charinfo.lastname or 'Unknown'
    return ('%s %s'):format(first, last)
end

local function getGrade(definition, level)
    if not definition or not definition.grades then return nil end
    return definition.grades[tostring(level)] or definition.grades[tonumber(level)]
end

local function jobData(character)
    local definition = Node7Jobs[character.job.name] or Node7Jobs.unemployed
    local grade = getGrade(definition, character.job.grade) or getGrade(definition, 0) or { name = '0', label = '0', payment = 0 }
    return {
        name = character.job.name,
        label = definition.label,
        type = definition.type or 'civilian',
        onduty = character.job.duty == true,
        duty = character.job.duty == true,
        isboss = grade.isboss == true,
        payment = grade.payment or 0,
        grade = {
            name = grade.name or tostring(character.job.grade),
            level = character.job.grade,
            label = grade.label or grade.name or tostring(character.job.grade)
        },
        metadata = definition.metadata or {}
    }
end

local function gangData(character)
    local definition = Node7Gangs[character.gang.name] or Node7Gangs.none
    local grade = getGrade(definition, character.gang.grade) or getGrade(definition, 0) or { name = '0', label = '0' }
    return {
        name = character.gang.name,
        label = definition.label,
        isboss = grade.isboss == true,
        grade = {
            name = grade.name or tostring(character.gang.grade),
            level = character.gang.grade,
            label = grade.label or grade.name or tostring(character.gang.grade)
        },
        metadata = definition.metadata or {}
    }
end

local function makeCharacter(playerData)
    local charinfo = normalizeCharInfo(playerData.charinfo)
    local character = {
        id = tostring(playerData.citizenid),
        citizenid = tostring(playerData.citizenid),
        slot = tonumber(playerData.slot or playerData.cid) or 1,
        firstName = charinfo.firstname,
        lastName = charinfo.lastname,
        dateOfBirth = charinfo.birthdate,
        sex = charinfo.gender,
        nationality = charinfo.nationality,
        biography = charinfo.backstory,
        money = normalizeMoney(playerData.money),
        job = normalizeJob(playerData.job),
        gang = normalizeGang(playerData.gang),
        metadata = type(playerData.metadata) == 'table' and clone(playerData.metadata) or {},
        position = normalizePosition(playerData.position),
        appearance = type(playerData.appearance) == 'table' and clone(playerData.appearance) or {},
        inventory = type(playerData.inventory) == 'table' and clone(playerData.inventory) or {},
        weapons = type(playerData.weapons) == 'table' and clone(playerData.weapons) or {},
        horses = type(playerData.horses) == 'table' and clone(playerData.horses) or {},
        wagons = type(playerData.wagons) == 'table' and clone(playerData.wagons) or {},
        health = tonumber(playerData.health) or 200,
        stamina = tonumber(playerData.stamina) or 100
    }
    return character
end

local function publicData(player)
    if not player or not player.character then return nil end
    return {
        source = player.source,
        character = player.character,
        PlayerData = player.PlayerData
    }
end

local function buildFunctions(source, player)
    player.Functions = player.Functions or {}
    player.Functions.UpdatePlayerData = function() return Node7.RefreshPlayerData(source, true, true) end
    player.Functions.Save = function() return Node7.SavePlayer(source) end
    player.Functions.GetName = function() return player.PlayerData and player.PlayerData.name end
    player.Functions.SetJob = function(name, grade) return Node7.SetJob(source, name, grade) end
    player.Functions.SetGang = function(name, grade) return Node7.SetGang(source, name, grade) end
    player.Functions.SetJobDuty = function(state) return Node7.SetDuty(source, state) end
    player.Functions.AddMoney = function(account, amount, reason) return Node7.AddMoney(source, account, amount, reason) end
    player.Functions.RemoveMoney = function(account, amount, reason) return Node7.RemoveMoney(source, account, amount, reason) end
    player.Functions.SetMoney = function(account, amount, reason) return Node7.SetMoney(source, account, amount, reason) end
    player.Functions.GetMoney = function(account) return Node7.GetMoney(source, account) end
    player.Functions.AddItem = function(item, amount, slot, metadata) return Node7.AddItem(source, item, amount, metadata, slot) end
    player.Functions.RemoveItem = function(item, amount, slot) return Node7.RemoveItem(source, item, amount, slot) end
    player.Functions.GetItemByName = function(item)
        local inventory = Node7.GetInventory(source)
        for _, row in ipairs(inventory and inventory.items or {}) do
            if row.name == item or row.item_name == item then return row end
        end
    end
    player.Functions.SetMetaData = function(key, value)
        if type(key) ~= 'string' or #key > 40 then return false end
        player.character.metadata[key] = clone(value)
        Node7.RefreshPlayerData(source, false, true)
        Node7.MarkPlayerDirty(source)
        return true
    end
    player.Functions.GetMetaData = function(key) return player.character.metadata[key] end
    player.Functions.SetPosition = function(position) return Node7.SetPosition(source, position) end
    player.Functions.SetAppearance = function(appearance) return Node7.SetAppearance(source, appearance) end
    player.Functions.AddMethod = function(name, handler)
        if type(name) ~= 'string' or type(handler) ~= 'function' then return false end
        player.Functions[name] = handler
        return true
    end
    player.Functions.AddField = function(name, value)
        if type(name) ~= 'string' or name == 'PlayerData' or name == 'Functions' then return false end
        player[name] = value
        return true
    end
end

function Node7.RefreshPlayerData(source, includeInventory, sendClient)
    source = tonumber(source)
    local player = source and Node7.Players[source]
    if not player or not player.character then return nil end

    local character = player.character
    local inventory = includeInventory and Node7.GetInventory and Node7.GetInventory(source) or nil
    local charinfo = {
        firstname = character.firstName,
        lastname = character.lastName,
        birthdate = character.dateOfBirth,
        gender = character.sex,
        nationality = character.nationality,
        backstory = character.biography
    }

    player.PlayerData = {
        source = source,
        citizenid = character.citizenid,
        cid = character.slot,
        slot = character.slot,
        license = player.identifiers.license,
        name = fullName(charinfo),
        charinfo = charinfo,
        money = character.money,
        job = jobData(character),
        gang = gangData(character),
        position = character.position,
        metadata = character.metadata,
        appearance = character.appearance,
        inventory = character.inventory,
        weapons = character.weapons,
        horses = character.horses,
        wagons = character.wagons,
        health = character.health,
        stamina = character.stamina,
        items = inventory and inventory.items or character.inventory
    }

    buildFunctions(source, player)

    if sendClient ~= false then
        TriggerClientEvent('node7:client:setPlayerData', source, player.PlayerData)
        TriggerClientEvent('Node7:Player:SetPlayerData', source, player.PlayerData)
    end

    return player.PlayerData
end

function Node7.RegisterExternalPlayer(source, playerData)
    source = tonumber(source)
    if not source or source <= 0 or not GetPlayerName(source) then return false, 'invalid_source' end
    if type(playerData) ~= 'table' then return false, 'invalid_player_data' end
    if type(playerData.citizenid) ~= 'string' or playerData.citizenid == '' then return false, 'missing_citizenid' end

    local identifiers = identifiersFor(source)
    identifiers.license = tostring(playerData.license or identifiers.license or '')

    local character = makeCharacter(playerData)
    local player = {
        source = source,
        identifiers = identifiers,
        name = GetPlayerName(source),
        loaded = true,
        dirty = false,
        character = character,
        PlayerData = nil,
        Functions = {}
    }

    Node7.Players[source] = player
    Node7.RefreshPlayerData(source, true, true)

    Player(source).state:set('citizenid', character.citizenid, true)
    Player(source).state:set('node7CharacterSlot', character.slot, true)
    Player(source).state:set('node7Loaded', true, true)

    TriggerClientEvent('node7:client:loaded', source, publicData(player))
    TriggerClientEvent('Node7:Client:OnPlayerLoaded', source)
    TriggerEvent('node7:server:playerLoaded', source, player)
    TriggerEvent('Node7:Server:OnPlayerLoaded', source, player)

    if Node7.Commands and Node7.Commands.Refresh then Node7.Commands.Refresh(source) end
    return true, player
end

function Node7.SavePlayer(source)
    source = tonumber(source)
    local player = source and Node7.Players[source]
    if not player or not player.character then return false, 'player_not_loaded' end

    local ped = GetPlayerPed(source)
    if ped and ped > 0 then
        local coords = GetEntityCoords(ped)
        player.character.position = { x = coords.x, y = coords.y, z = coords.z, w = GetEntityHeading(ped) }
    end

    local playerData = Node7.RefreshPlayerData(source, true, false)
    if not playerData then return false, 'refresh_failed' end

    TriggerEvent('node7:server:externalSaveRequested', source, playerData.citizenid, playerData)
    player.dirty = false
    player.lastSave = os.time()
    return true, playerData
end

function Node7.UnloadExternalPlayer(source, save)
    source = tonumber(source)
    local player = source and Node7.Players[source]
    if not player then return false, 'player_not_loaded' end

    if save ~= false then
        pcall(Node7.SavePlayer, source)
    end

    Node7.Players[source] = nil

    if GetPlayerName(source) then
        Player(source).state:set('citizenid', nil, true)
        Player(source).state:set('node7CharacterSlot', nil, true)
        Player(source).state:set('node7Loaded', false, true)
        TriggerClientEvent('node7:client:unloaded', source)
    end

    TriggerEvent('node7:server:playerUnloaded', source, player)
    TriggerEvent('Node7:Server:OnPlayerUnload', source, player)
    return true, 'success'
end

function Node7.SetPosition(source, position)
    source = tonumber(source)
    local player = source and Node7.Players[source]
    if not player or not player.character or type(position) ~= 'table' then return false, 'player_not_loaded' end
    player.character.position = normalizePosition(position)
    Node7.RefreshPlayerData(source, false, true)
    Node7.MarkPlayerDirty(source)
    return true, player.character.position
end

function Node7.SetAppearance(source, appearance)
    source = tonumber(source)
    local player = source and Node7.Players[source]
    if not player or not player.character then return false, 'player_not_loaded' end
    if type(appearance) ~= 'table' then return false, 'invalid_appearance' end
    player.character.appearance = clone(appearance)
    Node7.RefreshPlayerData(source, false, true)
    Node7.MarkPlayerDirty(source)
    return true, player.character.appearance
end

RegisterNetEvent('node7:server:updateMetadata', function(key, value)
    local player = Node7.GetPlayer(source)
    if not player or not player.character or type(key) ~= 'string' or #key > 40 then return end
    player.character.metadata[key] = clone(value)
    Node7.RefreshPlayerData(source, false, true)
    Node7.MarkPlayerDirty(source)
end)

AddEventHandler('playerDropped', function()
    local src = source
    if Node7.Players[src] then
        pcall(Node7.SavePlayer, src)
        Node7.Players[src] = nil
    end
end)

exports('RegisterExternalPlayer', Node7.RegisterExternalPlayer)
exports('UnloadExternalPlayer', Node7.UnloadExternalPlayer)
exports('SavePlayer', Node7.SavePlayer)
exports('RefreshPlayerData', Node7.RefreshPlayerData)
exports('SetPosition', Node7.SetPosition)
exports('SetAppearance', Node7.SetAppearance)
