local function identifiersFor(source)
    local identifiers = { license = nil, fivem = nil, discord = nil, steam = nil }
    for _, identifier in ipairs(GetPlayerIdentifiers(source)) do
        local kind = identifier:match('^([^:]+):')
        if kind == 'license' and not identifiers.license then identifiers.license = identifier end
        if kind == 'fivem' then identifiers.fivem = identifier end
        if kind == 'discord' then identifiers.discord = identifier end
        if kind == 'steam' then identifiers.steam = identifier end
    end
    return identifiers
end

local function clone(value)
    if type(value) ~= 'table' then return value end
    local result = {}
    for key, entry in pairs(value) do result[key] = clone(entry) end
    return result
end

local function hydrate(row)
    local metadata = Node7Database.Decode(row.metadata, {})
    for key, value in pairs(Node7Config.PlayerMetadata) do
        if metadata[key] == nil then metadata[key] = clone(value) end
    end
    return {
        id = row.id,
        firstName = row.first_name,
        lastName = row.last_name,
        dateOfBirth = row.date_of_birth,
        sex = row.sex,
        nationality = row.nationality,
        biography = row.biography,
        money = { cash = row.cash, bank = row.bank, gold = row.gold },
        job = { name = row.job, grade = row.job_grade, duty = false },
        gang = { name = row.gang, grade = row.gang_grade },
        metadata = metadata,
        position = Node7Database.Decode(row.position, Node7Config.DefaultSpawn),
        appearance = Node7Database.Decode(row.appearance, {}),
        health = row.health or 200,
        stamina = row.stamina or 100
    }
end

local function publicData(player)
    if not player or not player.character then return nil end
    return {
        source = player.source,
        character = player.character,
        PlayerData = player.PlayerData
    }
end

local function getGrade(definition, level)
    if not definition or not definition.grades then return nil end
    return definition.grades[tostring(level)] or definition.grades[tonumber(level)]
end

local function jobData(character)
    local definition = Node7Jobs[character.job.name] or Node7Jobs.unemployed
    local grade = getGrade(definition, character.job.grade) or getGrade(definition, 0)
    return {
        name = character.job.name,
        label = definition.label,
        type = definition.type or 'civilian',
        onduty = character.job.duty == true,
        isboss = grade.isboss == true,
        payment = grade.payment or 0,
        grade = { name = grade.name, level = character.job.grade, label = grade.label or grade.name },
        metadata = definition.metadata or {}
    }
end

local function gangData(character)
    local definition = Node7Gangs[character.gang.name] or Node7Gangs.none
    local grade = getGrade(definition, character.gang.grade) or getGrade(definition, 0)
    return {
        name = character.gang.name,
        label = definition.label,
        isboss = grade.isboss == true,
        grade = { name = grade.name, level = character.gang.grade, label = grade.label or grade.name },
        metadata = definition.metadata or {}
    }
end

function Node7.RefreshPlayerData(source, includeInventory)
    local player = Node7.Players[source]
    if not player or not player.character then return nil end
    local character = player.character
    local inventory = includeInventory and Node7.GetInventory and Node7.GetInventory(source) or nil
    player.PlayerData = {
        source = source,
        userId = player.userId,
        citizenid = ('N7%08d'):format(character.id),
        cid = character.id,
        license = player.identifiers.license,
        name = player.name,
        charinfo = {
            firstname = character.firstName,
            lastname = character.lastName,
            birthdate = character.dateOfBirth,
            gender = character.sex,
            nationality = character.nationality,
            backstory = character.biography
        },
        money = character.money,
        job = jobData(character),
        gang = gangData(character),
        position = character.position,
        metadata = character.metadata,
        items = inventory and inventory.items or (player.PlayerData and player.PlayerData.items or {})
    }

    player.Functions = player.Functions or {}
    player.Functions.UpdatePlayerData = function() return Node7.RefreshPlayerData(source, true) end
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
        local inventoryData = Node7.GetInventory(source)
        for _, row in ipairs(inventoryData and inventoryData.items or {}) do if row.item_name == item then return row end end
    end
    player.Functions.SetMetaData = function(key, value)
        if type(key) ~= 'string' or #key > 40 then return false end
        character.metadata[key] = value
        player.PlayerData.metadata = character.metadata
        TriggerClientEvent('node7:client:setPlayerData', source, player.PlayerData)
        return true
    end
    player.Functions.GetMetaData = function(key) return character.metadata[key] end
    player.Functions.SetAppearance = function(value) return Node7.SetAppearance(source, value) end
    player.Functions.Save = function() return Node7.SavePlayer(source) end

    TriggerClientEvent('node7:client:setPlayerData', source, player.PlayerData)
    TriggerClientEvent('Node7:Player:SetPlayerData', source, player.PlayerData)
    return player.PlayerData
end

local function initializePlayer(source)
    local existing = Node7.Players[source]
    if existing then return existing end
    local identifiers = identifiersFor(source)
    if not identifiers.license then return nil, 'license_missing' end
    local userId = Node7Database.GetOrCreateUser(identifiers, GetPlayerName(source) or ('Player %s'):format(source))
    if not userId then return nil, 'database_error' end
    local player = {
        source = source,
        userId = userId,
        identifiers = identifiers,
        name = GetPlayerName(source),
        loaded = false,
        character = nil
    }
    Node7.Players[source] = player
    return player
end

function Node7.LoadCharacter(source, characterId)
    local player = Node7.Players[source]
    if not player then return false, 'player_missing' end

    local row = Node7Database.GetCharacter(player.userId, tonumber(characterId))
    if not row then return false, 'character_missing' end

    player.character = hydrate(row)
    player.loaded = true
    if Node7.GetItemCount and Node7.GetItemCount(source, 'identity_card') == 0 then
        Node7.AddItem(source, 'identity_card', 1, {
            characterId = player.character.id,
            firstName = player.character.firstName,
            lastName = player.character.lastName,
            dateOfBirth = player.character.dateOfBirth
        })
    end
    Node7.RefreshPlayerData(source, true)
    Player(source).state:set('node7CharacterId', player.character.id, true)
    Player(source).state:set('node7Loaded', true, true)
    TriggerClientEvent('node7:client:loaded', source, publicData(player))
    TriggerClientEvent('Node7:Client:OnPlayerLoaded', source)
    if Node7.Commands and Node7.Commands.Refresh then Node7.Commands.Refresh(source) end
    TriggerEvent('node7:server:playerLoaded', source, player)
    return true, publicData(player)
end

function Node7.SavePlayer(source)
    local player = Node7.Players[source]
    if not player or not player.character then return false end
    local ped = GetPlayerPed(source)
    if ped and ped > 0 then
        local coords = GetEntityCoords(ped)
        player.character.position = { x = coords.x, y = coords.y, z = coords.z, w = GetEntityHeading(ped) }
    end
    Node7Database.SaveCharacter(player.character)
    return true
end

function Node7.SetAppearance(source, appearance)
    source = tonumber(source)
    local player = source and Node7.Players[source]
    if not player or not player.character then return false, 'player_not_loaded' end
    if type(appearance) ~= 'table' then return false, 'invalid_appearance' end

    -- Copy through JSON so a resource cannot place functions, userdata, cyclic
    -- references, or oversized values inside persistent character data.
    local encodedOk, encoded = pcall(json.encode, appearance)
    if not encodedOk or type(encoded) ~= 'string' or #encoded > 100000 then
        return false, 'invalid_appearance'
    end
    local decodedOk, safeAppearance = pcall(json.decode, encoded)
    if not decodedOk or type(safeAppearance) ~= 'table' then
        return false, 'invalid_appearance'
    end

    player.character.appearance = safeAppearance
    local saved, saveResult = pcall(Node7Database.SaveCharacter, player.character)
    if not saved or saveResult == false then return false, 'database_error' end

    Node7.RefreshPlayerData(source, false)
    TriggerClientEvent('node7:client:appearanceChanged', source, safeAppearance)
    TriggerEvent('node7:server:appearanceChanged', source, player.character.id, safeAppearance)
    Node7.Log(player.identifiers.license, 'appearance_update', player.character.id, {})
    return true, 'success'
end

AddEventHandler('playerConnecting', function(name, _, deferrals)
    local source = source
    deferrals.defer()
    Wait(0)
    deferrals.update('NODE7 is validating your connection...')

    local identifiers = identifiersFor(source)
    if not identifiers.license then
        deferrals.done('NODE7 could not find a Rockstar license identifier.')
        return
    end

    local ok, userId = pcall(Node7Database.GetOrCreateUser, identifiers, name)
    if not ok or not userId then
        print(('^1[NODE7]^7 Connection database error for %s: %s'):format(name, userId or 'unknown'))
        deferrals.done('NODE7 could not load your account. Please try again.')
        return
    end

    Node7.Players[source] = { source = source, userId = userId, identifiers = identifiers,
        name = name, loaded = false, character = nil }
    deferrals.done()
end)

RegisterNetEvent('node7:server:requestCharacters', function()
    local source = source
    local player = Node7.Players[source] or initializePlayer(source)
    if not player then return end
    local characters = Node7Database.GetCharacters(player.userId)
    TriggerClientEvent('node7:client:characters', source, characters)
end)

Node7.RegisterCallback('characters:list', function(source, cb)
    local player = Node7.Players[source]
    cb(player and Node7Database.GetCharacters(player.userId) or {})
end)

Node7.RegisterCallback('characters:create', function(source, cb, data)
    local player = Node7.Players[source]
    if not player or type(data) ~= 'table' then cb(false, 'invalid_request') return end
    local characters = Node7Database.GetCharacters(player.userId)
    if #characters >= Node7Config.DefaultCharacterSlots then cb(false, 'slot_limit') return end

    local firstName = Node7.SanitizeText(data.firstName, 32)
    local lastName = Node7.SanitizeText(data.lastName, 32)
    if not firstName or not lastName then cb(false, 'invalid_name') return end
    data.firstName, data.lastName = firstName, lastName
    data.dateOfBirth = Node7.SanitizeText(data.dateOfBirth or 'Unknown', 20) or 'Unknown'
    data.sex = Node7.SanitizeText(data.sex or 'unknown', 16) or 'unknown'
    data.nationality = Node7.SanitizeText(data.nationality or 'American', 32) or 'American'
    data.biography = Node7.SanitizeText(data.biography or 'No biography provided.', 500) or ''

    local id = Node7Database.CreateCharacter(player.userId, data)
    Node7.Log(player.identifiers.license, 'character_create', id, { name = firstName .. ' ' .. lastName })
    cb(id ~= nil, id)
end)

Node7.RegisterCallback('characters:select', function(source, cb, characterId)
    cb(Node7.LoadCharacter(source, characterId))
end)

Node7.RegisterCallback('characters:delete', function(source, cb, characterId)
    local player = Node7.Players[source]
    if not player then cb(false) return end
    local result = Node7Database.DeleteCharacter(player.userId, tonumber(characterId))
    Node7.Log(player.identifiers.license, 'character_delete', characterId)
    cb(result and result > 0)
end)

RegisterNetEvent('node7:server:updateMetadata', function(key, value)
    local source = source
    local player = Node7.GetPlayer(source)
    if not player or not player.character or type(key) ~= 'string' or #key > 40 then return end
    player.character.metadata[key] = value
    Node7.RefreshPlayerData(source, false)
end)

AddEventHandler('playerDropped', function()
    local source = source
    if Node7.Players[source] then
        pcall(Node7.SavePlayer, source)
        TriggerEvent('node7:server:playerUnloaded', source, Node7.Players[source])
        Node7.Players[source] = nil
    end
end)

exports('SavePlayer', Node7.SavePlayer)
exports('LoadCharacter', Node7.LoadCharacter)
exports('RefreshPlayerData', Node7.RefreshPlayerData)
exports('SetAppearance', Node7.SetAppearance)
