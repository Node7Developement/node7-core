local Translations = {
    error = {
        not_online = 'Spiller ikke online',
        wrong_format = 'Forkert format',
        missing_args = 'Du mangler nogle argumenter (x, y, z)',
        missing_args2 = 'Alle argumenter skal udfyldes!',
        no_access = 'Ingen adgang til denne kommando',
        company_too_poor = 'Din arbejdsgiver er for fattig',
        item_not_exist = 'Item findes ikke',
        too_heavy = 'Tasken er fuld',
        location_not_exist = 'Placering findes ikke',
        job_not_exist               = 'Job does not exist',
        gang_not_exist              = 'Gang does not exist',
        duplicate_license = 'Dublet Rockstar-licens fundet',
        no_valid_license  = 'Ingen gyldig Rockstar-licens fundet',
        not_whitelisted = 'Du er ikke allowlisted pÃ¥ denne server',
        server_already_open = 'Serveren er allerede Ã¥ben',
        server_already_closed = 'Serveren er allerede lukket',
        no_permission = 'Du har ikke tilladelser til dette..',
        no_waypoint = 'Intet waypoint indstillet.',
        tp_error = 'Fejl under teleportering.',
        connecting_database_error = 'Der opstod en databasefejl under forbindelse til serveren. (Er SQL-serveren tÃ¦ndt?)',
        connecting_database_timeout = 'Forbindelsen til databasen fik timeout. (Er SQL-serveren tÃ¦ndt?)',
    },
    success = {
        server_opened = 'Serveren er blevet Ã¥bnet',
        server_closed = 'Serveren er blevet lukket',
        teleported_waypoint = 'Teleporteret til waypoint.',
        job_set = 'Job set successfully',
        gang_set = 'Gang set successfully',
    },
    info = {
        received_paycheck = 'Du har modtaget din lÃ¸nseddel pÃ¥ %{value} kr.',
        job_info = 'Job: %{value} | Karakter: %{value2} | PÃ¥ Arbejde: â€‹â€‹%{value3}',
        gang_info = 'Bande: %{value} | Karakter: %{value2}',
        on_duty = 'Du er nu pÃ¥ vagt!',
        off_duty = 'Du har nu fri!',
        checking_ban = 'Hej %s. Vi tjekker om du er bannet.',
        join_server = 'Velkommen %s til {Server Name}.',
        checking_whitelisted = 'Hej %s. Vi tjekker din godtgÃ¸relse.',
        exploit_banned = 'Du er blevet udelukket for exploit. Tjek vores Discord for mere information: %{discord}',
        exploit_dropped = 'Du er blevet sparket for exploit',
    },
    command = {
        tp = {
            help = 'TP til spiller eller koordinater (kun admin)',
            params = {
                x = { name = 'id/x', help = 'ID for spiller eller X-position'},
                y = { name = 'y', help = 'Y position'},
                z = { name = 'z', help = 'Z position'},
            },
        },
        tpm = { help = 'TP til markÃ¸r (kun admin)' },
        togglepvp = { help = 'SlÃ¥ PVP til/fra pÃ¥ serveren (kun admin)' },
        addpermission = {
            help = 'Giv spillertilladelser (kun gud)',
            params = {
                id = { name = 'id', help = 'ID pÃ¥ spiller' },
                permission = { name = 'tilladelse', help = 'Tilladelsesniveau' },
            },
        },
        removepermission = {
            help = 'Fjern spillertilladelser (kun gud)',
            params = {
                id = { name = 'id', help = 'ID pÃ¥ spiller' },
                permission = { name = 'tilladelse', help = 'Tilladelsesniveau' },
            },
        },
        openserver = { help = 'Ã…bn serveren for alle (kun admin)' },
        closeserver = {
            help = 'Luk serveren for personer uden tilladelser (kun administrator)',
            params = {
                reason = { name = 'Ã¥rsag', help = 'Ã…rsag til lukning (valgfrit)' },
            },
        },
        car = {
            help = 'Spawn-kÃ¸retÃ¸j (kun admin)',
            params = {
                model = { name = 'model', help = 'Model navn pÃ¥ kÃ¸retÃ¸jet' },
            },
        },
        dv = { help = 'Slet kÃ¸retÃ¸j (kun admin)' },
        givemoney = {
            help = 'Giv en spiller penge (kun admin)',
            params = {
                id = { name = 'id', help = 'Spiller ID' },
                moneytype = { name = 'pengetype', help = 'Type penge (cash, bank, crypto)' },
                amount = { name = 'belÃ¸b', help = 'MÃ¦ngde penge' },
            },
        },
        setmoney = {
            help = 'Indstil spillerens pengebelÃ¸b (kun administrator)',
            params = {
                id = { name = 'id', help = 'Spiller ID' },
                moneytype = { name = 'pengetype', help = 'Type penge (cash, bank, crypto)' },
                amount = { name = 'belÃ¸b', help = 'MÃ¦ngde penge' },
            },
        },
        job = { help = 'Tjek Dit Job' },
        setjob = {
            help = 'SÃ¦t en spillers job (kun admin)',
            params = {
                id = { name = 'id', help = 'Spiller ID' },
                job = { name = 'job', help = 'Job navn' },
                grade = { name = 'grade', help = 'Job grade' },
            },
        },
        gang = { help = 'Tjek din bande' },
        setgang = {
            help = 'SÃ¦t en spiller til bande (kun admin)',
            params = {
                id = { name = 'id', help = 'Spiller ID' },
                gang = { name = 'bande', help = 'Bande navn' },
                grade = { name = 'grade', help = 'Bande grade' },
            },
        },
        ooc = { help = 'OOC Chat Besked' },
        me = {
            help = 'Vis lokal besked',
            params = {
                message = { name = 'besked', help = 'Besked at sende' }
            },
        },
    },
}

if GetConvar('qb_locale', 'en') == 'da' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
