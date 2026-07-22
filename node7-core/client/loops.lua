Node7Client.Cache = Node7Client.Cache or {
    playerId = PlayerId(),
    ped = PlayerPedId(),
    coords = vector3(0.0, 0.0, 0.0)
}

-- Cache only what client resources commonly request. Unloaded sessions update
-- less frequently, reducing idle native calls during character selection.
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        Node7Client.Cache.playerId = PlayerId()
        Node7Client.Cache.ped = ped
        Node7Client.Cache.coords = GetEntityCoords(ped)

        Wait(Node7Client.Loaded and 500 or 1500)
    end
end)
