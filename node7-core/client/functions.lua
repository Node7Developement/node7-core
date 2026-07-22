Node7Client = {
    PlayerData = nil,
    CharacterData = nil,
    Loaded = false,
    Callbacks = {},
    RequestId = 0,
    ActiveProgress = nil,
    ActiveHorse = nil,
    ActiveWagon = nil,
    Blips = {},
    Peds = {},
    Shared = Node7Shared
}
Node7Core = Node7Client
Node7Client.Functions = Node7Client

local function nui(action, data)
    SendNUIMessage({ action = action, data = data })
end

-- Older NODE7 Core builds owned full-screen startup, character, and inventory
-- layers. Explicitly close them so a cached NUI document can never cover the
-- standalone multicharacter, appearance, or spawn resources.
local function closeLegacyCoreUi()
    nui('startup', false)
    nui('characters:close')
    nui('inventory:close')
end

function Node7Client.TriggerCallback(name, callback, ...)
    Node7Client.RequestId = Node7Client.RequestId + 1
    if Node7Client.RequestId > 1000000 then Node7Client.RequestId = 1 end
    Node7Client.Callbacks[Node7Client.RequestId] = callback
    TriggerServerEvent('node7:server:callback', Node7Client.RequestId, name, ...)
end

function Node7Client.Notify(message, notificationType, duration)
    nui('notify', {
        message = tostring(message),
        type = notificationType or 'info',
        duration = duration or 4000
    })
end

function Node7Client.Progress(options, callback)
    if Node7Client.ActiveProgress then return false end
    options = options or {}
    Node7Client.ActiveProgress = {
        callback = callback,
        cancellable = options.cancellable ~= false,
        disableMovement = options.disableMovement ~= false,
        disableCombat = options.disableCombat ~= false
    }
    nui('progress', {
        label = options.label or 'Working...',
        duration = math.max(tonumber(options.duration) or 3000, 250),
        cancellable = Node7Client.ActiveProgress.cancellable
    })
    return true
end

function Node7Client.GetCoords(entity)
    entity = entity or PlayerPedId()
    local coords = GetEntityCoords(entity)
    return vector4(coords.x, coords.y, coords.z, GetEntityHeading(entity))
end

function Node7Client.HasItem(itemName, amount)
    local result = promise.new()
    Node7Client.TriggerCallback('inventory:hasItem', function(success, hasItem)
        result:resolve(success and hasItem == true)
    end, itemName, tonumber(amount) or 1)
    return Citizen.Await(result)
end

RegisterNetEvent('node7:client:callback', function(requestId, success, ...)
    local callback = Node7Client.Callbacks[requestId]
    if not callback then return end
    Node7Client.Callbacks[requestId] = nil
    callback(success, ...)
end)

RegisterNetEvent('node7:client:notify', function(data)
    Node7Client.Notify(data.message, data.type, data.duration)
end)

RegisterNetEvent('node7:client:onSharedUpdate', function(category, key, value)
    if type(category) ~= 'string' or not Node7Shared[category] then return end
    Node7Shared[category][key] = value
    TriggerEvent('node7:client:sharedUpdated', category, key, value)
end)

RegisterNetEvent('node7:client:onSharedUpdateMultiple', function(category, values)
    if type(category) ~= 'string' or not Node7Shared[category] or type(values) ~= 'table' then return end
    for key, value in pairs(values) do Node7Shared[category][key] = value end
    TriggerEvent('node7:client:sharedUpdatedMultiple', category, values)
end)

RegisterNetEvent('node7:client:updateObject', function()
    Node7Client.Shared = Node7Shared
    TriggerEvent('node7:client:coreUpdated', Node7Client)
end)

RegisterNetEvent('node7:client:setPlayerData', function(playerData)
    Node7Client.PlayerData = playerData
    TriggerEvent('node7:client:playerDataUpdated', playerData)
end)

RegisterNetEvent('Node7:Player:SetPlayerData', function(playerData)
    Node7Client.PlayerData = playerData
    TriggerEvent('node7:client:playerDataUpdated', playerData)
end)

RegisterNetEvent('node7:client:loaded', function(data)
    Node7Client.PlayerData = data.PlayerData or data
    Node7Client.CharacterData = data.character
    Node7Client.Loaded = true
    closeLegacyCoreUi()

    local position = data.character.position
    if position and position.x then
        local ped = PlayerPedId()
        SetEntityCoords(ped, position.x + 0.0, position.y + 0.0, position.z + 0.0, false, false, false, false)
        SetEntityHeading(ped, (position.w or 0.0) + 0.0)
    end
    Node7Client.Notify(Node7Translate('character_loaded'), 'success')
end)

RegisterNetEvent('node7:client:unloaded', function()
    Node7Client.PlayerData = nil
    Node7Client.CharacterData = nil
    Node7Client.Loaded = false
    Node7Client.Callbacks = {}
    closeLegacyCoreUi()
    TriggerEvent('Node7:Client:OnPlayerUnload')
    TriggerEvent('node7:client:playerUnloaded')
end)

RegisterNetEvent('node7:client:moneyChanged', function(money)
    if Node7Client.PlayerData then Node7Client.PlayerData.money = money end
    if Node7Client.CharacterData then Node7Client.CharacterData.money = money end
end)

RegisterNetEvent('node7:client:jobChanged', function(job)
    if Node7Client.CharacterData then Node7Client.CharacterData.job = job end
end)

RegisterNetEvent('node7:client:gangChanged', function(gang)
    if Node7Client.CharacterData then Node7Client.CharacterData.gang = gang end
end)

RegisterNetEvent('node7:client:statusChanged', function(metadata)
    if Node7Client.PlayerData then Node7Client.PlayerData.metadata = metadata end
    if Node7Client.CharacterData then Node7Client.CharacterData.metadata = metadata end
end)

RegisterNetEvent('node7:client:heal', function(amount)
    local ped = PlayerPedId()
    SetEntityHealth(ped, math.min(GetEntityMaxHealth(ped), GetEntityHealth(ped) + (tonumber(amount) or 0)))
end)

RegisterNetEvent('node7:client:applyItemEffects', function(effects)
    local ped = PlayerPedId()
    if effects.health then
        SetEntityHealth(ped, math.min(GetEntityMaxHealth(ped), GetEntityHealth(ped) + tonumber(effects.health)))
    end
    if effects.stamina then
        RestorePlayerStamina(PlayerId(), math.min(1.0, tonumber(effects.stamina) / 100.0))
    end
end)

local function loadModel(model)
    local hash = type(model) == 'number' and model or joaat(model)
    if not IsModelValid(hash) then return nil, 'invalid_model' end
    RequestModel(hash)
    local deadline = GetGameTimer() + Node7Config.Stables.modelLoadTimeout
    while not HasModelLoaded(hash) and GetGameTimer() < deadline do Wait(50) end
    if not HasModelLoaded(hash) then return nil, 'model_timeout' end
    return hash
end

local function removeEntity(entity)
    if entity and DoesEntityExist(entity) then
        SetEntityAsMissionEntity(entity, true, true)
        DeleteEntity(entity)
    end
end

RegisterNetEvent('node7:client:spawnHorse', function(data)
    local hash, reason = loadModel(data.model)
    if not hash then Node7Client.Notify(('Horse spawn failed: %s'):format(reason), 'error') return end
    if Node7Config.Stables.replaceActiveEntity then removeEntity(Node7Client.ActiveHorse) end
    local ped = PlayerPedId()
    local spawn = GetOffsetFromEntityInWorldCoords(ped, 2.5, Node7Config.Stables.spawnDistance, 0.0)
    local horse = CreatePed(hash, spawn.x, spawn.y, spawn.z, GetEntityHeading(ped), true, true, false, false)
    if not horse or horse == 0 then
        SetModelAsNoLongerNeeded(hash)
        Node7Client.Notify('Horse creation failed.', 'error')
        return
    end
    SetEntityAsMissionEntity(horse, true, true)
    PlaceEntityOnGroundProperly(horse)
    NetworkRegisterEntityAsNetworked(horse)
    local netId = NetworkGetNetworkIdFromEntity(horse)
    SetNetworkIdCanMigrate(netId, true)
    Node7Client.ActiveHorse = horse
    SetModelAsNoLongerNeeded(hash)
    Node7Client.Notify(('%s is ready.'):format(data.name or 'Your horse'), 'success')
end)

RegisterNetEvent('node7:client:spawnWagon', function(data, adminSpawn)
    local hash, reason = loadModel(data.model)
    if not hash then Node7Client.Notify(('Wagon spawn failed: %s'):format(reason), 'error') return end
    if Node7Config.Stables.replaceActiveEntity then removeEntity(Node7Client.ActiveWagon) end
    local ped = PlayerPedId()
    local spawn = GetOffsetFromEntityInWorldCoords(ped, 3.0, Node7Config.Stables.spawnDistance + 2.0, 0.0)
    local wagon = CreateVehicle(hash, spawn.x, spawn.y, spawn.z, GetEntityHeading(ped), true, true, false, false)
    if not wagon or wagon == 0 then
        SetModelAsNoLongerNeeded(hash)
        Node7Client.Notify('Wagon creation failed.', 'error')
        return
    end
    SetEntityAsMissionEntity(wagon, true, true)
    PlaceEntityOnGroundProperly(wagon)
    NetworkRegisterEntityAsNetworked(wagon)
    local netId = NetworkGetNetworkIdFromEntity(wagon)
    SetNetworkIdCanMigrate(netId, true)
    Node7Client.ActiveWagon = wagon
    SetModelAsNoLongerNeeded(hash)
    if adminSpawn and Node7Config.Stables.warpIntoAdminWagon then TaskWarpPedIntoVehicle(ped, wagon, -1) end
    Node7Client.Notify(('%s is ready.'):format(data.name or 'Your wagon'), 'success')
end)

RegisterNetEvent('node7:client:dismissHorse', function()
    removeEntity(Node7Client.ActiveHorse)
    Node7Client.ActiveHorse = nil
    Node7Client.Notify('Horse dismissed.', 'info')
end)

RegisterNetEvent('node7:client:dismissWagon', function()
    removeEntity(Node7Client.ActiveWagon)
    Node7Client.ActiveWagon = nil
    Node7Client.Notify('Wagon dismissed.', 'info')
end)

RegisterNetEvent('node7:client:weaponGiven', function(weaponName, ammo)
    local ped = PlayerPedId()
    Citizen.InvokeNative(0x5E3BDDBCB83F3D84, ped, joaat(weaponName), tonumber(ammo) or 0,
        false, true, 0, false, 0.5, 1.0, 0, 0, false)
end)

RegisterNetEvent('node7:client:weaponRemoved', function(serial)
    Node7Client.Notify(('Weapon %s removed. Reconnect to refresh the native loadout.'):format(serial), 'info')
end)

RegisterNetEvent('node7:client:weaponAmmoChanged', function(weaponName, amount)
    SetPedAmmo(PlayerPedId(), joaat(weaponName), tonumber(amount) or 0)
end)

RegisterNUICallback('progress:complete', function(data, cb)
    local progress = Node7Client.ActiveProgress
    Node7Client.ActiveProgress = nil
    if progress and progress.callback then progress.callback(not data.cancelled) end
    cb({ ok = true })
end)

CreateThread(function()
    closeLegacyCoreUi()
    nui('theme', Node7Config.UI)
    Wait(1000)
    closeLegacyCoreUi()
end)

CreateThread(function()
    local pauseMenuVisible = false
    while true do
        local active = IsPauseMenuActive() == true
        if active ~= pauseMenuVisible then
            pauseMenuVisible = active
            nui('pause', active)
        end
        Wait(active and 100 or 250)
    end
end)

CreateThread(function()
    while true do
        if Node7Client.ActiveProgress then
            if Node7Client.ActiveProgress.disableMovement then
                DisableControlAction(0, 0x8FD015D8, true)
                DisableControlAction(0, 0xD27782E3, true)
                DisableControlAction(0, 0x7065027D, true)
                DisableControlAction(0, 0xB4E465B4, true)
            end
            if Node7Client.ActiveProgress.disableCombat then
                DisablePlayerFiring(PlayerId(), true)
            end
            if Node7Client.ActiveProgress.cancellable and IsControlJustReleased(0, 0x156F7119) then
                nui('progress:cancel')
            end
            Wait(0)
        else
            Wait(250)
        end
    end
end)

exports('GetPlayerData', function() return Node7Client.PlayerData end)
exports('IsPlayerLoaded', function() return Node7Client.Loaded end)
exports('TriggerCallback', Node7Client.TriggerCallback)
exports('Notify', Node7Client.Notify)
exports('Progress', Node7Client.Progress)
exports('Progressbar', Node7Client.Progress)
exports('GetCoords', Node7Client.GetCoords)
exports('HasItem', Node7Client.HasItem)
exports('LoadModel', loadModel)
exports('GetCoreObject', function() return Node7Client end)
exports('GetSharedObject', function() return Node7Shared end)
exports('GetItems', function() return Node7Shared.Items end)
exports('GetItem', function(name) return Node7Shared.Items[name] end)
exports('GetJobs', function() return Node7Shared.Jobs end)
exports('GetGangs', function() return Node7Shared.Gangs end)
exports('GetHorses', function() return Node7Shared.Horses end)
exports('GetVehicles', function() return Node7Shared.Vehicles end)
exports('GetWeapons', function() return Node7Shared.Weapons end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    removeEntity(Node7Client.ActiveHorse)
    removeEntity(Node7Client.ActiveWagon)
end)
