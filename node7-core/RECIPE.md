# NODE7 Core Recipe

Start order:

```cfg
ensure ox_lib
ensure oxmysql
ensure node7-core
```

Import `recipe/node7-core.sql` or leave the resource to auto-create/update the required `players` and `bans` tables on first start.

Optional ACE lines are in `recipe/permissions.cfg`.


## Money and notifications

- `cash` uses the `dollar` and `cent` items supplied by NODE7 inventory.
- `bank` is the shared persistent personal bank account.
- Start order remains `ox_lib`, `oxmysql`, `node7-core`, then `node7-inventory`.
- NODE7 core notifications use native RedM left-side feed cards with icons and sound; ox_lib remains available for other systems.


## QBCore-style API layout

The core follows the supplied QBCore object/player/callback/export conventions under the `Node7Core` namespace. Keep the resource name `node7-core`. RedM items remain in `shared/items.lua` and are not replaced by the FiveM QBCore item list.
