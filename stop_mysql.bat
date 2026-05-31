@echo off
REM ===== Stop the VIEWFLIX MySQL server =====
echo Stopping MySQL server...
"C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqladmin.exe" -u root -pViewflix2026 shutdown
echo MySQL stopped.
pause
