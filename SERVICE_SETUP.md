# Windows Service Setup Guide

## Problem: Service Kills Game Server on Restart

If your Windows service is killing the game server when you restart the panel, it's likely due to how the service is configured.

## Solution 1: Use NSSM (Recommended)

NSSM (Non-Sucking Service Manager) is the best way to run Python scripts as Windows services.

### Install NSSM

1. Download from: https://nssm.cc/download
2. Extract to a folder (e.g., `C:\nssm`)
3. Add to PATH or use full path

### Create Service

```cmd
nssm install IcarusPanel "C:\Python\python.exe" "C:\path\to\webserver.py"
```

### Configure Service to NOT Kill Children

```cmd
nssm set IcarusPanel AppStopMethodSkip 0
nssm set IcarusPanel AppStopMethodConsole 1500
nssm set IcarusPanel AppExit Default Restart
```

### Set Working Directory

```cmd
nssm set IcarusPanel AppDirectory "C:\path\to\panel"
```

### Start Service

```cmd
nssm start IcarusPanel
```

## Solution 2: Use Task Scheduler

Task Scheduler doesn't kill child processes by default.

1. Open Task Scheduler
2. Create Basic Task
3. Name: "Icarus Control Panel"
4. Trigger: At system startup
5. Action: Start a program
   - Program: `C:\Python\python.exe`
   - Arguments: `C:\path\to\webserver.py`
   - Start in: `C:\path\to\panel`
6. Settings:
   - ✅ Run whether user is logged on or not
   - ✅ Run with highest privileges
   - ❌ Stop the task if it runs longer than...

## Solution 3: Modify Existing Service

If using `sc.exe` or another service manager:

### Check Current Service Config

```cmd
sc qc YourServiceName
```

### Key Settings

Make sure these are NOT set:
- `SERVICE_CONTROL_STOP` should not kill child processes
- Service should not have `KILL_PROCESS_TREE` flag

## Solution 4: Use the Launch Script

The panel now includes `launch_server.bat` which uses Windows `start` command to create a truly independent process.

### How It Works

1. Panel calls `launch_server.bat`
2. Batch file uses `start ""` command
3. Server runs in separate process tree
4. Panel can restart without affecting server

### Verify It's Working

1. Start the game server via panel
2. Open Task Manager
3. Find `IcarusServer-Win64-Shipping.exe`
4. Check its parent process - should NOT be python.exe
5. Kill the Python service
6. Game server should still be running

## Testing Process Isolation

```cmd
# Start the panel
python webserver.py

# In another terminal, check processes
tasklist | findstr "IcarusServer"
tasklist | findstr "python"

# Kill Python
taskkill /F /IM python.exe

# Check if game server is still running
tasklist | findstr "IcarusServer"
```

If the game server is still running after killing Python, process isolation is working!

## Troubleshooting

### Server Still Dies

1. Check service configuration
2. Verify `launch_server.bat` is being used
3. Check `webserver.log` for launch method
4. Try running panel directly (not as service) to test

### Service Won't Start

1. Check Python path in service config
2. Verify working directory is correct
3. Check service account has permissions
4. Review Windows Event Viewer for errors

### Panel Doesn't Detect Running Server

1. Check `PROCESS_NAME` in config.py matches actual process
2. Verify panel has permission to query processes
3. Check `webserver.log` for detection messages

## Recommended Setup

For production, use NSSM with these settings:

```cmd
# Install service
nssm install IcarusPanel "C:\Python\python.exe" "C:\path\to\webserver.py"

# Configure
nssm set IcarusPanel AppDirectory "C:\path\to\panel"
nssm set IcarusPanel AppStopMethodSkip 0
nssm set IcarusPanel AppStopMethodConsole 1500
nssm set IcarusPanel DisplayName "Icarus Control Panel"
nssm set IcarusPanel Description "Web control panel for Icarus dedicated server"
nssm set IcarusPanel Start SERVICE_AUTO_START

# Logging
nssm set IcarusPanel AppStdout "C:\path\to\panel\service_stdout.log"
nssm set IcarusPanel AppStderr "C:\path\to\panel\service_stderr.log"

# Start
nssm start IcarusPanel
```

This ensures:
- Panel starts automatically on boot
- Panel can be restarted without affecting game server
- Logs are captured for debugging
- Service is properly managed
