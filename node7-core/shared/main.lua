Node7Shared = {
    Items = {},
    Jobs = {},
    Gangs = {},
    Horses = {},
    Vehicles = {},
    Weapons = {},
    WeaponsByName = {},
    AmmoTypes = {},
    ItemCategories = {}
}

local stringCharacters, numberCharacters = {}, {}
for index = 48, 57 do numberCharacters[#numberCharacters + 1] = string.char(index) end
for index = 65, 90 do stringCharacters[#stringCharacters + 1] = string.char(index) end
for index = 97, 122 do stringCharacters[#stringCharacters + 1] = string.char(index) end

function Node7Shared.RandomStr(length)
    if length <= 0 then return '' end
    return Node7Shared.RandomStr(length - 1) .. stringCharacters[math.random(1, #stringCharacters)]
end

function Node7Shared.RandomInt(length)
    if length <= 0 then return '' end
    return Node7Shared.RandomInt(length - 1) .. numberCharacters[math.random(1, #numberCharacters)]
end

function Node7Shared.SplitStr(value, delimiter)
    local result, from = {}, 1
    local first, last = string.find(value, delimiter, from)
    while first do
        result[#result + 1] = string.sub(value, from, first - 1)
        from = last + 1
        first, last = string.find(value, delimiter, from)
    end
    result[#result + 1] = string.sub(value, from)
    return result
end

function Node7Shared.Trim(value)
    if value == nil then return nil end
    return (tostring(value):gsub('^%s*(.-)%s*$', '%1'))
end

function Node7Shared.Round(value, decimals)
    if not decimals then return math.floor(value + 0.5) end
    local power = 10 ^ decimals
    return math.floor((value * power) + 0.5) / power
end
