# node7-core

NODE7's RedM core rebuilt around the supplied QBCore 1.3.0 object, callback, player, command, and export conventions. RedM item, weapon, job, gang, vehicle, location, keybind, money-item, database, notification, recipe, and manifest behavior remains NODE7-native.

## Core access

```lua
local Node7Core = exports['node7-core']:GetCoreObject()
local FunctionsOnly = exports['node7-core']:GetCoreObject({ 'Functions' })
local Items = exports['node7-core']:GetShared('Items')
local Dollar = exports['node7-core']:GetShared('Items', 'dollar')
```

## Player access

```lua
local Player = Node7Core.Functions.GetPlayer(source)
local SamePlayer = exports['node7-core']:GetPlayer(source)

Player.Functions.AddMoney('bank', 100.00, 'example')
local balance = Player.Functions.GetMoney('bank')
```

Callbacks support both callback and await styles, matching QBCore conventions. The resource remains `node7-core`; no `qb-core` dependency or FiveM item set is introduced.

NODE7 RedM framework core built in the same resource format as `node7-core`, with ox_lib and oxmysql support.

## Required start order

```cfg
ensure ox_lib
ensure oxmysql
ensure node7-core
ensure node7-inventory # required when cash is configured as inventory items
```

## Main export

```lua
local Node7Core = exports['node7-core']:GetCoreObject()
```

## Included

- NODE7-core style folder layout.
- `@ox_lib/init.lua` shared import.
- ox_lib callbacks, locale, math, input, context-menu, and text-UI utilities.
- oxmysql player/bans database support.
- NODE7 naming/events/permissions.
- Compatibility exports used by current NODE7 player resources.
- Recipe files, GitHub workflow, `.gitignore`, `.gitattributes`, `.editorconfig`.

## Notes

This core does not require horses, spawnselect, charselect, clothing, or menu-base to start.


## Money accounts

`cash` is backed by the `dollar` and `cent` inventory items when `Node7Config.Money.EnableMoneyItems` is enabled. `bank` remains a persistent character balance in the players table. The legacy account names `valbank`, `rhobank`, `blkbank`, and `armbank` resolve to `bank` for compatibility.

```lua
local Node7Core = exports['node7-core']:GetCoreObject()
local Player = Node7Core.Functions.GetPlayer(source)

local cash = Player.Functions.GetMoney('cash')
local bank = Player.Functions.GetMoney('bank')

local deposited = Player.Functions.RemoveMoney('cash', 25.00, 'Bank deposit')
if deposited then
    Player.Functions.AddMoney('bank', 25.00, 'Bank deposit')
end
```

Server exports are also available: `GetMoney`, `AddMoney`, `RemoveMoney`, and `SetMoney`.

## NODE7 western notification UI

The core includes an actual transparent NUI under `html/`:

- `html/index.html`
- `html/style.css`
- `html/app.js`
- `html/images/default-portrait.png`

The visual matches the supplied left-side western alert reference: portrait on the left, bold title, wrapped message, dark brush-style transparent backing, slide animation, and a native RedM notification sound. It does not use `ox_lib:notify`. ox_lib remains available for callbacks, menus, inputs, locale, math, and other framework utilities.

Existing calls remain compatible:

```lua
-- Client
local Node7Core = exports['node7-core']:GetCoreObject()

Node7Core.Functions.Notify({
    title = 'BANK',
    description = 'Deposit completed.',
    type = 'success',
    duration = 5000,
})

exports['node7-core']:Notify('Insufficient cash.', 'error', 5000, 'BANK')

exports['node7-core']:NotifyAlert(
    'Your alert was sent! You can use /alertcancel if you do not need help anymore.',
    7000,
    'ALERT!!'
)

-- Server
Node7Core.Functions.Notify(source, {
    title = 'ALERT!!',
    description = 'Your alert was sent.',
    type = 'warning',
    duration = 5000,
})

-- Player object
local Player = Node7Core.Functions.GetPlayer(source)
Player.Functions.Notify('Your paycheck was deposited.', 'money', 5000, 'PAYCHECK')
```

A custom portrait may be supplied as an NUI-relative image path, `nui://` path, or web URL:

```lua
Node7Core.Functions.Notify({
    title = 'SHERIFF',
    description = 'A deputy is requesting assistance.',
    type = 'alert',
    image = 'images/default-portrait.png',
    duration = 7000,
})
```

Notification defaults, type titles, images, durations, and sounds are configured under `Node7Config.Notify`.

Run `/node7notifytest` in game to display the reference-style `ALERT!!` card with sound.
