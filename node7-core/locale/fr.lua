local Translations = {
    error = {
        not_online = 'Le joueur n\'est pas connectÃ©',
        wrong_format = 'Format incorrect',
        missing_args = 'Arguments manquants (x, y, z)',
        missing_args2 = 'Tous les arguments doivent Ãªtre remplis!',
        no_access = 'Vous n\'avez pas accÃ¨s Ã  cette commande',
        company_too_poor = 'Votre entreprise n\'a pas suffisamment d\'argent',
        item_not_exist = 'L\'objet n\'existe pas',
        too_heavy = 'L\'inventaire est plein',
        location_not_exist = 'Destination inexistante',
        job_not_exist               = 'Job does not exist',
        gang_not_exist              = 'Gang does not exist',
        duplicate_license = 'License Rockstar DupliquÃ©e trouvÃ©e',
        no_valid_license  = 'Aucune License Rockstar trouvÃ©e',
        not_whitelisted = 'Vous n\'Ãªtes pas WhitelistÃ© sur ce serveur',
        server_already_open = 'Le serveur est dÃ©jÃ  ouvert',
        server_already_closed = 'Le serveur est dÃ©jÃ  fermÃ©',
        no_permission  = 'Vous n\'avez pas les permissions pour cela',
        no_waypoint = 'Pas de marqueur dÃ©fini.',
        tp_error = 'Erreur lors de la tÃ©lÃ©portation.',
    },
    success = {
        server_opened = 'Le serveur a Ã©tÃ© ouvert',
        server_closed = 'Le serveur a Ã©tÃ© fermÃ©',
        teleported_waypoint = 'TÃ©lÃ©portÃ© au marqueur',
        job_set = 'Job set successfully',
        gang_set = 'Gang set successfully',
    },
    info = {
        received_paycheck = 'Vous avez reÃ§u votre salaire de : $%{value}',
        job_info = 'Emplois: %{value} | Grade: %{value2} | Service: %{value3}',
        gang_info = 'Gang: %{value} | Grade: %{value2}',
        org_info = 'Org: %{value} | Grade: %{value2}',
        on_duty = 'Vous Ãªtes dÃ©sormais en service!',
        off_duty = 'Vous n\'Ãªtes plus en service!',
        checking_ban = 'Bonjour %s. Nous verifions si vous Ãªtes banni.',
        validatin_license = 'Bonjour %s. Nous validons votre License Rockstar.',
        join_server = 'Bienvenue %s sur {Server Name}.',
        checking_whitelisted = 'Bonjour %s. Nous vÃ©rifions si vous Ãªtes Whitelist.',
        exploit_banned = 'Vous avez Ã©tÃ© ban parceque vous avez trichÃ©. Allez sur notre discord pour plus d\'information: %{discord}',
        exploit_dropped = 'Vous avez Ã©tÃ© kick pour exploitation.',
    },
    command = {
        tp = {
            help = 'TP vers un joueur ou des coordonnÃ©es (Admin Only)',
            params = {
                x = { name ='id/x', help = 'ID du joueur ou position X',},
                y = { name = 'y', help = 'Position Y'},
                z = { name = 'z', help = 'Position Z'},
            },
        },
        tpm = { help = 'TP au marqueur (Admin Only)'},
        togglepvp = { help = 'Activer/DÃ©sactiver le PVP sur le serveur (Admin Only)'},
        addpermission = {
            help = 'Donner des permissions Ã  un joueur (God Only)',
            params = {
                id = { name = 'id', help = 'ID du joueur',},
                permission = { name = 'permission', help = 'Niveau de permission',},
            },
        },
        removepermission = {
            help = 'Retirer les permissions d\'un joueur (God Only)',
            params = {
                id = { name = 'id', help = 'ID du joueur',},
                permission = { name = 'permission', help = 'Niveau de permission',},
            },
        },
        openserver = { help = 'Ouvrir le serveur Ã  tout le monde (Admin Only)'},
        closeserver = {
            help = 'Fermer le serveur au joueurs sans permissions (Admin Only)',
            params = {
                reason = { name = 'reason', help = 'Raison de fermeture du serveur (Optionnel)',},
            },
        },
        car = {
            help = 'Faire apparaÃ®tre un vÃ©hicule (Admin Only)',
            params = {
                model = { name = 'model', help = 'ModÃ¨le du vÃ©hicule',},
            },
        },
        dv = { help = 'Supprimer un vÃ©hicule (Admin Only)'},
        dvall = { help = 'Supprimer tous les vÃ©hicules (Admin Only)' },
        dvp = { help = 'Supprimer tous les Peds (Admin Only)' },
        dvo = { help = 'Supprimer tous les Objets (Admin Only)' },
        givemoney = {
            help = 'Donner de l\'argent Ã  un joueur (Admin Only)',
            params = {
                id = { name = 'id', help = 'ID du joueur',},
                moneytype = { name = 'moneytype', help = 'Type d\'argent (cash, bank, crypto)',},
                amount = { name = 'amount', help = 'Montant' },
            },
        },
        setmoney = {
            help = 'DÃ©finir le solde d\'un joueur (Admin Only)',
            params = {
                id = { name = 'id', help = 'ID du joueur',},
                moneytype = { name = 'moneytype', help = 'Type d\'argent (cash, bank, crypto)',},
                amount = { name = 'amount', help = 'Montant' },
            },
        },
        job = { help = 'Voir son travail'},
        setjob = {
            help = 'DÃ©finir le travail d\'un joueur (Admin Only)',
            params = {
                id = { name = 'id', help = 'ID du joueur',},
                job = { name = 'job', help = 'Nom du Travail',},
                grade = { name = 'grade', help = 'Grade'},
            },
        },
        gang = { help = 'Voir son gang'},
        setgang = {
            help = 'DÃ©finir le gang d\'un joueur (Admin Only)',
            params = {
                id = { name = 'id', help = 'ID du joueur',},
                gang = { name = 'gang', help = 'Nom du Gang',},
                grade = { name = 'grade', help = 'Grade'},
            },
        },
        ooc = { help = 'Envoyer un message HRP'},
        me = {
            help = 'Envoyer un message local',
            params = {
                message = { name = 'message', help = 'Message'}
            },
        },
    },
}

if GetConvar('qb_locale', 'en') == 'fr' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
