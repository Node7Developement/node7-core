local Translations = {
    error = {
        not_online 					= 'A jÃ¡tÃ©kos nem elÃ©rhetÅ‘',
        wrong_format 				= 'Helytelen formÃ¡tum',
        missing_args 				= 'Nem minden Ã©rtÃ©k lett megadva (x, y, z)',
        missing_args2 				= 'Az Ã¶sszes Ã©rtÃ©ket meg kell adnod!',
        no_access 					= 'Nem hasznÃ¡lhatod ezt a parancsot',
        company_too_poor 			= 'A munkÃ¡ltatÃ³d nem tudott kifizetni',
        item_not_exist 				= 'Ez a tÃ¡rgy nem lÃ©tezik',
        too_heavy 					= 'A leltÃ¡rad megtelt',
        location_not_exist          = 'Location does not exist',
        duplicate_license           = '[SZERVER] - DuplikÃ¡lt Rockstar License-t talÃ¡ltunk!',
        no_valid_license            = '[SZERVER] - Nem valÃ³s Rockstar License-t talÃ¡ltunk!',
        not_whitelisted             = '[SZERVER] - Nincs engedÃ©lyed, hogy csatlakozz a szerverhez!',
        server_already_open         = 'Szerver megnyitva!',
        server_already_closed       = 'Szerver bezÃ¡rva!',
        no_permission               = 'Nincs engedÃ©lyed, hogy ezt tehesd..',
        no_waypoint                 = 'Nem lett uticÃ©l megadva.',
        tp_error                    = 'Hiba teleportÃ¡lÃ¡s kÃ¶zben.',
        ban_table_not_found         = '[SZERVER] - Ban tÃ¡bla nem talÃ¡lhatÃ³ az adatbÃ¡zisban. GyÃ¶zÃ¶dj meg rÃ³la, hogy helyesen lett importÃ¡lva.',
        connecting_database_error   = '[SZERVER] - Hiba tÃ¶rtÃ©nt az adatbÃ¡zis csatlakozÃ¡sa sorÃ¡n. EllenÃ¶rizd, hogy a server.cfg fÃ¡jlban minden SQL adat helyesen szerepel.',
        connecting_database_timeout = '[SZERVER] - AdatbÃ¡zis csatlakozÃ¡s idÃ¶tÃºllÃ©pÃ©s. EllenÃ¶rizd, hogy a server.cfg fÃ¡jlban minden SQL adat helyesen szerepel.',
    },
    success = {
        server_opened = 'Szerver megnyitva',
        server_closed = 'Szerver bezÃ¡rva',
        teleported_waypoint = 'TeleportÃ¡lÃ¡s az uticÃ©lhoz.',
        job_set = 'Job set successfully',
        gang_set = 'Gang set successfully',
    },
    info = {
        received_paycheck = 'FizetÃ©st kaptÃ¡l - $%{value}',
        job_info = 'Munka: %{value} | BeosztÃ¡s: %{value2} | Ãœgyeletben: %{value3}',
        gang_info = 'Banda: %{value} | Rang: %{value2}',
        on_duty = 'Ãœgyeletbe lÃ©ptÃ©l!',
        off_duty = 'Befejezted az Ã¼gyeletet!',
        checking_ban = 'ÃœdvÃ¶zÃ¶llek %s. EllenÃ¶rizzÃ¼k a tÃ­ltÃ³listÃ¡t.',
        join_server = 'ÃœdvÃ¶zÃ¶llek %s a {Server Name} szerveren!.',
        checking_whitelisted = 'Szia %s. EllenÃ¶rizzÃ¼k az engedÃ©lyeidet.',
        exploit_banned = 'CsalÃ¡sÃ©rt kitÃ­ltÃ¡sra kerÃ¼ltÃ©l. TovÃ¡bbi informÃ¡ciÃ³kÃ©rt lÃ¡togass el a Discord csatornÃ¡nkra - %{discord}',
        exploit_dropped = 'KirÃºgtak a szerverrÃ¶l mert szabÃ¡lyt sÃ©rtettÃ©l!',
    },
    command = {
        tp = {
            help = 'TP jÃ¡tÃ©koshoz vagy koordinÃ¡tÃ¡ra (Admin Only)',
            params = {
                x = { name = 'id/x', help = 'JÃ¡tÃ©kos id vagy koordinÃ¡ta X' },
                y = { name = 'y', help = 'koordinÃ¡ta Y' },
                z = { name = 'z', help = 'koordinÃ¡ta Z' },
            },
        },
        tpm = { help = 'TP uticÃ©lhoz (Admin Only)' },
        noclip = { help = 'No Clip (Admin Only)' },
        togglepvp = { help = 'PVP (Admin Only)' },
        addpermission = {
            help = 'EngedÃ©lyek adÃ¡sa (God Only)',
            params = {
                id = { name = 'id', help = 'JÃ¡tÃ©kos ID' },
                permission = { name = 'permission', help = 'EngedÃ©ly szint' },
            },
        },
        removepermission = {
            help = 'EngedÃ©ly elvÃ©tele jÃ¡tÃ©kostÃ³l (God Only)',
            params = {
                id = { name = 'id', help = 'JÃ¡tÃ©kos ID' },
                permission = { name = 'permission', help = 'EngedÃ©ly szint' },
            },
        },
        openserver = { help = 'Szerver megnyitÃ¡sa mindenki szÃ¡mÃ¡ra (Admin Only)' },
        closeserver = {
            help = 'Szerver bezÃ¡rÃ¡sa az engedÃ©ly nÃ©lkÃ¼li jÃ¡tÃ©kosok szÃ¡mÃ¡ra (Admin Only)',
            params = {
                reason = { name = 'reason', help = 'BezÃ¡rÃ¡s oka (opcionÃ¡lis)' },
            },
        },
        car = {
            help = 'JÃ¡rmÃ¼ Spawn (Admin Only)',
            params = {
                model = { name = 'model', help = 'JÃ¡rmÃ¼ model' },
            },
        },
        dv = { help = 'JÃ¡rmÃ¼ tÃ¶rlÃ©s (Admin Only)' },
        dvall = { help = 'Ã–sszes jÃ¡rmÃ¼ tÃ¶rlÃ©s (Admin Only)' },
        dvp = { help = 'Ã–sszes Ped tÃ¶rlÃ©s (Admin Only)' },
        dvo = { help = 'Ã–sszes Objekt tÃ¶rlÃ©s (Admin Only)' },
        givemoney = {
            help = 'PÃ©nz adÃ¡s jÃ¡tÃ©kosnak (Admin Only)',
            params = {
                id = { name = 'id', help = 'JÃ¡tÃ©kos ID' },
                moneytype = { name = 'moneytype', help = 'PÃ©nztÃ­pus (cash, bank, gold, bloodmoney, tbcoin)' },
                amount = { name = 'amount', help = 'Amount of money' },
            },
        },
        setmoney = {
            help = 'PÃ©nz mennyisÃ©gÃ©nek megadÃ¡sa jÃ¡tÃ©kosnak (Admin Only)',
            params = {
                id = { name = 'id', help = 'JÃ¡tÃ©kos ID' },
                moneytype = { name = 'moneytype', help = 'PÃ©nztÃ­pus (cash, bank, gold, bloodmoney, tbcoin)' },
                amount = { name = 'amount', help = 'Ã–sszeg' },
            },
        },
        job = { help = 'MunkÃ¡d ellenÃ¶rzÃ©se' },
        setjob = {
            help = 'Munka megadÃ¡s jÃ¡tÃ©kosnak (Admin Only)',
            params = {
                id = { name = 'id', help = 'JÃ¡tÃ©kos ID' },
                job = { name = 'job', help = 'Munka neve' },
                grade = { name = 'grade', help = 'BeosztÃ¡s' },
            },
        },
        gang = { help = 'BandÃ¡d ellenÃ¶rzÃ©se' },
        setgang = {
            help = 'Banda megadÃ¡sa jÃ¡tÃ©kosnak (Admin Only)',
            params = {
                id = { name = 'id', help = 'JÃ¡tÃ©kos ID' },
                gang = { name = 'gang', help = 'Banda neve' },
                grade = { name = 'grade', help = 'Rang' },
            },
        },
        ooc = { help = 'OOC Chat Ã¼zenet' },
        me = {
            help = 'LokÃ¡lis cselekvÃ©s buborÃ©k',
            params = {
                message = { name = 'message', help = 'Ãœzenet elkÃ¼ldve' }
            },
        },
    },
}

if GetConvar('rsg_locale', 'en') == 'hu' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
