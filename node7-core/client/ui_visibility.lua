-- NODE7 core UI visibility controller.
-- Hides every core-owned UI surface while RedM's native pause/map frontend is open.

Node7Core.UI = Node7Core.UI or {}

local pauseMenuOpen = false
local lastHeartbeat = 0
local pauseControlLatchUntil = 0

local PAUSE_CONTROL = GetHashKey('INPUT_FRONTEND_PAUSE')
local PAUSE_CONTROL_ALT = GetHashKey('INPUT_FRONTEND_PAUSE_ALTERNATE')

local function visibilityConfig()
    return (Node7Core.Config and Node7Core.Config.UI) or {}
end

local function safeControlJustPressed(control)
    if not control or control == 0 then return false end

    local pressed = false
    local ok = pcall(function()
        pressed = IsControlJustPressed(0, control) or IsDisabledControlJustPressed(0, control)
    end)

    return ok and pressed == true
end

local function readPauseMenuState()
    if visibilityConfig().HideDuringPauseMenu == false then return false end

    local now = GetGameTimer()

    -- Hide immediately on the frame the native frontend is requested. The native
    -- pause state can become available a few frames after ESC/O is pressed.
    if safeControlJustPressed(PAUSE_CONTROL) or safeControlJustPressed(PAUSE_CONTROL_ALT) then
        pauseControlLatchUntil = now + 400
    end

    local active = false

    -- Standard CFX pause detector.
    if type(IsPauseMenuActive) == 'function' then
        local ok, result = pcall(IsPauseMenuActive)
        if ok and result == true then active = true end
    end

    -- RedM's map/front-end may report a pause state here even when
    -- IsPauseMenuActive() has not switched yet.
    if not active and type(GetPauseMenuState) == 'function' then
        local ok, state = pcall(GetPauseMenuState)
        if ok and tonumber(state) and tonumber(state) > 0 then active = true end
    end

    if active then
        pauseControlLatchUntil = 0
        return true
    end

    return now < pauseControlLatchUntil
end

local function pushNuiState(force)
    local now = GetGameTimer()
    local heartbeat = tonumber(visibilityConfig().PauseMenuHeartbeatMs) or 100
    if not force and now - lastHeartbeat < heartbeat then return end
    lastHeartbeat = now

    SendNUIMessage({
        action = 'ui:pause',
        paused = pauseMenuOpen,
    })

    -- Force the account HUD off as a second layer. The browser root is also
    -- hidden by ui:pause, but this prevents a queued status update from flashing.
    if pauseMenuOpen then
        SendNUIMessage({ action = 'status:hide' })
    end
end

local function setPauseMenuState(active)
    active = active == true

    if pauseMenuOpen == active then
        if active then pushNuiState(false) end
        return
    end

    pauseMenuOpen = active
    pushNuiState(true)

    if LocalPlayer and LocalPlayer.state then
        LocalPlayer.state:set('node7PauseMenuOpen', pauseMenuOpen, false)
    end

    TriggerEvent('Node7Core:Client:PauseMenuStateChanged', pauseMenuOpen)
    TriggerEvent('node7-core:client:PauseMenuStateChanged', pauseMenuOpen)
end

function Node7Core.UI.IsPauseMenuOpen()
    return pauseMenuOpen
end

function Node7Core.UI.ShouldHideCoreUI()
    return pauseMenuOpen
end

CreateThread(function()
    while true do
        setPauseMenuState(readPauseMenuState())
        Wait(tonumber(visibilityConfig().PauseMenuPollMs) or 0)
    end
end)

AddEventHandler('onClientResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    pauseMenuOpen = readPauseMenuState()

    CreateThread(function()
        Wait(250)
        pushNuiState(true)
    end)
end)

exports('IsPauseMenuOpen', function()
    return pauseMenuOpen
end)

exports('ShouldHideCoreUI', function()
    return pauseMenuOpen
end)
