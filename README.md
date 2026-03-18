# Meduseld Backend

<div align="center">
  <img src="app/static/logo.png" alt="Meduseld" width="150">
</div>

Flask backend for the Meduseld server management platform. Provides the game server control panel, SSH terminal wrapper, health dashboard, and API endpoints for the static site pages.

## Pages

### panel.meduseld.io — Game Server Control Panel

**File:** `app/templates/panel.html` (extends `base.html`)

Authenticated page for controlling the Icarus dedicated game server. Requires Discord OIDC login via Cloudflare Access.

- **System status cards** — CPU, RAM, disk, CPU temp, system status (updates every 5s)
- **Server status card** — state (running/offline/crashed/starting/stopping/restarting), health badge, update badge, uptime, player count, server CPU/RAM
- **Control buttons** — Start, Stop, Restart, Kill (2x2 grid, enable/disable based on server state)
- **Game server logs** — live log viewer with state transition separators (updates every 5s)
- **Startup script logs** — color-coded entries with clear button (updates every 5s)
- **CPU & RAM charts** — Chart.js line graphs with 30 minutes of history (system + server datasets)
- **Dynamic tab title** — emoji changes based on server state (🟢 running, 🔴 offline, 💥 crashed, etc.)
- **Development mode** — activated via `?env=development` URL parameter, shows purple badge
- **Backup dropdown** — download backup or trigger Google Drive upload
- **Update detection** — checks Steam API for new builds, clickable badge to trigger update

### ssh.meduseld.io — SSH Terminal Wrapper (Admin Only)

**File:** `app/templates/terminal.html`

Embeds the ttyd web terminal in an iframe with navigation and a help modal. Non-admin users get a 403 and are redirected to the services page.

- **Embedded terminal** — iframe pointing to `terminal.meduseld.io` (ttyd instance)
- **Navigation bar** — Back to Services, Server Panel buttons
- **Help button** — floating gold button that opens a Linux Commands Cheat Sheet modal
- **Cheat sheet sections** — navigation, file operations, disk usage, process management, permissions, server configuration

### health.meduseld.io — Service Health Dashboard

**File:** `app/templates/health.html` (extends `base.html`)

Public health monitoring page (no auth required).

- **Service status cards** — Control Panel, SSH Terminal, Jellyfin Media
- **Status indicators** — Online (green), Degraded (yellow), Down (red) with response times
- **Auto-refresh** — checks all services every 30 seconds

## API Endpoints

### Public (No Auth)

| Method | Path                           | Description                  |
| ------ | ------------------------------ | ---------------------------- |
| GET    | `/health`                      | Health check                 |
| GET    | `/api/check-service/<service>` | Check if a service is online |

### Authenticated

| Method | Path                      | Description                             |
| ------ | ------------------------- | --------------------------------------- |
| GET    | `/`                       | Control panel UI                        |
| POST   | `/start`                  | Start game server                       |
| POST   | `/stop`                   | Stop game server                        |
| POST   | `/restart`                | Restart game server (with update check) |
| POST   | `/kill`                   | Force kill game server                  |
| GET    | `/api/stats`              | System and server stats                 |
| GET    | `/api/logs`               | Game server logs                        |
| GET    | `/api/startup-logs`       | Startup script logs                     |
| POST   | `/api/clear-startup-logs` | Clear and archive startup logs          |
| GET    | `/api/server-logs`        | Webserver logs                          |
| GET    | `/api/console`            | Console output                          |
| GET    | `/api/check-update`       | Check for game updates                  |
| GET    | `/api/update-output`      | Update process output                   |
| GET    | `/api/history`            | Stats history (30 min)                  |
| GET    | `/api/activity`           | Activity log                            |
| GET    | `/api/me`                 | Current authenticated user info         |
| POST   | `/api/sync-identity`      | Sync Discord user data to DB            |
| GET    | `/jellyfin/*`             | Proxy to Jellyfin service               |

### Admin Only

| Method | Path                    | Description                       |
| ------ | ----------------------- | --------------------------------- |
| GET    | `/api/admin/users`      | List all users                    |
| PUT    | `/api/admin/users/<id>` | Update user role or active status |

## Standalone Services

### Backup Microservice

**File:** `reboot/backup_server.py`

Runs independently on port 5003 so backups work even when the main Flask app is down. Triggered from the system page.

- `POST /backup` — triggers `meduseld-backup.service` via systemd
- `GET /status` — returns backup progress and result (includes filename on success)
- `GET /health` — health check

## Authentication

- Discord OIDC via Cloudflare Access (herugrim worker bridges Discord OAuth)
- `CF_Authorization` cookie decoded for cross-origin auth from static pages
- `Cf-Access-Jwt-Assertion` header used for direct requests
- Admin role determined by Discord server role, stored in DB `users` table
- Dev mode uses a fake user with SQLite (no Cloudflare needed)

## Project Structure

```
meduseld/
├── app/
│   ├── webserver.py        # Main Flask application
│   ├── config.py           # Configuration
│   ├── database.py         # SQLAlchemy init
│   ├── models.py           # User model
│   ├── templates/
│   │   ├── base.html       # Base template
│   │   ├── panel.html      # Control panel
│   │   ├── terminal.html   # SSH terminal wrapper
│   │   └── health.html     # Health dashboard
│   └── static/             # CSS, JS, images
├── reboot/
│   └── backup_server.py    # Standalone backup microservice
├── monitoring/             # System monitoring service
├── webhook/                # Deploy webhook
├── migrations/             # Alembic DB migrations
├── logs/                   # Log files
├── requirements.txt        # Python dependencies
├── CHANGELOG.md            # Version history
└── README.md               # This file
```

## Tech Stack

- Python 3.12 + Flask
- PostgreSQL + Flask-SQLAlchemy (SQLite in dev)
- Bootstrap 5 + Chart.js
- ttyd (web terminal)
- Cloudflare Tunnel + Cloudflare Access
- Ubuntu Server 24.04

## Local Development

```bash
git clone <repo-url>
cd meduseld
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python app/webserver.py
```

Runs on `http://localhost:5001` in dev mode with a fake user and SQLite database.

## Deployment

Runs as a systemd service (`meduseld.service`) on the production server. Push to main, then pull and restart on the server. The webhook at `/webhook/deploy.sh` can automate this.

```bash
sudo systemctl restart meduseld
```

## Version

**0.5.0-alpha**
