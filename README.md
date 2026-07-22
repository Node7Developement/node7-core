[README.md](https://github.com/user-attachments/files/30272802/README.md)
# NODE7 Core

NODE7 Core is a modular, server-authoritative RedM framework foundation. It includes account and character persistence, economy, inventory services, weapons, six configured jobs, five configured gangs, persistent horses and wagons, permissions, callbacks, notifications, progress bars, a HUD, and character services. Inventory presentation belongs in the separate `node7-inventory` resource.

Version 1.3.4 keeps player accounts, character persistence, character validation, loading, ownership, and appearance persistence inside NODE7 Core while leaving character presentation entirely to standalone resources such as `node7-multicharacter` and `node7-appearance`. Core does not display a full-screen startup overlay and forcibly closes legacy cached Core interfaces.

## Requirements

- Current FXServer/RedM artifact
- MariaDB or MySQL
- The compiled `oxmysql` release in a resource folder named exactly `oxmysql`

## Installation

1. Import `sql/node7_core.sql` into MariaDB.
2. Put `node7-core` inside `resources/[node7]/node7-core`.
3. Add the lines from `server.cfg.example` to the main `server.cfg`.
4. Start `oxmysql` before `node7-core`.
5. Restart the server. Do not use `refresh` to replace a clean initial restart.

## Built-in controls

- `Backspace`: cancel a cancellable progress action
- `/n7notifytest`: test notifications
- `/n7progresstest`: test the progress bar
- `/horse [ownedHorseId]`: call an owned horse
- `/wagon [ownedWagonId]`: call an owned wagon
- `/dismisshorse` and `/dismisswagon`: dismiss the current stable entity
- `/myhorses` and `/mywagons`: list owned stable entries
- `/duty`: toggle job duty

## Restricted commands

- `n7status`
- `n7save [serverId]`
- `n7setmoney [serverId] [cash|bank|gold] [amount]`
- `n7givemoney [serverId] [cash|bank|gold] [amount]`
- `n7giveitem [serverId] [item] [amount]`
- `n7giveweapon [serverId] [weapon_name] [ammo]`
- `n7giveammo [serverId] [weaponSerial] [amount]`
- `n7removeammo [serverId] [weaponSerial] [amount]`
- `n7setjob [serverId] [job] [grade]`
- `n7setgang [serverId] [gang] [grade]`

Short aliases are included:

- `giveitem [serverId] [item] [amount] [metadataJson]`
- `removeitem [serverId] [item] [amount] [slot]`
- `giveweapon [serverId] [weapon] [ammo] [metadataJson]`
- `removeweapon [serverId] [serial]`
- `giveammo [serverId] [weaponSerial] [amount]`
- `removeammo [serverId] [weaponSerial] [amount]`
- `givemoney [serverId] [cash|bank|gold] [amount]`
- `setmoney [serverId] [cash|bank|gold] [amount]`
- `setjob [serverId] [job] [grade]`
- `setgang [serverId] [gang] [grade]`
- `addhorse [serverId] [modelKey] [name]`
- `deletehorse [serverId] [horseId]`
- `addwagon [serverId] [modelKey] [name]`
- `deletewagon [serverId] [wagonId]`
- `spawnhorse [modelKey]`
- `spawnwagon [modelKey]`
- `car [wagonModelKey]`

Registry commands: `/items`, `/jobs`, `/gangs`, `/horsemodels`, and `/wagonmodels`.

## Core access

```lua
local Core = exports['node7-core']:GetCoreObject()
local Player = Core.Functions.GetPlayer(source)

print(Player.PlayerData.citizenid)
print(Player.PlayerData.charinfo.firstname)
print(Player.PlayerData.money.cash)

Player.Functions.AddMoney('cash', 10, 'example')
Player.Functions.AddItem('bread', 1)
```

Shared tables use a QBR-style layout:

```lua
Core.Shared.Items
Core.Shared.Jobs
Core.Shared.Gangs
Core.Shared.Horses
Core.Shared.Vehicles
Core.Shared.Weapons
Core.Shared.AmmoTypes
```

`AddItem`, `AddItems`, `AddJob`, `AddJobs`, `AddGang`, `AddGangs`, `AddHorse`, `AddHorses`, `AddVehicle`, and `AddVehicles` extend shared definitions. `GiveItem` adds an inventory item to a player.

Owned data exports are `GetOwnedWeapons`, `GetOwnedHorses`, and `GetOwnedWagons`. Shared registry exports are `GetWeapons`, `GetHorses`, and `GetVehicles`.

Important client exports include `GetPlayerData`, `IsPlayerLoaded`, `TriggerCallback`, `Notify`, and `Progress`.

## Security model

Money, item, weapon, character, job, gang, horse, and wagon writes are performed on the server. Client callbacks are rate-limited. Inventory operations are locked per inventory. Administrative commands use ACE restrictions and audit-sensitive actions in the database.

## Defaults and registries

Default jobs are `sheriff`, `doctor`, `blacksmith`, `rancher`, `stablehand`, and `saloon`. Each includes grades, salary, duty behavior, permissions, and metadata.

Default gangs are `blackwater_raiders`, `grizzlies_outlaws`, `lemoyne_riders`, `new_austin_renegades`, and `cumberland_wolves`. Each includes five ranks, rank permissions, account/storage settings, territory metadata, and member limits.

Items use the literal QBR field layout: `name`, `label`, `weight`, `type`, `image`, `unique`, `useable`, `shouldClose`, `combinable`, `level`, and `description`. Per-instance `info`/metadata is stored in the database without changing the shared item definition format.

## QBR-style source layout

```text
node7-core/
  client/
    functions.lua
    loops.lua
    events.lua
    drawtxt.lua
    prompts.lua
  server/
    debug.lua
    functions.lua
    player.lua
    events.lua
    commands.lua
    exports.lua
    modules/
  shared/
    main.lua
    items.lua
    jobs.lua
    horse.lua
    vehicles.lua
    gangs.lua
    weapons.lua
  locale/en.lua
  config.lua
  fxmanifest.lua
  node7_core.sql
```

## Extending the registries

Add items in `shared/items.lua`, weapons and ammunition in `shared/weapons.lua`, jobs in `shared/jobs.lua`, gangs in `shared/gangs.lua`, horse models in `shared/horse.lua`, and wagon models in `shared/vehicles.lua`. External resources can register items, jobs, gangs, usable items, and callbacks through the core API.
