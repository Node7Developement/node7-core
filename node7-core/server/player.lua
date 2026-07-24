Node7Core.Players = {}
Node7Core.Player = {}

-- On player login get their data or set defaults
-- Don't touch any of this unless you know what you are doing
-- Will cause major issues!

local resourceName = GetCurrentResourceName()
function Node7Core.Player.Login(source, citizenid, newData)
    if source and source ~= '' then
        if citizenid then
            local license = Node7Core.Functions.GetIdentifier(source, 'license')
            local PlayerData = MySQL.prepare.await('SELECT * FROM players where citizenid = ?', { citizenid })
            if PlayerData and license == PlayerData.license then
                PlayerData.money = json.decode(PlayerData.money)
                PlayerData.job = json.decode(PlayerData.job)
                PlayerData.gang = json.decode(PlayerData.gang)
                PlayerData.position = json.decode(PlayerData.position)
                PlayerData.metadata = json.decode(PlayerData.metadata)
                PlayerData.charinfo = json.decode(PlayerData.charinfo)
                Node7Core.Player.CheckPlayerData(source, PlayerData)
            else
                DropPlayer(source, Lang:t('info.exploit_dropped'))
                TriggerEvent('node7-log:server:CreateLog', 'anticheat', 'Anti-Cheat', 'white', GetPlayerName(source) .. ' Has Been Dropped For Character Joining Exploit', false)
            end
        else
            Node7Core.Player.CheckPlayerData(source, newData)
        end
        return true
    else
        Node7Core.ShowError(resourceName, 'ERROR Node7Core.PLAYER.LOGIN - NO SOURCE GIVEN!')
        return false
    end
end

function Node7Core.Player.GetOfflinePlayer(citizenid)
    if citizenid then
        local PlayerData = MySQL.prepare.await('SELECT * FROM players where citizenid = ?', { citizenid })
        if PlayerData then
            PlayerData.money = json.decode(PlayerData.money)
            PlayerData.job = json.decode(PlayerData.job)
            PlayerData.gang = json.decode(PlayerData.gang)
            PlayerData.position = json.decode(PlayerData.position)
            PlayerData.metadata = json.decode(PlayerData.metadata)
            PlayerData.charinfo = json.decode(PlayerData.charinfo)
            return Node7Core.Player.CheckPlayerData(nil, PlayerData)
        end
    end
    return nil
end

function Node7Core.Player.GetPlayerByLicense(license)
    if license then
        local source = Node7Core.Functions.GetSource(license)
        if source > 0 then
            return Node7Core.Players[source]
        else
            return Node7Core.Player.GetOfflinePlayerByLicense(license)
        end
    end
    return nil
end

function Node7Core.Player.GetOfflinePlayerByLicense(license)
    if license then
        local PlayerData = MySQL.prepare.await('SELECT * FROM players where license = ?', { license })
        if PlayerData then
            PlayerData.money = json.decode(PlayerData.money)
            PlayerData.job = json.decode(PlayerData.job)
            PlayerData.gang = json.decode(PlayerData.gang)
            PlayerData.position = json.decode(PlayerData.position)
            PlayerData.metadata = json.decode(PlayerData.metadata)
            PlayerData.charinfo = json.decode(PlayerData.charinfo)
            return Node7Core.Player.CheckPlayerData(nil, PlayerData)
        end
    end
    return nil
end

local function applyDefaults(playerData, defaults)
    for key, value in pairs(defaults) do
        if type(value) == 'function' then
            playerData[key] = playerData[key] or value()
        elseif type(value) == 'table' then
            playerData[key] = playerData[key] or {}
            applyDefaults(playerData[key], value)
        else
            playerData[key] = playerData[key] or value
        end
    end
end


local function normalizeGrade(grade)
    if type(grade) == 'table' then
        local level = tonumber(grade.level or grade.grade or grade[1]) or 0
        return {
            name = grade.name or 'No Grades',
            level = level,
            payment = tonumber(grade.payment) or 0,
            isboss = grade.isboss == true
        }
    end

    local level = tonumber(grade) or 0
    return {
        name = 'No Grades',
        level = level,
        payment = 0,
        isboss = false
    }
end

local function normalizeJobData(job)
    if type(job) ~= 'table' then return nil end
    local name = tostring(job.name or 'unemployed'):lower()
    local jobInfo = Node7Core.Shared.Jobs[name]
    if not jobInfo then return nil end

    local grade = normalizeGrade(job.grade or job.gradelevel or job.grade_level or job.level or 0)
    local gradeKey = tostring(grade.level or 0)
    local jobGradeInfo = jobInfo.grades and jobInfo.grades[gradeKey] or nil
    if not jobGradeInfo and jobInfo.grades then
        gradeKey = '0'
        grade.level = 0
        jobGradeInfo = jobInfo.grades[gradeKey]
    end
    if not jobGradeInfo then return nil end

    return {
        name = name,
        label = jobInfo.label or job.label or name,
        payment = tonumber(jobGradeInfo.payment or job.payment or grade.payment) or 0,
        type = jobInfo.type or job.type or 'none',
        onduty = job.onduty == true or jobInfo.defaultDuty == true,
        isboss = jobGradeInfo.isboss == true,
        grade = {
            name = jobGradeInfo.name or grade.name or gradeKey,
            level = tonumber(gradeKey) or 0,
            payment = tonumber(jobGradeInfo.payment or grade.payment) or 0,
            isboss = jobGradeInfo.isboss == true
        }
    }
end

local function normalizeGangData(gang)
    if type(gang) ~= 'table' then return nil end
    local name = tostring(gang.name or 'none'):lower()
    local gangInfo = Node7Core.Shared.Gangs[name]
    if not gangInfo then return nil end

    local grade = normalizeGrade(gang.grade or gang.gradelevel or gang.grade_level or gang.level or 0)
    local gradeKey = tostring(grade.level or 0)
    local gangGradeInfo = gangInfo.grades and gangInfo.grades[gradeKey] or nil
    if not gangGradeInfo and gangInfo.grades then
        gradeKey = '0'
        grade.level = 0
        gangGradeInfo = gangInfo.grades[gradeKey]
    end
    if not gangGradeInfo then return nil end

    return {
        name = name,
        label = gangInfo.label or gang.label or name,
        isboss = gangGradeInfo.isboss == true,
        grade = {
            name = gangGradeInfo.name or grade.name or gradeKey,
            level = tonumber(gradeKey) or 0,
            isboss = gangGradeInfo.isboss == true
        }
    }
end

function Node7Core.Player.CheckPlayerData(source, PlayerData)
    PlayerData = PlayerData or {}
    PlayerData.cid = tonumber(PlayerData.cid or PlayerData.slot or 1) or 1
    PlayerData.slot = tonumber(PlayerData.slot or PlayerData.cid or 1) or 1
    local Offline = not source

    if source then
        PlayerData.source = source
        PlayerData.license = PlayerData.license or Node7Core.Functions.GetIdentifier(source, 'license')
        PlayerData.name = GetPlayerName(source)
    end

    PlayerData.job = normalizeJobData(PlayerData.job)
    if not PlayerData.job then
        -- set to nil, as the default job (unemployed) will be added by `applyDefaults`
        PlayerData.job = nil
    end

    PlayerData.gang = normalizeGangData(PlayerData.gang)
    if not PlayerData.gang then
        -- set to nil, as the default gang (none) will be added by `applyDefaults`
        PlayerData.gang = nil
    end

    applyDefaults(PlayerData, Node7Core.Config.Player.PlayerDefaults)

    if GetResourceState('node7-inventory') == 'started' then
        local ok, items = pcall(function()
            return exports['node7-inventory']:LoadInventory(PlayerData.source, PlayerData.citizenid)
        end)
        if ok and items then PlayerData.items = items end
    end

    return Node7Core.Player.CreatePlayer(PlayerData, Offline)
end

-- On player logout

function Node7Core.Player.Logout(source)
    TriggerClientEvent('Node7Core:Client:OnPlayerUnload', source)
    TriggerEvent('Node7Core:Server:OnPlayerUnload', source)
    TriggerClientEvent('Node7Core:Player:UpdatePlayerData', source)
    Wait(200)
    Node7Core.Players[source] = nil
end

-- Create a new character
-- Don't touch any of this unless you know what you are doing
-- Will cause major issues!

function Node7Core.Player.CreatePlayer(PlayerData, Offline)
    local self = {}
    self.Functions = {}
    self.PlayerData = PlayerData
    self.Offline = Offline

    function self.Functions.UpdatePlayerData()
        if self.Offline then return end

        if Node7Core.Config.Money.EnableMoneyItems then
            self.PlayerData = SynchronizeMoneyItems(self.PlayerData)
        end

        TriggerEvent('Node7Core:Player:SetPlayerData', self.PlayerData)
        TriggerClientEvent('Node7Core:Player:SetPlayerData', self.PlayerData.source, self.PlayerData)
    end

    function self.Functions.SetJob(job, grade)
        job = job:lower()
        grade = grade or '0'
        if not Node7Core.Shared.Jobs[job] then return false end
        self.PlayerData.job = {
            name = job,
            label = Node7Core.Shared.Jobs[job].label,
            onduty = Node7Core.Shared.Jobs[job].defaultDuty,
            type = Node7Core.Shared.Jobs[job].type or 'none',
            grade = {
                name = 'No Grades',
                level = 0,
                payment = 30,
                isboss = false
            }
        }
        local gradeKey = tostring(grade)
        local jobGradeInfo = Node7Core.Shared.Jobs[job].grades[gradeKey]
        if jobGradeInfo then
            self.PlayerData.job.grade.name = jobGradeInfo.name
            self.PlayerData.job.grade.level = tonumber(gradeKey)
            self.PlayerData.job.grade.payment = jobGradeInfo.payment
            self.PlayerData.job.grade.isboss = jobGradeInfo.isboss or false
            self.PlayerData.job.isboss = jobGradeInfo.isboss or false
        end

        if not self.Offline then
            self.Functions.UpdatePlayerData()
            TriggerEvent('Node7Core:Server:OnJobUpdate', self.PlayerData.source, self.PlayerData.job)
            TriggerClientEvent('Node7Core:Client:OnJobUpdate', self.PlayerData.source, self.PlayerData.job)
        end

        return true
    end

    function self.Functions.SetGang(gang, grade)
        gang = gang:lower()
        grade = grade or '0'
        if not Node7Core.Shared.Gangs[gang] then return false end
        self.PlayerData.gang = {
            name = gang,
            label = Node7Core.Shared.Gangs[gang].label,
            grade = {
                name = 'No Grades',
                level = 0,
                isboss = false
            }
        }
        local gradeKey = tostring(grade)
        local gangGradeInfo = Node7Core.Shared.Gangs[gang].grades[gradeKey]
        if gangGradeInfo then
            self.PlayerData.gang.grade.name = gangGradeInfo.name
            self.PlayerData.gang.grade.level = tonumber(gradeKey)
            self.PlayerData.gang.grade.isboss = gangGradeInfo.isboss or false
            self.PlayerData.gang.isboss = gangGradeInfo.isboss or false
        end

        if not self.Offline then
            self.Functions.UpdatePlayerData()
            TriggerEvent('Node7Core:Server:OnGangUpdate', self.PlayerData.source, self.PlayerData.gang)
            TriggerClientEvent('Node7Core:Client:OnGangUpdate', self.PlayerData.source, self.PlayerData.gang)
        end

        return true
    end

    function self.Functions.HasItem(items, amount)
        return Node7Core.Functions.HasItem(self.PlayerData.source, items, amount)
    end

    function self.Functions.SetJobDuty(onDuty)
        self.PlayerData.job.onduty = not not onDuty
        TriggerEvent('Node7Core:Server:OnJobUpdate', self.PlayerData.source, self.PlayerData.job)
        TriggerClientEvent('Node7Core:Client:OnJobUpdate', self.PlayerData.source, self.PlayerData.job)
        self.Functions.UpdatePlayerData()
    end

    function self.Functions.SetPlayerData(key, val)
        if not key or type(key) ~= 'string' then return end
        self.PlayerData[key] = val
        self.Functions.UpdatePlayerData()
    end

    function self.Functions.SetMetaData(meta, val)
        local function validateData(key, value)
            if key == 'hunger' or key == 'thirst' or key == 'cleanliness' then
                value = lib.math.clamp(value, 0, 100)
            end

            return value
        end

        if type(meta) == 'table' then
            for key, value in pairs(meta) do
                self.PlayerData.metadata[key] = validateData(key, value)
            end
            self.Functions.UpdatePlayerData()
            return
        end
    
        if type(meta) ~= 'string' then return end
        self.PlayerData.metadata[meta] = validateData(meta, val)
        self.Functions.UpdatePlayerData()
    end

    function self.Functions.GetMetaData(meta)
        if not meta or type(meta) ~= 'string' then return end
        return self.PlayerData.metadata[meta]
    end

    function self.Functions.AddRep(rep, amount)
        if not rep or not amount then return end
        local addAmount = tonumber(amount)
        local currentRep = self.PlayerData.metadata['rep'][rep] or 0
        self.PlayerData.metadata['rep'][rep] = currentRep + addAmount
        self.Functions.UpdatePlayerData()
    end

    function self.Functions.RemoveRep(rep, amount)
        if not rep or not amount then return end
        local removeAmount = tonumber(amount)
        local currentRep = self.PlayerData.metadata['rep'][rep] or 0
        if currentRep - removeAmount < 0 then
            self.PlayerData.metadata['rep'][rep] = 0
        else
            self.PlayerData.metadata['rep'][rep] = currentRep - removeAmount
        end
        self.Functions.UpdatePlayerData()
    end

    function self.Functions.GetRep(rep)
        if not rep then return end
        return self.PlayerData.metadata['rep'][rep] or 0
    end

    function self.Functions.AddMoney(moneytype, amount, reason)
        reason = reason or 'unknown'
        moneytype = moneytype:lower()
        amount = tonumber(amount)
        if amount < 0 then return end
        if not self.PlayerData.money[moneytype] then return false end
        self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] + amount

        if not self.Offline then
            self.Functions.UpdatePlayerData()
            if amount > 100000 then
                TriggerEvent('node7-log:server:CreateLog', 'playermoney', 'AddMoney', 'lightgreen', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') added, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason, true)
            else
                TriggerEvent('node7-log:server:CreateLog', 'playermoney', 'AddMoney', 'lightgreen', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') added, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason)
            end

            if not Node7Core.Config.Money.EnableMoneyItems then
                TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, amount, false)
            end
            TriggerClientEvent('Node7Core:Client:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'add', reason)
            TriggerEvent('Node7Core:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'add', reason)
        end

        return true
    end

    function self.Functions.RemoveMoney(moneytype, amount, reason)
        reason = reason or 'unknown'
        moneytype = moneytype:lower()
        amount = tonumber(amount)
        if amount < 0 then return end
        if not self.PlayerData.money[moneytype] then return false end
        for _, mtype in pairs(Node7Core.Config.Money.DontAllowMinus) do
            if mtype == moneytype then
                if (self.PlayerData.money[moneytype] - amount) < 0 then
                    return false
                end
            end
        end
        if self.PlayerData.money[moneytype] - amount < Node7Core.Config.Money.MinusLimit then return false end
        self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] - amount

        if not self.Offline then
            self.Functions.UpdatePlayerData()
            if amount > 100000 then
                TriggerEvent('node7-log:server:CreateLog', 'playermoney', 'RemoveMoney', 'red', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') removed, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason, true)
            else
                TriggerEvent('node7-log:server:CreateLog', 'playermoney', 'RemoveMoney', 'red', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') removed, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason)
            end
            if not Node7Core.Config.Money.EnableMoneyItems then
                TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, amount, true)
            end
            TriggerClientEvent('Node7Core:Client:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'remove', reason)
            TriggerEvent('Node7Core:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'remove', reason)
        end

        return true
    end

    function self.Functions.SetMoney(moneytype, amount, reason)
        reason = reason or 'unknown'
        moneytype = moneytype:lower()
        amount = tonumber(amount)
        if amount < 0 then return false end
        if not self.PlayerData.money[moneytype] then return false end
        local difference = amount - self.PlayerData.money[moneytype]
        self.PlayerData.money[moneytype] = amount

        if not self.Offline then
            self.Functions.UpdatePlayerData()
            TriggerEvent('node7-log:server:CreateLog', 'playermoney', 'SetMoney', 'green', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') set, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason)
            if not Node7Core.Config.Money.EnableMoneyItems then
                TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, math.abs(difference), difference < 0)
            end
            TriggerClientEvent('Node7Core:Client:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'set', reason)
            TriggerEvent('Node7Core:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'set', reason)
        end

        return true
    end

    function self.Functions.GetMoney(moneytype)
        if not moneytype then return false end
        moneytype = moneytype:lower()
        return self.PlayerData.money[moneytype]
    end

    function self.Functions.Save()
        if self.Offline then
            Node7Core.Player.SaveOffline(self.PlayerData)
        else
            self.Functions.PersistStateBags()
            Node7Core.Player.Save(self.PlayerData.source)
        end
    end

    function self.Functions.Logout()
        if self.Offline then return end
        Node7Core.Player.Logout(self.PlayerData.source)
    end

    function self.Functions.AddMethod(methodName, handler)
        self.Functions[methodName] = handler
    end

    function self.Functions.AddField(fieldName, data)
        self[fieldName] = data
    end

    function self.Functions.PersistStateBags()
        local metadata = {}
        local keys = { "hunger", "thirst", "cleanliness", "stress", "health" }
    
        local state = Player(self.PlayerData.source).state
        for _, key in ipairs(keys) do
            if state[key] ~= nil then
                metadata[key] = state[key]
            end
        end
    
        if next(metadata) then
            self.Functions.SetMetaData(metadata)
        end
    end

    function self.Functions.InitializeStateBags()
        local metadata = self.PlayerData.metadata
        local keys = { "hunger", "thirst", "cleanliness", "stress", "health" }
    
        local state = Player(self.PlayerData.source).state
        for _, key in ipairs(keys) do
            if metadata[key] ~= nil then
                state[key] = metadata[key]
            end
        end
    end

    if self.Offline then
        return self
    else
        self.Functions.InitializeStateBags()
        Node7Core.Players[self.PlayerData.source] = self
        Node7Core.Player.Save(self.PlayerData.source)
        TriggerEvent('Node7Core:Server:PlayerLoaded', self)
        self.Functions.UpdatePlayerData()
        return self
    end
end

-- Add a new function to the Functions table of the player class
-- Use-case:
--[[
    AddEventHandler('Node7Core:Server:PlayerLoaded', function(Player)
        Node7Core.Functions.AddPlayerMethod(Player.PlayerData.source, "functionName", function(oneArg, orMore)
            -- do something here
        end)
    end)
]]

function Node7Core.Functions.AddPlayerMethod(ids, methodName, handler)
    local idType = type(ids)
    if idType == 'number' then
        if ids == -1 then
            for _, v in pairs(Node7Core.Players) do
                v.Functions.AddMethod(methodName, handler)
            end
        else
            if not Node7Core.Players[ids] then return end

            Node7Core.Players[ids].Functions.AddMethod(methodName, handler)
        end
    elseif idType == 'table' and table.type(ids) == 'array' then
        for i = 1, #ids do
            Node7Core.Functions.AddPlayerMethod(ids[i], methodName, handler)
        end
    end
end

-- Add a new field table of the player class
-- Use-case:
--[[
    AddEventHandler('Node7Core:Server:PlayerLoaded', function(Player)
        Node7Core.Functions.AddPlayerField(Player.PlayerData.source, "fieldName", "fieldData")
    end)
]]

function Node7Core.Functions.AddPlayerField(ids, fieldName, data)
    local idType = type(ids)
    if idType == 'number' then
        if ids == -1 then
            for _, v in pairs(Node7Core.Players) do
                v.Functions.AddField(fieldName, data)
            end
        else
            if not Node7Core.Players[ids] then return end

            Node7Core.Players[ids].Functions.AddField(fieldName, data)
        end
    elseif idType == 'table' and table.type(ids) == 'array' then
        for i = 1, #ids do
            Node7Core.Functions.AddPlayerField(ids[i], fieldName, data)
        end
    end
end

-- Save player info to database (make sure citizenid is the primary key in your database)

function Node7Core.Player.Save(source)
    local ped = GetPlayerPed(source)
    local pcoords = GetEntityCoords(ped)
    local PlayerData = Node7Core.Players[source].PlayerData
    if PlayerData then
        MySQL.insert('INSERT INTO players (citizenid, cid, slot, license, name, money, charinfo, job, gang, position, metadata, weight, slots) VALUES (:citizenid, :cid, :slot, :license, :name, :money, :charinfo, :job, :gang, :position, :metadata, :weight, :slots) ON DUPLICATE KEY UPDATE cid = :cid, slot = :slot, name = :name, money = :money, charinfo = :charinfo, job = :job, gang = :gang, position = :position, metadata = :metadata, weight = :weight, slots = :slots', {
            citizenid = PlayerData.citizenid,
            cid = tonumber(PlayerData.cid or PlayerData.slot or 1),
            slot = tonumber(PlayerData.slot or PlayerData.cid or 1),
            license = PlayerData.license,
            name = PlayerData.name,
            money = json.encode(PlayerData.money),
            charinfo = json.encode(PlayerData.charinfo),
            job = json.encode(PlayerData.job),
            gang = json.encode(PlayerData.gang),
            position = json.encode(pcoords),
            metadata = json.encode(PlayerData.metadata),
            weight = PlayerData.weight,
            slots = PlayerData.slots,
        })
        if GetResourceState('node7-inventory') == 'started' then pcall(function() exports['node7-inventory']:SaveInventory(source) end) end
        Node7Core.ShowSuccess(resourceName, PlayerData.name .. ' PLAYER SAVED!')
    else
        Node7Core.ShowError(resourceName, 'ERROR Node7Core.PLAYER.SAVE - PLAYERDATA IS EMPTY!')
    end
end

function Node7Core.Player.SaveOffline(PlayerData)
    if PlayerData then
        MySQL.insert('INSERT INTO players (citizenid, cid, slot, license, name, money, charinfo, job, gang, position, metadata, weight, slots) VALUES (:citizenid, :cid, :slot, :license, :name, :money, :charinfo, :job, :gang, :position, :metadata, :weight, :slots) ON DUPLICATE KEY UPDATE cid = :cid, slot = :slot, name = :name, money = :money, charinfo = :charinfo, job = :job, gang = :gang, position = :position, metadata = :metadata, weight = :weight, slots = :slots', {
            citizenid = PlayerData.citizenid,
            cid = tonumber(PlayerData.cid or PlayerData.slot or 1),
            slot = tonumber(PlayerData.slot or PlayerData.cid or 1),
            license = PlayerData.license,
            name = PlayerData.name,
            money = json.encode(PlayerData.money),
            charinfo = json.encode(PlayerData.charinfo),
            job = json.encode(PlayerData.job),
            gang = json.encode(PlayerData.gang),
            position = json.encode(PlayerData.position),
            metadata = json.encode(PlayerData.metadata),
            weight = PlayerData.weight,
            slots = PlayerData.slots,
        })
        if GetResourceState('node7-inventory') == 'started' then pcall(function() exports['node7-inventory']:SaveInventory(PlayerData, true) end) end
        Node7Core.ShowSuccess(resourceName, PlayerData.name .. ' OFFLINE PLAYER SAVED!')
    else
        Node7Core.ShowError(resourceName, 'ERROR Node7Core.PLAYER.SAVEOFFLINE - PLAYERDATA IS EMPTY!')
    end
end


-- Delete character

local playertables = { -- Add tables as needed
    { table = 'players'},
    { table = 'playeroutfit'},
    { table = 'playerskins'},
    { table = 'player_weapons'},
    { table = 'address_book'},
    { table = 'telegrams'},
}

function Node7Core.Player.DeleteCharacter(source, citizenid)
    local license = Node7Core.Functions.GetIdentifier(source, 'license')
    local result = MySQL.scalar.await('SELECT license FROM players where citizenid = ?', { citizenid })
    if license == result then
        local query = 'DELETE FROM %s WHERE citizenid = ?'
        local tableCount = #playertables
        local queries = table.create(tableCount, 0)

        for i = 1, tableCount do
            local v = playertables[i]
            queries[i] = { query = query:format(v.table), values = { citizenid } }
        end

        MySQL.transaction(queries, function(result2)
            if result2 then
                TriggerEvent('node7-log:server:CreateLog', 'joinleave', 'Character Deleted', 'red', '**' .. GetPlayerName(source) .. '** ' .. license .. ' deleted **' .. citizenid .. '**..')
            end
        end)
    else
        DropPlayer(source, Lang:t('info.exploit_dropped'))
        TriggerEvent('node7-log:server:CreateLog', 'anticheat', 'Anti-Cheat', 'white', GetPlayerName(source) .. ' Has Been Dropped For Character Deletion Exploit', true)
    end
end

function Node7Core.Player.ForceDeleteCharacter(citizenid)
    local result = MySQL.scalar.await('SELECT license FROM players where citizenid = ?', { citizenid })
    if result then
        local query = 'DELETE FROM %s WHERE citizenid = ?'
        local tableCount = #playertables
        local queries = table.create(tableCount, 0)
        local Player = Node7Core.Functions.GetPlayerByCitizenId(citizenid)

        if Player then
            DropPlayer(Player.PlayerData.source, 'An admin deleted the character which you are currently using')
        end
        for i = 1, tableCount do
            local v = playertables[i]
            queries[i] = { query = query:format(v.table), values = { citizenid } }
        end

        MySQL.transaction(queries, function(result2)
            if result2 then
                TriggerEvent('node7-log:server:CreateLog', 'joinleave', 'Character Force Deleted', 'red', 'Character **' .. citizenid .. '** got deleted')
            end
        end)
    end
end

-- Inventory Backwards Compatibility

function Node7Core.Player.SaveInventory(source)
    if GetResourceState('node7-inventory') ~= 'started' then return end
    pcall(function() exports['node7-inventory']:SaveInventory(source, false) end)
end

function Node7Core.Player.SaveOfflineInventory(PlayerData)
    if GetResourceState('node7-inventory') ~= 'started' then return end
    pcall(function() exports['node7-inventory']:SaveInventory(PlayerData, true) end)
end

function Node7Core.Player.GetTotalWeight(items)
    if GetResourceState('node7-inventory') ~= 'started' then return end
    local ok, result = pcall(function() return exports['node7-inventory']:GetTotalWeight(items) end)
    if ok then return result end
end

function Node7Core.Player.GetSlotsByItem(items, itemName)
    if GetResourceState('node7-inventory') ~= 'started' then return end
    local ok, result = pcall(function() return exports['node7-inventory']:GetSlotsByItem(items, itemName) end)
    if ok then return result end
end

function Node7Core.Player.GetFirstSlotByItem(items, itemName)
    if GetResourceState('node7-inventory') ~= 'started' then return end
    local ok, result = pcall(function() return exports['node7-inventory']:GetFirstSlotByItem(items, itemName) end)
    if ok then return result end
end

-- Util Functions

function Node7Core.Player.CreateCitizenId()
    local CitizenId = tostring(Node7Core.Shared.RandomStr(3) .. Node7Core.Shared.RandomInt(5)):upper()
    local result = MySQL.prepare.await('SELECT EXISTS(SELECT 1 FROM players WHERE citizenid = ?) AS uniqueCheck', { CitizenId })
    if result == 0 then return CitizenId end
    return Node7Core.Player.CreateCitizenId()
end

function Node7Core.Functions.CreateAccountNumber()
    local AccountNumber = 'US0' .. math.random(1, 9) .. 'Node7Core' .. math.random(1111, 9999) .. math.random(1111, 9999) .. math.random(11, 99)
    local result = MySQL.prepare.await('SELECT EXISTS(SELECT 1 FROM players WHERE JSON_UNQUOTE(JSON_EXTRACT(charinfo, "$.account")) = ?) AS uniqueCheck', { AccountNumber })
    if result == 0 then return AccountNumber end
    return Node7Core.Functions.CreateAccountNumber()
end

function Node7Core.Player.CreateFingerId()
    local FingerId = tostring(Node7Core.Shared.RandomStr(2) .. Node7Core.Shared.RandomInt(3) .. Node7Core.Shared.RandomStr(1) .. Node7Core.Shared.RandomInt(2) .. Node7Core.Shared.RandomStr(3) .. Node7Core.Shared.RandomInt(4))
    local result = MySQL.prepare.await('SELECT EXISTS(SELECT 1 FROM players WHERE JSON_UNQUOTE(JSON_EXTRACT(metadata, "$.fingerprint")) = ?) AS uniqueCheck', { FingerId })
    if result == 0 then return FingerId end
    return Node7Core.Player.CreateFingerId()
end

function Node7Core.Player.CreateWalletId()
    local WalletId = 'NODE7-' .. math.random(11111111, 99999999)
    local result = MySQL.prepare.await('SELECT EXISTS(SELECT 1 FROM players WHERE JSON_UNQUOTE(JSON_EXTRACT(metadata, "$.walletid")) = ?) AS uniqueCheck', { WalletId })
    if result == 0 then return WalletId end
    return Node7Core.Player.CreateWalletId()
end

function Node7Core.Player.CreateSerialNumber()
    local SerialNumber = math.random(11111111, 99999999)
    local result = MySQL.prepare.await('SELECT EXISTS(SELECT 1 FROM players WHERE JSON_UNQUOTE(JSON_EXTRACT(metadata, "$.phonedata.SerialNumber")) = ?) AS uniqueCheck', { SerialNumber })
    if result == 0 then return SerialNumber end
    return Node7Core.Player.CreateSerialNumber()
end

PaycheckInterval() -- This starts the paycheck system
