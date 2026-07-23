function Node7.RegisterJob(name, definition)
    if Node7Jobs[name] then return false, 'job_exists' end
    local ok, normalized = pcall(Node7NormalizeJobDefinition, name, definition)
    if not ok then return false, normalized end
    Node7Jobs[name] = normalized
    return true, normalized
end

function Node7.RegisterGang(name, definition)
    if Node7Gangs[name] then return false, 'gang_exists' end
    local ok, normalized = pcall(Node7NormalizeGangDefinition, name, definition)
    if not ok then return false, normalized end
    Node7Gangs[name] = normalized
    return true, normalized
end

local OrganizationAccounts = {}

local function gradeHasPermission(grade, permission)
    if not grade then return false end
    for _, value in ipairs(grade.permissions or {}) do
        if value == 'all' or value == permission then return true end
    end
    return false
end

local function getGrade(definition, level)
    if not definition or not definition.grades then return nil end
    return definition.grades[tostring(level)] or definition.grades[tonumber(level)]
end

function Node7.HasJobPermission(source, permission)
    local player = Node7.GetPlayer(source)
    if not player or not player.character then return false end
    local job = Node7Jobs[player.character.job.name]
    return job and gradeHasPermission(getGrade(job, player.character.job.grade), permission) or false
end

function Node7.HasGangPermission(source, permission)
    local player = Node7.GetPlayer(source)
    if not player or not player.character then return false end
    local gang = Node7Gangs[player.character.gang.name]
    return gang and gradeHasPermission(getGrade(gang, player.character.gang.grade), permission) or false
end

local function organizationKey(organizationType, name)
    if organizationType ~= 'job' and organizationType ~= 'gang' then return nil end
    if type(name) ~= 'string' or name == '' then return nil end
    return ('%s:%s'):format(organizationType, name)
end

function Node7.GetOrganizationBalance(organizationType, name)
    local key = organizationKey(organizationType, name)
    if not key then return nil end
    OrganizationAccounts[key] = OrganizationAccounts[key] or { balance = 0, metadata = {} }
    return OrganizationAccounts[key].balance
end

function Node7.AddOrganizationMoney(organizationType, name, amount)
    local key = organizationKey(organizationType, name)
    amount = tonumber(amount)
    if not key or not amount or amount <= 0 or amount ~= math.floor(amount) then return false end
    OrganizationAccounts[key] = OrganizationAccounts[key] or { balance = 0, metadata = {} }
    OrganizationAccounts[key].balance = OrganizationAccounts[key].balance + amount
    return true
end

function Node7.RemoveOrganizationMoney(organizationType, name, amount)
    local key = organizationKey(organizationType, name)
    amount = tonumber(amount)
    if not key or not amount or amount <= 0 or amount ~= math.floor(amount) then return false end
    if Node7.GetOrganizationBalance(organizationType, name) < amount then return false end
    OrganizationAccounts[key].balance = OrganizationAccounts[key].balance - amount
    return true
end

function Node7.SetJob(source, jobName, grade)
    local player = Node7.GetPlayer(source)
    local job = Node7Jobs[jobName]
    grade = tonumber(grade)
    if not player or not player.character or not job or grade == nil or not getGrade(job, grade) then return false, 'invalid_job' end
    player.character.job = { name = jobName, grade = grade, duty = job.defaultDuty == true }
    Node7.RefreshPlayerData(source, false, true)
    Node7.MarkPlayerDirty(source)
    TriggerClientEvent('node7:client:jobChanged', source, player.character.job)
    TriggerClientEvent('Node7:Client:OnJobUpdate', source, player.PlayerData.job)
    TriggerEvent('node7:server:jobChanged', source, player.character.job)
    return true, player.PlayerData.job
end

function Node7.SetGang(source, gangName, grade)
    local player = Node7.GetPlayer(source)
    local gang = Node7Gangs[gangName]
    grade = tonumber(grade)
    if not player or not player.character or not gang or grade == nil or not getGrade(gang, grade) then return false, 'invalid_gang' end
    player.character.gang = { name = gangName, grade = grade }
    Node7.RefreshPlayerData(source, false, true)
    Node7.MarkPlayerDirty(source)
    TriggerClientEvent('node7:client:gangChanged', source, player.character.gang)
    TriggerClientEvent('Node7:Client:OnGangUpdate', source, player.PlayerData.gang)
    TriggerEvent('node7:server:gangChanged', source, player.character.gang)
    return true, player.PlayerData.gang
end

function Node7.SetDuty(source, state)
    local player = Node7.GetPlayer(source)
    if not player or not player.character then return false, 'player_not_loaded' end
    player.character.job.duty = state == true
    Node7.RefreshPlayerData(source, false, true)
    Node7.MarkPlayerDirty(source)
    TriggerClientEvent('node7:client:jobChanged', source, player.character.job)
    return true, player.PlayerData.job
end

RegisterNetEvent('node7:server:setDuty', function(state)
    Node7.SetDuty(source, state)
end)

exports('RegisterJob', Node7.RegisterJob)
exports('RegisterGang', Node7.RegisterGang)
exports('SetJob', Node7.SetJob)
exports('SetGang', Node7.SetGang)
exports('SetDuty', Node7.SetDuty)
exports('HasJobPermission', Node7.HasJobPermission)
exports('HasGangPermission', Node7.HasGangPermission)
exports('GetOrganizationBalance', Node7.GetOrganizationBalance)
exports('AddOrganizationMoney', Node7.AddOrganizationMoney)
exports('RemoveOrganizationMoney', Node7.RemoveOrganizationMoney)
