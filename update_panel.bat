@echo off
REM Update script for Icarus Control Panel
REM This will pull latest changes and restart the service

echo ================================================
echo Icarus Control Panel Update
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
    echo Please run setup_service_fixed.bat first.
    pause
    exit /b 1
)

echo Step 1: Checking for git repository...
if not exist ".git" (
    echo WARNING: Not a git repository. Skipping git pull.
    echo You'll need to manually update files.
    goto :skip_git
)

echo Step 2: Pulling latest changes from git...
git pull
if %ERRORLEVEL% NEQ 0 (
    echo WARNING: Git pull failed. Continuing anyway...
)

:skip_git

echo.
echo Step 3: Installing/updating Python dependencies...
pip install -r requirements.txt --quiet
if %ERRORLEVEL% NEQ 0 (
    echo WARNING: Dependency installation had issues. Continuing anyway...
)

echo.
echo Step 4: Stopping the panel service...
"%NSSM_PATH%" stop Meduseld
timeout /t 3 /nobreak >nul

echo Step 5: Starting the panel service...
"%NSSM_PATH%" start Meduseld
timeout /t 3 /nobreak >nul

echo.
echo Step 6: Checking service status...
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
echo Update Complete!
echo ================================================
echo.
echo The game server was NOT affected by this update.
echo Check the panel at: http://localhost:5000
echo.
pause
