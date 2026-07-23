Node7Config = {}

Node7Config.Version = '2.0.0'
Node7Config.Locale = 'en'
Node7Config.Debug = GetConvar('node7_environment', 'development') == 'development'
Node7Config.ServerName = GetConvar('node7_serverName', 'NODE7 DEVELOPMENT STUDIOS')

-- Runtime-only core:
-- node7-core owns no player SQL, no citizen IDs, and no character slots.
-- node7-players owns persistence and passes selected PlayerData into this core.
Node7Config.RuntimeOnly = true

Node7Config.SaveInterval = 60000
Node7Config.PaycheckInterval = 600000
Node7Config.CallbackRateLimit = 40

Node7Config.Inventory = {
    maxSlots = 40,
    maxWeight = 30000,
    defaultName = 'main'
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
    hud = true,
    startup = false
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
