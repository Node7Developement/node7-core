Node7Core.Commands = {}
Node7Core.Commands.List = {}
Node7Core.Commands.IgnoreList = { -- Ignore old perm levels while keeping backwards compatibility
    ['god'] = true,            -- We don't need to create an ace because god is allowed all commands
    ['user'] = true            -- We don't need to create an ace because builtin.everyone
}

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
        extraPerms[extraPerms.n + 1] = permission
        extraPerms.n += 1
        permission = extraPerms
        permission.n = nil
    else
        permission = tostring(permission:lower())
    end

    -- ACEs are intentionally declared in server.cfg/recipe/permissions.cfg.
    -- Resources must not execute add_ace during runtime.

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
            local hasPerm = info.permission == 'user' or IsPlayerAceAllowed(tostring(src), 'command.' .. command)
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
                Node7Core.Functions.Notify(source, {title = Lang:t('error.not_online'), type = 'error', duration = 5000 })
            end
        else
            local location = Node7Shared.Locations[args[1]]
            if location then
                TriggerClientEvent('Node7Core:Command:TeleportToCoords', source, location.x, location.y, location.z, location.w)
            else
                Node7Core.Functions.Notify(source, {title = Lang:t('error.location_not_exist'), type = 'error', duration = 5000 })
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
                Node7Core.Functions.Notify(source, {title = Lang:t('error.wrong_format'), type = 'error', duration = 5000 })
            end
        else
            Node7Core.Functions.Notify(source, {title = Lang:t('error.missing_args'), type = 'error', duration = 5000 })
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
        Node7Core.Functions.Notify(source, {title = Lang:t('error.not_online'), type = 'error', duration = 5000 })
    end
end, 'god')

Node7Core.Commands.Add('removepermission', Lang:t('command.removepermission.help'), { { name = Lang:t('command.removepermission.params.id.name'), help = Lang:t('command.removepermission.params.id.help') }, { name = Lang:t('command.removepermission.params.permission.name'), help = Lang:t('command.removepermission.params.permission.help') } }, true, function(source, args)
    local Player = Node7Core.Functions.GetPlayer(tonumber(args[1]))
    local permission = tostring(args[2]):lower()
    if Player then
        Node7Core.Functions.RemovePermission(Player.PlayerData.source, permission)
    else
        Node7Core.Functions.Notify(source, {title = Lang:t('error.not_online'), type = 'error', duration = 5000 })
    end
end, 'god')

-- Open & Close Server

Node7Core.Commands.Add('openserver', Lang:t('command.openserver.help'), {}, false, function(source)
    if not Node7Core.Config.Server.Closed then
        Node7Core.Functions.Notify(source, {title = Lang:t('error.server_already_open'), type = 'error', duration = 5000 })
        return
    end
    if Node7Core.Functions.HasPermission(source, 'admin') then
        Node7Core.Config.Server.Closed = false
        Node7Core.Functions.Notify(source, {title = Lang:t('success.server_opened'), type = 'success', duration = 5000 })
    else
        Node7Core.Functions.Kick(source, Lang:t('error.no_permission'), nil, nil)
    end
end, 'admin')

Node7Core.Commands.Add('closeserver', Lang:t('command.closeserver.help'), { { name = Lang:t('command.closeserver.params.reason.name'), help = Lang:t('command.closeserver.params.reason.help') } }, false, function(source, args)
    if Node7Core.Config.Server.Closed then
        Node7Core.Functions.Notify(source, {title = Lang:t('error.server_already_closed'), type = 'error', duration = 5000 })
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
        Node7Core.Functions.Notify(source, {title = Lang:t('success.server_closed'), type = 'success', duration = 5000 })
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

local validAdminMoneyAccounts = {
    cash = true,
    bank = true,
    gold = true,
    bloodmoney = true,
}

local function adminMoneyAccount(value)
    local account = tostring(value or ''):lower()
    account = (Node7Core.Config.Money.AccountAliases or {})[account] or account
    if not validAdminMoneyAccounts[account] or Node7Core.Config.Money.MoneyTypes[account] == nil then
        return nil
    end
    return account
end

local function adminMoneyAmount(value, allowZero)
    local amount = tonumber(value)
    if not amount or amount ~= amount or amount == math.huge or amount == -math.huge then return nil end
    amount = tonumber(string.format('%.2f', amount))
    if amount < 0 or (not allowZero and amount == 0) then return nil end
    if amount > (tonumber(Node7Core.Config.Money.MaxTransactionAmount) or 100000000) then return nil end
    return amount
end

local function commandReason(args, firstIndex, fallback)
    if #args < firstIndex then return fallback end
    local reason = table.concat(args, ' ', firstIndex)
    reason = reason:gsub('^%s+', ''):gsub('%s+$', '')
    return reason ~= '' and reason or fallback
end

local function moneyCommandFailure(source, description)
    Node7Core.Functions.Notify(source, {
        title = 'MONEY COMMAND FAILED',
        description = description,
        type = 'error',
        duration = 6000,
    })
end

local function moneyCommandSuccess(source, target, action, account, amount, balance)
    local targetName = target.Functions.GetName()
    Node7Core.Functions.Notify(source, {
        title = 'MONEY UPDATED',
        description = ('%s %s %.2f for %s. Balance: %.2f'):format(action, account:upper(), amount, targetName, balance),
        type = 'success',
        duration = 6000,
    })

    if source ~= target.PlayerData.source then
        Node7Core.Functions.Notify(target.PlayerData.source, {
            title = 'ACCOUNT UPDATED',
            description = ('Your %s balance is now %.2f.'):format(account:upper(), balance),
            type = 'money',
            duration = 6000,
        })
    end
end

Node7Core.Commands.Add('givemoney', 'Give money to an online character.', {
    { name = 'id', help = 'Player server ID' },
    { name = 'account', help = 'cash, bank, gold, or bloodmoney' },
    { name = 'amount', help = 'Amount greater than zero' },
}, true, function(source, args)
    local target = Node7Core.Functions.GetPlayer(tonumber(args[1]))
    local account = adminMoneyAccount(args[2])
    local amount = adminMoneyAmount(args[3], false)
    if not target then return moneyCommandFailure(source, 'That player is not online.') end
    if not account then return moneyCommandFailure(source, 'Use cash, bank, gold, or bloodmoney.') end
    if not amount then return moneyCommandFailure(source, 'Enter a valid positive amount.') end

    local reason = commandReason(args, 4, ('Admin give by %s'):format(source))
    local success, balance = target.Functions.AddMoney(account, amount, reason)
    if not success then return moneyCommandFailure(source, tostring(balance or 'Unable to add money.')) end
    moneyCommandSuccess(source, target, 'Gave', account, amount, balance)
end, 'admin')

Node7Core.Commands.Add('setmoney', 'Set an online character account balance.', {
    { name = 'id', help = 'Player server ID' },
    { name = 'account', help = 'cash, bank, gold, or bloodmoney' },
    { name = 'amount', help = 'New balance, including zero' },
}, true, function(source, args)
    local target = Node7Core.Functions.GetPlayer(tonumber(args[1]))
    local account = adminMoneyAccount(args[2])
    local amount = adminMoneyAmount(args[3], true)
    if not target then return moneyCommandFailure(source, 'That player is not online.') end
    if not account then return moneyCommandFailure(source, 'Use cash, bank, gold, or bloodmoney.') end
    if amount == nil then return moneyCommandFailure(source, 'Enter a valid balance of zero or greater.') end

    local reason = commandReason(args, 4, ('Admin set by %s'):format(source))
    local success, balance = target.Functions.SetMoney(account, amount, reason)
    if not success then return moneyCommandFailure(source, tostring(balance or 'Unable to set money.')) end
    moneyCommandSuccess(source, target, 'Set', account, amount, balance)
end, 'admin')

Node7Core.Commands.Add('removemoney', 'Remove money from an online character.', {
    { name = 'id', help = 'Player server ID' },
    { name = 'account', help = 'cash, bank, gold, or bloodmoney' },
    { name = 'amount', help = 'Amount greater than zero' },
}, true, function(source, args)
    local target = Node7Core.Functions.GetPlayer(tonumber(args[1]))
    local account = adminMoneyAccount(args[2])
    local amount = adminMoneyAmount(args[3], false)
    if not target then return moneyCommandFailure(source, 'That player is not online.') end
    if not account then return moneyCommandFailure(source, 'Use cash, bank, gold, or bloodmoney.') end
    if not amount then return moneyCommandFailure(source, 'Enter a valid positive amount.') end

    local reason = commandReason(args, 4, ('Admin remove by %s'):format(source))
    local success, balance = target.Functions.RemoveMoney(account, amount, reason)
    if not success then return moneyCommandFailure(source, tostring(balance or 'Unable to remove money.')) end
    moneyCommandSuccess(source, target, 'Removed', account, amount, balance)
end, 'admin')

Node7Core.Commands.Add('balances', 'View your NODE7 account balances.', {}, false, function(source)
    local player = Node7Core.Functions.GetPlayer(source)
    if not player then return end
    Node7Core.Functions.Notify(source, {
        title = 'ACCOUNT BALANCES',
        description = ('Cash: $%.2f | Bank: $%.2f | Gold: %.2f'):format(
            player.Functions.GetMoney('cash'),
            player.Functions.GetMoney('bank'),
            player.Functions.GetMoney('gold')
        ),
        type = 'money',
        duration = 8000,
    })
end, 'user')

Node7Core.Commands.Add('setbloodtype', 'Set an online character blood type.', {
    { name = 'id', help = 'Player server ID' },
    { name = 'bloodtype', help = 'A+, A-, B+, B-, AB+, AB-, O+, or O-' },
}, true, function(source, args)
    local target = Node7Core.Functions.GetPlayer(tonumber(args[1]))
    if not target then return moneyCommandFailure(source, 'That player is not online.') end
    local success, bloodType = target.Functions.SetBloodType(args[2])
    if not success then return moneyCommandFailure(source, 'Invalid blood type.') end
    Node7Core.Functions.Notify(source, {
        title = 'BLOOD TYPE UPDATED',
        description = ('%s is now %s.'):format(target.Functions.GetName(), bloodType),
        type = 'success',
        duration = 6000,
    })
end, 'admin')

-- Job

Node7Core.Commands.Add('job', Lang:t('command.job.help'), {}, false, function(source)
    local PlayerJob = Node7Core.Functions.GetPlayer(source).PlayerData.job
    Node7Core.Functions.Notify(source, {title = Lang:t('info.job_info', { value = PlayerJob.label, value2 = PlayerJob.grade.name, value3 = PlayerJob.onduty }), type = 'info', duration = 5000 })
end, 'user')

Node7Core.Commands.Add('setjob', Lang:t('command.setjob.help'), { { name = Lang:t('command.setjob.params.id.name'), help = Lang:t('command.setjob.params.id.help') }, { name = Lang:t('command.setjob.params.job.name'), help = Lang:t('command.setjob.params.job.help') }, { name = Lang:t('command.setjob.params.grade.name'), help = Lang:t('command.setjob.params.grade.help') } }, true, function(source, args)
    local Player = Node7Core.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        local job = tostring(args[2])
        local grade = tonumber(args[3])
        if not Node7Core.Shared.Jobs[job] then
            Node7Core.Functions.Notify(source, {title = Lang:t('error.job_not_exist'), type = 'error', duration = 5000 })
            return
        end
        if GetResourceState('node7-multijob') == 'started' then
            exports['node7-multijob']:AddJobToPlayer(Player.PlayerData.citizenid, job, grade)
        end
        Player.Functions.SetJob(job, grade)
        Node7Core.Functions.Notify(source, {title = Lang:t('success.job_set'), type = 'success', duration = 5000 })
    else
        Node7Core.Functions.Notify(source, {title = Lang:t('error.not_online'), type = 'error', duration = 5000 })
    end
end, 'admin')

-- Gang

Node7Core.Commands.Add('gang', Lang:t('command.gang.help'), {}, false, function(source)
    local PlayerGang = Node7Core.Functions.GetPlayer(source).PlayerData.gang
    Node7Core.Functions.Notify(source, {title = Lang:t('info.gang_info', { value = PlayerGang.label, value2 = PlayerGang.grade.name }), type = 'info', duration = 5000 })
end, 'user')

Node7Core.Commands.Add('setgang', Lang:t('command.setgang.help'), { { name = Lang:t('command.setgang.params.id.name'), help = Lang:t('command.setgang.params.id.help') }, { name = Lang:t('command.setgang.params.gang.name'), help = Lang:t('command.setgang.params.gang.help') }, { name = Lang:t('command.setgang.params.grade.name'), help = Lang:t('command.setgang.params.grade.help') } }, true, function(source, args)
    local Player = Node7Core.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        if Player.Functions.SetGang(tostring(args[2]), tonumber(args[3])) then
            Node7Core.Functions.Notify(source, {title = Lang:t('success.gang_set'), type = 'success', duration = 5000 })
        else
            Node7Core.Functions.Notify(source, {title = Lang:t('error.gang_not_exist'), type = 'error', duration = 5000 })
        end
    else
        Node7Core.Functions.Notify(source, {title = Lang:t('error.not_online'), type = 'error', duration = 5000 })
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
        Node7Core.Functions.Notify(source, {title = Lang:t('error.missing_args2'), type = 'error', duration = 5000 })
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
    Node7Core.Functions.Notify(source, {title = 'ID: '..source, type = 'info', duration = 5000 })
end, 'user')

Node7Core.Commands.Add('cid', 'Check Your Citizen ID #', {}, false, function(source)
    local src = source
    local Player = Node7Core.Functions.GetPlayer(src)
    local Playercid = Player.PlayerData.citizenid
    Node7Core.Functions.Notify(source, {title = 'Citizen ID: '..Playercid, type = 'info', duration = 5000 })
end, 'user')
