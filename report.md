# STREAMFLIX — Dizi & Film İzleme Platformu Veritabanı Sistemi
**Veritabanı Sistemleri Dönem Projesi**
Grup Üyeleri: Göktuğ Karaca, Defne Kaya · Tarih: 29/05/2026

---

## 1. Sistem Tanımı ve Fonksiyonel Gereksinimler

**STREAMFLIX**, kullanıcıların film ve dizi izleyebildiği, kişisel hesaplarıyla
giriş yaparak içerikleri izleme listesine ekleyebildiği, favorileyebildiği,
puanlayıp yorum yapabildiği bir dijital içerik yayın (streaming) platformudur.
Netflix benzeri bir sistemin veri katmanını modeller; **web/mobil arayüz
kapsam dışıdır**, odak noktası ilişkisel veritabanı tasarımıdır.

**Fonksiyonel gereksinimler:**
- Kullanıcılar kişisel bilgileriyle (e-posta, ad, ülke, doğum tarihi) kayıt olur.
- Bir hesap altında birden fazla **profil** (ör. yetişkin / çocuk) bulunabilir.
- Kullanıcılar üç **abonelik planından** (Basic / Standard / Premium) birine
  abone olur ve aylık **ödeme** yapar.
- İçerikler **film** veya **dizi** olabilir; diziler **sezon** ve **bölüm**lere ayrılır.
- Her içeriğin birden çok **türü** (Action, Drama…) ve **oyuncu/yönetmen** kadrosu vardır.
- Profiller içeriği **izleme listesine** ve **favorilere** ekler, **izleme geçmişi**
  tutulur, içeriklere **puan + yorum** yazar.
- İçeriklerin **altyazı** dilleri ve kullanıcıların **cihazları** kaydedilir.

## 2. Mantıksal Tasarım (E-R Diyagramı)

Sistem **22 normalize tablo** içerir (3NF). Tüm tablo, anahtar, kardinalite ve
ilişkiler `schema.dbml` dosyasında tanımlıdır ve **dbdiagram.io** üzerinde
görsel E-R diyagramı olarak üretilir.

**Başlıca varlıklar ve ilişkiler:**

| İlişki | Kardinalite | Açıklama |
|--------|-------------|----------|
| users — profiles | 1 : N | Bir hesap birçok profile sahip |
| users — subscriptions — payments | 1 : N : N | Abonelik ve ödeme zinciri |
| content — movies / series | 1 : 1 | Üst tip / alt tip (ISA) ayrımı |
| series — seasons — episodes | 1 : N : N | Dizi hiyerarşisi |
| content — genres | N : M | `content_genres` ara tablosu |
| content — people | N : M | `content_cast` ara tablosu (+rol) |
| profiles — content | N : M | watchlist, favorites, reviews ara tabloları |

### 2.1. Normalizasyon Analizi (1NF → 2NF → 3NF)

Naif bir "tek tablo" tasarımının normalize edilmesiyle veri tekrarı ve anomalilerin
giderildiği gösterilir. Örnek evrensel tablo:

> *İzlemeKaydı(user_email, user_ad, ülke_adı, ülke_kodu, plan_adı, plan_ücret,
> içerik_adı, içerik_türleri, yönetmen, puan)*

- **Anomaliler:** *Ekleme* — aboneliği olmayan planı/izlenmemiş içeriği ekleyememe;
  *Güncelleme* — plan ücreti değişince tüm satırları tek tek güncelleme zorunluluğu;
  *Silme* — bir içeriğin son izleme kaydı silinince içerik bilgisinin de kaybolması.
- **Fonksiyonel bağımlılıklar:** `user_email → user_ad, ülke_adı`;
  `ülke_adı → ülke_kodu`; `plan_adı → plan_ücret`; `içerik_id → içerik_adı, yönetmen`.
- **1NF (atomiklik):** `içerik_türleri` çok-değerli → `content_genres(content_id, genre_id)`.
- **2NF (tam bağımlılık):** Kısmi bağımlılıklar ayrıldı → `users`, `subscription_plans`, `content`.
- **3NF (geçişsizlik):** `user_email → ülke_adı → ülke_kodu` geçişli zinciri `countries`'e;
  `plan_adı → plan_ücret` `subscription_plans`'e; yönetmen `people` + `content_cast`'e taşındı.

**Sonuç:** 22 tablonun tamamı **3NF**'dedir (her anahtar-olmayan öznitelik PK'ye tam ve
geçişsiz bağlı). Çoğu tablo, her belirleyicinin aday anahtar olması nedeniyle **BCNF**'i de
sağlar. Ayrışım kayıpsız (lossless) ve bağımlılık koruyucudur.

## 3. Fiziksel Tasarım

`01_create_tables.sql` dosyası tüm tabloları MySQL 8.0 üzerinde oluşturur.
Uygulanan bütünlük kısıtları:

- **Primary Key:** Her tabloda; ara tablolarda bileşik PK
  (ör. `content_genres(content_id, genre_id)`).
- **Foreign Key:** Tüm ilişkilerde; uygun yerlerde `ON DELETE CASCADE`
  (ör. kullanıcı silinince profilleri, abonelikleri, cihazları da silinir).
- **UNIQUE:** `users.email`, `genres.genre_name`, `reviews(profile_id, content_id)`
  (profil başına içerik başına tek yorum), `seasons(content_id, season_number)`.
- **NOT NULL:** Zorunlu alanlarda (e-posta, başlık, tarih vb.).
- **CHECK:** `rating BETWEEN 1 AND 10`, `progress_percent BETWEEN 0 AND 100`,
  `content_type IN ('Movie','Series')`, `monthly_price >= 0`,
  `payment_status IN ('Success','Failed','Refunded')` vb.

**Örnek veri:** `02_sample_data.sql` ile **426 kayıt** 22 tabloya dağıtılmıştır
(15 kullanıcı, 26 profil, 20 içerik, 32 bölüm, 28 izleme geçmişi, 20 yorum…).
Tüm veriler FK kontrolü açıkken hatasız yüklenmektedir.

## 4. SQL Uygulaması

Her ifade öncesinde anlamlı bir **iş sorusu** belirtilmiştir.

- **`03_dml_operations.sql`** — 14 DML işlemi: 5 INSERT (yeni kayıt, abonelik,
  profil, izleme listesi, yorum), 5 UPDATE (plan değişikliği, abonelik süresi
  dolması, dizi durumu, izleme tamamlama, hesap aktifleştirme),
  4 DELETE (listeden çıkarma, başarısız ödeme temizliği, hesap silme/cascade).
- **`04_queries.sql`** — **5 basit sorgu** (filtreleme/sıralama: filmler,
  ülkeye göre kullanıcılar, yıla göre içerik…) ve **7 karmaşık sorgu**
  (JOIN, GROUP BY/HAVING, alt sorgu, NOT EXISTS): içerik başına ortalama puan,
  en kalabalık türler, kullanıcı başına toplam ödeme, ortalamanın üstündeki
  içerikler, hiç izlenmemiş içerikler, en çok favorilenen 5 içerik,
  belirli yönetmenin içerikleri.

**Doğrulama:** Tüm dosyalar (CREATE + veri + DML + 12 sorgu) referans bütünlüğü
kontrolü açıkken hatasız çalıştırılarak test edilmiştir.

---
*Canlı demo: MySQL Workbench üzerinde dosyalar sırasıyla 01 → 02 → 03 → 04
çalıştırılır. E-R diyagramı dbdiagram.io üzerinde `schema.dbml` ile gösterilir.*
