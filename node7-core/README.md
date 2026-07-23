# NODE7 Core

Runtime-only RedM framework core for NODE7 DEVELOPMENT STUDIOS.

This resource does **not** own player SQL, citizen IDs, users, character slots, or multicharacter logic. It only accepts a loaded `PlayerData` table from `node7-players` and provides runtime framework functions around that active session.

## Correct ownership

- `node7-core`: runtime framework functions only
- `node7-players`: database, citizen IDs, character slots, create/list/load/save/delete
- `node7-multicharacter`: fullscreen UI/selection only

## Recipe support

This core is compatible with the clean NODE7 txAdmin recipe layout.

Place it here after the recipe creates the folders:

```text
resources/[node7-core]/node7-core
```

Start order:

```cfg
ensure oxmysql
ensure node7-core
ensure node7-players
ensure node7-multicharacter
```

`oxmysql` is required by `node7-players`, not by `node7-core`.

## What this core does

- registers externally loaded players
- unloads externally loaded players
- refreshes QBCore-style `PlayerData`
- handles money
- handles runtime inventory
- handles runtime weapons
- handles runtime horses and wagons
- handles jobs, gangs, duty, permissions, callbacks, commands, notifications, progress bars, draw text, and prompts
- emits save requests back to `node7-players`

## What this core does not do

- no SQL files
- no `oxmysql` dependency
- no `users` table
- no `characters` table
- no citizen ID generation
- no character creation
- no character selector
- no account creation on connection

## Required player-manager contract

`node7-players` must load/create/select the character, then call:

```lua
exports['node7-core']:RegisterExternalPlayer(source, PlayerData)
```

When unloading:

```lua
exports['node7-core']:UnloadExternalPlayer(source)
```

When saving is needed, this core emits:

```lua
TriggerEvent('node7:server:externalSaveRequested', source, citizenid, PlayerData)
```

`node7-players` should listen for that event and persist the data to the clean `players` table.

## Core exports

Common exports:

- `GetCoreObject()`
- `GetPlayer(source)`
- `GetPlayers()`
- `GetPlayerByCitizenId(citizenid)`
- `RegisterExternalPlayer(source, PlayerData)`
- `UnloadExternalPlayer(source, save)`
- `RefreshPlayerData(source, includeInventory, sendClient)`
- `SavePlayer(source)`
- `GetMoney(source, account)`
- `AddMoney(source, account, amount, reason)`
- `RemoveMoney(source, account, amount, reason)`
- `SetMoney(source, account, amount, reason)`
- `GiveItem(source, item, amount, metadata, slot)`
- `RemoveItem(source, item, amount, slot)`
- `SetJob(source, job, grade)`
- `SetGang(source, gang, grade)`
- `SetDuty(source, state)`

## Notes

Runtime inventory, weapons, horses, and wagons are stored inside the active `PlayerData` object. Persistence belongs to `node7-players`.

Do not add player SQL back into this core.
