
-- NODE7 core UI visibility controller.
-- Uses RedM's native pause-menu state every frame and force-hides every core NUI surface.

Node7Core.UI = Node7Core.UI or {}

local pauseMenuOpen = false
local lastHeartbeat = 0

local function visibilityConfig()
    return (Node7Core.Config and Node7Core.Config.UI) or {}
end

local function readPauseMenuState()
    if visibilityConfig().HideDuringPauseMenu == false then return false end

    local ok, active = pcall(IsPauseMenuActive)
    return ok and active == true
end

local function pushNuiState(force)
    local now = GetGameTimer()
    local heartbeat = tonumber(visibilityConfig().PauseMenuHeartbeatMs) or 250
    if not force and now - lastHeartbeat < heartbeat then return end
    lastHeartbeat = now

    SendNUIMessage({
        action = 'ui:pause',
        paused = pauseMenuOpen,
    })
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
