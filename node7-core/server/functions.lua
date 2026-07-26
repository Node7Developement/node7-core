Node7Core.Functions = {}
Node7Core.Player_Buckets = {}
Node7Core.Entity_Buckets = {}
Node7Core.UsableItems = {}


---Send the NODE7 western left-side notification UI without using ox_lib notifications.
---@param source number
---@param text string|table
---@param texttype? string
---@param length? number
---@param title? string
function Node7Core.Functions.Notify(source, text, texttype, length, title)
    source = tonumber(source) or source
    if source == 0 then
        local message = type(text) == 'table' and (text.description or text.title) or text
        print(('[node7-core] %s'):format(tostring(message or 'Notification')))
        return true
    end
    TriggerClientEvent('Node7Core:Notify', source, text, texttype, length, title)
    return true
end

exports('Notify', Node7Core.Functions.Notify)

---Send an explicit NODE7 western left-side notification card.
---@param source number
---@param title string
---@param description string
---@param iconDict? string
---@param icon? string
---@param duration? number
---@param color? string
---@param soundDict? string
---@param soundName? string
function Node7Core.Functions.NotifyLeft(source, title, description, iconDict, icon, duration, color, soundDict, soundName)
    source = tonumber(source) or source
    if not source or source == 0 then return false end
    TriggerClientEvent('Node7Core:NotifyLeft', source, title, description, iconDict, icon, duration, color, soundDict, soundName)
    return true
end

exports('NotifyLeft', Node7Core.Functions.NotifyLeft)

---Send the screenshot-style NODE7 western alert card.
---@param source number
---@param description string
---@param duration? number
---@param title? string
---@param iconDict? string
---@param icon? string
function Node7Core.Functions.NotifyAlert(source, description, duration, title, iconDict, icon)
    source = tonumber(source) or source
    if not source or source == 0 then return false end
    TriggerClientEvent('Node7Core:NotifyAlert', source, description, duration, title, iconDict, icon)
    return true
end

exports('NotifyAlert', Node7Core.Functions.NotifyAlert)

-- Getters
-- Get your player first and then trigger a function on them
-- ex: local player = Node7Core.Functions.GetPlayer(source)
-- ex: local example = player.Functions.functionname(parameter)

---Gets the coordinates of an entity
---@param entity number
---@return vector4
function Node7Core.Functions.GetCoords(entity)
    local coords = GetEntityCoords(entity, false)
    local heading = GetEntityHeading(entity)
    return vector4(coords.x, coords.y, coords.z, heading)
end

---Gets player identifier of the given type
---@param source any
---@param idtype string
---@return string?
function Node7Core.Functions.GetIdentifier(source, idtype)
    return GetPlayerIdentifierByType(source, idtype or 'license')
end

---Gets a players server id (source). Returns 0 if no player is found.
---@param identifier string
---@return number
function Node7Core.Functions.GetSource(identifier)
    for src, _ in pairs(Node7Core.Players) do
        local idens = GetPlayerIdentifiers(src)
        for _, id in pairs(idens) do
            if identifier == id then
                return src
            end
        end
    end
    return 0
end

---Get player with given server id (source)
---@param source any
---@return table
function Node7Core.Functions.GetPlayer(source)
    local numericSource = tonumber(source)
    if numericSource then return Node7Core.Players[numericSource] end
    return Node7Core.Players[Node7Core.Functions.GetSource(source)]
end

---Get player by citizen id
---@param citizenid string
---@return table?
function Node7Core.Functions.GetPlayerByCitizenId(citizenid)
    return Node7Core.PlayersByCitizenId[citizenid]
end

---Get offline player by citizen id
---@param citizenid string
---@return table?
function Node7Core.Functions.GetOfflinePlayerByCitizenId(citizenid)
    return Node7Core.Player.GetOfflinePlayer(citizenid)
end

---Get player by license
---@param license string
---@return table?
function Node7Core.Functions.GetPlayerByLicense(license)
    return Node7Core.Player.GetPlayerByLicense(license)
end

---Get player by account id
---@param account string
---@return table?
function Node7Core.Functions.GetPlayerByAccount(account)
    for src in pairs(Node7Core.Players) do
        if Node7Core.Players[src].PlayerData.charinfo.account == account then
            return Node7Core.Players[src]
        end
    end
    return nil
end

---Get player passing property and value to check exists
---@param property string
---@param value string
---@return table?
function Node7Core.Functions.GetPlayerByCharInfo(property, value)
    for src in pairs(Node7Core.Players) do
        local charinfo = Node7Core.Players[src].PlayerData.charinfo
        if charinfo[property] ~= nil and charinfo[property] == value then
            return Node7Core.Players[src]
        end
    end
    return nil
end

---Get all players. Returns the server ids of all players.
---@return table
function Node7Core.Functions.GetPlayers()
    local sources = {}
    for k in pairs(Node7Core.Players) do
        sources[#sources + 1] = k
    end
    return sources
end

---Will return an array of NODE7 Player class instances
---unlike the GetPlayers() wrapper which only returns IDs
---@return table
function Node7Core.Functions.GetNODE7Players()
    return Node7Core.Players
end

---Gets a list of all on duty players of a specified job and the number
---@param job string
---@return table, number
function Node7Core.Functions.GetPlayersOnDuty(job)
    local players = {}
    local count = 0
    for src, Player in pairs(Node7Core.Players) do
        if Player.PlayerData.job.name == job then
            if Player.PlayerData.job.onduty then
                players[#players + 1] = src
                count += 1
            end
        end
    end
    return players, count
end

---Returns only the amount of players on duty for the specified job
---@param job string
---@return number
function Node7Core.Functions.GetDutyCount(job)
    local count = 0
    for _, Player in pairs(Node7Core.Players) do
        if Player.PlayerData.job.name == job then
            if Player.PlayerData.job.onduty then
                count += 1
            end
        end
    end
    return count
end

--- @param source number source player's server ID.
--- @param coords vector The coordinates to calculate the distance from. Can be a table with x, y, z fields or a vector3. If not provided, the source player's Ped's coordinates are used.
--- @return string closestPlayer - The Player that is closest to the source player (or the provided coordinates). Returns -1 if no Players are found.
--- @return number closestDistance - The distance to the closest Player. Returns -1 if no Players are found.
function Node7Core.Functions.GetClosestPlayer(source, coords)
    local ped = GetPlayerPed(source)
    local players = GetPlayers()
    local closestDistance, closestPlayer = -1, -1
    if coords then coords = type(coords) == 'table' and vector3(coords.x, coords.y, coords.z) or coords end
    if not coords then coords = GetEntityCoords(ped) end
    for i = 1, #players do
        local playerId = players[i]
        local playerPed = GetPlayerPed(playerId)
        if playerPed ~= ped then
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - coords)
            if closestDistance == -1 or distance < closestDistance then
                closestPlayer = playerId
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end

--- @param source number source player's server ID.
--- @param coords vector The coordinates to calculate the distance from. Can be a table with x, y, z fields or a vector3. If not provided, the source player's Ped's coordinates are used.
--- @return number closestObject - The Object that is closest to the source player (or the provided coordinates). Returns -1 if no Objects are found.
--- @return number closestDistance - The distance to the closest Object. Returns -1 if no Objects are found.
function Node7Core.Functions.GetClosestObject(source, coords)
    local ped = GetPlayerPed(source)
    local objects = GetAllObjects()
    local closestDistance, closestObject = -1, -1
    if coords then coords = type(coords) == 'table' and vector3(coords.x, coords.y, coords.z) or coords end
    if not coords then coords = GetEntityCoords(ped) end
    for i = 1, #objects do
        local objectCoords = GetEntityCoords(objects[i])
        local distance = #(objectCoords - coords)
        if closestDistance == -1 or closestDistance > distance then
            closestObject = objects[i]
            closestDistance = distance
        end
    end
    return closestObject, closestDistance
end

--- @param source number source player's server ID.
--- @param coords vector The coordinates to calculate the distance from. Can be a table with x, y, z fields or a vector3. If not provided, the source player's Ped's coordinates are used.
--- @return number closestVehicle - The Vehicle that is closest to the source player (or the provided coordinates). Returns -1 if no Vehicles are found.
--- @return number closestDistance - The distance to the closest Vehicle. Returns -1 if no Vehicles are found.
function Node7Core.Functions.GetClosestVehicle(source, coords)
    local ped = GetPlayerPed(source)
    local vehicles = GetAllVehicles()
    local closestDistance, closestVehicle = -1, -1
    if coords then coords = type(coords) == 'table' and vector3(coords.x, coords.y, coords.z) or coords end
    if not coords then coords = GetEntityCoords(ped) end
    for i = 1, #vehicles do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local distance = #(vehicleCoords - coords)
        if closestDistance == -1 or closestDistance > distance then
            closestVehicle = vehicles[i]
            closestDistance = distance
        end
    end
    return closestVehicle, closestDistance
end

--- @param source number source player's server ID.
--- @param coords vector The coordinates to calculate the distance from. Can be a table with x, y, z fields or a vector3. If not provided, the source player's Ped's coordinates are used.
--- @return number closestPed - The Ped that is closest to the source player (or the provided coordinates). Returns -1 if no Peds are found.
--- @return number closestDistance - The distance to the closest Ped. Returns -1 if no Peds are found.
function Node7Core.Functions.GetClosestPed(source, coords)
    local ped = GetPlayerPed(source)
    local peds = GetAllPeds()
    local closestDistance, closestPed = -1, -1
    if coords then coords = type(coords) == 'table' and vector3(coords.x, coords.y, coords.z) or coords end
    if not coords then coords = GetEntityCoords(ped) end
    for i = 1, #peds do
        if peds[i] ~= ped then
            local pedCoords = GetEntityCoords(peds[i])
            local distance = #(pedCoords - coords)
            if closestDistance == -1 or closestDistance > distance then
                closestPed = peds[i]
                closestDistance = distance
            end
        end
    end
    return closestPed, closestDistance
end

-- Routing buckets (Only touch if you know what you are doing)

---Returns the objects related to buckets, first returned value is the player buckets, second one is entity buckets
---@return table, table
function Node7Core.Functions.GetBucketObjects()
    return Node7Core.Player_Buckets, Node7Core.Entity_Buckets
end

---Will set the provided player id / source into the provided bucket id
---@param source any
---@param bucket any
---@return boolean
function Node7Core.Functions.SetPlayerBucket(source, bucket)
    if source and bucket then
        local plicense = Node7Core.Functions.GetIdentifier(source, 'license')
        Player(source).state:set('instance', bucket, true)
        SetPlayerRoutingBucket(source, bucket)
        Node7Core.Player_Buckets[plicense] = { id = source, bucket = bucket }
        return true
    else
        return false
    end
end

---Will set any entity into the provided bucket, for example peds / vehicles / props / etc.
---@param entity number
---@param bucket number
---@return boolean
function Node7Core.Functions.SetEntityBucket(entity, bucket)
    if entity and bucket then
        SetEntityRoutingBucket(entity, bucket)
        Node7Core.Entity_Buckets[entity] = { id = entity, bucket = bucket }
        return true
    else
        return false
    end
end

---Will return an array of all the player ids inside the current bucket
---@param bucket number
---@return table|boolean
function Node7Core.Functions.GetPlayersInBucket(bucket)
    local curr_bucket_pool = {}
    if Node7Core.Player_Buckets and next(Node7Core.Player_Buckets) then
        for _, v in pairs(Node7Core.Player_Buckets) do
            if v.bucket == bucket then
                curr_bucket_pool[#curr_bucket_pool + 1] = v.id
            end
        end
        return curr_bucket_pool
    else
        return false
    end
end

---Will return an array of all the entities inside the current bucket
---(not for player entities, use GetPlayersInBucket for that)
---@param bucket number
---@return table|boolean
function Node7Core.Functions.GetEntitiesInBucket(bucket)
    local curr_bucket_pool = {}
    if Node7Core.Entity_Buckets and next(Node7Core.Entity_Buckets) then
        for _, v in pairs(Node7Core.Entity_Buckets) do
            if v.bucket == bucket then
                curr_bucket_pool[#curr_bucket_pool + 1] = v.id
            end
        end
        return curr_bucket_pool
    else
        return false
    end
end

---Server side vehicle creation with optional callback
---the CreateVehicle RPC still uses the client for creation so players must be near
---@param source any
---@param model any
---@param coords vector
---@param warp boolean
---@return number
function Node7Core.Functions.SpawnVehicle(source, model, coords, warp)
    local ped = GetPlayerPed(source)
    model = type(model) == 'string' and joaat(model) or model
    if not coords then coords = GetEntityCoords(ped) end
    local heading = coords.w and coords.w or 0.0
    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, true)
    while not DoesEntityExist(veh) do Wait(0) end
    if warp then
        while GetVehiclePedIsIn(ped) ~= veh do
            Wait(0)
            TaskWarpPedIntoVehicle(ped, veh, -1)
        end
    end
    while NetworkGetEntityOwner(veh) ~= source do Wait(0) end
    return veh
end

--- New & more reliable server side native for creating vehicles
---comment
---@param source any
---@param model any
---@param vehtype any
-- The appropriate vehicle type for the model info.
-- Can be one of automobile, bike, boat, heli, plane, submarine, trailer, and (potentially), train.
-- This should be the same type as the type field in vehicles.meta.
---@param coords vector
---@param warp boolean
---@return number
function Node7Core.Functions.CreateVehicle(source, model, vehtype, coords, warp)
    model = type(model) == 'string' and joaat(model) or model
    vehtype = type(vehtype) == 'string' and tostring(vehtype) or vehtype
    if not coords then coords = GetEntityCoords(GetPlayerPed(source)) end
    local heading = coords.w and coords.w or 0.0
    local veh = CreateVehicleServerSetter(model, vehtype, coords, heading)
    while not DoesEntityExist(veh) do Wait(0) end
    if warp then TaskWarpPedIntoVehicle(GetPlayerPed(source), veh, -1) end
    return veh
end

---Paychecks (standalone - don't touch)
function PaycheckInterval()
    if next(Node7Core.Players) then
        for _, Player in pairs(Node7Core.Players) do
            if Player then
                local payment = Node7Shared.Jobs[Player.PlayerData.job.name]['grades'][tostring(Player.PlayerData.job.grade.level)].payment
                if not payment then payment = Player.PlayerData.job.payment end
                if Player.PlayerData.job and payment > 0 and (Node7Shared.Jobs[Player.PlayerData.job.name].offDutyPay or Player.PlayerData.job.onduty) then
                    if Node7Core.Config.Money.PayCheckSociety then
                        local account = exports['node7-banking']:GetAccountBalance(Player.PlayerData.job.name)
                        if account ~= 0 then          -- Checks if player is employed by a society
                            if account < payment then -- Checks if company has enough money to pay society
                                Node7Core.Functions.Notify(Player.PlayerData.source, {title = Lang:t('error.company_too_poor'), type = 'error', duration = 5000 })
                            else
                                Player.Functions.AddMoney('bank', payment, 'paycheck')
                                exports['node7-banking']:RemoveMoney(Player.PlayerData.job.name, payment, 'Employee Paycheck')
                                Node7Core.Functions.Notify(Player.PlayerData.source, {title = Lang:t('info.received_paycheck', { value = payment }), type = 'info', duration = 5000 })
                            end
                        else
                            Player.Functions.AddMoney('bank', payment, 'paycheck')
                            Node7Core.Functions.Notify(Player.PlayerData.source, {title = Lang:t('info.received_paycheck', { value = payment }), type = 'info', duration = 5000 })
                        end
                    else
                        Player.Functions.AddMoney('bank', payment, 'paycheck')
                        Node7Core.Functions.Notify(Player.PlayerData.source, {title = Lang:t('info.received_paycheck', { value = payment }), type = 'info', duration = 5000 })
                    end
                end
            end
        end
    end
    SetTimeout(Node7Core.Config.Money.PayCheckTimeOut * (60 * 1000), PaycheckInterval)
end

-- Callback Functions --

---Trigger a registered client callback. Supports callback and await styles.
---@param name string
---@param source number
---@param ... any
function Node7Core.Functions.TriggerClientCallback(name, source, ...)
    source = tonumber(source)
    if not source then return nil end

    local cb = nil
    local args = { ... }
    if Node7Core.Shared.IsFunction(args[1]) then
        cb = args[1]
        table.remove(args, 1)
    end

    local callbackKey = name .. ':' .. source
    local request = {
        callback = cb,
        promise = promise.new()
    }
    Node7Core.ClientCallbacks[callbackKey] = request

    TriggerClientEvent('Node7Core:Client:TriggerClientCallback', source, name, table.unpack(args))

    if cb == nil then
        Citizen.Await(request.promise)
        local value = request.promise.value
        Node7Core.ClientCallbacks[callbackKey] = nil
        return value
    end
end

---Create a server callback.
---@param name string
---@param cb function
function Node7Core.Functions.CreateCallback(name, cb)
    Node7Core.ServerCallbacks[name] = cb
end

---Execute a server callback directly.
---@param name string
---@param source number
---@param cb function
---@param ... any
function Node7Core.Functions.TriggerCallback(name, source, cb, ...)
    local handler = Node7Core.ServerCallbacks[name]
    if not handler then return false end
    handler(source, cb, ...)
    return true
end

-- Items

---Create a usable item
---@param item string
---@param data function
function Node7Core.Functions.CreateUseableItem(item, data)
    Node7Core.UsableItems[item] = data
end

---Checks if the given item is usable
---@param item string
---@return any
function Node7Core.Functions.CanUseItem(item)
    return Node7Core.UsableItems[item]
end

---Use item
---@param source any
---@param item string
function Node7Core.Functions.UseItem(source, item)
    if GetResourceState('node7-inventory') ~= 'started' then return end
    pcall(function()
        exports['node7-inventory']:UseItem(source, item)
    end)
end

---Kick Player
---@param source any
---@param reason string
---@param setKickReason boolean
---@param deferrals boolean
function Node7Core.Functions.Kick(source, reason, setKickReason, deferrals)
    reason = '\n' .. reason .. '\n🔸 Check our Discord for further information: ' .. Node7Core.Config.Server.Discord
    if setKickReason then
        setKickReason(reason)
    end
    CreateThread(function()
        if deferrals then
            deferrals.update(reason)
            Wait(2500)
        end
        if source then
            DropPlayer(source, reason)
        end
        for _ = 0, 4 do
            while true do
                if source then
                    if GetPlayerPing(source) >= 0 then
                        break
                    end
                    Wait(100)
                    CreateThread(function()
                        DropPlayer(source, reason)
                    end)
                end
            end
            Wait(5000)
        end
    end)
end

---Check if player is whitelisted, kept like this for backwards compatibility or future plans
---@param source any
---@return boolean
function Node7Core.Functions.IsWhitelisted(source)
    if not Node7Core.Config.Server.Whitelist then return true end
    if Node7Core.Functions.HasPermission(source, Node7Core.Config.Server.WhitelistPermission) then return true end
    return false
end

-- Setting & Removing Permissions

local permissionGroupAliases = {
    owner = 'group.node7_owner',
    god = 'group.node7_owner',
    admin = 'group.node7_admin',
    moderator = 'group.node7_moderator',
    mod = 'group.node7_moderator',
    staff = 'group.node7_staff',
}

local function resolvePermissionGroup(permission)
    return permissionGroupAliases[tostring(permission or ''):lower()]
end

---Add permission for player
---@param source any
---@param permission string
function Node7Core.Functions.AddPermission(source, permission)
    local group = resolvePermissionGroup(permission)
    if not group then return false, 'invalid_permission' end
    if not Node7Core.Functions.HasPermission(source, permission) then
        ExecuteCommand(('add_principal player.%s %s'):format(source, group))
        Node7Core.Commands.Refresh(source)
    end
    return true
end

---Remove permission from player
---@param source any
---@param permission string
function Node7Core.Functions.RemovePermission(source, permission)
    if permission then
        local group = resolvePermissionGroup(permission)
        if not group then return false, 'invalid_permission' end
        if Node7Core.Functions.HasPermission(source, permission) then
            ExecuteCommand(('remove_principal player.%s %s'):format(source, group))
            Node7Core.Commands.Refresh(source)
        end
        return true
    end

    local removed = {}
    for _, v in pairs(Node7Core.Config.Server.Permissions) do
        local group = resolvePermissionGroup(v)
        if group and not removed[group] and Node7Core.Functions.HasPermission(source, v) then
            ExecuteCommand(('remove_principal player.%s %s'):format(source, group))
            removed[group] = true
        end
    end
    Node7Core.Commands.Refresh(source)
    return true
end

-- Checking for Permission Level

---Check if player has permission
---@param source any
---@param permission string
---@return boolean
function Node7Core.Functions.HasPermission(source, permission)
    local function has(permissionName)
        permissionName = tostring(permissionName or ''):lower()
        if permissionName == '' then return false end
        return IsPlayerAceAllowed(source, permissionName)
            or IsPlayerAceAllowed(source, ('node7.%s'):format(permissionName))
            or IsPlayerAceAllowed(source, ('rsgcore.%s'):format(permissionName))
    end

    if type(permission) == 'string' then
        return has(permission)
    elseif type(permission) == 'table' then
        for _, permLevel in pairs(permission) do
            if has(permLevel) then return true end
        end
    end

    return false
end

---Get the players permissions
---@param source any
---@return table
function Node7Core.Functions.GetPermission(source)
    local src = source
    local perms = {}
    for _, v in pairs(Node7Core.Config.Server.Permissions) do
        if Node7Core.Functions.HasPermission(src, v) then
            perms[v] = true
        end
    end
    return perms
end

---Get admin messages opt-in state for player
---@param source any
---@return boolean
function Node7Core.Functions.IsOptin(source)
    local license = Node7Core.Functions.GetIdentifier(source, 'license')
    if not license or not Node7Core.Functions.HasPermission(source, 'admin') then return false end
    local Player = Node7Core.Functions.GetPlayer(source)
    return Player.PlayerData.optin
end

---Toggle opt-in to admin messages
---@param source any
function Node7Core.Functions.ToggleOptin(source)
    local license = Node7Core.Functions.GetIdentifier(source, 'license')
    if not license or not Node7Core.Functions.HasPermission(source, 'admin') then return end
    local Player = Node7Core.Functions.GetPlayer(source)
    Player.PlayerData.optin = not Player.PlayerData.optin
    Player.Functions.SetPlayerData('optin', Player.PlayerData.optin)
end

---Check if player is banned
---@param source any
---@return boolean, string?
function Node7Core.Functions.IsPlayerBanned(source)
    local plicense = Node7Core.Functions.GetIdentifier(source, 'license')
    local result = MySQL.single.await('SELECT id, reason, expire FROM bans WHERE license = ?', { plicense })
    if not result then return false end
    if os.time() < result.expire then
        local timeTable = os.date('*t', tonumber(result.expire))
        return true, 'You have been banned from the server:\n' .. result.reason .. '\nYour ban expires ' .. timeTable.day .. '/' .. timeTable.month .. '/' .. timeTable.year .. ' ' .. timeTable.hour .. ':' .. timeTable.min .. '\n'
    else
        MySQL.query('DELETE FROM bans WHERE id = ?', { result.id })
    end
    return false
end

---Get an online character's blood type.
---@param source number
---@return string?
function Node7Core.Functions.GetBloodType(source)
    local player = Node7Core.Functions.GetPlayer(source)
    return player and player.Functions.GetBloodType() or nil
end

---Set an online character's blood type.
---@param source number
---@param bloodType string
---@return boolean, string
function Node7Core.Functions.SetBloodType(source, bloodType)
    local player = Node7Core.Functions.GetPlayer(source)
    if not player then return false, 'player_not_found' end
    return player.Functions.SetBloodType(bloodType)
end

-- Retrieves information about the database connection.
--- @return table; A table containing the database information.
function Node7Core.Functions.GetDatabaseInfo()
    local details = {
        exists = false,
        database = "",
    }
    local connectionString = GetConvar("mysql_connection_string", "")

    if connectionString == "" then
        return details
    elseif connectionString:find("mysql://") then
        connectionString = connectionString:sub(9, -1)
        details.database = connectionString:sub(connectionString:find("/") + 1, -1):gsub("[%?]+[%w%p]*$", "")
        details.exists = true
        return details
    else
        connectionString = { string.strsplit(";", connectionString) }

        for i = 1, #connectionString do
            local v = connectionString[i]
            if v:match("database") then
                details.database = v:sub(10, #v)
                details.exists = true
                return details
            end
        end
    end
end

---Check for duplicate license
---@param license any
---@return boolean
function Node7Core.Functions.IsLicenseInUse(license)
    local players = GetPlayers()
    for _, player in pairs(players) do
        local playerLicense = Node7Core.Functions.GetIdentifier(player, 'license')
        if playerLicense == license then return true end
    end
    return false
end

-- Utility functions

---Check if a player has an item [deprecated]
---@param source any
---@param items table|string
---@param amount number
---@return boolean
function Node7Core.Functions.HasItem(source, items, amount)
    amount = amount or 1
    if GetResourceState('node7-inventory') == 'started' then
        local ok, result = pcall(function()
            return exports['node7-inventory']:HasItem(source, items, amount)
        end)
        if ok then return result end
    end

    if GetResourceState('ox_inventory') == 'started' then
        local ok, count = pcall(function()
            return exports.ox_inventory:Search(source, 'count', items)
        end)
        if ok then return tonumber(count) and tonumber(count) >= amount end
    end

    return false
end

---???? ... ok
---@param source any
---@param data any
---@param pattern any
---@return boolean
function Node7Core.Functions.PrepForSQL(source, data, pattern)
    data = tostring(data)
    local src = source
    local player = Node7Core.Functions.GetPlayer(src)
    local result = string.match(data, pattern)
    if not result or string.len(result) ~= string.len(data) then
        TriggerEvent('node7-log:server:CreateLog', 'anticheat', 'SQL Exploit Attempted', 'red', string.format('%s attempted to exploit SQL!', player.PlayerData.license))
        return false
    end
    return true
end

---Change weight to player
---@param source any
---@param weight number
---@return boolean
function Node7Core.Functions.ChangeWeight(source, weight)
    local Player = Node7Core.Functions.GetPlayer(source)
    if not Player then return end

    Player.Functions.SetPlayerData('weight', weight)
end

---Change slots to player
---@param source any
---@param slots number
---@return boolean
function Node7Core.Functions.ChangeSlots(source, slots)
    local Player = Node7Core.Functions.GetPlayer(source)
    if not Player then return end

    Player.Functions.SetPlayerData('slots', slots)
end

--- Checks if a player has enough weight capacity to carry a specific amount of an item
-- @param source number - The server ID of the player
-- @param item string - The name of the item
-- @param amount number - The quantity of the item to check
-- @return boolean - True if the player can carry it, false if they cannot
Node7Core.Functions.CanCarryItem = function(source, item, amount)
    local Player = Node7Core.Functions.GetPlayer(source)
    if not Player then return false end

    -- Fallback to 1 if amount isn't provided
    amount = tonumber(amount) or 1

    -- Fetch item data from the framework's shared config to get its weight
    local itemData = Node7Core.Shared.Items[item:lower()]
    if not itemData then 
        print(("^1[NODE7-Core] Error:^7 Item '%s' does not exist in shared items."):format(item))
        return false 
    end

    -- Calculate the total weight of the incoming items
    local itemWeight = itemData.weight or 0
    local incomingWeight = itemWeight * amount

    -- Get the player's current total inventory weight and max capacity
    -- Note: Depending on your specific node7-inventory version, this might also be accessed via exports
    local currentWeight = 0
    if GetResourceState('node7-inventory') == 'started' then
        local ok, weight = pcall(function()
            return exports['node7-inventory']:GetTotalWeight(Player.PlayerData.items)
        end)
        if ok then currentWeight = tonumber(weight) or 0 end
    end
    local maxWeight = Player.PlayerData.MaxWeight or 120000 -- Fallback default weight if not set

    -- Check if the new total exceeds the limit
    if (currentWeight + incomingWeight) <= maxWeight then
        return true
    else
        return false
    end
end
