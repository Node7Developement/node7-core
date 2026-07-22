local function saveAll()
    for source in pairs(Node7.Players) do
        local ok, err = pcall(Node7.SavePlayer, source)
        if not ok then print(('^1[NODE7]^7 Failed saving player %s: %s'):format(source, err)) end
    end
end

CreateThread(function()
    while true do
        Wait(Node7Config.SaveInterval)
        saveAll()
    end
end)

CreateThread(function()
    while true do
        Wait(Node7Config.Status.updateInterval)
        for source, player in pairs(Node7.Players) do
            if player.character then
                local metadata = player.character.metadata
                metadata.hunger = math.max(0, (metadata.hunger or 100) - Node7Config.Status.hungerDrain)
                metadata.thirst = math.max(0, (metadata.thirst or 100) - Node7Config.Status.thirstDrain)
                TriggerClientEvent('node7:client:statusChanged', source, metadata)
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(Node7Config.PaycheckInterval)
        for source, player in pairs(Node7.Players) do
            if player.character then
                local job = Node7Jobs[player.character.job.name]
                local grade = job and (job.grades[tostring(player.character.job.grade)] or job.grades[player.character.job.grade])
                local payment = grade and math.max(0, math.floor(tonumber(grade.payment) or 0)) or 0
                if payment > 0 and (player.character.job.duty or job.offDutyPay) then
                    Node7.AddMoney(source, 'bank', payment, ('paycheck:%s'):format(player.character.job.name))
                    Node7.Notify(source, ('Paycheck deposited: $%s'):format(payment), 'money')
                end
            end
        end
    end
end)

AddEventHandler('txAdmin:events:serverShuttingDown', saveAll)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then saveAll() end
end)

MySQL.ready(function()
    local requiredTables = {
        'node7_users', 'node7_characters', 'node7_inventories', 'node7_inventory_items',
        'node7_weapons', 'node7_horses', 'node7_wagons', 'node7_organization_accounts',
        'node7_transactions', 'node7_audit_logs'
    }
    local missing = {}
    for _, tableName in ipairs(requiredTables) do
        local exists = MySQL.scalar.await([[
            SELECT COUNT(*) FROM information_schema.tables
            WHERE table_schema = DATABASE() AND table_name = ?
        ]], { tableName })
        if tonumber(exists) ~= 1 then missing[#missing + 1] = tableName end
    end

    if #missing > 0 then
        print(('^1[NODE7]^7 Database schema is missing: %s'):format(table.concat(missing, ', ')))
        print('^1[NODE7]^7 Import sql/node7_core.sql before using the framework.')
        return
    end

    Node7.Ready = true
    print('^3============================================================^7')
    print(('^3  %s^7'):format(Node7Config.ServerName))
    print(('^3  NODE7 CORE v%s | %s^7'):format(Node7.Version, GetConvar('node7_environment', 'development'):upper()))
    print('^2  DATABASE CONNECTED | CORE READY^7')
    print('^3============================================================^7')
end)
