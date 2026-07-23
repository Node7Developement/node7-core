local locks = {}

local function clone(value, seen)
    if type(value) ~= 'table' then return value end
    seen = seen or {}
    if seen[value] then return seen[value] end
    local copy = {}
    seen[value] = copy
    for key, entry in pairs(value) do copy[clone(key, seen)] = clone(entry, seen) end
    return copy
end

local function encode(value)
    local ok, result = pcall(json.encode, value or {})
    return ok and result or '{}'
end

local function withLock(key, operation)
    if locks[key] then return false, 'inventory_busy' end
    locks[key] = true
    local result = table.pack(pcall(operation))
    locks[key] = nil
    if not result[1] then
        print(('^1[NODE7]^7 Inventory operation failed: %s'):format(tostring(result[2])))
        return false, 'inventory_error'
    end
    return table.unpack(result, 2, result.n)
end

local function getPlayerInventoryTable(source)
    local player = Node7.GetPlayer(source)
    if not player or not player.character then return nil, nil end
    player.character.inventory = type(player.character.inventory) == 'table' and player.character.inventory or {}
    return player.character.inventory, player
end

local function decorateItem(row)
    row.name = row.name or row.item_name
    row.item_name = row.item_name or row.name
    row.amount = math.max(0, math.floor(tonumber(row.amount) or 0))
    row.slot = math.max(1, math.floor(tonumber(row.slot) or 1))
    row.metadata = type(row.metadata) == 'table' and row.metadata or (type(row.info) == 'table' and row.info or {})
    row.info = row.metadata
    local definition = Node7Items[row.item_name]
    row.definition = definition
    if definition then
        row.label = definition.label
        row.description = definition.description or ''
        row.weight = definition.weight
        row.type = definition.type
        row.unique = definition.unique
        row.useable = definition.useable or definition.usable
        row.image = definition.image
        row.shouldClose = definition.shouldClose
        row.combinable = definition.combinable
    end
    return row
end

local function sortedItems(items)
    local result = {}
    for _, row in pairs(items or {}) do
        if type(row) == 'table' and (row.item_name or row.name) and tonumber(row.amount) and tonumber(row.amount) > 0 then
            result[#result + 1] = decorateItem(clone(row))
        end
    end
    table.sort(result, function(a, b) return (tonumber(a.slot) or 0) < (tonumber(b.slot) or 0) end)
    return result
end

local function currentWeight(items)
    local weight = 0
    for _, row in ipairs(items) do
        local definition = Node7Items[row.item_name]
        if definition then weight = weight + ((definition.weight or 0) * (tonumber(row.amount) or 0)) end
    end
    return weight
end

local function usedSlots(items)
    local used = {}
    for _, row in ipairs(items) do used[tonumber(row.slot)] = true end
    return used
end

local function nextSlot(items, maxSlots)
    local used = usedSlots(items)
    for slot = 1, maxSlots do
        if not used[slot] then return slot end
    end
end

local function saveInventory(source)
    local inventory, player = getPlayerInventoryTable(source)
    if not inventory then return false end
    player.character.inventory = sortedItems(inventory)
    Node7.RefreshPlayerData(source, true, true)
    Node7.MarkPlayerDirty(source)
    TriggerClientEvent('node7:client:inventoryChanged', source)
    return true
end

function Node7.GetInventory(source)
    local inventory = getPlayerInventoryTable(source)
    if not inventory then return nil end
    local items = sortedItems(inventory)
    return {
        id = tostring(source),
        name = Node7Config.Inventory.defaultName or 'main',
        maxSlots = Node7Config.Inventory.maxSlots,
        maxWeight = Node7Config.Inventory.maxWeight,
        weight = currentWeight(items),
        items = items
    }
end

function Node7.GetItemCount(source, itemName)
    local inventory = getPlayerInventoryTable(source)
    if not inventory or type(itemName) ~= 'string' then return 0 end
    local total = 0
    for _, row in ipairs(sortedItems(inventory)) do
        if row.item_name == itemName then total = total + (tonumber(row.amount) or 0) end
    end
    return total
end

function Node7.AddItem(source, itemName, amount, metadata, preferredSlot)
    local definition = Node7Items[itemName]
    local stackSize = definition and (definition.unique and 1 or math.max(1, math.floor(tonumber(definition.stack) or 100))) or 1
    amount = tonumber(amount)
    if not definition or not amount or amount < 1 or amount ~= math.floor(amount) or amount > Node7Config.Security.maxItemTransfer then
        return false, 'invalid_item'
    end
    if definition.unique and amount ~= 1 then return false, 'unique_item_amount' end

    local inventory = getPlayerInventoryTable(source)
    if not inventory then return false, 'player_not_loaded' end

    return withLock(('inventory:%s'):format(source), function()
        local items = sortedItems(inventory)
        if currentWeight(items) + ((definition.weight or 0) * amount) > Node7Config.Inventory.maxWeight then
            return false, 'inventory_full'
        end

        local validatedMetadata, metadataError = Node7BuildItemMetadata(itemName, metadata)
        if not validatedMetadata then return false, metadataError end
        metadata = validatedMetadata
        local encodedMetadata = encode(metadata)
        local remaining = amount
        local firstSlot

        if not definition.unique then
            for _, row in ipairs(inventory) do
                row = decorateItem(row)
                if row.item_name == itemName and encode(row.metadata) == encodedMetadata and row.amount < stackSize then
                    local add = math.min(stackSize - row.amount, remaining)
                    row.amount = row.amount + add
                    firstSlot = firstSlot or row.slot
                    remaining = remaining - add
                    if remaining <= 0 then break end
                end
            end
        end

        local snapshot = sortedItems(inventory)
        local freeSlots = Node7Config.Inventory.maxSlots - #snapshot
        local requiredSlots = math.ceil(remaining / stackSize)
        if requiredSlots > freeSlots then return false, 'inventory_full' end

        local taken = usedSlots(snapshot)
        local requestedSlot = tonumber(preferredSlot)

        while remaining > 0 do
            local slot
            if requestedSlot and requestedSlot >= 1 and requestedSlot <= Node7Config.Inventory.maxSlots and not taken[requestedSlot] then
                slot = requestedSlot
                requestedSlot = nil
            else
                slot = nextSlot(snapshot, Node7Config.Inventory.maxSlots)
            end
            if not slot then return false, 'inventory_full' end
            local stackAmount = math.min(stackSize, remaining)
            local row = {
                slot = slot,
                item_name = itemName,
                name = itemName,
                amount = stackAmount,
                metadata = clone(metadata),
                info = clone(metadata),
                durability = tonumber(metadata.durability) or definition.durability or 100
            }
            inventory[#inventory + 1] = row
            snapshot[#snapshot + 1] = decorateItem(clone(row))
            taken[slot] = true
            firstSlot = firstSlot or slot
            remaining = remaining - stackAmount
        end

        saveInventory(source)
        return true, firstSlot
    end)
end

function Node7.RemoveItem(source, itemName, amount, slot)
    amount = tonumber(amount)
    if not Node7Items[itemName] or not amount or amount < 1 or amount ~= math.floor(amount) then return false, 'invalid_item' end
    local inventory = getPlayerInventoryTable(source)
    if not inventory then return false, 'player_not_loaded' end

    return withLock(('inventory:%s'):format(source), function()
        local available = 0
        local targetSlot = tonumber(slot)
        for _, row in ipairs(inventory) do
            decorateItem(row)
            if row.item_name == itemName and (not targetSlot or tonumber(row.slot) == targetSlot) then
                available = available + row.amount
            end
        end
        if available < amount then return false, 'item_missing' end

        local remaining = amount
        table.sort(inventory, function(a, b) return (tonumber(a.amount) or 0) < (tonumber(b.amount) or 0) end)
        for index = #inventory, 1, -1 do
            local row = decorateItem(inventory[index])
            if row.item_name == itemName and (not targetSlot or tonumber(row.slot) == targetSlot) then
                local take = math.min(row.amount, remaining)
                row.amount = row.amount - take
                remaining = remaining - take
                if row.amount <= 0 then table.remove(inventory, index) end
                if remaining <= 0 then break end
            end
        end

        saveInventory(source)
        return true
    end)
end

function Node7.GiveWeapon(source, weaponName, ammo, metadata)
    local player = Node7.GetPlayer(source)
    local definition = Node7Weapons[weaponName]
    if not player or not player.character or not definition then return false, 'invalid_weapon' end
    player.character.weapons = type(player.character.weapons) == 'table' and player.character.weapons or {}
    ammo = math.max(0, math.floor(tonumber(ammo) or 0))
    metadata = type(metadata) == 'table' and clone(metadata) or {}
    local serial = metadata.serial or ('N7-%s-%06d'):format(tostring(player.character.citizenid):gsub('%W', ''), math.random(0, 999999))
    local weapon = {
        id = serial,
        character_id = player.character.citizenid,
        weapon_name = weaponName,
        name = weaponName,
        serial = serial,
        ammo_type = definition.ammo,
        ammo = ammo,
        condition_value = tonumber(metadata.condition_value or metadata.condition) or 100,
        metadata = metadata
    }
    player.character.weapons[#player.character.weapons + 1] = weapon
    Node7.RefreshPlayerData(source, true, true)
    Node7.MarkPlayerDirty(source)
    TriggerClientEvent('node7:client:weaponGiven', source, weaponName, ammo, serial)
    Node7.Log(player.character.citizenid, 'weapon_given', serial, { weapon = weaponName, ammo = ammo })
    return true, serial
end

function Node7.GetWeapons(source)
    local player = Node7.GetPlayer(source)
    if not player or not player.character then return {} end
    player.character.weapons = type(player.character.weapons) == 'table' and player.character.weapons or {}
    return clone(player.character.weapons)
end

function Node7.RemoveWeapon(source, serial)
    local player = Node7.GetPlayer(source)
    if not player or not player.character or type(serial) ~= 'string' then return false, 'invalid_weapon' end
    player.character.weapons = type(player.character.weapons) == 'table' and player.character.weapons or {}
    for index, weapon in ipairs(player.character.weapons) do
        if tostring(weapon.serial) == serial then
            table.remove(player.character.weapons, index)
            Node7.RefreshPlayerData(source, true, true)
            Node7.MarkPlayerDirty(source)
            TriggerClientEvent('node7:client:weaponRemoved', source, serial)
            return true
        end
    end
    return false, 'weapon_not_found'
end

local function changeAmmo(source, serial, amount)
    local player = Node7.GetPlayer(source)
    amount = tonumber(amount)
    if not player or not player.character or type(serial) ~= 'string' or not amount then return false, 'invalid_ammo' end
    amount = math.floor(amount)
    player.character.weapons = type(player.character.weapons) == 'table' and player.character.weapons or {}
    for _, weapon in ipairs(player.character.weapons) do
        if tostring(weapon.serial) == serial then
            local ammoDefinition = Node7AmmoTypes[weapon.ammo_type]
            local maximum = ammoDefinition and ammoDefinition.max or 200
            weapon.ammo = math.max(0, math.min(maximum, (tonumber(weapon.ammo) or 0) + amount))
            Node7.RefreshPlayerData(source, true, true)
            Node7.MarkPlayerDirty(source)
            TriggerClientEvent('node7:client:weaponAmmoChanged', source, weapon.weapon_name, weapon.ammo)
            return true, weapon.ammo
        end
    end
    return false, 'weapon_not_found'
end

function Node7.AddAmmo(source, serial, amount)
    amount = math.abs(math.floor(tonumber(amount) or 0))
    if amount <= 0 then return false, 'invalid_ammo' end
    return changeAmmo(source, serial, amount)
end

function Node7.RemoveAmmo(source, serial, amount)
    amount = math.abs(math.floor(tonumber(amount) or 0))
    if amount <= 0 then return false, 'invalid_ammo' end
    return changeAmmo(source, serial, -amount)
end

RegisterNetEvent('node7:server:useItem', function(itemName, slot)
    local handler = Node7.UsableItems[itemName]
    if not handler or Node7.GetItemCount(source, itemName) < 1 then return end
    handler(source, tonumber(slot))
end)

Node7.RegisterCallback('inventory:get', function(source, cb)
    cb(Node7.GetInventory(source))
end)

Node7.RegisterCallback('inventory:hasItem', function(source, cb, itemName, amount)
    if type(itemName) ~= 'string' then cb(false) return end
    cb(Node7.GetItemCount(source, itemName) >= math.max(1, math.floor(tonumber(amount) or 1)))
end)

Node7.RegisterCallback('weapons:get', function(source, cb)
    cb(Node7.GetWeapons(source))
end)

for itemName, definition in pairs(Node7Items) do
    if (definition.useable or definition.usable) and next(definition.effects or {}) then
        local registeredName, registeredDefinition = itemName, definition
        Node7.RegisterUsableItem(registeredName, function(source, slot)
            if not Node7.RemoveItem(source, registeredName, 1, slot) then return end
            local player = Node7.GetPlayer(source)
            if not player or not player.character then return end
            local metadata = player.character.metadata
            local effects = registeredDefinition.effects
            if effects.hunger then metadata.hunger = math.min(100, math.max(0, (metadata.hunger or 100) + effects.hunger)) end
            if effects.thirst then metadata.thirst = math.min(100, math.max(0, (metadata.thirst or 100) + effects.thirst)) end
            if effects.stress then metadata.stress = math.min(100, math.max(0, (metadata.stress or 0) + effects.stress)) end
            if effects.alcohol then metadata.alcohol = math.min(100, math.max(0, (metadata.alcohol or 0) + effects.alcohol)) end
            TriggerClientEvent('node7:client:applyItemEffects', source, effects)
            TriggerClientEvent('node7:client:statusChanged', source, metadata)
            Node7.Notify(source, ('Used %s.'):format(registeredDefinition.label), 'success')
            Node7.MarkPlayerDirty(source)
        end)
    end
end

exports('GetInventory', Node7.GetInventory)
exports('GetItemCount', Node7.GetItemCount)
exports('GiveItem', Node7.AddItem)
exports('RemoveItem', Node7.RemoveItem)
exports('RegisterUsableItem', Node7.RegisterUsableItem)
exports('GiveWeapon', Node7.GiveWeapon)
exports('GetOwnedWeapons', Node7.GetWeapons)
exports('RemoveWeapon', Node7.RemoveWeapon)
exports('AddAmmo', Node7.AddAmmo)
exports('RemoveAmmo', Node7.RemoveAmmo)
