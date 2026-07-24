local Translations = {
    error = {
     not_online = 'Pelaaja ei ole online-tilassa',
     wrong_format = 'VÃ¤Ã¤rÃ¤ muoto',
     missing_args = 'Kaikkia argumentteja ei ole syÃ¶tetty (x, y, z)',
     missing_args2 = 'Kaikki argumentit on tÃ¤ytettÃ¤vÃ¤!',
     no_access = 'Ei pÃ¤Ã¤syÃ¤ tÃ¤hÃ¤n komentoon',
     company_too_poor = 'TyÃ¶antajasi on konkurssissa',
     item_not_exist = 'Tuotetta ei ole olemassa',
     too_heavy = 'Varasto liian tÃ¤ynnÃ¤',
     location_not_exist = 'Sijaintia ei ole olemassa',
        job_not_exist               = 'Job does not exist',
        gang_not_exist              = 'Gang does not exist',
     duplicate_license = '[NODE7CORE] - Rockstar-lisenssin kaksoiskappale lÃ¶ydetty',
     no_valid_license = '[NODE7CORE] - Kelvollista Rockstar-lisenssiÃ¤ ei lÃ¶ytynyt',
     not_whitelisted = '[NODE7CORE] - Et ole sallittujen luettelossa tÃ¤lle palvelimelle',
     server_already_open = 'Palvelin on jo auki',
     server_already_closed = 'Palvelin on jo suljettu',
     no_permission = 'Sinulla ei ole oikeuksia tÃ¤hÃ¤n..',
     no_waypoint = 'Ei reittipistettÃ¤ asetettu.',
     tp_error = 'Virhe teleportoinnissa.',
     ban_table_not_found = '[NODE7CORE] - Kieltotaulukkoa ei lÃ¶ydy tietokannasta. Varmista, ettÃ¤ olet tuonut SQL-tiedoston oikein.',
     connecting_database_error = '[NODE7CORE] - Virhe muodostettaessa yhteyttÃ¤ tietokantaan. Varmista, ettÃ¤ SQL-palvelin on kÃ¤ynnissÃ¤ ja ettÃ¤ server.cfg-tiedoston tiedot ovat oikein.',
     connecting_database_timeout = '[NODE7CORE] - Tietokantayhteys aikakatkaistiin. Varmista, ettÃ¤ SQL-palvelin on kÃ¤ynnissÃ¤ ja ettÃ¤ server.cfg-tiedoston tiedot ovat oikein.',
    },
    success = {
        server_opened = 'Palvelin on avattu',
        server_closed = 'Palvelin on suljettu',
        teleported_waypoint = 'Teleporttaa Waypointille',
        job_set = 'Job set successfully',
        gang_set = 'Gang set successfully',
    },
    info = {
     Received_paycheck = 'Sait palkkasi $%{value}',
     job_info = 'TyÃ¶: %{value} | Arvosana: %{value2} | Tulli: %{value3}',
     gang_info = 'Joukku: %{value} | Arvosana: %{value2}',
     on_duty = 'Olet nyt pÃ¤ivystyksessÃ¤!',
     off_duty = 'Olet nyt vapaana!',
     checking_ban = 'Hei %s. Tarkistamme, oletko bannattu.',
     join_server = 'Tervetuloa %s palveluun {Palvelimen nimi}.',
     checking_whitelisted = 'Hei %s. Tarkistamme etusi.',
     exploit_banned = 'Sinulle on annettu porttikielto huijaamisen vuoksi. Katso lisÃ¤tietoja Discordistamme: %{discord}',
     exploit_dropped = 'Sinua on potkittu hyvÃ¤ksikÃ¤ytÃ¶n vuoksi',
    },
    command = {
        tp = {
            help = 'TP pelaajalle tai koordinaateille (Vain Admineille)',
            params = {
                x = { name = 'id/x', help = 'Pelaajan ID tai X-paikka'},
                y = { name = 'y', help = 'Y position'},
                z = { name = 'z', help = 'Z position'},
            },
        },
        tpm = { help = 'TP Markerille (Vain Admineille)' },
        togglepvp = { help = 'Vaihda PVP palvelimelle (Vain Admineille)' },
        noclip = { help = 'Ei klippiÃ¤ (vain jÃ¤rjestelmÃ¤nvalvoja)' },
        addpermission = {
            help = 'Anna pelaajalle admin oikeudet (God Only)',
            params = {
                id = { name = 'id', help = 'Pelaajan ID' },
                permission = { name = 'permission', help = 'Permission level' },
            },
        },
        removepermission = {
            help = 'Poista pelaajatlta admin oikeudet (God Only)',
            params = {
                id = { name = 'id', help = 'Pelaajan ID' },
                permission = { name = 'permission', help = 'Permission level' },
            },
        },
        openserver = { help = 'Avaa palvelin kaikille (Vain Admineille)' },
        closeserver = {
            help = 'Sulje palvelin ihmisiltÃ¤, â€‹â€‹joilla ei ole oikeuksia (Vain Admineille)',
            params = {
                reason = { name = 'reason', help = 'Sulkemisen syy (valinnainen)' },
            },
        },
        car = {
            help = 'Spawnaa ajoneuvo (Vain Admineille)',
            params = {
                model = { name = 'model', help = 'Ajoneuvon nimi' },
            },
        },
         dv = { help = 'Poista ajoneuvo (vain jÃ¤rjestelmÃ¤nvalvoja)' },
         dvall = { help = 'Poista kaikki ajoneuvot (vain jÃ¤rjestelmÃ¤nvalvoja)' },
         dvp = { help = 'Poista kaikki Peds (vain jÃ¤rjestelmÃ¤nvalvoja)' },
         dvo = { help = 'Poista kaikki objektit (vain jÃ¤rjestelmÃ¤nvalvoja)' },
        givemoney = {
            help = 'Anna Pelaajalle rahaa (Vain Admineille)',
            params = {
                id = { name = 'id', help = 'Pelaajan ID' },
                moneytype = { name = 'moneytype', help = 'Rahan tyyppi (cash, bank, crypto)' },
                amount = { name = 'amount', help = 'Rahan mÃ¤Ã¤rÃ¤' },
            },
        },
        setmoney = {
            help = 'Aseta pelaajien rahasumma (Vain Admineille)',
            params = {
                id = { name = 'id', help = 'Pelaajan ID' },
                moneytype = { name = 'moneytype', help = 'Rahan tyyppi (cash, bank, crypto)' },
                amount = { name = 'amount', help = 'Rahan mÃ¤Ã¤rÃ¤' },
            },
        },
        job = { help = 'katso tyÃ¶si' },
        setjob = {
            help = 'Aseta pelaajalle tyÃ¶ (Vain Admineille)',
            params = {
                id = { name = 'id', help = 'Pelaajan ID' },
                job = { name = 'job', help = 'TyÃ¶n nimi' },
                grade = { name = 'grade', help = 'Arvo' },
            },
        },
        gang = { help = 'Katso jengisi' },
        setgang = {
            help = 'Aseta pelaajalle jengi (Vain Admineille)',
            params = {
                id = { name = 'id', help = 'Pelaajan ID' },
                gang = { name = 'gang', help = 'Jengin Nimi' },
                grade = { name = 'grade', help = 'Arvo' },
            },
        },
        ooc = { help = 'OOC Viesti lÃ¤hipelaajille' },
        me = {
            help = 'NÃ¤ytÃ¤ paikallinen viesti',
            params = {
                message = { name = 'message', help = 'MitÃ¤ haluat kertoa?' }
            },
        },
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
