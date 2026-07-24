local Translations = {
    error = {
        not_online                  = 'Gracz nie jest online',
        wrong_format                = 'Niepoprawny format',
        missing_args                = 'Nie wszystkie argumenty zostaÅ‚y podane (x, y, z)',
        missing_args2               = 'Wszystkie argumenty muszÄ… byÄ‡ wypeÅ‚nione!',
        no_access                   = 'Brak dostÄ™pu do tej komendy',
        company_too_poor            = 'TwÃ³j pracodawca jest spÅ‚ukany',
        item_not_exist              = 'Przedmiot nie istnieje',
        too_heavy                   = 'Ekwipunek jest zbyt peÅ‚ny',
        location_not_exist          = 'Lokalizacja nie istnieje',
        duplicate_license           = '[NODE7CORE] - Znaleziono duplikat licencji Rockstar',
        no_valid_license            = '[NODE7CORE] - Nie znaleziono waÅ¼nej licencji Rockstar',
        not_whitelisted             = '[NODE7CORE] - Nie jesteÅ› na whitelist tego serwera',
        server_already_open         = 'Serwer jest juÅ¼ otwarty',
        server_already_closed       = 'Serwer jest juÅ¼ zamkniÄ™ty',
        no_permission               = 'Nie masz do tego uprawnieÅ„',
        no_waypoint                 = 'Nie ustawiono waypointu',
        tp_error                    = 'BÅ‚Ä…d podczas teleportacji',
        ban_table_not_found         = '[NODE7CORE] - Nie znaleziono tabeli banÃ³w w bazie danych. Upewnij siÄ™, Å¼e poprawnie zaimportowaÅ‚eÅ› plik SQL.',
        connecting_database_error   = '[NODE7CORE] - WystÄ…piÅ‚ bÅ‚Ä…d podczas Å‚Ä…czenia z bazÄ… danych. Upewnij siÄ™, Å¼e serwer SQL dziaÅ‚a i Å¼e dane w server.cfg sÄ… poprawne.',
        connecting_database_timeout = '[NODE7CORE] - PoÅ‚Ä…czenie z bazÄ… danych wygasÅ‚o. Upewnij siÄ™, Å¼e serwer SQL dziaÅ‚a i Å¼e dane w server.cfg sÄ… poprawne.',
    },
    success = {
        server_opened = 'Serwer zostaÅ‚ otwarty',
        server_closed = 'Serwer zostaÅ‚ zamkniÄ™ty',
        teleported_waypoint = 'Zteleportowano do waypointu',
        job_set = 'Job set successfully',
        gang_set = 'Gang set successfully',
    },
    info = {
        received_paycheck = 'OtrzymaÅ‚eÅ› wypÅ‚atÄ™ w wysokoÅ›ci $%{value}',
        job_info = 'Praca: %{value} | StopieÅ„: %{value2} | Na sÅ‚uÅ¼bie: %{value3}',
        gang_info = 'Gangi: %{value} | StopieÅ„: %{value2}',
        on_duty = 'JesteÅ› teraz na sÅ‚uÅ¼bie!',
        off_duty = 'JesteÅ› teraz poza sÅ‚uÅ¼bÄ…!',
        checking_ban = 'Witaj %s. Sprawdzamy, czy jesteÅ› zbanowany.',
        join_server = 'Witaj %s na {Server Name}.',
        checking_whitelisted = 'Witaj %s. Sprawdzamy twÃ³j dostÄ™p.',
        exploit_banned = 'ZostaÅ‚eÅ› zbanowany za oszustwo. SprawdÅº naszego Discorda po wiÄ™cej informacji: %{discord}',
        exploit_dropped = 'ZostaÅ‚eÅ› wyrzucony za wykorzystywanie exploitÃ³w',
    },
    command = {
        tp = {
            help = 'Teleport do gracza lub wspÃ³Å‚rzÄ™dnych (tylko Admin)',
            params = {
                x = { name = 'id/x', help = 'ID gracza lub pozycja X' },
                y = { name = 'y', help = 'Pozycja Y' },
                z = { name = 'z', help = 'Pozycja Z' },
            },
        },
        tpm = { help = 'Teleport do markera (tylko Admin)' },
        noclip = { help = 'Przelot przez obiekty (tylko Admin)' },
        togglepvp = { help = 'WÅ‚Ä…cz/WyÅ‚Ä…cz PVP na serwerze (tylko Admin)' },
        addpermission = {
            help = 'Nadaj graczowi uprawnienia (tylko BÃ³g)',
            params = {
                id = { name = 'id', help = 'ID gracza' },
                permission = { name = 'permission', help = 'Poziom uprawnieÅ„' },
            },
        },
        removepermission = {
            help = 'Odbierz graczowi uprawnienia (tylko BÃ³g)',
            params = {
                id = { name = 'id', help = 'ID gracza' },
                permission = { name = 'permission', help = 'Poziom uprawnieÅ„' },
            },
        },
        openserver = { help = 'OtwÃ³rz serwer dla wszystkich (tylko Admin)' },
        closeserver = {
            help = 'Zamknij serwer dla osÃ³b bez uprawnieÅ„ (tylko Admin)',
            params = {
                reason = { name = 'reason', help = 'PowÃ³d zamkniÄ™cia (opcjonalnie)' },
            },
        },
        car = {
            help = 'Spawn pojazdu (tylko Admin)',
            params = {
                model = { name = 'model', help = 'Nazwa modelu pojazdu' },
            },
        },
        dv = { help = 'UsuÅ„ pojazd (tylko Admin)' },
        dvall = { help = 'UsuÅ„ wszystkie pojazdy (tylko Admin)' },
        dvp = { help = 'UsuÅ„ wszystkie postacie (tylko Admin)' },
        dvo = { help = 'UsuÅ„ wszystkie obiekty (tylko Admin)' },
        givemoney = {
            help = 'Daj graczowi pieniÄ…dze (tylko Admin)',
            params = {
                id = { name = 'id', help = 'ID gracza' },
                moneytype = { name = 'moneytype', help = 'Rodzaj pieniÄ™dzy (cash, bank, bloodmoney)' },
                amount = { name = 'amount', help = 'Kwota pieniÄ™dzy' },
            },
        },
        setmoney = {
            help = 'Ustaw kwotÄ™ pieniÄ™dzy gracza (tylko Admin)',
            params = {
                id = { name = 'id', help = 'ID gracza' },
                moneytype = { name = 'moneytype', help = 'Rodzaj pieniÄ™dzy (cash, bank, bloodmoney)' },
                amount = { name = 'amount', help = 'Kwota pieniÄ™dzy' },
            },
        },
        job = { help = 'SprawdÅº swojÄ… pracÄ™' },
        setjob = {
            help = 'Ustaw pracÄ™ gracza (tylko Admin)',
            params = {
                id = { name = 'id', help = 'ID gracza' },
                job = { name = 'job', help = 'Nazwa pracy' },
                grade = { name = 'grade', help = 'StopieÅ„ pracy' },
            },
        },
        gang = { help = 'SprawdÅº swÃ³j gang' },
        setgang = {
            help = 'Ustaw gang gracza (tylko Admin)',
            params = {
                id = { name = 'id', help = 'ID gracza' },
                gang = { name = 'gang', help = 'Nazwa gangu' },
                grade = { name = 'grade', help = 'StopieÅ„ w gangu' },
            },
        },
        ooc = { help = 'WiadomoÅ›Ä‡ czatu OOC' },
        me = {
            help = 'PokaÅ¼ lokalnÄ… wiadomoÅ›Ä‡',
            params = {
                message = { name = 'message', help = 'WiadomoÅ›Ä‡ do wysÅ‚ania' }
            },
        },
    },
}

if GetConvar('qb_locale', 'en') == 'pl' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
