local accounts = { cash = true, bank = true, gold = true }

local function validAmount(amount)
    amount = tonumber(amount)
    if not amount or amount ~= math.floor(amount) or amount <= 0 then return nil end
    return amount
end

local function changed(source, account, amount)
    local player = Node7.GetPlayer(source)
    if not player or not player.character then return end
    Node7.RefreshPlayerData(source, false, true)
    Node7.MarkPlayerDirty(source)
    TriggerClientEvent('node7:client:moneyChanged', source, player.character.money, account, amount)
    TriggerClientEvent('Node7:Client:OnMoneyChange', source, account, math.abs(tonumber(amount) or 0), (tonumber(amount) or 0) < 0)
end

function Node7.GetMoney(source, account)
    local player = Node7.GetPlayer(source)
    if not player or not player.character or not accounts[account] then return nil end
    return player.character.money[account] or 0
end

function Node7.AddMoney(source, account, amount, reason)
    local player = Node7.GetPlayer(source)
    amount = validAmount(amount)
    if not player or not player.character or not accounts[account] or not amount then return false, 'invalid_money' end

    local balance = (player.character.money[account] or 0) + amount
    player.character.money[account] = balance
    Node7.Log(player.character.citizenid, 'money_add', account, { amount = amount, reason = reason or 'unspecified', balance = balance })
    changed(source, account, amount)
    return true, balance
end

function Node7.RemoveMoney(source, account, amount, reason)
    local player = Node7.GetPlayer(source)
    amount = validAmount(amount)
    if not player or not player.character or not accounts[account] or not amount then return false, 'invalid_money' end
    if (player.character.money[account] or 0) < amount then return false, 'not_enough_money' end

    local balance = player.character.money[account] - amount
    player.character.money[account] = balance
    Node7.Log(player.character.citizenid, 'money_remove', account, { amount = amount, reason = reason or 'unspecified', balance = balance })
    changed(source, account, -amount)
    return true, balance
end

function Node7.SetMoney(source, account, amount, reason)
    local player = Node7.GetPlayer(source)
    amount = tonumber(amount)
    if not player or not player.character or not accounts[account] or not amount or amount < 0 then return false, 'invalid_money' end
    amount = math.floor(amount)
    local previous = player.character.money[account] or 0
    local difference = amount - previous
    player.character.money[account] = amount
    Node7.Log(player.character.citizenid, 'money_set', account, { amount = amount, reason = reason or 'set' })
    changed(source, account, difference)
    return true, amount
end

function Node7.TransferMoney(source, targetSource, account, amount, reason)
    amount = validAmount(amount)
    targetSource = tonumber(targetSource)
    if not amount or amount > Node7Config.Security.maxMoneyTransfer or source == targetSource then return false, 'invalid_transfer' end
    local sender, receiver = Node7.GetPlayer(source), Node7.GetPlayer(targetSource)
    if not sender or not receiver or not sender.character or not receiver.character then return false, 'player_not_loaded' end
    local removed = Node7.RemoveMoney(source, account, amount, reason or 'player_transfer')
    if not removed then return false, 'not_enough_money' end
    local added = Node7.AddMoney(targetSource, account, amount, reason or 'player_transfer')
    if not added then
        Node7.AddMoney(source, account, amount, 'transfer_rollback')
        return false, 'transfer_failed'
    end
    return true, amount
end

exports('GetMoney', Node7.GetMoney)
exports('AddMoney', Node7.AddMoney)
exports('RemoveMoney', Node7.RemoveMoney)
exports('SetMoney', Node7.SetMoney)
exports('TransferMoney', Node7.TransferMoney)
