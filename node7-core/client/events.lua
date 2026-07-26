-- Place Ped on ground properly
local function PlacePedOnGroundProperly(ped, coord)
    local x, y, z = table.unpack(coord)
    local found, groundz, normal = GetGroundZAndNormalFor_3dCoord(x, y, z)

    if found then
        SetEntityCoordsNoOffset(ped, x, y, groundz + normal.z, true)
    end
end

-- Player load and unload handling
-- New method for checking if logged in across all scripts (optional)
-- if LocalPlayer.state['isLoggedIn'] then
RegisterNetEvent('Node7Core:Client:OnPlayerLoaded', function()
    ShutdownLoadingScreenNui()
    LocalPlayer.state:set('isLoggedIn', true, false)
    --if not Node7Core.Config.Server.PVP then return end
    --SetCanAttackFriendly(PlayerPedId(), true, false)
    --NetworkSetFriendlyFireOption(true)
    if Node7Config.Server.PVP then
        Citizen.InvokeNative(0xF808475FA571D823, true)
        SetRelationshipBetweenGroups(5, `PLAYER`, `PLAYER`)
    end
    if Node7Config.Player.RevealMap then
        SetMinimapHideFow(true)
    end
    Citizen.InvokeNative(0x39363DFD04E91496, PlayerId(), true) -- enable mercy kil
    Citizen.InvokeNative(0x8899C244EBCF70DE, PlayerPedId(), 0.0) -- SetPlayerHealthRechargeMultiplier
    Citizen.InvokeNative(0xDE1B1907A83A1550, PlayerPedId(), 0.0) -- SetHealthRechargeMultiplier
end)

RegisterNetEvent('Node7Core:Client:OnPlayerUnload', function()
    LocalPlayer.state:set('isLoggedIn', false, false)
end)

RegisterNetEvent('Node7Core:Client:PvpHasToggled', function(pvp_state)
    Node7Config.Server.PVP = pvp_state
    SetCanAttackFriendly(PlayerPedId(), pvp_state, false)
    NetworkSetFriendlyFireOption(pvp_state)
end)

-- Teleport Commands

RegisterNetEvent('Node7Core:Command:TeleportToPlayer', function(coords)
    SetEntityCoords(cache.ped, coords.x, coords.y, coords.z) 
end)

RegisterNetEvent('Node7Core:Command:TeleportToCoords', function(x, y, z, h)
    SetEntityCoords(cache.ped, x, y, z) 
end)

RegisterNetEvent('Node7Core:Command:GoToMarker', function()
    local coords = GetWaypointCoords()
    local groundZ = GetHeightmapBottomZForPosition(coords.x, coords.y)
    local vehicle = GetVehiclePedIsIn(cache.ped, false)
    if not IsWaypointActive() then
        Node7Core.Functions.Notify({ title = Lang:t("error.no_waypoint"), type = 'error', duration = 5000 })
        return
    end

    SetEntityCoords(cache.ped, coords.x, coords.y, groundZ + 3.0)
    PlacePedOnGroundProperly(cache.ped, coords)

    if cache.mount then
        SetEntityCoords(cache.mount, coords.x, coords.y, groundZ + 3.0)
        PlacePedOnGroundProperly(cache.mount, coords)
        Citizen.InvokeNative(0x028F76B6E78246EB, cache.ped, cache.mount, -1)
    end

    if vehicle then
        SetEntityCoords(vehicle, coords.x, coords.y, groundZ + 3.0)
        PlacePedOnGroundProperly(vehicle, coords)
        Citizen.InvokeNative(0x028F76B6E78246EB, cache.ped, vehicle, -1)
    end

    Node7Core.Functions.Notify({ title = Lang:t("success.teleported_waypoint"), type = 'success', duration = 5000 })
end)

-- Noclip Command
RegisterNetEvent('Node7Core:Command:ToggleNoClip', function()
    ExecuteCommand('txAdmin:menu:noClipToggle')
end)

-- Vehicle Commands

RegisterNetEvent('Node7Core:Command:SpawnVehicle', function(vehName)
    local ped = PlayerPedId()
    local hash = joaat(vehName)
    local veh = GetVehiclePedIsUsing(ped)
    if not IsModelInCdimage(hash) then return end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end

    if IsPedInAnyVehicle(ped) then
        SetEntityAsMissionEntity(veh, true, true)
        DeleteVehicle(veh)
    end

    local vehicle = CreateVehicle(hash, GetEntityCoords(ped), GetEntityHeading(ped), true, false)
    TaskWarpPedIntoVehicle(ped, vehicle, -1)
    SetVehicleDirtLevel(vehicle, 0.0)
    SetModelAsNoLongerNeeded(hash)
end)

RegisterNetEvent('Node7Core:Command:DeleteVehicle', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsUsing(ped)
    if veh ~= 0 then
        SetEntityAsMissionEntity(veh, true, true)
        DeleteVehicle(veh)
    else
        local pcoords = GetEntityCoords(ped)
        local vehicles = GetGamePool('CVehicle')
        for _, v in pairs(vehicles) do
            if #(pcoords - GetEntityCoords(v)) <= 5.0 then
                SetEntityAsMissionEntity(v, true, true)
                DeleteVehicle(v)
            end
        end
    end
end)

-- Other stuff

RegisterNetEvent('Node7Core:Player:SetPlayerData', function(val)
    Node7Core.PlayerData = val
end)

RegisterNetEvent('Node7Core:Player:UpdatePlayerData', function()
    TriggerServerEvent('Node7Core:UpdatePlayer')
end)

-- This event is exploitable and should not be used. It has been deprecated, and will be removed soon.
RegisterNetEvent('Node7Core:Client:UseItem', function(item)
    Node7Core.Debug(string.format('%s triggered Node7Core:Client:UseItem by ID %s with the following data. This event is deprecated due to exploitation, and will be removed soon. Check node7-inventory for the correct item-use path.', GetInvokingResource(), GetPlayerServerId(PlayerId())))
    Node7Core.Debug(item)
end)

-- Callback Events --

-- Client Callback request
RegisterNetEvent('Node7Core:Client:TriggerClientCallback', function(name, ...)
    local handler = Node7Core.ClientCallbacks[name]
    if not handler then return end
    handler(function(...)
        TriggerServerEvent('Node7Core:Server:TriggerClientCallback', name, ...)
    end, ...)
end)

-- Server Callback response
RegisterNetEvent('Node7Core:Client:TriggerCallback', function(name, ...)
    local request = Node7Core.ServerCallbacks[name]
    if not request then return end

    request.promise:resolve(...)
    if request.callback then request.callback(...) end
    Node7Core.ServerCallbacks[name] = nil
end)

-- Me command
local function Draw3DText(coords, str)
    local onScreen, worldX, worldY = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
    local camCoords = GetGameplayCamCoord()
    local scale = 200 / (GetGameplayCamFov() * #(camCoords - coords))

    if onScreen then
        -- Set the text color using SetTextColor (RedM version)
        SetTextColor(255, 255, 255, 255) -- White color with full opacity

        -- Set the text scale (RedM requires slight adjustment)
        SetTextScale(0.0, 0.5 * scale) -- Adjust the scale values as needed

        -- Set the font to the desired font using SetTextFontForCurrentCommand
        SetTextFontForCurrentCommand(2) -- Use appropriate font ID here

        -- Center the text
        SetTextCentre(true)

        -- Create the text to be displayed using a variable string
        local varString = CreateVarString(10, "LITERAL_STRING", str)

        -- Display the text at the world coordinates (converted to screen coordinates)
        DisplayText(varString, worldX, worldY)
    end
end

RegisterNetEvent('Node7Core:Command:ShowMe3D', function(senderId, msg)
    local sender = GetPlayerFromServerId(senderId)
    CreateThread(function()
        local displayTime = 10000 + GetGameTimer()
        while displayTime > GetGameTimer() do
            local targetPed = GetPlayerPed(sender)
            local tCoords = GetEntityCoords(targetPed)
            Draw3DText(tCoords, msg)
            Wait(0)
        end
    end)
end)

-- Listen to Shared being updated
RegisterNetEvent('Node7Core:Client:OnSharedUpdate', function(tableName, key, value)
    Node7Core.Shared[tableName][key] = value
    TriggerEvent('Node7Core:Client:UpdateObject')
end)

RegisterNetEvent('Node7Core:Client:OnSharedUpdateMultiple', function(tableName, values)
    for key, value in pairs(values) do
        Node7Core.Shared[tableName][key] = value
    end
    TriggerEvent('Node7Core:Client:UpdateObject')
end)

RegisterNetEvent('Node7Core:Client:SharedUpdate', function(table)
    Node7Core.Shared = table
end)

if Node7Config.HidePlayerNames then
    CreateThread(function()
        while true do
            Wait(5000)
            for _, player in ipairs(GetActivePlayers()) do
                local ped = GetPlayerPed(player)
                SetPedPromptName(ped, "Stranger (" .. tostring(GetPlayerServerId(player)) .. ")")
            end
        end
    end)
end

-- csrf protection

local csrfToken = nil

local function GenerateCSRFToken() 
    local timeout = 500
    while csrfToken and timeout > 0 do
        timeout = timeout - 1
        Wait(0)
    end
    
    local token = tostring(math.random(100000, 999999)) .. GetGameTimer()
    csrfToken = token

    return token
end
exports('GenerateCSRFToken', GenerateCSRFToken)

RegisterNUICallback('validateCSRF', function(data, cb)
    if csrfToken and csrfToken == data.clientToken then
        csrfToken = nil
        cb({ valid = true })
    else
        TriggerServerEvent('Node7Core:Server:KickCSRF')
        cb({ valid = false })
    end
end)
