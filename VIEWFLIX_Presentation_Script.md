# VIEWFLIX - Presentation Script (2 speakers, ~10 min + 5 min Q&A)
**Defne Kaya** = [D]  ·  **Goktug Karaca** = [G]
Slides 1-7: Defne (design)  ·  Slides 8-15: Goktug (implementation + live queries)

### Before you start
- [G] open a **db-fiddle.com** tab in advance (MySQL 8), paste the schema+data, and have these
  queries ready in the Query box so you can press Run during the talk:
  1. Movies by IMDb rating  2. Active users in Turkey  3. Content above average IMDb (subquery)
  4. Average rating per title (JOIN + GROUP BY)  5. Genres with more than one title (HAVING)
- Have the slide deck open in full screen. Speak slowly, look at the audience, not the slides.

---

## SLIDE 1 - Title  **[D]**
"Hello everyone. We are Defne and Goktug. Today we will present VIEWFLIX, a database system
we designed for an online movie and TV streaming platform, for the Database Management Systems
course."

## SLIDE 2 - Project Overview  **[D]**
"VIEWFLIX is the database behind a Netflix-like streaming service. Users can subscribe to a
plan, browse movies and series, add titles to favorites, rate and review content, and track
their watch history. We built only the database layer - the focus is a clean, normalized
relational design."

## SLIDE 3 - System Requirements  **[D]**
"From these features we listed the requirements: store user accounts and account status,
manage subscription plans and payment status, store movies and series under one content model,
categorize content by genres, store cast and crew, track watch history, and let users add
favorites and write reviews."

## SLIDE 4 - ER Diagram (entities & relationships)  **[D]**
"To model this we identified our entities and how they relate. The main entities are Users,
Subscription_Plans, Subscriptions, Content, Genres, People, Watch_History, Reviews, plus the
bridge tables Content_Genres, Content_Cast and Favorites. Every many-to-many relationship is
resolved with a bridge table - for example, one content can have many genres and one genre can
belong to many contents, so Content_Genres connects them."

## SLIDE 5 - ER Diagram (image)  **[D]**  (explain the diagram here)
"Here is the full ER diagram in Chen notation. Rectangles are entities, ovals are attributes -
the underlined ones are primary keys - and the diamonds are relationships, with the cardinality
(1, N, M) on each line. For example: a User 'Subscribes' to one Subscription Plan; a User
'Watches', 'Reviews' and 'Favorites' many Contents; Content 'Has Genre' with Genres; and People
take part in Content through 'Cast In'. This single picture shows the whole design."

## SLIDE 6 - Database Design (3NF)  **[D]**
"The database is in Third Normal Form. 1NF: every attribute is atomic, no repeating groups -
that is why genres are stored in their own table. 2NF: no partial dependency on a composite key.
3NF: no transitive dependency - every non-key attribute depends only on the primary key. This
removes redundancy and keeps the data consistent."

## SLIDE 7 - Table Structure  **[D] -> hand over to [G]**
"Physically we have eleven tables. Strong entities such as Users, Content and Reviews have their
own primary key. Associative tables such as Content_Genres, Content_Cast and Favorites use a
composite primary key made of the foreign keys they connect. Now Goktug will continue with the
keys and the SQL."

## SLIDE 8 - Primary & Foreign Keys  **[G]**
"Thanks. Primary keys uniquely identify each row, and foreign keys connect the tables and enforce
referential integrity. For example every subscription references a valid user and plan, and every
review references a valid user and content. We also use UNIQUE on email, CHECK constraints such
as rating between 1 and 10, and ON DELETE CASCADE so that deleting a user also removes their
subscriptions, reviews, favorites and history."

## SLIDE 9-10 - Sample (Simple) SQL Queries  **[G]**  -> LIVE on db-fiddle
"We wrote fifteen queries in three groups. First, simple queries that filter and sort. Let me
show two of them running live."
- Switch to db-fiddle. Run **Q: movies ordered by IMDb rating** -> point at the result:
  "These are all movies, highest rating first."
- Run **Q: active users in Turkey** -> "And here are the active users located in Turkey."
"These use basic WHERE and ORDER BY."

## SLIDE 11-13 - Complex SQL Queries  **[G]**  -> LIVE on db-fiddle
"Second and third, complex queries with joins and subqueries, and aggregation queries with
GROUP BY and HAVING. A few examples, live:"
- Run **Q: content with IMDb above the average** (subquery) -> "A subquery compares each title to
  the average."
- Run **Q: average rating and number of reviews per title** (JOIN + GROUP BY) -> "Here we join
  reviews to content and group by title."
- Run **Q: genres linked to more than one title** (HAVING) -> "HAVING filters the groups."
"Other examples on the slides include content never watched using NOT EXISTS, titles directed by
a given director, and the monthly revenue per subscription plan."

## SLIDE 14 - Conclusion  **[G] then [D] closes**
**[G]:** "In conclusion, VIEWFLIX is a fully normalized relational database for a streaming
platform, with data integrity enforced by primary and foreign keys and integrity constraints."
**[D]:** "By applying 3NF and proper relational design, the system is consistent, has no
redundancy, and is easy to extend. Thank you for listening - we are happy to take questions."

## SLIDE 15 - Thanks  **[both]**

---

## Q&A Preparation (5 min) - likely questions and short answers
- **Why are Content_Genres, Content_Cast and Favorites associative/weak entities?**
  They have no key of their own; they are identified by the combination of the foreign keys of
  the entities they connect (a composite key) and they resolve many-to-many relationships.
- **In the diagram a junction looks like a relationship, but in the report it is a weak entity - why?**
  In the conceptual (Chen) diagram a pure many-to-many is drawn as a relationship; in the
  relational schema it becomes a bridge table with a composite key, which we call a weak /
  associative entity. Both describe the same thing.
- **Why is Subscriptions a separate table and not a column in Users?**
  A subscription has its own attributes (plan, dates, status, payment) and its own key, and a
  user could have a subscription history. Keeping it separate avoids redundancy and stays in 3NF.
- **How did you handle movies vs series in one table?**
  Content has a content_type column ('Movie' or 'Series') with a CHECK constraint; duration is
  filled for movies and NULL for series.
- **Show that the design is in 3NF.**
  No non-key attribute depends on another non-key attribute. Multi-valued data such as genres was
  moved to its own table (Content_Genres), removing redundancy.
- **What happens if a user is deleted?**
  ON DELETE CASCADE removes the user's subscriptions, reviews, favorites and watch history,
  keeping referential integrity.

## Tips
- Total target ~10 minutes; practice once out loud.
- If db-fiddle is slow, the same query results are also visible in the slides - just read them.
- Keep the db-fiddle tab already loaded BEFORE the presentation starts.
