local function copyTable(value)
    if type(value) ~= 'table' then return value end
    local output = {}
    for k, v in pairs(value) do output[k] = copyTable(v) end
    return output
end

local function normalizeExternalPlayer(source, data)
    data = type(data) == 'table' and copyTable(data.PlayerData or data) or {}
    data.source = tonumber(source)
    data.license = data.license or Node7Core.Functions.GetIdentifier(source, 'license')
    data.name = data.name or GetPlayerName(source) or 'Unknown'
    data.cid = tonumber(data.cid or data.slot or 1) or 1
    data.slot = tonumber(data.slot or data.cid or 1) or 1
    data.charinfo = type(data.charinfo) == 'table' and data.charinfo or {}
    data.money = type(data.money) == 'table' and data.money or nil
    data.job = type(data.job) == 'table' and data.job or nil
    data.gang = type(data.gang) == 'table' and data.gang or nil
    data.metadata = type(data.metadata) == 'table' and data.metadata or nil
    data.position = data.position or Node7Core.Config.DefaultSpawn
    return data
end

local function refreshPlayerData(source, includeInventory, sendClient)
    local Player = Node7Core.Functions.GetPlayer(tonumber(source))
    if not Player then return nil end
    if includeInventory and GetResourceState('node7-inventory') == 'started' then
        local ok, items = pcall(function()
            return exports['node7-inventory']:LoadInventory(source, Player.PlayerData.citizenid)
        end)
        if ok and items then Player.PlayerData.items = items end
    end
    if sendClient ~= false and Player.Functions and Player.Functions.UpdatePlayerData then
        Player.Functions.UpdatePlayerData()
    end
    return Player.PlayerData
end

exports('RegisterExternalPlayer', function(source, playerData)
    source = tonumber(source)
    if not source then return false, 'invalid_source' end
    local normalized = normalizeExternalPlayer(source, playerData)
    local player = Node7Core.Player.CheckPlayerData(source, normalized)
    return player or false, player and player.PlayerData or 'register_failed'
end)

exports('UnloadExternalPlayer', function(source)
    source = tonumber(source)
    if not source or not Node7Core.Players[source] then return false end
    Node7Core.Player.Logout(source)
    return true
end)

exports('RefreshPlayerData', refreshPlayerData)

exports('SetAppearance', function(source, appearance)
    local Player = Node7Core.Functions.GetPlayer(source)
    if not Player then return false, 'not_loaded' end
    Player.PlayerData.appearance = type(appearance) == 'table' and appearance or {}
    Player.Functions.UpdatePlayerData()
    return true, Player.PlayerData.appearance
end)

exports('SetMetaData', function(source, key, value)
    local Player = Node7Core.Functions.GetPlayer(source)
    if not Player then return false, 'not_loaded' end
    Player.Functions.SetMetaData(key, value)
    return true
end)

exports('SetJob', function(source, name, grade)
    local Player = Node7Core.Functions.GetPlayer(source)
    if not Player then return false, 'not_loaded' end
    local ok = Player.Functions.SetJob(name, grade or 0)
    return ok == true, ok == true and Player.PlayerData.job or 'invalid_job'
end)

exports('SetGang', function(source, name, grade)
    local Player = Node7Core.Functions.GetPlayer(source)
    if not Player then return false, 'not_loaded' end
    local ok = Player.Functions.SetGang(name, grade or 0)
    return ok == true, ok == true and Player.PlayerData.gang or 'invalid_gang'
end)

exports('SetDuty', function(source, state)
    local Player = Node7Core.Functions.GetPlayer(source)
    if not Player then return false, 'not_loaded' end
    Player.Functions.SetJobDuty(state == true)
    return true, Player.PlayerData.job
end)

exports('GetMoney', function(source, account)
    local Player = Node7Core.Functions.GetPlayer(source)
    if not Player then return 0 end
    return Player.Functions.GetMoney(account or 'cash') or 0
end)

exports('AddMoney', function(source, account, amount, reason)
    local Player = Node7Core.Functions.GetPlayer(source)
    if not Player then return false, 'not_loaded' end
    local success, result = Player.Functions.AddMoney(account or 'cash', amount or 0, reason)
    return success, result, Player.PlayerData.money
end)

exports('RemoveMoney', function(source, account, amount, reason)
    local Player = Node7Core.Functions.GetPlayer(source)
    if not Player then return false, 'not_loaded' end
    local success, result = Player.Functions.RemoveMoney(account or 'cash', amount or 0, reason)
    return success, result, Player.PlayerData.money
end)

exports('SetMoney', function(source, account, amount, reason)
    local Player = Node7Core.Functions.GetPlayer(source)
    if not Player then return false, 'not_loaded' end
    local success, result = Player.Functions.SetMoney(account or 'cash', amount or 0, reason)
    return success, result, Player.PlayerData.money
end)

exports('GiveItem', function(source, item, amount, metadata, slot)
    if GetResourceState('node7-inventory') ~= 'started' then return false, 'inventory_not_started' end
    local ok, result = pcall(function()
        return exports['node7-inventory']:AddItem(source, item, amount or 1, slot, metadata)
    end)
    if ok then return result end
    return false, result
end)

exports('RemovePlayerItem', function(source, item, amount, slot)
    if GetResourceState('node7-inventory') ~= 'started' then return false, 'inventory_not_started' end
    local ok, result = pcall(function()
        return exports['node7-inventory']:RemoveItem(source, item, amount or 1, slot)
    end)
    if ok then return result end
    return false, result
end)

-- old node7-players calls this name
exports('RemoveItem', function(source, item, amount, slot)
    if GetResourceState('node7-inventory') ~= 'started' then return false, 'inventory_not_started' end
    local ok, result = pcall(function()
        return exports['node7-inventory']:RemoveItem(source, item, amount or 1, slot)
    end)
    if ok then return result end
    return false, result
end)

exports('GetNode7Players', function()
    return Node7Core.Players
end)

exports('GetCore', function()
    return Node7Core
end)

RegisterNetEvent('node7:server:updateObject', function()
    TriggerClientEvent('Node7Core:Client:UpdateObject', source)
end)

RegisterNetEvent('node7:server:externalPlayerDataChanged', function()
    refreshPlayerData(source, false, true)
end)
