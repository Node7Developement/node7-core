local locks = {}

local function withLock(key, operation)
    if locks[key] then return false, 'inventory_busy' end
    locks[key] = true
    local result = table.pack(pcall(operation))
    locks[key] = nil
    if not result[1] then
        print(('^1[NODE7]^7 Inventory operation failed: %s'):format(result[2]))
        return false, 'inventory_error'
    end
    return table.unpack(result, 2, result.n)
end

local function getInventory(ownerType, ownerId, name)
    local inventory = MySQL.single.await([[
        SELECT * FROM node7_inventories WHERE owner_type = ? AND owner_id = ? AND name = ? LIMIT 1
    ]], { ownerType, tostring(ownerId), name })

    if inventory then return inventory end
    local id = MySQL.insert.await([[
        INSERT INTO node7_inventories (owner_type, owner_id, name, max_slots, max_weight)
        VALUES (?, ?, ?, ?, ?)
    ]], { ownerType, tostring(ownerId), name, Node7Config.Inventory.maxSlots, Node7Config.Inventory.maxWeight })
    return { id = id, owner_type = ownerType, owner_id = tostring(ownerId), name = name,
        max_slots = Node7Config.Inventory.maxSlots, max_weight = Node7Config.Inventory.maxWeight }
end

local function getPlayerInventory(source)
    local player = Node7.GetPlayer(source)
    if not player or not player.character then return nil end
    return getInventory('player', player.character.id, 'main')
end

local function inventoryItems(inventoryId)
    local rows = MySQL.query.await('SELECT * FROM node7_inventory_items WHERE inventory_id = ? ORDER BY slot ASC', { inventoryId }) or {}
    for _, row in ipairs(rows) do
        row.metadata = Node7Database.Decode(row.metadata, {})
        row.definition = Node7Items[row.item_name]
        if row.definition then
            row.name = row.item_name
            row.info = row.metadata
            row.label = row.definition.label
            row.description = row.definition.description or ''
            row.weight = row.definition.weight
            row.type = row.definition.type
            row.unique = row.definition.unique
            row.useable = row.definition.useable
            row.image = row.definition.image
            row.shouldClose = row.definition.shouldClose
            row.combinable = row.definition.combinable
        end
    end
    return rows
end

local function currentWeight(items)
    local weight = 0
    for _, row in ipairs(items) do
        local definition = Node7Items[row.item_name]
        if definition then weight = weight + (definition.weight * row.amount) end
    end
    return weight
end

local function nextSlot(items, maxSlots)
    local used = {}
    for _, row in ipairs(items) do used[row.slot] = true end
    for slot = 1, maxSlots do
        if not used[slot] then return slot end
    end
end

local function inventoryChanged(source)
    TriggerClientEvent('node7:client:inventoryChanged', source)
    if Node7.RefreshPlayerData then Node7.RefreshPlayerData(source, true) end
end

function Node7.GetInventory(source)
    local inventory = getPlayerInventory(source)
    if not inventory then return nil end
    local items = inventoryItems(inventory.id)
    return {
        id = inventory.id,
        name = inventory.name,
        maxSlots = inventory.max_slots,
        maxWeight = inventory.max_weight,
        weight = currentWeight(items),
        items = items
    }
end

function Node7.GetItemCount(source, itemName)
    local inventory = getPlayerInventory(source)
    if not inventory then return 0 end
    return MySQL.scalar.await([[
        SELECT COALESCE(SUM(amount), 0) FROM node7_inventory_items WHERE inventory_id = ? AND item_name = ?
    ]], { inventory.id, itemName }) or 0
end

function Node7.AddItem(source, itemName, amount, metadata, preferredSlot)
    local definition = Node7Items[itemName]
    local stackSize = definition and (definition.unique and 1 or math.max(1, math.floor(tonumber(definition.stack) or 100))) or 1
    amount = tonumber(amount)
    if not definition or not amount or amount < 1 or amount ~= math.floor(amount) or amount > Node7Config.Security.maxItemTransfer then
        return false, 'invalid_item'
    end
    if definition.unique and amount ~= 1 then return false, 'unique_item_amount' end

    local inventory = getPlayerInventory(source)
    if not inventory then return false, 'player_not_loaded' end
    return withLock(('inventory:%s'):format(inventory.id), function()
        local items = inventoryItems(inventory.id)
        if currentWeight(items) + (definition.weight * amount) > inventory.max_weight then
            return false, 'inventory_full'
        end

        local validatedMetadata, metadataError = Node7BuildItemMetadata(itemName, metadata)
        if not validatedMetadata then return false, metadataError end
        metadata = validatedMetadata
        local encodedMetadata = json.encode(metadata)
        local matching = {}
        local existingCapacity = 0
        if not definition.unique then
            for _, row in ipairs(items) do
                if row.item_name == itemName and json.encode(row.metadata) == encodedMetadata and row.amount < stackSize then
                    matching[#matching + 1] = row
                    existingCapacity = existingCapacity + (stackSize - row.amount)
                end
            end
        end

        local usedSlots = {}
        for _, row in ipairs(items) do usedSlots[row.slot] = true end
        local freeSlots = inventory.max_slots - #items
        local amountNeedingSlots = math.max(0, amount - existingCapacity)
        local requiredSlots = math.ceil(amountNeedingSlots / stackSize)
        if requiredSlots > freeSlots then return false, 'inventory_full' end

        local remaining = amount
        local firstSlot
        for _, row in ipairs(matching) do
            if remaining == 0 then break end
            local added = math.min(stackSize - row.amount, remaining)
            MySQL.update.await('UPDATE node7_inventory_items SET amount = amount + ? WHERE id = ?', { added, row.id })
            firstSlot = firstSlot or row.slot
            remaining = remaining - added
        end

        local durability = tonumber(metadata.durability) or definition.durability or 100
        local requestedSlot = tonumber(preferredSlot)
        while remaining > 0 do
            local slot
            if requestedSlot and requestedSlot >= 1 and requestedSlot <= inventory.max_slots and not usedSlots[requestedSlot] then
                slot = requestedSlot
                requestedSlot = nil
            else
                slot = nextSlot(items, inventory.max_slots)
            end
            if not slot then return false, 'inventory_full' end
            local stackAmount = math.min(stackSize, remaining)
            MySQL.insert.await([[
                INSERT INTO node7_inventory_items (inventory_id, slot, item_name, amount, metadata, durability)
                VALUES (?, ?, ?, ?, ?, ?)
            ]], { inventory.id, slot, itemName, stackAmount, encodedMetadata, durability })
            items[#items + 1] = { slot = slot }
            usedSlots[slot] = true
            firstSlot = firstSlot or slot
            remaining = remaining - stackAmount
        end
        inventoryChanged(source)
        return true, firstSlot
    end)
end

function Node7.RemoveItem(source, itemName, amount, slot)
    amount = tonumber(amount)
    if not Node7Items[itemName] or not amount or amount < 1 or amount ~= math.floor(amount) then return false end
    local inventory = getPlayerInventory(source)
    if not inventory then return false end

    return withLock(('inventory:%s'):format(inventory.id), function()
        local parameters = { inventory.id, itemName }
        local query = 'SELECT * FROM node7_inventory_items WHERE inventory_id = ? AND item_name = ?'
        if slot then
            query = query .. ' AND slot = ?'
            parameters[#parameters + 1] = tonumber(slot)
        end
        query = query .. ' ORDER BY amount ASC'
        local rows = MySQL.query.await(query, parameters) or {}
        local available = 0
        for _, row in ipairs(rows) do available = available + row.amount end
        if available < amount then return false, 'item_missing' end

        local remaining = amount
        for _, row in ipairs(rows) do
            local take = math.min(row.amount, remaining)
            if take == row.amount then
                MySQL.query.await('DELETE FROM node7_inventory_items WHERE id = ?', { row.id })
            else
                MySQL.update.await('UPDATE node7_inventory_items SET amount = amount - ? WHERE id = ?', { take, row.id })
            end
            remaining = remaining - take
            if remaining == 0 then break end
        end
        inventoryChanged(source)
        return true
    end)
end

function Node7.GiveWeapon(source, weaponName, ammo, metadata)
    local player = Node7.GetPlayer(source)
    local definition = Node7Weapons[weaponName]
    if not player or not player.character or not definition then return false end
    ammo = math.max(0, math.floor(tonumber(ammo) or 0))
    metadata = type(metadata) == 'table' and metadata or {}
    metadata.ownerCharacterId = player.character.id
    metadata.createdAt = metadata.createdAt or os.time()
    metadata.components = type(metadata.components) == 'table' and metadata.components or {}
    metadata.customName = metadata.customName or definition.label
    local serial = ('N7-%06d-%06d'):format(player.character.id, math.random(0, 999999))
    MySQL.insert.await([[
        INSERT INTO node7_weapons (character_id, weapon_name, serial, ammo_type, ammo, condition_value, metadata)
        VALUES (?, ?, ?, ?, ?, 100, ?)
    ]], { player.character.id, weaponName, serial, definition.ammo, ammo, json.encode(metadata) })
    TriggerClientEvent('node7:client:weaponGiven', source, weaponName, ammo, serial)
    Node7.Log(player.character.id, 'weapon_given', serial, { weapon = weaponName, ammo = ammo })
    return true, serial
end

function Node7.GetWeapons(source)
    local player = Node7.GetPlayer(source)
    if not player or not player.character then return {} end
    local weapons = MySQL.query.await('SELECT * FROM node7_weapons WHERE character_id = ?', { player.character.id }) or {}
    for _, weapon in ipairs(weapons) do weapon.metadata = Node7Database.Decode(weapon.metadata, {}) end
    return weapons
end

function Node7.RemoveWeapon(source, serial)
    local player = Node7.GetPlayer(source)
    if not player or not player.character or type(serial) ~= 'string' then return false end
    local changed = MySQL.update.await('DELETE FROM node7_weapons WHERE character_id = ? AND serial = ?', {
        player.character.id, serial
    })
    if changed and changed > 0 then TriggerClientEvent('node7:client:weaponRemoved', source, serial) end
    return changed and changed > 0
end

function Node7.AddAmmo(source, serial, amount)
    local player = Node7.GetPlayer(source)
    amount = tonumber(amount)
    if not player or not player.character or type(serial) ~= 'string' or not amount or amount <= 0 then return false end
    amount = math.floor(amount)
    local weapon = MySQL.single.await('SELECT * FROM node7_weapons WHERE character_id = ? AND serial = ? LIMIT 1', {
        player.character.id, serial
    })
    if not weapon then return false end
    local ammoDefinition = Node7AmmoTypes[weapon.ammo_type]
    local maximum = ammoDefinition and ammoDefinition.max or 200
    local nextAmount = math.min(maximum, weapon.ammo + amount)
    MySQL.update.await('UPDATE node7_weapons SET ammo = ? WHERE id = ?', { nextAmount, weapon.id })
    TriggerClientEvent('node7:client:weaponAmmoChanged', source, weapon.weapon_name, nextAmount)
    return true, nextAmount
end

function Node7.RemoveAmmo(source, serial, amount)
    local player = Node7.GetPlayer(source)
    amount = tonumber(amount)
    if not player or not player.character or type(serial) ~= 'string' or not amount or amount <= 0 then return false end
    amount = math.floor(amount)
    local weapon = MySQL.single.await('SELECT * FROM node7_weapons WHERE character_id = ? AND serial = ? LIMIT 1', {
        player.character.id, serial
    })
    if not weapon then return false end
    local nextAmount = math.max(0, weapon.ammo - amount)
    MySQL.update.await('UPDATE node7_weapons SET ammo = ? WHERE id = ?', { nextAmount, weapon.id })
    TriggerClientEvent('node7:client:weaponAmmoChanged', source, weapon.weapon_name, nextAmount)
    return true, nextAmount
end

RegisterNetEvent('node7:server:useItem', function(itemName, slot)
    local source = source
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
