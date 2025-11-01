@echo off
REM Phasmophobia Save Sync Up Script
REM Usage: sync-up.bat "Save Name"

setlocal

if "%~1"=="" (
    echo Error: Please provide a save name
    echo Usage: sync-up.bat "Save Name"
    echo Example: sync-up.bat "Level 50 All Items"
    pause
    exit /b 1
)

echo ========================================
echo  Phasmophobia Save Sync Up
echo ========================================
echo.

cd /d "%~dp0"

node sync.js up "%~1"

echo.
echo ========================================
pause

