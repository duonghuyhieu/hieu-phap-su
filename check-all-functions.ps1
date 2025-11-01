# Check all functions for balanced braces
$lines = Get-Content 'phasmophobia-hacker-gui.ps1'
$functions = @()
$currentFunction = $null
$braceCount = 0

for ($i = 0; $i -lt $lines.Count; $i++) {
    $lineNum = $i + 1
    $line = $lines[$i]
    
    # Detect function start
    if ($line -match '^function\s+(\S+)') {
        if ($currentFunction) {
            # Previous function didn't close properly
            $currentFunction.EndLine = $lineNum - 1
            $currentFunction.BraceBalance = $braceCount
            $functions += $currentFunction
        }
        
        $currentFunction = [PSCustomObject]@{
            Name = $matches[1]
            StartLine = $lineNum
            EndLine = 0
            BraceBalance = 0
        }
        $braceCount = 0
    }
    
    if ($currentFunction) {
        $openBraces = ($line.ToCharArray() | Where-Object { $_ -eq '{' }).Count
        $closeBraces = ($line.ToCharArray() | Where-Object { $_ -eq '}' }).Count
        $braceCount += $openBraces - $closeBraces
        
        # Function ends when braces balance and we're past the first line
        if ($braceCount -eq 0 -and $lineNum -gt $currentFunction.StartLine) {
            $currentFunction.EndLine = $lineNum
            $currentFunction.BraceBalance = 0
            $functions += $currentFunction
            $currentFunction = $null
        }
    }
}

# Check if last function didn't close
if ($currentFunction) {
    $currentFunction.EndLine = $lines.Count
    $currentFunction.BraceBalance = $braceCount
    $functions += $currentFunction
}

# Display results
Write-Host ""
Write-Host "FUNCTION ANALYSIS:" -ForegroundColor Cyan
Write-Host "==================" -ForegroundColor Cyan
Write-Host ""

$hasErrors = $false
foreach ($func in $functions) {
    $status = if ($func.BraceBalance -eq 0) { "[OK]" } else { "[ERROR]" }
    $color = if ($func.BraceBalance -eq 0) { "Green" } else { "Red" }
    
    Write-Host "$status $($func.Name)" -ForegroundColor $color
    Write-Host "      Lines: $($func.StartLine)-$($func.EndLine)" -ForegroundColor Gray
    
    if ($func.BraceBalance -ne 0) {
        Write-Host "      Missing $($func.BraceBalance) closing braces!" -ForegroundColor Yellow
        $hasErrors = $true
    }
    Write-Host ""
}

if ($hasErrors) {
    Write-Host "[ERROR] Some functions have unbalanced braces!" -ForegroundColor Red
    exit 1
} else {
    Write-Host "[OK] All functions have balanced braces!" -ForegroundColor Green
    exit 0
}

