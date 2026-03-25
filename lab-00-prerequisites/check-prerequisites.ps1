# UbuCon Workshop Prerequisites Check Script
# Run this in PowerShell to verify your system is ready

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  UbuCon Workshop Prerequisites Check" -ForegroundColor Cyan
Write-Host "  Building Secure Dev Environments" -ForegroundColor Cyan  
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$allPassed = $true

# Check Windows version
Write-Host "Checking Windows version..." -ForegroundColor Yellow
$build = [System.Environment]::OSVersion.Version.Build
if ($build -ge 19041) {
    Write-Host "  [PASS] Windows Build: $build" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Windows Build: $build (need 19041+)" -ForegroundColor Red
    $allPassed = $false
}

# Check WSL installation
Write-Host "Checking WSL installation..." -ForegroundColor Yellow
try {
    $wslCheck = wsl --status 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [PASS] WSL is installed" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] WSL not properly configured" -ForegroundColor Red
        $allPassed = $false
    }
} catch {
    Write-Host "  [FAIL] WSL not found - run 'wsl --install'" -ForegroundColor Red
    $allPassed = $false
}

# Check virtualization
Write-Host "Checking virtualization..." -ForegroundColor Yellow
try {
    $hyperv = (Get-ComputerInfo -Property HyperVisorPresent).HyperVisorPresent
    if ($hyperv) {
        Write-Host "  [PASS] Virtualization enabled" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] Virtualization not enabled - check BIOS settings" -ForegroundColor Red
        $allPassed = $false
    }
} catch {
    Write-Host "  [WARN] Could not check virtualization status" -ForegroundColor Yellow
}

# Check RAM
Write-Host "Checking system memory..." -ForegroundColor Yellow
$ram = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
if ($ram -ge 16) {
    Write-Host "  [PASS] RAM: ${ram} GB (excellent)" -ForegroundColor Green
} elseif ($ram -ge 8) {
    Write-Host "  [PASS] RAM: ${ram} GB (sufficient)" -ForegroundColor Green
} else {
    Write-Host "  [WARN] RAM: ${ram} GB (8 GB minimum recommended)" -ForegroundColor Yellow
}

# Check disk space
Write-Host "Checking disk space..." -ForegroundColor Yellow
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'" | Select-Object -ExpandProperty FreeSpace
$freeGB = [math]::Round($disk / 1GB)
if ($freeGB -ge 40) {
    Write-Host "  [PASS] Free disk space: ${freeGB} GB" -ForegroundColor Green
} elseif ($freeGB -ge 20) {
    Write-Host "  [PASS] Free disk space: ${freeGB} GB (minimum met)" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Free disk space: ${freeGB} GB (need at least 20 GB)" -ForegroundColor Red
    $allPassed = $false
}

# Check Windows Terminal
Write-Host "Checking Windows Terminal..." -ForegroundColor Yellow
if (Get-Command wt -ErrorAction SilentlyContinue) {
    Write-Host "  [PASS] Windows Terminal installed" -ForegroundColor Green
} else {
    Write-Host "  [INFO] Windows Terminal not found (optional but recommended)" -ForegroundColor Cyan
}

# Check VS Code
Write-Host "Checking Visual Studio Code..." -ForegroundColor Yellow
if (Get-Command code -ErrorAction SilentlyContinue) {
    Write-Host "  [PASS] VS Code installed" -ForegroundColor Green
} else {
    Write-Host "  [INFO] VS Code not found (optional but recommended)" -ForegroundColor Cyan
}

# Summary
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
if ($allPassed) {
    Write-Host "  All checks passed! You're ready!" -ForegroundColor Green
} else {
    Write-Host "  Some checks failed. Please fix issues above." -ForegroundColor Red
}
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
