Node7Client.Cache = Node7Client.Cache or {
    playerId = PlayerId(),
    ped = PlayerPedId(),
    coords = vector3(0.0, 0.0, 0.0)
}

CreateThread(function()
    while true do
        Node7Client.Cache.playerId = PlayerId()
        Node7Client.Cache.ped = PlayerPedId()
        Node7Client.Cache.coords = GetEntityCoords(Node7Client.Cache.ped)
        Wait(250)
    end
end)

CreateThread(function()
    while true do
        if Node7Client.Loaded then
            LocalPlayer.state:set('node7Loaded', true, false)
            Wait(5000)
        else
            Wait(1000)
        end
    end
end)
