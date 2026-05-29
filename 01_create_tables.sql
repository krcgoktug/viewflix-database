-- STREAMFLIX - movie & series streaming platform
-- Schema (11 tables, 3NF) - MySQL 8.0+

DROP DATABASE IF EXISTS streamflix;
CREATE DATABASE streamflix CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE streamflix;

-- Accounts
CREATE TABLE users (
    user_id        INT AUTO_INCREMENT PRIMARY KEY,
    email          VARCHAR(120) NOT NULL UNIQUE,
    password_hash  VARCHAR(255) NOT NULL,
    first_name     VARCHAR(50)  NOT NULL,
    last_name      VARCHAR(50)  NOT NULL,
    birth_date     DATE,
    country        VARCHAR(50),
    phone          VARCHAR(20),
    created_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    account_status VARCHAR(15)  NOT NULL DEFAULT 'Active',
    CONSTRAINT chk_users_status CHECK (account_status IN ('Active','Suspended','Cancelled'))
) ENGINE=InnoDB;

-- Subscription plans
CREATE TABLE subscription_plans (
    plan_id        INT AUTO_INCREMENT PRIMARY KEY,
    plan_name      VARCHAR(30) NOT NULL UNIQUE,
    monthly_price  DECIMAL(6,2) NOT NULL,
    max_resolution VARCHAR(10) NOT NULL,
    max_screens    INT NOT NULL,
    description    VARCHAR(200),
    CONSTRAINT chk_plan_price   CHECK (monthly_price >= 0),
    CONSTRAINT chk_plan_screens CHECK (max_screens BETWEEN 1 AND 10)
) ENGINE=InnoDB;

-- One subscription per user; payment_status kept here
CREATE TABLE subscriptions (
    subscription_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT NOT NULL,
    plan_id         INT NOT NULL,
    start_date      DATE NOT NULL,
    end_date        DATE,
    status          VARCHAR(15) NOT NULL DEFAULT 'Active',
    payment_status  VARCHAR(15) NOT NULL DEFAULT 'Success',
    auto_renew      BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_sub_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_sub_plan FOREIGN KEY (plan_id) REFERENCES subscription_plans(plan_id),
    CONSTRAINT chk_sub_status CHECK (status IN ('Active','Expired','Cancelled')),
    CONSTRAINT chk_sub_pay    CHECK (payment_status IN ('Success','Failed','Refunded')),
    CONSTRAINT chk_sub_dates  CHECK (end_date IS NULL OR end_date >= start_date)
) ENGINE=InnoDB;

-- Movies and series (content_type tells them apart)
CREATE TABLE content (
    content_id        INT AUTO_INCREMENT PRIMARY KEY,
    title             VARCHAR(150) NOT NULL,
    content_type      VARCHAR(10) NOT NULL,
    release_year      INT,
    description       TEXT,
    maturity_rating   VARCHAR(6),
    original_language VARCHAR(30),
    duration_minutes  INT,
    imdb_rating       DECIMAL(3,1),
    added_date        DATE NOT NULL,
    CONSTRAINT chk_content_type CHECK (content_type IN ('Movie','Series')),
    CONSTRAINT chk_content_year CHECK (release_year BETWEEN 1900 AND 2100),
    CONSTRAINT chk_content_imdb CHECK (imdb_rating BETWEEN 0 AND 10),
    CONSTRAINT chk_content_mat  CHECK (maturity_rating IN ('G','PG','PG-13','R','TV-PG','TV-14','TV-MA'))
) ENGINE=InnoDB;

CREATE TABLE genres (
    genre_id   INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(40) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- content <-> genre (many-to-many)
CREATE TABLE content_genres (
    content_id INT NOT NULL,
    genre_id   INT NOT NULL,
    PRIMARY KEY (content_id, genre_id),
    CONSTRAINT fk_cg_content FOREIGN KEY (content_id) REFERENCES content(content_id) ON DELETE CASCADE,
    CONSTRAINT fk_cg_genre   FOREIGN KEY (genre_id)   REFERENCES genres(genre_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE people (
    person_id   INT AUTO_INCREMENT PRIMARY KEY,
    full_name   VARCHAR(100) NOT NULL,
    birth_date  DATE,
    nationality VARCHAR(50)
) ENGINE=InnoDB;

-- content <-> person with role (many-to-many)
CREATE TABLE content_cast (
    content_id     INT NOT NULL,
    person_id      INT NOT NULL,
    cast_role      VARCHAR(15) NOT NULL,
    character_name VARCHAR(80),
    PRIMARY KEY (content_id, person_id, cast_role),
    CONSTRAINT fk_cast_content FOREIGN KEY (content_id) REFERENCES content(content_id) ON DELETE CASCADE,
    CONSTRAINT fk_cast_person  FOREIGN KEY (person_id)  REFERENCES people(person_id) ON DELETE CASCADE,
    CONSTRAINT chk_cast_role   CHECK (cast_role IN ('Actor','Director','Writer','Producer'))
) ENGINE=InnoDB;

CREATE TABLE watch_history (
    history_id       INT AUTO_INCREMENT PRIMARY KEY,
    user_id          INT NOT NULL,
    content_id       INT NOT NULL,
    watched_at       DATETIME NOT NULL,
    progress_percent INT NOT NULL DEFAULT 0,
    is_completed     BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_wh_user    FOREIGN KEY (user_id)    REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_wh_content FOREIGN KEY (content_id) REFERENCES content(content_id) ON DELETE CASCADE,
    CONSTRAINT chk_wh_progress CHECK (progress_percent BETWEEN 0 AND 100)
) ENGINE=InnoDB;

-- One review per user per title
CREATE TABLE reviews (
    review_id   INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT NOT NULL,
    content_id  INT NOT NULL,
    rating      INT NOT NULL,
    comment     TEXT,
    review_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_rev_user    FOREIGN KEY (user_id)    REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_rev_content FOREIGN KEY (content_id) REFERENCES content(content_id) ON DELETE CASCADE,
    CONSTRAINT uq_review UNIQUE (user_id, content_id),
    CONSTRAINT chk_rev_rating CHECK (rating BETWEEN 1 AND 10)
) ENGINE=InnoDB;

CREATE TABLE favorites (
    user_id    INT NOT NULL,
    content_id INT NOT NULL,
    added_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, content_id),
    CONSTRAINT fk_fav_user    FOREIGN KEY (user_id)    REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_fav_content FOREIGN KEY (content_id) REFERENCES content(content_id) ON DELETE CASCADE
) ENGINE=InnoDB;
