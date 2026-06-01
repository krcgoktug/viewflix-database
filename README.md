# VIEWFLIX - Database Project

Movie & series streaming platform database. 11 tables (3NF), ~228 sample rows.

## Files
| File | What it is |
|------|------------|
| `schema.dbml` | E-R diagram source (for dbdiagram.io) |
| `01_create_tables.sql` | All tables (PK, FK, UNIQUE, NOT NULL, CHECK) |
| `02_sample_data.sql` | ~228 sample rows |
| `03_dml_operations.sql` | 14 DML statements (INSERT / UPDATE / DELETE) |
| `04_queries.sql` | 5 simple + 5 complex + 5 aggregation queries |
| `online_full.sql` | Same schema + data as one file for online SQL tools |
| `report.pdf` / `report.docx` | 2-page project report |

## 1) E-R diagram (dbdiagram.io)
1. Open https://dbdiagram.io and click "Go to App".
2. Clear the editor and paste the contents of `schema.dbml`.
3. The diagram is drawn automatically. Use Export to save as PNG/PDF.

## 2) Run the database (MySQL Workbench)
1. Open MySQL Workbench and connect to your server.
2. Open and run the files in order:
   `01_create_tables.sql` -> `02_sample_data.sql` -> `03_dml_operations.sql` -> `04_queries.sql`
3. Results show in the bottom panel.

> CHECK constraints need MySQL 8.0.16+.

## 3) Run online (no install)
Open https://www.db-fiddle.com, set the engine to MySQL 8.0, paste `online_full.sql`
into the left "Schema SQL" box, write a query in the right box, and click Run.

## Testing
All SQL files were run on a real MySQL 8.4 server with foreign key checks on
(schema + ~228 rows + 14 DML + 12 queries), with no errors.
