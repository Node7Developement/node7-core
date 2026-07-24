local Translations = {
    error = {
        not_online                  = 'ãƒ—ãƒ¬ã‚¤ãƒ¤ãƒ¼ã¯ã‚ªãƒ•ãƒ©ã‚¤ãƒ³ã§ã™',
        wrong_format                = 'å½¢å¼ãŒæ­£ã—ãã‚ã‚Šã¾ã›ã‚“',
        missing_args                = 'å…¨ã¦ã®å¼•æ•°ãŒå…¥åŠ›ã•ã‚Œã¦ã„ã¾ã›ã‚“ (x, y, z)',
        missing_args2               = 'å¼•æ•°ã¯å…¨ã¦å…¥åŠ›ã™ã‚‹å¿…è¦ãŒã‚ã‚Šã¾ã™',
        no_access                   = 'ã“ã®ã‚³ãƒžãƒ³ãƒ‰ã«ã¯ã‚¢ã‚¯ã‚»ã‚¹ã§ãã¾ã›ã‚“',
        company_too_poor            = 'ã‚ãªãŸã®é›‡ç”¨ä¸»ãŒç ´ç”£ã—ã¾ã—ãŸ',
        item_not_exist              = 'ã‚¢ã‚¤ãƒ†ãƒ ãŒã‚ã‚Šã¾ã›ã‚“',
        too_heavy                   = 'ã‚¤ãƒ³ãƒ™ãƒ³ãƒˆãƒªãŒæº€æ¯ã§ã™',
        location_not_exist          = 'ãã®ä½ç½®ã¯å­˜åœ¨ã—ã¾ã›ã‚“',
        duplicate_license           = '[NODE7CORE] - Rockstarãƒ©ã‚¤ã‚»ãƒ³ã‚¹ãŒé‡è¤‡ã—ã¦ã„ã¾ã™',
        no_valid_license            = '[NODE7CORE] - æœ‰åŠ¹ãªRockstarãƒ©ã‚¤ã‚»ãƒ³ã‚¹ãŒè¦‹ã¤ã‹ã‚Šã¾ã›ã‚“',
        not_whitelisted             = '[NODE7CORE] - ã‚ãªãŸã¯ãƒ›ãƒ¯ã‚¤ãƒˆãƒªã‚¹ãƒˆã«ç™»éŒ²ã•ã‚Œã¦ã„ã¾ã›ã‚“',
        server_already_open         = 'ã‚µãƒ¼ãƒãƒ¼ã¯æ—¢ã«ã‚ªãƒ¼ãƒ—ãƒ³ã—ã¦ã„ã¾ã™',
        server_already_closed       = 'ã‚µãƒ¼ãƒãƒ¼ã¯æ—¢ã«ã‚¯ãƒ­ãƒ¼ã‚ºã—ã¦ã„ã¾ã™',
        no_permission               = 'æ¨©é™ãŒã‚ã‚Šã¾ã›ã‚“',
        no_waypoint                 = 'ã‚¦ã‚§ã‚¤ãƒã‚¤ãƒ³ãƒˆãŒè¨­å®šã•ã‚Œã¦ã„ã¾ã›ã‚“',
        tp_error                    = 'ãƒ†ãƒ¬ãƒãƒ¼ãƒˆä¸­ã«ã‚¨ãƒ©ãƒ¼ãŒç™ºç”Ÿã—ã¾ã—ãŸ',
        connecting_database_error   = '[NODE7CORE] - ã‚µãƒ¼ãƒãƒ¼ã¸ã®æŽ¥ç¶šä¸­ã«ãƒ‡ãƒ¼ã‚¿ãƒ™ãƒ¼ã‚¹ã‚¨ãƒ©ãƒ¼ãŒç™ºç”Ÿã—ã¾ã—ãŸ(SQLã‚µãƒ¼ãƒã®ç¨¼åƒã‚’ç¢ºèªã—ã¦ãã ã•ã„)',
        connecting_database_timeout = '[NODE7CORE] - ãƒ‡ãƒ¼ã‚¿ãƒ™ãƒ¼ã‚¹ã¸ã®æŽ¥ç¶šãŒã‚¿ã‚¤ãƒ ã‚¢ã‚¦ãƒˆã—ã¾ã—ãŸ(SQLã‚µãƒ¼ãƒãƒ¼ã®ç¨¼åƒã‚’ç¢ºèªã—ã¦ãã ã•ã„)',
    },
    success = {
        server_opened = 'ã‚µãƒ¼ãƒãƒ¼ã‚’ã‚ªãƒ¼ãƒ—ãƒ³ã—ã¾ã—ãŸ',
        server_closed = 'ã‚µãƒ¼ãƒãƒ¼ã‚’ã‚¯ãƒ­ãƒ¼ã‚ºã—ã¾ã—ãŸ',
        teleported_waypoint = 'ã‚¦ã‚§ã‚¤ãƒã‚¤ãƒ³ãƒˆã«ãƒ†ãƒ¬ãƒãƒ¼ãƒˆã—ã¾ã—ãŸ',
        job_set = 'Job set successfully',
        gang_set = 'Gang set successfully',
    },
    info = {
        received_paycheck = '$%{value}ã®çµ¦ä¸Žã‚’å—ã‘å–ã£ãŸ',
        job_info = 'è·æ¥­: %{value} | éšŽç´š: %{value2} | å‹¤å‹™: %{value3}',
        gang_info = 'ã‚®ãƒ£ãƒ³ã‚°: %{value} | éšŽç´š: %{value2}',
        on_duty = 'å‡ºå‹¤ã—ã¾ã—ãŸï¼',
        off_duty = 'é€€å‹¤ã—ã¾ã—ãŸï¼',
        checking_ban = 'ã“ã‚“ã«ã¡ã¯ %s ã•ã‚“ã€‚ã‚ãªãŸãŒBANã•ã‚Œã¦ã„ãªã„ã‹ã‚’ç¢ºèªä¸­ã§ã™ã€‚',
        join_server = '{Server Name} ã¸ã‚ˆã†ã“ãã€‚%sã•ã‚“ã€‚',
        checking_whitelisted = 'ã“ã‚“ã«ã¡ã¯ %s ã•ã‚“ã€‚ãƒ›ãƒ¯ã‚¤ãƒˆãƒªã‚¹ãƒˆã‚’ç¢ºèªä¸­ã§ã™ã€‚',
        exploit_banned = 'ã‚ãªãŸã¯ä¸æ­£è¡Œç‚ºã«ã‚ˆã‚ŠBANã•ã‚Œã¾ã—ãŸã€‚è©³ã—ãã¯Discordã‚’ã”ç¢ºèªãã ã•ã„: %{discord}',
        exploit_dropped = 'ã‚ãªãŸã¯ä¸æ­£è¡Œç‚ºã«ã‚ˆã‚Šå¼·åˆ¶é€€å‡ºã•ã›ã‚‰ã‚Œã¾ã—ãŸ',
    },
    command = {
        tp = {
            help = 'ãƒ—ãƒ¬ã‚¤ãƒ¤ãƒ¼ã¾ãŸã¯åº§æ¨™ã¸ãƒ†ãƒ¬ãƒãƒ¼ãƒˆ (Adminå°‚ç”¨)',
            params = {
                x = { name = 'id/x', help = 'ãƒ—ãƒ¬ã‚¤ãƒ¤ãƒ¼IDã¾ãŸã¯Xåº§æ¨™' },
                y = { name = 'y', help = 'Yåº§æ¨™' },
                z = { name = 'z', help = 'Zåº§æ¨™' },
            },
        },
        tpm = { help = 'ãƒžãƒ¼ã‚«ãƒ¼ã¸ãƒ†ãƒ¬ãƒãƒ¼ãƒˆ (Adminå°‚ç”¨)' },
        togglepvp = { help = 'ã‚µãƒ¼ãƒä¸Šã®PVPå¯å¦ã‚’åˆ‡ã‚Šæ›¿ãˆ (Adminå°‚ç”¨)' },
        addpermission = {
            help = 'ãƒ—ãƒ¬ã‚¤ãƒ¤ãƒ¼ã«æ¨©é™ã‚’æ¸¡ã™ (Godå°‚ç”¨)',
            params = {
                id = { name = 'id', help = 'ãƒ—ãƒ¬ã‚¤ãƒ¤ãƒ¼ID' },
                permission = { name = 'permission', help = 'æ¨©é™ãƒ¬ãƒ™ãƒ«' },
            },
        },
        removepermission = {
            help = 'ãƒ—ãƒ¬ã‚¤ãƒ¤ãƒ¼ã®æ¨©é™ã‚’å‰¥å¥ª (Godå°‚ç”¨)',
            params = {
                id = { name = 'id', help = 'ãƒ—ãƒ¬ã‚¤ãƒ¤ãƒ¼ID' },
                permission = { name = 'permission', help = 'æ¨©é™ãƒ¬ãƒ™ãƒ«' },
            },
        },
        openserver = { help = 'ã‚µãƒ¼ãƒã‚’å…¨ä½“ã¸ã‚ªãƒ¼ãƒ—ãƒ³ã«ã—ã¾ã™ (Adminå°‚ç”¨)' },
        closeserver = {
            help = 'æ¨©é™ä¿æŒè€…ä»¥å¤–ã‚µãƒ¼ãƒã‚’ã‚¯ãƒ­ãƒ¼ã‚ºã—ã¾ã™ (Adminå°‚ç”¨)',
            params = {
                reason = { name = 'reason', help = 'ã‚¯ãƒ­ãƒ¼ã‚ºç†ç”±(ä»»æ„)' },
            },
        },
        car = {
            help = 'ä¹—ã‚Šç‰©ã‚’å¬å–š (Adminå°‚ç”¨)',
            params = {
                model = { name = 'model', help = 'ä¹—ã‚Šç‰©ã®ãƒ¢ãƒ‡ãƒ«å' },
            },
        },
        dv = { help = 'ä¹—ã‚Šç‰©ã‚’æ¶ˆåŽ» (Adminå°‚ç”¨)' },
        dvall = { help = 'å…¨ã¦ã®ä¹—ã‚Šç‰©ã‚’æ¶ˆåŽ» (Adminå°‚ç”¨)' },
        dvp = { help = 'å…¨ã¦ã®Pedã‚’æ¶ˆåŽ» (Adminå°‚ç”¨)' },
        dvo = { help = 'å…¨ã¦ã®ã‚ªãƒ–ã‚¸ã‚§ã‚¯ãƒˆã‚’æ¶ˆåŽ» (Adminå°‚ç”¨)' },
        givemoney = {
            help = 'ãƒ—ãƒ¬ã‚¤ãƒ¤ãƒ¼ã«ãŠé‡‘ã‚’æ¸¡ã™ (Adminå°‚ç”¨)',
            params = {
                id = { name = 'id', help = 'ãƒ—ãƒ¬ã‚¤ãƒ¤ãƒ¼ID' },
                moneytype = { name = 'moneytype', help = 'ç¨®é¡ž (cash, bank, crypto)' },
                amount = { name = 'amount', help = 'é‡‘é¡' },
            },
        },
        setmoney = {
            help = 'ãƒ—ãƒ¬ã‚¤ãƒ¤ãƒ¼ã®æ‰€æŒé‡‘ã‚’è¨­å®š (Adminå°‚ç”¨)',
            params = {
                id = { name = 'id', help = 'ãƒ—ãƒ¬ã‚¤ãƒ¤ãƒ¼ID' },
                moneytype = { name = 'moneytype', help = 'ç¨®é¡ž (cash, bank, crypto)' },
                amount = { name = 'amount', help = 'é‡‘é¡' },
            },
        },
        job = { help = 'è‡ªåˆ†ã®è·æ¥­ã‚’ç¢ºèª' },
        setjob = {
            help = 'ãƒ—ãƒ¬ã‚¤ãƒ¤ãƒ¼ã®è·æ¥­ã‚’è¨­å®š (Adminå°‚ç”¨)',
            params = {
                id = { name = 'id', help = 'ãƒ—ãƒ¬ã‚¤ãƒ¤ãƒ¼ID' },
                job = { name = 'job', help = 'è·æ¥­å' },
                grade = { name = 'grade', help = 'éšŽç´š' },
            },
        },
        gang = { help = 'è‡ªåˆ†ã®æ‰€å±žã‚®ãƒ£ãƒ³ã‚°ã‚’ç¢ºèª' },
        setgang = {
            help = 'ãƒ—ãƒ¬ã‚¤ãƒ¤ãƒ¼ã®æ‰€å±žã‚®ãƒ£ãƒ³ã‚°ã‚’è¨­å®š (Adminå°‚ç”¨)',
            params = {
                id = { name = 'id', help = 'ãƒ—ãƒ¬ã‚¤ãƒ¤ãƒ¼ID' },
                gang = { name = 'gang', help = 'ã‚®ãƒ£ãƒ³ã‚°å' },
                grade = { name = 'grade', help = 'éšŽç´š' },
            },
        },
        ooc = { help = 'OOC ãƒãƒ£ãƒƒãƒˆãƒ¡ãƒƒã‚»ãƒ¼ã‚¸' },
        me = {
            help = 'ãƒ­ãƒ¼ã‚«ãƒ«ãƒ¡ãƒƒã‚»ãƒ¼ã‚¸ã‚’è¡¨ç¤º',
            params = {
                message = { name = 'message', help = 'ãƒ¡ãƒƒã‚»ãƒ¼ã‚¸ã‚’é€ä¿¡' }
            },
        },
    },
}

if GetConvar('qb_locale', 'en') == 'ja' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
