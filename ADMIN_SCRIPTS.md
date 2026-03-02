# Admin Scripts Reference

These scripts are for **SERVER ADMINISTRATORS ONLY**. Your friends access the panel through their web browser at **meduseld.io** - they don't need any of these files.

## 🔧 Setup Scripts (Run Once)

### `setup_service.bat`
**Run as Administrator** - Sets up the Windows service

What it does:
- Installs the panel as a Windows service
- Configures auto-start on boot
- Sets up logging
- Configures process isolation

When to use:
- First time setup on the dedicated server
- After reinstalling Windows
- If service gets corrupted

## 🔄 Daily Operations (Run as Needed)

### `restart_panel.bat`
Quick restart of the control panel

What it does:
- Restarts the panel service
- Verifies it's working
- Does NOT affect the game server

When to use:
- After manually updating panel files
- If panel is acting weird
- After changing config.py

### `update_panel.bat`
Full update process

What it does:
- Pulls latest code from git (if repo)
- Updates Python dependencies
- Restarts the service
- Verifies it's working

When to use:
- Weekly maintenance
- When new features are released
- To get bug fixes

### `stop_panel.bat`
Stops the panel completely

What it does:
- Stops the Windows service
- Kills any running Python instances

When to use:
- Before major system maintenance
- If you need to completely stop the panel
- Troubleshooting

## 🏥 Diagnostics (Run When Troubleshooting)

### `diagnose_service.bat`
Shows service status and recent logs

What it does:
- Checks service status
- Shows recent errors
- Displays configuration

When to use:
- Panel won't start
- Investigating issues
- Before asking for help

### `health_check.bat`
Complete system health check

What it does:
- Checks panel service
- Checks game server process
- Reviews disk space
- Shows recent errors

When to use:
- Regular health checks
- Before/after updates
- Investigating performance issues

## 🎮 Server Scripts (Rarely Needed)

### `launch_server.bat`
Manually launches the game server

What it does:
- Starts the game server independently
- Used internally by the panel

When to use:
- Usually never (panel handles this)
- Only if testing server launch manually

### `updateserver.bat`
Your existing SteamCMD update script

What it does:
- Kills game server
- Runs SteamCMD to update
- Used by panel during restart

When to use:
- Usually never (panel calls this automatically)
- Only if manually updating game server

## 📁 Other Files

### `nssm.exe`
Windows service manager

What it is:
- Third-party service manager
- Better than built-in Windows services
- Handles process isolation

Don't delete this!

### Configuration Files

- `config.py` - Panel configuration (edit this)
- `webserver.py` - Main application (don't edit unless you know what you're doing)
- `requirements.txt` - Python dependencies

### Log Files

- `webserver.log` - Application logs
- `service_stdout.log` - Service output
- `service_stderr.log` - Service errors
- `version.txt` - Current game server build ID

## 🌐 What Your Friends Use

Your friends access the panel through their **web browser** at:
```
https://meduseld.io
```

They see:
- Dashboard with server status
- Start/Stop/Restart buttons
- Resource graphs
- Live logs

They DON'T need:
- ❌ Any .bat files
- ❌ Python installed
- ❌ Access to the server PC
- ❌ Any technical knowledge

Just share the URL and the USER_GUIDE.md with them!

## 🔐 Cloudflare Setup

Since you're using Cloudflare:

1. **DNS Settings**:
   - Point meduseld.io to your server's public IP
   - Use Cloudflare proxy (orange cloud) for DDoS protection
   - Or use Cloudflare Tunnel for extra security

2. **SSL/TLS**:
   - Set to "Full" or "Full (strict)" mode
   - Cloudflare handles HTTPS automatically
   - Panel runs on HTTP locally (port 5000)

3. **Firewall Rules** (optional):
   - Restrict access by country
   - Block known bad IPs
   - Rate limiting (in addition to panel's built-in)

4. **Page Rules** (optional):
   - Cache static assets
   - Always use HTTPS

## 📋 Quick Reference

**First Time Setup:**
```cmd
1. setup_service.bat (as Admin)
2. Test: http://localhost:5000
3. Configure Cloudflare DNS
4. Test: https://meduseld.io
5. Share USER_GUIDE.md with friends
```

**Weekly Maintenance:**
```cmd
update_panel.bat
```

**After Manual Changes:**
```cmd
restart_panel.bat
```

**If Something's Wrong:**
```cmd
health_check.bat
diagnose_service.bat
```

**Emergency Stop:**
```cmd
stop_panel.bat
```

## 🆘 Getting Help

If you need help:

1. Run `diagnose_service.bat`
2. Check `webserver.log` for errors
3. Check `service_stderr.log` for service errors
4. Note what you were doing when it broke
5. Note any error messages

## 📝 Notes

- All scripts are safe to run multiple times
- Scripts won't affect the game server (process isolation)
- Always run setup_service.bat as Administrator
- Other scripts can run as normal user
- Keep backups of config.py before major changes

---

Remember: Your friends only need a web browser and the URL. All these scripts are for you to manage the server!
