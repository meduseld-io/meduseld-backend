@echo off
REM Launch script for Icarus server - runs independently of the control panel
cd /d C:\icarusserver
start "" "C:\icarusserver\IcarusServer.exe" -SteamServerName=404localserver -Port=17777 -QueryPort=27015 -Log
