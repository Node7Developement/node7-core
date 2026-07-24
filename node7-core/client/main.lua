Node7Core = {}
Node7Core.PlayerData = {}
Node7Core.Config = Node7Config
Node7Core.Shared = Node7Shared
Node7Core.ClientCallbacks = {}
Node7Core.ServerCallbacks = {}

exports('GetCoreObject', function()
    return Node7Core
end)

-- To use this export in a script instead of manifest method
-- Just put this line of code below at the very top of the script
-- local Node7Core = exports['node7-core']:GetCoreObject()
