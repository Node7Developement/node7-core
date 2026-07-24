local Translations = {
    error = {
        not_online = 'HrÃ¡Ä nenÃ­ online',
        wrong_format = 'NesprÃ¡vnÃ½ formÃ¡t',
        missing_args = 'NÃ© vÅ¡echny argumenty byly vyplnÄ›ny (x, y, z)',
        missing_args2 = 'VÅ¡echny argumenty musÃ­ bÃ½t vyplnÄ›nÃ½!',
        no_access = 'NemÃ¡te pÅ™Ã­stup k tomuto pÅ™Ã­kazu',
        company_too_poor = 'VÃ¡Å¡ zamÄ›stnavatel nemÃ¡ dostatek penÄ›z, aby vÃ¡s vyplatil',
        item_not_exist = 'PÅ™edmÄ›t neexistuje',
        too_heavy = 'InventÃ¡Å™ je plnÃ½',
        duplicate_license = 'StejnÃ¡ Rockstar licence je jiÅ¾ na serveru',
        no_valid_license  = 'Nebyla nalezena Å¾Ã¡dnÃ¡ platnÃ¡ Rockstar licence',
        not_whitelisted = 'Nejste na whitelistu'
    },
    success = {
        server_opened = 'Server byl otevÅ™en',
        server_closed = 'Server byl uzavÅ™en',
        teleported_waypoint = 'TeleportovÃ¡no na Waypoint.',
        job_set = 'Job set successfully',
        gang_set = 'Gang set successfully',
    },
    info = {
        received_paycheck = 'ObdrÅ¾eli jste vÃ½platu v hodnotÄ› $%{value}',
        job_info = 'PrÃ¡ce: %{value} | Pozice: %{value2} | Ve sluÅ¾bÄ›: %{value3}',
        gang_info = 'Gang: %{value} | Pozice: %{value2}',
        on_duty = 'VeÅ¡li jste do sluÅ¾by',
        off_duty = 'OdeÅ¡li jste ze sluÅ¾by!',
        checking_ban = 'Ahoj %s. Kontrolujeme zda nejste zabanovÃ¡ni.',
        join_server = 'VÃ­tejte %s na {Server Name}.',
        checking_whitelisted = 'Ahoj %s. Kontrolujeme zda mÃ¡te pÅ™Ã­stup.'
    },
    command = {
        tp = {
            help = 'Teleport k hrÃ¡Äi nebo na souÅ™adnice (Pouze Admin)',
            params = {
                x = { name = 'id/x', help = 'ID hrÃ¡Äe nebo X pozice'},
                y = { name = 'y', help = 'Y pozice'},
                z = { name = 'z', help = 'Z pozice'},
            },
        },
        tpm = { help = 'TP Na Marker (pouze Admin)' },
        togglepvp = { help = 'PÅ™epnutÃ­ PVP na serveru (Pouze Admin)' },
        addpermission = {
            help = 'UdÄ›lenÃ­ hrÃ¡Äi oprÃ¡vnÄ›nÃ­ (God Pouze)',
            params = {
                id = { name = 'id', help = 'ID hrÃ¡Äe' },
                permission = { name = 'permission', help = 'ÃšroveÅˆ oprÃ¡vnÄ›nÃ­' },
            },
        },
        removepermission = {
            help = 'Odeber hrÃ¡Äi oprÃ¡vnÄ›nÃ­ (God Pouze)',
            params = {
                id = { name = 'id', help = 'ID hrÃ¡Äe' },
                permission = { name = 'permission', help = 'ÃšroveÅˆ oprÃ¡vnÄ›nÃ­' },
            },
        },
        openserver = { help = 'OtevÅ™i server pro vÅ¡echny (Pouze Admin)' },
        closeserver = {
            help = 'UzavÅ™i server pro vÅ¡echny bez prÃ¡v (Pouze Admin)',
            params = {
                reason = { name = 'reason', help = 'DÅ¯dov pro uzavÅ™enÃ­ (optimÃ¡lnÃ­)' },
            },
        },
        car = {
            help = 'Spawn Vozidla (Pouze Admin)',
            params = {
                model = { name = 'model', help = 'JmÃ©no modelu vozidla' },
            },
        },
        dv = { help = 'OdstraÅˆ vozidlo (Pouze Admin)' },
        givemoney = {
            help = 'Dej hrÃ¡Äi penÃ­ze (Pouze Admin)',
            params = {
                id = { name = 'id', help = 'ID hrÃ¡Äe' },
                moneytype = { name = 'moneytype', help = 'Typ (hotovost, banka, krypto)' },
                amount = { name = 'amount', help = 'PoÄet penÄ›z' },
            },
        },
        setmoney = {
            help = 'Nastav hrÃ¡Äi penÃ­ze (Pouze Admin)',
            params = {
                id = { name = 'id', help = 'ID hrÃ¡Äe' },
                moneytype = { name = 'moneytype', help = 'Typ (hotovost, banka, krypto)' },
                amount = { name = 'amount', help = 'PoÄet penÄ›z' },
            },
        },
        job = { help = 'Zkontroluj si prÃ¡ci' },
        setjob = {
            help = 'Nastav hrÃ¡Äi prÃ¡ci (Pouze Admin)',
            params = {
                id = { name = 'id', help = 'ID hrÃ¡Äe' },
                job = { name = 'job', help = 'JmÃ©no prÃ¡ce' },
                grade = { name = 'grade', help = 'JmÃ©no hodnosti' },
            },
        },
        gang = { help = 'Zkontroluj si gang' },
        setgang = {
            help = 'Nastav hrÃ¡Äi gang (Pouze Admin)',
            params = {
                id = { name = 'id', help = 'ID hrÃ¡Äe' },
                gang = { name = 'gang', help = 'JmÃ©no gangu' },
                grade = { name = 'grade', help = 'Pozice v gangu' },
            },
        },
        ooc = { help = 'OOC Chat' },
        me = {
            help = 'UkaÅ¾ zprÃ¡vu',
            params = {
                message = { name = 'message', help = 'ZprÃ¡va k odeslÃ¡nÃ­' }
            },
        },
    },
}

if GetConvar('qb_locale', 'en') == 'cs' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
