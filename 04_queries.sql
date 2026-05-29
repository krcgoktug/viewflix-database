-- STREAMFLIX - Queries
-- 5 simple + 7 complex queries. Each has a business question above it.
USE streamflix;

-- ===== Simple queries =====

-- Q: List all movies, highest IMDb rating first.
SELECT title, release_year, imdb_rating
FROM content
WHERE content_type = 'Movie'
ORDER BY imdb_rating DESC;

-- Q: Active users based in Turkey (name and email).
SELECT u.first_name, u.last_name, u.email
FROM users u
JOIN countries c ON u.country_id = c.country_id
WHERE c.country_name = 'Turkey' AND u.account_status = 'Active';

-- Q: Content released after 2015, ordered by year.
SELECT title, content_type, release_year
FROM content
WHERE release_year > 2015
ORDER BY release_year ASC, title ASC;

-- Q: Plans that allow 4 or more screens.
SELECT plan_name, monthly_price, max_resolution, max_screens
FROM subscription_plans
WHERE max_screens >= 4;

-- Q: All reviews with a score of 9 or higher, newest first.
SELECT profile_id, content_id, rating, comment, review_date
FROM reviews
WHERE rating >= 9
ORDER BY review_date DESC;

-- ===== Complex queries =====

-- Q: Average rating and review count per title, best first.
SELECT c.title,
       c.content_type,
       COUNT(r.review_id)      AS review_count,
       ROUND(AVG(r.rating), 2) AS avg_rating
FROM content c
JOIN reviews r ON c.content_id = r.content_id
GROUP BY c.content_id, c.title, c.content_type
ORDER BY avg_rating DESC, review_count DESC;

-- Q: Which genres have more than one title, and how many?
SELECT g.genre_name,
       COUNT(cg.content_id) AS title_count
FROM genres g
JOIN content_genres cg ON g.genre_id = cg.genre_id
GROUP BY g.genre_id, g.genre_name
HAVING COUNT(cg.content_id) > 1
ORDER BY title_count DESC;

-- Q: Total successful payment amount per user and plan.
SELECT u.first_name, u.last_name, p.plan_name,
       SUM(pay.amount) AS total_paid
FROM users u
JOIN subscriptions s      ON u.user_id = s.user_id
JOIN subscription_plans p ON s.plan_id = p.plan_id
JOIN payments pay         ON s.subscription_id = pay.subscription_id
WHERE pay.payment_status = 'Success'
GROUP BY u.user_id, u.first_name, u.last_name, p.plan_name
ORDER BY total_paid DESC;

-- Q: Titles rated above the overall average IMDb rating.
SELECT title, content_type, imdb_rating
FROM content
WHERE imdb_rating > (SELECT AVG(imdb_rating) FROM content)
ORDER BY imdb_rating DESC;

-- Q: Titles that have never been watched.
SELECT c.title, c.content_type
FROM content c
WHERE NOT EXISTS (
    SELECT 1 FROM watch_history wh WHERE wh.content_id = c.content_id
)
ORDER BY c.title;

-- Q: Top 5 most-favorited titles.
SELECT c.title,
       COUNT(f.profile_id) AS favorite_count
FROM content c
JOIN favorites f ON c.content_id = f.content_id
GROUP BY c.content_id, c.title
ORDER BY favorite_count DESC
LIMIT 5;

-- Q: All titles directed by Christopher Nolan.
SELECT c.title, c.release_year
FROM content c
WHERE c.content_id IN (
    SELECT cc.content_id
    FROM content_cast cc
    JOIN people pe ON cc.person_id = pe.person_id
    WHERE pe.full_name = 'Christopher Nolan' AND cc.cast_role = 'Director'
);
