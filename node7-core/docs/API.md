# NODE7 Core API

`node7-core` is runtime-only. It does not create, load, or persist characters.

## External player contract

```lua
local ok, player = exports['node7-core']:RegisterExternalPlayer(source, PlayerData)
```

```lua
exports['node7-core']:UnloadExternalPlayer(source, true)
```

```lua
local data = exports['node7-core']:RefreshPlayerData(source, true, true)
```

## Save event

```lua
AddEventHandler('node7:server:externalSaveRequested', function(source, citizenid, playerData)
    -- node7-players persists playerData here
end)
```

## Runtime exports

- `GetCoreObject`
- `GetPlayer`
- `GetPlayers`
- `GetPlayerByCitizenId`
- `RegisterExternalPlayer`
- `UnloadExternalPlayer`
- `RefreshPlayerData`
- `SavePlayer`
- `GetMoney`
- `AddMoney`
- `RemoveMoney`
- `SetMoney`
- `GiveItem`
- `RemoveItem`
- `GetInventory`
- `GiveWeapon`
- `RemoveWeapon`
- `SetJob`
- `SetGang`
- `SetDuty`
