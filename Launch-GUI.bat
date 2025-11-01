(base) PS C:\WINDOWS\system32> git push
fatal: not a git repository (or any of the parent directories): .git
(base) PS C:\WINDOWS\system32> irm https://raw.githubusercontent.com/duonghuyhieu/hieu-phap-su/main/quick-run.ps1 | iex
========================================
Phasmophobia Save Manager - Quick Run
========================================

Downloading GUI from GitHub...
Downloading sync scripts...

Download complete!

Installing dependencies...
WARNING: Failed to install dependencies!
Upload/Download features may not work properly.

Launching GUI...


ERROR: Failed to download from GitHub!

Error details: At C:\Users\Hieu PC\AppData\Local\Temp\phasmophobia-gui\phasmophobia-hacker-gui.ps1:210 char:26
+ function Show-SystemInfo {
+                          ~
Missing closing '}' in statement block or type definition.

Please check:
  1. You have internet connection
  2. GitHub repository URL is correct
  3. The files exist in the repository

Press Enter to exit:@echo off
REM Phasmophobia Save Manager - GUI Launcher
REM Double-click this file to open the graphical interface

echo Starting Phasmophobia Save Manager GUI...

REM Check if PowerShell is available
where powershell >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: PowerShell not found!
    echo PowerShell is required to run the GUI.
    echo.
    echo Please use the batch files instead:
    echo   - sync-up.bat for uploading
    echo   - sync-down.bat for downloading
    echo.
    pause
    exit /b 1
)

REM Launch PowerShell GUI
powershell -ExecutionPolicy Bypass -File "%~dp0phasmophobia-sync-gui.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo An error occurred while running the GUI.
    echo You can still use the command-line tools:
    echo   - scripts\sync-up.bat
    echo   - scripts\sync-down.bat
    echo.
    pause
)

