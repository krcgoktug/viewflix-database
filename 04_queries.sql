-- VIEWFLIX - Queries
-- 5 simple + 5 complex (JOIN/subquery) + 5 aggregation (GROUP BY/HAVING).
-- Each query has a business question above it.
USE viewflix;

-- ============================================================
-- SIMPLE QUERIES (filtering / sorting)
-- ============================================================

-- Q1: List all movies, highest IMDb rating first.
SELECT title, release_year, imdb_rating
FROM content
WHERE content_type = 'Movie'
ORDER BY imdb_rating DESC;

-- Q2: Active users based in Turkey.
SELECT first_name, last_name, email
FROM users
WHERE country = 'Turkey' AND account_status = 'Active';

-- Q3: Content released after 2015, ordered by year.
SELECT title, content_type, release_year
FROM content
WHERE release_year > 2015
ORDER BY release_year ASC, title ASC;

-- Q4: Plans that allow 4 or more screens.
SELECT plan_name, monthly_price, max_resolution, max_screens
FROM subscription_plans
WHERE max_screens >= 4;

-- Q5: Reviews with a score of 9 or higher, newest first.
SELECT user_id, content_id, rating, comment, review_date
FROM reviews
WHERE rating >= 9
ORDER BY review_date DESC;

-- ============================================================
-- COMPLEX QUERIES (JOIN / SUBQUERY)
-- ============================================================

-- Q6: Titles rated above the overall average IMDb rating. (subquery)
SELECT title, content_type, imdb_rating
FROM content
WHERE imdb_rating > (SELECT AVG(imdb_rating) FROM content)
ORDER BY imdb_rating DESC;

-- Q7: Titles that have never been watched. (NOT EXISTS subquery)
SELECT c.title, c.content_type
FROM content c
WHERE NOT EXISTS (
    SELECT 1 FROM watch_history wh WHERE wh.content_id = c.content_id
)
ORDER BY c.title;

-- Q8: All titles directed by Christopher Nolan. (subquery + join)
SELECT c.title, c.release_year
FROM content c
WHERE c.content_id IN (
    SELECT cc.content_id
    FROM content_cast cc
    JOIN people pe ON cc.person_id = pe.person_id
    WHERE pe.full_name = 'Christopher Nolan' AND cc.cast_role = 'Director'
);

-- Q9: Every review with the reviewer's name and the title. (3-table join)
SELECT u.first_name, u.last_name, c.title, r.rating
FROM reviews r
JOIN users u   ON r.user_id = u.user_id
JOIN content c ON r.content_id = c.content_id
ORDER BY r.rating DESC, c.title;

-- Q10: Actors and the titles they appear in. (join + filter on role)
SELECT pe.full_name AS actor, c.title, cc.character_name
FROM content_cast cc
JOIN people pe  ON cc.person_id = pe.person_id
JOIN content c  ON cc.content_id = c.content_id
WHERE cc.cast_role = 'Actor'
ORDER BY pe.full_name;

-- ============================================================
-- AGGREGATION QUERIES (GROUP BY / HAVING)
-- ============================================================

-- Q11: How many titles and what average rating per content type? (GROUP BY)
SELECT content_type,
       COUNT(*)               AS title_count,
       ROUND(AVG(imdb_rating),2) AS avg_imdb
FROM content
GROUP BY content_type;

-- Q12: Average user rating and review count per title. (JOIN + GROUP BY)
SELECT c.title,
       COUNT(r.review_id)      AS review_count,
       ROUND(AVG(r.rating), 2) AS avg_rating
FROM content c
JOIN reviews r ON c.content_id = r.content_id
GROUP BY c.content_id, c.title
ORDER BY avg_rating DESC, review_count DESC;

-- Q13: Genres that have more than one title. (GROUP BY + HAVING)
SELECT g.genre_name,
       COUNT(cg.content_id) AS title_count
FROM genres g
JOIN content_genres cg ON g.genre_id = cg.genre_id
GROUP BY g.genre_id, g.genre_name
HAVING COUNT(cg.content_id) > 1
ORDER BY title_count DESC;

-- Q14: Monthly revenue per plan from active subscriptions. (JOIN + GROUP BY + SUM)
SELECT p.plan_name,
       COUNT(s.subscription_id) AS active_subs,
       SUM(p.monthly_price)     AS monthly_revenue
FROM subscription_plans p
JOIN subscriptions s ON p.plan_id = s.plan_id
WHERE s.status = 'Active'
GROUP BY p.plan_id, p.plan_name
ORDER BY monthly_revenue DESC;

-- Q15: Top 5 most-favorited titles. (GROUP BY + COUNT + LIMIT)
SELECT c.title,
       COUNT(f.user_id) AS favorite_count
FROM content c
JOIN favorites f ON c.content_id = f.content_id
GROUP BY c.content_id, c.title
ORDER BY favorite_count DESC
LIMIT 5;
