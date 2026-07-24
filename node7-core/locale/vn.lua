local Translations = {
    error = {
        not_online = 'NgÆ°á»i chÆ¡i khÃ´ng trá»±c tuyáº¿n',
        wrong_format = 'Äá»‹nh dáº¡ng khÃ´ng chÃ­nh xÃ¡c',
        missing_args = 'ChÆ°a nháº­p Ä‘á»§ cÃ¡c sá»‘ (x, y, z)',
        missing_args2 = 'Táº¥t cáº£ cÃ¡c Ä‘á»‘i sá»‘ pháº£i Ä‘Æ°á»£c Ä‘iá»n vÃ o!',
        no_access = 'khÃ´ng cÃ³ quyá»n sá»­ dá»¥ng lá»‡nh nÃ y',
        company_too_poor = 'CÃ´ng ty cá»§a báº¡n Ä‘Ã£ phÃ¡ sáº£n',
        item_not_exist = 'Váº­t pháº©m khÃ´ng tá»“n táº¡i',
        too_heavy = 'kho Ä‘á»“ Ä‘Ã£ Ä‘áº§y',
        location_not_exist = 'Vá»‹ trÃ­ khÃ´ng tá»“n táº¡i',
        job_not_exist               = 'Job does not exist',
        gang_not_exist              = 'Gang does not exist',
        duplicate_license = 'ÄÃ£ tÃ¬m tháº¥y giáº¥y phÃ©p Rockstar trÃ¹ng láº·p',
        no_valid_license  = 'KhÃ´ng tÃ¬m tháº¥y giáº¥y phÃ©p Rockstar há»£p lá»‡',
        not_whitelisted = 'Báº¡n khÃ´ng náº±m trong danh sÃ¡ch cho phÃ©p cá»§a mÃ¡y chá»§ nÃ y',
        server_already_open = 'MÃ¡y chá»§ Ä‘Ã£ má»Ÿ cá»­a',
        server_already_closed = 'MÃ¡y chá»§ Ä‘Ã£ Ä‘Ã³ng cá»­a',
        no_permission = 'Báº¡n khÃ´ng cÃ³ quyá»n Ä‘á»ƒ lÃ m viá»‡c nÃ y',
        no_waypoint = 'KhÃ´ng cÃ³ Waypoint nÃ o Ä‘Æ°á»£c Ä‘áº·t.',
        tp_error = 'Lá»—i trong lÃºc dá»‹ch chuyá»ƒn.',
        connecting_database_error = 'ÄÃ£ xáº£y ra lá»—i trong lÃºc káº¿t ná»‘i Ä‘áº¿n mÃ¡y chá»§ CSDL. (MÃ¡y chá»§ SQL Ä‘Ã£ má»Ÿ?)',
        connecting_database_timeout = 'ÄÃ£ háº¿t thá»i gian káº¿t ná»‘i tá»›i CSDL. (MÃ¡y chá»§ SQL Ä‘Ã£ má»Ÿ?)',
    },
    success = {
        server_opened = 'ÄÃ£ má»Ÿ mÃ¡y chá»§',
        server_closed = 'ÄÃ£ Ä‘Ã³ng mÃ¡y chá»§',
        teleported_waypoint = 'ÄÃ£ dá»‹ch chuyá»ƒn tá»›i Waypoint.',
        job_set = 'Job set successfully',
        gang_set = 'Gang set successfully',
    },
    info = {
        received_paycheck = 'Báº¡n nháº­n Ä‘Æ°á»£c sá»‘ tiá»n thanh toÃ¡n lÃ  $%{value}',
        job_info = 'CÃ´ng viá»‡c: %{value} | Cáº¥p Ä‘á»™: %{value2} | LÃ m viá»‡c: %{value3}',
        gang_info = 'BÄƒng Ä‘áº£ng: %{value} | Cáº¥p Ä‘á»™: %{value2}',
        on_duty = 'Báº¡n Ä‘Ã£ sáºµn sÃ ng lÃ m viÃªc!',
        off_duty = 'Báº¡n Ä‘Ã£ dá»«ng lÃ m viá»‡c!',
        checking_ban = 'Xin chÃ o %s. ChÃºng tÃ´i Ä‘ang kiá»ƒm tra xem báº¡n cÃ³ bá»‹ cáº¥m khÃ´ng.',
        join_server = 'ChÃ o má»«ng %s Ä‘Ã£ Ä‘áº¿n vá»›i {Server Name}.',
        checking_whitelisted = 'Xin chÃ o %s. ChÃºng tÃ´i Ä‘ang kiá»ƒm tra trá»£ cáº¥p cá»§a báº¡n.',
        exploit_banned = 'Báº¡n Ä‘Ã£ bá»‹ cáº¥m vÃ¬ gian láº­n. Kiá»ƒm tra Discord cá»§a chÃºng tÃ´i Ä‘á»ƒ biáº¿t thÃªm thÃ´ng tin: %{discord}',
        exploit_dropped = 'Báº¡n Ä‘Ã£ bá»‹ Ä‘Ã¡ vÃ¬ lá»£i dá»¥ng lá»—i',
    },
    command = {
        tp = {
            help = 'Dá»‹ch chuyá»ƒn Ä‘áº¿n NgÆ°á»i chÆ¡i hoáº·c Tá»a Ä‘á»™ (Admin)',
            params = {
                x = { name = 'id/x', help = 'ID ngÆ°á»i chÆ¡i hoáº·c Tá»a Ä‘á»™ X'},
                y = { name = 'y', help = 'Tá»a Ä‘á»™ Y'},
                z = { name = 'z', help = 'Tá»a Ä‘á»™ Z'},
            },
        },
        tpm = { help = 'Dá»‹ch chuyá»ƒn Ä‘áº¿n Ä‘iá»ƒm ÄÃ¡nh dáº¥u (Admin)' },
        togglepvp = { help = 'Báº­t/Táº¯t PVP trÃªn mÃ¡y chá»§ (Admin)' },
        addpermission = {
            help = 'ThÃªm quyá»n cho ngÆ°á»i chÆ¡i (God)',
            params = {
                id = { name = 'id', help = 'ID ngÆ°á»i chÆ¡i' },
                permission = { name = 'permission', help = 'Cáº¥p Ä‘á»™ quyá»n' },
            },
        },
        removepermission = {
            help = 'XÃ³a quyá»n cá»§a ngÆ°á»i chÆ¡i (God)',
            params = {
                id = { name = 'id', help = 'ID ngÆ°á»i chÆ¡i' },
                permission = { name = 'permission', help = 'Cáº¥p Ä‘á»™ quyá»n' },
            },
        },
        openserver = { help = 'Má»Ÿ cá»­a mÃ¡y chá»§ (Admin)' },
        closeserver = {
            help = 'ÄÃ³ng mÃ¡y chá»§, chá»‰ cho phÃ©p ngÆ°á»i chÆ¡i cÃ³ quyá»n má»›i Ä‘Æ°á»£c tham gia (Admin)',
            params = {
                reason = { name = 'reason', help = 'LÃ½ do Ä‘Ã³ng mÃ¡y chá»§ (tÃ¹y chá»n)' },
            },
        },
        car = {
            help = 'Triá»‡u há»“i phÆ°Æ¡ng tiá»‡n (Admin)',
            params = {
                model = { name = 'model', help = 'TÃªn kiá»ƒu phÆ°Æ¡ng tiá»‡n' },
            },
        },
        dv = { help = 'XÃ³a phÆ°Æ¡ng tiá»‡n (Admin)' },
        givemoney = {
            help = 'Cho tiá»n ngÆ°á»i chÆ¡i (Admin)',
            params = {
                id = { name = 'id', help = 'ID ngÆ°á»i chÆ¡i' },
                moneytype = { name = 'moneytype', help = 'Loáº¡i tiá»n (cash, bank, crypto)' },
                amount = { name = 'amount', help = 'Sá»‘ tiá»n' },
            },
        },
        setmoney = {
            help = 'Äáº·t sá»‘ tiá»n cá»§a ngÆ°á»i chÆ¡i (Admin)',
            params = {
                id = { name = 'id', help = 'ID ngÆ°á»i chÆ¡i' },
                moneytype = { name = 'moneytype', help = 'Loáº¡i tiá»n (cash, bank, crypto)' },
                amount = { name = 'amount', help = 'Sá»‘ tiá»n' },
            },
        },
        job = { help = 'Kiá»ƒm tra cÃ´ng viá»‡c cá»§a báº¡n' },
        setjob = {
            help = 'Äáº·t cÃ´ng viá»‡c cho ngÆ°á»Ÿi chÆ¡i (Admin)',
            params = {
                id = { name = 'id', help = 'ID ngÆ°á»i chÆ¡i' },
                job = { name = 'job', help = 'TÃªn cÃ´ng viá»‡c' },
                grade = { name = 'grade', help = 'Cáº¥p Ä‘á»™ cÃ´ng viá»‡c' },
            },
        },
        gang = { help = 'Kiá»ƒm tra bÄƒng Ä‘áº£ng cá»§a báº¡n' },
        setgang = {
            help = 'Chá»‰ Ä‘á»‹nh bÄƒng Ä‘áº£ng cho ngÆ°á»i chÆ¡i (Admin)',
            params = {
                id = { name = 'id', help = 'ID ngÆ°á»i chÆ¡i' },
                gang = { name = 'gang', help = 'TÃªn bÄƒng Ä‘áº£ng' },
                grade = { name = 'grade', help = 'Cáº¥p Ä‘á»™ chá»©c vá»¥' },
            },
        },
        ooc = { help = 'Tin nháº¯n trÃ² chuyá»‡n OOC' },
        me = {
            help = 'Hiá»ƒn thá»‹ tin nháº¯n cá»¥c bá»™',
            params = {
                message = { name = 'message', help = 'Tin nháº¯n Ä‘á»ƒ gá»­i' }
            },
        },
    },
}

if GetConvar('qb_locale', 'en') == 'vn' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
