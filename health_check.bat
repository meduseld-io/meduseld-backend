@echo off
REM Health check script for Icarus Server and Control Panel

echo ================================================
echo Icarus Server Health Check
echo ================================================
echo.

REM Get the current directory
set PANEL_DIR=%~dp0
set PANEL_DIR=%PANEL_DIR:~0,-1%

echo Checking Control Panel Service...
if exist "%PANEL_DIR%\nssm.exe" (
    "%PANEL_DIR%\nssm.exe" status Meduseld
) else (
    sc query Meduseld
)
echo.

echo Checking if Panel is responding...
curl -s http://localhost:5000/api/stats >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Panel is responding
) else (
    echo [ERROR] Panel is not responding
)
echo.

echo Checking Game Server Process...
tasklist /FI "IMAGENAME eq IcarusServer-Win64-Shipping.exe" 2>NUL | find /I /N "IcarusServer-Win64-Shipping.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo [OK] Game server process is running
) else (
    echo [INFO] Game server is not running
)
echo.

echo Checking Disk Space...
for /f "tokens=3" %%a in ('dir C:\ ^| find "bytes free"') do set FREE_SPACE=%%a
echo Free space on C: %FREE_SPACE% bytes
echo.

echo Checking Recent Errors in Logs...
if exist webserver.log (
    echo Last 5 errors from webserver.log:
    findstr /I "ERROR" webserver.log | powershell -Command "$input | Select-Object -Last 5"
) else (
    echo No webserver.log found
)
echo.

echo Checking Service Logs...
if exist service_stderr.log (
    for /f %%A in ('dir /b service_stderr.log') do set SIZE=%%~zA
    if !SIZE! GTR 0 (
        echo [WARNING] Service has errors. Last 5 lines:
        powershell -Command "Get-Content service_stderr.log -Tail 5"
    ) else (
        echo [OK] No service errors
    )
) else (
    echo No service_stderr.log found
)
echo.

echo ================================================
echo Health Check Complete
echo ================================================
echo.
echo If you see any errors above, check the full logs or contact admin.
echo.
pause
