# VIEWFLIX - Presentation Script (2 speakers, ~10 min + 5 min Q&A)
**Goktug Karaca** = [G]  ·  **Defne Kaya** = [D]

**Split:** Goktug opens with the intro block (1-2-3). Defne does the design/ER block (4-5-6).
From slide 7 it alternates page by page. The 2-3 and 4-5 pairs are kept together on purpose.
Live db-fiddle queries alternate, and Goktug runs the first one.
**Every live query below is one that is actually printed on that slide** - just run the same one.

### Before you start (db-fiddle)
- Open a **db-fiddle.com** tab (MySQL 8), paste schema+data, keep these EXACT slide queries ready:
  - [G] - Slide 9 Q1 (active account status), Slide 11 Q1 (IMDb above average), Slide 13 Q8 (genres with >1 title)
  - [D] - Slide 10 Q5 (movies by IMDb rating), Slide 12 Q4 (reviews with user names)
- One laptop is fine; whoever speaks the query slide steps to it and presses Run. Speak slowly.

---

# GOKTUG - Intro block

## SLIDE 1 - Title  **[G]**
"Hello everyone. We are Goktug and Defne, and today we present VIEWFLIX, a database system for an
online movie and TV streaming platform, for the Database Management Systems course."

## SLIDE 2 - Project Overview  **[G]**
"VIEWFLIX is the database behind a Netflix-like service. Users can subscribe to a plan, browse
movies and series, add favorites, rate and review content, and track their watch history. We
built only the database layer - the focus is a clean, normalized relational design."

## SLIDE 3 - System Requirements  **[G]**
"From these features we listed the requirements: store user accounts and account status, manage
subscription plans and payment status, store movies and series under one content model,
categorize content by genres, store cast and crew, track watch history, and allow favorites and
reviews. Now Defne will present the design and the ER diagram."

# DEFNE - Design / ER block

## SLIDE 4 - ER Diagram (entities & relationships)  **[D]**
"Thanks. To model this we identified our entities: Users, Subscription_Plans, Subscriptions,
Content, Genres, People, Watch_History, Reviews, plus the bridge tables Content_Genres,
Content_Cast and Favorites. Every many-to-many relationship is resolved with a bridge table - for
example one content can have many genres and one genre many contents, so Content_Genres connects
them."

## SLIDE 5 - ER Diagram (image)  **[D]**  (explain the diagram)
"Here is the full ER diagram in Chen notation. Rectangles are entities, ovals are attributes -
underlined ones are primary keys - and diamonds are relationships, with the cardinality 1, N or M
on each line. For example, a User 'Subscribes' to one plan; a User 'Watches', 'Reviews' and
'Favorites' many contents; Content 'Has Genre' with Genres; and People take part in Content
through 'Cast In'. This one picture shows the whole design."

## SLIDE 6 - Database Design (3NF)  **[D]**
"The database is in Third Normal Form. 1NF: every attribute is atomic, no repeating groups - that
is why genres have their own table. 2NF: no partial dependency on a composite key. 3NF: no
transitive dependency - every non-key attribute depends only on the primary key. This removes
redundancy and keeps the data consistent. Now Goktug continues with the tables and the SQL."

# Alternating from here

## SLIDE 7 - Table Structure  **[G]**
"Physically we have eleven tables. Strong entities such as Users, Content and Reviews have their
own primary key. Associative tables such as Content_Genres, Content_Cast and Favorites use a
composite primary key made of the foreign keys they connect."

## SLIDE 8 - Primary & Foreign Keys  **[D]**
"Primary keys uniquely identify each row; foreign keys connect the tables and enforce referential
integrity - every subscription references a valid user and plan, every review a valid user and
content. We also use UNIQUE on email, CHECK constraints such as rating between 1 and 10, and ON
DELETE CASCADE so deleting a user removes their subscriptions, reviews, favorites and history."

## SLIDE 9 - Sample SQL Queries  **[G]**  -> LIVE on db-fiddle
"This slide has our first simple queries - filtering, joining and grouping. Let me run the first
one live - **Q1: which users currently have an active account status?**"
-> run on db-fiddle:
```
SELECT * FROM users WHERE account_status = 'Active';
```
"It returns every active user. The slide also shows Q2-Q4: the ratings users gave (a join),
favorites, and the average rating per title."

## SLIDE 10 - Sample SQL Queries (cont.)  **[D]**  -> LIVE on db-fiddle
"More simple queries. Live - **Q5: list all movies ordered by IMDb rating:**"
-> run on db-fiddle:
```
SELECT title, release_year, imdb_rating
FROM content WHERE content_type = 'Movie' ORDER BY imdb_rating DESC;
```
"Highest-rated movies first. The slide also covers active users in Turkey, high reviews, recent
content and plans with four or more screens."

## SLIDE 11 - Complex SQL Queries  **[G]**  -> LIVE on db-fiddle
"Now complex queries with subqueries. Live - **Q1: which content has an IMDb rating above the
average?**"
-> run on db-fiddle:
```
SELECT title, content_type, imdb_rating FROM content
WHERE imdb_rating > (SELECT AVG(imdb_rating) FROM content) ORDER BY imdb_rating DESC;
```
"The subquery computes the average, then we keep titles above it. The slide also shows content
never watched using NOT EXISTS, and titles directed by Christopher Nolan."

## SLIDE 12 - Complex SQL Queries (cont.)  **[D]**  -> LIVE on db-fiddle
"More complex joins. Live - **Q4: all reviews with the user names and content titles:**"
-> run on db-fiddle:
```
SELECT u.first_name, u.last_name, c.title, r.rating
FROM reviews r
JOIN users u ON r.user_id = u.user_id
JOIN content c ON r.content_id = c.content_id
ORDER BY r.rating DESC, c.title;
```
"This joins three tables. The slide also shows actors per content, titles per type, and the
average rating per title."

## SLIDE 13 - Complex / Aggregation Queries  **[G]**  -> LIVE on db-fiddle
"Finally, aggregation with GROUP BY and HAVING. Live - **Q8: which genres are associated with more
than one content item?**"
-> run on db-fiddle:
```
SELECT g.genre_name, COUNT(cg.content_id) AS title_count
FROM genres g JOIN content_genres cg ON g.genre_id = cg.genre_id
GROUP BY g.genre_id, g.genre_name
HAVING COUNT(cg.content_id) > 1 ORDER BY title_count DESC;
```
"HAVING filters the grouped results. The slide also shows the top 5 favorites and the monthly
revenue per subscription plan."

## SLIDE 14 - Conclusion  **[D]**
"In conclusion, VIEWFLIX is a fully normalized relational database for a streaming platform. With
3NF and proper relational design - primary keys, foreign keys and integrity constraints - the
system ensures data integrity, removes redundancy and is easy to extend."

## SLIDE 15 - Thanks  **[G]** (and both)
"That is our project. Thank you for listening - we are happy to take your questions."

---

## Q&A Preparation (5 min) - share the answers, either of you can reply
- **Why are Content_Genres, Content_Cast and Favorites associative/weak entities?**
  They have no key of their own; they are identified by the combination of the foreign keys of the
  entities they connect (composite key), and they resolve many-to-many relationships.
- **In the diagram a junction looks like a relationship, but in the report it is a weak entity - why?**
  In the conceptual (Chen) diagram a pure many-to-many is drawn as a relationship; in the relational
  schema it becomes a bridge table with a composite key, called a weak / associative entity. Both
  describe the same thing.
- **Why is Subscriptions a separate table and not a column in Users?**
  It has its own attributes (plan, dates, status, payment) and key, and a user could have a
  subscription history. Keeping it separate avoids redundancy and stays in 3NF.
- **Movies vs series in one table?**
  Content has a content_type column ('Movie' or 'Series') with a CHECK constraint; duration is
  filled for movies and NULL for series.
- **Prove it is in 3NF.**
  No non-key attribute depends on another non-key attribute. Multi-valued data such as genres was
  moved to Content_Genres, removing redundancy.
- **What happens if a user is deleted?**
  ON DELETE CASCADE removes their subscriptions, reviews, favorites and watch history.

## Tips
- Target ~10 minutes. Goktug: slides 1-3, 7, 9, 11, 13, 15. Defne: slides 4-6, 8, 10, 12, 14.
- Each live query above is copied straight from the slide it belongs to, so the screen and the
  slide match. Have the db-fiddle tab loaded BEFORE you start; if it is slow, read the slide.
- Hand the laptop over smoothly on the query slides (9-13).
