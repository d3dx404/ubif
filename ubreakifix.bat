@echo off
setlocal enabledelayedexpansion

echo Troubleshooting and repairing system issues...
echo Please ensure you are running this batch file with administrative privileges.
echo.

rem === Set variables ===
set BOOTDRIVE=C:
set OFFLINE_IMAGE_DIR=X:\OfflineImage
set WINDOWS_DIR=Windows
set SYSTEM32_DIR=System32

rem === Check and repair the boot configuration data (BCD) ===
echo Repairing the boot configuration data...
bootrec /fixmbr
bootrec /fixboot
bootrec /scanos
bootrec /rebuildbcd
if %errorlevel% neq 0 (
    echo Error repairing the BCD. Exiting...
    goto end
)
echo BCD repair completed.
echo.

rem === Run System File Checker (SFC) ===
echo Running System File Checker (SFC)...
sfc /scannow /offbootdir=%BOOTDRIVE% /offwindir=%BOOTDRIVE%\%WINDOWS_DIR%
if %errorlevel% neq 0 (
    echo Error running SFC. Exiting...
    goto end
)
echo SFC scan completed.
echo.

rem === Run Deployment Imaging Service and Management Tool (DISM) on offline image ===
echo Running Deployment Imaging Service and Management Tool (DISM) on offline image...
dism /image:%OFFLINE_IMAGE_DIR% /cleanup-image /restorehealth
if %errorlevel% neq 0 (
    echo Error running DISM on the offline image. Exiting...
    goto end
)
echo DISM offline image repair completed.
echo.

rem === Additional steps to troubleshoot boot-loop issues (optional) ===
echo Additional steps to troubleshoot boot-loop issues...
rem Replace BOOTDRIVE with the drive letter of your boot drive (usually C:)
bcdedit /set {bootmgr} displaybootmenu yes
bcdedit /set {bootmgr} timeout 10
bcdedit /set {default} recoveryenabled no
bcdedit /set {default} bootstatuspolicy IgnoreAllFailures
if %errorlevel% neq 0 (
    echo Error applying boot-loop troubleshooting steps. Exiting...
    goto end
)
echo Boot-loop troubleshooting steps completed.
echo.

:end
echo Troubleshooting and repair process completed.
pause
endlocal