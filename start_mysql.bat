@echo off
REM ===== Start the VIEWFLIX MySQL server =====
echo Starting MySQL server...
start "MySQL-VIEWFLIX" /B "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqld.exe" --datadir="C:\Users\HUAWEI\mysql_data"
timeout /t 3 /nobreak >nul
echo MySQL is running (localhost:3306). You can connect with Workbench.
echo User: root   Password: Viewflix2026
pause
