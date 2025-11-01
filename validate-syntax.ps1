# Validate PowerShell script syntax
param(
    [string]$FilePath = "phasmophobia-hacker-gui.ps1"
)

Write-Host "Validating: $FilePath" -ForegroundColor Cyan
Write-Host ""

# Try to parse the file
try {
    $content = Get-Content $FilePath -Raw -ErrorAction Stop
    $parseErrors = $null
    $tokens = [System.Management.Automation.PSParser]::Tokenize($content, [ref]$parseErrors)

    if ($parseErrors.Count -eq 0) {
        Write-Host "[OK] NO SYNTAX ERRORS FOUND!" -ForegroundColor Green
        Write-Host ""
        Write-Host "File is valid and ready to use." -ForegroundColor Green
        exit 0
    } else {
        Write-Host "[ERROR] SYNTAX ERRORS FOUND:" -ForegroundColor Red
        Write-Host ""
        foreach ($err in $parseErrors) {
            Write-Host "Line $($err.Token.StartLine): $($err.Message)" -ForegroundColor Yellow
        }
        exit 1
    }
} catch {
    Write-Host "[ERROR] ERROR READING FILE:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Yellow
    exit 1
}

