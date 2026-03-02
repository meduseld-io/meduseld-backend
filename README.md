# Icarus Server Control Panel

A Flask-based web control panel for managing Icarus dedicated game servers with automatic updates, monitoring, and health tracking.

## Features

- **Server Control**: Start, stop, restart, and force kill server processes
- **Automatic Updates**: Checks Steam for updates and runs update script on restart
- **Real-time Monitoring**: Live stats, logs, and resource usage tracking
- **Health Monitoring**: System and server health indicators
- **Version Tracking**: Automatic detection of available updates
- **Thread Safety**: Proper locking mechanisms to prevent race conditions
- **Rate Limiting**: Protection against API abuse
- **Comprehensive Logging**: Detailed logs for debugging and monitoring
- **Graceful Shutdown**: Proper cleanup on application exit
- **Thread Health Monitoring**: Detects and reports dead background threads
- **Process Isolation**: Game server runs independently - panel can be restarted without affecting the game server

## Site Structure

```
meduseld.io              → Landing page
meduseld.io/menu         → Services hub (tile menu)
panel.meduseld.io        → Icarus control panel
```

Users access through Tailscale VPN, then navigate from landing → menu → service.

See [SITE_STRUCTURE.md](SITE_STRUCTURE.md) for detailed flow and [ADDING_SERVICES.md](ADDING_SERVICES.md) for adding new services.

## For Server Administrators

This panel is designed to run on a dedicated server. Your users access it through their web browser - no installation needed on their end.

**Admin Documentation:**
- [ADMIN_SCRIPTS.md](ADMIN_SCRIPTS.md) - What each script does
- [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) - Full deployment guide
- [SERVICE_SETUP.md](SERVICE_SETUP.md) - Windows service setup

**User Documentation:**
- [USER_GUIDE.md](USER_GUIDE.md) - Share this with your friends

## Installation

1. Install Python dependencies:
```bash
pip install -r requirements.txt
```

2. Configure your server settings in `config.py`

3. Ensure your `updateserver.bat` script exists at the configured path

4. Run the server:
```bash
python webserver.py
```

5. **For Windows Service Setup**: See [SERVICE_SETUP.md](SERVICE_SETUP.md) for detailed instructions on running as a service without killing the game server

## Updating the Panel

### If using Git:
```cmd
update_panel.bat
```
This will:
- Pull latest changes from git
- Update Python dependencies
- Restart the service
- Verify it's running

### If updating manually:
1. Replace files with new versions
2. Run `restart_panel.bat`

### Manual restart:
```cmd
restart_panel.bat
```
Or use Windows services:
```cmd
net stop Meduseld
net start Meduseld
```

**Note**: The game server will NOT be affected when updating/restarting the panel!

## Configuration

Edit `config.py` to customize:

- Server paths and executable
- Launch arguments
- Security settings (allowed hosts, rate limits)
- Timing configuration (timeouts, intervals)
- Health thresholds
- Logging settings
- Flask settings

## API Endpoints

### Control Endpoints
- `POST /start` - Start the server
- `POST /stop` - Stop the server gracefully
- `POST /restart` - Restart server with update check
- `POST /kill` - Force kill the server

### API Endpoints
- `GET /api/stats` - Get server and system stats
- `GET /api/logs` - Get server logs
- `GET /api/history` - Get historical stats
- `GET /api/check-update` - Manually check for updates
- `GET /api/update-output` - Get output from last update

## Security Features

1. **Host-based Routing**: Different content for different domains
2. **Rate Limiting**: Prevents API abuse (configurable)
3. **State Validation**: Ensures valid state transitions
4. **Thread Safety**: Locks prevent race conditions

## Improvements Implemented

### Bug Fixes
1. ✅ Fixed race conditions in state management with threading locks
2. ✅ Fixed inconsistent quotes in kill commands
3. ✅ Fixed stop endpoint logic to properly detect final state
4. ✅ Prevented monitor thread from overriding user actions
5. ✅ Added error handling for Steam API failures
6. ✅ Fixed version file race conditions with locks

### Enhancements
1. ✅ Added threading locks for state and version management
2. ✅ Implemented state machine with valid transitions
3. ✅ Added comprehensive Python logging
4. ✅ Added retry logic with exponential backoff for Steam API
5. ✅ Added startup validation for configuration
6. ✅ Capture and expose update script output via API
7. ✅ Added graceful shutdown handlers
8. ✅ Implemented rate limiting on control endpoints
9. ✅ Moved configuration to external config file
10. ✅ Added startup state detection
11. ✅ Implemented thread health monitoring
12. ✅ Added detailed error logging throughout

## State Machine

Valid state transitions:
- `offline` → `starting`, `crashed`
- `starting` → `running`, `offline`, `crashed`
- `running` → `stopping`, `restarting`, `crashed`
- `stopping` → `offline`, `crashed`
- `restarting` → `running`, `offline`, `crashed`
- `crashed` → `starting`, `offline`

## Logging

Logs are written to both console and `webserver.log` (configurable).

Log levels:
- `INFO`: Normal operations
- `WARNING`: Non-critical issues
- `ERROR`: Errors that don't stop execution
- `CRITICAL`: Fatal errors

## Thread Health

The application monitors its background threads:
- Monitor thread (server state detection)
- Stats collection thread
- Update check thread

Thread health is exposed via `/api/stats` endpoint.

## Update Process

On restart:
1. Server is killed
2. `updateserver.bat` is executed (runs SteamCMD)
3. Update output is captured
4. Build ID is updated on success
5. Server is launched
6. State is monitored until running

## Troubleshooting

### Server won't start
- Check `webserver.log` for errors
- Verify paths in `config.py`
- Ensure executable exists and is accessible

### Updates failing
- Check update script exists
- Review update output via `/api/update-output`
- Verify SteamCMD is installed and working

### Thread health warnings
- Check `webserver.log` for thread errors
- Restart the application if threads are dead

### Game server dies when restarting the panel
- This should NOT happen with the current implementation
- The game server is launched as a detached process
- If it still happens, check your service configuration
- Ensure the service doesn't have "kill child processes" enabled

## Process Isolation

The game server is launched with `DETACHED_PROCESS` and `CREATE_NEW_PROCESS_GROUP` flags on Windows, which means:
- The game server runs independently of the control panel
- Restarting/stopping the panel does NOT affect the game server
- You can deploy panel updates without downtime
- The game server must be explicitly stopped via the panel or task manager

## License

MIT License - Feel free to modify and use for your own servers.
