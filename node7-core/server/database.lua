local function columnExists(database, tableName, columnName)
    local rows = MySQL.query.await('SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = ? AND TABLE_NAME = ? AND COLUMN_NAME = ?', {
        database,
        tableName,
        columnName
    })
    return rows and rows[1] ~= nil
end

local function ensureColumn(database, tableName, columnName, ddl)
    if not columnExists(database, tableName, columnName) then
        MySQL.query.await(('ALTER TABLE `%s` ADD COLUMN %s'):format(tableName, ddl))
    end
end

MySQL.ready(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `players` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `citizenid` varchar(50) NOT NULL,
            `cid` int(11) DEFAULT 1,
            `slot` int(11) DEFAULT 1,
            `license` varchar(255) NOT NULL,
            `name` varchar(255) NOT NULL,
            `money` longtext NOT NULL,
            `charinfo` longtext NOT NULL,
            `job` longtext NOT NULL,
            `gang` longtext NOT NULL,
            `position` longtext NOT NULL,
            `metadata` longtext NOT NULL,
            `inventory` longtext NULL,
            `appearance` longtext NULL,
            `weapons` longtext NULL,
            `horses` longtext NULL,
            `wagons` longtext NULL,
            `health` smallint unsigned NOT NULL DEFAULT 600,
            `stamina` smallint unsigned NOT NULL DEFAULT 100,
            `weight` int(11) DEFAULT 35000,
            `slots` int(11) DEFAULT 25,
            `last_played` timestamp NULL DEFAULT NULL,
            `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
            `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
            PRIMARY KEY (`id`),
            UNIQUE KEY `players_citizenid_unique` (`citizenid`),
            KEY `players_license_index` (`license`),
            KEY `players_license_slot_index` (`license`, `slot`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])

    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `bans` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `name` varchar(50) DEFAULT NULL,
            `license` varchar(50) DEFAULT NULL,
            `discord` varchar(50) DEFAULT NULL,
            `ip` varchar(50) DEFAULT NULL,
            `reason` text DEFAULT NULL,
            `expire` int(11) DEFAULT NULL,
            `bannedby` varchar(255) DEFAULT NULL,
            PRIMARY KEY (`id`),
            KEY `license` (`license`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])

    local db = Node7Core.Functions.GetDatabaseInfo()
    if db and db.database then
        ensureColumn(db.database, 'players', 'cid', '`cid` int(11) DEFAULT 1')
        ensureColumn(db.database, 'players', 'slot', '`slot` int(11) DEFAULT 1')
        ensureColumn(db.database, 'players', 'weight', '`weight` int(11) DEFAULT 35000')
        ensureColumn(db.database, 'players', 'slots', '`slots` int(11) DEFAULT 25')
        ensureColumn(db.database, 'players', 'inventory', '`inventory` longtext NULL')
        ensureColumn(db.database, 'players', 'appearance', '`appearance` longtext NULL')
        ensureColumn(db.database, 'players', 'weapons', '`weapons` longtext NULL')
        ensureColumn(db.database, 'players', 'horses', '`horses` longtext NULL')
        ensureColumn(db.database, 'players', 'wagons', '`wagons` longtext NULL')
        ensureColumn(db.database, 'players', 'health', '`health` smallint unsigned NOT NULL DEFAULT 600')
        ensureColumn(db.database, 'players', 'stamina', '`stamina` smallint unsigned NOT NULL DEFAULT 100')
        ensureColumn(db.database, 'players', 'last_played', '`last_played` timestamp NULL DEFAULT NULL')
    end

    print('^2[node7-core]^7 Database ready')
end)
