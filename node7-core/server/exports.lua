-- Add or change (a) method(s) in the Node7Core.Functions table
local function SetMethod(methodName, handler)
    if type(methodName) ~= 'string' then
        return false, 'invalid_method_name'
    end

    Node7Core.Functions[methodName] = handler

    TriggerEvent('Node7Core:Server:UpdateObject')

    return true, 'success'
end

Node7Core.Functions.SetMethod = SetMethod
exports('SetMethod', SetMethod)

-- Add or change (a) field(s) in the Node7Core table
local function SetField(fieldName, data)
    if type(fieldName) ~= 'string' then
        return false, 'invalid_field_name'
    end

    Node7Core[fieldName] = data

    TriggerEvent('Node7Core:Server:UpdateObject')

    return true, 'success'
end

Node7Core.Functions.SetField = SetField
exports('SetField', SetField)

-- Single add job function which should only be used if you planning on adding a single job
local function AddJob(jobName, job)
    if type(jobName) ~= 'string' then
        return false, 'invalid_job_name'
    end

    if Node7Core.Shared.Jobs[jobName] then
        return false, 'job_exists'
    end

    Node7Core.Shared.Jobs[jobName] = job

    TriggerClientEvent('Node7Core:Client:OnSharedUpdate', -1, 'Jobs', jobName, job)
    TriggerEvent('Node7Core:Server:UpdateObject')
    return true, 'success'
end

Node7Core.Functions.AddJob = AddJob
exports('AddJob', AddJob)

-- Multiple Add Jobs
local function AddJobs(jobs)
    local shouldContinue = true
    local message = 'success'
    local errorItem = nil

    for key, value in pairs(jobs) do
        if type(key) ~= 'string' then
            message = 'invalid_job_name'
            shouldContinue = false
            errorItem = jobs[key]
            break
        end

        if Node7Core.Shared.Jobs[key] then
            message = 'job_exists'
            shouldContinue = false
            errorItem = jobs[key]
            break
        end

        Node7Core.Shared.Jobs[key] = value
    end

    if not shouldContinue then return false, message, errorItem end
    TriggerClientEvent('Node7Core:Client:OnSharedUpdateMultiple', -1, 'Jobs', jobs)
    TriggerEvent('Node7Core:Server:UpdateObject')
    return true, message, nil
end

Node7Core.Functions.AddJobs = AddJobs
exports('AddJobs', AddJobs)

-- Single Remove Job
local function RemoveJob(jobName)
    if type(jobName) ~= 'string' then
        return false, 'invalid_job_name'
    end

    if not Node7Core.Shared.Jobs[jobName] then
        return false, 'job_not_exists'
    end

    Node7Core.Shared.Jobs[jobName] = nil

    TriggerClientEvent('Node7Core:Client:OnSharedUpdate', -1, 'Jobs', jobName, nil)
    TriggerEvent('Node7Core:Server:UpdateObject')
    return true, 'success'
end

Node7Core.Functions.RemoveJob = RemoveJob
exports('RemoveJob', RemoveJob)

-- Single Update Job
local function UpdateJob(jobName, job)
    if type(jobName) ~= 'string' then
        return false, 'invalid_job_name'
    end

    if not Node7Core.Shared.Jobs[jobName] then
        return false, 'job_not_exists'
    end

    Node7Core.Shared.Jobs[jobName] = job

    TriggerClientEvent('Node7Core:Client:OnSharedUpdate', -1, 'Jobs', jobName, job)
    TriggerEvent('Node7Core:Server:UpdateObject')
    return true, 'success'
end

Node7Core.Functions.UpdateJob = UpdateJob
exports('UpdateJob', UpdateJob)

-- Single add item
local function AddItem(itemName, item)
    if type(itemName) ~= 'string' then
        return false, 'invalid_item_name'
    end

    if Node7Core.Shared.Items[itemName] then
        return false, 'item_exists'
    end

    Node7Core.Shared.Items[itemName] = item

    TriggerClientEvent('Node7Core:Client:OnSharedUpdate', -1, 'Items', itemName, item)
    TriggerEvent('Node7Core:Server:UpdateObject')
    return true, 'success'
end

Node7Core.Functions.AddItem = AddItem
exports('AddItem', AddItem)

-- Single update item
local function UpdateItem(itemName, item)
    if type(itemName) ~= 'string' then
        return false, 'invalid_item_name'
    end
    if not Node7Core.Shared.Items[itemName] then
        return false, 'item_not_exists'
    end
    Node7Core.Shared.Items[itemName] = item
    TriggerClientEvent('Node7Core:Client:OnSharedUpdate', -1, 'Items', itemName, item)
    TriggerEvent('Node7Core:Server:UpdateObject')
    return true, 'success'
end

Node7Core.Functions.UpdateItem = UpdateItem
exports('UpdateItem', UpdateItem)

-- Multiple Add Items
local function AddItems(items)
    local shouldContinue = true
    local message = 'success'
    local errorItem = nil

    for key, value in pairs(items) do
        if type(key) ~= 'string' then
            message = 'invalid_item_name'
            shouldContinue = false
            errorItem = items[key]
            break
        end

        if Node7Core.Shared.Items[key] then
            message = 'item_exists'
            shouldContinue = false
            errorItem = items[key]
            break
        end

        Node7Core.Shared.Items[key] = value
    end

    if not shouldContinue then return false, message, errorItem end
    TriggerClientEvent('Node7Core:Client:OnSharedUpdateMultiple', -1, 'Items', items)
    TriggerEvent('Node7Core:Server:UpdateObject')
    return true, message, nil
end

Node7Core.Functions.AddItems = AddItems
exports('AddItems', AddItems)

-- Single Remove Item
local function RemoveItem(itemName)
    if type(itemName) ~= 'string' then
        return false, 'invalid_item_name'
    end

    if not Node7Core.Shared.Items[itemName] then
        return false, 'item_not_exists'
    end

    Node7Core.Shared.Items[itemName] = nil

    TriggerClientEvent('Node7Core:Client:OnSharedUpdate', -1, 'Items', itemName, nil)
    TriggerEvent('Node7Core:Server:UpdateObject')
    return true, 'success'
end

Node7Core.Functions.RemoveItem = RemoveItem
exports('RemoveItem', RemoveItem)

-- Single Add Gang
local function AddGang(gangName, gang)
    if type(gangName) ~= 'string' then
        return false, 'invalid_gang_name'
    end

    if Node7Core.Shared.Gangs[gangName] then
        return false, 'gang_exists'
    end

    Node7Core.Shared.Gangs[gangName] = gang

    TriggerClientEvent('Node7Core:Client:OnSharedUpdate', -1, 'Gangs', gangName, gang)
    TriggerEvent('Node7Core:Server:UpdateObject')
    return true, 'success'
end

Node7Core.Functions.AddGang = AddGang
exports('AddGang', AddGang)

-- Multiple Add Gangs
local function AddGangs(gangs)
    local shouldContinue = true
    local message = 'success'
    local errorItem = nil

    for key, value in pairs(gangs) do
        if type(key) ~= 'string' then
            message = 'invalid_gang_name'
            shouldContinue = false
            errorItem = gangs[key]
            break
        end

        if Node7Core.Shared.Gangs[key] then
            message = 'gang_exists'
            shouldContinue = false
            errorItem = gangs[key]
            break
        end

        Node7Core.Shared.Gangs[key] = value
    end

    if not shouldContinue then return false, message, errorItem end
    TriggerClientEvent('Node7Core:Client:OnSharedUpdateMultiple', -1, 'Gangs', gangs)
    TriggerEvent('Node7Core:Server:UpdateObject')
    return true, message, nil
end

Node7Core.Functions.AddGangs = AddGangs
exports('AddGangs', AddGangs)

-- Single Remove Gang
local function RemoveGang(gangName)
    if type(gangName) ~= 'string' then
        return false, 'invalid_gang_name'
    end

    if not Node7Core.Shared.Gangs[gangName] then
        return false, 'gang_not_exists'
    end

    Node7Core.Shared.Gangs[gangName] = nil

    TriggerClientEvent('Node7Core:Client:OnSharedUpdate', -1, 'Gangs', gangName, nil)
    TriggerEvent('Node7Core:Server:UpdateObject')
    return true, 'success'
end

Node7Core.Functions.RemoveGang = RemoveGang
exports('RemoveGang', RemoveGang)

-- Single Update Gang
local function UpdateGang(gangName, gang)
    if type(gangName) ~= 'string' then
        return false, 'invalid_gang_name'
    end

    if not Node7Core.Shared.Gangs[gangName] then
        return false, 'gang_not_exists'
    end

    Node7Core.Shared.Gangs[gangName] = gang

    TriggerClientEvent('Node7Core:Client:OnSharedUpdate', -1, 'Gangs', gangName, gang)
    TriggerEvent('Node7Core:Server:UpdateObject')
    return true, 'success'
end

Node7Core.Functions.UpdateGang = UpdateGang
exports('UpdateGang', UpdateGang)

local resourceName = GetCurrentResourceName()
local function GetCoreVersion(InvokingResource)
    local resourceVersion = GetResourceMetadata(resourceName, 'version')
    if InvokingResource and InvokingResource ~= '' then
        print(('%s called rsgcore version check: %s'):format(InvokingResource or 'Unknown Resource', resourceVersion))
    end
    return resourceVersion
end

Node7Core.Functions.GetCoreVersion = GetCoreVersion
exports('GetCoreVersion', GetCoreVersion)

local function ExploitBan(playerId, origin)
    local name = GetPlayerName(playerId)
    MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        name,
        Node7Core.Functions.GetIdentifier(playerId, 'license'),
        Node7Core.Functions.GetIdentifier(playerId, 'discord'),
        Node7Core.Functions.GetIdentifier(playerId, 'ip'),
        origin,
        2147483647,
        'Anti Cheat'
    })
    DropPlayer(playerId, Lang:t('info.exploit_banned', { discord = Node7Core.Config.Server.Discord }))
    TriggerEvent('node7-log:server:CreateLog', 'anticheat', 'Anti-Cheat', 'red', name .. ' has been banned for exploiting ' .. origin, true)
end

exports('ExploitBan', ExploitBan)

-- NODE7 medical metadata helpers
exports('GetBloodType', function(source)
    return Node7Core.Functions.GetBloodType(source)
end)

exports('SetBloodType', function(source, bloodType)
    return Node7Core.Functions.SetBloodType(source, bloodType)
end)
