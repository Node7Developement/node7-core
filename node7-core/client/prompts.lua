local prompts = {}

local function execute(options)
    if not options or not options.event then return end
    local arguments = options.args or {}
    if options.type == 'callback' then
        return options.event(table.unpack(arguments))
    elseif options.type == 'server' then
        TriggerServerEvent(options.event, table.unpack(arguments))
    else
        TriggerEvent(options.event, table.unpack(arguments))
    end
end

local function registerNativePrompt(entry)
    local handle = PromptRegisterBegin()
    PromptSetControlAction(handle, entry.key)
    PromptSetText(handle, CreateVarString(10, 'LITERAL_STRING', entry.text))
    PromptSetEnabled(handle, false)
    PromptSetVisible(handle, false)
    PromptSetHoldMode(handle, entry.hold ~= false)
    PromptRegisterEnd(handle)
    entry.handle = handle
end

local function CreatePrompt(name, coords, key, text, options, marker)
    if type(name) ~= 'string' or prompts[name] then return false, 'prompt_exists' end
    prompts[name] = {
        name = name,
        coords = coords,
        key = key,
        text = text,
        options = options or {},
        marker = marker,
        distance = tonumber(options and options.distance) or 1.75,
        hold = not options or options.hold ~= false,
        active = false
    }
    return true
end

local function DeletePrompt(name)
    local entry = prompts[name]
    if not entry then return false end
    if entry.handle then
        PromptSetEnabled(entry.handle, false)
        PromptSetVisible(entry.handle, false)
    end
    prompts[name] = nil
    return true
end

CreateThread(function()
    while true do
        local waitTime = 750
        local coords = GetEntityCoords(PlayerPedId())
        for _, entry in pairs(prompts) do
            local nearby = #(coords - entry.coords) <= entry.distance
            if nearby then
                waitTime = 0
                if not entry.handle then registerNativePrompt(entry) end
                if not entry.active then
                    PromptSetEnabled(entry.handle, true)
                    PromptSetVisible(entry.handle, true)
                    entry.active = true
                end
                if PromptHasHoldModeCompleted(entry.handle) then
                    execute(entry.options)
                    PromptSetEnabled(entry.handle, false)
                    PromptSetVisible(entry.handle, false)
                    entry.active = false
                end
            elseif entry.active and entry.handle then
                PromptSetEnabled(entry.handle, false)
                PromptSetVisible(entry.handle, false)
                entry.active = false
            end
        end
        Wait(waitTime)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for name in pairs(prompts) do DeletePrompt(name) end
end)

exports('CreatePrompt', CreatePrompt)
exports('createPrompt', CreatePrompt)
exports('GetPrompts', function() return prompts end)
exports('getPrompt', function() return prompts end)
exports('DeletePrompt', DeletePrompt)
exports('deletePrompt', DeletePrompt)
