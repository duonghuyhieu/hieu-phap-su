# Phasmophobia Save Manager - Quick Run Script
# Run this with: irm https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO_NAME/main/quick-run.ps1 | iex

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Phasmophobia Save Manager - Quick Run" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Create temp directory
$tempDir = Join-Path $env:TEMP "phasmophobia-gui"
if (-not (Test-Path $tempDir)) {
    New-Item -Path $tempDir -ItemType Directory -Force | Out-Null
}

Write-Host "Downloading GUI from GitHub..." -ForegroundColor Yellow

# GitHub repository URL
$repoUrl = "https://raw.githubusercontent.com/duonghuyhieu/hieu-phap-su/main"

try {
    # Download Hacker Style GUI script
    $guiPath = Join-Path $tempDir "phasmophobia-hacker-gui.ps1"
    Invoke-WebRequest -Uri "$repoUrl/phasmophobia-hacker-gui.ps1" -OutFile $guiPath -ErrorAction Stop
    
    # Download scripts folder
    $scriptsDir = Join-Path $tempDir "scripts"
    if (-not (Test-Path $scriptsDir)) {
        New-Item -Path $scriptsDir -ItemType Directory -Force | Out-Null
    }
    
    Write-Host "Downloading sync scripts..." -ForegroundColor Yellow
    
    Invoke-WebRequest -Uri "$repoUrl/scripts/sync-up.bat" -OutFile (Join-Path $scriptsDir "sync-up.bat") -ErrorAction Stop
    Invoke-WebRequest -Uri "$repoUrl/scripts/sync-down.bat" -OutFile (Join-Path $scriptsDir "sync-down.bat") -ErrorAction Stop
    Invoke-WebRequest -Uri "$repoUrl/scripts/sync.js" -OutFile (Join-Path $scriptsDir "sync.js") -ErrorAction Stop
    Invoke-WebRequest -Uri "$repoUrl/scripts/config.js" -OutFile (Join-Path $scriptsDir "config.js") -ErrorAction Stop
    Invoke-WebRequest -Uri "$repoUrl/scripts/package.json" -OutFile (Join-Path $scriptsDir "package.json") -ErrorAction Stop
    
    Write-Host ""
    Write-Host "Download complete!" -ForegroundColor Green
    Write-Host ""
    
    # Check if Node.js is installed
    $nodeInstalled = $false
    try {
        $null = node --version
        $nodeInstalled = $true
    } catch {
        $nodeInstalled = $false
    }
    
    if ($nodeInstalled) {
        Write-Host "Installing dependencies..." -ForegroundColor Yellow
        try {
            Push-Location -LiteralPath $scriptsDir
            npm install --silent 2>&1 | Out-Null
            Pop-Location
            Write-Host "Dependencies installed!" -ForegroundColor Green
        } catch {
            Pop-Location
            Write-Host "WARNING: Failed to install dependencies!" -ForegroundColor Yellow
            Write-Host "Upload/Download features may not work properly." -ForegroundColor Yellow
        }
    } else {
        Write-Host "WARNING: Node.js not found!" -ForegroundColor Red
        Write-Host "Upload/Download features may not work." -ForegroundColor Yellow
        Write-Host "Install Node.js from: https://nodejs.org" -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "Launching GUI..." -ForegroundColor Green
    Write-Host ""
    
    # Launch GUI
    & "$guiPath"
    
    Write-Host ""
    Write-Host "GUI closed." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Temporary files stored in: $tempDir" -ForegroundColor Gray
    Write-Host "You can delete this folder if you want." -ForegroundColor Gray
    
} catch {
    Write-Host ""
    Write-Host "ERROR: Failed to download from GitHub!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Error details: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please check:" -ForegroundColor Yellow
    Write-Host "  1. You have internet connection" -ForegroundColor Yellow
    Write-Host "  2. GitHub repository URL is correct" -ForegroundColor Yellow
    Write-Host "  3. The files exist in the repository" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit"
}

