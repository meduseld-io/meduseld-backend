# What's New - Dedicated Server Edition

All the improvements made for running on a dedicated server with multiple users.

## New Features

### 1. Activity Logging
- Tracks all user actions (start, stop, restart, kill)
- Records IP address and timestamp
- View via `/api/activity` endpoint
- Logged to `webserver.log` for admin review

### 2. Better CPU Display
- Changed from confusing "12.5% (50% total)" to simple "50%"
- Shows total CPU usage (what Task Manager shows)
- Renamed "Icarus CPU" to "Server CPU Usage" for clarity
- Updated chart labels for consistency

### 3. Easy Update Commands
- `update_panel.bat` - Full update (git pull + restart)
- `restart_panel.bat` - Quick restart after manual updates
- Both verify the panel is working after restart
- Game server is never affected

### 4. Process Isolation
- Game server runs independently of control panel
- Panel can be restarted without affecting game server
- Proper NSSM configuration prevents child process termination
- Tested and verified working

### 5. Improved Service Setup
- `setup_service_fixed.bat` - Handles spaces in paths
- Finds real Python executable (not Windows Store launcher)
- Configures all NSSM settings automatically
- Includes verification steps

### 6. Health Monitoring
- `health_check.bat` - Quick system health check
- Checks panel service, game server, disk space
- Reviews recent errors in logs
- Easy troubleshooting tool

## New Documentation

### For Admins

1. **DEPLOYMENT_GUIDE.md** - Complete setup guide for dedicated server
   - Pre-deployment checklist
   - Security hardening
   - Network configuration
   - Firewall setup
   - Backup strategy
   - Performance optimization
   - Troubleshooting

2. **SERVICE_SETUP.md** - Windows service configuration
   - NSSM setup instructions
   - Alternative methods (Task Scheduler)
   - Process isolation explanation
   - Testing procedures

### For Users

3. **USER_GUIDE.md** - Simple guide for your friends
   - Dashboard overview
   - What each button does
   - Common tasks
   - Best practices
   - Troubleshooting
   - Tips for multiple users

### Reference

4. **WHATS_NEW.md** - This file!
5. **README.md** - Updated with new features

## Configuration Improvements

### config.py Additions

```python
# Security
SECRET_KEY = "..."  # For future session management
ALLOWED_IPS = []    # IP whitelist (optional)

# Better defaults for multiple users
RATE_LIMIT_MAX_REQUESTS = 10  # Adjustable per user count
```

### Configurable Timeouts

All intervals are now in `config.py`:
- `START_TIMEOUT` - How long to wait for server start
- `STOP_TIMEOUT` - How long to wait for server stop
- `UPDATE_TIMEOUT` - How long to wait for updates
- `UPDATE_CHECK_INTERVAL` - How often to check for updates
- `STATS_COLLECTION_INTERVAL` - How often to collect stats
- `MONITOR_INTERVAL` - How often to check server state

## Bug Fixes

### Fixed in This Version

1. **Thread Timeout Issue**
   - Reduced Steam API timeout from 10s to 5s
   - Reduced retry backoff to 1s
   - Prevents update thread from appearing dead

2. **Log Panel Scrolling**
   - Only auto-scrolls when already at bottom
   - Stays in place when scrolling up to read history
   - 50px threshold for "at bottom" detection

3. **Service Path Handling**
   - Properly quotes paths with spaces
   - Uses real Python executable, not Windows Store launcher
   - Separates Python path from script path in NSSM config

4. **Process Isolation**
   - Uses batch file with `start` command
   - Properly detaches game server from panel process
   - Service configuration prevents child process termination

## Scripts Overview

### Setup & Installation
- `setup_service_fixed.bat` - Install/configure Windows service
- `nssm.exe` - Service manager (included in project)

### Daily Operations
- `restart_panel.bat` - Quick panel restart
- `update_panel.bat` - Full update (git + restart)
- `stop_panel.bat` - Stop panel and any running instances
- `health_check.bat` - System health check

### Server Control
- `launch_server.bat` - Launches game server independently
- `updateserver.bat` - Your existing update script (unchanged)

### Diagnostics
- `diagnose_service.bat` - Service diagnostics and logs

## API Endpoints

### New Endpoints

- `GET /api/activity` - View recent user actions
- `GET /api/update-output` - View last update script output

### Existing Endpoints

- `GET /api/stats` - Server and system stats
- `GET /api/logs` - Game server logs
- `GET /api/history` - Historical resource usage
- `GET /api/check-update` - Manually check for updates
- `POST /start` - Start server
- `POST /stop` - Stop server
- `POST /restart` - Restart with update check
- `POST /kill` - Force kill server

## Security Enhancements

### Implemented

1. **Rate Limiting** - Prevents button spam
2. **Activity Logging** - Tracks who does what
3. **State Validation** - Prevents invalid state transitions
4. **Thread Safety** - Locks prevent race conditions
5. **Error Handling** - Comprehensive try/catch blocks

### Ready to Add (if needed)

1. **IP Whitelisting** - Restrict access by IP
2. **Authentication** - Login system
3. **HTTPS** - SSL/TLS encryption
4. **CSRF Protection** - Cross-site request forgery prevention

## Performance Improvements

1. **Reduced API Timeouts** - Faster failure detection
2. **Configurable Intervals** - Adjust for your hardware
3. **Thread Health Monitoring** - Detects dead threads
4. **Log Rotation** - Prevents log files from growing too large

## What's Next?

### Potential Future Features

1. **User Authentication**
   - Login system
   - Role-based permissions (admin vs user)
   - Session management

2. **Discord Integration**
   - Notifications for server events
   - Control via Discord bot
   - Player count tracking

3. **Scheduled Restarts**
   - Auto-restart at specific times
   - Configurable schedule
   - Player warnings

4. **Backup Management**
   - Automated backups
   - Restore from backup
   - Backup scheduling

5. **Multi-Server Support**
   - Manage multiple game servers
   - Switch between servers
   - Separate configurations

6. **Mobile-Friendly UI**
   - Responsive design
   - Touch-optimized controls
   - Mobile app (PWA)

7. **Advanced Monitoring**
   - Player count tracking
   - Performance graphs
   - Alert system

Let me know which features you'd like added!

## Migration from Development

If you're moving from your dev PC to dedicated server:

1. Copy entire project folder
2. Update `config.py` with new paths and IPs
3. Run `setup_service_fixed.bat` as Administrator
4. Configure Windows Firewall
5. Test access from another computer
6. Share URL with friends

## Support

Check these files for help:
- **DEPLOYMENT_GUIDE.md** - Full deployment instructions
- **USER_GUIDE.md** - For your friends
- **SERVICE_SETUP.md** - Service configuration
- **README.md** - General overview

All logs are in:
- `webserver.log` - Application logs
- `service_stdout.log` - Service output
- `service_stderr.log` - Service errors

---

Ready for your dedicated server deployment! 🚀
