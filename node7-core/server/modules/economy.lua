local accounts = { cash = true, bank = true, gold = true }

local function validAmount(amount)
    amount = tonumber(amount)
    if not amount or amount ~= math.floor(amount) or amount <= 0 then return nil end
    return amount
end

function Node7.GetMoney(source, account)
    local player = Node7.GetPlayer(source)
    if not player or not player.character or not accounts[account] then return nil end
    return player.character.money[account]
end

function Node7.AddMoney(source, account, amount, reason)
    local player = Node7.GetPlayer(source)
    amount = validAmount(amount)
    if not player or not player.character or not accounts[account] or not amount then return false end

    local balance = player.character.money[account] + amount
    player.character.money[account] = balance
    Node7Database.Transaction(player.character.id, account, amount, reason or 'unspecified', balance)
    TriggerClientEvent('node7:client:moneyChanged', source, player.character.money, account, amount)
    TriggerClientEvent('Node7:Client:OnMoneyChange', source, account, amount, false)
    return true, balance
end

function Node7.RemoveMoney(source, account, amount, reason)
    local player = Node7.GetPlayer(source)
    amount = validAmount(amount)
    if not player or not player.character or not accounts[account] or not amount then return false end
    if player.character.money[account] < amount then return false end

    local balance = player.character.money[account] - amount
    player.character.money[account] = balance
    Node7Database.Transaction(player.character.id, account, -amount, reason or 'unspecified', balance)
    TriggerClientEvent('node7:client:moneyChanged', source, player.character.money, account, -amount)
    TriggerClientEvent('Node7:Client:OnMoneyChange', source, account, amount, true)
    return true, balance
end

function Node7.SetMoney(source, account, amount, reason)
    local player = Node7.GetPlayer(source)
    amount = tonumber(amount)
    if not player or not player.character or not accounts[account] or not amount or amount < 0 then return false end
    amount = math.floor(amount)
    local difference = amount - player.character.money[account]
    player.character.money[account] = amount
    Node7Database.Transaction(player.character.id, account, difference, reason or 'set', amount)
    TriggerClientEvent('node7:client:moneyChanged', source, player.character.money, account, difference)
    TriggerClientEvent('Node7:Client:OnMoneyChange', source, account, math.abs(difference), difference < 0)
    return true, amount
end

function Node7.TransferMoney(source, targetSource, account, amount, reason)
    amount = validAmount(amount)
    targetSource = tonumber(targetSource)
    if not amount or amount > Node7Config.Security.maxMoneyTransfer or source == targetSource then return false end
    local sender, receiver = Node7.GetPlayer(source), Node7.GetPlayer(targetSource)
    if not sender or not receiver or not sender.character or not receiver.character then return false end
    if not Node7.RemoveMoney(source, account, amount, reason or 'player_transfer') then return false end
    if not Node7.AddMoney(targetSource, account, amount, reason or 'player_transfer') then
        Node7.AddMoney(source, account, amount, 'transfer_rollback')
        return false
    end
    Node7.Log(sender.character.id, 'money_transfer', receiver.character.id, { account = account, amount = amount })
    return true
end

exports('GetMoney', Node7.GetMoney)
exports('AddMoney', Node7.AddMoney)
exports('RemoveMoney', Node7.RemoveMoney)
exports('SetMoney', Node7.SetMoney)
exports('TransferMoney', Node7.TransferMoney)
