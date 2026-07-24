local Translations = {
    error = {
        not_online = 'IgraÄ nije na mreÅ¾i',
        wrong_format = 'NetaÄan format',
        missing_args = 'Nije unesen svaki argument (X, Y, Z)',
        missing_args2 = 'Svi argumenti moraju se popuniti!',
        no_access = 'Nemate pristupa ovoj komandi',
        company_too_poor = 'VaÅ¡ poslodavac je siromaÅ¡an',
        item_not_exist = 'Predmet ne postoji',
        too_heavy = 'Inventar je prepun',
        location_not_exist = 'Lokacija ne postoji',
        job_not_exist               = 'Job does not exist',
        gang_not_exist              = 'Gang does not exist',
        duplicate_license = 'Duplicirana Rockstar licenca pronaÄ‘ena',
        no_valid_license  = 'Nije pronaÄ‘ena nijedna vaÅ¾eÄ‡a Rockstar licenca',
        not_whitelisted = 'Niste na listi za Äekanje na ovom serveru',
        server_already_open = 'Server je veÄ‡ otvoren',
        server_already_closed = 'Server je veÄ‡ zatvoren',
        no_permission = 'Nemate dozvole za ovo..',
        no_waypoint = 'Nema postavljen marker.',
        tp_error = 'GreÅ¡ka tokom teleportiranja.',
        connecting_database_error = 'DoÅ¡lo je do pogreÅ¡ke u bazi podataka tokom povezivanja na serverom. (Je li SQL server ukljuÄen?)',
        connecting_database_timeout = 'Veza sa bazom podataka istekla. (Je li SQL server ukljuÄen?)',
    },
    success = {
        server_opened = 'Server je otvoren',
        server_closed = 'Server je zatvoren',
        teleported_waypoint = 'Teleportirani ste na marker.',
        job_set = 'Job set successfully',
        gang_set = 'Gang set successfully',
    },
    info = {
        received_paycheck = 'Primili ste platu od $%{value}',
        job_info = 'Posao: %{value} | Nivo: %{value2} | DuÅ¾nost: %{value3}',
        gang_info = 'Banda: %{value} | Nivo: %{value2}',
        on_duty = 'Sada ste na duÅ¾nosti!',
        off_duty = 'Sada ste izvan duÅ¾nosti!',
        checking_ban = 'Zdravo %s. Provjeravamo da li ste banovani.',
        join_server = 'DobrodoÅ¡li %s, na {Server Name}.',
        checking_whitelisted = 'Zdravo %s. Provjeravamo listu za Äekanje.',
        exploit_banned = 'Banovani ste zbog varanja. Provjerite naÅ¡ discord za viÅ¡e informacija: %{discord}',
        exploit_dropped = 'Banovani ste zbog eksplotacije',
    },
    command = {
        tp = {
            help = 'TP igraÄu ili koordinatama (Samo Admin)',
            params = {
                x = { name = 'id/x', help = 'ID igraÄa ili X kordinata'},
                y = { name = 'y', help = 'Y kordinata'},
                z = { name = 'z', help = 'Z kordinata'},
            },
        },
        tpm = { help = 'TP na Marker (Samo Admin)' },
        togglepvp = { help = 'UkljuÄivanje PVP na serveru (Samo Admin)' },
        addpermission = {
            help = 'Dajte dozvole igraÄu (Samo God)',
            params = {
                id = { name = 'id', help = 'ID igraÄa' },
                permission = { name = 'permission', help = 'Nivo dozvole' },
            },
        },
        removepermission = {
            help = 'Uklonite dozvole igraÄu (Samo God)',
            params = {
                id = { name = 'id', help = 'ID igraÄa' },
                permission = { name = 'permission', help = 'Nivo dozvole' },
            },
        },
        openserver = { help = 'Otvorite server za sve (Samo Admin)' },
        closeserver = {
            help = 'Zatvorite server za ljude bez dozvola (Samo Admin)',
            params = {
                reason = { name = 'reason', help = 'Razlog zatvaranja (neobavezno)' },
            },
        },
        car = {
            help = 'Stvorite vozilo (Samo Admin)',
            params = {
                model = { name = 'model', help = 'Naziv modela vozila' },
            },
        },
        dv = { help = 'IzbriÅ¡ite vozilo (Samo Admin)' },
        givemoney = {
            help = 'Dajte novac igraÄu (Samo Admin)',
            params = {
                id = { name = 'id', help = 'ID igraÄa' },
                moneytype = { name = 'moneytype', help = 'Vrsta novca (cash, bank, crypto)' },
                amount = { name = 'amount', help = 'KoliÄina novca' },
            },
        },
        setmoney = {
            help = 'Podesite novac igraÄu (Samo Admin)',
            params = {
                id = { name = 'id', help = 'ID igraÄa' },
                moneytype = { name = 'moneytype', help = 'Vrsta novca (cash, bank, crypto)' },
                amount = { name = 'amount', help = 'KoliÄina novca' },
            },
        },
        job = { help = 'Provjerite svoj posao' },
        setjob = {
            help = 'Podesite posao igraÄu (Samo Admin)',
            params = {
                id = { name = 'id', help = 'ID igraÄa' },
                job = { name = 'job', help = 'Ime posla' },
                grade = { name = 'grade', help = 'Nivo posla' },
            },
        },
        gang = { help = 'Provjerite svoju bandu' },
        setgang = {
            help = 'Postavite bandu igraÄu (Samo Admin)',
            params = {
                id = { name = 'id', help = 'ID igraÄa' },
                gang = { name = 'gang', help = 'Ime bande' },
                grade = { name = 'grade', help = 'Nivo bande' },
            },
        },
        ooc = { help = 'OOC Chat Poruka' },
        me = {
            help = 'PrikaÅ¾i lokalnu poruku',
            params = {
                message = { name = 'message', help = 'Poruka za slanje' }
            },
        },
    },
}

if GetConvar('qb_locale', 'en') == 'bs' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end