"""
Configuration file for Icarus Server Control Panel
Edit these values to match your setup
"""

import os

# ================= SERVER CONFIGURATION =================

# Path to the server executable
LAUNCH_EXE = r"C:\icarusserver\IcarusServer.exe"

# Path to launch script (recommended for process isolation)
LAUNCH_SCRIPT = r"launch_server.bat"

# Process name to monitor
PROCESS_NAME = "IcarusServer-Win64-Shipping.exe"

# Path to server log file
LOG_FILE = r"C:\icarusserver\Icarus\Saved\Logs\Icarus.log"

# Path to update script
UPDATE_SCRIPT = r"C:\icarusserver\updateserver.bat"

# Steam App ID for version checking
STEAM_APP_ID = "2089300"  # Icarus Dedicated Server

# Path to store version information
VERSION_FILE = r"C:\icarusserver\version.txt"

# Server working directory
SERVER_DIR = r"C:\icarusserver"

# ================= SERVER LAUNCH ARGUMENTS =================

SERVER_ARGS = [
    "-SteamServerName=404localserver",
    "-Port=17777",
    "-QueryPort=27015",
    "-Log"
]

# ================= SECURITY =================

# Flask secret key for session management (generate a secure one for production)
SECRET_KEY = "change-this-to-a-random-secret-key-in-production"

# IP whitelist (empty list = allow all)
# Example: ALLOWED_IPS = ["192.168.1.0/24", "10.0.0.5"]
ALLOWED_IPS = []

# ================= SECURITY CONFIGURATION =================

# Allowed hostnames
ALLOWED_HOSTS = [
    "localhost",
    "127.0.0.1",
    "meduseld.io",
    "panel.meduseld.io"
]

# Rate limiting
RATE_LIMIT_WINDOW = 60  # seconds
RATE_LIMIT_MAX_REQUESTS = 10  # max requests per window

# ================= TIMING CONFIGURATION =================

# Cooldown between restarts (seconds)
RESTART_COOLDOWN = 30

# Timeout for server start (seconds)
START_TIMEOUT = 60

# Timeout for server stop (seconds)
STOP_TIMEOUT = 30

# Timeout for update script (seconds)
UPDATE_TIMEOUT = 600

# How often to check for updates (seconds)
UPDATE_CHECK_INTERVAL = 3600  # 1 hour

# How often to collect stats (seconds)
STATS_COLLECTION_INTERVAL = 30

# How often to check server state (seconds)
MONITOR_INTERVAL = 5

# ================= HEALTH THRESHOLDS =================

# System health warning thresholds
WARNING_CPU = 80
WARNING_RAM = 80
WARNING_DISK = 85

# System health critical thresholds
CRITICAL_CPU = 95
CRITICAL_RAM = 90
CRITICAL_DISK = 95

# ================= LOGGING CONFIGURATION =================

# Log file path
LOG_FILE_PATH = "webserver.log"

# Log level (DEBUG, INFO, WARNING, ERROR, CRITICAL)
LOG_LEVEL = "INFO"

# ================= FLASK CONFIGURATION =================

# Flask host
FLASK_HOST = "0.0.0.0"

# Flask port
FLASK_PORT = 5000

# Flask debug mode (set to False in production)
FLASK_DEBUG = False
