"""
Standalone backup microservice for Meduseld.
Runs independently of the main Flask app so backups can be triggered
from the system page even when the panel is down.

Listens on port 5003, accepts POST /backup with a shared secret token.
Triggers the backup.sh script via systemd.
Runs as its own systemd service: meduseld-backup-api.service
"""

import json
import os
import subprocess
import threading
from http.server import HTTPServer, BaseHTTPRequestHandler

PORT = 5003
BACKUP_SECRET = os.environ.get("BACKUP_SECRET")

backup_in_progress = False
backup_status = {"running": False, "last_result": None}


class BackupHandler(BaseHTTPRequestHandler):
    def _cors_headers(self):
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "POST, GET, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")

    def do_OPTIONS(self):
        self.send_response(204)
        self._cors_headers()
        self.end_headers()

    def do_GET(self):
        if self.path == "/health":
            self._respond(200, {"status": "ok"})
        elif self.path == "/status":
            self._respond(200, backup_status)
        else:
            self.send_response(404)
            self.end_headers()

    def do_POST(self):
        if self.path != "/backup":
            self.send_response(404)
            self.end_headers()
            return

        if not BACKUP_SECRET:
            self._respond(503, {"error": "Backup secret not configured"})
            return

        length = int(self.headers.get("Content-Length", 0))
        body = self.rfile.read(length) if length else b"{}"
        try:
            data = json.loads(body)
        except json.JSONDecodeError:
            self._respond(400, {"error": "Invalid JSON"})
            return

        token = data.get("token", "")
        if token != BACKUP_SECRET:
            print(f"[WARN] Unauthorized backup attempt from {self.client_address[0]}")
            self._respond(403, {"error": "Unauthorized"})
            return

        if backup_status["running"]:
            self._respond(409, {"error": "Backup already in progress"})
            return

        print(f"[INFO] Backup triggered from {self.client_address[0]}")
        self._respond(200, {"success": True, "message": "Backup started"})

        def run_backup():
            global backup_status
            backup_status = {"running": True, "last_result": None}
            try:
                result = subprocess.run(
                    ["sudo", "systemctl", "start", "meduseld-backup.service"],
                    capture_output=True,
                    text=True,
                    timeout=1800,
                )
                if result.returncode == 0:
                    # Read backup filename if available
                    filename = None
                    try:
                        with open("/tmp/meduseld-last-backup-name", "r") as f:
                            filename = f.read().strip()
                    except Exception:
                        pass
                    backup_status = {
                        "running": False,
                        "last_result": "success",
                        "filename": filename,
                    }
                    print("[INFO] Backup completed successfully")
                else:
                    backup_status = {
                        "running": False,
                        "last_result": f"failed: {result.stderr.strip()}",
                    }
                    print(f"[ERROR] Backup failed: {result.stderr.strip()}")
            except subprocess.TimeoutExpired:
                backup_status = {"running": False, "last_result": "failed: timeout"}
                print("[ERROR] Backup timed out")
            except Exception as e:
                backup_status = {"running": False, "last_result": f"failed: {str(e)}"}
                print(f"[ERROR] Backup error: {e}")

        threading.Thread(target=run_backup, daemon=True).start()

    def _respond(self, code, data):
        self.send_response(code)
        self._cors_headers()
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        self.wfile.write(json.dumps(data).encode())

    def log_message(self, format, *args):
        print(f"[backup-service] {args[0]}")


if __name__ == "__main__":
    if not BACKUP_SECRET:
        print("[ERROR] BACKUP_SECRET environment variable is not set. Exiting.")
        exit(1)

    server = HTTPServer(("0.0.0.0", PORT), BackupHandler)
    print(f"[backup-service] Listening on 0.0.0.0:{PORT}")
    server.serve_forever()
