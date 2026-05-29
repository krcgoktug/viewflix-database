-- ============================================================
--  STREAMFLIX  -  03 - DML OPERASYONLARI (Q&A FORMATI)
--  En az 10 anlamli INSERT / UPDATE / DELETE
--  Her islemden once is sorusu (business question) belirtilmistir.
-- ============================================================
USE streamflix;

-- ----- INSERT 1 -----
-- Soru: Yeni bir kullanici platforma kayit oluyor. Hesabini sisteme ekle.
INSERT INTO users (email, password_hash, first_name, last_name, birth_date, country_id, phone, created_at, account_status)
VALUES ('elif.aydin@mail.com','hX9y8z','Elif','Aydin','1999-03-15',3,'+905381234567', NOW(),'Active');

-- ----- INSERT 2 -----
-- Soru: Yeni kayit olan kullanici Standard plana abone oluyor. Aboneligini olustur.
INSERT INTO subscriptions (user_id, plan_id, start_date, status, auto_renew)
VALUES ((SELECT user_id FROM users WHERE email='elif.aydin@mail.com'), 2, CURDATE(), 'Active', TRUE);

-- ----- INSERT 3 -----
-- Soru: Kullanici kendi izleme profilini olusturuyor. Profili ekle.
INSERT INTO profiles (user_id, profile_name, is_kids, preferred_language_id, created_at)
VALUES ((SELECT user_id FROM users WHERE email='elif.aydin@mail.com'), 'Elif', FALSE, 2, NOW());

-- ----- INSERT 4 -----
-- Soru: Bir kullanici "Inception" filmini izleme listesine ekliyor.
INSERT INTO watchlist (profile_id, content_id, added_date)
VALUES ((SELECT profile_id FROM profiles WHERE profile_name='Elif' AND user_id=(SELECT user_id FROM users WHERE email='elif.aydin@mail.com')),
        1, NOW());

-- ----- INSERT 5 -----
-- Soru: Yeni eklenen profil "Breaking Bad" icin 9 puanli bir yorum yaziyor.
INSERT INTO reviews (profile_id, content_id, rating, comment, review_date)
VALUES ((SELECT profile_id FROM profiles WHERE profile_name='Elif' AND user_id=(SELECT user_id FROM users WHERE email='elif.aydin@mail.com')),
        11, 9, 'Ilk izleyisimde cok etkilendim.', NOW());

-- ----- UPDATE 1 -----
-- Soru: Kullanici Ayse (user_id=1) aboneligini Premiumdan Standarda dusurmek istiyor.
UPDATE subscriptions
SET plan_id = 2
WHERE user_id = 1 AND status = 'Active';

-- ----- UPDATE 2 -----
-- Soru: Suresi gecmis (end_date bugunden once) tum aktif abonelikleri "Expired" yap.
UPDATE subscriptions
SET status = 'Expired'
WHERE end_date IS NOT NULL AND end_date < CURDATE() AND status = 'Active';

-- ----- UPDATE 3 -----
-- Soru: "Stranger Things" dizisi yeni sezonuyla devam ediyor; durumunu Ongoing yap ve IMDB puanini guncelle.
UPDATE content
SET imdb_rating = 8.8
WHERE content_id = 12;
UPDATE series
SET series_status = 'Ongoing'
WHERE content_id = 12;

-- ----- UPDATE 4 -----
-- Soru: Bir kullanici bir bolumu sonuna kadar izledi; izleme gecmisini tamamlandi olarak isaretle.
UPDATE watch_history
SET progress_percent = 100, is_completed = TRUE
WHERE profile_id = 1 AND episode_id = 3;

-- ----- UPDATE 5 -----
-- Soru: Hesabi askiya alinan kullanicinin (Sophie, user_id=6) durumunu tekrar Active yap.
UPDATE users
SET account_status = 'Active'
WHERE user_id = 6;

-- ----- DELETE 1 -----
-- Soru: Bir kullanici "Inception" filmini izleme listesinden cikariyor.
DELETE FROM watchlist
WHERE profile_id = (SELECT profile_id FROM profiles WHERE profile_name='Elif' AND user_id=(SELECT user_id FROM users WHERE email='elif.aydin@mail.com'))
  AND content_id = 1;

-- ----- DELETE 2 -----
-- Soru: Basarisiz (Failed) olan tum odeme kayitlarini sistemden temizle.
DELETE FROM payments
WHERE payment_status = 'Failed';

-- ----- DELETE 3 -----
-- Soru: Hesabini tamamen iptal eden kullaniciyi (David, user_id=12) sil.
--       FK ON DELETE CASCADE sayesinde profilleri, abonelikleri ve cihazlari da silinir.
DELETE FROM users
WHERE user_id = 12;

-- ----- DELETE 4 -----
-- Soru: 30 puanin altinda ilerlemis ve tamamlanmamis izleme kayitlarini temizle (yanlislikla acilan icerikler).
DELETE FROM watch_history
WHERE is_completed = FALSE AND progress_percent < 30;
