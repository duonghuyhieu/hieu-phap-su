# Phasmophobia Save Manager - Hacker Style
# Simple menu-based CLI interface

# Set console colors
$host.UI.RawUI.BackgroundColor = "Black"
$host.UI.RawUI.ForegroundColor = "Green"
Clear-Host

# ASCII Art Banner
function Show-Banner {
    Write-Host ""
    Write-Host "  ██████╗ ██╗  ██╗ █████╗ ███████╗███╗   ███╗ ██████╗ " -ForegroundColor Cyan
    Write-Host "  ██╔══██╗██║  ██║██╔══██╗██╔════╝████╗ ████║██╔═══██╗" -ForegroundColor Cyan
    Write-Host "  ██████╔╝███████║███████║███████╗██╔████╔██║██║   ██║" -ForegroundColor Cyan
    Write-Host "  ██╔═══╝ ██╔══██║██╔══██║╚════██║██║╚██╔╝██║██║   ██║" -ForegroundColor Cyan
    Write-Host "  ██║     ██║  ██║██║  ██║███████║██║ ╚═╝ ██║╚██████╔╝" -ForegroundColor Cyan
    Write-Host "  ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝ ╚═════╝ " -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  ═══════════════════════════════════════════════════" -ForegroundColor DarkGreen
    Write-Host "  │  SAVE MANAGER v2.0 - GHOST HUNTING EDITION  │" -ForegroundColor Green
    Write-Host "  ═══════════════════════════════════════════════════" -ForegroundColor DarkGreen
    Write-Host ""
}

# Show loading animation
function Show-Loading {
    param([string]$Message)
    Write-Host ""
    Write-Host "  [" -NoNewline -ForegroundColor DarkGreen
    Write-Host "~" -NoNewline -ForegroundColor Yellow
    Write-Host "] " -NoNewline -ForegroundColor DarkGreen
    Write-Host "$Message" -ForegroundColor White
    Start-Sleep -Milliseconds 500
}

# Show success message
function Show-Success {
    param([string]$Message)
    Write-Host "  [" -NoNewline -ForegroundColor DarkGreen
    Write-Host "+" -NoNewline -ForegroundColor Green
    Write-Host "] " -NoNewline -ForegroundColor DarkGreen
    Write-Host "$Message" -ForegroundColor Green
}

# Show error message
function Show-Error {
    param([string]$Message)
    Write-Host "  [" -NoNewline -ForegroundColor DarkGreen
    Write-Host "!" -NoNewline -ForegroundColor Red
    Write-Host "] " -NoNewline -ForegroundColor DarkGreen
    Write-Host "$Message" -ForegroundColor Red
}

# Show info message
function Show-Info {
    param([string]$Message)
    Write-Host "  [" -NoNewline -ForegroundColor DarkGreen
    Write-Host "*" -NoNewline -ForegroundColor Cyan
    Write-Host "] " -NoNewline -ForegroundColor DarkGreen
    Write-Host "$Message" -ForegroundColor Cyan
}

# Show main menu
function Show-Menu {
    Write-Host ""
    Write-Host "  ┌─────────────────────────────────────────────┐" -ForegroundColor DarkGreen
    Write-Host "  │           MAIN MENU - SELECT OPTION         │" -ForegroundColor Green
    Write-Host "  ├─────────────────────────────────────────────┤" -ForegroundColor DarkGreen
    Write-Host "  │                                             │" -ForegroundColor DarkGreen
    Write-Host "  │  [" -NoNewline -ForegroundColor DarkGreen
    Write-Host "1" -NoNewline -ForegroundColor Yellow
    Write-Host "] Upload Save to Cloud              │" -ForegroundColor DarkGreen
    Write-Host "  │  [" -NoNewline -ForegroundColor DarkGreen
    Write-Host "2" -NoNewline -ForegroundColor Yellow
    Write-Host "] Download Save from Cloud          │" -ForegroundColor DarkGreen
    Write-Host "  │  [" -NoNewline -ForegroundColor DarkGreen
    Write-Host "3" -NoNewline -ForegroundColor Yellow
    Write-Host "] Open Web Interface                │" -ForegroundColor DarkGreen
    Write-Host "  │  [" -NoNewline -ForegroundColor DarkGreen
    Write-Host "4" -NoNewline -ForegroundColor Yellow
    Write-Host "] Open Save Folder                  │" -ForegroundColor DarkGreen
    Write-Host "  │  [" -NoNewline -ForegroundColor DarkGreen
    Write-Host "5" -NoNewline -ForegroundColor Yellow
    Write-Host "] System Info                       │" -ForegroundColor DarkGreen
    Write-Host "  │  [" -NoNewline -ForegroundColor DarkGreen
    Write-Host "0" -NoNewline -ForegroundColor Red
    Write-Host "] Exit                              │" -ForegroundColor DarkGreen
    Write-Host "  │                                             │" -ForegroundColor DarkGreen
    Write-Host "  └─────────────────────────────────────────────┘" -ForegroundColor DarkGreen
    Write-Host ""
    Write-Host "  >> " -NoNewline -ForegroundColor Green
}

# Upload function
function Invoke-Upload {
    Clear-Host
    Show-Banner
    Write-Host ""
    Write-Host "  ┌─────────────────────────────────────────────┐" -ForegroundColor DarkGreen
    Write-Host "  │              UPLOAD SAVE TO CLOUD           │" -ForegroundColor Yellow
    Write-Host "  └─────────────────────────────────────────────┘" -ForegroundColor DarkGreen
    Write-Host ""
    
    Write-Host "  Enter save name: " -NoNewline -ForegroundColor Cyan
    $saveName = Read-Host
    
    if ([string]::IsNullOrWhiteSpace($saveName)) {
        Show-Error "Save name cannot be empty!"
        Start-Sleep -Seconds 2
        return
    }
    
    Show-Loading "Initializing upload sequence..."
    Show-Loading "Compressing save files..."
    Show-Loading "Connecting to cloud..."
    
    # Run upload script
    $scriptPath = Join-Path $PSScriptRoot "scripts\sync-up.bat"
    if (Test-Path -LiteralPath $scriptPath) {
        & "$scriptPath" "$saveName"
        Show-Success "Upload completed!"
    } else {
        Show-Error "Upload script not found!"
    }
    
    Write-Host ""
    Write-Host "  Press any key to continue..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# Download function
function Invoke-Download {
    Clear-Host
    Show-Banner
    Write-Host ""
    Write-Host "  ┌─────────────────────────────────────────────┐" -ForegroundColor DarkGreen
    Write-Host "  │           DOWNLOAD SAVE FROM CLOUD          │" -ForegroundColor Yellow
    Write-Host "  └─────────────────────────────────────────────┘" -ForegroundColor DarkGreen
    Write-Host ""
    
    Write-Host "  Enter Save ID: " -NoNewline -ForegroundColor Cyan
    $saveId = Read-Host
    
    if ([string]::IsNullOrWhiteSpace($saveId)) {
        Show-Error "Save ID cannot be empty!"
        Start-Sleep -Seconds 2
        return
    }
    
    Show-Info "WARNING: This will replace your current save!"
    Write-Host "  Continue? (Y/N): " -NoNewline -ForegroundColor Yellow
    $confirm = Read-Host
    
    if ($confirm -ne "Y" -and $confirm -ne "y") {
        Show-Info "Download cancelled."
        Start-Sleep -Seconds 2
        return
    }
    
    Show-Loading "Connecting to cloud..."
    Show-Loading "Downloading save data..."
    Show-Loading "Creating backup..."
    Show-Loading "Extracting files..."
    
    # Run download script
    $scriptPath = Join-Path $PSScriptRoot "scripts\sync-down.bat"
    if (Test-Path -LiteralPath $scriptPath) {
        & "$scriptPath" "$saveId"
        Show-Success "Download completed!"
    } else {
        Show-Error "Download script not found!"
    }
    
    Write-Host ""
    Write-Host "  Press any key to continue..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# Open web interface
function Open-WebInterface {
    Clear-Host
    Show-Banner
    Show-Loading "Opening web interface..."
    Start-Process "http://localhost:3000"
    Show-Success "Web interface opened in browser"
    Show-Info "If page doesn't load, run 'npm run dev' first"
    Start-Sleep -Seconds 2
}

# Open save folder
function Open-SaveFolder {
    Clear-Host
    Show-Banner
    $savePath = "$env:APPDATA\..\LocalLow\Kinetic Games\Phasmophobia"

    if (Test-Path -LiteralPath $savePath) {
        Show-Loading "Opening save folder..."
        Start-Process "explorer.exe" -ArgumentList "`"$savePath`""
        Show-Success "Save folder opened"
    } else {
        Show-Error "Save folder not found!"
        Show-Info "Path: $savePath"
    }
    Start-Sleep -Seconds 2
}

# Show system info
function Show-SystemInfo {
    Clear-Host
    Show-Banner
    Write-Host ""
    Write-Host "  ┌─────────────────────────────────────────────┐" -ForegroundColor DarkGreen
    Write-Host "  │              SYSTEM INFORMATION             │" -ForegroundColor Yellow
    Write-Host "  └─────────────────────────────────────────────┘" -ForegroundColor DarkGreen
    Write-Host ""
    
    # Check Node.js
    try {
        $nodeVersion = node --version 2>$null
        Show-Success "Node.js: $nodeVersion"
    } catch {
        Show-Error "Node.js: Not installed"
    }
    
    # Check save folder
    $savePath = "$env:APPDATA\..\LocalLow\Kinetic Games\Phasmophobia"
    if (Test-Path -LiteralPath $savePath) {
        Show-Success "Save folder: Found"
        Show-Info "Location: $savePath"
    } else {
        Show-Error "Save folder: Not found"
    }
    
    # Check scripts
    $scriptsPath = Join-Path $PSScriptRoot "scripts"
    if (Test-Path -LiteralPath $scriptsPath) {
        Show-Success "Scripts: Found"
    } else {
        Show-Error "Scripts: Not found"
    }
    
    Write-Host ""
    Write-Host "  Press any key to continue..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# Main loop
$running = $true
while ($running) {
    Clear-Host
    Show-Banner
    Show-Menu
    
    $choice = Read-Host
    
    switch ($choice) {
        "1" { Invoke-Upload }
        "2" { Invoke-Download }
        "3" { Open-WebInterface }
        "4" { Open-SaveFolder }
        "5" { Show-SystemInfo }
        "0" { 
            Clear-Host
            Show-Banner
            Show-Info "Shutting down..."
            Start-Sleep -Seconds 1
            $running = $false
        }
        default {
            Show-Error "Invalid option!"
            Start-Sleep -Seconds 1
        }
    }
}

Clear-Host
Write-Host ""
Write-Host "  ═══════════════════════════════════════════════════" -ForegroundColor DarkGreen
Write-Host "  │         THANK YOU FOR USING PHASMO MANAGER        │" -ForegroundColor Green
Write-Host "  ═══════════════════════════════════════════════════" -ForegroundColor DarkGreen
Write-Host ""

