local Node7Core = exports['node7-core']:GetCoreObject()
local pvp = true

CreateThread(function()
    local active = false
    local timer = 0
    while true do 
        Wait(0)

        if Node7Core.Config.Server.PVP then
            if active == false and not IsPedOnMount(cache.ped) and not IsPedInAnyVehicle(cache.ped) then
                SetRelationshipBetweenGroups(3, `PLAYER`, `PLAYER`)
            else
                SetRelationshipBetweenGroups(1, `PLAYER`, `PLAYER`)
            end

            if IsControlJustPressed(0, Node7Core.Shared.Keybinds['E']) then
                timer = 0
                active = true
                while timer < 200 do 
                    Wait(0)
                    timer = timer + 1
                    SetRelationshipBetweenGroups(1, `PLAYER`, `PLAYER`)
                end
                active = false
            end

            if IsControlJustPressed(0, Node7Core.Shared.Keybinds['F']) then
                Wait(500)
                SetRelationshipBetweenGroups(1, `PLAYER`, `PLAYER`)
                active = false
                timer = 0
            end
                    
            Citizen.InvokeNative(0xF808475FA571D823, true)
            NetworkSetFriendlyFireOption(true)
        end
    end
end)
