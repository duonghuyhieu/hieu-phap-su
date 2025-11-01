@echo off
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

