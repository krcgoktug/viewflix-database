# STREAMFLIX — Veritabanı Projesi · Kullanım Kılavuzu

Dizi & film izleme platformu veritabanı. 22 tablo (3NF), 426+ örnek kayıt.

## Dosyalar
| Dosya | İçerik |
|-------|--------|
| `schema.dbml` | E-R diyagramı (dbdiagram.io için) |
| `01_create_tables.sql` | Tüm tablolar (PK, FK, UNIQUE, NOT NULL, CHECK) |
| `02_sample_data.sql` | 426 örnek kayıt |
| `03_dml_operations.sql` | 14 DML işlemi (INSERT/UPDATE/DELETE) |
| `04_queries.sql` | 5 basit + 7 karmaşık sorgu |
| `report.md` | 4 sayfalık proje raporu (PDF'e çevrilecek) |

## 1) E-R diyagramını oluşturma (dbdiagram.io)
1. https://dbdiagram.io adresine git (ücretsiz, kayıt gerekmez).
2. `schema.dbml` dosyasının içeriğini sol panele yapıştır.
3. Sağda otomatik E-R diyagramı çizilir. **Export → PNG/PDF** ile raporа ekle.

## 2) Veritabanını kurma (MySQL Workbench — canlı demo)
1. MySQL Workbench'i aç, bir bağlantı oluştur.
2. Dosyaları **sırasıyla** aç ve çalıştır (yıldırım ikonu):
   `01_create_tables.sql` → `02_sample_data.sql` → `03_dml_operations.sql` → `04_queries.sql`
3. Sorgu sonuçları alt panelde görünür. Demo için `04_queries.sql` idealdir.

> Not: CHECK kısıtları için **MySQL 8.0.16+** gerekir. SQLite kullanmak isterseniz
> küçük sözdizimi farkları olur (AUTO_INCREMENT → AUTOINCREMENT vb.).

## Doğrulama
Tüm SQL dosyaları, foreign key kontrolü açıkken hatasız çalıştırılarak test edildi
(CREATE + 426 kayıt + 14 DML + 12 sorgu).
