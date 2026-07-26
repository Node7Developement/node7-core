-- Event Handler

AddEventHandler('chatMessage', function(_, _, message)
    if string.sub(message, 1, 1) == '/' then
        CancelEvent()
        return
    end
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    if not Node7Core.Players[src] then return end
    local Player = Node7Core.Players[src]
    TriggerEvent('node7-log:server:CreateLog', 'joinleave', 'Dropped', 'red', '**' .. GetPlayerName(src) .. '** (' .. Player.PlayerData.license .. ') left..' .. '\n **Reason:** ' .. reason)
    TriggerEvent('Node7Core:Server:PlayerDropped', Player)
    Player.Functions.Save()
    Node7Core.Player_Buckets[Player.PlayerData.license] = nil
    Node7Core.Players[src] = nil
end)

local readyFunction = MySQL.ready
local databaseConnected, bansTableExists = readyFunction == nil, readyFunction == nil
if readyFunction ~= nil then
    MySQL.ready(function()
        databaseConnected = true
    
        local DatabaseInfo = Node7Core.Functions.GetDatabaseInfo()
        if not DatabaseInfo or not DatabaseInfo.exists then return end

        local result = MySQL.query.await('SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = ? AND TABLE_NAME = "bans";', {DatabaseInfo.database})
        if result and result[1] then
            bansTableExists = true
        end
        
        local resultColumns = MySQL.query.await('SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = ? AND TABLE_NAME = "players" AND COLUMN_NAME IN ("weight", "slots");', {DatabaseInfo.database})
        local columnsExist = {}
        if resultColumns then
            for _, column in ipairs(resultColumns) do
            columnsExist[column.COLUMN_NAME] = true
            end
        end

        if not columnsExist["weight"] or not columnsExist["slots"] then
            MySQL.query.await('ALTER TABLE players ADD COLUMN weight INT DEFAULT '..Node7Core.Config.Player.PlayerDefaults.weight..';')
            MySQL.query.await('ALTER TABLE players ADD COLUMN slots INT DEFAULT '..Node7Core.Config.Player.PlayerDefaults.slots..';')
            Node7Core.ShowSuccess(GetCurrentResourceName(), 'Added weight and slots columns to players table')
        end
    end)
end

-- Player Connecting
local function onPlayerConnecting(name, _, deferrals)
    local src = source
    deferrals.defer()

    if Node7Core.Config.Server.Closed and not IsPlayerAceAllowed(src, 'node7admin.join') then
        return deferrals.done(Node7Core.Config.Server.ClosedReason)
    end

    if not databaseConnected then
        return deferrals.done(Lang:t('error.connecting_database_error'))
    end

    if Node7Core.Config.Server.Whitelist then
        Wait(0)
        deferrals.update(string.format(Lang:t('info.checking_whitelisted'), name))
        if not Node7Core.Functions.IsWhitelisted(src) then
            return deferrals.done(Lang:t('error.not_whitelisted'))
        end
    end

    Wait(0)
    deferrals.update(string.format('Hello %s. Your license is being checked', name))
    local license = Node7Core.Functions.GetIdentifier(src, 'license')

    if not license then
        return deferrals.done(Lang:t('error.no_valid_license'))
    elseif Node7Core.Config.Server.CheckDuplicateLicense and Node7Core.Functions.IsLicenseInUse(license) then
        return deferrals.done(Lang:t('error.duplicate_license'))
    end

    Wait(0)
    deferrals.update(string.format(Lang:t('info.checking_ban'), name))

    if not bansTableExists then
        return deferrals.done(Lang:t('error.ban_table_not_found'))
    end

    local success, isBanned, reason = pcall(Node7Core.Functions.IsPlayerBanned, src)
    if not success then return deferrals.done(Lang:t('error.connecting_database_error')) end
    if isBanned then return deferrals.done(reason) end

    Wait(0)
    deferrals.update(string.format(Lang:t('info.join_server'), name))
    deferrals.done()

    TriggerClientEvent('Node7Core:Client:SharedUpdate', src, Node7Core.Shared)
end

AddEventHandler('playerConnecting', onPlayerConnecting)

-- Open & Close Server (prevents players from joining)

RegisterNetEvent('Node7Core:Server:CloseServer', function(reason)
    local src = source
    if Node7Core.Functions.HasPermission(src, 'admin') then
        reason = reason or 'No reason specified'
        Node7Core.Config.Server.Closed = true
        Node7Core.Config.Server.ClosedReason = reason
        for k in pairs(Node7Core.Players) do
            if not Node7Core.Functions.HasPermission(k, Node7Core.Config.Server.WhitelistPermission) then
                Node7Core.Functions.Kick(k, reason, nil, nil)
            end
        end
    else
        Node7Core.Functions.Kick(src, Lang:t('error.no_permission'), nil, nil)
    end
end)

RegisterNetEvent('Node7Core:Server:OpenServer', function()
    local src = source
    if Node7Core.Functions.HasPermission(src, 'admin') then
        Node7Core.Config.Server.Closed = false
    else
        Node7Core.Functions.Kick(src, Lang:t('error.no_permission'), nil, nil)
    end
end)

-- Callback Events --

-- Client Callback response
RegisterNetEvent('Node7Core:Server:TriggerClientCallback', function(name, ...)
    local callbackKey = name .. ':' .. source
    local request = Node7Core.ClientCallbacks[callbackKey]
    if not request then return end

    request.promise:resolve(...)
    if request.callback then request.callback(...) end
    Node7Core.ClientCallbacks[callbackKey] = nil
end)

-- Server Callback request
RegisterNetEvent('Node7Core:Server:TriggerCallback', function(name, ...)
    local handler = Node7Core.ServerCallbacks[name]
    if not handler then return end

    local src = source
    handler(src, function(...)
        TriggerClientEvent('Node7Core:Client:TriggerCallback', src, name, ...)
    end, ...)
end)

-- Player

RegisterNetEvent('Node7Core:UpdatePlayer', function()
    local src = source
    local Player = Node7Core.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.Save()
end)

RegisterNetEvent('Node7Core:Server:SetMetaData', function(meta, data)
    local src = source
    if not meta then return end
    local Player = Node7Core.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.SetMetaData(meta, data)
end)

RegisterNetEvent('Node7Core:ToggleDuty', function()
    local src = source
    local Player = Node7Core.Functions.GetPlayer(src)
    if not Player then return end
    if Player.PlayerData.job.onduty then
        Player.Functions.SetJobDuty(false)
        Node7Core.Functions.Notify(src, {title = Lang:t('info.off_duty'), type = 'info', duration = 5000 })
    else
        Player.Functions.SetJobDuty(true)
        Node7Core.Functions.Notify(src, {title = Lang:t('info.on_duty'), type = 'info', duration = 5000 })
    end

    TriggerEvent('Node7Core:Server:SetDuty', src, Player.PlayerData.job.onduty)
    TriggerClientEvent('Node7Core:Client:SetDuty', src, Player.PlayerData.job.onduty)
end)

-- Items

-- This event is exploitable and should not be used. It has been deprecated, and will be removed soon.
RegisterNetEvent('Node7Core:Server:UseItem', function(item)
    print(string.format('%s triggered Node7Core:Server:UseItem by ID %s with the following data. This event is deprecated due to exploitation, and will be removed soon. Check node7-inventory for the right use on this event.', GetInvokingResource(), source))
    Node7Core.Debug(item)
end)

-- This event is exploitable and should not be used. It has been deprecated, and will be removed soon. function(itemName, amount, slot)
RegisterNetEvent('Node7Core:Server:RemoveItem', function(itemName, amount)
    local src = source
    print(string.format('%s triggered Node7Core:Server:RemoveItem by ID %s for %s %s. This event is deprecated due to exploitation, and will be removed soon. Adjust your events accordingly to do this server side with player functions.', GetInvokingResource(), src, amount, itemName))
end)

-- This event is exploitable and should not be used. It has been deprecated, and will be removed soon. function(itemName, amount, slot, info)
RegisterNetEvent('Node7Core:Server:AddItem', function(itemName, amount)
    local src = source
    print(string.format('%s triggered Node7Core:Server:AddItem by ID %s for %s %s. This event is deprecated due to exploitation, and will be removed soon. Adjust your events accordingly to do this server side with player functions.', GetInvokingResource(), src, amount, itemName))
end)

-- Non-Chat Command Calling (ex: node7-adminmenu)

RegisterNetEvent('Node7Core:CallCommand', function(command, args)
    local src = source
    if not Node7Core.Commands.List[command] then return end
    local Player = Node7Core.Functions.GetPlayer(src)
    if not Player then return end
    local hasPerm = Node7Core.Functions.HasPermission(src, 'command.' .. Node7Core.Commands.List[command].name)
    if hasPerm then
        if Node7Core.Commands.List[command].argsrequired and #Node7Core.Commands.List[command].arguments ~= 0 and not args[#Node7Core.Commands.List[command].arguments] then
            Node7Core.Functions.Notify(src, {title = Lang:t('error.missing_args2'), type = 'error', duration = 5000 })
        else
            Node7Core.Commands.List[command].callback(src, args)
        end
    else
        Node7Core.Functions.Notify(src, {title = Lang:t('error.no_access'), type = 'error', duration = 5000 })
    end
end)

-- Use this for player vehicle spawning
-- Vehicle server-side spawning callback (netId)
-- use the netid on the client with the NetworkGetEntityFromNetworkId native
-- convert it to a vehicle via the NetToVeh native
Node7Core.Functions.CreateCallback('Node7Core:Server:SpawnVehicle', function(source, cb, model, coords, warp)
    local veh = Node7Core.Functions.SpawnVehicle(source, model, coords, warp)
    cb(NetworkGetNetworkIdFromEntity(veh))
end)

RegisterNetEvent('Node7Core:Server:KickCSRF', function()
    DropPlayer(source, 'CSRF validation failed')
end)