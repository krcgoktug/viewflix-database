-- STREAMFLIX - combined SQL for online tools (db-fiddle.com, sqliteonline.com)
-- CREATE DATABASE / USE lines removed. Tables first, then data.

-- STREAMFLIX - movie & series streaming platform
-- Schema (11 tables, 3NF) - MySQL 8.0+


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

-- STREAMFLIX - sample data (about 230 rows across 11 tables)
-- Run order: 01_create_tables.sql then this file

-- users (15)
INSERT INTO users (user_id, email, password_hash, first_name, last_name, birth_date, country, phone, created_at, account_status) VALUES
(1,'ayse.yilmaz@mail.com','h1a2b3','Ayse','Yilmaz','1995-04-12','Turkey','+905321112233','2024-01-15 10:20:00','Active'),
(2,'john.smith@mail.com','h4c5d6','John','Smith','1988-09-30','United States','+12025550101','2024-02-01 14:05:00','Active'),
(3,'emma.brown@mail.com','h7e8f9','Emma','Brown','1992-12-05','United Kingdom','+447700900111','2024-02-10 09:00:00','Active'),
(4,'mehmet.demir@mail.com','h1g2h3','Mehmet','Demir','2000-06-22','Turkey','+905339998877','2024-03-03 18:45:00','Active'),
(5,'lukas.muller@mail.com','h4i5j6','Lukas','Muller','1990-03-18','Germany','+4915112345678','2024-03-12 11:30:00','Active'),
(6,'sophie.martin@mail.com','h7k8l9','Sophie','Martin','1997-07-08','France','+33612345678','2024-03-20 16:10:00','Suspended'),
(7,'carlos.garcia@mail.com','h1m2n3','Carlos','Garcia','1985-11-27','Spain','+34612345678','2024-04-01 08:25:00','Active'),
(8,'jiwon.kim@mail.com','h4o5p6','Jiwon','Kim','1998-02-14','South Korea','+821012345678','2024-04-10 20:00:00','Active'),
(9,'yuki.tanaka@mail.com','h7q8r9','Yuki','Tanaka','1993-05-19','Japan','+819012345678','2024-04-18 13:40:00','Active'),
(10,'olivia.wilson@mail.com','h1s2t3','Olivia','Wilson','2001-08-23','Australia','+61412345678','2024-05-02 19:15:00','Active'),
(11,'zeynep.kaya@mail.com','h4u5v6','Zeynep','Kaya','1996-10-11','Turkey','+905345556677','2024-05-09 12:00:00','Active'),
(12,'david.jones@mail.com','h7w8x9','David','Jones','1983-01-29','United States','+12025550199','2024-05-15 07:50:00','Cancelled'),
(13,'laura.dubois@mail.com','h1y2z3','Laura','Dubois','1999-04-04','France','+33687654321','2024-05-20 22:30:00','Active'),
(14,'can.ozturk@mail.com','h4a5b6','Can','Ozturk','1994-09-09','Turkey','+905367778899','2024-05-25 15:20:00','Active'),
(15,'anna.schmidt@mail.com','h7c8d9','Anna','Schmidt','1991-12-31','Germany','+4915198765432','2025-01-05 10:00:00','Active');

-- subscription_plans (3)
INSERT INTO subscription_plans (plan_id, plan_name, monthly_price, max_resolution, max_screens, description) VALUES
(1,'Basic',7.99,'720p',1,'Single screen, HD quality'),
(2,'Standard',13.99,'1080p',2,'Two screens, Full HD quality'),
(3,'Premium',19.99,'4K',4,'Four screens, 4K Ultra HD and HDR');

-- subscriptions (15)
INSERT INTO subscriptions (subscription_id, user_id, plan_id, start_date, end_date, status, payment_status, auto_renew) VALUES
(1,1,3,'2024-01-15',NULL,'Active','Success',TRUE),
(2,2,2,'2024-02-01',NULL,'Active','Success',TRUE),
(3,3,2,'2024-02-10',NULL,'Active','Success',TRUE),
(4,4,1,'2024-03-03',NULL,'Active','Success',TRUE),
(5,5,3,'2024-03-12',NULL,'Active','Success',TRUE),
(6,6,1,'2024-03-20','2024-09-20','Cancelled','Failed',FALSE),
(7,7,2,'2024-04-01',NULL,'Active','Success',TRUE),
(8,8,3,'2024-04-10',NULL,'Active','Success',TRUE),
(9,9,2,'2024-04-18',NULL,'Active','Success',TRUE),
(10,10,1,'2024-05-02',NULL,'Active','Success',TRUE),
(11,11,3,'2024-05-09',NULL,'Active','Success',TRUE),
(12,12,2,'2024-05-15','2025-01-15','Expired','Refunded',FALSE),
(13,13,1,'2024-05-20',NULL,'Active','Success',TRUE),
(14,14,2,'2024-05-25',NULL,'Active','Success',TRUE),
(15,15,3,'2025-01-05',NULL,'Active','Success',TRUE);

-- content (20: 10 movies + 10 series)
INSERT INTO content (content_id, title, content_type, release_year, description, maturity_rating, original_language, duration_minutes, imdb_rating, added_date) VALUES
(1,'Inception','Movie',2010,'A thief steals secrets through dream-sharing.','PG-13','English',148,8.8,'2024-01-01'),
(2,'The Dark Knight','Movie',2008,'Batman faces the Joker in Gotham.','PG-13','English',152,9.0,'2024-01-01'),
(3,'Parasite','Movie',2019,'Class conflict between two families.','R','Korean',132,8.5,'2024-01-05'),
(4,'Amelie','Movie',2001,'A shy Parisian girl quietly changes lives.','R','French',122,8.3,'2024-01-10'),
(5,'Pans Labyrinth','Movie',2006,'A girl escapes into a dark fantasy in wartime Spain.','R','Spanish',118,8.2,'2024-01-12'),
(6,'Spirited Away','Movie',2001,'A girl is trapped in a spirit world.','PG','Japanese',125,8.6,'2024-01-15'),
(7,'The Matrix','Movie',1999,'A hacker learns reality is a simulation.','R','English',136,8.7,'2024-01-20'),
(8,'Interstellar','Movie',2014,'Astronauts travel through a wormhole to save humanity.','PG-13','English',169,8.6,'2024-01-22'),
(9,'Whiplash','Movie',2014,'A young drummer chases greatness under a brutal teacher.','R','English',107,8.5,'2024-02-01'),
(10,'Your Name','Movie',2016,'Two teenagers mysteriously swap bodies.','PG','Japanese',106,8.4,'2024-02-05'),
(11,'Breaking Bad','Series',2008,'A chemistry teacher turns to making drugs.','TV-MA','English',NULL,9.5,'2024-01-02'),
(12,'Stranger Things','Series',2016,'Supernatural events in a small town.','TV-14','English',NULL,8.7,'2024-01-03'),
(13,'Dark','Series',2017,'Time travel and missing children in a German town.','TV-MA','German',NULL,8.7,'2024-01-08'),
(14,'Money Heist','Series',2017,'A crew pulls off a massive heist.','TV-MA','Spanish',NULL,8.2,'2024-01-11'),
(15,'Squid Game','Series',2021,'Players risk their lives in deadly games.','TV-MA','Korean',NULL,8.0,'2024-01-18'),
(16,'The Crown','Series',2016,'The story of the British royal family.','TV-MA','English',NULL,8.6,'2024-02-02'),
(17,'Sherlock','Series',2010,'A genius detective in modern London.','TV-14','English',NULL,9.1,'2024-02-08'),
(18,'Game of Thrones','Series',2011,'Noble houses fight for the throne.','TV-MA','English',NULL,9.2,'2024-02-12'),
(19,'Black Mirror','Series',2011,'The dark side of technology.','TV-MA','English',NULL,8.7,'2024-02-15'),
(20,'The Witcher','Series',2019,'A monster hunter travels a dangerous world.','TV-MA','English',NULL,8.0,'2024-02-20');

-- genres (12)
INSERT INTO genres (genre_id, genre_name) VALUES
(1,'Action'),(2,'Drama'),(3,'Sci-Fi'),(4,'Thriller'),(5,'Crime'),(6,'Comedy'),
(7,'Romance'),(8,'Fantasy'),(9,'Horror'),(10,'Animation'),(11,'Mystery'),(12,'Adventure');

-- content_genres (52)
INSERT INTO content_genres (content_id, genre_id) VALUES
(1,1),(1,3),(1,4),
(2,1),(2,5),(2,4),
(3,2),(3,4),(3,5),
(4,7),(4,6),
(5,8),(5,2),
(6,10),(6,8),(6,12),
(7,1),(7,3),
(8,3),(8,2),(8,12),
(9,2),
(10,7),(10,10),(10,8),
(11,2),(11,5),(11,4),
(12,3),(12,9),(12,11),
(13,3),(13,11),(13,2),
(14,5),(14,4),
(15,4),(15,2),(15,9),
(16,2),
(17,5),(17,11),(17,2),
(18,8),(18,2),(18,1),
(19,3),(19,4),(19,11),
(20,8),(20,1),(20,12);

-- people (20)
INSERT INTO people (person_id, full_name, birth_date, nationality) VALUES
(1,'Christopher Nolan','1970-07-30','United Kingdom'),
(2,'Leonardo DiCaprio','1974-11-11','United States'),
(3,'Christian Bale','1974-01-30','United Kingdom'),
(4,'Heath Ledger','1979-04-04','Australia'),
(5,'Bong Joon-ho','1969-09-14','South Korea'),
(6,'Song Kang-ho','1967-01-17','South Korea'),
(7,'Hayao Miyazaki','1941-01-05','Japan'),
(8,'Keanu Reeves','1964-09-02','Canada'),
(9,'Matthew McConaughey','1969-11-04','United States'),
(10,'Anne Hathaway','1982-11-12','United States'),
(11,'Bryan Cranston','1956-03-07','United States'),
(12,'Aaron Paul','1979-08-27','United States'),
(13,'Vince Gilligan','1967-02-10','United States'),
(14,'Millie Bobby Brown','2004-02-19','United Kingdom'),
(15,'Winona Ryder','1971-10-29','United States'),
(16,'Pedro Alonso','1971-06-21','Spain'),
(17,'Lee Jung-jae','1972-12-15','South Korea'),
(18,'Benedict Cumberbatch','1976-07-19','United Kingdom'),
(19,'Emilia Clarke','1986-10-23','United Kingdom'),
(20,'Henry Cavill','1983-05-05','United Kingdom');

-- content_cast (32)
INSERT INTO content_cast (content_id, person_id, cast_role, character_name) VALUES
(1,1,'Director',NULL),(1,2,'Actor','Dom Cobb'),
(2,1,'Director',NULL),(2,3,'Actor','Bruce Wayne'),(2,4,'Actor','Joker'),
(3,5,'Director',NULL),(3,6,'Actor','Ki-taek'),
(4,2,'Actor','Narrator'),
(5,5,'Writer',NULL),
(6,7,'Director',NULL),
(7,8,'Actor','Neo'),
(8,1,'Director',NULL),(8,9,'Actor','Cooper'),(8,10,'Actor','Brand'),
(9,12,'Actor','Andrew'),
(10,7,'Producer',NULL),
(11,13,'Director',NULL),(11,11,'Actor','Walter White'),(11,12,'Actor','Jesse Pinkman'),
(12,14,'Actor','Eleven'),(12,15,'Actor','Joyce Byers'),
(13,5,'Writer',NULL),
(14,16,'Actor','Berlin'),
(15,17,'Actor','Seong Gi-hun'),
(16,19,'Actor','Queen'),
(17,18,'Actor','Sherlock Holmes'),
(18,19,'Actor','Daenerys'),
(19,18,'Producer',NULL),
(20,20,'Actor','Geralt'),(20,19,'Actor','Yennefer');

-- watch_history (25)
INSERT INTO watch_history (history_id, user_id, content_id, watched_at, progress_percent, is_completed) VALUES
(1,1,11,'2024-02-02 21:00:00',100,TRUE),
(2,1,8,'2024-02-10 20:00:00',100,TRUE),
(3,1,15,'2024-02-12 19:00:00',65,FALSE),
(4,2,2,'2024-02-06 19:00:00',100,TRUE),
(5,2,18,'2024-02-08 22:00:00',40,FALSE),
(6,2,7,'2024-02-09 20:00:00',100,TRUE),
(7,3,13,'2024-02-12 21:00:00',100,TRUE),
(8,3,17,'2024-02-15 20:00:00',80,FALSE),
(9,4,1,'2024-03-06 19:30:00',100,TRUE),
(10,4,12,'2024-03-08 20:30:00',55,FALSE),
(11,5,13,'2024-03-14 21:00:00',100,TRUE),
(12,5,6,'2024-03-16 18:00:00',100,TRUE),
(13,7,3,'2024-04-03 20:00:00',100,TRUE),
(14,7,15,'2024-04-05 19:00:00',70,FALSE),
(15,8,6,'2024-04-12 18:00:00',100,TRUE),
(16,8,10,'2024-04-13 18:00:00',100,TRUE),
(17,9,4,'2024-04-23 17:00:00',100,TRUE),
(18,9,16,'2024-04-24 21:00:00',90,FALSE),
(19,10,3,'2024-05-04 20:00:00',100,TRUE),
(20,11,11,'2024-05-13 22:00:00',100,TRUE),
(21,11,20,'2024-05-14 20:00:00',30,FALSE),
(22,13,10,'2024-05-22 19:00:00',100,TRUE),
(23,14,8,'2024-05-27 21:00:00',100,TRUE),
(24,14,19,'2024-05-28 22:00:00',100,TRUE),
(25,15,14,'2025-01-07 20:00:00',100,TRUE);

-- reviews (20)
INSERT INTO reviews (review_id, user_id, content_id, rating, comment, review_date) VALUES
(1,1,11,10,'Best show ever made.','2024-02-05 22:00:00'),
(2,1,8,9,'Visually stunning, the ending got me.','2024-02-11 21:00:00'),
(3,2,2,10,'Heath Ledger is an unreal Joker.','2024-02-07 20:00:00'),
(4,2,7,8,'Still a great classic.','2024-02-10 19:00:00'),
(5,3,13,9,'Complex but very rewarding.','2024-02-14 21:00:00'),
(6,3,17,10,'Every episode is a puzzle.','2024-02-16 20:00:00'),
(7,4,1,9,'Mind-bending film.','2024-03-07 19:00:00'),
(8,5,6,10,'Miyazaki at his best.','2024-03-17 18:00:00'),
(9,7,3,9,'Did not see that ending coming.','2024-04-04 20:00:00'),
(10,7,15,7,'Good but a bit overhyped.','2024-04-06 19:00:00'),
(11,8,10,9,'Beautiful and emotional.','2024-04-14 18:00:00'),
(12,9,4,8,'Sweet and charming.','2024-04-24 17:00:00'),
(13,10,3,9,'Great twist.','2024-05-05 20:00:00'),
(14,11,11,10,'Walter''s transformation is incredible.','2024-05-15 22:00:00'),
(15,12,8,9,'Science and emotion together.','2024-05-16 21:00:00'),
(16,13,10,9,'So emotional.','2024-05-23 19:00:00'),
(17,14,8,9,'Loved it.','2024-05-29 21:00:00'),
(18,14,19,8,'Some episodes are genius.','2024-05-30 22:00:00'),
(19,15,14,8,'Tension never drops.','2025-01-08 20:00:00'),
(20,2,18,9,'An epic production.','2024-02-12 22:00:00');

-- favorites (16)
INSERT INTO favorites (user_id, content_id, added_date) VALUES
(1,11,'2024-03-01 20:00:00'),(1,2,'2024-03-02 21:00:00'),
(2,18,'2024-03-10 22:00:00'),(2,8,'2024-03-11 20:00:00'),
(3,17,'2024-03-15 19:00:00'),
(4,1,'2024-04-01 18:00:00'),
(5,6,'2024-04-05 17:00:00'),
(7,3,'2024-04-20 20:00:00'),
(8,10,'2024-04-25 18:00:00'),
(9,4,'2024-04-26 17:00:00'),
(11,11,'2024-05-01 21:00:00'),(11,7,'2024-05-02 20:00:00'),
(13,4,'2024-05-25 18:00:00'),
(14,19,'2024-05-30 22:00:00'),
(15,14,'2025-01-09 20:00:00'),(15,15,'2025-01-10 19:00:00');
