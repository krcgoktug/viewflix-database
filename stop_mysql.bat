@echo off
REM ===== Stop the STREAMFLIX MySQL server =====
echo Stopping MySQL server...
"C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqladmin.exe" -u root -pStreamflix2026 shutdown
echo MySQL stopped.
pause
