Node7Database = {}

local function decode(value, fallback)
    if type(value) == 'table' then return value end
    if not value or value == '' then return fallback end
    local ok, result = pcall(json.decode, value)
    return ok and result or fallback
end

function Node7Database.Decode(value, fallback)
    return decode(value, fallback)
end

function Node7Database.GetOrCreateUser(identifiers, name)
    local user = MySQL.single.await('SELECT * FROM node7_users WHERE license = ? LIMIT 1', { identifiers.license })
    if user then
        MySQL.update.await([[
            UPDATE node7_users
            SET fivem = ?, discord = ?, steam = ?, player_name = ?, last_seen = CURRENT_TIMESTAMP
            WHERE id = ?
        ]], { identifiers.fivem, identifiers.discord, identifiers.steam, name, user.id })
        return user.id
    end

    return MySQL.insert.await([[
        INSERT INTO node7_users (license, fivem, discord, steam, player_name)
        VALUES (?, ?, ?, ?, ?)
    ]], { identifiers.license, identifiers.fivem, identifiers.discord, identifiers.steam, name })
end

function Node7Database.GetCharacters(userId)
    return MySQL.query.await('SELECT * FROM node7_characters WHERE user_id = ? AND deleted_at IS NULL ORDER BY id ASC', { userId }) or {}
end

function Node7Database.GetCharacter(userId, characterId)
    return MySQL.single.await('SELECT * FROM node7_characters WHERE user_id = ? AND id = ? AND deleted_at IS NULL LIMIT 1', { userId, characterId })
end

function Node7Database.CreateCharacter(userId, data)
    return MySQL.insert.await([[
        INSERT INTO node7_characters
            (user_id, first_name, last_name, date_of_birth, sex, nationality, biography,
             cash, bank, gold, job, job_grade, gang, gang_grade, metadata, position, appearance)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'unemployed', 0, 'none', 0, ?, ?, ?)
    ]], {
        userId,
        data.firstName,
        data.lastName,
        data.dateOfBirth,
        data.sex,
        data.nationality,
        data.biography or '',
        Node7Config.StartingMoney.cash,
        Node7Config.StartingMoney.bank,
        Node7Config.StartingMoney.gold,
        json.encode(data.metadata or {}),
        json.encode(data.position or Node7Config.DefaultSpawn),
        json.encode(data.appearance or {})
    })
end

function Node7Database.SaveCharacter(character)
    return MySQL.update.await([[
        UPDATE node7_characters SET
            cash = ?, bank = ?, gold = ?, job = ?, job_grade = ?, gang = ?, gang_grade = ?,
            metadata = ?, position = ?, appearance = ?, health = ?, stamina = ?, updated_at = CURRENT_TIMESTAMP
        WHERE id = ?
    ]], {
        character.money.cash,
        character.money.bank,
        character.money.gold,
        character.job.name,
        character.job.grade,
        character.gang.name,
        character.gang.grade,
        json.encode(character.metadata),
        json.encode(character.position),
        json.encode(character.appearance),
        character.health,
        character.stamina,
        character.id
    })
end

function Node7Database.DeleteCharacter(userId, characterId)
    return MySQL.update.await('UPDATE node7_characters SET deleted_at = CURRENT_TIMESTAMP WHERE user_id = ? AND id = ?', {
        userId, characterId
    })
end

function Node7Database.Audit(actor, action, target, data)
    MySQL.insert.await([[
        INSERT INTO node7_audit_logs (actor_identifier, action, target, data)
        VALUES (?, ?, ?, ?)
    ]], { tostring(actor or 'system'), action, tostring(target or ''), json.encode(data or {}) })
end

function Node7Database.Transaction(characterId, account, amount, reason, balanceAfter)
    MySQL.insert.await([[
        INSERT INTO node7_transactions (character_id, account, amount, reason, balance_after)
        VALUES (?, ?, ?, ?, ?)
    ]], { characterId, account, amount, reason, balanceAfter })
end
