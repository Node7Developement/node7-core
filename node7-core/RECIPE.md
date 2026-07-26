# NODE7 Core Recipe

Start order:

```cfg
ensure ox_lib
ensure oxmysql
ensure node7-core
```

Import `recipe/node7-core.sql` or leave the resource to auto-create/update the required `players` and `bans` tables on first start.

Optional ACE lines are in `recipe/permissions.cfg`.


## Money, medical metadata, and status display

- `cash`, `bank`, `gold`, and legacy `bloodmoney` are persisted by `node7-core`.
- Currency is not stored as inventory items and no inventory UI modification is included.
- Character metadata includes persistent `bloodtype` and `blood` level values.
- The core NUI renders a compact top-left cash, bank, gold, and blood-type display.
- Start order: `ox_lib`, `oxmysql`, `node7-core`, then `node7-inventory`.

## QBCore-style API layout

The core follows the supplied QBCore object/player/callback/export conventions under the `Node7Core` namespace. Keep the resource name `node7-core`. RedM items remain in `shared/items.lua` and are not replaced by the FiveM QBCore item list.
