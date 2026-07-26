# node7-core

NODE7's RedM core with core-owned cash, bank, gold, blood-money, character metadata, ACE-protected administration, inventory compatibility, and a compact top-left account display.

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
ensure node7-inventory # inventory remains separate from core-owned currency
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

`cash`, `bank`, `gold`, and legacy `bloodmoney` are persistent balances owned by `node7-core`. Currency is not represented by inventory items and the core status display shows cash, bank, gold, and blood type.

```lua

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


## Native pause-menu UI handling

Every UI surface owned by `node7-core` is hidden while the native RedM pause menu is open and restored when gameplay resumes:

- Cash, bank, gold, character name, and blood-type status HUD.
- Western notification cards.
- NODE7 ox_lib text UI exports and events.
- NODE7 native prompt and prompt-group exports.
- NODE7 2D/3D text helpers and `/me` world text.

Configuration is available under `Node7Config.UI`:

```lua
Node7Config.UI = {
    HideDuringPauseMenu = true,
    PauseMenuPollMs = 100,
    PauseMenuOpenPollMs = 50,
}
```

Other NODE7 resources can check the shared state with:

```lua
local isOpen = exports['node7-core']:IsPauseMenuOpen()
```

## Administration

- `/givemoney [id] [cash|bank|gold|bloodmoney] [amount] [reason]`
- `/setmoney [id] [cash|bank|gold|bloodmoney] [amount] [reason]`
- `/removemoney [id] [cash|bank|gold|bloodmoney] [amount] [reason]`
- `/setbloodtype [id] [A+|A-|B+|B-|AB+|AB-|O+|O-]`
- `/balances`
- `/togglemoneyhud`

Use `recipe/permissions.cfg` for the exact ACE rules.


## Physical cash integration

`cash` is the only physical currency item. Start resources in this order:

```cfg
ensure node7-core
ensure node7-inventory
ensure node7-cashitem
ensure node7-banking
```

Core money calls remain authoritative:

```lua
local ok, balance = exports['node7-core']:AddPlayerMoney(source, 'cash', 25, 'reward')
local ok, balance = exports['node7-core']:RemovePlayerMoney(source, 'cash', 10, 'purchase')
local ok, balance = exports['node7-core']:SetPlayerMoney(source, 'cash', 100, 'admin-set')
local balance = exports['node7-core']:GetPlayerMoney(source, 'cash')
```

Cash is synchronized through `node7-cashitem` and remains a normal movable inventory stack.
