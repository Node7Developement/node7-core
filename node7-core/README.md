# node7-core

NODE7 RedM framework core built in the same resource format as `node7-core`, with ox_lib and oxmysql support.

## Required start order

```cfg
ensure ox_lib
ensure oxmysql
ensure node7-core
```

## Main export

```lua
local Node7Core = exports['node7-core']:GetCoreObject()
```

## Included

- NODE7-core style folder layout.
- `@ox_lib/init.lua` shared import.
- ox_lib notifications/text UI usage.
- oxmysql player/bans database support.
- NODE7 naming/events/permissions.
- Compatibility exports used by current NODE7 player resources.
- Recipe files, GitHub workflow, `.gitignore`, `.gitattributes`, `.editorconfig`.

## Notes

This core does not require horses, spawnselect, charselect, clothing, or menu-base to start.
