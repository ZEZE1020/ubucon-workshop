# Lab 00: Prerequisites

> **Duration:** 10 minutes

This lab ensures your system meets all requirements for the workshop.

## System Requirements

### Windows Version

Open PowerShell and run:

```powershell
winver
```

**Required:** Windows 10 version 2004+ (Build 19041+) or Windows 11

### Hardware

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| CPU | 64-bit with virtualization | Multi-core |
| RAM | 8 GB | 16 GB |
| Storage | 20 GB free | 40 GB free (SSD preferred) |

### Enable Virtualization

1. Check if virtualization is enabled:

```powershell
# In PowerShell (Admin)
Get-ComputerInfo | Select-Object HyperVisorPresent
```

If `False`, enable it in BIOS/UEFI settings (usually under "CPU Configuration" or "Security").

## Install Required Software

### 1. Windows Terminal (Recommended)

```powershell
# Install via winget
winget install Microsoft.WindowsTerminal
```

Or download from [Microsoft Store](https://aka.ms/terminal).

### 2. Visual Studio Code

```powershell
winget install Microsoft.VisualStudioCode
```

After installation, add the **Remote - WSL** extension:
1. Open VS Code
2. Press `Ctrl+Shift+X`
3. Search for "Remote - WSL"
4. Click Install

### 3. Enable WSL Feature

Open PowerShell as Administrator:

```powershell
# Enable WSL and Virtual Machine Platform
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

**Restart your computer after running these commands.**

### 4. Set WSL 2 as Default

After restart, open PowerShell:

```powershell
wsl --set-default-version 2
```

## Verification Checklist

Run this script to verify your setup:

```powershell
# Save as check-prerequisites.ps1 and run in PowerShell

Write-Host "=== UbuCon Workshop Prerequisites Check ===" -ForegroundColor Cyan
Write-Host ""

# Check Windows version
$build = [System.Environment]::OSVersion.Version.Build
if ($build -ge 19041) {
    Write-Host "[OK] Windows Build: $build" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Windows Build: $build (need 19041+)" -ForegroundColor Red
}

# Check WSL
try {
    $wslVersion = wsl --version 2>$null
    Write-Host "[OK] WSL is installed" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] WSL not found" -ForegroundColor Red
}

# Check virtualization
$hyperv = (Get-ComputerInfo).HyperVisorPresent
if ($hyperv) {
    Write-Host "[OK] Virtualization enabled" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Virtualization not enabled" -ForegroundColor Red
}

# Check RAM
$ram = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
if ($ram -ge 8) {
    Write-Host "[OK] RAM: ${ram} GB" -ForegroundColor Green
} else {
    Write-Host "[WARN] RAM: ${ram} GB (8 GB recommended)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Check Complete ===" -ForegroundColor Cyan
```

## Troubleshooting

### "WSL 2 requires an update to its kernel component"

Download and install the WSL2 Linux kernel update:
- [WSL2 Kernel Update (x64)](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi)

### Virtualization Not Available

1. Restart and enter BIOS/UEFI (usually F2, F10, or Del during boot)
2. Find virtualization setting (Intel VT-x, AMD-V, or SVM)
3. Enable it and save changes

### Corporate/Managed Device

If your device is managed by IT:
- Request WSL2 to be enabled via group policy
- Ask for local admin rights for the workshop duration

## Next Step

Once all checks pass, proceed to [Lab 01: WSL Setup](../lab-01-wsl-setup/).
