@echo off
REM Quick restart script for Icarus Control Panel
REM Use this after manually updating files

echo ================================================
echo Restarting Icarus Control Panel
echo ================================================
echo.

REM Get the current directory
set PANEL_DIR=%~dp0
set PANEL_DIR=%PANEL_DIR:~0,-1%

REM Check if NSSM exists
if exist "%PANEL_DIR%\nssm.exe" (
    set NSSM_PATH=%PANEL_DIR%\nssm.exe
) else (
    echo ERROR: NSSM not found. Cannot manage service.
    echo.
    echo Try using Windows services instead:
    echo   net stop Meduseld
    echo   net start Meduseld
    pause
    exit /b 1
)

echo Restarting service...
"%NSSM_PATH%" restart Meduseld

timeout /t 3 /nobreak >nul

echo.
echo Checking service status...
"%NSSM_PATH%" status Meduseld

echo.
echo Verifying web interface...
timeout /t 2 /nobreak >nul
curl -s http://localhost:5000 >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo SUCCESS! Panel is running at http://localhost:5000
) else (
    echo WARNING: Panel may not be responding yet. Give it a few seconds.
)

echo.
echo ================================================
echo Restart Complete!
echo ================================================
echo.
echo The game server was NOT affected by this restart.
echo.
pause
