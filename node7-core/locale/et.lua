local Translations = {
    error = {
        not_online = 'MÃ¤ngija pole serveris',
        wrong_format = 'Vale vorming',
        missing_args = 'KÃµiki argumente pole sisestatud (x, y, z)',
        missing_args2 = 'KÃµik argumendid tuleb tÃ¤ita!',
        no_access = 'Sellele kÃ¤sule pole juurdepÃ¤Ã¤su',
        company_too_poor = 'Teie tÃ¶Ã¶andja on vÃµlgades',
        item_not_exist = 'Asi ei eksisteeri',
        too_heavy = 'Inventuur on liiga tÃ¤is',
        location_not_exist = 'Asukoht ei eksisteeri',
        job_not_exist               = 'Job does not exist',
        gang_not_exist              = 'Gang does not exist',
        duplicate_license = 'Leiti Rockstari litsentsi duplikaat',
        no_valid_license  = 'Kehtivat Rockstari litsentsi ei leitud',
        not_whitelisted = 'Te ei ole selle serveri jaoks Allowlisted',
        server_already_open = 'Server on juba avatud',
        server_already_closed = 'Server on juba suletud',
        no_permission = 'Teil pole selleks Ãµigusi..',
        no_waypoint = 'Ãœhtegi punkti ei ole mÃ¤rgitud.',
        tp_error = 'Teleportimise viga.',
    },
    success = {
        server_opened = 'Server on avatud',
        server_closed = 'Server on suletud',
        teleported_waypoint = 'Teleporteerusid punktile.',
        job_set = 'Job set successfully',
        gang_set = 'Gang set successfully',
    },
    info = {
        received_paycheck = 'Saite oma palga $%{value}',
        job_info = 'TÃ¶Ã¶: %{value} | Auaste: %{value2} | TÃ¶Ã¶postil: %{value3}',
        gang_info = 'Gang: %{value} | Auaste: %{value2}',
        on_duty = 'Sa oled tÃ¶Ã¶le kirjutatud!',
        off_duty = 'Sa kirjutasid ennast tÃ¶Ã¶lt vabaks!',
        checking_ban = 'Tere %s. Me kontrollime, kas olete keelustatud.',
        join_server = 'Tere tulemast %s serverisse {Server Name}.',
        checking_whitelisted = 'Tere %s. Kontrollime teie Allowlisti staatust.',
        exploit_banned = 'Olete saanud petmise eest mÃ¤ngukeelu. Lisateabe saamiseks vaadake meie Discordi: %{discord}',
        exploit_dropped = 'Sind visati serverist vÃ¤lja petmise tÃµttu.',
    },
    command = {
        tp = {
            help = 'TP mÃ¤ngijale vÃµi koordinaatidele (ainult administraator)',
            params = {
                x = { name = 'id/x', help = 'ID mÃ¤ngija vÃµi X positsioon'},
                y = { name = 'y', help = 'Y positsioon'},
                z = { name = 'z', help = 'Z positsioon'},
            },
        },
        tpm = { help = 'TP Markerile (ainult administraator)' },
        togglepvp = { help = 'PVP serveris sisse- ja vÃ¤ljalÃ¼litamine (ainult administraator)' },
        addpermission = {
            help = 'Andke mÃ¤ngijale Ãµigused (ainult jumal)',
            params = {
                id = { name = 'id', help = 'mÃ¤ngija ID' },
                permission = { name = 'permission', help = 'Permission level' },
            },
        },
        removepermission = {
            help = 'Eemaldage mÃ¤ngija Ãµigused (ainult jumal)',
            params = {
                id = { name = 'id', help = 'mÃ¤ngija ID' },
                permission = { name = 'Ãµigused', help = 'Ã•iguse tase' },
            },
        },
        openserver = { help = 'Ava server kÃµigile (ainult administraator)' },
        closeserver = {
            help = 'Sulgege server ilma Ãµigusteta inimeste jaoks (ainult administraator)',
            params = {
                reason = { name = 'pÃµhjus', help = 'Sulgemise pÃµhjus (valikuline)' },
            },
        },
        car = {
            help = 'SÃµiduki loomine (ainult administraator)',
            params = {
                model = { name = 'mudel', help = 'SÃµiduki mudeli nimi' },
            },
        },
        dv = { help = 'SÃµiduki kustutamine (ainult administraator)' },
        givemoney = {
            help = 'MÃ¤ngija rahasumma mÃ¤Ã¤ramine (ainult administraator)',
            params = {
                id = { name = 'id', help = 'MÃ¤ngija ID' },
                moneytype = { name = 'rahatÃ¼Ã¼p', help = 'Raha liik (sularaha, pank, krÃ¼pto)' },
                amount = { name = 'kogus', help = 'Rahasumma' },
            },
        },
        setmoney = {
            help = 'MÃ¤ngija rahasumma mÃ¤Ã¤ramine (ainult administraator)',
            params = {
                id = { name = 'id', help = 'MÃ¤ngija ID' },
                moneytype = { name = 'rahatÃ¼Ã¼p', help = 'Raha liik (sularaha, pank, krÃ¼pto)' },
                amount = { name = 'kogus', help = 'Rahasumma' },
            },
        },
        job = { help = 'Kontrollige oma tÃ¶Ã¶dkohta' },
        setjob = {
            help = 'MÃ¤ngijale tÃ¶Ã¶koha mÃ¤Ã¤ramine (ainult administraator)',
            params = {
                id = { name = 'id', help = 'MÃ¤ngija ID' },
                job = { name = 'tÃ¶Ã¶', help = 'TÃ¶Ã¶koha nimi' },
                grade = { name = 'tase', help = 'TÃ¼Ã¼koha tase' },
            },
        },
        gang = { help = 'Kontrollige oma grupeeringut' },
        setgang = {
            help = 'MÃ¤Ã¤ra mÃ¤ngija grupeeringu (ainult administraator)',
            params = {
                id = { name = 'id', help = 'Player ID' },
                gang = { name = 'grupeering', help = 'Grupeeringu nimi' },
                grade = { name = 'tase', help = 'Grupeeringu tase' },
            },
        },
        ooc = { help = 'OOC vestlussÃµnum' },
        me = {
            help = 'Kuva kohalikud sÃµnumid',
            params = {
                message = { name = 'sÃµnum', help = 'SÃµnum saatmiseks' }
            },
        },
    },
}

if GetConvar('qb_locale', 'en') == 'et' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
