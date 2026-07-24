CreateThread(function()
    local interval = (1000 * 60) * Node7Core.Config.UpdateInterval

    while true do
        Wait(interval)
        if LocalPlayer.state.isLoggedIn then 
            TriggerServerEvent("Node7Core:UpdatePlayer")
        end     
    end
end)