# Icarus Server Control Panel - User Guide

Quick guide for controlling the Icarus dedicated server through your web browser.

## First Time Setup

### Step 1: Install Tailscale

Tailscale is a VPN that lets you securely access the server from anywhere.

1. **Download Tailscale**:
   - Go to: https://tailscale.com/download
   - Download for your operating system (Windows, Mac, Linux, iOS, Android)
   - Install it

2. **Login to Tailscale**:
   - Open Tailscale
   - Click "Log in"
   - Use this account:
     - Email: `404@meduseld.io`
     - Password: (provided by admin)
   - Complete the login

3. **Connect**:
   - Tailscale will automatically connect
   - You'll see a green checkmark when connected
   - Keep Tailscale running in the background

**Important**: You must be connected to Tailscale to access the control panel!

### Step 2: Access the Panel

Once Tailscale is connected, open your web browser and go to:
```
https://meduseld.io
```

You'll see the landing page. Click **"Enter the Great Hall"** to access the services menu.

From the menu, click **"Open Control Panel"** to access the Icarus server controls.

**Direct link to panel:**
```
https://panel.meduseld.io
```

Bookmark this for quick access!

**Supported Browsers:**
- Chrome / Edge (recommended)
- Firefox
- Safari
- Any modern browser

**You DON'T need:**
- ❌ Any other software installed
- ❌ Access to the server PC
- ❌ Technical knowledge
- ❌ Admin permissions

## Troubleshooting Tailscale

### "Can't access meduseld.io"

1. **Check Tailscale is connected**:
   - Look for Tailscale icon in system tray (Windows) or menu bar (Mac)
   - Should show green/connected status
   - If not connected, click it and select "Connect"

2. **Verify you're logged in**:
   - Open Tailscale
   - Check you're logged in as `404@meduseld.io`
   - If not, log out and log back in

3. **Try reconnecting**:
   - Disconnect from Tailscale
   - Wait 5 seconds
   - Connect again
   - Try accessing meduseld.io again

4. **Restart Tailscale**:
   - Quit Tailscale completely
   - Start it again
   - Wait for it to connect
   - Try accessing meduseld.io

### "Tailscale won't connect"

1. Check your internet connection
2. Try restarting Tailscale
3. Try restarting your computer
4. Contact the admin if still not working

### "Wrong password"

- Make sure you're using the password provided by the admin
- Check for typos (passwords are case-sensitive)
- Contact the admin if you've forgotten it

## Using Multiple Devices

You can install Tailscale on multiple devices:
- Your PC
- Your laptop
- Your phone
- Your tablet

Just install Tailscale on each device and log in with the same account (`404@meduseld.io`). Then you can access the control panel from any of them!

## Dashboard Overview

### Server Status Card (Left Side)

Shows the current state of the game server:

- **🟢 Running** - Server is online and accepting players
- **🔴 Offline** - Server is not running
- **🟡 Starting** - Server is booting up (wait ~30 seconds)
- **🟡 Stopping** - Server is shutting down
- **🟡 Restarting** - Server is updating and restarting
- **💥 Crashed** - Server has crashed (use Start to recover)

### Health Badge

- **⚔ Health: Good** - Everything is normal
- **⚠ Health: Warning** - High resource usage
- **☠ Health: Critical** - Very high resource usage

### Update Badge

- **🔄 Update Available** - A new server version is available
- **✓ Up to Date** - Server is on the latest version

### Resource Stats

- **Server CPU Usage** - How much CPU the game server is using
- **Server RAM Usage** - How much memory the game server is using
- **Uptime** - How long the server has been running

## Control Buttons (Right Side)

### Start Button (Green)
- Starts the server when it's offline
- Takes about 30-60 seconds to fully start
- Wait for status to show "Running" before joining

### Stop Button (Red)
- Gracefully shuts down the server
- Saves all player data before stopping
- Use this for normal shutdowns

### Restart Button (Yellow)
- **Automatically checks for updates**
- Stops the server, updates it, then starts it again
- Takes 2-5 minutes depending on update size
- **Use this regularly to keep the server updated**

### Kill Button (Dark Red)
- **Emergency use only!**
- Forces the server to stop immediately
- May cause data loss
- Only use if server is frozen/unresponsive

## System Stats (Top Row)

- **System Status** - Is the server PC online?
- **System CPU** - Total CPU usage of the server PC
- **System RAM** - Total RAM usage of the server PC
- **Disk Usage** - How full the hard drive is

## Live Logs

The log panel at the bottom shows real-time server logs:
- Server startup messages
- Player connections
- Errors and warnings
- You can scroll up to read older logs

## Graphs

Two graphs show resource usage over time:
- **CPU Usage** - System vs Server CPU
- **RAM Usage** - System vs Server RAM

These update every 30 seconds.

## Common Tasks

### Starting the Server for the First Time
1. Click the **Start** button
2. Wait for status to change to "Running" (~30 seconds)
3. Server is ready when you see "Running" status

### Regular Maintenance
1. Click the **Restart** button once a week
2. This checks for updates and applies them
3. Wait 2-5 minutes for restart to complete

### Shutting Down for Maintenance
1. Warn players in-game first!
2. Click the **Stop** button
3. Wait for status to show "Offline"
4. Perform your maintenance
5. Click **Start** when ready

### If Server Crashes
1. Status will show "💥 CRASHED"
2. Check the logs for error messages
3. Click **Start** to restart the server
4. If it crashes again, contact the admin

### If Server is Frozen
1. Try the **Stop** button first
2. Wait 30 seconds
3. If still frozen, use the **Kill** button
4. Wait for "Offline" status
5. Click **Start** to restart

## Best Practices

### DO:
- ✅ Use **Restart** regularly to keep server updated
- ✅ Use **Stop** for normal shutdowns
- ✅ Wait for status changes to complete
- ✅ Check logs if something goes wrong
- ✅ Warn players before restarting

### DON'T:
- ❌ Spam buttons (rate limited to prevent issues)
- ❌ Use **Kill** unless absolutely necessary
- ❌ Restart during active gameplay without warning
- ❌ Panic if server shows "Starting" for 30 seconds (normal)

## Troubleshooting

### "Server won't start"
- Check if status shows "Starting" - wait 60 seconds
- Check logs for error messages
- Try clicking **Start** again
- Contact admin if still not working

### "Can't access the panel"
- Check your internet connection
- Verify the server IP address
- Make sure you're using port 5000
- Contact admin if still can't connect

### "Restart is taking forever"
- Large updates can take 5-10 minutes
- Check if status shows "Restarting"
- Wait at least 10 minutes before taking action
- Contact admin if stuck for more than 15 minutes

### "Update Available" won't go away
- Click **Restart** to apply the update
- Wait for restart to complete
- Badge should change to "Up to Date"

## Understanding the Restart Process

When you click **Restart**:

1. **Server stops** (saves all data)
2. **Update check** runs via SteamCMD
3. **Files download** if update available
4. **Server starts** with new version
5. **Status shows "Running"** when ready

Total time: 2-10 minutes depending on update size.

## Rate Limiting

To prevent accidents, the panel limits how often you can use controls:
- Maximum 10 actions per minute
- Restart has a 30-second cooldown
- If you hit the limit, wait a minute and try again

## Activity Logging

All actions are logged with:
- Timestamp
- Your IP address
- Action performed

Admins can review this log to see who did what.

## Tips for Multiple Users

- **Communicate** before restarting
- **Check status** before taking action
- **Don't fight** over controls (last action wins)
- **Be patient** during state transitions
- **Ask admin** if unsure about something

## Emergency Contacts

If something goes wrong and you can't fix it:

1. Check the logs first
2. Try the troubleshooting steps above
3. Contact the server admin
4. Provide details: what you did, what happened, any error messages

## Panel Updates

The admin may occasionally update the control panel itself. When this happens:
- The panel will be unavailable for 1-2 minutes
- **The game server will keep running**
- Just refresh your browser when it's back

---

**Remember**: The game server and control panel are separate. Updating the panel doesn't affect the game server!

## Quick Reference Card

**To access the panel:**
1. ✅ Connect to Tailscale (404@meduseld.io)
2. ✅ Go to https://meduseld.io
3. ✅ Click "Enter the Great Hall"
4. ✅ Click "Open Control Panel"
5. ✅ Control the server!

**Direct link:** https://panel.meduseld.io

**If you can't access:**
1. Check Tailscale is connected (green icon)
2. Try reconnecting Tailscale
3. Restart Tailscale
4. Contact admin

**Common actions:**
- Start server: Green "Start" button
- Stop server: Red "Stop" button  
- Update server: Yellow "Restart" button
- Emergency: Dark red "Kill" button

Have fun and happy gaming! 🎮
