@echo off
REM Setup script for Icarus Control Panel Windows Service
REM Run this as Administrator

echo ================================================
echo Icarus Control Panel Service Setup
echo ================================================
echo.

REM Get the current directory
set PANEL_DIR=%~dp0
set PANEL_DIR=%PANEL_DIR:~0,-1%

echo Panel Directory: %PANEL_DIR%
echo.

REM Find the REAL Python executable (not the Windows Store launcher)
for /f "delims=" %%i in ('python -c "import sys; print(sys.executable)"') do set PYTHON_PATH=%%i

if "%PYTHON_PATH%"=="" (
    echo ERROR: Could not find Python executable
    pause
    exit /b 1
)

echo Python Path: %PYTHON_PATH%
echo.

REM Check if NSSM is in current directory first
if exist "%PANEL_DIR%\nssm.exe" (
    set NSSM_PATH=%PANEL_DIR%\nssm.exe
    echo NSSM found in current directory!
    goto :nssm_found
)

REM Check if NSSM is available in PATH
where nssm >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    for /f "delims=" %%i in ('where nssm') do set NSSM_PATH=%%i
    echo NSSM found in PATH!
    goto :nssm_found
)

REM NSSM not found
echo ERROR: NSSM not found in PATH or current directory
echo.
echo Please download NSSM from https://nssm.cc/download
echo Extract it and either:
echo   1. Add nssm.exe to your PATH, or
echo   2. Copy nssm.exe to this directory: %PANEL_DIR%
pause
exit /b 1

:nssm_found
echo NSSM Path: %NSSM_PATH%
echo.

REM Stop and remove existing service if it exists
echo Checking for existing service...
sc query Meduseld >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Stopping existing service...
    "%NSSM_PATH%" stop Meduseld
    timeout /t 2 /nobreak >nul
    echo Removing existing service...
    "%NSSM_PATH%" remove Meduseld confirm
    timeout /t 2 /nobreak >nul
)

echo.
echo Installing new service...
"%NSSM_PATH%" install Meduseld "%PYTHON_PATH%"

echo Configuring service...
"%NSSM_PATH%" set Meduseld AppParameters "\"%PANEL_DIR%\webserver.py\""
"%NSSM_PATH%" set Meduseld AppDirectory "%PANEL_DIR%"
"%NSSM_PATH%" set Meduseld DisplayName "Icarus Control Panel"
"%NSSM_PATH%" set Meduseld Description "Web control panel for Icarus dedicated server"
"%NSSM_PATH%" set Meduseld Start SERVICE_AUTO_START

REM Configure stop behavior to not kill child processes
"%NSSM_PATH%" set Meduseld AppStopMethodSkip 0
"%NSSM_PATH%" set Meduseld AppStopMethodConsole 1500
"%NSSM_PATH%" set Meduseld AppExit Default Restart

REM Configure logging
"%NSSM_PATH%" set Meduseld AppStdout "%PANEL_DIR%\service_stdout.log"
"%NSSM_PATH%" set Meduseld AppStderr "%PANEL_DIR%\service_stderr.log"
"%NSSM_PATH%" set Meduseld AppStdoutCreationDisposition 4
"%NSSM_PATH%" set Meduseld AppStderrCreationDisposition 4

REM Rotate logs
"%NSSM_PATH%" set Meduseld AppRotateFiles 1
"%NSSM_PATH%" set Meduseld AppRotateOnline 1
"%NSSM_PATH%" set Meduseld AppRotateSeconds 86400
"%NSSM_PATH%" set Meduseld AppRotateBytes 1048576

echo.
echo Service installed successfully!
echo.
echo Starting service...
"%NSSM_PATH%" start Meduseld

timeout /t 3 /nobreak >nul

echo.
echo Checking service status...
"%NSSM_PATH%" status Meduseld

echo.
echo If service is running, checking web interface...
timeout /t 2 /nobreak >nul
curl -s http://localhost:5000 >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo SUCCESS! Panel is accessible at http://localhost:5000
) else (
    echo WARNING: Service may not be responding yet. Check logs.
)

echo.
echo ================================================
echo Setup Complete!
echo ================================================
echo.
echo Service Name: Meduseld
echo Panel Directory: %PANEL_DIR%
echo Python Path: %PYTHON_PATH%
echo.
echo Logs:
echo   - Application: %PANEL_DIR%\webserver.log
echo   - Service stdout: %PANEL_DIR%\service_stdout.log
echo   - Service stderr: %PANEL_DIR%\service_stderr.log
echo.
echo To manage the service:
echo   "%NSSM_PATH%" start Meduseld
echo   "%NSSM_PATH%" stop Meduseld
echo   "%NSSM_PATH%" restart Meduseld
echo   "%NSSM_PATH%" status Meduseld
echo   "%NSSM_PATH%" edit Meduseld
echo.
echo Or use Windows services:
echo   net start Meduseld
echo   net stop Meduseld
echo.
pause
