# NODE7 Core API

## Server events

- `node7:server:playerLoaded(source, player)`
- `node7:server:playerUnloaded(source, player)`
- `node7:server:jobChanged(source, job)`
- `node7:server:gangChanged(source, gang)`

## Client events

- `node7:client:loaded(data)`
- `node7:client:notify(data)`
- `node7:client:moneyChanged(money, account, difference)`
- `node7:client:jobChanged(job)`
- `node7:client:gangChanged(gang)`
- `node7:client:statusChanged(metadata)`
- `node7:client:inventoryChanged()`

## Server example

```lua
local Core = exports['node7-core']:GetCoreObject()

RegisterCommand('payday', function(source)
    Core.Functions.AddMoney(source, 'bank', 10, 'payday')
    Core.Notify(source, 'You received $10.', 'money')
end)
```

## Registration exports

- `SetAppearance(source, appearance)` to validate and persist standalone appearance data
- `AddItem(name, definition)` and `AddItems(definitions)` for shared item definitions
- `GiveItem(source, item, amount, metadata, slot)` for inventory items
- `AddJob(name, definition)` and `AddJobs(definitions)`
- `AddGang(name, definition)` and `AddGangs(definitions)`
- `AddHorse(name, definition)` and `AddHorses(definitions)`
- `AddVehicle(name, definition)` and `AddVehicles(definitions)`
- `CreateUseableItem(name, handler)`
- `HasJobPermission(source, permission)`
- `HasGangPermission(source, permission)`
- `GetOrganizationBalance(type, name)`
- `AddOrganizationMoney(type, name, amount)`
- `RemoveOrganizationMoney(type, name, amount)`

## Shared registry exports

- `GetItems()` and `GetItem(name)`
- `GetJobs()` and `GetGangs()`
- `GetHorses()` and `GetVehicles()`
- `GetWeapons()`, `GetWeaponsByName()`, and `GetAmmoTypes()`

## Owned stable exports

- `GetOwnedHorses(source)` and `GetHorse(source, horseId)`
- `CreateHorse(source, data)` and `DeleteHorse(source, horseId)`
- `SetActiveHorse(source, horseId)` and `SpawnHorse(source, horseId)`
- `GetOwnedWagons(source)` and `GetWagon(source, wagonId)`
- `CreateWagon(source, data)` and `DeleteWagon(source, wagonId)`
- `SetActiveWagon(source, wagonId)` and `SpawnWagon(source, wagonId)`

## Client example

```lua
exports['node7-core']:Notify('Welcome to NODE7.', 'success', 4000)

exports['node7-core']:Progress({
    label = 'Preparing supplies...',
    duration = 5000,
    cancellable = true
}, function(completed)
    if completed then
        TriggerServerEvent('my-resource:server:completed')
    end
end)
```
