local Prompts = {}
local PromptGroups = {}

local function pauseMenuOpen()
    return Node7Core.UI and Node7Core.UI.IsPauseMenuOpen and Node7Core.UI.IsPauseMenuOpen()
end

local function distanceBetween(a, b)
    local dx = a.x - (b.x or b[1])
    local dy = a.y - (b.y or b[2])
    local dz = a.z - (b.z or b[3])
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

local function setPromptState(promptHandle, enabled, visible)
    if not promptHandle then return end
    UiPromptSetEnabled(promptHandle, enabled == true)
    UiPromptSetVisible(promptHandle, visible == true)
end

local function hideAllPrompts()
    for _, prompt in pairs(Prompts) do
        setPromptState(prompt.prompt, false, false)
    end

    for _, group in pairs(PromptGroups) do
        for _, prompt in pairs(group.prompts) do
            setPromptState(prompt.prompt, false, false)
        end
    end
end

local function createPrompt(name, coords, key, text, options)
    if Prompts[name] == nil then
        Prompts[name] = {
            name = name,
            coords = coords,
            key = key,
            text = text,
            options = options,
            prompt = nil,
        }
    else
        print('[node7-core] Prompt with name ' .. name .. ' already exists!')
    end
end

local function createPromptGroup(group, label, coords, prompts)
    if PromptGroups[group] == nil then
        PromptGroups[group] = {
            coords = coords,
            label = label,
            group = group,
            created = false,
            prompts = prompts,
        }
    else
        print('[node7-core] Prompt group with name ' .. group .. ' already exists!')
    end
end

local function getPrompt()
    return Prompts
end

local function getPromptGroup()
    return PromptGroups
end

local function deletePrompt(name)
    if not Prompts[name] then return end
    if Prompts[name].prompt then UiPromptDelete(Prompts[name].prompt) end
    Prompts[name] = nil
end

local function deletePromptGroup(name)
    if not PromptGroups[name] then return end
    for _, prompt in pairs(PromptGroups[name].prompts) do
        if prompt.prompt then UiPromptDelete(prompt.prompt) end
    end
    PromptGroups[name] = nil
end

local function executeOptions(options)
    if not options or pauseMenuOpen() then return end

    if options.type == 'client' then
        if options.args == nil then
            TriggerEvent(options.event)
        else
            TriggerEvent(options.event, table.unpack(options.args))
        end
    else
        if options.args == nil then
            TriggerServerEvent(options.event)
        else
            TriggerServerEvent(options.event, table.unpack(options.args))
        end
    end
end

local function setupPrompt(prompt)
    local str = CreateVarString(10, 'LITERAL_STRING', prompt.text)
    prompt.prompt = Citizen.InvokeNative(0x04F97DE45A519419, Citizen.ReturnResultAnyway())
    Citizen.InvokeNative(0xB5352B7494A08258, prompt.prompt, prompt.key)
    Citizen.InvokeNative(0x5DD02A8318420DD7, prompt.prompt, str)
    Citizen.InvokeNative(0x8A0FB4D03A630D21, prompt.prompt, true)
    Citizen.InvokeNative(0x71215ACCFDE075EE, prompt.prompt, true)
    Citizen.InvokeNative(0x94073D5CA3F16B7B, prompt.prompt, 1000)
    Citizen.InvokeNative(0xF7AA2696A22AD8B9, prompt.prompt)
end

local function setupPromptGroup(promptGroup)
    for _, prompt in pairs(promptGroup.prompts) do
        local str = CreateVarString(10, 'LITERAL_STRING', prompt.text)
        prompt.prompt = Citizen.InvokeNative(0x04F97DE45A519419, Citizen.ReturnResultAnyway())
        Citizen.InvokeNative(0xB5352B7494A08258, prompt.prompt, prompt.key)
        Citizen.InvokeNative(0x5DD02A8318420DD7, prompt.prompt, str)
        Citizen.InvokeNative(0x8A0FB4D03A630D21, prompt.prompt, true)
        Citizen.InvokeNative(0x71215ACCFDE075EE, prompt.prompt, true)
        Citizen.InvokeNative(0x94073D5CA3F16B7B, prompt.prompt, 1000)
        Citizen.InvokeNative(0x2F11D3A254169EA4, prompt.prompt, promptGroup.group, 0)
        Citizen.InvokeNative(0xF7AA2696A22AD8B9, prompt.prompt)
    end

    promptGroup.created = true
end

AddEventHandler('Node7Core:Client:PauseMenuStateChanged', function(isOpen)
    if isOpen then hideAllPrompts() end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    for _, prompt in pairs(Prompts) do
        if prompt.prompt then UiPromptDelete(prompt.prompt) end
    end
    Prompts = {}

    for _, promptGroup in pairs(PromptGroups) do
        for _, prompt in pairs(promptGroup.prompts) do
            if prompt.prompt then UiPromptDelete(prompt.prompt) end
        end
    end
    PromptGroups = {}
end)

CreateThread(function()
    while true do
        local sleep = 1000

        if pauseMenuOpen() then
            hideAllPrompts()
            sleep = 100
        elseif next(Prompts) ~= nil then
            local coords = GetEntityCoords(cache.ped, true)

            for name, prompt in pairs(Prompts) do
                local distance = distanceBetween(coords, prompt.coords)

                if distance < Node7Config.PromptDistance then
                    sleep = 1
                    if prompt.prompt == nil then setupPrompt(prompt) end
                    setPromptState(prompt.prompt, true, true)

                    if UiPromptHasHoldModeCompleted(prompt.prompt) then
                        executeOptions(prompt.options)
                        setPromptState(prompt.prompt, false, false)
                        Wait(0)
                        if not pauseMenuOpen() then setPromptState(prompt.prompt, true, true) end
                        break
                    end
                elseif prompt.prompt then
                    UiPromptDelete(prompt.prompt)
                    Prompts[name].prompt = nil
                end
            end
        end

        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000

        if pauseMenuOpen() then
            hideAllPrompts()
            sleep = 100
        elseif next(PromptGroups) ~= nil then
            local coords = GetEntityCoords(cache.ped, true)

            for name, promptGroup in pairs(PromptGroups) do
                local distance = distanceBetween(coords, promptGroup.coords)

                if distance < Node7Config.PromptDistance then
                    sleep = 1
                    if promptGroup.created == false then setupPromptGroup(promptGroup) end

                    for _, prompt in pairs(promptGroup.prompts) do
                        setPromptState(prompt.prompt, true, true)
                    end

                    Citizen.InvokeNative(
                        0xC65A45D4453C2627,
                        promptGroup.group,
                        CreateVarString(10, 'LITERAL_STRING', promptGroup.label),
                        1
                    )

                    for _, prompt in pairs(promptGroup.prompts) do
                        if UiPromptHasHoldModeCompleted(prompt.prompt) then
                            executeOptions(prompt.options)
                            setPromptState(prompt.prompt, false, false)
                            Wait(0)
                            if not pauseMenuOpen() then setPromptState(prompt.prompt, true, true) end
                            break
                        end
                    end
                elseif promptGroup.created then
                    for _, prompt in pairs(promptGroup.prompts) do
                        if prompt.prompt then UiPromptDelete(prompt.prompt) end
                        prompt.prompt = nil
                    end
                    PromptGroups[name].created = false
                end
            end
        end

        Wait(sleep)
    end
end)

-- https://github.com/femga/rdr3_discoveries/tree/master/graphics/HUD/prompts/prompt_types
CreateThread(function()
    while true do
        if not pauseMenuOpen() then
            Citizen.InvokeNative(0xFC094EF26DD153FA, 1)
            Citizen.InvokeNative(0xFC094EF26DD153FA, 2)
        end
        Wait(pauseMenuOpen() and 100 or 1)
    end
end)

exports('createPrompt', createPrompt)
exports('createPromptGroup', createPromptGroup)
exports('getPrompt', getPrompt)
exports('getPromptGroup', getPromptGroup)
exports('deletePrompt', deletePrompt)
exports('deletePromptGroup', deletePromptGroup)
