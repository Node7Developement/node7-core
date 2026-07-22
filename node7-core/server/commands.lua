local function respond(source, message, notificationType)
    if source == 0 then
        print(('^3[NODE7]^7 %s'):format(message))
    else
        Node7.Notify(source, message, notificationType or 'info')
    end
end

function Node7.Commands.Add(name, help, arguments, argsRequired, callback, permission)
    name = tostring(name):gsub('^/', ''):lower()
    permission = permission or 'user'
    Node7.Commands.List[name] = {
        name = name,
        help = help or '',
        arguments = arguments or {},
        argsRequired = argsRequired == true,
        callback = callback,
        permission = permission
    }
    RegisterCommand(name, function(source, args, raw)
        local ace = Node7Config.Permissions[permission] or permission
        if permission ~= 'user' and not Node7.HasPermission(source, ace) then
            Node7.Notify(source, Node7Translate('no_permission'), 'error')
            return
        end
        if argsRequired and #args < #(arguments or {}) then
            Node7.Notify(source, ('Usage: /%s'):format(name), 'error')
            return
        end
        callback(source, args, raw)
    end, false)
end

function Node7.Commands.Refresh(source)
    for name, command in pairs(Node7.Commands.List) do
        local ace = Node7Config.Permissions[command.permission] or command.permission
        if command.permission == 'user' or Node7.HasPermission(source, ace) then
            TriggerClientEvent('chat:addSuggestion', source, '/' .. name, command.help, command.arguments)
        end
    end
end

exports('AddCommand', Node7.Commands.Add)
exports('RefreshCommands', Node7.Commands.Refresh)

local function chat(source, message)
    if source == 0 then print(('[NODE7] %s'):format(message)) return end
    TriggerClientEvent('chat:addMessage', source, { color = { 212, 175, 55 }, args = { 'NODE7', message } })
end

local function targetPlayer(source, raw)
    local target = tonumber(raw)
    local player = target and Node7.GetPlayer(target)
    if not player or not player.character then
        respond(source, Node7Translate('player_missing'), 'error')
        return nil
    end
    return target, player
end

local function register(names, restricted, handler)
    if type(names) == 'string' then names = { names } end
    for _, name in ipairs(names) do RegisterCommand(name, handler, restricted) end
end

local function decodeMetadata(args, firstIndex)
    if not args[firstIndex] then return {} end
    local raw = table.concat(args, ' ', firstIndex)
    local ok, decoded = pcall(json.decode, raw)
    if not ok or type(decoded) ~= 'table' then return nil, 'Metadata must be valid JSON.' end
    return decoded
end

register('n7status', true, function(source)
    local loaded = 0
    for _, player in pairs(Node7.Players) do if player.loaded then loaded = loaded + 1 end end
    respond(source, ('NODE7 %s | %d connected | %d loaded'):format(Node7.Version, #GetPlayers(), loaded))
end)

register({ 'n7save', 'saveplayer' }, true, function(source, args)
    local target = args[1] and targetPlayer(source, args[1]) or source
    if target and Node7.SavePlayer(target) then respond(source, Node7Translate('saved'), 'success') end
end)

register({ 'n7setmoney', 'setmoney' }, true, function(source, args)
    local target = targetPlayer(source, args[1])
    if not target then return end
    local ok = Node7.SetMoney(target, args[2], args[3], ('admin:%s'):format(source))
    respond(source, ok and 'Balance updated.' or 'Usage: /setmoney [id] [cash|bank|gold] [amount]', ok and 'success' or 'error')
end)

register({ 'n7givemoney', 'givemoney' }, true, function(source, args)
    local target = targetPlayer(source, args[1])
    if not target then return end
    local ok = Node7.AddMoney(target, args[2], args[3], ('admin:%s'):format(source))
    respond(source, ok and 'Money added.' or 'Usage: /givemoney [id] [cash|bank|gold] [amount]', ok and 'success' or 'error')
end)

register({ 'n7giveitem', 'giveitem' }, true, function(source, args)
    local target = targetPlayer(source, args[1])
    if not target then return end
    local metadata, metadataError = decodeMetadata(args, 4)
    if not metadata then respond(source, metadataError, 'error') return end
    local ok, reason = Node7.AddItem(target, args[2], tonumber(args[3]) or 1, metadata)
    respond(source, ok and 'Item added.' or ('Unable to add item: ' .. tostring(reason)), ok and 'success' or 'error')
end)

register({ 'n7removeitem', 'removeitem' }, true, function(source, args)
    local target = targetPlayer(source, args[1])
    if not target then return end
    local ok, reason = Node7.RemoveItem(target, args[2], tonumber(args[3]) or 1, tonumber(args[4]))
    respond(source, ok and 'Item removed.' or ('Unable to remove item: ' .. tostring(reason)), ok and 'success' or 'error')
end)

register({ 'n7giveweapon', 'giveweapon' }, true, function(source, args)
    local target = targetPlayer(source, args[1])
    if not target then return end
    local metadata, metadataError = decodeMetadata(args, 4)
    if not metadata then respond(source, metadataError, 'error') return end
    local ok, serial = Node7.GiveWeapon(target, tostring(args[2] or ''):upper(), tonumber(args[3]) or 0, metadata)
    respond(source, ok and ('Weapon added. Serial: %s'):format(serial) or 'Invalid weapon name.', ok and 'success' or 'error')
end)

register({ 'n7removeweapon', 'removeweapon' }, true, function(source, args)
    local target = targetPlayer(source, args[1])
    if not target then return end
    local ok = Node7.RemoveWeapon(target, args[2])
    respond(source, ok and 'Weapon removed.' or 'Weapon serial not found.', ok and 'success' or 'error')
end)

register({ 'n7giveammo', 'giveammo' }, true, function(source, args)
    local target = targetPlayer(source, args[1])
    if not target then return end
    local ok, amount = Node7.AddAmmo(target, args[2], args[3])
    respond(source, ok and ('Ammunition updated to %s.'):format(amount) or 'Weapon serial not found.', ok and 'success' or 'error')
end)

register({ 'n7removeammo', 'removeammo' }, true, function(source, args)
    local target = targetPlayer(source, args[1])
    if not target then return end
    local ok, amount = Node7.RemoveAmmo(target, args[2], args[3])
    respond(source, ok and ('Ammunition updated to %s.'):format(amount) or 'Weapon serial not found.', ok and 'success' or 'error')
end)

register({ 'n7setjob', 'setjob' }, true, function(source, args)
    local target = targetPlayer(source, args[1])
    if not target then return end
    local ok = Node7.SetJob(target, tostring(args[2] or ''):lower(), tonumber(args[3]) or 0)
    respond(source, ok and 'Job updated.' or 'Invalid job or grade.', ok and 'success' or 'error')
end)

register({ 'n7setgang', 'setgang' }, true, function(source, args)
    local target = targetPlayer(source, args[1])
    if not target then return end
    local ok = Node7.SetGang(target, tostring(args[2] or ''):lower(), tonumber(args[3]) or 0)
    respond(source, ok and 'Gang updated.' or 'Invalid gang or grade.', ok and 'success' or 'error')
end)

register('addhorse', true, function(source, args)
    local target = targetPlayer(source, args[1])
    if not target then return end
    local name = table.concat(args, ' ', 3)
    local ok, id = Node7.CreateHorse(target, { model = args[2], name = name })
    respond(source, ok and ('Horse added with ID %s.'):format(id) or ('Unable to add horse: ' .. tostring(id)), ok and 'success' or 'error')
end)

register('deletehorse', true, function(source, args)
    local target = targetPlayer(source, args[1])
    if not target then return end
    local ok = Node7.DeleteHorse(target, args[2])
    respond(source, ok and 'Horse deleted.' or 'Horse not found.', ok and 'success' or 'error')
end)

register('addwagon', true, function(source, args)
    local target = targetPlayer(source, args[1])
    if not target then return end
    local name = table.concat(args, ' ', 3)
    local ok, id = Node7.CreateWagon(target, { model = args[2], name = name })
    respond(source, ok and ('Wagon added with ID %s.'):format(id) or ('Unable to add wagon: ' .. tostring(id)), ok and 'success' or 'error')
end)

register('deletewagon', true, function(source, args)
    local target = targetPlayer(source, args[1])
    if not target then return end
    local ok = Node7.DeleteWagon(target, args[2])
    respond(source, ok and 'Wagon deleted.' or 'Wagon not found.', ok and 'success' or 'error')
end)

register('spawnhorse', true, function(source, args)
    if source == 0 then respond(source, 'Run this command in game.', 'error') return end
    local ok, reason = Node7.AdminSpawnHorse(source, args[1])
    respond(source, ok and 'Horse spawned.' or ('Unable to spawn horse: ' .. tostring(reason)), ok and 'success' or 'error')
end)

register({ 'spawnwagon', 'car' }, true, function(source, args)
    if source == 0 then respond(source, 'Run this command in game.', 'error') return end
    local ok, reason = Node7.AdminSpawnWagon(source, args[1])
    respond(source, ok and 'Wagon spawned.' or ('Unable to spawn wagon: ' .. tostring(reason)), ok and 'success' or 'error')
end)

register({ 'horse', 'callhorse' }, false, function(source, args)
    local ok, reason = Node7.SpawnHorse(source, tonumber(args[1]))
    if not ok then respond(source, ('Unable to call horse: %s'):format(reason), 'error') end
end)

register('duty', false, function(source)
    local player = Node7.GetPlayer(source)
    if not player or not player.character then return end
    local nextState = not player.character.job.duty
    Node7.SetDuty(source, nextState)
    respond(source, nextState and 'You are now on duty.' or 'You are now off duty.', nextState and 'success' or 'info')
end)

register({ 'wagon', 'callwagon' }, false, function(source, args)
    local ok, reason = Node7.SpawnWagon(source, tonumber(args[1]))
    if not ok then respond(source, ('Unable to call wagon: %s'):format(reason), 'error') end
end)

register('dismisshorse', false, function(source) TriggerClientEvent('node7:client:dismissHorse', source) end)
register('dismisswagon', false, function(source) TriggerClientEvent('node7:client:dismissWagon', source) end)

register('myhorses', false, function(source)
    local horses = Node7.GetHorses(source)
    if #horses == 0 then chat(source, 'You do not own any horses.') return end
    local values = {}
    for _, horse in ipairs(horses) do values[#values + 1] = ('#%s %s (%s)'):format(horse.id, horse.name, horse.model) end
    chat(source, table.concat(values, ' | '))
end)

register('mywagons', false, function(source)
    local wagons = Node7.GetWagons(source)
    if #wagons == 0 then chat(source, 'You do not own any wagons.') return end
    local values = {}
    for _, wagon in ipairs(wagons) do values[#values + 1] = ('#%s %s (%s)'):format(wagon.id, wagon.name, wagon.model) end
    chat(source, table.concat(values, ' | '))
end)

local function keysOf(registry)
    local keys = {}
    for key in pairs(registry) do keys[#keys + 1] = key end
    table.sort(keys)
    return keys
end

register('items', false, function(source) chat(source, table.concat(keysOf(Node7Items), ', ')) end)
register('jobs', false, function(source) chat(source, table.concat(keysOf(Node7Jobs), ', ')) end)
register('gangs', false, function(source) chat(source, table.concat(keysOf(Node7Gangs), ', ')) end)
register('horsemodels', false, function(source) chat(source, table.concat(keysOf(Node7HorseModels), ', ')) end)
register('wagonmodels', false, function(source) chat(source, table.concat(keysOf(Node7WagonModels), ', ')) end)
