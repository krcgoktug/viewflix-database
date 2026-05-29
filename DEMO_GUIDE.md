# STREAMFLIX - Live Demo Guide

MySQL Server 8.4 is installed and the STREAMFLIX database is loaded (11 tables, ~228 rows).

## Connection
| Setting | Value |
|---------|-------|
| Host | `localhost` (127.0.0.1) |
| Port | `3306` |
| User | `root` |
| Password | `Streamflix2026` |
| Database | `streamflix` |

## Before the demo
1. Double-click `start_mysql.bat` to start the server (do this after any reboot).
2. Open MySQL Workbench and connect with the details above.
3. If you changed data while practicing, run `reset_database.bat` to reload the clean ~228 rows.

## Demo flow (run in order in Workbench)
1. `01_create_tables.sql` - the tables.
2. `02_sample_data.sql` - sample rows.
3. `04_queries.sql` - 5 simple + 7 complex queries.
4. `03_dml_operations.sql` - INSERT / UPDATE / DELETE examples.

To run SQL: select it and click the lightning icon. Results show in the bottom panel.

## Live add / delete (what the instructor asked for)
Type and run this during the demo:

```sql
USE streamflix;

-- current users
SELECT user_id, first_name, last_name, email FROM users ORDER BY user_id DESC LIMIT 5;

-- add a user
INSERT INTO users (email, password_hash, first_name, last_name, birth_date, country, account_status)
VALUES ('demo.user@mail.com', 'hash123', 'Demo', 'User', '2000-01-01', 'Turkey', 'Active');

SELECT user_id, first_name, last_name, email FROM users WHERE email='demo.user@mail.com';

-- add a favorite for them (to show cascade)
INSERT INTO favorites (user_id, content_id)
VALUES ((SELECT user_id FROM users WHERE email='demo.user@mail.com'), 1);

-- delete the user -> ON DELETE CASCADE also removes their favorite
DELETE FROM users WHERE email='demo.user@mail.com';

-- both are gone (returns 0 rows)
SELECT * FROM users WHERE email='demo.user@mail.com';
```

This shows live add/delete plus foreign key cascade.

## Normalization (live)
Open and run `normalization_demo.sql` to show a redundant flat table and the same data
split into a clean 3NF design.

## E-R diagram
Open https://dbdiagram.io, paste `schema.dbml`, then Export to PNG/PDF.
Or in Workbench: Database -> Reverse Engineer (Ctrl+R) -> pick `streamflix` to get an EER diagram of the live database.

## Troubleshooting
- Workbench can't connect: make sure `start_mysql.bat` is running.
- Server won't stop: run `stop_mysql.bat`.
- Broke the data: run `reset_database.bat`.
