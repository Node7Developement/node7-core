local Translations = {
    error = {
        not_online = 'çŽ©å®¶ä¸åœ¨çº¿',
        wrong_format = 'æ ¼å¼é”™è¯¯',
        missing_args = 'è¯·è¾“å…¥å¿…é¡»å‚æ•° (x, y, z)',
        missing_args2 = 'è¯·è¾“å…¥æ‰€æœ‰å‚æ•°!',
        no_access = 'ä½ æ²¡æœ‰æƒé™',
        company_too_poor = 'ä½ æ‰€åœ¨çš„å…¬å¸è´¦æˆ·ç›®å‰å‘ä¸èµ·å·¥èµ„',
        item_not_exist = 'è¯¥ç‰©å“ä¸å­˜åœ¨',
        too_heavy = 'èƒŒåŒ…å·²æ»¡',
        location_not_exist = 'ä½ç½®ä¸å­˜åœ¨',
        job_not_exist               = 'Job does not exist',
        gang_not_exist              = 'Gang does not exist',
        duplicate_license = 'å‘çŽ°é‡å¤çš„ Rockstar è®¸å¯è¯',
        no_valid_license  = 'æœªæ‰¾åˆ°æœ‰æ•ˆçš„ Rockstar è®¸å¯è¯',
        not_whitelisted = 'æ‚¨æ²¡æœ‰è¢«åˆ—å…¥æ­¤æœåŠ¡å™¨çš„ç™½åå•',
        server_already_open = 'æœåŠ¡å™¨å·²æ‰“å¼€',
        server_already_closed = 'æœåŠ¡å™¨å·²å…³é—­',
        no_permission = 'æ‚¨æ²¡æœ‰æ­¤æƒé™..',
        no_waypoint = 'æ— GPSç‚¹ä½è®¾ç½®.',
        tp_error = 'ä¼ é€æ—¶å‡ºé”™.',
        connecting_database_error = 'è¿žæŽ¥åˆ°æœåŠ¡å™¨æ—¶å‘ç”Ÿæ•°æ®åº“é”™è¯¯ã€‚(SQL serveræ˜¯å¦å·²æ‰“å¼€?)',
        connecting_database_timeout = 'ä¸Žæ•°æ®åº“çš„è¿žæŽ¥è¶…æ—¶ã€‚(SQL serveræ˜¯å¦å·²æ‰“å¼€?)',
    },
    success = {
        server_opened = 'æœåŠ¡å™¨å·²æ‰“å¼€',
        server_closed = 'æœåŠ¡å™¨å·²å…³é—­',
        teleported_waypoint = 'ä¼ é€è‡³èˆªè·¯ç‚¹.',
        job_set = 'Job set successfully',
        gang_set = 'Gang set successfully',
    },
    info = {
        received_paycheck = 'ä½ æ”¶åˆ°çš„è–ªæ°´æ˜¯ $%{value}',
        job_info = 'å·¥ä½œ: %{value} | çº§åˆ«: %{value2} | ä¸Šç­çŠ¶æ€: %{value3}',
        gang_info = 'å¸®æ´¾: %{value} | çº§åˆ«: %{value2}',
        on_duty = 'ä½ çŽ°åœ¨å¼€å§‹ä¸Šç­äº†!',
        off_duty = 'ä»ŽçŽ°åœ¨å¼€å§‹ä½ ä¸‹ç­äº†!',
        checking_ban = 'ä½ å¥½ %s. æˆ‘ä»¬æ­£åœ¨æ£€æŸ¥æ‚¨æ˜¯å¦è¢«ç¦æ­¢.',
        join_server = 'æ¬¢è¿Ž %s åŠ å…¥ {Server Name}.',
        checking_whitelisted = 'ä½ å¥½ %s. æˆ‘ä»¬æ­£åœ¨æ£€æŸ¥æ‚¨æ˜¯å¦åœ¨ç™½åå•å†….',
        exploit_banned = 'ä½ å› ä½œå¼Šè€Œè¢«ç¦æ­¢ã€‚æŸ¥çœ‹Discordäº†è§£æ›´å¤šä¿¡æ¯:%{discord}',
        exploit_dropped = 'ä½ å› ä¸ºè¢«è€Œè¢«è¸¢å‡º',
    },
    command = {
        tp = {
            help = 'TPè‡³çŽ©å®¶æˆ–åæ ‡(ä»…é™ç®¡ç†å‘˜)',
            params = {
                x = { name = 'id/x', help = 'çŽ©å®¶IDæˆ–Xä½ç½®'},
                y = { name = 'y', help = 'Yä½ç½®'},
                z = { name = 'z', help = 'Zä½ç½®'},
            },
        },
        tpm = { help = 'TPåˆ°æ ‡è®°(ä»…é™ç®¡ç†å‘˜)' },
        togglepvp = { help = 'åˆ‡æ¢æœåŠ¡å™¨ä¸Šçš„PVP(ä»…é™ç®¡ç†å‘˜)' },
        addpermission = {
            help = 'æŽˆäºˆçŽ©å®¶æƒé™(ä»…é™God)',
            params = {
                id = { name = 'id', help = 'çŽ©å®¶ID' },
                permission = { name = 'permission', help = 'æƒé™çº§åˆ«' },
            },
        },
        removepermission = {
            help = 'åˆ é™¤çŽ©å®¶æƒé™(ä»…é™ä¸Šå¸)',
            params = {
                id = { name = 'id', help = 'çŽ©å®¶ID' },
                permission = { name = 'permission', help = 'æƒé™çº§åˆ«' },
            },
        },
        openserver = { help = 'ä¸ºæ¯ä¸ªäººæ‰“å¼€æœåŠ¡å™¨(ä»…é™ç®¡ç†å‘˜)' },
        closeserver = {
            help = 'ä¸ºæ²¡æœ‰æƒé™çš„äººå…³é—­æœåŠ¡å™¨(ä»…é™ç®¡ç†å‘˜)',
            params = {
                reason = { name = 'reason', help = 'å…³é—­åŽŸå› (å¯é€‰)' },
            },
        },
        car = {
            help = 'åˆ·å‡ºè½¦è¾†(ä»…é™ç®¡ç†å‘˜)',
            params = {
                model = { name = 'model', help = 'è½¦è¾†åž‹å·åç§°' },
            },
        },
        dv = { help = 'åˆ é™¤è½¦è¾†(ä»…é™ç®¡ç†å‘˜)' },
        givemoney = {
            help = 'ç»™çŽ©å®¶é’±(ä»…é™ç®¡ç†å‘˜)',
            params = {
                id = { name = 'id', help = 'çŽ©å®¶ID' },
                moneytype = { name = 'moneytype', help = 'è´§å¸ç±»åž‹(cash, bank, crypto)' },
                amount = { name = 'amount', help = 'æ•°é‡' },
            },
        },
        setmoney = {
            help = 'è®¾ç½®çŽ©å®¶é‡‘é¢(ä»…é™ç®¡ç†å‘˜)',
            params = {
                id = { name = 'id', help = 'çŽ©å®¶ID' },
                moneytype = { name = 'moneytype', help = 'è´§å¸ç±»åž‹(cash, bank, crypto)' },
                amount = { name = 'amount', help = 'æ•°é‡' },
            },
        },
        job = { help = 'æ£€æŸ¥æ‚¨çš„å·¥ä½œ' },
        setjob = {
            help = 'è®¾ç½®çŽ©å®¶å·¥ä½œ(ä»…é™ç®¡ç†å‘˜)',
            params = {
                id = { name = 'id', help = 'çŽ©å®¶ID' },
                job = { name = 'job', help = 'å·¥ä½œåç§°' },
                grade = { name = 'grade', help = 'å·¥ä½œçº§åˆ«' },
            },
        },
        gang = { help = 'æ£€æŸ¥ä½ çš„å¸®æ´¾' },
        setgang = {
            help = 'è®¾ç½®çŽ©å®¶ä½œä¸š(ä»…é™ç®¡ç†å‘˜)',
            params = {
                id = { name = 'id', help = 'çŽ©å®¶ID' },
                gang = { name = 'gang', help = 'å¸®æ´¾åç§°' },
                grade = { name = 'grade', help = 'å¸®æ´¾çº§åˆ«' },
            },
        },
        ooc = { help = 'OOCèŠå¤©æ¶ˆæ¯' },
        me = {
            help = 'æ˜¾ç¤ºæœ¬åœ°æ¶ˆæ¯',
            params = {
                message = { name = 'message', help = 'è¦å‘é€çš„æ¶ˆæ¯' }
            },
        },
    },
}

if GetConvar('qb_locale', 'en') == 'cn' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end