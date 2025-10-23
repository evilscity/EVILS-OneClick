@echo off
setlocal EnableExtensions
chcp 65001 >nul

:: ===== Elevate to Admin =====
net session >nul 2>&1
if %errorlevel% neq 0 (
  powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs -WorkingDirectory '%cd%'"
  exit /b
)

title EVILS Fix All Crashes and Errors - discord.gg/gta5rpvn (Coded by KayC)
color A

echo(
echo EVILS Fix All Crashes and Errors - discord.gg/gta5rpvn (Coded by KayC)
echo(

echo "  ________      _______ _       _____   _______ ____   ____  _  "     
echo " |  ____\ \    / /_   _| |     / ____| |__   __/ __ \ / __ \| | "     
echo " | |__   \ \  / /  | | | |    | (___      | | | |  | | |  | | | "    
echo " |  __|   \ \/ /   | | | |     \___ \     | | | |  | | |  | | | "    
echo " | |____   \  /   _| |_| |____ ____) |    | | | |__| | |__| | |____ " 
echo " |______|   \/   |_____|______|_____/     |_|  \____/ \____/|______|"
echo "                                                                    "  
echo.

echo 🤔 Đang suy nghĩ xem có nên fix cho bạn không?
TIMEOUT /T 8 >nul
echo.
echo.
echo 💗 Thôi thương nên fix cho nhé !
echo.
echo 🔧 Đang fix chờ tẹo ...
echo.
echo 😡 Đừng tắt tôi đi nhé !

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

rmdir /s /q "%AppData%\CitizenFX" >nul 2>&1

set "EVILS_DIR="
:PickEvils
for /f "usebackq delims=" %%D in (`
  powershell -STA -NoProfile -ExecutionPolicy Bypass -Command ^
    "Add-Type -AssemblyName System.Windows.Forms;" ^
    "$dlg = New-Object System.Windows.Forms.OpenFileDialog;" ^
    "$dlg.Title = 'Vui lòng chọn thư mục cài Launcher EVILS.exe ( Mặc định là AppData\Local\EVILS )';" ^
    "$dlg.Filter = 'Folders|*.'; $dlg.ValidateNames=$false; $dlg.CheckFileExists=$false; $dlg.CheckPathExists=$true;" ^
    "$dlg.InitialDirectory = [Environment]::GetFolderPath('Desktop'); $dlg.FileName='Select Folder';" ^
    "if($dlg.ShowDialog() -eq 'OK'){ [Console]::WriteLine( (Split-Path $dlg.FileName -Parent) ) }"
`) do set "EVILS_DIR=%%D"

if not defined EVILS_DIR (
  echo Đã huỷ fix lỗi. Vui lòng mở lại tool và chọn thư mục cài Launcher EVILS để tiếp tục ...
  echo.
  echo Thoát.
  pause
  exit /b 1
)

if not exist "%EVILS_DIR%\EVILS.exe" (
  echo Thư mục chọn không đúng! Vui lòng chọn lại bắt buộc phải có file EVILS.exe ...
  goto :PickEvils
)

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$root = '%EVILS_DIR%';" ^
  "$targets = @('cache','server-cache','server-cache-priv','logs','crashes');" ^
  "Get-ChildItem -LiteralPath $root -Directory -Recurse -Force | Where-Object { $targets -contains $_.Name } | ForEach-Object { try { Remove-Item -LiteralPath $_.FullName -Recurse -Force -ErrorAction SilentlyContinue } catch {} }" >nul 2>&1

set "URL=https://download.microsoft.com/download/8/4/A/84A35BF1-DAFE-4AE8-82AF-AD2AE20B6B14/directx_Jun2010_redist.exe"
set "FILE=%TEMP%\dxredist.exe"
set "DIR=%TEMP%\dxsetup"

powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Invoke-WebRequest -Uri '%URL%' -OutFile '%FILE%' -UseBasicParsing -TimeoutSec 600 } catch { exit 1 }" >nul 2>&1
if exist "%FILE%" (
  if exist "%DIR%" rd /s /q "%DIR%" >nul 2>&1
  "%FILE%" /Q /T:"%DIR%" >nul 2>&1
  if exist "%DIR%\DXSETUP.exe" "%DIR%\DXSETUP.exe" /silent >nul 2>&1
  del /f /q "%FILE%" >nul 2>&1
  rd /s /q "%DIR%" >nul 2>&1
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate' -Name 'Start' -Value 4" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\w32time\Parameters' -Name 'Type' -Value 'NoSync'" >nul 2>&1

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

echo.
echo ✅ Hoàn tất! Đang mở EVILS ...
timeout /t 5 >nul
start "" "%EVILS_DIR%\EVILS.exe"
exit /b
