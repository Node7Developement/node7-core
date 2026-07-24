--[[
Romanian base language translation for qb-core
Translation done by wanderrer (Martin Riggs#0807 on Discord)
]]--
local Translations = {
    error = {
        not_online = 'JucÄƒtorul nu este online',
        wrong_format = 'Format incorect',
        missing_args = 'Nu au fost introduse toate argumentele (x, y, z)',
        missing_args2 = 'Trebuie completate toate argumentele!',
        no_access = 'Nu ai acces la aceastÄƒ comandÄƒ',
        company_too_poor = 'Angajatorul tÄƒu este falit',
        item_not_exist = 'Obiectul nu existÄƒ',
        too_heavy = 'Inventarul este prea plin',
        location_not_exist = 'LocaÈ›ia nu existÄƒ',
        job_not_exist               = 'Job does not exist',
        gang_not_exist              = 'Gang does not exist',
        duplicate_license = 'Duplicate Rockstar License Found',
        no_valid_license  = 'Nicio licenÈ›Äƒ Rockstar validÄƒ gÄƒsitÄƒ',
        not_whitelisted = 'Nu eÈ™ti Ã®n lista albÄƒ pentru acest server',
        server_already_open = 'Serverul este deja deschis',
        server_already_closed = 'Serverul este deja Ã®nchis',
        no_permission = 'Nu ai permisiuni pentru asta..',
        no_waypoint = 'Nu a fost setat un punct de referinÈ›Äƒ.',
        tp_error = 'Eroare Ã®n timpul teleportÄƒrii.',
        connecting_database_error = 'A apÄƒrut o eroare de bazÄƒ de date Ã®n timpul conectÄƒrii la server. (Este serverul SQL pornit?)',
        connecting_database_timeout = 'Conexiunea la baza de date a expirat. (Este serverul SQL pornit?)',
    },
    success = {
        server_opened = 'Serverul a fost deschis',
        server_closed = 'Serverul a fost Ã®nchis',
        teleported_waypoint = 'Teleportat la punctul de referinÈ›Äƒ.',
        job_set = 'Job set successfully',
        gang_set = 'Gang set successfully',
    },
    info = {
        received_paycheck = 'Ai primit salariul Ã®n valoare de $%{value}',
        job_info = 'Job: %{value} | Grad: %{value2} | ÃŽndatorire: %{value3}',
        gang_info = 'BandÄƒ: %{value} | Grad: %{value2}',
        on_duty = 'EÈ™ti Ã®n serviciu acum!',
        off_duty = 'Nu eÈ™ti Ã®n serviciu acum!',
        checking_ban = 'Salut %s. VerificÄƒm dacÄƒ eÈ™ti interzis.',
        join_server = 'Bun venit %s pe {Numele Serverului}.',
        checking_whitelisted = 'Salut %s. VerificÄƒm aprobarea ta.',
        exploit_banned = 'Ai fost interzis pentru Ã®nÈ™elÄƒciune. VerificÄƒ Discord-ul nostru pentru mai multe informaÈ›ii: %{discord}',
        exploit_dropped = 'Ai fost dat afarÄƒ pentru exploatare',
    },
    command = {
        tp = {
            help = 'TeleporteazÄƒ la un jucÄƒtor sau coordonate (doar pentru administrator)',
            params = {
                x = { name = 'id/x', help = 'ID-ul jucÄƒtorului sau poziÈ›ia X' },
                y = { name = 'y', help = 'PoziÈ›ia Y' },
                z = { name = 'z', help = 'PoziÈ›ia Z' },
            },
        },
        tpm = { help = 'TeleporteazÄƒ la marker (doar pentru administrator)' },
        togglepvp = { help = 'ActiveazÄƒ/dezactiveazÄƒ PVP pe server (doar pentru administrator)' },
        addpermission = {
            help = 'AcordÄƒ permisiuni jucÄƒtorului (doar pentru creator)',
            params = {
                id = { name = 'id', help = 'ID-ul jucÄƒtorului' },
                permission = { name = 'permission', help = 'Nivelul permisiunii' },
            },
        },
        removepermission = {
            help = 'EliminÄƒ permisiunile jucÄƒtorului (doar pentru creator)',
            params = {
                id = { name = 'id', help = 'ID-ul jucÄƒtorului' },
                permission = { name = 'permission', help = 'Nivelul permisiunii' },
            },
        },
        openserver = { help = 'Deschide serverul pentru toÈ›i (doar pentru administrator)' },
        closeserver = {
            help = 'ÃŽnchide serverul pentru persoanele fÄƒrÄƒ permisiuni (doar pentru administrator)',
            params = {
                reason = { name = 'reason', help = 'Motivul Ã®nchiderii (opÈ›ional)' },
            },
        },
        car = {
            help = 'GenereazÄƒ vehicul (doar pentru administrator)',
            params = {
                model = { name = 'model', help = 'Numele modelului vehiculului' },
            },
        },
        dv = { help = 'È˜terge vehicul (doar pentru administrator)' },
        givemoney = {
            help = 'DÄƒ bani unui jucÄƒtor (doar pentru administrator)',
            params = {
                id = { name = 'id', help = 'ID-ul jucÄƒtorului' },
                moneytype = { name = 'moneytype', help = 'Tipul de bani (cash, bancÄƒ, criptomonede)' },
                amount = { name = 'amount', help = 'Suma de bani' },
            },
        },
        setmoney = {
            help = 'SeteazÄƒ suma de bani a unui jucÄƒtor (doar pentru administrator)',
            params = {
                id = { name = 'id', help = 'ID-ul jucÄƒtorului' },
                moneytype = { name = 'moneytype', help = 'Tipul de bani (cash, bancÄƒ, criptomonede)' },
                amount = { name = 'amount', help = 'Suma de bani' },
            },
        },
        job = { help = 'VerificÄƒ-È›i jobul' },
        setjob = {
            help = 'SeteazÄƒ jobul unui jucÄƒtor (doar pentru administrator)',
            params = {
                id = { name = 'id', help = 'ID-ul jucÄƒtorului' },
                job = { name = 'job', help = 'Numele jobului' },
                grade = { name = 'grade', help = 'Gradul jobului' },
            },
        },
        gang = { help = 'VerificÄƒ-È›i banda' },
        setgang = {
            help = 'SeteazÄƒ banda unui jucÄƒtor (doar pentru administrator)',
            params = {
                id = { name = 'id', help = 'ID-ul jucÄƒtorului' },
                gang = { name = 'gang', help = 'Numele bÄƒndei' },
                grade = { name = 'grade', help = 'Gradul bÄƒndei' },
            },
        },
        ooc = { help = 'Mesaj chat OOC' },
        me = {
            help = 'AfiÈ™eazÄƒ un mesaj local',
            params = {
                message = { name = 'message', help = 'Mesajul de trimis' }
            },
        },
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
