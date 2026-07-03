-- ============================================================
-- N5 ID - Esquema inicial MVP
-- Compatible con MariaDB 11.4 / MySQL 8
-- Base objetivo: base de datos N5 ID
-- Fecha: 2026-07-02
-- ============================================================

SET NAMES utf8mb4;
SET time_zone = '+00:00';
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE IF NOT EXISTS n5_types (
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    slug VARCHAR(40) NOT NULL,
    name VARCHAR(100) NOT NULL,
    data_module VARCHAR(40) NOT NULL,
    public_template VARCHAR(80) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_n5_types_slug (slug),
    KEY idx_n5_types_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS n5_owners (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    full_name VARCHAR(160) NOT NULL,
    email VARCHAR(190) NULL,
    phone VARCHAR(30) NULL,
    whatsapp VARCHAR(30) NULL,
    city VARCHAR(120) NULL,
    notes TEXT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_n5_owners_email (email),
    KEY idx_n5_owners_phone (phone),
    KEY idx_n5_owners_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS n5_profiles (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    owner_id BIGINT UNSIGNED NULL,
    type_id SMALLINT UNSIGNED NOT NULL,
    public_name VARCHAR(160) NOT NULL,
    public_title VARCHAR(160) NULL,
    public_message TEXT NULL,
    photo_path VARCHAR(500) NULL,
    primary_phone VARCHAR(30) NULL,
    secondary_phone VARCHAR(30) NULL,
    whatsapp_phone VARCHAR(30) NULL,
    city VARCHAR(120) NULL,
    lost_mode TINYINT(1) NOT NULL DEFAULT 0,
    reward_text VARCHAR(255) NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'draft',
    published_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_n5_profiles_owner FOREIGN KEY (owner_id) REFERENCES n5_owners(id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_n5_profiles_type FOREIGN KEY (type_id) REFERENCES n5_types(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    KEY idx_n5_profiles_owner (owner_id),
    KEY idx_n5_profiles_type (type_id),
    KEY idx_n5_profiles_status (status),
    KEY idx_n5_profiles_lost_mode (lost_mode),
    KEY idx_n5_profiles_public_name (public_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS n5_products (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    type_id SMALLINT UNSIGNED NOT NULL,
    sku VARCHAR(80) NOT NULL,
    name VARCHAR(160) NOT NULL,
    material VARCHAR(100) NULL,
    shape VARCHAR(100) NULL,
    color VARCHAR(100) NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_n5_products_sku (sku),
    CONSTRAINT fk_n5_products_type FOREIGN KEY (type_id) REFERENCES n5_types(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    KEY idx_n5_products_type (type_id),
    KEY idx_n5_products_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS n5_tags (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    public_code VARCHAR(24) NOT NULL,
    profile_id BIGINT UNSIGNED NULL,
    product_id BIGINT UNSIGNED NULL,
    serial_number VARCHAR(100) NULL,
    environment VARCHAR(20) NOT NULL DEFAULT 'production',
    status VARCHAR(20) NOT NULL DEFAULT 'available',
    activated_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_n5_tags_public_code (public_code),
    UNIQUE KEY uq_n5_tags_serial_number (serial_number),
    CONSTRAINT fk_n5_tags_profile FOREIGN KEY (profile_id) REFERENCES n5_profiles(id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_n5_tags_product FOREIGN KEY (product_id) REFERENCES n5_products(id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    KEY idx_n5_tags_profile (profile_id),
    KEY idx_n5_tags_product (product_id),
    KEY idx_n5_tags_status (status),
    KEY idx_n5_tags_environment (environment)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS n5_pet_data (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    profile_id BIGINT UNSIGNED NOT NULL,
    species VARCHAR(80) NULL,
    breed VARCHAR(120) NULL,
    sex VARCHAR(30) NULL,
    birth_date DATE NULL,
    age_text VARCHAR(60) NULL,
    color VARCHAR(120) NULL,
    size VARCHAR(40) NULL,
    sterilized TINYINT(1) NULL,
    medical_conditions TEXT NULL,
    allergies TEXT NULL,
    medications TEXT NULL,
    veterinarian_name VARCHAR(160) NULL,
    veterinarian_phone VARCHAR(30) NULL,
    special_instructions TEXT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_n5_pet_data_profile (profile_id),
    CONSTRAINT fk_n5_pet_data_profile FOREIGN KEY (profile_id) REFERENCES n5_profiles(id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS n5_emergency_data (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    profile_id BIGINT UNSIGNED NOT NULL,
    birth_date DATE NULL,
    blood_type VARCHAR(10) NULL,
    allergies TEXT NULL,
    medical_conditions TEXT NULL,
    medications TEXT NULL,
    emergency_contact_name VARCHAR(160) NULL,
    emergency_contact_phone VARCHAR(30) NULL,
    emergency_contact_relationship VARCHAR(80) NULL,
    insurance_provider VARCHAR(160) NULL,
    policy_number VARCHAR(100) NULL,
    emergency_instructions TEXT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_n5_emergency_data_profile (profile_id),
    CONSTRAINT fk_n5_emergency_data_profile FOREIGN KEY (profile_id) REFERENCES n5_profiles(id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS n5_object_data (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    profile_id BIGINT UNSIGNED NOT NULL,
    category VARCHAR(100) NULL,
    brand VARCHAR(120) NULL,
    model VARCHAR(120) NULL,
    color VARCHAR(120) NULL,
    serial_number VARCHAR(150) NULL,
    description TEXT NULL,
    return_instructions TEXT NULL,
    reward_text VARCHAR(255) NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_n5_object_data_profile (profile_id),
    CONSTRAINT fk_n5_object_data_profile FOREIGN KEY (profile_id) REFERENCES n5_profiles(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    KEY idx_n5_object_data_serial (serial_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS n5_vehicle_data (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    profile_id BIGINT UNSIGNED NOT NULL,
    vehicle_type VARCHAR(80) NULL,
    brand VARCHAR(120) NULL,
    model VARCHAR(120) NULL,
    color VARCHAR(120) NULL,
    serial_number VARCHAR(150) NULL,
    identification_number VARCHAR(150) NULL,
    description TEXT NULL,
    owner_notes TEXT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_n5_vehicle_data_profile (profile_id),
    CONSTRAINT fk_n5_vehicle_data_profile FOREIGN KEY (profile_id) REFERENCES n5_profiles(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    KEY idx_n5_vehicle_data_serial (serial_number),
    KEY idx_n5_vehicle_data_identification (identification_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS n5_edit_tokens (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    profile_id BIGINT UNSIGNED NOT NULL,
    token_hash CHAR(64) NOT NULL,
    token_hint VARCHAR(16) NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    expires_at DATETIME NULL,
    last_used_at DATETIME NULL,
    revoked_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_n5_edit_tokens_hash (token_hash),
    CONSTRAINT fk_n5_edit_tokens_profile FOREIGN KEY (profile_id) REFERENCES n5_profiles(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    KEY idx_n5_edit_tokens_profile (profile_id),
    KEY idx_n5_edit_tokens_status (status),
    KEY idx_n5_edit_tokens_expires (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS n5_admin_users (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    full_name VARCHAR(160) NOT NULL,
    email VARCHAR(190) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(40) NOT NULL DEFAULT 'admin',
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    last_login_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_n5_admin_users_email (email),
    KEY idx_n5_admin_users_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS n5_orders (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_number VARCHAR(40) NOT NULL,
    owner_id BIGINT UNSIGNED NULL,
    sales_channel VARCHAR(40) NOT NULL DEFAULT 'whatsapp',
    status VARCHAR(30) NOT NULL DEFAULT 'pending',
    currency CHAR(3) NOT NULL DEFAULT 'MXN',
    subtotal DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    total DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    notes TEXT NULL,
    ordered_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    paid_at DATETIME NULL,
    completed_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_n5_orders_number (order_number),
    CONSTRAINT fk_n5_orders_owner FOREIGN KEY (owner_id) REFERENCES n5_owners(id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    KEY idx_n5_orders_owner (owner_id),
    KEY idx_n5_orders_status (status),
    KEY idx_n5_orders_channel (sales_channel)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS n5_order_items (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NULL,
    profile_id BIGINT UNSIGNED NULL,
    tag_id BIGINT UNSIGNED NULL,
    quantity INT UNSIGNED NOT NULL DEFAULT 1,
    unit_price DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    line_total DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    personalization_notes TEXT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_n5_order_items_order FOREIGN KEY (order_id) REFERENCES n5_orders(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_n5_order_items_product FOREIGN KEY (product_id) REFERENCES n5_products(id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_n5_order_items_profile FOREIGN KEY (profile_id) REFERENCES n5_profiles(id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_n5_order_items_tag FOREIGN KEY (tag_id) REFERENCES n5_tags(id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    KEY idx_n5_order_items_order (order_id),
    KEY idx_n5_order_items_product (product_id),
    KEY idx_n5_order_items_profile (profile_id),
    KEY idx_n5_order_items_tag (tag_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS n5_scan_events (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    tag_id BIGINT UNSIGNED NOT NULL,
    profile_id BIGINT UNSIGNED NOT NULL,
    event_type VARCHAR(40) NOT NULL DEFAULT 'profile_view',
    ip_hash CHAR(64) NULL,
    user_agent VARCHAR(500) NULL,
    referrer VARCHAR(500) NULL,
    country_code CHAR(2) NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_n5_scan_events_tag FOREIGN KEY (tag_id) REFERENCES n5_tags(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_n5_scan_events_profile FOREIGN KEY (profile_id) REFERENCES n5_profiles(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    KEY idx_n5_scan_events_tag_created (tag_id, created_at),
    KEY idx_n5_scan_events_profile_created (profile_id, created_at),
    KEY idx_n5_scan_events_type_created (event_type, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS n5_change_log (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    actor_type VARCHAR(30) NOT NULL,
    actor_id BIGINT UNSIGNED NULL,
    action VARCHAR(80) NOT NULL,
    entity_type VARCHAR(80) NOT NULL,
    entity_id BIGINT UNSIGNED NULL,
    details LONGTEXT NULL,
    ip_hash CHAR(64) NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_n5_change_log_entity (entity_type, entity_id),
    KEY idx_n5_change_log_actor (actor_type, actor_id),
    KEY idx_n5_change_log_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO n5_types (id, slug, name, data_module, public_template, status)
VALUES
    (1, 'pet',      'N5 PET',      'pet',       'pet',      'active'),
    (2, 'biker',    'N5 Biker',    'emergency', 'biker',    'active'),
    (3, 'runner',   'N5 Runner',   'emergency', 'runner',   'active'),
    (4, 'kids',     'N5 Kids',     'emergency', 'kids',     'active'),
    (5, 'senior',   'N5 Senior',   'emergency', 'senior',   'active'),
    (6, 'bag',      'N5 Bag',      'object',    'bag',      'active'),
    (7, 'luggage',  'N5 Luggage',  'object',    'luggage',  'active'),
    (8, 'bike',     'N5 Bike',     'vehicle',   'bike',     'active'),
    (9, 'moto',     'N5 Moto',     'vehicle',   'moto',     'active')
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    data_module = VALUES(data_module),
    public_template = VALUES(public_template),
    status = VALUES(status);

SET FOREIGN_KEY_CHECKS = 1;
