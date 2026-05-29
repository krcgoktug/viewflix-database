@echo off
REM ===== STREAMFLIX veritabanini temiz haline sifirlar (426 kayit) =====
set MYSQLEXE="C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe"
echo Veritabani sifirlaniyor (01 + 02 yeniden yukleniyor)...
%MYSQLEXE% -u root -pStreamflix2026 < "%~dp001_create_tables.sql"
%MYSQLEXE% -u root -pStreamflix2026 < "%~dp002_sample_data.sql"
echo Tamamlandi. Veritabani temiz baseline'da (426 kayit).
pause
