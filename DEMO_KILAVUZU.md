# STREAMFLIX — Canlı Demo Kılavuzu (Sunum İçin)

Bilgisayara **MySQL Server 8.4** kuruldu ve **STREAMFLIX** veritabanı yüklendi
(22 tablo, 426 kayıt). Aşağıdaki adımlarla sunumda canlı SQL demosu yapabilirsiniz.

## Bağlantı Bilgileri
| Ayar | Değer |
|------|-------|
| Host | `localhost` (127.0.0.1) |
| Port | `3306` |
| Kullanıcı | `root` |
| Parola | `Streamflix2026` |
| Veritabanı | `streamflix` |

## Sunum Öncesi (1 kez)
1. **`start_mysql.bat`** dosyasına çift tıkla → MySQL sunucusu başlar.
   (Bilgisayar yeniden başlatıldıysa demodan önce mutlaka çalıştır.)
2. **MySQL Workbench**'i aç → yukarıdaki bilgilerle bir bağlantı oluştur ve bağlan.
3. (İsteğe bağlı) Pratik sırasında veriyi değiştirdiysen **`reset_database.bat`** ile
   her şeyi 426 kayıtlık temiz haline döndür.

## Demo Akışı (Workbench'te sırayla çalıştır)
1. **`01_create_tables.sql`** → tabloları gösterir (zaten yüklü; isterseniz tekrar çalıştırılabilir).
2. **`02_sample_data.sql`** → 426 örnek kayıt.
3. **`04_queries.sql`** → 5 basit + 7 karmaşık sorgu (her birinde iş sorusu var).
4. **`03_dml_operations.sql`** → INSERT / UPDATE / DELETE örnekleri.

> Workbench'te SQL çalıştırmak: sorguyu seç, **şimşek (⚡) ikonuna** bas. Sonuçlar alt panelde tablo halinde görünür.

## Hocanın İstediği: Canlı Kullanıcı Ekleme / Silme
Sunumda elle yazıp çalıştırarak göster (en etkileyici kısım budur):

```sql
USE streamflix;

-- 1) Mevcut kullanıcılar
SELECT user_id, first_name, last_name, email FROM users ORDER BY user_id DESC LIMIT 5;

-- 2) YENİ KULLANICI EKLE
INSERT INTO users (email, password_hash, first_name, last_name, birth_date, country_id, account_status)
VALUES ('demo.kullanici@mail.com', 'hash123', 'Demo', 'Kullanici', '2000-01-01', 3, 'Active');

-- Eklendiğini göster
SELECT user_id, first_name, last_name, email FROM users WHERE email='demo.kullanici@mail.com';

-- 3) Bu kullanıcıya bir profil ekle (cascade'i göstermek için)
INSERT INTO profiles (user_id, profile_name, is_kids, preferred_language_id)
VALUES ((SELECT user_id FROM users WHERE email='demo.kullanici@mail.com'), 'Demo Profil', FALSE, 2);

-- 4) KULLANICIYI SİL  → ON DELETE CASCADE sayesinde profili de otomatik silinir
DELETE FROM users WHERE email='demo.kullanici@mail.com';

-- Hem kullanıcının hem profilinin gittiğini göster (0 satır dönmeli)
SELECT * FROM users WHERE email='demo.kullanici@mail.com';
```

Bu, hem **kullanıcı ekleme/silme** hem de **foreign key + CASCADE bütünlüğünü** canlı kanıtlar.

## E-R Diyagramı (sunum slaytı için)
- https://dbdiagram.io → `schema.dbml` içeriğini yapıştır → otomatik diyagram → **Export PDF/PNG**.

## Sorun Giderme
- **Workbench bağlanamıyor:** `start_mysql.bat` çalışıyor mu kontrol et.
- **Sunucu kapanmıyor / kilitli:** `stop_mysql.bat` ile durdur, sonra tekrar başlat.
- **Veriyi bozdum:** `reset_database.bat` ile sıfırla.
