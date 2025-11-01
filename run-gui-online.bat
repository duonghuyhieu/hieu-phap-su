@echo off
REM Phasmophobia Save Manager - Online GUI Launcher
REM This script downloads and runs the GUI directly from GitHub

echo ========================================
echo Phasmophobia Save Manager - Online GUI
echo ========================================
echo.

REM Check if PowerShell is available
where powershell >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: PowerShell not found!
    echo PowerShell is required to run this script.
    pause
    exit /b 1
)

echo Downloading GUI from GitHub...
echo.

REM Create temp directory
set TEMP_DIR=%TEMP%\phasmophobia-gui
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

REM Download the PowerShell GUI script from GitHub
powershell -Command "& { Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/duonghuyhieu/hieu-phap-su/main/phasmophobia-sync-gui.ps1' -OutFile '%TEMP_DIR%\phasmophobia-sync-gui.ps1' }"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Failed to download GUI from GitHub!
    echo.
    echo Please check:
    echo   1. You have internet connection
    echo   2. GitHub repository URL is correct
    echo   3. The file exists in the repository
    echo.
    pause
    exit /b 1
)

REM Download the batch scripts
echo Downloading sync scripts...
if not exist "%TEMP_DIR%\scripts" mkdir "%TEMP_DIR%\scripts"

powershell -Command "& { Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/duonghuyhieu/hieu-phap-su/main/scripts/sync-up.bat' -OutFile '%TEMP_DIR%\scripts\sync-up.bat' }"
powershell -Command "& { Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/duonghuyhieu/hieu-phap-su/main/scripts/sync-down.bat' -OutFile '%TEMP_DIR%\scripts\sync-down.bat' }"
powershell -Command "& { Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/duonghuyhieu/hieu-phap-su/main/scripts/sync.js' -OutFile '%TEMP_DIR%\scripts\sync.js' }"
powershell -Command "& { Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/duonghuyhieu/hieu-phap-su/main/scripts/config.js' -OutFile '%TEMP_DIR%\scripts\config.js' }"
powershell -Command "& { Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/duonghuyhieu/hieu-phap-su/main/scripts/package.json' -OutFile '%TEMP_DIR%\scripts\package.json' }"

echo.
echo Download complete!
echo.
echo Installing dependencies...
cd /d "%TEMP_DIR%\scripts"
call npm install

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo WARNING: Failed to install dependencies!
    echo You may need to install Node.js from https://nodejs.org
    echo.
    echo The GUI will still open, but upload/download may not work.
    echo.
    pause
)

echo.
echo Launching GUI...
echo.

REM Launch the GUI
cd /d "%TEMP_DIR%"
powershell -ExecutionPolicy Bypass -File "%TEMP_DIR%\phasmophobia-sync-gui.ps1"

echo.
echo GUI closed.
echo.
echo Temporary files are stored in: %TEMP_DIR%
echo You can delete this folder if you want.
echo.
pause

