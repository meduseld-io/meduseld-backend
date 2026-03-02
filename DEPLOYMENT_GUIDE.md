# Deployment Guide for Dedicated Server

This guide will help you set up the Icarus Control Panel on a dedicated server for your friends to use.

## Pre-Deployment Checklist

### 1. Server Requirements
- [ ] Windows Server or Windows 10/11
- [ ] Python 3.8 or higher installed
- [ ] Static IP address or DDNS configured
- [ ] Port 5000 open in Windows Firewall
- [ ] Port forwarding configured on router (if accessing from outside network)

### 2. Security Considerations
- [ ] Change default Flask secret key (see Security section below)
- [ ] Configure allowed hosts in `config.py`
- [ ] Set up HTTPS with reverse proxy (recommended for production)
- [ ] Create separate Windows user account for the service
- [ ] Enable Windows Firewall
- [ ] Keep Windows and Python updated

### 3. Network Configuration
- [ ] Configure static IP or DDNS
- [ ] Open port 5000 in Windows Firewall
- [ ] Configure port forwarding if needed
- [ ] Test access from external network

## Step-by-Step Setup

### 1. Install Prerequisites

```cmd
# Install Python (if not already installed)
# Download from: https://www.python.org/downloads/

# Verify Python installation
python --version

# Install dependencies
pip install -r requirements.txt
```

### 2. Configure the Panel

Edit `config.py`:

```python
# Update allowed hosts with your domain/IP
ALLOWED_HOSTS = [
    "localhost",
    "127.0.0.1",
    "your-server-ip",      # Add your server's IP
    "yourdomain.com",       # Add your domain if you have one
    "panel.yourdomain.com"  # Add panel subdomain
]

# Update server paths if different
LAUNCH_EXE = r"C:\icarusserver\IcarusServer.exe"
SERVER_DIR = r"C:\icarusserver"

# Adjust rate limiting for multiple users
RATE_LIMIT_MAX_REQUESTS = 20  # Increase for more users
```

### 3. Configure Windows Firewall

```cmd
# Open PowerShell as Administrator

# Allow port 5000 for the panel
netsh advfirewall firewall add rule name="Icarus Control Panel" dir=in action=allow protocol=TCP localport=5000

# Allow game server ports
netsh advfirewall firewall add rule name="Icarus Server" dir=in action=allow protocol=UDP localport=17777
netsh advfirewall firewall add rule name="Icarus Query" dir=in action=allow protocol=UDP localport=27015
```

### 4. Install as Windows Service

Run as Administrator:
```cmd
setup_service_fixed.bat
```

Verify it's running:
```cmd
nssm status Meduseld
```

### 5. Test Access

From the server:
```
http://localhost:5000
```

From another computer on the network:
```
http://SERVER-IP:5000
```

From outside the network (if port forwarded):
```
http://YOUR-PUBLIC-IP:5000
```

## Security Hardening

### 1. Add Flask Secret Key

Create a file `secret_key.txt` with a random string:
```cmd
python -c "import secrets; print(secrets.token_hex(32))" > secret_key.txt
```

Then update `webserver.py` to use it (we'll add this feature).

### 2. Use HTTPS (Recommended)

For production, use a reverse proxy like:
- **Caddy** (easiest, auto HTTPS)
- **nginx** (more control)
- **IIS** (if you prefer Windows tools)

Example Caddy configuration:
```
panel.yourdomain.com {
    reverse_proxy localhost:5000
}
```

### 3. Restrict Access by IP (Optional)

If you only want specific IPs to access:

Edit `config.py`:
```python
# Whitelist specific IPs
ALLOWED_IPS = [
    "192.168.1.0/24",  # Local network
    "1.2.3.4",         # Friend's IP
]
```

We can add this feature if needed.

### 4. Create Dedicated Service Account

```cmd
# Create a new user for the service
net user IcarusPanel PASSWORD /add
net localgroup Users IcarusPanel /add

# Give it permissions to the server directory
icacls "C:\icarusserver" /grant IcarusPanel:(OI)(CI)F /T

# Update service to run as this user
nssm set Meduseld ObjectName .\IcarusPanel PASSWORD
```

## Router Configuration

### Port Forwarding

Forward these ports to your server's local IP:

| Service | Protocol | Port | Purpose |
|---------|----------|------|---------|
| Control Panel | TCP | 5000 | Web interface |
| Game Server | UDP | 17777 | Game traffic |
| Query Port | UDP | 27015 | Server browser |

### Dynamic DNS (if no static IP)

Use a DDNS service like:
- No-IP (free)
- DuckDNS (free)
- Cloudflare (free with domain)

## User Management

### Creating User Accounts (Future Feature)

Currently, anyone with access to the panel can control the server. Consider:

1. **Network-level security**: Only allow access from trusted IPs
2. **VPN**: Require VPN connection to access panel
3. **Authentication**: We can add login system if needed

### Recommended Access Control

For now, the best approach is:
- Use Windows Firewall to restrict access
- Share panel URL only with trusted friends
- Monitor `webserver.log` for suspicious activity

## Monitoring and Maintenance

### Check Service Status
```cmd
nssm status Meduseld
```

### View Logs
```cmd
# Application logs
type webserver.log

# Service logs
type service_stdout.log
type service_stderr.log
```

### Restart Panel
```cmd
restart_panel.bat
```

### Update Panel
```cmd
update_panel.bat
```

### Monitor Resource Usage

Open Task Manager and check:
- Python.exe (control panel)
- IcarusServer-Win64-Shipping.exe (game server)

## Backup Strategy

### What to Backup

1. **Game Server Data**:
   - `C:\icarusserver\Icarus\Saved\`
   - Contains player data, world saves

2. **Panel Configuration**:
   - `config.py`
   - `version.txt`
   - `webserver.log` (optional)

3. **Service Configuration**:
   - Export with: `nssm dump Meduseld > service_backup.txt`

### Automated Backup Script

Create `backup.bat`:
```cmd
@echo off
set BACKUP_DIR=C:\Backups\Icarus_%date:~-4,4%%date:~-10,2%%date:~-7,2%
mkdir "%BACKUP_DIR%"
xcopy "C:\icarusserver\Icarus\Saved" "%BACKUP_DIR%\Saved" /E /I /Y
copy "config.py" "%BACKUP_DIR%\"
copy "version.txt" "%BACKUP_DIR%\"
echo Backup complete: %BACKUP_DIR%
```

Schedule with Task Scheduler to run daily.

## Troubleshooting

### Panel won't start
1. Check `service_stderr.log` for errors
2. Verify Python path: `python --version`
3. Check port 5000 isn't in use: `netstat -ano | findstr :5000`
4. Restart service: `restart_panel.bat`

### Can't access from other computers
1. Check Windows Firewall rules
2. Verify server IP: `ipconfig`
3. Test from server first: `http://localhost:5000`
4. Check router port forwarding

### Game server dies when panel restarts
1. This shouldn't happen with current setup
2. Check `webserver.log` for process launch method
3. Verify service is configured correctly: `nssm dump Meduseld`

### High CPU/RAM usage
1. Check `webserver.log` for errors
2. Verify no infinite loops in background threads
3. Restart panel: `restart_panel.bat`
4. Check for updates: `update_panel.bat`

## Performance Optimization

### For Multiple Users

If you have many friends accessing the panel:

1. **Increase rate limits** in `config.py`:
```python
RATE_LIMIT_MAX_REQUESTS = 30
```

2. **Use production WSGI server** instead of Flask dev server:
```cmd
pip install waitress
```

We can add this if needed.

3. **Enable caching** for static files (future feature)

### For Low-End Hardware

If running on older hardware:

1. **Increase check intervals** in `config.py`:
```python
STATS_COLLECTION_INTERVAL = 60  # Instead of 30
UPDATE_CHECK_INTERVAL = 7200    # Instead of 3600
```

2. **Reduce log retention**:
```python
LOG_LEVEL = "WARNING"  # Instead of "INFO"
```

## Going Live Checklist

Before giving access to friends:

- [ ] Service is running and auto-starts on boot
- [ ] Firewall rules are configured
- [ ] Port forwarding is working (if needed)
- [ ] Panel is accessible from external network
- [ ] Game server starts and stops correctly
- [ ] Restart/update scripts work
- [ ] Backups are configured
- [ ] Logs are being written
- [ ] Friends can access the panel
- [ ] Test full restart cycle (panel + game server)

## Support and Updates

### Getting Updates

```cmd
update_panel.bat
```

### Reporting Issues

Check logs first:
- `webserver.log` - Application logs
- `service_stderr.log` - Service errors
- Windows Event Viewer - System errors

### Community

Share your setup with friends and document any custom changes you make!

## Next Steps

After deployment:
1. Monitor for a few days to ensure stability
2. Set up automated backups
3. Consider adding authentication if needed
4. Set up monitoring/alerting (optional)
5. Document any custom configurations

Good luck with your dedicated server! 🎮
