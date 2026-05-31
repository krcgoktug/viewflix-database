-- VIEWFLIX - DML (INSERT / UPDATE / DELETE)
-- Each statement has a short business question above it.
USE viewflix;

-- Q: A new user signs up. Add the account.
INSERT INTO users (email, password_hash, first_name, last_name, birth_date, country, phone, created_at, account_status)
VALUES ('elif.aydin@mail.com','hX9y8z','Elif','Aydin','1999-03-15','Turkey','+905381234567', NOW(),'Active');

-- Q: The new user subscribes to the Standard plan.
INSERT INTO subscriptions (user_id, plan_id, start_date, status, payment_status, auto_renew)
VALUES ((SELECT user_id FROM users WHERE email='elif.aydin@mail.com'), 2, CURDATE(), 'Active', 'Success', TRUE);

-- Q: The user adds "Inception" to their favorites.
INSERT INTO favorites (user_id, content_id, added_date)
VALUES ((SELECT user_id FROM users WHERE email='elif.aydin@mail.com'), 1, NOW());

-- Q: The user starts watching "The Matrix".
INSERT INTO watch_history (user_id, content_id, watched_at, progress_percent, is_completed)
VALUES ((SELECT user_id FROM users WHERE email='elif.aydin@mail.com'), 7, NOW(), 35, FALSE);

-- Q: The user reviews "Breaking Bad" with a score of 9.
INSERT INTO reviews (user_id, content_id, rating, comment, review_date)
VALUES ((SELECT user_id FROM users WHERE email='elif.aydin@mail.com'), 11, 9, 'Loved it on the first watch.', NOW());

-- Q: User Ayse (user_id=1) downgrades from Premium to Standard.
UPDATE subscriptions
SET plan_id = 2
WHERE user_id = 1 AND status = 'Active';

-- Q: Mark all active subscriptions whose end date has passed as Expired.
UPDATE subscriptions
SET status = 'Expired'
WHERE end_date IS NOT NULL AND end_date < CURDATE() AND status = 'Active';

-- Q: "Stranger Things" returns with a new season; bump its rating.
UPDATE content
SET imdb_rating = 8.8
WHERE title = 'Stranger Things';

-- Q: A user finished a title; mark the history record as completed.
UPDATE watch_history
SET progress_percent = 100, is_completed = TRUE
WHERE user_id = 1 AND content_id = 15;

-- Q: Reactivate a suspended account (Sophie, user_id=6).
UPDATE users
SET account_status = 'Active'
WHERE user_id = 6;

-- Q: A user removes "Inception" from their favorites.
DELETE FROM favorites
WHERE user_id = (SELECT user_id FROM users WHERE email='elif.aydin@mail.com')
  AND content_id = 1;

-- Q: Remove subscriptions whose payment was refunded.
DELETE FROM subscriptions
WHERE payment_status = 'Refunded';

-- Q: A user cancels their account entirely (David, user_id=12).
--    ON DELETE CASCADE also removes their subscriptions, reviews, favorites and history.
DELETE FROM users
WHERE user_id = 12;

-- Q: Remove abandoned, unfinished views (opened by mistake, under 30% watched).
DELETE FROM watch_history
WHERE is_completed = FALSE AND progress_percent < 30;
