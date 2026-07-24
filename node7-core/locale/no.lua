local Translations = {
    error = {
        not_online = 'Spiller ikke online',
        wrong_format = 'Ugyldig format',
        missing_args = 'Ikke alle argumenter er lagt inn (x, y, z)',
        missing_args2 = 'Alle argumenter mÃ¥ fylles ut!',
        no_access = 'Du mangler tilgang til denne kommandoen',
        company_too_poor = 'Arbeidsgiveren din er blakk',
        item_not_exist = 'Gjenstand finnes ikke',
        too_heavy = 'Lommene er fulle',
        location_not_exist = 'Plassering finnes ikke',
        job_not_exist               = 'Job does not exist',
        gang_not_exist              = 'Gang does not exist',
        duplicate_license = 'Duplikat Rockstar-lisens funnet',
        no_valid_license  = 'Ingen gyldig Rockstar-lisens funnet',
        not_whitelisted = 'Du har ikke tilgang til serveren',
        server_already_open = 'Serveren er allerede Ã¥pen',
        server_already_closed = 'Serveren er allerede stengt',
        no_permission = 'Du har ikke tillatelser til dette..',
        no_waypoint = 'Ingen markÃ¸r satt.',
        tp_error = 'Feil under teleportering.',
    },
    success = {
        server_opened = 'Serveren er Ã¥pnet',
        server_closed = 'Serveren er stengt',
        teleported_waypoint = 'Teleporter til angitt markÃ¸r.',
        job_set = 'Job set successfully',
        gang_set = 'Gang set successfully',
    },
    info = {
        received_paycheck = 'Du har mottatt lÃ¸nnsslippen din pÃ¥ kr %{value}',
        job_info = 'Jobb: %{value} | Grad: %{value2} | Vakt: %{value3}',
        gang_info = 'Gjeng: %{value} | Grad: %{value2}',
        on_duty = 'Du er nÃ¥ pÃ¥ vakt!',
        off_duty = 'Du er nÃ¥ av vakt!',
        checking_ban = 'Hei %s. Vi sjekker om du er utestengt.',
        join_server = 'Velkommen %s til {Server Name}.',
        checking_whitelisted = 'Hei %s. Vi sjekker dine tilganger.',
        exploit_banned = 'Du har blitt utestengt for juks. Sjekk vÃ¥r Discord for mer informasjon: %{discord}',
        exploit_dropped = 'Du har blitt sparket for utnyttelse',
    },
    command = {
        tp = {
            help = 'TP til spiller eller koordinater (kun admin)',
            params = {
                x = { name = 'id/x', help = 'ID for spiller eller X-posisjon'},
                y = { name = 'y', help = 'Y posisjon'},
                z = { name = 'z', help = 'Z posisjon'},
            },
        },
        tpm = { help = 'TP Til MarkÃ¸r (kun admin)' },
        togglepvp = { help = 'Skru pÃ¥/av PVP pÃ¥ serveren (kun admin)' },
        addpermission = {
            help = 'Gi spillertilganger (Kun gud)',
            params = {
                id = { name = 'id', help = 'ID pÃ¥ spiller' },
                permission = { name = 'permission', help = 'TilgangsnivÃ¥ '},
            },
        },
        removepermission = {
            help = 'Fjern spillertilganger (kun gud)',
            params = {
                id = { name = 'id', help = 'ID pÃ¥ spiller' },
                permission = { name = 'permission', help = 'TilgangsnivÃ¥' },
            },
        },
        openserver = { help = 'Ã…pne opp serveren for alle (kun admin)' },
        closeserver = {
            help = 'Lukk serveren for personer uten tillatelser (kun admin)',
            params = {
                reason = { name = 'reason', help = 'Ã…rsak til stenging (valgfritt)' },
            },
        },
        car = {
            help = 'Spawn kjÃ¸retÃ¸y (kun admin)',
            params = {
                model = { name = 'model', help = 'Modellnavn pÃ¥ kjÃ¸retÃ¸yet' },
            },
        },
        dv = { help = 'Slett kjÃ¸retÃ¸y (kun admin)' },
        givemoney = {
            help = 'Gi en spiller penger (kun admin)',
            params = {
                id = { name = 'id', help = 'ID pÃ¥ spiller' },
                moneytype = { name = 'moneytype', help = 'Type: (cash, bank, crypto)' },
                amount = { name = 'amount', help = 'PengebelÃ¸p' },
            },
        },
        setmoney = {
            help = 'Angi spillerens pengebelÃ¸p (kun admin)',
            params = {
                id = { name = 'id', help = 'ID pÃ¥ spiller' },
                moneytype = { name = 'moneytype', help = 'Type: (cash, bank, crypto)' },
                amount = { name = 'amount', help = 'PengebelÃ¸p' },
            },
        },
        job = { help = 'Sjekk din jobb' },
        setjob = {
            help = 'Sett en spillerjobb (kun admin)',
            params = {
                id = { name = 'id', help = 'ID pÃ¥ spiller' },
                job = { name = 'job', help = 'Jobb navn' },
                grade = { name = 'grade', help = 'Jobb grad' },
            },
        },
        gang = { help = 'Sjekk din gjeng' },
        setgang = {
            help = 'Sett en spillergjeng (kun admin)',
            params = {
                id = { name = 'id', help = 'ID pÃ¥ spiller' },
                gang = { name = 'gang', help = 'Gjeng navn' },
                grade = { name = 'grade', help = 'Gjeng grad' },
            },
        },
        ooc = { help = 'UAK Chat Melding' },
        me = {
            help = 'Vis lokal melding',
            params = {
                message = { name = 'message', help = 'Melding Ã¥ sende' }
            },
        },
    },
}

if GetConvar('qb_locale', 'en') == 'no' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end