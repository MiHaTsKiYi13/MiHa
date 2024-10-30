@echo off
:: ===========================================
::      WINDOWS 10 OPTIMIZATION SCRIPT
:: ===========================================

:: Set color scheme: light text on black background
color 0F

:: Function to create a restore point
:askRestorePoint
cls
echo.
echo ===========================================
echo          Create Restore Point
echo ===========================================
echo.
set /p choice="Would you like to create a restore point? (y/n): "

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
echo.
echo ===========================================
echo          WINDOWS TWEAKER 
echo         Author: MiHaTsKiYi
echo ===========================================
echo.
echo          * MAIN MENU *
echo.
echo      [1]  Clean System
echo      [2]  Optimize Settings
echo      [3]  Configure Privacy
echo      [4]  Disable Telemetry
echo      [5]  Debloat Windows
echo      [6]  Manage Startup Programs
echo      [7]  Optimize Network Settings
echo      [8]  Clean Registry
echo      [9]  Use Restore Point
echo      [10] Open GitHub Page
echo      [11] Exit
echo.
set /p choice="Select an option (1-11): "

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
if "%choice%"=="10" goto openGitHub
if "%choice%"=="11" goto confirmExit

:: Invalid choice handling
echo Invalid choice. Please try again.
timeout /t 3 /nobreak >nul
goto mainMenu

:cleanSystem
cls
echo.
echo ===========================================
echo          CLEANING SYSTEM
echo ===========================================
echo.
echo Deleting temporary files...
del /q /f /s "%TEMP%\*" 2>nul
del /q /f /s "C:\Windows\Temp\*" 2>nul
del /q /f /s "C:\Windows\SoftwareDistribution\Download\*" 2>nul
del /q /f /s "C:\Users\%username%\AppData\Local\Temp\*" 2>nul

echo Cleaning up the Recycle Bin...
rd /s /q "C:\$Recycle.Bin" 2>nul

echo Deleting old Windows installations...
rd /s /q "C:\Windows.old" 2>nul

echo Cleaning up Windows Update cache...
dism /Online /Cleanup-Image /StartComponentCleanup 2>nul

echo Clearing prefetch files...
del /q /f /s "C:\Windows\Prefetch\*" 2>nul

echo Clearing system logs...
wevtutil cl Application 2>nul
wevtutil cl Security 2>nul
wevtutil cl System 2>nul

echo Optimizing Disk Space...
powershell -command "Optimize-Volume -DriveLetter C -Defrag -Verbose"

echo Cleaning up system files...
cleanmgr /sagerun:1

echo System cleaning completed.
echo ==========================
pause
goto mainMenu

:optimizeSettings
cls
echo.
echo ===========================================
echo          OPTIMIZING SETTINGS
echo ===========================================
echo.
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

echo Setting power plan to High Performance...
powercfg -setactive SCHEME_MIN

echo Disabling automatic driver updates...
powershell -command "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching' -Name 'SearchOrderConfig' -Value 0 2>$null"

echo Disabling Superfetch...
powershell -command "Get-Service -Name SysMain -ErrorAction SilentlyContinue | Stop-Service -Force; Set-Service -Name SysMain -StartupType Disabled 2>$null"

echo Enabling 'Do Not Disturb' mode...
powershell -command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Settings\DoNotDisturb' -Name 'Enabled' -Value 1 2>$null"

echo Disabling Windows Firewall...
powershell -command "Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False 2>$null"

echo Disabling Windows Defender...
powershell -command "Set-MpPreference -DisableRealtimeMonitoring $true 2>$null"

:: Additional Optimization Options
echo Enabling high-performance mode in network settings...
powercfg -setactive SCHEME_MIN

echo Configuring visual effects for performance...
powershell -command "Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -Value 2147483648 2>$null"
powershell -command "Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'VisualFXSetting' -Value 2 2>$null"

:: Additional Optimization Options
echo Enabling high-performance mode in network settings...
powercfg -setactive SCHEME_MIN

echo Configuring visual effects for performance...
powershell -command "Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -Value 2147483648 2>$null"
powershell -command "Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'VisualFXSetting' -Value 2 2>$null"

:: Configure Sleep Settings
echo Configure Sleep Settings:
set /p sleepChoice="Set sleep timeout in minutes (0 to disable): "
if "%sleepChoice%" NEQ "0" (
    powercfg -change -monitor-timeout-ac %sleepChoice%
    powercfg -change -monitor-timeout-dc %sleepChoice%
    powercfg -change -standby-timeout-ac %sleepChoice%
    powercfg -change -standby-timeout-dc %sleepChoice%
) else (
    echo Sleep timeout disabled.
echo Optimizing settings completed.
echo ==========================
pause
goto mainMenu

:configurePrivacy
cls
echo.
echo ===========================================
echo         CONFIGURING PRIVACY
echo ===========================================
echo.
echo Disabling advertising ID...
powershell -command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo' -Name 'Enabled' -Value 0 2>$null"

echo Disabling app diagnostics...
powershell -command "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection' -Name 'AllowTelemetry' -Value 0 2>$null"

echo Configuring privacy settings...
powershell -command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy' -Name 'ID' -Value 0 2>$null"

echo Privacy configuration completed.
echo ==========================
pause
goto mainMenu

:disableTelemetry
cls
echo.
echo ===========================================
echo          DISABLING TELEMETRY
echo ===========================================
echo.
:: Disabling telemetry services
echo Disabling telemetry services...
powershell -command "Get-Service -Name 'DiagTrack' -ErrorAction SilentlyContinue | Stop-Service -Force; Set-Service -Name 'DiagTrack' -StartupType Disabled 2>$null"
powershell -command "Get-Service -Name 'dmwappusermanager' -ErrorAction SilentlyContinue | Stop-Service -Force; Set-Service -Name 'dmwappusermanager' -StartupType Disabled 2>$null"

echo Disabling error reporting...
powershell -command "Set-Service -Name 'WerSvc' -StartupType Disabled -ErrorAction SilentlyContinue"

echo Disabling feedback notifications...
powershell -command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'FeedbackScale' -Value 0 -ErrorAction SilentlyContinue"

echo Disabling connected user experiences and telemetry...
powershell -command "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection' -Name 'AllowTelemetry' -Value 0 -ErrorAction SilentlyContinue"

:: Additional Telemetry Disabling Options
echo Disabling Windows Error Reporting...
powershell -command "Set-Service -Name WerSvc -StartupType Disabled -ErrorAction SilentlyContinue"

echo Disabling user activity history...
powershell -command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'PublishUserActivity' -Value 0 -ErrorAction SilentlyContinue"

echo Disabling app telemetry...
powershell -command "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection' -Name 'AllowAppTelemetry' -Value 0 -ErrorAction SilentlyContinue"

echo Telemetry disabling completed.
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

:: Additional Debloating Options
echo Removing pre-installed applications...
set /p choice="Do you want to remove pre-installed applications? (y/n): "
if /i "%choice%"=="y" (
    echo Removing pre-installed applications...
    powershell -command "Get-AppxPackage -AllUsers | Where-Object { $_.Name -like '*Microsoft.*' -and $_.Name -notlike '*Windows.*' } | Remove-AppxPackage"
    echo Pre-installed applications removed.
) else (
    echo Skipping removal of pre-installed applications.
)

echo Resetting Windows Store...
set /p choice="Do you want to reset Windows Store? (y/n): "
if /i "%choice%"=="y" (
    powershell -command "Get-AppxPackage -allusers Microsoft.StoreApp | Reset-AppxPackage"
    echo Windows Store reset completed.
) else (
    echo Skipping reset of Windows Store.
)

echo Debloating completed.
echo ==========================
pause
goto mainMenu

:manageStartup
cls
echo.
echo ===========================================
echo        MANAGING STARTUP PROGRAMS
echo ===========================================

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
goto manageStartup

:optimizeNetwork
cls
echo.
echo ===========================================
echo        OPTIMIZING NETWORK SETTINGS
echo ===========================================

:: Network optimization settings
echo Optimizing TCP settings...
powershell -command "Set-NetTCPSetting -SettingName InternetCustom -ErrorAction SilentlyContinue"
echo Setting DNS to Google Public DNS...
netsh interface ip set dns "Ethernet" static 8.8.8.8
netsh interface ip add dns "Ethernet" 8.8.4.4 index=2

echo Disabling IPv6...
netsh interface ipv6 set teredo disabled
netsh interface ipv6 set state disabled
echo Optimizing DNS settings...
powershell -command "Set-DnsClient -InterfaceAlias '*' -UseDNSServer '8.8.8.8','8.8.4.4' -ErrorAction SilentlyContinue"

echo Network optimizations completed.
echo ==========================
pause
goto mainMenu

:cleanRegistry
cls
echo.
echo ===========================================
echo          CLEANING REGISTRY
echo ===========================================
echo.
echo Cleaning up registry...
powershell -command "Get-Item -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall | ForEach-Object { Remove-Item $_.PSPath -Recurse -Force -ErrorAction SilentlyContinue }"

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

:openGitHub
start https://github.com/MiHaTsKiYi13/MiHa
goto mainMenu

:confirmExit
cls
echo.
echo Are you sure you want to exit? (y/n)
set /p choice="Your choice (y/n): "
if /i "%choice%"=="y" (
    echo Exiting...
    exit
) else (
    echo Returning to main menu...
    timeout /t 2 /nobreak >nul
    goto mainMenu
)
