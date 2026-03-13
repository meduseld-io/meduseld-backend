# Meduseld - Game Server Control Panel

<div align="center">
  <img src="app/static/meduseldminimal.png" alt="Meduseld" width="150">
</div>

Meduseld is a web-based control panel that lets you manage your Icarus dedicated game server from anywhere. No technical knowledge required - just click buttons in your browser to start, stop, and monitor your server.

## What is Meduseld?

Think of Meduseld as a remote control for your game server. Instead of logging into the server computer and typing commands, you can:

- Start and stop your Icarus server with one click
- See if the server is online or offline
- Check how many players are connected
- View server performance (CPU, memory, disk space)
- Read server logs to troubleshoot issues
- Update the server when new versions are available

Everything happens through a simple website - no apps to install, no complicated setup.

## Features

### Game Server Control

- Start, stop, or restart your Icarus server instantly
- See real-time status - is the server online or offline?
- View how many players are currently connected
- Check for game updates and apply them with one click
- Emergency "force stop" if the server gets stuck

### Server Monitoring

- Live graphs showing CPU, memory, and disk usage
- Performance history for the last 30 minutes
- Health indicators that warn you if something's wrong
- Activity log showing recent server events

### Server Logs

- Read game server logs directly in your browser
- See what's happening without technical knowledge
- Troubleshoot issues or check player activity
- Logs update automatically as new events occur

### Web Terminal (Advanced Users)

- Access the server computer directly from your browser
- No need to install special software
- Full command-line access for advanced troubleshooting

## How to Use Meduseld

1. **Visit the main page**: Go to https://meduseld.io
2. **Navigate to services**: Click the button to access the service menu
3. **Choose what you need**: Select the Game Server Panel, SSH Terminal, or other services
4. **Log in with Discord**: Authenticate using your Discord account
5. **Control your server**: Use the buttons and controls to manage your game server

You'll need to be authorized to access Meduseld. If you can't log in, contact the server administrator to add your Discord account to the access list.

## Understanding Server Status

The control panel shows your server in different states:

- **Offline** - Server is not running. Click "Start" to launch it.
- **Starting** - Server is booting up. Wait a minute for it to fully start.
- **Running** - Server is online and ready for players to join.
- **Stopping** - Server is shutting down gracefully.
- **Restarting** - Server is restarting (usually to apply updates).
- **Crashed** - Server stopped unexpectedly. Check logs or restart it.

The panel automatically detects these states and updates the display every few seconds.

## Common Questions

### How do I start the server?

Click the green "Start Server" button on the control panel. Wait about 30-60 seconds for it to fully start.

### How do I know if players can connect?

When the status shows "Running" and turns green, players can join. The panel also shows the current player count.

### What if the server is stuck or frozen?

Use the "Force Stop" button to immediately kill the server process, then start it again.

### How do I update the game server?

Click "Check for Updates" to see if a new version is available. If there is, click "Restart" to apply the update automatically.

### Can I see what's happening on the server?

Yes! Click the "Logs" tab to see real-time server activity, including player connections and game events.

### What do the graphs mean?

- **CPU**: How much processing power the server is using
- **Memory**: How much RAM the server is using
- **Disk**: How much storage space is being used

If any of these get too high (near 100%), the server might slow down or crash.

## Contributors

This project is maintained by:

- [Add contributor names here]

Want to contribute? Check out the development section below or contact the project maintainers.

## For Developers

If you want to modify the panel or fix something:

### 1. Clone the Repo

```bash
git clone <repo-url>
cd meduseld
```

### 2. Create a New Branch

```bash
git checkout -b feature/your-feature-name
```

### 3. Make Your Changes

Edit files in the `app/` folder:

- `app/webserver.py` - Main Flask application
- `app/config.py` - Configuration settings
- `app/templates/panel.html` - Control panel HTML
- `app/templates/terminal.html` - SSH terminal wrapper
- `app/static/css/style.css` - Styles

### 4. Test Locally (Optional)

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python app/webserver.py
```

Visit http://localhost:5000 to test.

### 5. Commit and Push Your Branch

```bash
git add .
git commit -m "Description of what you changed"
git push -u origin feature/your-feature-name
```

### 6. Open a Pull Request

- Go to the GitHub repository
- Click "Compare & pull request" for your branch
- Add a description of your changes
- Submit the PR for review

### 7. Deploy to Server (After PR is Merged)

SSH into the server and pull the changes:

```bash
ssh vertebra@meduseld.io
cd /srv/meduseld
git pull
sudo systemctl restart icarus-panel
```

That's it! Your changes are live.

## Understanding the Code

### Main Files

**app/webserver.py**

- The Flask app that runs everything
- Has routes for `/start`, `/stop`, `/restart`, `/kill`
- API endpoints like `/api/stats`, `/api/logs`
- Monitors the server process and collects metrics

**app/config.py**

- All the settings (server paths, timeouts, thresholds)
- Auto-detects if running in dev or production mode
- Change `SERVER_DIR` if the Icarus server moves

**app/templates/panel.html**

- The control panel UI
- Uses Bootstrap for styling
- Chart.js for the graphs
- Updates every 5 seconds via JavaScript

**app/templates/terminal.html**

- Wrapper for the SSH terminal
- Embeds ttyd (the terminal emulator)
- Has navigation buttons to go back to service

### How It Works

```
Your Browser
    ↓
Cloudflare (handles auth + HTTPS)
    ↓
Cloudflare Tunnel (routes to server)
    ↓
Flask App (port 5000) → Control Panel
    ↓
Monitors Icarus Server Process
```

For SSH:

```
Your Browser
    ↓
Cloudflare
    ↓
ttyd (port 7681) → Terminal
    ↓
Ubuntu Server Shell
```

### Key Concepts

**Server States**

- `offline` - Server not running
- `starting` - Server is booting up
- `running` - Server is online
- `stopping` - Server is shutting down
- `restarting` - Server is restarting (with update check)
- `crashed` - Server died unexpectedly

**Process Detection**
The panel looks for a process named `IcarusServer-Win64-Shipping.exe` (it runs via Wine on Ubuntu). If it finds it, the server is "running".

**Update Detection**
Checks Steam's API for the latest build ID and compares it to what's installed. If different, shows "Update Available".

## Common Tasks

### Restarting the Panel

If the panel itself is broken:

```bash
ssh vertebra@meduseld.io
sudo systemctl restart icarus-panel
```

### Viewing Panel Logs

```bash
ssh vertebra@meduseld.io
tail -f /srv/meduseld/logs/webserver.log
```

### Restarting the SSH Terminal

If the terminal isn't working:

```bash
ssh vertebra@meduseld.io
sudo systemctl restart ttyd
```

### Checking What's Running

```bash
ssh vertebra@meduseld.io
sudo systemctl status icarus-panel
sudo systemctl status ttyd
sudo systemctl status cloudflared
```

### Manually Starting/Stopping Icarus

If you need to bypass the panel:

```bash
ssh vertebra@meduseld.io
cd /srv/games/icarus
./start.sh              # Start server
pkill -9 IcarusServer   # Stop server
```

## Troubleshooting

### "Server shows offline but I know it's running"

The process name might have changed. Check:

```bash
ps aux | grep -i icarus
```

If the process name is different, update `PROCESS_NAME` in `app/config.py`.

### "Graphs aren't showing data"

The stats collection thread might have crashed. Restart the panel:

```bash
sudo systemctl restart icarus-panel
```

### "SSH terminal shows blank page"

1. Check if ttyd is running: `sudo systemctl status ttyd`
2. Check if terminal.meduseld.io is in Cloudflare Access
3. Restart ttyd: `sudo systemctl restart ttyd`

### "Can't access the site at all"

1. Check if Cloudflare Tunnel is running: `sudo systemctl status cloudflared`
2. Check if your email is in the Access list
3. Try incognito mode (clear cookies)

### "Changes I pushed aren't showing up"

Did you restart the panel after pulling?

```bash
cd /srv/meduseld
git pull
sudo systemctl restart icarus-panel
```

## API for Nerds

If you want to script things or integrate with other tools:

### Control the Server

```bash
# Start
curl -X POST https://panel.meduseld.io/start

# Stop
curl -X POST https://panel.meduseld.io/stop

# Restart (with update check)
curl -X POST https://panel.meduseld.io/restart

# Force kill
curl -X POST https://panel.meduseld.io/kill
```

### Get Stats

```bash
# Current stats
curl https://panel.meduseld.io/api/stats | jq

# Logs
curl https://panel.meduseld.io/api/logs | jq

# Historical data (30 min)
curl https://panel.meduseld.io/api/history | jq

# Check for updates
curl https://panel.meduseld.io/api/check-update | jq
```

Example response from `/api/stats`:

```json
{
  "state": "running",
  "stats": {
    "cpu": 15.2,
    "ram_percent": 45.8,
    "ram_used": 7.3,
    "ram_total": 16.0,
    "disk_percent": 31.2
  },
  "icarus": {
    "cpu": 8.5,
    "cpu_raw": 34.0,
    "ram": 3.2
  },
  "uptime": 3600,
  "health": "good"
}
```

## Project Structure

```
meduseld/
├── app/
│   ├── webserver.py           # Main Flask app
│   ├── config.py              # Settings
│   ├── templates/
│   │   ├── base.html          # Base template
│   │   ├── panel.html         # Control panel
│   │   └── terminal.html      # SSH wrapper
│   └── static/
│       ├── css/style.css      # Styles
│       ├── js/main.js         # JavaScript
│       └── *.png              # Images
├── logs/                      # Log files
├── requirements.txt           # Python packages
├── README.md                  # This file
└── CHANGELOG.md               # Version history
```

## Tech Stack

- **Python 3.12** + Flask - The web app
- **Bootstrap 5** - UI framework
- **Chart.js** - Graphs
- **ttyd** - Web terminal
- **Cloudflare Tunnel** - Secure access without port forwarding
- **Cloudflare Access** - Email authentication
- **Ubuntu Server 24.04** - Where it all runs

## Adding New People

To give someone access:

1. **Add their email to Cloudflare Access**:
   - Go to Cloudflare Zero Trust dashboard
   - Access → Applications → Meduseld
   - Add their email to the policy

2. **Add them to GitHub** (if they'll make changes):
   - Repo → Settings → Collaborators
   - Add their GitHub username

3. **Tell them the URL**: https://panel.meduseld.io

They'll get an OTP code via email to login.

## Questions?

Contact the server administrator or project maintainers if you need help or have questions about using Meduseld.

## Version

Current version: **0.3.0-alpha**

This is an alpha release - features are still being tested and improved. Report any issues to the project maintainers.

---

For technical documentation, deployment information, and API details, see the developer sections above.
