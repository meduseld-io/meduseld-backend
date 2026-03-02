@echo off
echo Stopping Icarus Control Panel...
echo.

REM Stop the service if it exists
sc query Meduseld >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Stopping service...
    net stop Meduseld
    timeout /t 2 /nobreak >nul
)

REM Kill any running Python instances of webserver
echo Checking for running Python processes...
tasklist /FI "IMAGENAME eq python.exe" 2>NUL | find /I /N "python.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo Found Python processes. Checking if they're running webserver.py...
    wmic process where "name='python.exe' and commandline like '%%webserver.py%%'" delete 2>NUL
    echo Python webserver processes stopped.
) else (
    echo No Python processes found.
)

echo.
echo Panel stopped.
pause
