
Node7Core.PhysicalCash = Node7Core.PhysicalCash or {}

local PhysicalCash = Node7Core.PhysicalCash

local function settings()
    return (Node7Core.Config.Money and Node7Core.Config.Money.PhysicalCash) or {}
end

local function resourceName()
    return tostring(settings().Resource or 'node7-cashitem')
end

function PhysicalCash.IsEnabled()
    return settings().Enabled ~= false
end

function PhysicalCash.IsCashAccount(account)
    return account == 'cash' and PhysicalCash.IsEnabled()
end

function PhysicalCash.IsReady()
    return GetResourceState(resourceName()) == 'started'
end

function PhysicalCash.NormalizeAmount(amount, allowZero)
    local number = tonumber(amount)
    if not number or number ~= number or number == math.huge or number == -math.huge then
        return nil, 'invalid_amount'
    end

    if settings().WholeAmountsOnly ~= false and number % 1 ~= 0 then
        return nil, 'cash_requires_whole_amount'
    end

    number = math.floor(number)
    if number < 0 or (not allowZero and number == 0) then
        return nil, 'invalid_amount'
    end

    local maxAmount = tonumber(Node7Core.Config.Money.MaxTransactionAmount) or 100000000
    if number > maxAmount then return nil, 'amount_too_large' end
    return number
end

local function unavailable()
    return false, 'cashitem_not_started'
end

function PhysicalCash.Get(source)
    if not PhysicalCash.IsReady() then return unavailable() end
    local ok, balance, err = pcall(function()
        return exports['node7-cashitem']:GetCash(source)
    end)
    if not ok then
        print(('^1[node7-core]^7 node7-cashitem GetCash failed: %s'):format(tostring(balance)))
        return false, 'cashitem_export_failed'
    end
    if balance == false or balance == nil then return false, err or 'cashitem_get_failed' end
    return true, tonumber(balance) or 0
end

function PhysicalCash.Add(source, amount, reason)
    if not PhysicalCash.IsReady() then return unavailable() end
    local ok, success, result = pcall(function()
        return exports['node7-cashitem']:AddCash(source, amount, reason)
    end)
    if not ok then
        print(('^1[node7-core]^7 node7-cashitem AddCash failed: %s'):format(tostring(success)))
        return false, 'cashitem_export_failed'
    end
    return success == true, result
end

function PhysicalCash.Remove(source, amount, reason)
    if not PhysicalCash.IsReady() then return unavailable() end
    local ok, success, result = pcall(function()
        return exports['node7-cashitem']:RemoveCash(source, amount, reason)
    end)
    if not ok then
        print(('^1[node7-core]^7 node7-cashitem RemoveCash failed: %s'):format(tostring(success)))
        return false, 'cashitem_export_failed'
    end
    return success == true, result
end

function PhysicalCash.Set(source, amount, reason)
    if not PhysicalCash.IsReady() then return unavailable() end
    local ok, success, result = pcall(function()
        return exports['node7-cashitem']:SetCash(source, amount, reason)
    end)
    if not ok then
        print(('^1[node7-core]^7 node7-cashitem SetCash failed: %s'):format(tostring(success)))
        return false, 'cashitem_export_failed'
    end
    return success == true, result
end
