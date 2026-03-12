@echo off
setlocal
cd /d "%~dp0"

REM One-click deploy entrypoint (avoids PowerShell execution policy issues)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0deploy_github.ps1"
if errorlevel 1 (
  echo.
  echo Deploy failed. See messages above.
  pause
  exit /b 1
)

echo.
echo Deploy finished.
pause

