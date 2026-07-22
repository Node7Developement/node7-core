Node7Core = {
    Name = 'NODE7',
    Version = Node7Config.Version,
    Ready = false,
    Players = {},
    Callbacks = {},
    UsableItems = {},
    RateLimits = {},
    Shared = Node7Shared
}
Node7 = Node7Core
Node7.Functions = Node7
Node7.Player = {}
Node7.Commands = { List = {} }

local function debugPrint(message)
    if Node7Config.Debug then
        print(('^3[NODE7 DEBUG]^7 %s'):format(message))
    end
end

function Node7.Debug(message)
    debugPrint(message)
end

function Node7.GetPlayer(source)
    return Node7.Players[tonumber(source)]
end

function Node7.GetPlayers()
    return Node7.Players
end

function Node7.GetPlayerByCharacterId(characterId)
    characterId = tonumber(characterId)
    for _, player in pairs(Node7.Players) do
        if player.character and player.character.id == characterId then
            return player
        end
    end
end

function Node7.HasPermission(source, permission)
    if source == 0 then return true end
    return IsPlayerAceAllowed(tostring(source), permission)
end

function Node7.Notify(source, message, notificationType, duration)
    TriggerClientEvent('node7:client:notify', source, {
        message = tostring(message),
        type = notificationType or 'info',
        duration = math.min(math.max(tonumber(duration) or 4000, 1000), 15000)
    })
end

function Node7.RegisterCallback(name, handler)
    assert(type(name) == 'string' and type(handler) == 'function', 'Invalid NODE7 callback registration')
    Node7.Callbacks[name] = handler
    return true
end

-- QBR-style alias for resources using Core.Functions.CreateCallback.
Node7.CreateCallback = Node7.RegisterCallback

function Node7.RegisterUsableItem(itemName, handler)
    assert(Node7Items[itemName], ('Unknown NODE7 item: %s'):format(itemName))
    Node7.UsableItems[itemName] = handler
end

function Node7.RegisterItem(itemName, definition)
    if Node7Items[itemName] then return false, 'item_exists' end
    local ok, normalized = pcall(Node7NormalizeItemDefinition, itemName, definition)
    if not ok then return false, normalized end
    Node7Items[itemName] = normalized
    return true, normalized
end

function Node7.Log(actor, action, target, data)
    CreateThread(function()
        Node7Database.Audit(actor, action, target, data)
    end)
end

function Node7.SanitizeText(value, maxLength)
    if type(value) ~= 'string' then return nil end
    value = value:gsub('[%c]', ''):match('^%s*(.-)%s*$')
    if value == '' or #value > (maxLength or 64) then return nil end
    return value
end

local function rateAllowed(source)
    local now = os.time()
    local current = Node7.RateLimits[source]
    if not current or current.window ~= now then
        Node7.RateLimits[source] = { window = now, count = 1 }
        return true
    end
    current.count = current.count + 1
    return current.count <= Node7Config.CallbackRateLimit
end

RegisterNetEvent('node7:server:callback', function(requestId, name, ...)
    local source = source
    if type(requestId) ~= 'number' or type(name) ~= 'string' or not rateAllowed(source) then return end

    local handler = Node7.Callbacks[name]
    if not handler then
        TriggerClientEvent('node7:client:callback', source, requestId, false, 'unknown_callback')
        return
    end

    local responded = false
    local function respond(...)
        if responded then return end
        responded = true
        TriggerClientEvent('node7:client:callback', source, requestId, true, ...)
    end

    local ok, err = pcall(handler, source, respond, ...)
    if not ok then
        print(('^1[NODE7]^7 Callback %s failed: %s'):format(name, err))
        TriggerClientEvent('node7:client:callback', source, requestId, false, 'server_error')
    end
end)

AddEventHandler('playerDropped', function()
    Node7.RateLimits[source] = nil
end)

exports('GetCore', function()
    return Node7
end)

exports('GetPlayer', function(source)
    return Node7.GetPlayer(source)
end)

exports('HasPermission', function(source, permission)
    return Node7.HasPermission(source, permission)
end)

exports('RegisterItem', Node7.RegisterItem)


-- Character-session lifecycle used by standalone multicharacter resources.
Node7.Logout = function(source)
    return Node7.UnloadPlayer(source)
end

Node7.Unload = Node7.Logout
Node7.UnloadPlayer = Node7.UnloadPlayer
