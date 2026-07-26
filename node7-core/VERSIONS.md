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
