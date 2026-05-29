# STREAMFLIX - Live Demo Guide

MySQL Server 8.4 is installed and the STREAMFLIX database is loaded (22 tables, 426 rows).

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
3. If you changed data while practicing, run `reset_database.bat` to reload the clean 426 rows.

## Demo flow (run in order in Workbench)
1. `01_create_tables.sql` - the tables.
2. `02_sample_data.sql` - 426 sample rows.
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
INSERT INTO users (email, password_hash, first_name, last_name, birth_date, country_id, account_status)
VALUES ('demo.user@mail.com', 'hash123', 'Demo', 'User', '2000-01-01', 3, 'Active');

SELECT user_id, first_name, last_name, email FROM users WHERE email='demo.user@mail.com';

-- add a profile for them (to show cascade)
INSERT INTO profiles (user_id, profile_name, is_kids, preferred_language_id)
VALUES ((SELECT user_id FROM users WHERE email='demo.user@mail.com'), 'Demo Profile', FALSE, 1);

-- delete the user -> ON DELETE CASCADE also removes the profile
DELETE FROM users WHERE email='demo.user@mail.com';

-- both are gone (returns 0 rows)
SELECT * FROM users WHERE email='demo.user@mail.com';
```

This shows live add/delete plus foreign key cascade.

## E-R diagram
Open https://dbdiagram.io, paste `schema.dbml`, then Export to PNG/PDF.
Or in Workbench: Database -> Reverse Engineer (Ctrl+R) -> pick `streamflix` to get an EER diagram of the live database.

## Troubleshooting
- Workbench can't connect: make sure `start_mysql.bat` is running.
- Server won't stop: run `stop_mysql.bat`.
- Broke the data: run `reset_database.bat`.
