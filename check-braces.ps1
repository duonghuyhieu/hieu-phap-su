# Check braces in Show-SystemInfo function
$lines = Get-Content 'phasmophobia-hacker-gui.ps1'
$inFunction = $false
$braceCount = 0
$functionStart = 0

for ($i = 0; $i -lt $lines.Count; $i++) {
    $lineNum = $i + 1
    $line = $lines[$i]
    
    if ($line -match 'function Show-SystemInfo') {
        $inFunction = $true
        $functionStart = $lineNum
        Write-Host "Function starts at line $lineNum" -ForegroundColor Cyan
    }
    
    if ($inFunction) {
        $openBraces = ($line.ToCharArray() | Where-Object { $_ -eq '{' }).Count
        $closeBraces = ($line.ToCharArray() | Where-Object { $_ -eq '}' }).Count
        $braceCount += $openBraces - $closeBraces
        
        if ($openBraces -gt 0 -or $closeBraces -gt 0) {
            Write-Host "Line $lineNum : Open=$openBraces Close=$closeBraces Total=$braceCount" -ForegroundColor Gray
        }
        
        if ($braceCount -eq 0 -and $lineNum -gt $functionStart) {
            Write-Host "Function ends at line $lineNum" -ForegroundColor Green
            break
        }
    }
}

if ($braceCount -ne 0) {
    Write-Host ""
    Write-Host "[ERROR] Function Show-SystemInfo is missing $braceCount closing braces!" -ForegroundColor Red
} else {
    Write-Host ""
    Write-Host "[OK] Function Show-SystemInfo has balanced braces" -ForegroundColor Green
}

