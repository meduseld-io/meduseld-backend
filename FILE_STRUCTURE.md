# File Structure

Quick reference for what each file does.

## 📁 Core Application Files

```
webserver.py          - Main application (don't edit)
config.py             - Configuration (edit this!)
requirements.txt      - Python dependencies
launch_server.bat     - Game server launcher
updateserver.bat      - Your SteamCMD update script
```

## 🔧 Admin Scripts (For You)

```
setup_service.bat     - Initial service setup (run once as Admin)
restart_panel.bat     - Quick panel restart
update_panel.bat      - Full update (git + restart)
stop_panel.bat        - Stop panel completely
diagnose_service.bat  - Service diagnostics
health_check.bat      - System health check
nssm.exe             - Service manager (don't delete!)
```

## 📚 Documentation

```
README.md             - Project overview
ADMIN_SCRIPTS.md      - What each script does (for you)
USER_GUIDE.md         - How to use the panel (for friends)
DEPLOYMENT_GUIDE.md   - Full deployment guide (for you)
SERVICE_SETUP.md      - Service configuration (for you)
WHATS_NEW.md          - Recent improvements
FILE_STRUCTURE.md     - This file!
```

## 🌐 Web Files (Templates)

```
templates/
  ├── base.html       - Base template
  ├── dashboard.html  - Main control panel
  ├── landing.html    - Landing page
  ├── spotify.html    - Future feature
  └── settings.html   - Future feature

static/
  ├── css/
  │   └── style.css   - Styles
  ├── js/
  │   └── main.js     - JavaScript
  └── *.png           - Images/icons
```

## 📝 Generated Files (Auto-created)

```
webserver.log         - Application logs
service_stdout.log    - Service output
service_stderr.log    - Service errors
version.txt           - Current game server build ID
```

## 🗑️ Safe to Delete

These files are generated and can be deleted if needed:
- `webserver.log` (will be recreated)
- `service_stdout.log` (will be recreated)
- `service_stderr.log` (will be recreated)
- `__pycache__/` folder (Python cache)

## ⚠️ Don't Delete

Critical files:
- `webserver.py`
- `config.py`
- `requirements.txt`
- `nssm.exe`
- `templates/` folder
- `static/` folder

## 📦 What to Backup

Before major changes, backup:
- `config.py` (your settings)
- `version.txt` (current version)
- `webserver.log` (if investigating issues)

## 🚀 What Your Friends See

Your friends access through their browser at **meduseld.io** and see:
- Dashboard (templates/dashboard.html)
- Landing page (templates/landing.html)
- Static assets (CSS, JS, images)

They never see or need:
- Any .bat files
- Python files
- Configuration files
- Log files

## 📊 File Sizes (Approximate)

```
Small (<100 KB):
- All .bat files
- config.py
- requirements.txt
- version.txt

Medium (100 KB - 1 MB):
- webserver.py
- All documentation
- Templates
- nssm.exe

Large (>1 MB):
- webserver.log (grows over time)
- service logs (grow over time)
```

## 🔄 Files Modified by Panel

The panel automatically modifies:
- `version.txt` - Updated after successful game server update
- `webserver.log` - Continuously appended
- `service_stdout.log` - Continuously appended
- `service_stderr.log` - Continuously appended

## 📁 Recommended Folder Structure on Server

```
C:\
├── icarusserver\              (Game server)
│   ├── IcarusServer.exe
│   ├── updateserver.bat
│   └── Icarus\
│       └── Saved\             (Player data - BACKUP THIS!)
│
└── meduseld\                  (Control panel - this project)
    ├── webserver.py
    ├── config.py
    ├── templates\
    ├── static\
    └── [all other files]
```

## 🔐 Permissions Needed

Files that need write access:
- `webserver.log`
- `service_stdout.log`
- `service_stderr.log`
- `version.txt`

The service account needs:
- Read access to all panel files
- Write access to log files
- Execute access to Python
- Execute access to game server

## 📝 Notes

- Keep all files in the same directory
- Don't rename core files (webserver.py, config.py)
- Scripts expect to be run from the panel directory
- Logs rotate automatically (configured in service)

---

When in doubt, check ADMIN_SCRIPTS.md for what each script does!
