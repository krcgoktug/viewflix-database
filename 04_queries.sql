-- ============================================================
--  STREAMFLIX  -  04 - SORGULAR (Q&A FORMATI)
--  5 Basit Sorgu + 5 Karmasik Sorgu
--  Her sorgudan once anlamli bir is sorusu yer alir.
-- ============================================================
USE streamflix;

-- ############################################################
--  BASIT SORGULAR (filtreleme, siralama)
-- ############################################################

-- ----- BASIT 1 -----
-- Soru: Platformdaki tum filmleri (sadece Movie tipi) IMDB puanina gore en yuksekten dusuge listele.
SELECT title, release_year, imdb_rating
FROM content
WHERE content_type = 'Movie'
ORDER BY imdb_rating DESC;

-- ----- BASIT 2 -----
-- Soru: Turkiyede yasayan aktif kullanicilarin ad, soyad ve e-postalarini getir.
SELECT u.first_name, u.last_name, u.email
FROM users u
JOIN countries c ON u.country_id = c.country_id
WHERE c.country_name = 'Turkey' AND u.account_status = 'Active';

-- ----- BASIT 3 -----
-- Soru: 2015 yilindan sonra eklenmis (yayinlanmis) icerikleri yil sirasiyla listele.
SELECT title, content_type, release_year
FROM content
WHERE release_year > 2015
ORDER BY release_year ASC, title ASC;

-- ----- BASIT 4 -----
-- Soru: Premium aboneligi olan (max 4 ekran) abonelik planinin detaylarini goster.
SELECT plan_name, monthly_price, max_resolution, max_screens
FROM subscription_plans
WHERE max_screens >= 4;

-- ----- BASIT 5 -----
-- Soru: Puani 9 ve uzeri olan tum kullanici yorumlarini en yeniden eskiye dogru listele.
SELECT profile_id, content_id, rating, comment, review_date
FROM reviews
WHERE rating >= 9
ORDER BY review_date DESC;

-- ############################################################
--  KARMASIK SORGULAR (JOIN, GROUP BY/HAVING, Subquery)
-- ############################################################

-- ----- KARMASIK 1 (JOIN + GROUP BY + ORDER BY) -----
-- Soru: Her icerigin aldigi ortalama kullanici puani ve yorum sayisi nedir?
--       En yuksek ortalamadan baslayarak goster.
SELECT c.title,
       c.content_type,
       COUNT(r.review_id)        AS yorum_sayisi,
       ROUND(AVG(r.rating), 2)   AS ortalama_puan
FROM content c
JOIN reviews r ON c.content_id = r.content_id
GROUP BY c.content_id, c.title, c.content_type
ORDER BY ortalama_puan DESC, yorum_sayisi DESC;

-- ----- KARMASIK 2 (JOIN + GROUP BY + HAVING) -----
-- Soru: Birden fazla (1'den fazla) icerige sahip film/dizi turleri hangileri
--       ve her birinde kac icerik var? En kalabalik turleri once goster.
SELECT g.genre_name,
       COUNT(cg.content_id) AS icerik_sayisi
FROM genres g
JOIN content_genres cg ON g.genre_id = cg.genre_id
GROUP BY g.genre_id, g.genre_name
HAVING COUNT(cg.content_id) > 1
ORDER BY icerik_sayisi DESC;

-- ----- KARMASIK 3 (Coklu JOIN + Aggregation) -----
-- Soru: Her kullanicinin abonelik planina gore platforma yaptigi toplam basarili odeme tutari nedir?
SELECT u.first_name, u.last_name, p.plan_name,
       SUM(pay.amount) AS toplam_odeme
FROM users u
JOIN subscriptions s   ON u.user_id = s.user_id
JOIN subscription_plans p ON s.plan_id = p.plan_id
JOIN payments pay      ON s.subscription_id = pay.subscription_id
WHERE pay.payment_status = 'Success'
GROUP BY u.user_id, u.first_name, u.last_name, p.plan_name
ORDER BY toplam_odeme DESC;

-- ----- KARMASIK 4 (Subquery + IN) -----
-- Soru: Ortalama IMDB puani tum iceriklerin genel ortalamasinin uzerinde olan icerikleri,
--       baslik ve puanlariyla listele.
SELECT title, content_type, imdb_rating
FROM content
WHERE imdb_rating > (SELECT AVG(imdb_rating) FROM content)
ORDER BY imdb_rating DESC;

-- ----- KARMASIK 5 (Correlated Subquery / NOT EXISTS) -----
-- Soru: Hic kez izlenmemis (watch_history kaydi olmayan) icerikleri bul.
SELECT c.title, c.content_type
FROM content c
WHERE NOT EXISTS (
    SELECT 1 FROM watch_history wh WHERE wh.content_id = c.content_id
)
ORDER BY c.title;

-- ----- KARMASIK 6 (BONUS: Coklu JOIN + En cok izlenen) -----
-- Soru: En cok favorilere eklenen ilk 5 icerik hangileri?
SELECT c.title,
       COUNT(f.profile_id) AS favori_sayisi
FROM content c
JOIN favorites f ON c.content_id = f.content_id
GROUP BY c.content_id, c.title
ORDER BY favori_sayisi DESC
LIMIT 5;

-- ----- KARMASIK 7 (BONUS: Subquery + oyuncu-icerik) -----
-- Soru: Christopher Nolan'in yonettigi (Director) tum icerikleri listele.
SELECT c.title, c.release_year
FROM content c
WHERE c.content_id IN (
    SELECT cc.content_id
    FROM content_cast cc
    JOIN people pe ON cc.person_id = pe.person_id
    WHERE pe.full_name = 'Christopher Nolan' AND cc.cast_role = 'Director'
);
