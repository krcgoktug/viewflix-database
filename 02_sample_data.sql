-- STREAMFLIX - sample data (426 rows across 22 tables)
-- Run order: 01_create_tables.sql then this file
USE streamflix;

-- countries (10)
INSERT INTO countries (country_id, country_name, country_code) VALUES
(1,'United States','US'),(2,'United Kingdom','GB'),(3,'Turkey','TR'),
(4,'Canada','CA'),(5,'Germany','DE'),(6,'France','FR'),
(7,'Spain','ES'),(8,'South Korea','KR'),(9,'Japan','JP'),(10,'Australia','AU');

-- languages (8)
INSERT INTO languages (language_id, language_name, language_code) VALUES
(1,'English','en'),(2,'Turkish','tr'),(3,'German','de'),(4,'French','fr'),
(5,'Spanish','es'),(6,'Korean','ko'),(7,'Japanese','ja'),(8,'Italian','it');

-- subscription_plans (3)
INSERT INTO subscription_plans (plan_id, plan_name, monthly_price, max_resolution, max_screens, description) VALUES
(1,'Basic',7.99,'720p',1,'Single screen, HD quality'),
(2,'Standard',13.99,'1080p',2,'Two screens, Full HD quality'),
(3,'Premium',19.99,'4K',4,'Four screens, 4K Ultra HD and HDR');

-- users (15)
INSERT INTO users (user_id, email, password_hash, first_name, last_name, birth_date, country_id, phone, created_at, account_status) VALUES
(1,'ayse.yilmaz@mail.com','h1a2b3','Ayse','Yilmaz','1995-04-12',3,'+905321112233','2024-01-15 10:20:00','Active'),
(2,'john.smith@mail.com','h4c5d6','John','Smith','1988-09-30',1,'+12025550101','2024-02-01 14:05:00','Active'),
(3,'emma.brown@mail.com','h7e8f9','Emma','Brown','1992-12-05',2,'+447700900111','2024-02-10 09:00:00','Active'),
(4,'mehmet.demir@mail.com','h1g2h3','Mehmet','Demir','2000-06-22',3,'+905339998877','2024-03-03 18:45:00','Active'),
(5,'lukas.muller@mail.com','h4i5j6','Lukas','Muller','1990-03-18',5,'+4915112345678','2024-03-12 11:30:00','Active'),
(6,'sophie.martin@mail.com','h7k8l9','Sophie','Martin','1997-07-08',6,'+33612345678','2024-03-20 16:10:00','Suspended'),
(7,'carlos.garcia@mail.com','h1m2n3','Carlos','Garcia','1985-11-27',7,'+34612345678','2024-04-01 08:25:00','Active'),
(8,'jiwon.kim@mail.com','h4o5p6','Jiwon','Kim','1998-02-14',8,'+821012345678','2024-04-10 20:00:00','Active'),
(9,'yuki.tanaka@mail.com','h7q8r9','Yuki','Tanaka','1993-05-19',9,'+819012345678','2024-04-18 13:40:00','Active'),
(10,'olivia.wilson@mail.com','h1s2t3','Olivia','Wilson','2001-08-23',10,'+61412345678','2024-05-02 19:15:00','Active'),
(11,'zeynep.kaya@mail.com','h4u5v6','Zeynep','Kaya','1996-10-11',3,'+905345556677','2024-05-09 12:00:00','Active'),
(12,'david.jones@mail.com','h7w8x9','David','Jones','1983-01-29',1,'+12025550199','2024-05-15 07:50:00','Cancelled'),
(13,'laura.dubois@mail.com','h1y2z3','Laura','Dubois','1999-04-04',6,'+33687654321','2024-05-20 22:30:00','Active'),
(14,'can.ozturk@mail.com','h4a5b6','Can','Ozturk','1994-09-09',3,'+905367778899','2024-05-25 15:20:00','Active'),
(15,'anna.schmidt@mail.com','h7c8d9','Anna','Schmidt','1991-12-31',5,'+4915198765432','2025-01-05 10:00:00','Active');

-- profiles (26)
INSERT INTO profiles (profile_id, user_id, profile_name, is_kids, preferred_language_id, created_at) VALUES
(1,1,'Ayse',FALSE,2,'2024-01-15 10:25:00'),
(2,1,'Kids',TRUE,2,'2024-01-16 09:00:00'),
(3,2,'John',FALSE,1,'2024-02-01 14:10:00'),
(4,2,'Family',FALSE,1,'2024-02-02 10:00:00'),
(5,3,'Emma',FALSE,1,'2024-02-10 09:05:00'),
(6,4,'Mehmet',FALSE,2,'2024-03-03 18:50:00'),
(7,4,'Guest',FALSE,1,'2024-03-04 12:00:00'),
(8,5,'Lukas',FALSE,3,'2024-03-12 11:35:00'),
(9,6,'Sophie',FALSE,4,'2024-03-20 16:15:00'),
(10,7,'Carlos',FALSE,5,'2024-04-01 08:30:00'),
(11,7,'Kids',TRUE,5,'2024-04-02 09:00:00'),
(12,8,'Jiwon',FALSE,6,'2024-04-10 20:05:00'),
(13,9,'Yuki',FALSE,7,'2024-04-18 13:45:00'),
(14,10,'Olivia',FALSE,1,'2024-05-02 19:20:00'),
(15,11,'Zeynep',FALSE,2,'2024-05-09 12:05:00'),
(16,11,'Kids',TRUE,2,'2024-05-10 08:00:00'),
(17,12,'David',FALSE,1,'2024-05-15 07:55:00'),
(18,13,'Laura',FALSE,4,'2024-05-20 22:35:00'),
(19,14,'Can',FALSE,2,'2024-05-25 15:25:00'),
(20,14,'Sports',FALSE,2,'2024-05-26 10:00:00'),
(21,15,'Anna',FALSE,3,'2025-01-05 10:05:00'),
(22,1,'Guest',FALSE,1,'2024-06-01 11:00:00'),
(23,3,'Kids',TRUE,1,'2024-06-02 12:00:00'),
(24,5,'Gaming',FALSE,3,'2024-06-03 13:00:00'),
(25,8,'Family',FALSE,6,'2024-06-04 14:00:00'),
(26,10,'Kids',TRUE,1,'2024-06-05 15:00:00');

-- subscriptions (15)
INSERT INTO subscriptions (subscription_id, user_id, plan_id, start_date, end_date, status, auto_renew) VALUES
(1,1,3,'2024-01-15',NULL,'Active',TRUE),
(2,2,2,'2024-02-01',NULL,'Active',TRUE),
(3,3,2,'2024-02-10',NULL,'Active',TRUE),
(4,4,1,'2024-03-03',NULL,'Active',TRUE),
(5,5,3,'2024-03-12',NULL,'Active',TRUE),
(6,6,1,'2024-03-20','2024-09-20','Cancelled',FALSE),
(7,7,2,'2024-04-01',NULL,'Active',TRUE),
(8,8,3,'2024-04-10',NULL,'Active',TRUE),
(9,9,2,'2024-04-18',NULL,'Active',TRUE),
(10,10,1,'2024-05-02',NULL,'Active',TRUE),
(11,11,3,'2024-05-09',NULL,'Active',TRUE),
(12,12,2,'2024-05-15','2025-01-15','Expired',FALSE),
(13,13,1,'2024-05-20',NULL,'Active',TRUE),
(14,14,2,'2024-05-25',NULL,'Active',TRUE),
(15,15,3,'2025-01-05',NULL,'Active',TRUE);

-- payments (22)
INSERT INTO payments (payment_id, subscription_id, amount, payment_date, payment_method, payment_status) VALUES
(1,1,19.99,'2024-01-15 10:30:00','CreditCard','Success'),
(2,1,19.99,'2024-02-15 10:30:00','CreditCard','Success'),
(3,1,19.99,'2024-03-15 10:30:00','CreditCard','Success'),
(4,2,13.99,'2024-02-01 14:15:00','PayPal','Success'),
(5,2,13.99,'2024-03-01 14:15:00','PayPal','Success'),
(6,3,13.99,'2024-02-10 09:10:00','CreditCard','Success'),
(7,4,7.99,'2024-03-03 18:55:00','GiftCard','Success'),
(8,5,19.99,'2024-03-12 11:40:00','CreditCard','Success'),
(9,5,19.99,'2024-04-12 11:40:00','CreditCard','Success'),
(10,6,7.99,'2024-03-20 16:20:00','PayPal','Success'),
(11,6,7.99,'2024-04-20 16:20:00','PayPal','Failed'),
(12,7,13.99,'2024-04-01 08:35:00','CreditCard','Success'),
(13,8,19.99,'2024-04-10 20:10:00','CreditCard','Success'),
(14,8,19.99,'2024-05-10 20:10:00','CreditCard','Success'),
(15,9,13.99,'2024-04-18 13:50:00','PayPal','Success'),
(16,10,7.99,'2024-05-02 19:25:00','GiftCard','Success'),
(17,11,19.99,'2024-05-09 12:10:00','CreditCard','Success'),
(18,12,13.99,'2024-05-15 08:00:00','CreditCard','Success'),
(19,12,13.99,'2024-06-15 08:00:00','CreditCard','Refunded'),
(20,13,7.99,'2024-05-20 22:40:00','PayPal','Success'),
(21,14,13.99,'2024-05-25 15:30:00','CreditCard','Success'),
(22,15,19.99,'2025-01-05 10:10:00','CreditCard','Success');

-- content (20)
INSERT INTO content (content_id, title, content_type, release_year, description, maturity_rating, original_language_id, imdb_rating, added_date) VALUES
(1,'Inception','Movie',2010,'A thief steals secrets through dream-sharing.','PG-13',1,8.8,'2024-01-01'),
(2,'The Dark Knight','Movie',2008,'Batman faces the Joker in Gotham.','PG-13',1,9.0,'2024-01-01'),
(3,'Parasite','Movie',2019,'Class conflict between two families.','R',6,8.5,'2024-01-05'),
(4,'Amelie','Movie',2001,'A shy Parisian girl quietly changes lives.','R',4,8.3,'2024-01-10'),
(5,'Pans Labyrinth','Movie',2006,'A girl escapes into a dark fantasy in wartime Spain.','R',5,8.2,'2024-01-12'),
(6,'Spirited Away','Movie',2001,'A girl is trapped in a spirit world.','PG',7,8.6,'2024-01-15'),
(7,'The Matrix','Movie',1999,'A hacker learns reality is a simulation.','R',1,8.7,'2024-01-20'),
(8,'Interstellar','Movie',2014,'Astronauts travel through a wormhole to save humanity.','PG-13',1,8.6,'2024-01-22'),
(9,'Whiplash','Movie',2014,'A young drummer chases greatness under a brutal teacher.','R',1,8.5,'2024-02-01'),
(10,'Your Name','Movie',2016,'Two teenagers mysteriously swap bodies.','PG',7,8.4,'2024-02-05'),
(11,'Breaking Bad','Series',2008,'A chemistry teacher turns to making drugs.','TV-MA',1,9.5,'2024-01-02'),
(12,'Stranger Things','Series',2016,'Supernatural events in a small town.','TV-14',1,8.7,'2024-01-03'),
(13,'Dark','Series',2017,'Time travel and missing children in a German town.','TV-MA',3,8.7,'2024-01-08'),
(14,'Money Heist','Series',2017,'A crew pulls off a massive heist.','TV-MA',5,8.2,'2024-01-11'),
(15,'Squid Game','Series',2021,'Players risk their lives in deadly games.','TV-MA',6,8.0,'2024-01-18'),
(16,'The Crown','Series',2016,'The story of the British royal family.','TV-MA',1,8.6,'2024-02-02'),
(17,'Sherlock','Series',2010,'A genius detective in modern London.','TV-14',1,9.1,'2024-02-08'),
(18,'Game of Thrones','Series',2011,'Noble houses fight for the throne.','TV-MA',1,9.2,'2024-02-12'),
(19,'Black Mirror','Series',2011,'The dark side of technology.','TV-MA',1,8.7,'2024-02-15'),
(20,'The Witcher','Series',2019,'A monster hunter travels a dangerous world.','TV-MA',1,8.0,'2024-02-20');

-- movies (10)
INSERT INTO movies (content_id, duration_minutes) VALUES
(1,148),(2,152),(3,132),(4,122),(5,118),(6,125),(7,136),(8,169),(9,107),(10,106);

-- series (10)
INSERT INTO series (content_id, series_status) VALUES
(11,'Ended'),(12,'Ongoing'),(13,'Ended'),(14,'Ended'),(15,'Ongoing'),
(16,'Ended'),(17,'Ended'),(18,'Ended'),(19,'Ongoing'),(20,'Ongoing');

-- seasons (15)
INSERT INTO seasons (season_id, content_id, season_number, release_year) VALUES
(1,11,1,2008),(2,11,2,2009),(3,11,3,2010),
(4,12,1,2016),(5,12,2,2017),
(6,13,1,2017),(7,13,2,2019),
(8,14,1,2017),(9,14,2,2018),
(10,15,1,2021),
(11,16,1,2016),(12,16,2,2017),
(13,17,1,2010),
(14,19,1,2011),(15,19,2,2013);

-- episodes (32)
INSERT INTO episodes (episode_id, season_id, episode_number, title, duration_minutes) VALUES
(1,1,1,'Pilot',58),(2,1,2,'Cats in the Bag',48),(3,1,3,'And the Bags Hole',47),
(4,2,1,'Seven Thirty-Seven',47),(5,2,2,'Grilled',48),
(6,3,1,'No Mas',47),(7,3,2,'Caballo sin Nombre',48),
(8,4,1,'The Vanishing of Will',49),(9,4,2,'The Weirdo on Maple Street',56),(10,4,3,'Holly Jolly',52),
(11,5,1,'MADMAX',48),(12,5,2,'Trick or Treat',56),
(13,6,1,'Secrets',51),(14,6,2,'Lies',45),
(15,7,1,'Beginnings and Endings',57),(16,7,2,'Dark Matter',57),
(17,8,1,'Episode 1',47),(18,8,2,'Episode 2',41),
(19,9,1,'Episode 1',54),(20,9,2,'Episode 2',49),
(21,10,1,'Red Light Green Light',60),(22,10,2,'Hell',63),(23,10,3,'The Man with the Umbrella',55),
(24,11,1,'Wolferton Splash',57),(25,11,2,'Hyde Park Corner',61),
(26,12,1,'Misadventure',58),(27,12,2,'Beryl',52),
(28,13,1,'A Study in Pink',88),(29,13,2,'The Blind Banker',89),(30,13,3,'The Great Game',89),
(31,14,1,'The National Anthem',44),(32,15,1,'Be Right Back',48);

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
INSERT INTO people (person_id, full_name, birth_date, nationality_country_id) VALUES
(1,'Christopher Nolan','1970-07-30',2),
(2,'Leonardo DiCaprio','1974-11-11',1),
(3,'Christian Bale','1974-01-30',2),
(4,'Heath Ledger','1979-04-04',10),
(5,'Bong Joon-ho','1969-09-14',8),
(6,'Song Kang-ho','1967-01-17',8),
(7,'Hayao Miyazaki','1941-01-05',9),
(8,'Keanu Reeves','1964-09-02',4),
(9,'Matthew McConaughey','1969-11-04',1),
(10,'Anne Hathaway','1982-11-12',1),
(11,'Bryan Cranston','1956-03-07',1),
(12,'Aaron Paul','1979-08-27',1),
(13,'Vince Gilligan','1967-02-10',1),
(14,'Millie Bobby Brown','2004-02-19',2),
(15,'Winona Ryder','1971-10-29',1),
(16,'Pedro Alonso','1971-06-21',7),
(17,'Lee Jung-jae','1972-12-15',8),
(18,'Benedict Cumberbatch','1976-07-19',2),
(19,'Emilia Clarke','1986-10-23',2),
(20,'Henry Cavill','1983-05-05',2);

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

-- watchlist (22)
INSERT INTO watchlist (profile_id, content_id, added_date) VALUES
(1,11,'2024-02-01 20:00:00'),(1,8,'2024-02-03 21:00:00'),(1,15,'2024-02-10 19:00:00'),
(3,2,'2024-02-05 18:00:00'),(3,18,'2024-02-06 22:00:00'),(3,7,'2024-02-07 20:00:00'),
(5,13,'2024-02-11 21:00:00'),(5,17,'2024-02-12 20:00:00'),
(6,1,'2024-03-05 19:30:00'),(6,12,'2024-03-06 20:30:00'),
(8,6,'2024-03-15 18:00:00'),
(9,4,'2024-03-22 17:00:00'),(9,16,'2024-03-23 21:00:00'),
(10,3,'2024-04-02 20:00:00'),(10,15,'2024-04-03 19:00:00'),
(12,11,'2024-04-12 22:00:00'),(12,20,'2024-04-13 20:00:00'),
(14,8,'2024-05-03 21:00:00'),(14,19,'2024-05-04 22:00:00'),
(15,14,'2024-05-10 20:00:00'),(15,18,'2024-05-11 21:00:00'),
(18,10,'2024-05-21 19:00:00');

-- favorites (16)
INSERT INTO favorites (profile_id, content_id, added_date) VALUES
(1,11,'2024-03-01 20:00:00'),(1,2,'2024-03-02 21:00:00'),
(3,18,'2024-03-10 22:00:00'),(3,8,'2024-03-11 20:00:00'),
(5,17,'2024-03-15 19:00:00'),
(6,1,'2024-04-01 18:00:00'),
(8,6,'2024-04-05 17:00:00'),(8,10,'2024-04-06 18:00:00'),
(10,3,'2024-04-20 20:00:00'),
(12,11,'2024-05-01 21:00:00'),(12,7,'2024-05-02 20:00:00'),
(14,19,'2024-05-10 22:00:00'),
(15,14,'2024-05-15 20:00:00'),(15,15,'2024-05-16 19:00:00'),
(18,4,'2024-05-25 18:00:00'),
(19,11,'2024-05-30 21:00:00');

-- watch_history (28)
INSERT INTO watch_history (history_id, profile_id, content_id, episode_id, watched_at, progress_percent, is_completed) VALUES
(1,1,11,1,'2024-02-02 21:00:00',100,TRUE),
(2,1,11,2,'2024-02-03 21:00:00',100,TRUE),
(3,1,11,3,'2024-02-04 21:00:00',65,FALSE),
(4,1,8,NULL,'2024-02-10 20:00:00',100,TRUE),
(5,3,2,NULL,'2024-02-06 19:00:00',100,TRUE),
(6,3,18,NULL,'2024-02-08 22:00:00',40,FALSE),
(7,3,7,NULL,'2024-02-09 20:00:00',100,TRUE),
(8,5,13,13,'2024-02-12 21:00:00',100,TRUE),
(9,5,13,14,'2024-02-13 21:00:00',80,FALSE),
(10,5,17,28,'2024-02-15 20:00:00',100,TRUE),
(11,6,1,NULL,'2024-03-06 19:30:00',100,TRUE),
(12,6,12,8,'2024-03-07 20:30:00',100,TRUE),
(13,6,12,9,'2024-03-08 20:30:00',55,FALSE),
(14,8,6,NULL,'2024-03-16 18:00:00',100,TRUE),
(15,9,4,NULL,'2024-03-23 17:00:00',100,TRUE),
(16,9,16,24,'2024-03-24 21:00:00',90,FALSE),
(17,10,3,NULL,'2024-04-03 20:00:00',100,TRUE),
(18,10,15,21,'2024-04-04 19:00:00',100,TRUE),
(19,10,15,22,'2024-04-05 19:00:00',70,FALSE),
(20,12,11,1,'2024-04-13 22:00:00',100,TRUE),
(21,12,20,NULL,'2024-04-14 20:00:00',30,FALSE),
(22,14,8,NULL,'2024-05-04 21:00:00',100,TRUE),
(23,14,19,31,'2024-05-05 22:00:00',100,TRUE),
(24,15,14,17,'2024-05-11 20:00:00',100,TRUE),
(25,15,18,NULL,'2024-05-12 21:00:00',25,FALSE),
(26,18,10,NULL,'2024-05-22 19:00:00',100,TRUE),
(27,19,11,4,'2024-05-31 21:00:00',100,TRUE),
(28,21,9,NULL,'2025-01-06 20:00:00',100,TRUE);

-- reviews (20)
INSERT INTO reviews (review_id, profile_id, content_id, rating, comment, review_date) VALUES
(1,1,11,10,'Best show ever made.','2024-02-05 22:00:00'),
(2,1,8,9,'Visually stunning, the ending got me.','2024-02-11 21:00:00'),
(3,3,2,10,'Heath Ledger is an unreal Joker.','2024-02-07 20:00:00'),
(4,3,7,8,'Still a great classic.','2024-02-10 19:00:00'),
(5,5,13,9,'Complex but very rewarding.','2024-02-14 21:00:00'),
(6,5,17,10,'Every episode is a puzzle.','2024-02-16 20:00:00'),
(7,6,1,9,'Mind-bending film.','2024-03-07 19:00:00'),
(8,8,6,10,'Miyazaki at his best.','2024-03-17 18:00:00'),
(9,9,4,8,'Sweet and charming.','2024-03-24 17:00:00'),
(10,10,3,9,'Did not see that ending coming.','2024-04-04 20:00:00'),
(11,10,15,7,'Good but a bit overhyped.','2024-04-06 19:00:00'),
(12,12,11,10,'Walter''s transformation is incredible.','2024-04-15 22:00:00'),
(13,14,8,9,'Science and emotion together.','2024-05-05 21:00:00'),
(14,14,19,8,'Some episodes are genius.','2024-05-06 22:00:00'),
(15,15,14,8,'Tension never drops.','2024-05-12 20:00:00'),
(16,18,10,9,'Beautiful and emotional.','2024-05-23 19:00:00'),
(17,19,11,10,'Rewatchable any time.','2024-06-01 21:00:00'),
(18,21,9,9,'Music and tension are perfect.','2025-01-07 20:00:00'),
(19,5,12,7,'Nostalgic and fun.','2024-02-20 21:00:00'),
(20,3,18,9,'An epic production.','2024-02-12 22:00:00');

-- devices (16)
INSERT INTO devices (device_id, user_id, device_type, device_name, last_login) VALUES
(1,1,'TV','Samsung Living Room','2024-05-20 21:00:00'),
(2,1,'Phone','Ayse iPhone','2024-05-22 08:00:00'),
(3,2,'Laptop','John MacBook','2024-05-18 19:00:00'),
(4,2,'TV','LG Bedroom','2024-05-19 22:00:00'),
(5,3,'Tablet','Emma iPad','2024-05-15 20:00:00'),
(6,4,'Phone','Mehmet Android','2024-05-10 18:00:00'),
(7,5,'TV','Sony 4K','2024-05-12 21:00:00'),
(8,6,'Laptop','Sophie Dell','2024-04-01 17:00:00'),
(9,7,'Phone','Carlos Pixel','2024-05-01 20:00:00'),
(10,8,'TV','Samsung Seoul','2024-05-10 20:00:00'),
(11,9,'Tablet','Yuki Tab','2024-04-25 13:00:00'),
(12,10,'Phone','Olivia iPhone','2024-05-03 19:00:00'),
(13,11,'Desktop','Zeynep PC','2024-05-09 12:00:00'),
(14,13,'Laptop','Laura HP','2024-05-21 22:00:00'),
(15,14,'TV','Vestel Living Room','2024-05-26 15:00:00'),
(16,15,'Phone','Anna Samsung','2025-01-05 10:00:00');

-- subtitles (24)
INSERT INTO subtitles (subtitle_id, content_id, language_id) VALUES
(1,1,1),(2,1,2),(3,1,5),
(4,2,1),(5,2,2),
(6,3,1),(7,3,6),(8,3,2),
(9,6,1),(10,6,7),(11,6,2),
(12,8,1),(13,8,3),
(14,11,1),(15,11,2),(16,11,5),
(17,13,3),(18,13,1),
(19,14,5),(20,14,1),(21,14,2),
(22,15,6),(23,15,1),(24,17,1);
