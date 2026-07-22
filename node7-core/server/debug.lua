local function printTable(value, indent, visited)
    indent = indent or 0
    visited = visited or {}
    if type(value) ~= 'table' then
        print(('%s%s'):format(string.rep('  ', indent), tostring(value)))
        return
    end
    if visited[value] then
        print(('%s<cycle>'):format(string.rep('  ', indent)))
        return
    end
    visited[value] = true
    for key, entry in pairs(value) do
        local prefix = ('%s^3%s:^7'):format(string.rep('  ', indent), tostring(key))
        if type(entry) == 'table' then
            print(prefix)
            printTable(entry, indent + 1, visited)
        else
            print(('%s %s'):format(prefix, tostring(entry)))
        end
    end
end

function Node7Debug(value, indent)
    local resource = GetInvokingResource() or GetCurrentResourceName()
    print(('^3[%s | NODE7 DEBUG]^7'):format(resource))
    printTable(value, tonumber(indent) or 0)
    print('^3[NODE7 DEBUG END]^7')
end

function Node7ShowError(resource, message)
    print(('^1[%s | ERROR]^7 %s'):format(resource or 'NODE7', tostring(message)))
end

function Node7ShowSuccess(resource, message)
    print(('^2[%s | SUCCESS]^7 %s'):format(resource or 'NODE7', tostring(message)))
end

RegisterNetEvent('node7:server:debug', function(value, indent)
    Node7Debug(value, indent)
end)

exports('Debug', Node7Debug)
exports('ShowError', Node7ShowError)
exports('ShowSuccess', Node7ShowSuccess)
