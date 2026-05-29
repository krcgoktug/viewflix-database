@echo off
REM ===== STREAMFLIX MySQL sunucusunu baslatir =====
echo MySQL sunucusu baslatiliyor...
start "MySQL-STREAMFLIX" /B "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqld.exe" --datadir="C:\Users\HUAWEI\mysql_data"
timeout /t 3 /nobreak >nul
echo MySQL calisiyor (localhost:3306). Workbench ile baglanabilirsiniz.
echo Kullanici: root   Parola: Streamflix2026
pause
