Node7Core = Node7Core or {}
Node7Core.Config = Node7Core.Config or Node7Config or {}
Node7Core.Shared = Node7Core.Shared or Node7Shared or {}
Node7Core.ClientCallbacks = Node7Core.ClientCallbacks or {}
Node7Core.ServerCallbacks = Node7Core.ServerCallbacks or {}
Node7Core.PlayerData = Node7Core.PlayerData or {}

-- Preserve the historical Node7Shared global while making Node7Core.Shared
-- the canonical QBCore-style shared table.
Node7Shared = Node7Core.Shared

---Return the full core object or a filtered subset, matching QBCore usage.
---@param filters string[]?
---@return table
local function GetCoreObject(filters)
    if not filters then return Node7Core end

    local results = {}
    for i = 1, #filters do
        local key = filters[i]
        if Node7Core[key] ~= nil then
            results[key] = Node7Core[key]
        end
    end
    return results
end
exports('GetCoreObject', GetCoreObject)

---Return a shared namespace or one entry from it.
---@param namespace string
---@param item string?
---@return any
local function GetShared(namespace, item)
    local sharedNamespace = Node7Core.Shared[namespace]
    if sharedNamespace == nil then return nil end
    return item and sharedNamespace[item] or sharedNamespace
end
exports('GetShared', GetShared)
