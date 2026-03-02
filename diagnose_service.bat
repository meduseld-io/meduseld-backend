@echo off
REM Diagnostic script for Icarus Control Panel Service

echo ================================================
echo Service Diagnostics
echo ================================================
echo.

echo Checking service status...
sc query Meduseld
echo.

echo Checking service configuration...
sc qc Meduseld
echo.

echo Checking if Python is accessible...
where python
echo.

echo Checking if webserver.py exists...
if exist webserver.py (
    echo webserver.py found in current directory
) else (
    echo ERROR: webserver.py not found in current directory
)
echo.

echo Checking recent service logs...
if exist service_stderr.log (
    echo === Last 20 lines of service_stderr.log ===
    powershell -Command "Get-Content service_stderr.log -Tail 20"
) else (
    echo service_stderr.log not found
)
echo.

if exist service_stdout.log (
    echo === Last 20 lines of service_stdout.log ===
    powershell -Command "Get-Content service_stdout.log -Tail 20"
) else (
    echo service_stdout.log not found
)
echo.

if exist webserver.log (
    echo === Last 20 lines of webserver.log ===
    powershell -Command "Get-Content webserver.log -Tail 20"
) else (
    echo webserver.log not found
)
echo.

echo Checking Windows Event Log for service errors...
powershell -Command "Get-EventLog -LogName Application -Source 'Service Control Manager' -Newest 10 | Where-Object {$_.Message -like '*Meduseld*'} | Format-List TimeGenerated, EntryType, Message"
echo.

echo ================================================
echo Diagnostics Complete
echo ================================================
pause
