-- STREAMFLIX - Normalization demo (1NF -> 3NF)
-- Shows how one flat, redundant table is split into a clean 3NF design.
-- Run in MySQL Workbench (all at once), or in db-fiddle:
--   put the CREATE/INSERT parts in "Schema SQL", the SELECTs in "Query SQL".

-- ============ BEFORE: one un-normalized table ============
-- Problems: genres holds many values (breaks 1NF); country, plan price and
-- user name repeat on every row (redundancy -> update/insert/delete anomalies).
DROP TABLE IF EXISTS nf_flat;
CREATE TABLE nf_flat (
    user_email   VARCHAR(120),
    user_name    VARCHAR(50),
    country_name VARCHAR(60),
    plan_name    VARCHAR(30),
    plan_price   DECIMAL(6,2),
    title        VARCHAR(100),
    genres       VARCHAR(100),   -- multi-valued => not 1NF
    rating       INT
);

INSERT INTO nf_flat VALUES
('ayse@mail.com','Ayse','Turkey','Premium',19.99,'Inception','Action, Sci-Fi',9),
('ayse@mail.com','Ayse','Turkey','Premium',19.99,'The Matrix','Action, Sci-Fi',8),
('ayse@mail.com','Ayse','Turkey','Premium',19.99,'Parasite','Drama, Thriller',10),
('john@mail.com','John','United States','Standard',13.99,'Inception','Action, Sci-Fi',9),
('john@mail.com','John','United States','Standard',13.99,'Dark','Sci-Fi, Mystery',8);

-- Look at the repetition: 'Turkey', 'Premium', 19.99 repeat on every Ayse row.
SELECT * FROM nf_flat;

-- ============ AFTER: 3NF (each fact stored once) ============
DROP TABLE IF EXISTS nf_rating;
DROP TABLE IF EXISTS nf_title_genre;
DROP TABLE IF EXISTS nf_title;
DROP TABLE IF EXISTS nf_user;
DROP TABLE IF EXISTS nf_plan;
DROP TABLE IF EXISTS nf_country;

CREATE TABLE nf_country (country_code CHAR(2) PRIMARY KEY, country_name VARCHAR(60));
CREATE TABLE nf_plan    (plan_name VARCHAR(30) PRIMARY KEY, plan_price DECIMAL(6,2));
CREATE TABLE nf_user (
    email VARCHAR(120) PRIMARY KEY,
    user_name VARCHAR(50),
    country_code CHAR(2),
    plan_name VARCHAR(30),
    FOREIGN KEY (country_code) REFERENCES nf_country(country_code),
    FOREIGN KEY (plan_name)    REFERENCES nf_plan(plan_name)
);
CREATE TABLE nf_title (title_id INT PRIMARY KEY, title VARCHAR(100));
CREATE TABLE nf_title_genre (          -- 1NF: one genre per row
    title_id INT,
    genre VARCHAR(40),
    PRIMARY KEY (title_id, genre),
    FOREIGN KEY (title_id) REFERENCES nf_title(title_id)
);
CREATE TABLE nf_rating (
    email VARCHAR(120),
    title_id INT,
    rating INT,
    PRIMARY KEY (email, title_id),
    FOREIGN KEY (email)    REFERENCES nf_user(email),
    FOREIGN KEY (title_id) REFERENCES nf_title(title_id)
);

INSERT INTO nf_country VALUES ('TR','Turkey'),('US','United States');
INSERT INTO nf_plan    VALUES ('Premium',19.99),('Standard',13.99);
INSERT INTO nf_user    VALUES ('ayse@mail.com','Ayse','TR','Premium'),
                              ('john@mail.com','John','US','Standard');
INSERT INTO nf_title   VALUES (1,'Inception'),(2,'The Matrix'),(3,'Parasite'),(4,'Dark');
INSERT INTO nf_title_genre VALUES (1,'Action'),(1,'Sci-Fi'),(2,'Action'),(2,'Sci-Fi'),
                                  (3,'Drama'),(3,'Thriller'),(4,'Sci-Fi'),(4,'Mystery');
INSERT INTO nf_rating  VALUES ('ayse@mail.com',1,9),('ayse@mail.com',2,8),
                              ('ayse@mail.com',3,10),('john@mail.com',1,9),('john@mail.com',4,8);

-- Each fact stored once: price only in nf_plan, country only in nf_country.
SELECT * FROM nf_plan;
SELECT * FROM nf_country;

-- The original wide view is rebuilt with a JOIN whenever needed:
SELECT u.email, u.user_name, c.country_name, p.plan_name, p.plan_price, t.title, r.rating
FROM nf_rating r
JOIN nf_user u    ON r.email = u.email
JOIN nf_country c ON u.country_code = c.country_code
JOIN nf_plan p    ON u.plan_name = p.plan_name
JOIN nf_title t   ON r.title_id = t.title_id
ORDER BY u.user_name, t.title;
