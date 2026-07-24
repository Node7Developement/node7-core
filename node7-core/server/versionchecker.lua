local resourceName = GetCurrentResourceName()

if not (Node7Core and Node7Core.Config and Node7Core.Config.Server and Node7Core.Config.Server.VersionCheck) then
    return
end

local function printLog(kind, message)
    local color = (kind == 'success' and '^2') or (kind == 'warning' and '^3') or '^1'
    print(('[%s]%s %s^7'):format(resourceName, color, message))
end

printLog('success', 'Version checker disabled by default. Set Node7Config.Server.VersionCheck = true only after adding your NODE7 GitHub endpoint.')
