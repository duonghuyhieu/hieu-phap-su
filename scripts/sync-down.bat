@echo off
REM Phasmophobia Save Sync Down Script
REM Usage: sync-down.bat [SAVE_ID]

setlocal

if "%~1"=="" (
    echo Error: Please provide a save ID
    echo Usage: sync-down.bat [SAVE_ID]
    echo Example: sync-down.bat abc123xyz456
    pause
    exit /b 1
)

echo ========================================
echo  Phasmophobia Save Sync Down
echo ========================================
echo.
echo WARNING: This will replace your current save!
echo A backup will be created automatically.
echo.
set /p confirm="Continue? (Y/N): "

if /i not "%confirm%"=="Y" (
    echo Operation cancelled.
    pause
    exit /b 0
)

echo.

cd /d "%~dp0"

node sync.js down "%~1"

echo.
echo ========================================
pause

