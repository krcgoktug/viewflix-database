# VIEWFLIX - Presentation Script (10 min + 5 min Q&A)
**Team:** Defne Kaya & Goktug Karaca · COMP2004 Database Management Systems

Roles: **[D] = Defne** speaks · **[G] = Goktug** speaks. Both speak roughly half.
Target: ~10 minutes. Keep each slide ~30-45 seconds. Speak slowly and look at the audience.

---

## Slide 1 - Title  **[D]**
"Hello everyone. We are Defne and Goktug, and today we will present VIEWFLIX, the
database system we designed for an online movie and TV streaming platform, for the
Database Management Systems course."

## Slide 2 - Project Overview  **[D]**
"VIEWFLIX is the database behind a Netflix-like service. It lets users subscribe to a
plan, browse movies and series, add titles to favorites, rate and review content, track
their watch history, and see the actors and directors of each title. We built only the
database layer - the focus is the relational design, not an app."

## Slide 3 - System Requirements  **[D]**
"From these features we derived the requirements: store user accounts, manage
subscription plans and payments, store movies and series under one content model,
categorize content by genres, store cast and crew, track watch history, and let users
add favorites and write reviews."

## Slide 4 - ER Diagram (text)  **[D]**
"To model this we identified eleven entities. Eight are strong entities with their own
primary key - Users, Subscription_Plans, Subscriptions, Content, Genres, People,
Watch_History and Reviews. Three are weak, or associative, entities that use a composite
key - Content_Genres, Content_Cast and Favorites. On the next slide you can see how they
connect."

## Slide 5 - ER Diagram (image)  **[D]**
"Here is the full ER diagram. The blue boxes are strong entities, the orange double-bordered
boxes are the weak entities. Every relationship is one-to-many: for example, one User has
many Reviews, and one Content has many Reviews - so Reviews sits between them. The same
pattern resolves every many-to-many relationship using a bridge table. Primary keys and
foreign keys are shown inside each box."

## Slide 6 - Database Design (3NF)  **[D] -> hand over to [G] at the end**
"The database is in Third Normal Form. 1NF: every attribute is atomic, no repeating groups.
2NF: no partial dependency on a composite key. 3NF: no transitive dependency - every non-key
attribute depends only on the primary key. This removes redundancy and keeps the data
consistent. Now Goktug will walk through the physical design and the SQL."

## Slide 7 - Table Structure  **[G]**
"Thanks. Physically we have eleven tables. The eight strong entities each have a single-column
primary key. The three associative tables use composite primary keys - for instance
Content_Genres is keyed by content_id and genre_id together. This is exactly the bridge-table
pattern that resolves many-to-many relationships."

## Slide 8 - Primary & Foreign Keys  **[G]**
"Primary keys uniquely identify each row; foreign keys connect the tables and enforce
referential integrity. For example, every subscription references a valid user and a valid
plan, and every review references a valid user and a valid content. We also added constraints
like UNIQUE on email, and CHECK constraints such as rating between 1 and 10."

## Slide 9-10 - Simple SQL Queries  **[G]**
"We wrote fifteen queries grouped in three sets. First, simple queries - filtering and
sorting. For example, listing all movies ordered by IMDb rating, or finding active users in
Turkey. These use basic WHERE and ORDER BY."

## Slide 11-12 - Complex SQL Queries (JOIN / Subquery)  **[G]**
"Second, complex queries using joins and subqueries. For example, titles with an IMDb rating
above the average - that uses a subquery; content that has never been watched - that uses NOT
EXISTS; and every review shown with the user's name and the title - a three-table join."

## Slide 13 - Aggregation Queries (GROUP BY / HAVING)  **[G]**
"Third, aggregation queries with GROUP BY and HAVING. For example, the average rating per
title, the genres linked to more than one title, and the monthly revenue per subscription
plan. Each query answers a real business question."

## LIVE DEMO  **[G]**  (open MySQL Workbench - do this here)
"Now a quick live demo on our MySQL database."
1. Show the schema panel: "Here are the 11 tables in the viewflix database."
2. Run a query from 04_queries.sql (e.g. average rating per title). "These are real results."
3. Type and run live:
   - `INSERT INTO users (email, password_hash, first_name, last_name, birth_date, country, account_status) VALUES ('demo@mail.com','h','Demo','User','2000-01-01','Turkey','Active');`
   - `SELECT * FROM users WHERE email='demo@mail.com';`  -> "The user is added."
   - `DELETE FROM users WHERE email='demo@mail.com';`  -> "and removed. The foreign keys keep everything consistent."

## Slide 14 - Conclusion  **[G] then [D] closes**
**[G]:** "In conclusion, VIEWFLIX is a fully normalized relational database for a streaming
platform. It manages users, subscriptions, content, genres, people, reviews, favorites and
watch history, with data integrity through primary and foreign keys."
**[D]:** "By applying 3NF and proper relational design, the system is consistent, has no
redundancy, and is easy to extend. Thank you for listening - we are happy to take questions."

## Slide 15 - Thanks  **[both]**

---

## Q&A Preparation (5 min) - likely questions and short answers

- **Why are Content_Genres, Content_Cast and Favorites weak entities?**
  Because they have no key of their own; they are identified by the combination of the foreign
  keys of the entities they connect (a composite key). They resolve many-to-many relationships.

- **Why is Subscriptions a separate table and not a column in Users?**
  A subscription has its own attributes (plan, dates, status, payment) and its own key, and a
  user could have a subscription history. Keeping it separate avoids redundancy and is in 3NF.

- **How did you handle movies vs series in one table?**
  Content has a content_type column ('Movie' or 'Series') with a CHECK constraint. duration is
  filled for movies and left NULL for series.

- **Show that the design is in 3NF.**
  No non-key attribute depends on another non-key attribute. Repeating/multi-valued data (like
  genres) was moved to its own table (Content_Genres), removing redundancy.

- **What happens if a user is deleted?**
  We use ON DELETE CASCADE, so the user's subscriptions, reviews, favorites and watch history
  are removed automatically, keeping referential integrity.

- **Why MySQL?**
  It is free, widely used, supports all the constraints we needed (PK, FK, UNIQUE, CHECK), and
  MySQL Workbench lets us run and show the database live.

---

## Tips
- Practice once out loud; total should land near 10 minutes.
- Defne covers design (slides 1-6), Goktug covers implementation + demo (slides 7-15).
- Have MySQL Workbench already open and connected before you start (run start_mysql.bat first).
- If the live demo fails, say "here are the same queries in the script" and show 04_queries.sql.
