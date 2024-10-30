@echo off
:: ===========================================
:: SCRIPT FOR OPTIMIZING WINDOWS 10
:: ===========================================

:: Set colors to bright white
color F

:: Ask user to create a restore point
:askRestorePoint
cls
echo ==============================
echo    Create Restore Point?
echo ==============================
echo Would you like to create a restore point?
set /p choice="Select an option (y/n): "

if /i "%choice%"=="y" (
    echo Creating restore point...
    powershell -command "Checkpoint-Computer -Description 'Restore Point from Windows Tweaker' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction SilentlyContinue"
    echo Restore point created.
) else if /i "%choice%"=="n" (
    echo Skipping restore point creation.
) else (
    echo Invalid choice. Please try again.
    timeout /t 3 /nobreak >nul
    goto askRestorePoint
)

goto mainMenu

:mainMenu
cls
echo                     =============================
echo                     Windows Tweaker by MiHaTsKiYi
echo                     =============================

echo ---------------------------------------------------------------------
echo 1. Clean System                5. Debloat Windows
echo 2. Optimize Settings           6. Manage Startup Programs
echo 3. Configure Privacy           7. Optimize Network Settings
echo 4. Disable Telemetry           8. Clean Registry
echo ---------------------------------------------------------------------
echo                            9. Use Restore Point
echo                           10. Exit
echo ---------------------------------------------------------------------
set /p choice="Select an option (1-10): "

:: Validate user choice
if "%choice%"=="1" goto cleanSystem
if "%choice%"=="2" goto optimizeSettings
if "%choice%"=="3" goto configurePrivacy
if "%choice%"=="4" goto disableTelemetry
if "%choice%"=="5" goto debloatWindows
if "%choice%"=="6" goto manageStartup
if "%choice%"=="7" goto optimizeNetwork
if "%choice%"=="8" goto cleanRegistry
if "%choice%"=="9" goto useRestorePoint
if "%choice%"=="10" goto confirmExit

:: Invalid choice handling
echo Invalid choice. Please try again.
timeout /t 3 /nobreak >nul
goto mainMenu

:cleanSystem
cls
echo Cleaning System...
echo ==========================
echo Deleting temporary files...
del /q /f /s "%TEMP%\*" 2>nul
del /q /f /s "C:\Windows\Temp\*" 2>nul
del /q /f /s "C:\Windows\SoftwareDistribution\Download\*" 2>nul
del /q /f /s "C:\Users\%username%\AppData\Local\Temp\*" 2>nul

echo Cleaning up the Recycle Bin...
rd /s /q "C:\$Recycle.Bin" 2>nul

echo Deleting old Windows installations...
rd /s /q "C:\Windows.old" 2>nul

echo Deleting previous Windows update files...
dism /Online /Cleanup-Image /StartComponentCleanup 2>nul

echo Clearing prefetch files...
del /q /f /s "C:\Windows\Prefetch\*" 2>nul

echo Clearing system logs...
wevtutil cl Application 2>nul
wevtutil cl Security 2>nul
wevtutil cl System 2>nul

echo Cleaning up Windows Update cache...
net stop wuauserv 2>nul
del /q /f /s "C:\Windows\SoftwareDistribution\*" 2>nul
net start wuauserv 2>nul

echo Clearing browser caches...
:: Google Chrome
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache" (
    rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache"
)

:: Mozilla Firefox
if exist "%APPDATA%\Mozilla\Firefox\Profiles\*" (
    for /d %%D in ("%APPDATA%\Mozilla\Firefox\Profiles\*") do (
        rd /s /q "%%D\cache2"
    )
)

:: Microsoft Edge
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache" (
    rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache"
)

:: Opera
if exist "%APPDATA%\Opera Software\Opera Stable\Cache" (
    rd /s /q "%APPDATA%\Opera Software\Opera Stable\Cache"
)

:: Additional cleanup for third-party apps
echo Clearing additional application caches...
if exist "%LOCALAPPDATA%\Microsoft\WindowsApps\*" (
    rd /s /q "%LOCALAPPDATA%\Microsoft\WindowsApps"
)

echo System cleaning completed.
echo ==========================
pause
goto mainMenu

:optimizeSettings
cls
echo Optimizing Settings...
echo ==========================
echo Disabling Bluetooth...
powershell -command "Get-Service -Name bthserv -ErrorAction SilentlyContinue | Stop-Service -Force; Set-Service -Name bthserv -StartupType Disabled 2>$null"

echo Disabling Windows Update...
powershell -command "Get-Service -Name wuauserv -ErrorAction SilentlyContinue | Stop-Service -Force; Set-Service -Name wuauserv -StartupType Disabled 2>$null"

echo Disabling OneDrive...
powershell -command "Stop-Process -Name OneDrive -Force -ErrorAction SilentlyContinue; Get-AppxPackage -AllUsers *OneDrive* | Remove-AppxPackage 2>$null"

echo Disabling Cortana...
powershell -command "Get-AppxPackage -AllUsers *Cortana* | Remove-AppxPackage 2>$null"

echo Disabling background applications...
powershell -command "Get-StartApps | Where-Object { $_.Name -notlike '*Windows Explorer*' } | ForEach-Object { Stop-Process -Name $_.Name -Force 2>$null }"

echo Disabling Windows Search...
powershell -command "Get-Service -Name WSearch -ErrorAction SilentlyContinue | Stop-Service -Force; Set-Service -Name WSearch -StartupType Disabled 2>$null"

echo Disabling automatic maintenance...
powershell -command "Get-Service -Name maintenance -ErrorAction SilentlyContinue | Stop-Service -Force; Set-Service -Name maintenance -StartupType Disabled 2>$null"

echo Disabling Delivery Optimization...
powershell -command "Set-Service -Name DoSvc -StartupType Disabled; Stop-Service -Name DoSvc -ErrorAction SilentlyContinue"

echo Disabling App Readiness...
powershell -command "Get-Service -Name AppReadiness -ErrorAction SilentlyContinue | Stop-Service -Force; Set-Service -Name AppReadiness -StartupType Disabled 2>$null"

echo Disabling SysMain (Superfetch)...
powershell -command "Get-Service -Name SysMain -ErrorAction SilentlyContinue | Stop-Service -Force; Set-Service -Name SysMain -StartupType Disabled 2>$null"

echo Disabling unnecessary startup programs...
powershell -command "Get-CimInstance -ClassName Win32_StartupCommand | Where-Object { $_.Name -ne 'Windows Defender' } | ForEach-Object { $_.Disable() } 2>$null"

echo Disabling visual effects...
powershell -command "Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'VisualFXSetting' -Value '2'"

echo Disabling Hibernation...
powercfg -h off

echo Disabling Windows tips...
powershell -command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowSyncProviderNotifications' -Value 0"

echo Setting power plan to High Performance...
powercfg -setactive SCHEME_MIN

echo Disabling Windows Error Reporting...
powershell -command "Set-Service -Name WerSvc -StartupType Disabled; Stop-Service -Name WerSvc -ErrorAction SilentlyContinue 2>$null"

:: Additional optimization
echo Adjusting network throttling...
powershell -command "Set-NetTCPSetting -SettingName InternetCustom -AutoTuningLevel Disabled"

:: Disabling unnecessary visual effects
powershell -command "Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -Value 0x00000000 2>$null"

:: Enabling high-performance mode for USB
echo Enabling high-performance mode for USB devices...
powershell -command "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Power' -Name 'CsEnabled' -Value 0"

echo Optimizations completed.
echo ==========================
pause
goto mainMenu

:configurePrivacy
cls
echo Configuring Privacy Settings...
echo ==========================
powershell -command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy' -Name 'WindowsSpotlight' -Value 0 2>$null"

echo Disabling location services...
powershell -command "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location' -Name 'Value' -Value 0 2>$null"

echo Disabling advertising ID...
powershell -command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo' -Name 'Enabled' -Value 0 2>$null"

echo Disabling Feedback Notifications...
powershell -command "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feedback' -Name 'Enabled' -Value 0 2>$null"

echo Disabling activity history...
powershell -command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'SendDiagnosticData' -Value 0 2>$null"

echo Disabling Windows Ink Workspace...
powershell -command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows Ink Workspace' -Name 'Enabled' -Value 0 2>$null"

echo Privacy settings configured.
echo ==========================
pause
goto mainMenu

:disableTelemetry
cls
echo Disabling Telemetry...
echo ==========================
powershell -command "Set-Service -Name dmwappuserv -StartupType Disabled; Stop-Service -Name dmwappuserv -ErrorAction SilentlyContinue"
powershell -command "Set-Service -Name DiagnosticsTracking -StartupType Disabled; Stop-Service -Name DiagnosticsTracking -ErrorAction SilentlyContinue"
powershell -command "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection' -Name 'AllowTelemetry' -Value 0 2>$null"
powershell -command "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection' -Name 'LimitDiagnosticData' -Value 0 2>$null"
powershell -command "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection' -Name 'SendPersonalData' -Value 0 2>$null"

echo All telemetry has been disabled.
echo ==========================
pause
goto mainMenu

:debloatWindows
cls
echo Debloating Windows...
echo ==========================
:: Remove built-in apps
echo Removing unnecessary built-in apps...
powershell -command "Get-AppxPackage -AllUsers | Where-Object { $_.Name -notlike '*Microsoft.*' -and $_.Name -notlike '*Windows.*' } | Remove-AppxPackage"

echo Windows debloat completed.
echo ==========================
pause
goto mainMenu

:manageStartup
cls
echo Managing Startup Programs...
echo ==========================
echo 1. Enable All
echo 2. Disable All
echo 3. List Current Startup Programs
echo 4. Back to Main Menu
echo ==========================
set /p choice="Select an option (1-4): "

if "%choice%"=="1" (
    echo Enabling all startup programs...
    powershell -command "Get-CimInstance -ClassName Win32_StartupCommand | ForEach-Object { $_.Enable() } 2>$null"
    echo All startup programs have been enabled.
) else if "%choice%"=="2" (
    echo Disabling all startup programs...
    powershell -command "Get-CimInstance -ClassName Win32_StartupCommand | ForEach-Object { $_.Disable() } 2>$null"
    echo All startup programs have been disabled.
) else if "%choice%"=="3" (
    echo Listing current startup programs...
    powershell -command "Get-CimInstance -ClassName Win32_StartupCommand | Select-Object Name, Command"
    pause
    goto manageStartup
) else if "%choice%"=="4" (
    goto mainMenu
) else (
    echo Invalid choice. Please try again.
    timeout /t 3 /nobreak >nul
    goto manageStartup
)

:optimizeNetwork
cls
echo Optimizing Network Settings...
echo ==========================
echo Disabling large send offload...
netsh int tcp set global autotuninglevel=disabled
netsh int tcp set global dca=disabled

echo Enabling TCP window scaling...
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global rss=enabled

echo Disabling IPv6 (if not needed)...
powershell -command "Set-NetAdapterBinding -Name '*' -ComponentID ms_tcpip6 -Enabled $false"

echo Optimizing network throttling...
powershell -command "Set-NetTCPSetting -SettingName InternetCustom -AutoTuningLevel Disabled"

echo Network optimizations completed.
echo ==========================
pause
goto mainMenu

:cleanRegistry
cls
echo Cleaning Registry...
echo ==========================
echo This process will remove unnecessary registry entries. Please proceed with caution!
pause

:: Backup the registry before cleaning
echo Backing up the registry...
reg export "HKLM\Software" "C:\RegistryBackup.reg" /y 2>nul

:: Cleaning the registry
echo Cleaning unnecessary registry entries...
powershell -command "Get-ChildItem 'HKLM:\Software\' | Where-Object { $_.Name -notlike '*Microsoft*' -and $_.Name -notlike '*Windows*' } | Remove-Item -Recurse -Force 2>$null"

echo Registry cleaning completed.
echo ==========================
pause
goto mainMenu

:useRestorePoint
cls
echo ==============================
echo    Using Restore Point
echo ==============================
echo Please ensure you have a restore point created before using this option.
echo Starting system restore process...
rstrui.exe
echo ==========================
pause
goto mainMenu

:confirmExit
cls
echo Are you sure you want to exit? (y/n)
set /p choice="Select an option: "

if /i "%choice%"=="y" (
    exit
) else (
    goto mainMenu
)
