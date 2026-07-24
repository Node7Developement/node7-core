local Translations = {
    error = {
        not_online = 'ekki Ã¡ netinu',
        wrong_format = 'rangt sniÃ°',
        missing_args = 'Ekki er bÃºiÃ° aÃ° fÃ¦ra inn Ã¶ll rÃ¶k (x, y, z)',
        missing_args2 = 'Ã–ll rÃ¶k verÃ°ur aÃ° fylla Ãºt!',
        no_access = 'Enginn aÃ°gangur aÃ° Ã¾essari skipun',
        company_too_poor = 'Vinnuveitandi Ã¾inn er blankur',
        item_not_exist = 'Varan er ekki til',
        too_heavy = 'BirgÃ°ir of fullar',
        location_not_exist = 'StaÃ°setning er ekki til',
        job_not_exist               = 'Job does not exist',
        gang_not_exist              = 'Gang does not exist',
        duplicate_license = 'Afrit Rockstar leyfi fannst',
        no_valid_license  = 'Ekkert gilt Rockstar leyfi fannst',
        not_whitelisted = 'ÃžÃº  ert ekki Ã¡ hvÃ­tlista fyrir Ã¾ennan netÃ¾jÃ³n',
        server_already_open = 'MiÃ°larinn er Ã¾egar opinn',
        server_already_closed = 'MiÃ°larinn er Ã¾egar lokaÃ°ur',
        no_permission = 'ÃžÃº hefur ekki heimildir fyrir Ã¾essu..',
        no_waypoint = 'Engin leiÃ°arpunktur settur.',
        tp_error = 'Villa viÃ° fjarflutning.',
    },
    success = {
        server_opened = 'MiÃ°larinn hefur veriÃ° opnaÃ°ur',
        server_closed = 'MiÃ°larinn hefur veriÃ° lokaÃ°ur',
        teleported_waypoint = 'Teleported til Waypoint.',
        job_set = 'Job set successfully',
        gang_set = 'Gang set successfully',
    },
    info = {
        received_paycheck = 'ÃžÃº fÃ©kkst launaseÃ°ilinn Ã¾inn af $%{value}',
        job_info = 'Starf: %{value} | Einkunn: %{value2} | Skylda: %{value3}',
        gang_info = 'Gang: %{value} | Einkunn: %{value2}',
        on_duty = 'ÃžÃº ert nÃº Ã¡ vakt!',
        off_duty = 'ÃžÃº ert nÃº Ã¡ vakt!',
        checking_ban = 'HallÃ³ %s. ViÃ° erum aÃ° athuga hvort Ã¾Ãº sÃ©rt bannaÃ°ur.',
        join_server = 'Velkominn %s til {Nafn netÃ¾jÃ³ns}.',
        checking_whitelisted = 'HallÃ³ %s. ViÃ° erum aÃ° athuga vasapeningana Ã¾Ã­na.',
        exploit_banned = 'ÃžÃº hefur veriÃ° bannaÃ°ur fyrir svindl. AthugaÃ°u Discord okkar til aÃ° fÃ¡ frekari upplÃ½singar: %{discord}',
        exploit_dropped = 'ÃžÃ©r hefur veriÃ° sparkaÃ° fyrir arÃ°rÃ¡n',
    },
    command = {
        tp = {
            help = 'TP Til leikmanns eÃ°a coords (AÃ°eins stjÃ³rnandi)',
            params = {
                x = { name = 'id/x', help = 'ID af leikmanni eÃ°a X staÃ°a'},
                y = { name = 'y', help = 'Y position'},
                z = { name = 'z', help = 'Z position'},
            },
        },
        tpm = { help = 'TP To Til Marker (AÃ°eins stjÃ³rnandi)' },
        togglepvp = { help = 'Toggle PVP on the server (AÃ°eins stjÃ³rnandi)' },
        addpermission = {
            help = 'Give Player Permissions (God Only)',
            params = {
                id = { name = 'id', help = 'ID of player' },
                permission = { name = 'permission', help = 'Permission level' },
            },
        },
        removepermission = {
            help = 'Remove Player Permissions (God Only)',
            params = {
                id = { name = 'id', help = 'ID of player' },
                permission = { name = 'permission', help = 'Permission level' },
            },
        },
        openserver = { help = 'Open the server for everyone (AÃ°eins stjÃ³rnandi)' },
        closeserver = {
            help = 'Close the server for people without permissions (AÃ°eins stjÃ³rnandi)',
            params = {
                reason = { name = 'reason', help = 'Reason for closing (optional)' },
            },
        },
        car = {
            help = 'Spawn Vehicle (AÃ°eins stjÃ³rnandi)',
            params = {
                model = { name = 'model', help = 'Model name of the vehicle' },
            },
        },
        dv = { help = 'Delete Vehicle (AÃ°eins stjÃ³rnandi)' },
        givemoney = {
            help = 'GefÃ°u spilara peninga (AÃ°eins stjÃ³rnandi)',
            params = {
                id = { name = 'id', help = 'LeikmaÃ°ur ID' },
                moneytype = { name = 'moneytype', help = 'Tegund peninga (reiÃ°ufÃ©, banki, dulritun)' },
                amount = { name = 'amount', help = 'Magn peninga' },
            },
        },
        setmoney = {
            help = 'Stilltu peningaupphÃ¦Ã° leikmanna (AÃ°eins stjÃ³rnandi)',
            params = {
                id = { name = 'id', help = 'LeikmaÃ°ur ID' },
                moneytype = { name = 'moneytype', help = 'Tegund peninga (reiÃ°ufÃ©, banki, dulritun)' },
                amount = { name = 'amount', help = 'Magn peninga' },
            },
        },
        job = { help = 'AthugaÃ°u starf Ã¾itt' },
        setjob = {
            help = 'Settu leikmannastarf (AÃ°eins stjÃ³rnandi)',
            params = {
                id = { name = 'id', help = 'LeikmaÃ°ur ID' },
                job = { name = 'job', help = 'Nafn starfs' },
                grade = { name = 'grade', help = 'Starfseinkunn' },
            },
        },
        gang = { help = 'AthugaÃ°u Ã¾inn Gang' },
        setgang = {
            help = 'Stilltu leikmann Gang (AÃ°eins stjÃ³rnandi)',
            params = {
                id = { name = 'id', help = 'LeikmaÃ°ur ID' },
                gang = { name = 'gang', help = ' klÃ­ku nafn' },
                grade = { name = 'grade', help = ' klÃ­kustig' },
            },
        },
        ooc = { help = 'OOC spjallskilaboÃ°' },
        me = {
            help = 'SÃ½na staÃ°bundin skilaboÃ°',
            params = {
                message = { name = 'message', help = 'SkilaboÃ° til aÃ° senda' }
            },
        },
    },
}

if GetConvar('qb_locale', 'en') == 'is' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
