@echo off
chcp 65001 > nul

net session >nul 2>&1 || (powershell -Command "Start-Process '%~f0' -Verb RunAs" & exit)

title Evils Fix All Crashes and Errors - discord.gg/gta5rpvn (Coded by KayC)
color A

echo Evils Fix All Crashes and Errors - discord.gg/gta5rpvn (Coded by KayC)
echo.

echo "  ________      _______ _       _____   _______ ____   ____  _  "     
echo " |  ____\ \    / /_   _| |     / ____| |__   __/ __ \ / __ \| | "     
echo " | |__   \ \  / /  | | | |    | (___      | | | |  | | |  | | | "    
echo " |  __|   \ \/ /   | | | |     \___ \     | | | |  | | |  | | | "    
echo " | |____   \  /   _| |_| |____ ____) |    | | | |__| | |__| | |____ " 
echo " |______|   \/   |_____|______|_____/     |_|  \____/ \____/|______|"
echo "                                                                    "  
echo.

echo 🤔 Đang suy nghĩ xem có nên fix cho bạn không?
TIMEOUT /T 10 >nul
echo.
echo.
echo 💗 Thôi thương nên fix cho nhé!
echo.
echo 🔧 Đang fix chờ tẹo ...

takeown /f "%temp%" /r /d y >nul 2>&1
icacls "%temp%" /grant %username%:F /T /C >nul 2>&1
del /f /s /q /a "%temp%\*.*" >nul 2>&1
for /d %%p in ("%temp%\*") do rmdir /s /q "%%p" >nul 2>&1

takeown /f "C:\Windows\Temp" /r /d y >nul 2>&1
icacls "C:\Windows\Temp" /grant Administrators:F /T /C >nul 2>&1
del /f /s /q /a "C:\Windows\Temp\*.*" >nul 2>&1
for /d %%p in ("C:\Windows\Temp\*") do rmdir /s /q "%%p" >nul 2>&1

takeown /f "C:\Windows\Prefetch" /r /d y >nul 2>&1
del /s /f /q /a "C:\Windows\Prefetch\*.*" >nul 2>&1

rmdir /s /q "%LocalAppData%\EVILS\EVILS.app\data\cache" >nul 2>&1
rmdir /s /q "%LocalAppData%\EVILS\EVILS.app\data\server-cache" >nul 2>&1
rmdir /s /q "%LocalAppData%\EVILS\EVILS.app\data\server-cache-priv" >nul 2>&1
rmdir /s /q "%LocalAppData%\EVILS\EVILS.app\logs" >nul 2>&1
rmdir /s /q "%LocalAppData%\EVILS\EVILS.app\crashes" >nul 2>&1

rmdir /s /q "%AppData%\CitizenFX" >nul 2>&1

set "URL=https://download.microsoft.com/download/8/4/A/84A35BF1-DAFE-4AE8-82AF-AD2AE20B6B14/directx_Jun2010_redist.exe"
set "FILE=%TEMP%\dxredist.exe"
set "DIR=%TEMP%\dxsetup"
powershell -Command "Invoke-WebRequest '%URL%' -OutFile '%FILE%' -UseBasicParsing" >nul 2>&1
if exist "%DIR%" rd /s /q "%DIR%" >nul 2>&1
"%FILE%" /Q /T:"%DIR%" >nul 2>&1
"%DIR%\DXSETUP.exe" /silent >nul 2>&1
del /f /q "%FILE%" >nul 2>&1
rd /s /q "%DIR%" >nul 2>&1

powershell -command "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate' -Name 'Start' -Value 4" >nul 2>&1
powershell -command "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\w32time\Parameters' -Name 'Type' -Value 'NoSync'" >nul 2>&1
net stop w32time >nul 2>&1
net start w32time >nul 2>&1
w32tm /config /manualpeerlist:"time.windows.com,0x1" /syncfromflags:manual /reliable:YES /update >nul 2>&1
w32tm /resync /nowait >nul 2>&1
w32tm /query /status | findstr /C:"Stratum" >nul 2>&1
if %errorlevel% neq 0 (
    w32tm /config /manualpeerlist:"time.nist.gov,0x1" /syncfromflags:manual /reliable:YES /update >nul 2>&1
    w32tm /resync /nowait >nul 2>&1
    w32tm /query /status | findstr /C:"Stratum" >nul 2>&1
    if %errorlevel% neq 0 (
        w32tm /config /manualpeerlist:"pool.ntp.org,0x1" /syncfromflags:manual /reliable:YES /update >nul 2>&1
        w32tm /resync /nowait >nul 2>&1
    )
)
w32tm /query /status | findstr /C:"Stratum" >nul 2>&1

echo.
echo ✅ Fix xong rồi, yêu lắm mới fix đó nhé!
echo.
echo Đang vào lại game, chờ tí nhen...
TIMEOUT /T 5 >nul

start "" "%USERPROFILE%\AppData\Local\EVILS\EVILS.exe"