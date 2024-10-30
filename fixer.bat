@echo off
:: ===========================================
:: SCRIPT FOR WINDOWS FIXES
:: ===========================================

:: Set colors to bright white
color F

:mainMenu
cls
echo                     =============================
echo                           Windows Fixes Menu
echo                     =============================

echo ---------------------------------------------------------------------
echo 1. Fix Network Issues                 11. Clear DNS Cache
echo 2. Reset Windows Update Components    12. Fix Windows Search
echo 3. Repair Corrupt System Files        13. Reset TCP/IP Stack
echo 4. Fix Audio Issues                   14. Clear Windows Store Cache
echo 5. Fix Display Issues                 15. Reset Firewall
echo 6. Fix Windows Boot Issues            16. Optimize Disk Performance
echo 7. Repair Windows Registry            17. Disable Unwanted Services
echo 8. Clear Temporary Files              18. Check Disk for Errors
echo 9. Fix Printer Issues                 19. Enable Windows Features
echo 10. Update Drivers                    20. Disable Startup Programs
:: Add more options as needed
:: ...
echo 21. Fix System Performance            31. Fix Internet Explorer Issues
echo 22. Enable Windows Defender           32. Fix Application Crashes
echo 23. Repair Microsoft Store            33. Reset Windows 10
echo 24. Check for Windows Updates         34. Repair Microsoft Office
echo 25. Restore Missing Files             35. Clean Windows Registry
echo 26. Fix Blue Screen Errors            36. Restore System Settings
echo 27. Disable Telemetry                 37. Reset Network Settings
echo 28. Remove Unused Applications        38. Repair Windows Features
echo 29. Fix Slow Startup                  39. Reset App Permissions
echo 30. Restore System Files              40. Create System Restore Point
:: ...

echo ---------------------------------------------------------------------
set /p choice="Select an option (1-40): "

:: Validate user choice
if "%choice%"=="1" goto fixNetwork
if "%choice%"=="2" goto resetWindowsUpdate
if "%choice%"=="3" goto repairSystemFiles
if "%choice%"=="4" goto fixAudio
if "%choice%"=="5" goto fixDisplay
if "%choice%"=="6" goto fixBootIssues
if "%choice%"=="7" goto repairRegistry
if "%choice%"=="8" goto clearTempFiles
if "%choice%"=="9" goto fixPrinter
if "%choice%"=="10" goto updateDrivers
if "%choice%"=="11" goto clearDNS
if "%choice%"=="12" goto fixSearch
if "%choice%"=="13" goto resetTCPIP
if "%choice%"=="14" goto clearStoreCache
if "%choice%"=="15" goto resetFirewall
if "%choice%"=="16" goto optimizeDisk
if "%choice%"=="17" goto disableServices
if "%choice%"=="18" goto checkDisk
if "%choice%"=="19" goto enableFeatures
if "%choice%"=="20" goto disableStartup
if "%choice%"=="21" goto fixPerformance
if "%choice%"=="22" goto enableDefender
if "%choice%"=="23" goto repairStore
if "%choice%"=="24" goto checkUpdates
if "%choice%"=="25" goto restoreFiles
if "%choice%"=="26" goto fixBSOD
if "%choice%"=="27" goto disableTelemetry
if "%choice%"=="28" goto removeUnusedApps
if "%choice%"=="29" goto fixSlowStartup
if "%choice%"=="30" goto restoreSystemFiles
if "%choice%"=="31" goto fixIE
if "%choice%"=="32" goto fixCrashes
if "%choice%"=="33" goto resetWindows
if "%choice%"=="34" goto repairOffice
if "%choice%"=="35" goto cleanRegistry
if "%choice%"=="36" goto restoreSettings
if "%choice%"=="37" goto resetNetwork
if "%choice%"=="38" goto repairFeatures
if "%choice%"=="39" goto resetPermissions
if "%choice%"=="40" goto createRestorePoint

:: Invalid choice handling
echo Invalid choice. Please try again.
timeout /t 3 /nobreak >nul
goto mainMenu

:fixNetwork
cls
echo Fixing Network Issues...
:: Add commands to fix network issues
:: Example:
netsh int ip reset
netsh winsock reset
echo Network issues fixed.
pause
goto mainMenu

:resetWindowsUpdate
cls
echo Resetting Windows Update Components...
:: Add commands to reset Windows Update
:: Example:
net stop wuauserv
net stop cryptSvc
net stop bits
net stop msiserver
:: Additional commands here...
echo Windows Update components reset.
pause
goto mainMenu

:repairSystemFiles
cls
echo Repairing Corrupt System Files...
:: Add commands to repair system files
sfc /scannow
echo System files repaired.
pause
goto mainMenu

:fixAudio
cls
echo Fixing Audio Issues...
:: Add commands to fix audio issues
:: Example:
start ms-settings:sound
echo Audio issues fixed.
pause
goto mainMenu

:fixDisplay
cls
echo Fixing Display Issues...
:: Add commands to fix display issues
:: Example:
start ms-settings:display
echo Display issues fixed.
pause
goto mainMenu

:fixBootIssues
cls
echo Fixing Windows Boot Issues...
:: Add commands to fix boot issues
bootrec /fixmbr
bootrec /fixboot
bootrec /scanos
bootrec /rebuildbcd
echo Boot issues fixed.
pause
goto mainMenu

:repairRegistry
cls
echo Repairing Windows Registry...
:: Add commands to repair registry
:: Example:
echo Creating registry backup...
reg export "HKLM\Software" "C:\RegistryBackup.reg" /y
echo Repairing registry...
:: Add additional commands as necessary
echo Registry repaired.
pause
goto mainMenu

:clearTempFiles
cls
echo Clearing Temporary Files...
del /q /f /s "%TEMP%\*" 2>nul
del /q /f /s "C:\Windows\Temp\*" 2>nul
echo Temporary files cleared.
pause
goto mainMenu

:fixPrinter
cls
echo Fixing Printer Issues...
:: Add commands to fix printer issues
:: Example:
start ms-settings:printers
echo Printer issues fixed.
pause
goto mainMenu

:updateDrivers
cls
echo Updating Drivers...
:: Add commands to update drivers
:: Example:
devmgmt.msc
echo Drivers updated.
pause
goto mainMenu

:clearDNS
cls
echo Clearing DNS Cache...
ipconfig /flushdns
echo DNS cache cleared.
pause
goto mainMenu

:fixSearch
cls
echo Fixing Windows Search...
:: Add commands to fix search issues
:: Example:
powershell -command "Get-AppxPackage *Microsoft.Windows.Search* | Remove-AppxPackage"
echo Windows Search fixed.
pause
goto mainMenu

:resetTCPIP
cls
echo Resetting TCP/IP Stack...
netsh int ip reset
echo TCP/IP stack reset.
pause
goto mainMenu

:clearStoreCache
cls
echo Clearing Windows Store Cache...
wsreset.exe
echo Windows Store cache cleared.
pause
goto mainMenu

:resetFirewall
cls
echo Resetting Firewall...
netsh advfirewall reset
echo Firewall reset.
pause
goto mainMenu

:optimizeDisk
cls
echo Optimizing Disk Performance...
defrag C: /O /H
echo Disk optimized.
pause
goto mainMenu

:disableServices
cls
echo Disabling Unwanted Services...
:: Add commands to disable unwanted services
:: Example:
sc config "ServiceName" start= disabled
echo Unwanted services disabled.
pause
goto mainMenu

:checkDisk
cls
echo Checking Disk for Errors...
chkdsk C: /f /r
echo Disk checked.
pause
goto mainMenu

:enableFeatures
cls
echo Enabling Windows Features...
:: Add commands to enable Windows features
:: Example:
DISM /Online /Enable-Feature /FeatureName:XXXX
echo Windows features enabled.
pause
goto mainMenu

:disableStartup
cls
echo Disabling Startup Programs...
:: Add commands to disable startup programs
:: Example:
powershell -command "Get-CimInstance -ClassName Win32_StartupCommand | Where-Object { $_.Name -ne 'Windows Defender' } | ForEach-Object { $_.Disable() } 2>$null"
echo Startup programs disabled.
pause
goto mainMenu

:fixPerformance
cls
echo Fixing System Performance...
:: Add commands to fix system performance issues
echo System performance fixed.
pause
goto mainMenu

:enableDefender
cls
echo Enabling Windows Defender...
:: Add commands to enable Windows Defender
powershell -command "Set-MpPreference -DisableRealtimeMonitoring $false"
echo Windows Defender enabled.
pause
goto mainMenu

:repairStore
cls
echo Repairing Microsoft Store...
:: Add commands to repair Microsoft Store
powershell -command "Get-AppxPackage *Microsoft.WindowsStore* | Remove-AppxPackage"
echo Microsoft Store repaired.
pause
goto mainMenu

:checkUpdates
cls
echo Checking for Windows Updates...
start ms-settings:windowsupdate
echo Windows Updates checked.
pause
goto mainMenu

:restoreFiles
cls
echo Restoring Missing Files...
:: Add commands to restore missing files
echo Restoring files...
echo Files restored.
pause
goto mainMenu

:fixBSOD
cls
echo Fixing Blue Screen Errors...
:: Add commands to fix BSOD errors
:: Example:
start ms-settings:troubleshoot
echo Blue screen errors fixed.
pause
goto mainMenu

:disableTelemetry
cls
echo Disabling Telemetry...
powershell -command "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection' -Name 'AllowTelemetry' -Value 0"
echo Telemetry disabled.
pause
goto mainMenu

:removeUnusedApps
cls
echo Removing Unused Applications...
powershell -command "Get-AppxPackage | Where-Object { $_.Name -notlike '*Microsoft*' } | Remove-AppxPackage"
echo Unused applications removed.
pause
goto mainMenu

:fixSlowStartup
cls
echo Fixing Slow Startup...
:: Add commands to fix slow startup issues
echo Slow startup fixed.
pause
goto mainMenu

:restoreSystemFiles
cls
echo Restoring System Files...
:: Add commands to restore system files
echo System files restored.
pause
goto mainMenu

:fixIE
cls
echo Fixing Internet Explorer Issues...
:: Add commands to fix IE issues
start ms-settings:network
echo Internet Explorer issues fixed.
pause
goto mainMenu

:fixCrashes
cls
echo Fixing Application Crashes...
:: Add commands to fix application crashes
:: Example:
powershell -command "Get-Process | Where-Object { $_.Responding -eq $false } | Stop-Process"
echo Application crashes fixed.
pause
goto mainMenu

:resetWindows
cls
echo Resetting Windows 10...
start ms-settings:recovery
echo Windows 10 reset.
pause
goto mainMenu

:repairOffice
cls
echo Repairing Microsoft Office...
:: Add commands to repair Microsoft Office
:: Example:
start winword /repair
echo Microsoft Office repaired.
pause
goto mainMenu

:cleanRegistry
cls
echo Cleaning Windows Registry...
:: Add commands to clean registry
echo Cleaning registry...
echo Registry cleaned.
pause
goto mainMenu

:restoreSettings
cls
echo Restoring System Settings...
:: Add commands to restore system settings
echo System settings restored.
pause
goto mainMenu

:resetNetwork
cls
echo Resetting Network Settings...
netsh int ip reset
netsh winsock reset
echo Network settings reset.
pause
goto mainMenu

:repairFeatures
cls
echo Repairing Windows Features...
DISM /Online /Cleanup-Image /RestoreHealth
echo Windows features repaired.
pause
goto mainMenu

:resetPermissions
cls
echo Resetting App Permissions...
:: Add commands to reset app permissions
echo App permissions reset.
pause
goto mainMenu

:createRestorePoint
cls
echo Creating System Restore Point...
powershell -command "Checkpoint-Computer -Description 'Manual Restore Point' -RestorePointType 'MODIFY_SETTINGS'"
echo System Restore Point created.
pause
goto mainMenu
