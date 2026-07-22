CREATE DATABASE IF NOT EXISTS node7_core
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE node7_core;

CREATE TABLE IF NOT EXISTS node7_users (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    license VARCHAR(80) NOT NULL,
    fivem VARCHAR(80) NULL,
    discord VARCHAR(80) NULL,
    steam VARCHAR(80) NULL,
    player_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_seen TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_node7_users_license (license),
    KEY idx_node7_users_fivem (fivem),
    KEY idx_node7_users_discord (discord)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS node7_characters (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id BIGINT UNSIGNED NOT NULL,
    first_name VARCHAR(32) NOT NULL,
    last_name VARCHAR(32) NOT NULL,
    date_of_birth VARCHAR(20) NOT NULL,
    sex VARCHAR(16) NOT NULL,
    nationality VARCHAR(32) NOT NULL,
    biography VARCHAR(500) NOT NULL DEFAULT '',
    cash INT UNSIGNED NOT NULL DEFAULT 25,
    bank INT UNSIGNED NOT NULL DEFAULT 100,
    gold INT UNSIGNED NOT NULL DEFAULT 0,
    job VARCHAR(50) NOT NULL DEFAULT 'unemployed',
    job_grade INT UNSIGNED NOT NULL DEFAULT 0,
    gang VARCHAR(50) NOT NULL DEFAULT 'none',
    gang_grade INT UNSIGNED NOT NULL DEFAULT 0,
    health SMALLINT UNSIGNED NOT NULL DEFAULT 200,
    stamina SMALLINT UNSIGNED NOT NULL DEFAULT 100,
    metadata LONGTEXT NOT NULL,
    position LONGTEXT NOT NULL,
    appearance LONGTEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    PRIMARY KEY (id),
    KEY idx_node7_characters_user (user_id),
    CONSTRAINT fk_node7_characters_user FOREIGN KEY (user_id) REFERENCES node7_users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS node7_inventories (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    owner_type VARCHAR(32) NOT NULL,
    owner_id VARCHAR(80) NOT NULL,
    name VARCHAR(50) NOT NULL DEFAULT 'main',
    max_slots SMALLINT UNSIGNED NOT NULL DEFAULT 40,
    max_weight INT UNSIGNED NOT NULL DEFAULT 30000,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_node7_inventory_owner (owner_type, owner_id, name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS node7_inventory_items (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    inventory_id BIGINT UNSIGNED NOT NULL,
    slot SMALLINT UNSIGNED NOT NULL,
    item_name VARCHAR(80) NOT NULL,
    amount INT UNSIGNED NOT NULL DEFAULT 1,
    metadata LONGTEXT NOT NULL,
    durability DECIMAL(6,2) NOT NULL DEFAULT 100.00,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_node7_inventory_slot (inventory_id, slot),
    KEY idx_node7_inventory_item (inventory_id, item_name),
    CONSTRAINT fk_node7_inventory_items_inventory FOREIGN KEY (inventory_id) REFERENCES node7_inventories(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS node7_weapons (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    character_id BIGINT UNSIGNED NOT NULL,
    weapon_name VARCHAR(80) NOT NULL,
    serial VARCHAR(40) NOT NULL,
    ammo_type VARCHAR(80) NULL,
    ammo INT UNSIGNED NOT NULL DEFAULT 0,
    condition_value DECIMAL(6,2) NOT NULL DEFAULT 100.00,
    metadata LONGTEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_node7_weapon_serial (serial),
    KEY idx_node7_weapons_character (character_id),
    CONSTRAINT fk_node7_weapons_character FOREIGN KEY (character_id) REFERENCES node7_characters(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS node7_horses (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    character_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(32) NOT NULL,
    model VARCHAR(64) NOT NULL,
    breed VARCHAR(64) NOT NULL,
    gender VARCHAR(16) NOT NULL DEFAULT 'unknown',
    health DECIMAL(7,2) NOT NULL DEFAULT 100.00,
    stamina DECIMAL(7,2) NOT NULL DEFAULT 100.00,
    bonding INT UNSIGNED NOT NULL DEFAULT 0,
    active TINYINT(1) NOT NULL DEFAULT 0,
    tack LONGTEXT NOT NULL,
    metadata LONGTEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_node7_horses_character (character_id),
    CONSTRAINT fk_node7_horses_character FOREIGN KEY (character_id) REFERENCES node7_characters(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS node7_wagons (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    character_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(32) NOT NULL,
    model VARCHAR(64) NOT NULL,
    livery INT NOT NULL DEFAULT 0,
    condition_value DECIMAL(7,2) NOT NULL DEFAULT 100.00,
    active TINYINT(1) NOT NULL DEFAULT 0,
    metadata LONGTEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_node7_wagons_character (character_id),
    CONSTRAINT fk_node7_wagons_character FOREIGN KEY (character_id) REFERENCES node7_characters(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS node7_organization_accounts (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    organization_type ENUM('job', 'gang') NOT NULL,
    organization_name VARCHAR(50) NOT NULL,
    balance BIGINT UNSIGNED NOT NULL DEFAULT 0,
    metadata LONGTEXT NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_node7_organization_account (organization_type, organization_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS node7_transactions (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    character_id BIGINT UNSIGNED NOT NULL,
    account VARCHAR(20) NOT NULL,
    amount BIGINT NOT NULL,
    reason VARCHAR(100) NOT NULL,
    balance_after BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_node7_transactions_character (character_id),
    CONSTRAINT fk_node7_transactions_character FOREIGN KEY (character_id) REFERENCES node7_characters(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS node7_audit_logs (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    actor_identifier VARCHAR(100) NOT NULL,
    action VARCHAR(80) NOT NULL,
    target VARCHAR(100) NOT NULL DEFAULT '',
    data LONGTEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_node7_audit_action (action),
    KEY idx_node7_audit_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
