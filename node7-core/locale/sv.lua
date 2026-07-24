local Translations = {
    error = {
        not_online = 'Spelaren Ã¤r inte online',
        wrong_format = 'Felaktigt format',
        missing_args = 'Alla argument har inte angetts (x, y, z)',
        missing_args2 = 'Alla argument mÃ¥ste fyllas i!',
        no_access = 'Du har inte tillgÃ¥ng till detta kommando',
        company_too_poor = 'Din arbetsgivare Ã¤r pank',
        item_not_exist = 'Objektet finns inte',
        too_heavy = 'Ditt inventory Ã¤r fullt!',
        location_not_exist = 'Platsen finns inte',
        job_not_exist               = 'Job does not exist',
        gang_not_exist              = 'Gang does not exist',
        duplicate_license = 'Duplicerad Rockstar Licens Funnet',
        no_valid_license  = 'Ingen Giltig Rockstar Licens Hittades',
        not_whitelisted = 'Du Ã¤r inte whitelistad pÃ¥ servern',
        server_already_open = 'Servern Ã¤r redan Ã¶ppen',
        server_already_closed = 'Servern Ã¤r redan stÃ¤ngd',
        no_permission = 'Du har inte behÃ¶righeter fÃ¶r detta..',
        no_waypoint = 'Ingen waypoint satt.',
        tp_error = 'Fel vid teleportering.',
        connecting_database_error = 'Ett databasfel intrÃ¤ffade under anslutningen till servern.(Ã„r SQL-servern pÃ¥?)',
        connecting_database_timeout = 'Anslutning till databasen timed out.(Ã„r SQL-servern pÃ¥?)',
    },
    success = {
        server_opened = 'Servern har Ã¶ppnats',
        server_closed = 'Servern har stÃ¤ngts',
        teleported_waypoint = 'Teleporterad till waypoint.',
        job_set = 'Job set successfully',
        gang_set = 'Gang set successfully',
    },
    info = {
        received_paycheck = 'Du fick din lÃ¶necheck pÃ¥ SEK%{value}',
        job_info = 'Jobb: %{value} | Grad: %{value2} | TjÃ¤nst: %{value3}',
        gang_info = 'GÃ¤ng: %{value} | Grad: %{value2}',
        on_duty = 'Du Ã¤r nu i tjÃ¤nst!',
        off_duty = 'Du har gÃ¥tt ur tjÃ¤nst!',
        checking_ban = 'Hej %s. Validerar AnvÃ¤ndare.',
        join_server = 'VÃ¤lkommen %s.',
        checking_whitelisted = 'Hej %s. Vi kontrollerar din whitelist.',
        exploit_banned = 'Du har blivit bannad fÃ¶r fusk. Kontrollera vÃ¥r discord fÃ¶r mer information: %{discord}',
        exploit_dropped = 'Du har blivit sparkad fÃ¶r Exploitation',
    },
    command = {
        tp = {
            help = 'TP till spelare eller koords (Admin Only)',
            params = {
                x = { name = 'id/x', help = 'ID fÃ¶r spelare eller X-position'},
                y = { name = 'y', help = 'Y position'},
                z = { name = 'z', help = 'Z position'},
            },
        },
        tpm = { help = 'TP till markÃ¶r (Admin Only)' },
        togglepvp = { help = 'VÃ¤xla PvP pÃ¥ servern (Admin Only)' },
        addpermission = {
            help = 'Ge spelarbehÃ¶righeter (God Only)',
            params = {
                id = { name = 'id', help = 'ID pÃ¥ spelare' },
                permission = { name = 'permission', help = 'BehÃ¶righetsnivÃ¥' },
            },
        },
        removepermission = {
            help = 'Ta bort spelarbehÃ¶righeter (God Only)',
            params = {
                id = { name = 'id', help = 'ID pÃ¥ spelare' },
                permission = { name = 'permission', help = 'BehÃ¶righetsnivÃ¥' },
            },
        },
        openserver = { help = 'Ã–ppna servern fÃ¶r alla (Admin Only)' },
        closeserver = {
            help = 'StÃ¤ng servern fÃ¶r personer utan behÃ¶righeter (Admin Only)',
            params = {
                reason = { name = 'reason', help = 'Anledning till stÃ¤ngning (frivillig)' },
            },
        },
        car = {
            help = 'Spawna Fordon (Admin Only)',
            params = {
                model = { name = 'model', help = 'Fordonets modellnamn' },
            },
        },
        dv = { help = 'Radera fordon (Admin Only)' },
        givemoney = {
            help = 'Ge en spelare pengar (Admin Only)',
            params = {
                id = { name = 'id', help = 'Spelar-ID' },
                moneytype = { name = 'moneytype', help = 'Typ av pengar (cash, bank, crypto)' },
                amount = { name = 'amount', help = 'Belopp' },
            },
        },
        setmoney = {
            help = 'SÃ¤tt spelar pengar (Admin Only)',
            params = {
                id = { name = 'id', help = 'Spelar-ID' },
                moneytype = { name = 'moneytype', help = 'Typ av pengar (cash, bank, crypto)' },
                amount = { name = 'amount', help = 'Belopp' },
            },
        },
        job = { help = 'Kolla ditt jobb' },
        setjob = {
            help = 'SÃ¤tt Spelar-Jobb (Admin Only)',
            params = {
                id = { name = 'id', help = 'Spelar-ID' },
                job = { name = 'job', help = 'Jobbnamn' },
                grade = { name = 'grade', help = 'Jobb-Grad' },
            },
        },
        gang = { help = 'Kolla ditt gÃ¤ng' },
        setgang = {
            help = 'SÃ¤tt spelar-gÃ¤ng (Admin Only)',
            params = {
                id = { name = 'id', help = 'Spelar-ID' },
                gang = { name = 'gang', help = 'GÃ¤ngnamn' },
                grade = { name = 'grade', help = 'GÃ¤ng-grad' },
            },
        },
        ooc = { help = 'OOC-chattmeddelande' },
        me = {
            help = 'Visa lokalt meddelande',
            params = {
                message = { name = 'message', help = 'Meddelande' }
            },
        },
    },
}

if GetConvar('qb_locale', 'en') == 'sv' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
