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
        print(('^3[NODE7 DEBUG]^7 %s'):format(tostring(message)))
    end
end

local function clone(value, seen)
    if type(value) ~= 'table' then return value end
    seen = seen or {}
    if seen[value] then return seen[value] end
    local copy = {}
    seen[value] = copy
    for key, entry in pairs(value) do
        copy[clone(key, seen)] = clone(entry, seen)
    end
    return copy
end

function Node7.Clone(value)
    return clone(value)
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

function Node7.GetPlayerByCitizenId(citizenid)
    citizenid = tostring(citizenid or '')
    if citizenid == '' then return nil end
    for _, player in pairs(Node7.Players) do
        if player.PlayerData and tostring(player.PlayerData.citizenid) == citizenid then
            return player
        end
    end
end

function Node7.GetPlayerByCharacterId(characterId)
    return Node7.GetPlayerByCitizenId(characterId)
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
end

function Node7.RegisterUsableItem(itemName, handler)
    assert(Node7Items[itemName], ('Unknown NODE7 item: %s'):format(tostring(itemName)))
    assert(type(handler) == 'function', 'Invalid NODE7 usable item handler')
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
    if not Node7Config.Debug then return end
    print(('^3[NODE7 LOG]^7 actor=%s action=%s target=%s data=%s'):format(
        tostring(actor or 'system'),
        tostring(action or 'unknown'),
        tostring(target or ''),
        json.encode(data or {})
    ))
end

function Node7.SanitizeText(value, maxLength, allowEmpty)
    if value == nil then return allowEmpty and '' or nil end
    value = tostring(value):gsub('[%c]', ''):match('^%s*(.-)%s*$')
    if (not allowEmpty and value == '') or #value > (maxLength or 64) then return nil end
    return value
end

function Node7.MarkPlayerDirty(source)
    source = tonumber(source)
    local player = source and Node7.Players[source]
    if not player then return false end
    player.dirty = true
    player.lastChanged = os.time()
    TriggerEvent('node7:server:externalPlayerDataChanged', source)
    return true
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
        print(('^1[NODE7]^7 Callback %s failed: %s'):format(name, tostring(err)))
        TriggerClientEvent('node7:client:callback', source, requestId, false, 'server_error')
    end
end)

AddEventHandler('playerDropped', function()
    Node7.RateLimits[source] = nil
end)

exports('GetCore', function() return Node7 end)
exports('GetPlayer', function(source) return Node7.GetPlayer(source) end)
exports('HasPermission', function(source, permission) return Node7.HasPermission(source, permission) end)
exports('RegisterItem', Node7.RegisterItem)
