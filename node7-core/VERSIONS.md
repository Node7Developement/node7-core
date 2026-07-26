# 2.6.2-node7.9

- Fixed RedM native map/pause detection by checking both `IsPauseMenuActive()` and `GetPauseMenuState()`.
- Hides the core NUI immediately when ESC/O requests the native frontend.
- Force-hides the complete HTML root while paused so the account HUD cannot render above the map.
- No inventory, banking, money, or CSRF behavior was changed.

# 2.6.1-node7.8

- Fixed concurrent NUI CSRF token validation.
- Stale UI tokens are rejected without disconnecting legitimate players.

## 2.5.1-node7.6

- Added centralized native pause-menu detection for all NODE7 core-owned UI.
- Hides the cash/bank/gold HUD and western notifications while the pause menu is open.
- Temporarily hides ox_lib text UI and restores it cleanly when gameplay resumes.
- Disables individual prompts, prompt groups, exported 2D/3D text, and `/me` text during pause.
- Added configurable pause detection intervals and a client `IsPauseMenuOpen` export.

## 2.5.0-node7.5

- Moved cash, bank, gold, and blood-money ownership fully into node7-core persistence.
- Disabled and unloaded inventory-backed currency without changing node7-inventory.
- Added validated give, set, and remove money commands with exact ACE permissions.
- Added persistent blood type and blood-level metadata plus exports and an admin command.
- Added the compact NODE7 top-left account and blood-type display.
- Removed runtime add_ace execution to prevent console access-denied errors.
- Added immediate database persistence for successful money changes.

## 2.4.0-node7.4
- Fixed notification NUI transparency and removed the inactive full-screen black canvas/flash.
- NUI body remains hidden until a notification is actively displayed.

# 2.4.0-node7.3

- Added the actual transparent western notification NUI under `html/`.
- Added the supplied reference portrait as the default notification portrait.
- Wired `Notify`, `NotifyLeft`, and `NotifyAlert` to `SendNUIMessage` while preserving all existing client, server, export, event, and player-object call signatures.
- Kept native RedM notification sounds without using `ox_lib:notify`.
- Preserved the QBCore-style Node7 API and all RedM items.

# 2.4.0-node7.2

- Restored and repaired the native RedM left-side notification card after the QBCore-style rebuild.
- Fixed the DataView 64-bit pointer packing that prevented the native card from rendering reliably.
- Fixed the frontend sound native argument order.
- Added NotifyAlert client/server exports, events, and player-object support for the supplied ALERT-style reference.
- Preserved all RedM items and the QBCore-style Node7 API.

## 2.4.0-node7.1

- Rebuilt bootstrap, shared API, callbacks, player lookup indexes, and player exports around the supplied QBCore 1.3.0 conventions.
- Preserved all NODE7 RedM items and RedM-specific systems.
- Added filtered `GetCoreObject`, `GetShared`, awaitable callbacks, direct player exports, and `PlayersByCitizenId`.

# 2.3.10-node7.6

- Fixed the native notification implementation to use the standard RedM left-side feed card shown in the supplied reference.
- Added native frontend notification sounds without ox_lib or NUI.
- Added client/server `NotifyLeft` exports and player-object support.
- Added `/node7notifytest` for immediate in-game verification.

# Versions

## 2.3.10-node7.5

- Replaced the custom notification NUI with native RedM left-side feed cards.
- Added native icon, color, duration, secondary text, and transaction-feed sound configuration.
- Preserved existing client, server, export, event, and player-object Notify call signatures.
- Added `NotifyLeft` for fully customized native cards.
- Added DataView support required by RedM native UI feed structures.
- Kept ox_lib enabled for callbacks, locale, math, inputs, context menus, and other framework utilities.
- Removed the obsolete notification HTML, CSS, JavaScript, ui_page, and file entries.

## 2.3.10-node7.4

- Core cash operations now call the verified node7-inventory AddItem and RemoveItem exports directly, removing player-method event-order failures.
- Rebuilt cash as a true inventory-backed account while keeping bank as the persistent character account.
- Added atomic AddMoney, RemoveMoney, SetMoney, and GetMoney behavior with validation and rollback-safe cash item changes.
- Added legacy branch account aliases that resolve to the shared `bank` account.
- Added the built-in NODE7 top-screen notification NUI and removed ox_lib notifications from core messages.
- Kept ox_lib enabled for callbacks, locale, math, input, context menus, and other framework utilities.

## 2.3.10-node7.1

- Converted from uploaded NODE7 core format.
- Renamed to `node7-core`.
- Added proper ox_lib dependency/init.
- Added NODE7 permission namespace.
- Added database bootstrap for players/bans.
- Added NODE7 compatibility exports.
- Removed hard reliance on horses.


## 2.6.0-node7.7

- Replaced legacy `dollar` and `cent` items with one physical `cash` item.
- Added the `node7-cashitem` bridge for SetMoney/AddMoney/RemoveMoney/GetMoney.
- Added canonical player-money exports and secure inventory-to-core synchronization.
- Hardened native pause-menu UI hiding with per-frame detection and direct NUI suppression.
