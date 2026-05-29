@echo off
REM ===== Start the STREAMFLIX MySQL server =====
echo Starting MySQL server...
start "MySQL-STREAMFLIX" /B "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqld.exe" --datadir="C:\Users\HUAWEI\mysql_data"
timeout /t 3 /nobreak >nul
echo MySQL is running (localhost:3306). You can connect with Workbench.
echo User: root   Password: Streamflix2026
pause
