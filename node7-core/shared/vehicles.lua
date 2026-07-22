Node7Shared.Vehicles = {
    buggy01 = { label = 'Buggy 01', model = 'BUGGY01' },
    buggy02 = { label = 'Buggy 02', model = 'BUGGY02' },
    buggy03 = { label = 'Buggy 03', model = 'BUGGY03' },
    cart01 = { label = 'Cart 01', model = 'CART01' },
    cart02 = { label = 'Cart 02', model = 'CART02' },
    cart03 = { label = 'Cart 03', model = 'CART03' },
    cart04 = { label = 'Cart 04', model = 'CART04' },
    cart05 = { label = 'Cart 05', model = 'CART05' },
    cart06 = { label = 'Cart 06', model = 'CART06' },
    cart07 = { label = 'Cart 07', model = 'CART07' },
    cart08 = { label = 'Cart 08', model = 'CART08' },
    coach2 = { label = 'Coach 2', model = 'COACH2' },
    coach3 = { label = 'Coach 3', model = 'COACH3' },
    coach4 = { label = 'Coach 4', model = 'COACH4' },
    coach5 = { label = 'Coach 5', model = 'COACH5' },
    coach6 = { label = 'Coach 6', model = 'COACH6' },
    stagecoach001x = { label = 'Stagecoach 001', model = 'STAGECOACH001X' },
    stagecoach002x = { label = 'Stagecoach 002', model = 'STAGECOACH002X' },
    stagecoach003x = { label = 'Stagecoach 003', model = 'STAGECOACH003X' },
    stagecoach004x = { label = 'Stagecoach 004', model = 'STAGECOACH004X' },
    stagecoach005x = { label = 'Stagecoach 005', model = 'STAGECOACH005X' },
    stagecoach006x = { label = 'Stagecoach 006', model = 'STAGECOACH006X' },
    wagon02x = { label = 'Wagon 02', model = 'WAGON02X' },
    wagon03x = { label = 'Wagon 03', model = 'WAGON03X' },
    wagon04x = { label = 'Wagon 04', model = 'WAGON04X' },
    wagon05x = { label = 'Wagon 05', model = 'WAGON05X' },
    wagon06x = { label = 'Wagon 06', model = 'WAGON06X' },
    wagonarmoured = { label = 'Armoured Wagon', model = 'WAGONARMOURED01X' },
    wagondairy = { label = 'Dairy Wagon', model = 'WAGONDAIRY01X' },
    wagonwork = { label = 'Work Wagon', model = 'WAGONWORK01X' },
    wagontraveller = { label = 'Traveller Wagon', model = 'WAGONTRAVELLER01X' },
    wagonprison = { label = 'Prison Wagon', model = 'WAGONPRISON01X' },
    wagoncircus01 = { label = 'Circus Wagon 01', model = 'WAGONCIRCUS01X' },
    wagoncircus02 = { label = 'Circus Wagon 02', model = 'WAGONCIRCUS02X' },
    chuckwagon = { label = 'Chuck Wagon', model = 'CHUCKWAGON000X' },
    chuckwagon02 = { label = 'Chuck Wagon 02', model = 'CHUCKWAGON002X' },
    huntercart = { label = 'Hunter Cart', model = 'HUNTERCART01' },
    supplywagon = { label = 'Supply Wagon', model = 'SUPPLYWAGON' },
    oilwagon01 = { label = 'Oil Wagon 01', model = 'OILWAGON01X' },
    oilwagon02 = { label = 'Oil Wagon 02', model = 'OILWAGON02X' },
    logwagon = { label = 'Log Wagon', model = 'LOGWAGON' },
    warwagon = { label = 'War Wagon', model = 'WARWAGON2' }
}
Node7WagonModels = Node7Shared.Vehicles

function Node7ResolveWagonModel(value)
    if type(value) ~= 'string' then return nil end
    local needle = value:lower()
    if Node7WagonModels[needle] then return Node7WagonModels[needle], needle end
    for key, entry in pairs(Node7WagonModels) do
        if entry.model:lower() == needle then return entry, key end
    end
end

function Node7NormalizeWagonDefinition(key, entry)
    assert(type(key) == 'string' and type(entry) == 'table' and type(entry.model) == 'string', 'Invalid NODE7 wagon definition')
    entry.key = key
    entry.name = entry.name or entry.label
    entry.label = entry.label or entry.name
    entry.brand = entry.brand or 'NODE7'
    entry.price = tonumber(entry.price) or 100
    entry.category = entry.category or 'wagons'
    entry.type = entry.type or 'wagon'
    entry.hash = entry.hash or joaat(entry.model)
    entry.shop = entry.shop or 'wagon'
    entry.metadata = entry.metadata or { condition = 100, storage = true }
    return entry
end

for key, entry in pairs(Node7WagonModels) do
    Node7WagonModels[key] = Node7NormalizeWagonDefinition(key, entry)
end
