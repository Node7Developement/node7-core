Node7Core.MoneyItems = Node7Core.MoneyItems or {}

local MoneyItems = Node7Core.MoneyItems
local initialized = {}
local operationLocks = {}

local itemAccounts = {
    cash = { dollar = 'dollar', cent = 'cent' },
    bloodmoney = { dollar = 'blood_dollar', cent = 'blood_cent' },
}

local function toCents(value)
    local number = tonumber(value)
    if not number or number ~= number or number == math.huge or number == -math.huge then return nil end
    return math.floor((number * 100) + 0.5)
end

local function fromCents(value)
    return tonumber(string.format('%.2f', (tonumber(value) or 0) / 100))
end

local function inventoryStarted()
    return GetResourceState('node7-inventory') == 'started'
end

local function getItemCount(playerData, itemName)
    local total = 0
    for _, item in pairs((playerData and playerData.items) or {}) do
        if item and item.name == itemName then
            total = total + math.max(0, math.floor(tonumber(item.amount) or 0))
        end
    end
    return total
end

local function getBalanceCents(playerData, moneytype)
    local mapping = itemAccounts[moneytype]
    if not mapping then return nil end
    return (getItemCount(playerData, mapping.dollar) * 100) + getItemCount(playerData, mapping.cent)
end

local function hasPhysicalMoney(playerData, moneytype)
    return (getBalanceCents(playerData, moneytype) or 0) > 0
end

local function addItem(src, itemName, amount, reason)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return true end
    if not inventoryStarted() then return false, 'inventory_not_started' end

    local ok, result = pcall(function()
        return exports['node7-inventory']:AddItem(
            src, itemName, amount, false, {}, reason or 'node7-core:money-add'
        )
    end)

    if not ok then
        print(('^1[node7-core]^7 node7-inventory AddItem failed: %s'):format(tostring(result)))
        return false, 'inventory_add_failed'
    end

    if result ~= true then return false, 'inventory_add_rejected' end
    return true
end

local function removeItem(src, itemName, amount, reason)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return true end
    if not inventoryStarted() then return false, 'inventory_not_started' end

    local ok, result = pcall(function()
        return exports['node7-inventory']:RemoveItem(
            src, itemName, amount, false, reason or 'node7-core:money-remove'
        )
    end)

    if not ok then
        print(('^1[node7-core]^7 node7-inventory RemoveItem failed: %s'):format(tostring(result)))
        return false, 'inventory_remove_failed'
    end

    if result ~= true then return false, 'inventory_remove_rejected' end
    return true
end

local function notifyInventory(src)
    if not src then return end
    local state = Player(src) and Player(src).state
    if state and state.inv_busy then
        TriggerClientEvent('node7-inventory:client:updateInventory', src)
    end
end

local function withLock(player, callback)
    local src = player and player.PlayerData and player.PlayerData.source
    if not src then return false, 'invalid_player' end
    if operationLocks[src] then return false, 'money_operation_busy' end

    operationLocks[src] = true
    local ok, success, result = pcall(callback)
    operationLocks[src] = nil

    if not ok then
        print(('^1[node7-core]^7 Money-item operation failed for player %s: %s'):format(src, tostring(success)))
        return false, 'money_item_operation_failed'
    end

    return success, result
end

function MoneyItems.IsItemType(moneytype)
    return Node7Core.Config.Money.EnableMoneyItems == true and itemAccounts[moneytype] ~= nil
end

function MoneyItems.GetBalance(player, moneytype)
    if not player or not player.PlayerData or not itemAccounts[moneytype] then return nil end
    if not inventoryStarted() and not initialized[player.PlayerData.citizenid] then return nil end
    return fromCents(getBalanceCents(player.PlayerData, moneytype) or 0)
end

function MoneyItems.SyncPlayerData(playerData)
    if not Node7Core.Config.Money.EnableMoneyItems or not playerData then return playerData end
    if not initialized[playerData.citizenid] then return playerData end

    playerData.money = playerData.money or {}
    for moneytype in pairs(itemAccounts) do
        playerData.money[moneytype] = fromCents(getBalanceCents(playerData, moneytype) or 0)
    end

    return playerData
end

-- Retained for the existing player update path.
SynchronizeMoneyItems = MoneyItems.SyncPlayerData

local function addPieces(player, moneytype, amount, reason)
    local mapping = itemAccounts[moneytype]
    local amountCents = toCents(amount)
    if not mapping or not amountCents or amountCents <= 0 then return false, 'invalid_amount' end
    if not inventoryStarted() then return false, 'inventory_not_started' end

    local src = player.PlayerData.source
    local before = getBalanceCents(player.PlayerData, moneytype) or 0
    local dollars = math.floor(amountCents / 100)
    local cents = amountCents % 100

    local dollarsAdded = false
    if dollars > 0 then
        local ok, err = addItem(src, mapping.dollar, dollars, reason or 'node7-core:money-add')
        if not ok then return false, err or 'cash_dollar_add_failed' end
        dollarsAdded = true
    end

    if cents > 0 then
        local ok, err = addItem(src, mapping.cent, cents, reason or 'node7-core:money-add')
        if not ok then
            if dollarsAdded then
                local rolledBack = removeItem(src, mapping.dollar, dollars, 'node7-core:money-add-rollback')
                if not rolledBack then
                    print(('^1[node7-core]^7 Failed to roll back %s dollar items for player %s.'):format(moneytype, src))
                end
            end
            return false, err or 'cash_cent_add_failed'
        end
    end

    local after = getBalanceCents(player.PlayerData, moneytype) or 0
    if after ~= before + amountCents then
        if cents > 0 then removeItem(src, mapping.cent, cents, 'node7-core:money-add-verify-rollback') end
        if dollars > 0 then removeItem(src, mapping.dollar, dollars, 'node7-core:money-add-verify-rollback') end
        return false, 'cash_balance_verification_failed'
    end

    notifyInventory(src)
    return true, fromCents(after)
end

local function removePieces(player, moneytype, amount, reason)
    local mapping = itemAccounts[moneytype]
    local requiredCents = toCents(amount)
    if not mapping or not requiredCents or requiredCents <= 0 then return false, 'invalid_amount' end
    if not inventoryStarted() then return false, 'inventory_not_started' end

    local src = player.PlayerData.source
    local availableDollars = getItemCount(player.PlayerData, mapping.dollar)
    local availableCents = getItemCount(player.PlayerData, mapping.cent)
    local before = (availableDollars * 100) + availableCents

    if before < requiredCents then return false, 'insufficient_funds' end

    local centsToRemove = math.min(availableCents, requiredCents)
    local remaining = requiredCents - centsToRemove
    local dollarsToRemove = remaining > 0 and math.ceil(remaining / 100) or 0
    local changeCents = (dollarsToRemove * 100) - remaining

    local removedCents = false
    if centsToRemove > 0 then
        local ok, err = removeItem(src, mapping.cent, centsToRemove, reason or 'node7-core:money-remove')
        if not ok then return false, err or 'cash_cent_remove_failed' end
        removedCents = true
    end

    local removedDollars = false
    if dollarsToRemove > 0 then
        local ok, err = removeItem(src, mapping.dollar, dollarsToRemove, reason or 'node7-core:money-remove')
        if not ok then
            if removedCents then addItem(src, mapping.cent, centsToRemove, 'node7-core:money-remove-rollback') end
            return false, err or 'cash_dollar_remove_failed'
        end
        removedDollars = true
    end

    if changeCents > 0 then
        local ok, err = addItem(src, mapping.cent, changeCents, 'node7-core:money-change')
        if not ok then
            if removedDollars then addItem(src, mapping.dollar, dollarsToRemove, 'node7-core:money-remove-rollback') end
            if removedCents then addItem(src, mapping.cent, centsToRemove, 'node7-core:money-remove-rollback') end
            return false, err or 'cash_change_add_failed'
        end
    end

    local after = getBalanceCents(player.PlayerData, moneytype) or 0
    if after ~= before - requiredCents then
        print(('^1[node7-core]^7 %s verification failed for player %s: before=%s expected=%s actual=%s'):format(moneytype, src, before, before - requiredCents, after))
        return false, 'cash_balance_verification_failed'
    end

    notifyInventory(src)
    return true, fromCents(after)
end

function MoneyItems.Add(player, moneytype, amount, reason)
    return withLock(player, function()
        return addPieces(player, moneytype, amount, reason)
    end)
end

function MoneyItems.Remove(player, moneytype, amount, reason)
    return withLock(player, function()
        return removePieces(player, moneytype, amount, reason)
    end)
end

function MoneyItems.Set(player, moneytype, amount, reason)
    local targetCents = toCents(amount)
    if not targetCents or targetCents < 0 then return false, 'invalid_amount' end

    local currentCents = getBalanceCents(player and player.PlayerData, moneytype)
    if currentCents == nil then return false, 'invalid_money_type' end
    if targetCents == currentCents then return true, fromCents(targetCents) end

    if targetCents > currentCents then
        return MoneyItems.Add(player, moneytype, fromCents(targetCents - currentCents), reason)
    end

    return MoneyItems.Remove(player, moneytype, fromCents(currentCents - targetCents), reason)
end

function MoneyItems.InitializePlayer(player)
    if not Node7Core.Config.Money.EnableMoneyItems then return true end
    if not player or not player.PlayerData then return false, 'invalid_player' end
    if not inventoryStarted() then return true, 'inventory_pending' end

    player.PlayerData.money = player.PlayerData.money or {}

    for moneytype in pairs(itemAccounts) do
        local actualCents = getBalanceCents(player.PlayerData, moneytype) or 0
        local persistedCents = toCents(player.PlayerData.money[moneytype]) or 0

        -- Existing physical items are authoritative. Persisted cash is used only
        -- to seed a character that has no physical money items yet.
        if actualCents == 0 and persistedCents > 0 and not hasPhysicalMoney(player.PlayerData, moneytype) then
            local ok, result = addPieces(player, moneytype, fromCents(persistedCents), 'node7-core:money-initialize')
            if not ok then
                print(('^1[node7-core]^7 Failed to initialize %s items for player %s: %s'):format(moneytype, player.PlayerData.source, tostring(result)))
                return false, result
            end
            actualCents = toCents(result) or persistedCents
        end

        player.PlayerData.money[moneytype] = fromCents(actualCents)
    end

    initialized[player.PlayerData.citizenid] = true
    MoneyItems.SyncPlayerData(player.PlayerData)
    return true
end

AddEventHandler('Node7Core:Server:OnPlayerUnload', function(src)
    local player = Node7Core.Functions.GetPlayer(src)
    if player and player.PlayerData then
        initialized[player.PlayerData.citizenid] = nil
    end
    operationLocks[src] = nil
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= 'node7-inventory' then return end
    CreateThread(function()
        Wait(500)
        for _, player in pairs(Node7Core.Players) do
            local ok = MoneyItems.InitializePlayer(player)
            if ok then player.Functions.UpdatePlayerData() end
        end
    end)
end)
