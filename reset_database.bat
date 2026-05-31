@echo off
REM ===== Reset VIEWFLIX to the clean baseline =====
set MYSQLEXE="C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe"
echo Resetting database (reloading 01 + 02)...
%MYSQLEXE% -u root -pViewflix2026 < "%~dp001_create_tables.sql"
%MYSQLEXE% -u root -pViewflix2026 < "%~dp002_sample_data.sql"
echo Done. Database is back to the clean baseline (~228 rows).
pause
