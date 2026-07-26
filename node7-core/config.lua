Node7Core = Node7Core or {}
Node7Core.Config = Node7Core.Config or {}
Node7Config = Node7Core.Config

Node7Config.MaxPlayers = GetConvarInt('sv_maxclients', 48) -- Gets max players from config file, default 48
Node7Config.DefaultSpawn = vector4(-325.29, 766.24, 117.48, 90.0)
Node7Config.UpdateInterval = 5                             -- how often to save player data in database in minutes
Node7Config.HidePlayerNames = true

Node7Config.Money = {}
Node7Config.Money.MoneyTypes = { cash = 50, bank = 0, bloodmoney = 0 } -- Persistent character money accounts. Cash can be represented by inventory items.
Node7Config.Money.AccountAliases = { valbank = 'bank', rhobank = 'bank', blkbank = 'bank', armbank = 'bank' } -- Legacy branch names resolve to the shared personal bank account.
Node7Config.Money.MigrateLegacyBranchBalances = true                   -- Keeps the highest bank/legacy branch value, then removes legacy branch keys.
Node7Config.Money.DontAllowMinus = { 'cash', 'bank', 'bloodmoney' }    -- Accounts that may never fall below zero.
Node7Config.Money.MinusLimit = -5000                                   -- Negative limit for custom accounts not listed above.
Node7Config.Money.MaxTransactionAmount = 100000000                     -- Maximum value accepted by one core money operation.
Node7Config.Money.PayCheckTimeOut = 10                                 -- The time in minutes that it will give the paycheck
Node7Config.Money.PayCheckSociety = false                              -- If true paycheck will come from the society account that the player is employed at, requires node7-management
Node7Config.Money.EnableMoneyItems = true                              -- If true, cash and bloodmoney use inventory items as the source of truth.


Node7Config.Notify = {
    DefaultTitle = 'NODE7',
    DefaultDuration = 5000,
    MinDuration = 1000,
    MaxDuration = 30000,
    EnableSound = true,
    DevelopmentMode = false,
    EnableTestCommand = true,
    TestCommand = 'node7notifytest',
    DefaultImage = 'images/default-portrait.png',
    DefaultSoundDict = 'Transaction_Feed_Sounds',
    DefaultSoundName = 'Transaction_Positive',
    AlertTitle = 'ALERT!!',
    AlertDuration = 7000,
    AlertImage = 'images/default-portrait.png',
    AlertSoundDict = 'Transaction_Feed_Sounds',
    AlertSoundName = 'Transaction_Negative',
    Types = {
        info = {
            title = 'NOTICE',
            image = 'images/default-portrait.png',
            soundName = 'Transaction_Positive',
        },
        success = {
            title = 'SUCCESS',
            image = 'images/default-portrait.png',
            soundName = 'Transaction_Positive',
        },
        error = {
            title = 'ERROR',
            image = 'images/default-portrait.png',
            soundName = 'Transaction_Negative',
        },
        warning = {
            title = 'WARNING',
            image = 'images/default-portrait.png',
            soundName = 'Transaction_Negative',
        },
        money = {
            title = 'BANKING',
            image = 'images/default-portrait.png',
            soundName = 'Transaction_Positive',
        },
        alert = {
            title = 'ALERT!!',
            image = 'images/default-portrait.png',
            soundName = 'Transaction_Negative',
        },
    },
}

Node7Config.Player = {}
Node7Config.Player.Bloodtypes = {
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-',
}

Node7Config.Player.PlayerDefaults = {
    citizenid = function() return Node7Core.Player.CreateCitizenId() end,
    cid = 1,
    money = function()
        local moneyDefaults = {}
        for moneytype, startamount in pairs(Node7Config.Money.MoneyTypes) do
            moneyDefaults[moneytype] = startamount
        end
        return moneyDefaults
    end,
    optin = true,
    charinfo = {
        firstname = 'Firstname',
        lastname = 'Lastname',
        birthdate = '00-00-0000',
        gender = 0,
        nationality = 'USA',
        account = function() return Node7Core.Functions.CreateAccountNumber() end
    },
    job = {
        name = 'unemployed',
        label = 'Civilian',
        payment = 10,
        type = 'none',
        onduty = false,
        isboss = false,
        grade = {
            name = 'Freelancer',
            level = 0
        }
    },
    gang = {
        name = 'none',
        label = 'No Gang Affiliation',
        isboss = false,
        grade = {
            name = 'none',
            level = 0
        }
    },
    metadata = {
        health = 600,
        hunger = 100,
        thirst = 100,
        cleanliness = 100,
        stress = 0,
        isdead = false,
        armor = 0,
        ishandcuffed = false,
        injail = 0,
        jailitems = {},
        status = {},
        rep = {},
        callsign = 'NO CALLSIGN',
        bloodtype = function() return Node7Config.Player.Bloodtypes[math.random(1, #Node7Config.Player.Bloodtypes)] end,
        fingerprint = function() return Node7Core.Player.CreateFingerId() end,
        walletid = function() return Node7Core.Player.CreateWalletId() end,
        criminalrecord = {
            hasRecord = false,
            date = nil
        },
    },
    position = Node7Config.DefaultSpawn,
    items = {},
    weight = 35000,
    slots = 25,
}

Node7Config.Server = {}                                    -- General server config
Node7Config.Server.Closed = false                          -- Set server closed (no one can join except people with ace permission 'node7admin.join')
Node7Config.Server.ClosedReason = 'Server Closed'          -- Reason message to display when people can't join the server
Node7Config.Server.Uptime = 0                              -- Time the server has been up.
Node7Config.Server.Whitelist = false                       -- Enable or disable whitelist on the server
Node7Config.Server.WhitelistPermission = 'admin'           -- Permission that's able to enter the server when the whitelist is on
Node7Config.Server.PVP = true                              -- Enable or disable pvp on the server (Ability to shoot other players)
Node7Config.Server.Discord = ''                            -- Discord invite link
Node7Config.Server.CheckDuplicateLicense = true            -- Check for duplicate rockstar license on join
Node7Config.Server.Permissions = { 'god', 'admin', 'mod' } -- Add as many groups as you want here after creating them in your server.cfg
Node7Config.Server.VersionCheck = false                 -- Keep false unless you host your own NODE7 version endpoint

Node7Config.Commands = {}                                  -- Command Configuration
Node7Config.Commands.OOCColor = { 255, 151, 133 }          -- RGB color code for the OOC command

Node7Config.PromptDistance = 1.5
Node7Config.Player.RevealMap = true
