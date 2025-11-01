@echo off
REM Phasmophobia Save Manager - Hacker Style GUI Launcher

REM Check if PowerShell is available
where powershell >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: PowerShell not found!
    echo PowerShell is required to run the GUI.
    pause
    exit /b 1
)

REM Launch Hacker Style GUI
powershell -ExecutionPolicy Bypass -File "%~dp0phasmophobia-hacker-gui.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo An error occurred while running the GUI.
    pause
)

