Node7Config = {}

Node7Config.Version = '1.3.4'
Node7Config.Locale = 'en'
Node7Config.Debug = GetConvar('node7_environment', 'development') == 'development'
Node7Config.ServerName = GetConvar('node7_serverName', 'NODE7 LABS')
Node7Config.DatabaseName = 'node7_core'

Node7Config.SaveInterval = 60000
Node7Config.PaycheckInterval = 600000
Node7Config.CallbackRateLimit = 40
Node7Config.DefaultCharacterSlots = 3
Node7Config.DefaultSpawn = vector4(-540.48, -2125.75, 6.01, 186.0)

Node7Config.StartingMoney = {
    cash = 25,
    bank = 100,
    gold = 0
}

Node7Config.PlayerMetadata = {
    hunger = 100.0,
    thirst = 100.0,
    stress = 0.0,
    alcohol = 0.0,
    armor = 0,
    isdead = false,
    inlaststand = false,
    ishandcuffed = false,
    jailtime = 0,
    criminalrecord = { hasRecord = false, date = nil },
    licences = { hunting = false, fishing = false, weapon = false },
    inside = { house = nil, property = nil },
    callsign = 'NO CALLSIGN',
    fingerprint = nil,
    bloodtype = 'O+',
    commandbinds = {},
    optin = true
}

Node7Config.Inventory = {
    maxSlots = 40,
    maxWeight = 30000,
    dropDistance = 3.0
}

Node7Config.Stables = {
    spawnDistance = 4.0,
    modelLoadTimeout = 10000,
    replaceActiveEntity = true,
    warpIntoAdminWagon = true
}

Node7Config.Status = {
    hungerDrain = 0.10,
    thirstDrain = 0.15,
    updateInterval = 60000
}

Node7Config.UI = {
    accent = '#d4af37',
    notifications = true,
    hud = true
}

Node7Config.Security = {
    maxItemTransfer = 100,
    maxMoneyTransfer = 100000,
    logDeniedActions = true
}

Node7Config.Permissions = {
    owner = 'node7.owner',
    admin = 'node7.admin',
    moderator = 'node7.moderator',
    staff = 'node7.staff'
}
