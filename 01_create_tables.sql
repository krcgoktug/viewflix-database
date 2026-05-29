-- STREAMFLIX - movie & series streaming platform
-- Schema (tables, keys, constraints) - MySQL 8.0+

DROP DATABASE IF EXISTS streamflix;
CREATE DATABASE streamflix CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE streamflix;

-- Lookup: countries
CREATE TABLE countries (
    country_id   INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(60) NOT NULL UNIQUE,
    country_code CHAR(2)     NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Lookup: languages
CREATE TABLE languages (
    language_id   INT AUTO_INCREMENT PRIMARY KEY,
    language_name VARCHAR(40) NOT NULL UNIQUE,
    language_code CHAR(2)     NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Accounts
CREATE TABLE users (
    user_id        INT AUTO_INCREMENT PRIMARY KEY,
    email          VARCHAR(120) NOT NULL UNIQUE,
    password_hash  VARCHAR(255) NOT NULL,
    first_name     VARCHAR(50)  NOT NULL,
    last_name      VARCHAR(50)  NOT NULL,
    birth_date     DATE,
    country_id     INT,
    phone          VARCHAR(20),
    created_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    account_status VARCHAR(15)  NOT NULL DEFAULT 'Active',
    CONSTRAINT fk_users_country  FOREIGN KEY (country_id) REFERENCES countries(country_id),
    CONSTRAINT chk_users_status  CHECK (account_status IN ('Active','Suspended','Cancelled'))
) ENGINE=InnoDB;

-- Multiple profiles per account
CREATE TABLE profiles (
    profile_id            INT AUTO_INCREMENT PRIMARY KEY,
    user_id               INT NOT NULL,
    profile_name          VARCHAR(40) NOT NULL,
    is_kids               BOOLEAN NOT NULL DEFAULT FALSE,
    preferred_language_id INT,
    created_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_profiles_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_profiles_lang FOREIGN KEY (preferred_language_id) REFERENCES languages(language_id)
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

CREATE TABLE subscriptions (
    subscription_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT NOT NULL,
    plan_id         INT NOT NULL,
    start_date      DATE NOT NULL,
    end_date        DATE,
    status          VARCHAR(15) NOT NULL DEFAULT 'Active',
    auto_renew      BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_sub_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_sub_plan FOREIGN KEY (plan_id) REFERENCES subscription_plans(plan_id),
    CONSTRAINT chk_sub_status CHECK (status IN ('Active','Expired','Cancelled')),
    CONSTRAINT chk_sub_dates  CHECK (end_date IS NULL OR end_date >= start_date)
) ENGINE=InnoDB;

CREATE TABLE payments (
    payment_id      INT AUTO_INCREMENT PRIMARY KEY,
    subscription_id INT NOT NULL,
    amount          DECIMAL(6,2) NOT NULL,
    payment_date    DATETIME NOT NULL,
    payment_method  VARCHAR(20) NOT NULL,
    payment_status  VARCHAR(15) NOT NULL DEFAULT 'Success',
    CONSTRAINT fk_pay_sub FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id) ON DELETE CASCADE,
    CONSTRAINT chk_pay_amount CHECK (amount >= 0),
    CONSTRAINT chk_pay_method CHECK (payment_method IN ('CreditCard','PayPal','GiftCard')),
    CONSTRAINT chk_pay_status CHECK (payment_status IN ('Success','Failed','Refunded'))
) ENGINE=InnoDB;

-- Shared parent for movies and series
CREATE TABLE content (
    content_id           INT AUTO_INCREMENT PRIMARY KEY,
    title                VARCHAR(150) NOT NULL,
    content_type         VARCHAR(10) NOT NULL,
    release_year         INT,
    description          TEXT,
    maturity_rating      VARCHAR(6),
    original_language_id INT,
    imdb_rating          DECIMAL(3,1),
    added_date           DATE NOT NULL,
    CONSTRAINT fk_content_lang FOREIGN KEY (original_language_id) REFERENCES languages(language_id),
    CONSTRAINT chk_content_type CHECK (content_type IN ('Movie','Series')),
    CONSTRAINT chk_content_year CHECK (release_year BETWEEN 1900 AND 2100),
    CONSTRAINT chk_content_imdb CHECK (imdb_rating BETWEEN 0 AND 10),
    CONSTRAINT chk_content_mat  CHECK (maturity_rating IN ('G','PG','PG-13','R','TV-PG','TV-14','TV-MA'))
) ENGINE=InnoDB;

-- Movie subtype (1:1 with content)
CREATE TABLE movies (
    content_id       INT PRIMARY KEY,
    duration_minutes INT NOT NULL,
    CONSTRAINT fk_movies_content FOREIGN KEY (content_id) REFERENCES content(content_id) ON DELETE CASCADE,
    CONSTRAINT chk_movie_duration CHECK (duration_minutes > 0)
) ENGINE=InnoDB;

-- Series subtype (1:1 with content)
CREATE TABLE series (
    content_id    INT PRIMARY KEY,
    series_status VARCHAR(10) NOT NULL,
    CONSTRAINT fk_series_content FOREIGN KEY (content_id) REFERENCES content(content_id) ON DELETE CASCADE,
    CONSTRAINT chk_series_status CHECK (series_status IN ('Ongoing','Ended'))
) ENGINE=InnoDB;

CREATE TABLE seasons (
    season_id     INT AUTO_INCREMENT PRIMARY KEY,
    content_id    INT NOT NULL,
    season_number INT NOT NULL,
    release_year  INT,
    CONSTRAINT fk_seasons_series FOREIGN KEY (content_id) REFERENCES series(content_id) ON DELETE CASCADE,
    CONSTRAINT uq_season UNIQUE (content_id, season_number),
    CONSTRAINT chk_season_no CHECK (season_number > 0)
) ENGINE=InnoDB;

CREATE TABLE episodes (
    episode_id       INT AUTO_INCREMENT PRIMARY KEY,
    season_id        INT NOT NULL,
    episode_number   INT NOT NULL,
    title            VARCHAR(150) NOT NULL,
    duration_minutes INT NOT NULL,
    CONSTRAINT fk_episodes_season FOREIGN KEY (season_id) REFERENCES seasons(season_id) ON DELETE CASCADE,
    CONSTRAINT uq_episode UNIQUE (season_id, episode_number),
    CONSTRAINT chk_ep_duration CHECK (duration_minutes > 0)
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
    person_id              INT AUTO_INCREMENT PRIMARY KEY,
    full_name              VARCHAR(100) NOT NULL,
    birth_date             DATE,
    nationality_country_id INT,
    CONSTRAINT fk_people_country FOREIGN KEY (nationality_country_id) REFERENCES countries(country_id)
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

CREATE TABLE watchlist (
    profile_id INT NOT NULL,
    content_id INT NOT NULL,
    added_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (profile_id, content_id),
    CONSTRAINT fk_wl_profile FOREIGN KEY (profile_id) REFERENCES profiles(profile_id) ON DELETE CASCADE,
    CONSTRAINT fk_wl_content FOREIGN KEY (content_id) REFERENCES content(content_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE favorites (
    profile_id INT NOT NULL,
    content_id INT NOT NULL,
    added_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (profile_id, content_id),
    CONSTRAINT fk_fav_profile FOREIGN KEY (profile_id) REFERENCES profiles(profile_id) ON DELETE CASCADE,
    CONSTRAINT fk_fav_content FOREIGN KEY (content_id) REFERENCES content(content_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE watch_history (
    history_id       INT AUTO_INCREMENT PRIMARY KEY,
    profile_id       INT NOT NULL,
    content_id       INT NOT NULL,
    episode_id       INT,
    watched_at       DATETIME NOT NULL,
    progress_percent INT NOT NULL DEFAULT 0,
    is_completed     BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_wh_profile FOREIGN KEY (profile_id) REFERENCES profiles(profile_id) ON DELETE CASCADE,
    CONSTRAINT fk_wh_content FOREIGN KEY (content_id) REFERENCES content(content_id) ON DELETE CASCADE,
    CONSTRAINT fk_wh_episode FOREIGN KEY (episode_id) REFERENCES episodes(episode_id) ON DELETE SET NULL,
    CONSTRAINT chk_wh_progress CHECK (progress_percent BETWEEN 0 AND 100)
) ENGINE=InnoDB;

-- One review per profile per content
CREATE TABLE reviews (
    review_id   INT AUTO_INCREMENT PRIMARY KEY,
    profile_id  INT NOT NULL,
    content_id  INT NOT NULL,
    rating      INT NOT NULL,
    comment     TEXT,
    review_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_rev_profile FOREIGN KEY (profile_id) REFERENCES profiles(profile_id) ON DELETE CASCADE,
    CONSTRAINT fk_rev_content FOREIGN KEY (content_id) REFERENCES content(content_id) ON DELETE CASCADE,
    CONSTRAINT uq_review UNIQUE (profile_id, content_id),
    CONSTRAINT chk_rev_rating CHECK (rating BETWEEN 1 AND 10)
) ENGINE=InnoDB;

CREATE TABLE devices (
    device_id   INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT NOT NULL,
    device_type VARCHAR(20) NOT NULL,
    device_name VARCHAR(60),
    last_login  DATETIME,
    CONSTRAINT fk_dev_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT chk_dev_type CHECK (device_type IN ('TV','Phone','Tablet','Laptop','Desktop'))
) ENGINE=InnoDB;

-- Available subtitle languages per content
CREATE TABLE subtitles (
    subtitle_id INT AUTO_INCREMENT PRIMARY KEY,
    content_id  INT NOT NULL,
    language_id INT NOT NULL,
    CONSTRAINT fk_sub_content  FOREIGN KEY (content_id)  REFERENCES content(content_id) ON DELETE CASCADE,
    CONSTRAINT fk_sub_language FOREIGN KEY (language_id) REFERENCES languages(language_id),
    CONSTRAINT uq_subtitle UNIQUE (content_id, language_id)
) ENGINE=InnoDB;
