local function broadcast(category, key, value)
    TriggerClientEvent('node7:client:onSharedUpdate', -1, category, key, value)
    TriggerClientEvent('Node7:Client:OnSharedUpdate', -1, category, key, value)
    TriggerEvent('node7:server:sharedUpdated', category, key, value)
end

local function broadcastMultiple(category, values)
    TriggerClientEvent('node7:client:onSharedUpdateMultiple', -1, category, values)
    TriggerClientEvent('Node7:Client:OnSharedUpdateMultiple', -1, category, values)
    TriggerEvent('node7:server:sharedUpdatedMultiple', category, values)
end

local function addMultiple(values, registry, normalizer, category)
    if type(values) ~= 'table' then return false, 'invalid_collection' end
    local staged = {}
    for name, definition in pairs(values) do
        if type(name) ~= 'string' then return false, 'invalid_name', definition end
        if registry[name] then return false, category:lower() .. '_exists', definition end
        local ok, normalized = pcall(normalizer, name, definition)
        if not ok then return false, normalized, definition end
        staged[name] = normalized
    end
    for name, definition in pairs(staged) do registry[name] = definition end
    broadcastMultiple(category, staged)
    return true, 'success'
end

exports('GetCoreObject', function() return Node7 end)
exports('GetSharedObject', function() return Node7Shared end)
exports('GetItems', function() return Node7Shared.Items end)
exports('GetItem', function(name) return Node7Shared.Items[name] end)
exports('GetJobs', function() return Node7Shared.Jobs end)
exports('GetGangs', function() return Node7Shared.Gangs end)
exports('GetHorses', function() return Node7Shared.Horses end)
exports('GetVehicles', function() return Node7Shared.Vehicles end)
exports('GetWeapons', function() return Node7Shared.Weapons end)
exports('GetWeaponsByName', function() return Node7Shared.WeaponsByName end)
exports('GetAmmoTypes', function() return Node7Shared.AmmoTypes end)

exports('RandomStr', Node7Shared.RandomStr)
exports('RandomInt', Node7Shared.RandomInt)
exports('SplitStr', Node7Shared.SplitStr)
exports('Trim', Node7Shared.Trim)
exports('Round', Node7Shared.Round)

exports('GetPlayers', function()
    local sources = {}
    for source in pairs(Node7.Players) do sources[#sources + 1] = source end
    return sources
end)

exports('GetNode7Players', function() return Node7.Players end)
exports('GetPlayerByCitizenId', function(citizenId)
    for _, player in pairs(Node7.Players) do
        if player.PlayerData and player.PlayerData.citizenid == citizenId then return player end
    end
end)

exports('GetPlayersOnDuty', function(jobName)
    local players = {}
    for source, player in pairs(Node7.Players) do
        if player.PlayerData and player.PlayerData.job.name == jobName and player.PlayerData.job.onduty then
            players[#players + 1] = source
        end
    end
    return players, #players
end)

exports('GetDutyCount', function(jobName)
    local count = 0
    for _, player in pairs(Node7.Players) do
        if player.PlayerData and player.PlayerData.job.name == jobName and player.PlayerData.job.onduty then count = count + 1 end
    end
    return count
end)

exports('CreateCallback', Node7.RegisterCallback)
exports('CreateUseableItem', Node7.RegisterUsableItem)
exports('CanUseItem', function(itemName) return Node7.UsableItems[itemName] end)
exports('GetPermissions', function(source)
    local permissions = {}
    for name, permission in pairs(Node7Config.Permissions) do permissions[name] = Node7.HasPermission(source, permission) end
    return permissions
end)

exports('AddItem', function(name, definition)
    local ok, result = Node7.RegisterItem(name, definition)
    if ok then broadcast('Items', name, result) end
    return ok, ok and 'success' or result
end)

exports('AddItems', function(items)
    return addMultiple(items, Node7Items, Node7NormalizeItemDefinition, 'Items')
end)

exports('AddJob', function(name, definition)
    local ok, result = Node7.RegisterJob(name, definition)
    if ok then broadcast('Jobs', name, result) end
    return ok, ok and 'success' or result
end)

exports('AddJobs', function(jobs)
    return addMultiple(jobs, Node7Jobs, Node7NormalizeJobDefinition, 'Jobs')
end)

exports('AddGang', function(name, definition)
    local ok, result = Node7.RegisterGang(name, definition)
    if ok then broadcast('Gangs', name, result) end
    return ok, ok and 'success' or result
end)

exports('AddGangs', function(gangs)
    return addMultiple(gangs, Node7Gangs, Node7NormalizeGangDefinition, 'Gangs')
end)

exports('AddHorse', function(name, definition)
    if Node7HorseModels[name] then return false, 'horse_exists' end
    local ok, normalized = pcall(Node7NormalizeHorseDefinition, name, definition)
    if not ok then return false, normalized end
    Node7HorseModels[name] = normalized
    broadcast('Horses', name, normalized)
    return true, 'success'
end)

exports('AddHorses', function(horses)
    return addMultiple(horses, Node7HorseModels, Node7NormalizeHorseDefinition, 'Horses')
end)

exports('AddVehicle', function(name, definition)
    if Node7WagonModels[name] then return false, 'vehicle_exists' end
    local ok, normalized = pcall(Node7NormalizeWagonDefinition, name, definition)
    if not ok then return false, normalized end
    Node7WagonModels[name] = normalized
    broadcast('Vehicles', name, normalized)
    return true, 'success'
end)

exports('AddVehicles', function(vehicles)
    return addMultiple(vehicles, Node7WagonModels, Node7NormalizeWagonDefinition, 'Vehicles')
end)

RegisterNetEvent('node7:server:updateObject', function()
    TriggerClientEvent('node7:client:updateObject', source)
end)

RegisterNetEvent('Node7:Server:UpdateObject', function()
    TriggerClientEvent('node7:client:updateObject', source)
end)
