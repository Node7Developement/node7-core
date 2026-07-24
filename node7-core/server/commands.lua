Node7Core.Commands = {}
Node7Core.Commands.List = {}
Node7Core.Commands.IgnoreList = { -- Ignore old perm levels while keeping backwards compatibility
    ['god'] = true,            -- We don't need to create an ace because god is allowed all commands
    ['user'] = true            -- We don't need to create an ace because builtin.everyone
}

CreateThread(function() -- Add ace to node for perm checking
    local permissions = Node7Core.Config.Server.Permissions
    for i = 1, #permissions do
        local permission = permissions[i]
        ExecuteCommand(('add_ace rsgcore.%s %s allow'):format(permission, permission))
    end
end)

-- Register & Refresh Commands

function Node7Core.Commands.Add(name, help, arguments, argsrequired, callback, permission, ...)
    local restricted = true                                  -- Default to restricted for all commands
    if not permission then permission = 'user' end           -- some commands don't pass permission level
    if permission == 'user' then restricted = false end      -- allow all users to use command

    RegisterCommand(name, function(source, args, rawCommand) -- Register command within fivem
        if argsrequired and #args < #arguments then
            return TriggerClientEvent('chat:addMessage', source, {
                color = { 255, 0, 0 },
                multiline = true,
                args = { 'System', Lang:t('error.missing_args2') }
            })
        end
        callback(source, args, rawCommand)
    end, restricted)

    local extraPerms = ... and table.pack(...) or nil
    if extraPerms then
        extraPerms[extraPerms.n + 1] = permission -- The `n` field is the number of arguments in the packed table
        extraPerms.n += 1
        permission = extraPerms
        for i = 1, permission.n do
            if not Node7Core.Commands.IgnoreList[permission[i]] then -- only create aces for extra perm levels
                ExecuteCommand(('add_ace rsgcore.%s command.%s allow'):format(permission[i], name))
            end
        end
        permission.n = nil
    else
        permission = tostring(permission:lower())
        if not Node7Core.Commands.IgnoreList[permission] then -- only create aces for extra perm levels
            ExecuteCommand(('add_ace rsgcore.%s command.%s allow'):format(permission, name))
        end
    end

    Node7Core.Commands.List[name:lower()] = {
        name = name:lower(),
        permission = permission,
        help = help,
        arguments = arguments,
        argsrequired = argsrequired,
        callback = callback
    }
end

function Node7Core.Commands.Refresh(source)
    local src = source
    local Player = Node7Core.Functions.GetPlayer(src)
    local suggestions = {}
    if Player then
        for command, info in pairs(Node7Core.Commands.List) do
            local hasPerm = IsPlayerAceAllowed(tostring(src), 'command.' .. command)
            if hasPerm then
                suggestions[#suggestions + 1] = {
                    name = '/' .. command,
                    help = info.help,
                    params = info.arguments
                }
            else
                TriggerClientEvent('chat:removeSuggestion', src, '/' .. command)
            end
        end
        TriggerClientEvent('chat:addSuggestions', src, suggestions)
    end
end

-- Teleport
Node7Core.Commands.Add('tp', Lang:t('command.tp.help'), { { name = Lang:t('command.tp.params.x.name'), help = Lang:t('command.tp.params.x.help') }, { name = Lang:t('command.tp.params.y.name'), help = Lang:t('command.tp.params.y.help') }, { name = Lang:t('command.tp.params.z.name'), help = Lang:t('command.tp.params.z.help') } }, false, function(source, args)
    if args[1] and not args[2] and not args[3] then
        if tonumber(args[1]) then
            local target = GetPlayerPed(tonumber(args[1]))
            if target ~= 0 then
                local coords = GetEntityCoords(target)
                TriggerClientEvent('Node7Core:Command:TeleportToPlayer', source, coords)
            else
                TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('error.not_online'), type = 'error', duration = 5000 })
            end
        else
            local location = Node7Shared.Locations[args[1]]
            if location then
                TriggerClientEvent('Node7Core:Command:TeleportToCoords', source, location.x, location.y, location.z, location.w)
            else
                TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('error.location_not_exist'), type = 'error', duration = 5000 })
            end
        end
    else
        if args[1] and args[2] and args[3] then
            local x = tonumber((args[1]:gsub(',', ''))) + .0
            local y = tonumber((args[2]:gsub(',', ''))) + .0
            local z = tonumber((args[3]:gsub(',', ''))) + .0
            if x ~= 0 and y ~= 0 and z ~= 0 then
                TriggerClientEvent('Node7Core:Command:TeleportToCoords', source, x, y, z)
            else
                TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('error.wrong_format'), type = 'error', duration = 5000 })
            end
        else
            TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('error.missing_args'), type = 'error', duration = 5000 })
        end
    end
end, 'admin')

Node7Core.Commands.Add('tpm', Lang:t('command.tpm.help'), {}, false, function(source)
    TriggerClientEvent('Node7Core:Command:GoToMarker', source)
end, 'admin')

Node7Core.Commands.Add('togglepvp', Lang:t('command.togglepvp.help'), {}, false, function()
    Node7Core.Config.Server.PVP = not Node7Core.Config.Server.PVP
    TriggerClientEvent('Node7Core:Client:PvpHasToggled', -1, Node7Core.Config.Server.PVP)
end, 'admin')

-- admin noclip
Node7Core.Commands.Add('noclip', Lang:t("command.noclip.help"), {}, false, function(source)
    TriggerClientEvent('Node7Core:Command:ToggleNoClip', source)
end, 'admin')

-- Permissions

Node7Core.Commands.Add('addpermission', Lang:t('command.addpermission.help'), { { name = Lang:t('command.addpermission.params.id.name'), help = Lang:t('command.addpermission.params.id.help') }, { name = Lang:t('command.addpermission.params.permission.name'), help = Lang:t('command.addpermission.params.permission.help') } }, true, function(source, args)
    local Player = Node7Core.Functions.GetPlayer(tonumber(args[1]))
    local permission = tostring(args[2]):lower()
    if Player then
        Node7Core.Functions.AddPermission(Player.PlayerData.source, permission)
    else
        TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('error.not_online'), type = 'error', duration = 5000 })
    end
end, 'god')

Node7Core.Commands.Add('removepermission', Lang:t('command.removepermission.help'), { { name = Lang:t('command.removepermission.params.id.name'), help = Lang:t('command.removepermission.params.id.help') }, { name = Lang:t('command.removepermission.params.permission.name'), help = Lang:t('command.removepermission.params.permission.help') } }, true, function(source, args)
    local Player = Node7Core.Functions.GetPlayer(tonumber(args[1]))
    local permission = tostring(args[2]):lower()
    if Player then
        Node7Core.Functions.RemovePermission(Player.PlayerData.source, permission)
    else
        TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('error.not_online'), type = 'error', duration = 5000 })
    end
end, 'god')

-- Open & Close Server

Node7Core.Commands.Add('openserver', Lang:t('command.openserver.help'), {}, false, function(source)
    if not Node7Core.Config.Server.Closed then
        TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('error.server_already_open'), type = 'error', duration = 5000 })
        return
    end
    if Node7Core.Functions.HasPermission(source, 'admin') then
        Node7Core.Config.Server.Closed = false
        TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('success.server_opened'), type = 'success', duration = 5000 })
    else
        Node7Core.Functions.Kick(source, Lang:t('error.no_permission'), nil, nil)
    end
end, 'admin')

Node7Core.Commands.Add('closeserver', Lang:t('command.closeserver.help'), { { name = Lang:t('command.closeserver.params.reason.name'), help = Lang:t('command.closeserver.params.reason.help') } }, false, function(source, args)
    if Node7Core.Config.Server.Closed then
        TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('error.server_already_closed'), type = 'error', duration = 5000 })
        return
    end
    if Node7Core.Functions.HasPermission(source, 'admin') then
        local reason = args[1] or 'No reason specified'
        Node7Core.Config.Server.Closed = true
        Node7Core.Config.Server.ClosedReason = reason
        for k in pairs(Node7Core.Players) do
            if not Node7Core.Functions.HasPermission(k, Node7Core.Config.Server.WhitelistPermission) then
                Node7Core.Functions.Kick(k, reason, nil, nil)
            end
        end
        TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('success.server_closed'), type = 'success', duration = 5000 })
    else
        Node7Core.Functions.Kick(source, Lang:t('error.no_permission'), nil, nil)
    end
end, 'admin')

-- Vehicle

Node7Core.Commands.Add('vehicle', Lang:t('command.car.help'), { { name = Lang:t('command.car.params.model.name'), help = Lang:t('command.car.params.model.help') } }, true, function(source, args)
    TriggerClientEvent('Node7Core:Command:SpawnVehicle', source, args[1])
end, 'admin')

Node7Core.Commands.Add('dv', Lang:t('command.dv.help'), {}, false, function(source)
    TriggerClientEvent('Node7Core:Command:DeleteVehicle', source)
end, 'admin')

Node7Core.Commands.Add('dvall', Lang:t('command.dvall.help'), {}, false, function()
    local vehicles = GetAllVehicles()
    for _, vehicle in ipairs(vehicles) do
        DeleteEntity(vehicle)
    end
end, 'admin')

-- Peds

Node7Core.Commands.Add('dvp', Lang:t('command.dvp.help'), {}, false, function()
    local peds = GetAllPeds()
    for _, ped in ipairs(peds) do
        DeleteEntity(ped)
    end
end, 'admin')

-- Objects

Node7Core.Commands.Add('dvo', Lang:t('command.dvo.help'), {}, false, function()
    local objects = GetAllObjects()
    for _, object in ipairs(objects) do
        DeleteEntity(object)
    end
end, 'admin')

-- Money

Node7Core.Commands.Add('givemoney', Lang:t('command.givemoney.help'), { { name = Lang:t('command.givemoney.params.id.name'), help = Lang:t('command.givemoney.params.id.help') }, { name = Lang:t('command.givemoney.params.moneytype.name'), help = Lang:t('command.givemoney.params.moneytype.help') }, { name = Lang:t('command.givemoney.params.amount.name'), help = Lang:t('command.givemoney.params.amount.help') } }, true, function(source, args)
    local Player = Node7Core.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.AddMoney(tostring(args[2]), tonumber(args[3]), 'Admin give money')
    else
        TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('error.not_online'), type = 'error', duration = 5000 })
    end
end, 'admin')

Node7Core.Commands.Add('setmoney', Lang:t('command.setmoney.help'), { { name = Lang:t('command.setmoney.params.id.name'), help = Lang:t('command.setmoney.params.id.help') }, { name = Lang:t('command.setmoney.params.moneytype.name'), help = Lang:t('command.setmoney.params.moneytype.help') }, { name = Lang:t('command.setmoney.params.amount.name'), help = Lang:t('command.setmoney.params.amount.help') } }, true, function(source, args)
    local Player = Node7Core.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.SetMoney(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('error.not_online'), type = 'error', duration = 5000 })
    end
end, 'admin')

-- Job

Node7Core.Commands.Add('job', Lang:t('command.job.help'), {}, false, function(source)
    local PlayerJob = Node7Core.Functions.GetPlayer(source).PlayerData.job
    TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('info.job_info', { value = PlayerJob.label, value2 = PlayerJob.grade.name, value3 = PlayerJob.onduty }), type = 'info', duration = 5000 })
end, 'user')

Node7Core.Commands.Add('setjob', Lang:t('command.setjob.help'), { { name = Lang:t('command.setjob.params.id.name'), help = Lang:t('command.setjob.params.id.help') }, { name = Lang:t('command.setjob.params.job.name'), help = Lang:t('command.setjob.params.job.help') }, { name = Lang:t('command.setjob.params.grade.name'), help = Lang:t('command.setjob.params.grade.help') } }, true, function(source, args)
    local Player = Node7Core.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        local job = tostring(args[2])
        local grade = tonumber(args[3])
        if not Node7Core.Shared.Jobs[job] then
            TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('error.job_not_exist'), type = 'error', duration = 5000 })
            return
        end
        if GetResourceState('node7-multijob') == 'started' then
            exports['node7-multijob']:AddJobToPlayer(Player.PlayerData.citizenid, job, grade)
        end
        Player.Functions.SetJob(job, grade)
        TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('success.job_set'), type = 'success', duration = 5000 })
    else
        TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('error.not_online'), type = 'error', duration = 5000 })
    end
end, 'admin')

-- Gang

Node7Core.Commands.Add('gang', Lang:t('command.gang.help'), {}, false, function(source)
    local PlayerGang = Node7Core.Functions.GetPlayer(source).PlayerData.gang
    TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('info.gang_info', { value = PlayerGang.label, value2 = PlayerGang.grade.name }), type = 'info', duration = 5000 })
end, 'user')

Node7Core.Commands.Add('setgang', Lang:t('command.setgang.help'), { { name = Lang:t('command.setgang.params.id.name'), help = Lang:t('command.setgang.params.id.help') }, { name = Lang:t('command.setgang.params.gang.name'), help = Lang:t('command.setgang.params.gang.help') }, { name = Lang:t('command.setgang.params.grade.name'), help = Lang:t('command.setgang.params.grade.help') } }, true, function(source, args)
    local Player = Node7Core.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        if Player.Functions.SetGang(tostring(args[2]), tonumber(args[3])) then
            TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('success.gang_set'), type = 'success', duration = 5000 })
        else
            TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('error.gang_not_exist'), type = 'error', duration = 5000 })
        end
    else
        TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('error.not_online'), type = 'error', duration = 5000 })
    end
end, 'admin')

-- Out of Character Chat
Node7Core.Commands.Add('ooc', Lang:t('command.ooc.help'), {}, false, function(source, args)
    local message = table.concat(args, ' ')
    local Players = Node7Core.Functions.GetPlayers()
    local Player = Node7Core.Functions.GetPlayer(source)
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    for _, v in pairs(Players) do
        if v == source then
            TriggerClientEvent('chat:addMessage', v, {
                color = Node7Core.Config.Commands.OOCColor,
                multiline = true,
                args = { 'OOC | ' .. GetPlayerName(source), message }
            })
        elseif #(playerCoords - GetEntityCoords(GetPlayerPed(v))) < 20.0 then
            TriggerClientEvent('chat:addMessage', v, {
                color = Node7Core.Config.Commands.OOCColor,
                multiline = true,
                args = { 'OOC | ' .. GetPlayerName(source), message }
            })
        elseif Node7Core.Functions.HasPermission(v, 'admin') then
            if Node7Core.Functions.IsOptin(v) then
                TriggerClientEvent('chat:addMessage', v, {
                    color = Node7Core.Config.Commands.OOCColor,
                    multiline = true,
                    args = { 'Proximity OOC | ' .. GetPlayerName(source), message }
                })
                TriggerEvent('node7-log:server:CreateLog', 'ooc', 'OOC', 'white', '**' .. GetPlayerName(source) .. '** (CitizenID: ' .. Player.PlayerData.citizenid .. ' | ID: ' .. source .. ') **Message:** ' .. message, false)
            end
        end
    end
end, 'user')

-- Me command

Node7Core.Commands.Add('me', Lang:t('command.me.help'), { { name = Lang:t('command.me.params.message.name'), help = Lang:t('command.me.params.message.help') } }, false, function(source, args)
    if #args < 1 then
        TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('error.missing_args2'), type = 'error', duration = 5000 })
        return
    end
    local ped = GetPlayerPed(source)
    local pCoords = GetEntityCoords(ped)
    local msg = table.concat(args, ' '):gsub('[~<].-[>~]', '')
    local Players = Node7Core.Functions.GetPlayers()
    for i = 1, #Players do
        local Player = Players[i]
        local target = GetPlayerPed(Player)
        local tCoords = GetEntityCoords(target)
        if target == ped or #(pCoords - tCoords) < 20 then
            TriggerClientEvent('Node7Core:Command:ShowMe3D', Player, source, msg)
        end
    end
end, 'user')

-- ids
Node7Core.Commands.Add('id', 'Check Your ID #', {}, false, function(source)
    local src = source
    local Player = Node7Core.Functions.GetPlayer(src)
    TriggerClientEvent('ox_lib:notify', source, {title = 'ID: '..source, type = 'info', duration = 5000 })
end, 'user')

Node7Core.Commands.Add('cid', 'Check Your Citizen ID #', {}, false, function(source)
    local src = source
    local Player = Node7Core.Functions.GetPlayer(src)
    local Playercid = Player.PlayerData.citizenid
    TriggerClientEvent('ox_lib:notify', source, {title = 'Citizen ID: '..Playercid, type = 'info', duration = 5000 })
end, 'user')
