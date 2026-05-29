@echo off
REM ===== STREAMFLIX MySQL sunucusunu durdurur =====
echo MySQL sunucusu durduruluyor...
"C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqladmin.exe" -u root -pStreamflix2026 shutdown
echo MySQL durduruldu.
pause
