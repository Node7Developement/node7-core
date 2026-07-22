# Changelog

## 1.3.5

- Removed the built-in top-right HUD only.
- Replaced the Core NUI JavaScript with a syntax-safe HUD-free implementation.
- Preserved notifications, progress bars, draw text, and pause handling.
- Did not modify player loading, character lifecycle, spawning, saving,
  state bags, callbacks, exports, server logic, or client loops.


## 1.3.4

- Added forced cleanup messages for cached legacy Core startup, character, and inventory interfaces.
- Hard-disabled every legacy full-screen Core selector and inventory layer in CSS.
- Made legacy cleanup safe when the removed elements do not exist.
- Kept Core notifications, progress, HUD, and draw-text components unchanged.

## 1.3.3

- Removed the full-screen Core startup overlay and its black background.
- Removed the startup NUI message, configuration flag, and loading delay.
- Prevented Core from covering multicharacter, appearance, and spawn presentation.
- Kept notifications, progress, HUD, and draw-text UI components intact.

## 1.3.2

- Added the server-authoritative `SetAppearance` export for standalone appearance resources.
- Validated and size-limited appearance metadata before persisting it to the character record.
- Added appearance-change events without adding any character-creator or clothing UI to Core.

## 1.3.1

- Fixed cross-resource `CreateCallback` registration used by `node7-multicharacter`.
- Added argument normalization for both Cfx export invocation forms.
- Added support for callable cross-resource function references.
- Added the QBR-style `Core.Functions.CreateCallback` alias.
- Applied the same safe export handling to `CreateUseableItem`.

## 1.3.0

- Removed the complete built-in multicharacter interface from NODE7 Core.
- Removed character NUI callbacks and automatic character-selector opening from the core client.
- Removed core NUI focus changes that interfered with `node7-multicharacter`.
- Kept player accounts, character persistence, character creation/select/delete callbacks, validation, ownership, loading, and player state in NODE7 Core.
- Reserved all character presentation and selection controls for the separate `node7-multicharacter` resource.

## 1.2.0

- Removed the inventory interface, inventory key mapping, inventory command, and inventory NUI callbacks from NODE7 Core.
- Kept server-authoritative inventory persistence, validation, metadata, usable items, callbacks, events, and exports in the core logic layer.
- Reserved inventory presentation and controls for the separate `node7-inventory` resource.
- Eliminated the `RegisterKeyMapping` startup path from NODE7 Core completely.
- Added native pause-menu detection and automatic hiding/restoration for the complete NODE7 Core NUI layer.

## 1.1.1

- Fixed the RedM client crash caused by calling an unavailable `RegisterKeyMapping` global.
- Added a capability check before registering the optional `I` inventory bind.
- Added `/inventory` as a reliable fallback command on artifacts without key-mapping support.
- Added configurable inventory command, key-mapping toggle, and default key settings.
- Added a user-facing inventory load failure notification.

## 1.1.0

- Replaced generated `define()` item entries with the attached QBR literal item-table format.
- Included the complete attached QBR item registry plus NODE7 identity, horse-deed, and wagon-deed items.
- Replaced `normalizeJob()` definitions with literal QBR-style jobs and string grade keys.
- Replaced generated gang definitions with literal QBR-style gangs and string grade keys.
- Updated inventory and organization runtime logic to consume the literal format directly.

## 1.0.0

- Reorganized the resource around the attached QBR Core source layout.
- Added `client/functions.lua`, `loops.lua`, `events.lua`, `drawtxt.lua`, and `prompts.lua` entry points.
- Added `server/debug.lua`, `functions.lua`, `player.lua`, `events.lua`, `commands.lua`, and `exports.lua` entry points.
- Split horse and vehicle definitions into `shared/horse.lua` and `shared/vehicles.lua`.
- Changed registry declarations to direct `Node7Shared.Items`, `Jobs`, `Gangs`, `Horses`, `Vehicles`, `Weapons`, and `AmmoTypes` tables.
- Added QBR-style client helpers for player data, coordinates, item checks, progress bars, prompts, and draw text.
- Preserved NODE7 persistence, metadata validation, inventory, economy, weapons, organizations, stables, commands, UI, and database schema.

## 0.3.0

- Reworked the public API around a QBR-style `GetCoreObject()` and `Shared` registry layout.
- Added `Items`, `Jobs`, `Gangs`, `Horses`, `Vehicles`, `Weapons`, and `AmmoTypes` shared tables.
- Added QBR-style single and bulk registry exports with live client synchronization.
- Added QBR-style `PlayerData` and per-player `Functions` compatibility objects.
- Added QBR field aliases including `useable`, `shouldClose`, `payment`, and `isboss`.
- Expanded native weapon and ammunition definitions and added ammunition commands/APIs.
- Kept NODE7 metadata schemas, server authority, persistence, validation, and audit behavior.

## 0.2.0

- Added 42 structured default items with effects and validated metadata schemas.
- Added six configured jobs with grades, salaries, duty rules, permissions, and metadata.
- Added five configured gangs with ranks, permissions, accounts, storage, limits, and territory metadata.
- Added 72 horse models and 42 wagon models to the stable registries.
- Added persistent horse and wagon ownership, active selection, spawning, dismissal, and deeds.
- Added `/car`, stable administration commands, registry commands, and unprefixed administration aliases.
- Added organization account APIs, job/gang permission helpers, and automatic paychecks.
- Improved inventory stacking, unique-item enforcement, and metadata validation.

## 0.1.0

- Initial NODE7 Core foundation.
