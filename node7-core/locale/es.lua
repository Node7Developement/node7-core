local Translations = {
    error = {
        not_online = 'El jugador no estÃ¡ conectado',
        wrong_format = 'Formato incorrecto',
        missing_args = 'No se han ingresado todos los argumentos (x, y, z)',
        missing_args2 = 'Â¡Debes ingresar todos los argumentos!',
        no_access = 'No tienes acceso a este comando',
        company_too_poor = 'Tu empleador estÃ¡ en bancarrota',
        item_not_exist = 'El objeto no existe',
        too_heavy = 'No hay espacio en tu inventario',
        location_not_exist = 'La ubicaciÃ³n no existe',
        job_not_exist               = 'Job does not exist',
        gang_not_exist              = 'Gang does not exist',
        duplicate_license = 'Licencia de Rockstar duplicada',
        no_valid_license  = 'No tienes una licencia de Rockstar vÃ¡lida',
        not_whitelisted = 'No tienes acceso a este servidor',
        server_already_open = 'El servidor ya estÃ¡ abierto',
        server_already_closed = 'El servidor ya estÃ¡ cerrado',
        no_permission = 'No tienes permisos para esto..',
        no_waypoint = 'No hay waypoint establecido.',
        tp_error = 'Error mientras se teletransporta.',
        connecting_database_error   = '[NODE7CORE] - Un error en la base de datos sucediÃ³ mientras te conectabas al servidor (Â¿EstÃ¡ la SQL del servidor encendida?)',
        connecting_database_timeout = '[NODE7CORE] - La conexiÃ³n con la base de datos fallÃ³ (Â¿EstÃ¡ la SQL del servidor encendida?)',
    },
    success = {
        server_opened = 'El servidor ha sido abierto',
        server_closed = 'El servidor ha sido cerrado',
        teleported_waypoint = 'Teletransportado a punto de encuentro.',
        job_set = 'Job set successfully',
        gang_set = 'Gang set successfully',
    },
    info = {
        received_paycheck = 'Has recibido tu salario de $%{value}',
        job_info = 'Trabajo: %{value} | Puesto: %{value2} | Estado: %{value3}',
        gang_info = 'Pandilla: %{value} | Puesto: %{value2}',
        on_duty = 'Â¡EstÃ¡s en servicio!',
        off_duty = 'Â¡EstÃ¡s fuera de servicio!',
        checking_ban = 'Hola %s. Estamos revisando la lista de baneos.',
        join_server = 'Bienvenid@ a {Server Name}, %s.',
        checking_whitelisted = 'Hola %s. Estamos revisando si tienes acceso a nuestro servidor.',
        exploit_banned = 'Has sido expulsado por hacer trampas. Consulta nuestro Discord para mÃ¡s informaciÃ³n: %{discord}',
        exploit_dropped = 'Has sido expulsado por hacer trampas',
    },
    command = {
        tp = {
            help = 'TP al jugador o a las coordenadas (sÃ³lo para admin)',
            params = {
                x = { name = 'id/x', help = 'ID de jugador o posiciÃ³n X'},
                y = { name = 'y', help = 'Y posiciÃ³n'},
                z = { name = 'z', help = 'Z posiciÃ³n'},
            },
        },
        tpm = { help = 'TP al marcador (sÃ³lo para admin)' },
        togglepvp = { help = 'Activar el PVP en el servidor (sÃ³lo para admin)' },
        addpermission = {
            help = 'Dar permisos al jugador (sÃ³lo modo Dios)',
            params = {
                id = { name = 'id', help = 'ID del jugador' },
                permission = { name = 'permission', help = 'Nivel de permiso' },
            },
        },
        removepermission = {
            help = 'Eliminar los permisos de los jugadores (sÃ³lo modo Dios)',
            params = {
                id = { name = 'id', help = 'ID del jugador' },
                permission = { name = 'permission', help = 'Nivel de permiso' },
            },
        },
        openserver = { help = 'Abrir el servidor para todo el mundo (sÃ³lo para admin)' },
        closeserver = {
            help = 'Cerrar el servidor para personas sin permisos (sÃ³lo para admin)',
            params = {
                reason = { name = 'reason', help = 'Motivo del cierre (opcional)' },
            },
        },
        car = {
            help = 'Crear VehÃ­culo (sÃ³lo para admin)',
            params = {
                model = { name = 'model', help = 'Nombre del modelo del vehÃ­culo' },
            },
        },
        dv = { help = 'Borrar vehÃ­culo (sÃ³lo para admin)' },
        dvall = { help = 'Borrar todos los VehÃ­culos (sÃ³lo para admin)' },
        dvp = { help = 'Borrar todos las Peds (sÃ³lo para admin)' },
        dvo = { help = 'Borrar todos los Objectos (sÃ³lo para admin)' },
        givemoney = {
            help = 'Dar dinero a un jugador (sÃ³lo para admin)',
            params = {
                id = { name = 'id', help = 'ID del jugador' },
                moneytype = { name = 'moneytype', help = 'Tipo de dinero (efectivo, banco, cripto)' },
                amount = { name = 'amount', help = 'Cantidad de dinero' },
            },
        },
        setmoney = {
            help = 'Establecer la cantidad de dinero de los jugadores (sÃ³lo para admin)',
            params = {
                id = { name = 'id', help = 'ID del jugador' },
                moneytype = { name = 'moneytype', help = 'Tipo de dinero (efectivo, banco, cripto)' },
                amount = { name = 'amount', help = 'Cantidad de dinero' },
            },
        },
        job = { help = 'Compruebe su trabajo' },
        setjob = {
            help = 'Establecer un trabajo de jugador (sÃ³lo para admin)',
            params = {
                id = { name = 'id', help = 'ID del jugador' },
                job = { name = 'job', help = 'Nombre del trabajo' },
                grade = { name = 'grade', help = 'Grado de trabajo' },
            },
        },
        gang = { help = 'Comprueba tu banda' },
        setgang = {
            help = 'Establecer una banda de jugadores (sÃ³lo para admin)',
            params = {
                id = { name = 'id', help = 'ID del jugador' },
                gang = { name = 'gang', help = 'Nombre de la banda' },
                grade = { name = 'grade', help = 'Grado de banda' },
            },
        },
        ooc = { help = 'Mensaje del chat OOC' },
        me = {
            help = 'Mostrar mensaje local',
            params = {
                message = { name = 'message', help = 'Mensaje a enviar' }
            },
        },
    },
}

if GetConvar('qb_locale', 'en') == 'es' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
