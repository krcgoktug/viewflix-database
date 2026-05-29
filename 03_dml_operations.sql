-- STREAMFLIX - DML (INSERT / UPDATE / DELETE)
-- Each statement has a short business question above it.
USE streamflix;

-- Q: A new user signs up. Add the account.
INSERT INTO users (email, password_hash, first_name, last_name, birth_date, country_id, phone, created_at, account_status)
VALUES ('elif.aydin@mail.com','hX9y8z','Elif','Aydin','1999-03-15',3,'+905381234567', NOW(),'Active');

-- Q: The new user subscribes to the Standard plan.
INSERT INTO subscriptions (user_id, plan_id, start_date, status, auto_renew)
VALUES ((SELECT user_id FROM users WHERE email='elif.aydin@mail.com'), 2, CURDATE(), 'Active', TRUE);

-- Q: The user creates their viewing profile.
INSERT INTO profiles (user_id, profile_name, is_kids, preferred_language_id, created_at)
VALUES ((SELECT user_id FROM users WHERE email='elif.aydin@mail.com'), 'Elif', FALSE, 2, NOW());

-- Q: The user adds "Inception" to their watchlist.
INSERT INTO watchlist (profile_id, content_id, added_date)
VALUES ((SELECT profile_id FROM profiles WHERE profile_name='Elif' AND user_id=(SELECT user_id FROM users WHERE email='elif.aydin@mail.com')),
        1, NOW());

-- Q: The new profile reviews "Breaking Bad" with a score of 9.
INSERT INTO reviews (profile_id, content_id, rating, comment, review_date)
VALUES ((SELECT profile_id FROM profiles WHERE profile_name='Elif' AND user_id=(SELECT user_id FROM users WHERE email='elif.aydin@mail.com')),
        11, 9, 'Loved it on the first watch.', NOW());

-- Q: User Ayse (user_id=1) downgrades from Premium to Standard.
UPDATE subscriptions
SET plan_id = 2
WHERE user_id = 1 AND status = 'Active';

-- Q: Mark all active subscriptions whose end date has passed as Expired.
UPDATE subscriptions
SET status = 'Expired'
WHERE end_date IS NOT NULL AND end_date < CURDATE() AND status = 'Active';

-- Q: "Stranger Things" returns with a new season; set it Ongoing and update its rating.
UPDATE content
SET imdb_rating = 8.8
WHERE content_id = 12;
UPDATE series
SET series_status = 'Ongoing'
WHERE content_id = 12;

-- Q: A user finished an episode; mark the history record as completed.
UPDATE watch_history
SET progress_percent = 100, is_completed = TRUE
WHERE profile_id = 1 AND episode_id = 3;

-- Q: Reactivate a suspended account (Sophie, user_id=6).
UPDATE users
SET account_status = 'Active'
WHERE user_id = 6;

-- Q: A user removes "Inception" from their watchlist.
DELETE FROM watchlist
WHERE profile_id = (SELECT profile_id FROM profiles WHERE profile_name='Elif' AND user_id=(SELECT user_id FROM users WHERE email='elif.aydin@mail.com'))
  AND content_id = 1;

-- Q: Clean up all failed payment records.
DELETE FROM payments
WHERE payment_status = 'Failed';

-- Q: A user cancels their account entirely (David, user_id=12).
--    ON DELETE CASCADE also removes their profiles, subscriptions and devices.
DELETE FROM users
WHERE user_id = 12;

-- Q: Remove abandoned, unfinished views (opened by mistake, under 30% watched).
DELETE FROM watch_history
WHERE is_completed = FALSE AND progress_percent < 30;
