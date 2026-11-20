@echo off
setlocal
cd /d "%~dp0"
where node >nul 2>nul
if errorlevel 1 (
  echo Please install Node.js 24 or newer, then run this file again.
  pause
  exit /b 1
)
echo Starting College Football Fan Poll...
echo Keep this window open while using the app.
node scripts/dev.mjs
if errorlevel 1 pause
