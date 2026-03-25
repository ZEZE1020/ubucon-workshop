# Lab 00: Prerequisites

> **Duration:** 10-15 minutes (varies by OS)

This lab ensures your system meets all requirements for the workshop.

**Jump to your OS:**
- [Windows](#windows)
- [Linux (Native)](#linux-native)
- [macOS](#macos)

---

## Windows

### System Requirements

#### Check Windows Version

Open PowerShell and run:

```powershell
winver
```

**Required:** Windows 10 version 2004+ (Build 19041+) or Windows 11

#### Hardware

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| CPU | 64-bit with virtualization | Multi-core |
| RAM | 8 GB | 16 GB |
| Storage | 20 GB free | 40 GB free (SSD preferred) |

#### Enable Virtualization

Check if virtualization is enabled:

```powershell
# In PowerShell (Admin)
Get-ComputerInfo | Select-Object HyperVisorPresent
```

If `False`, enable it in BIOS/UEFI settings (usually under "CPU Configuration" or "Security").

### Install Required Software

#### 1. Windows Terminal (Recommended)

```powershell
winget install Microsoft.WindowsTerminal
```

#### 2. Visual Studio Code

```powershell
winget install Microsoft.VisualStudioCode
```

Add the **Remote - WSL** extension after installation.

#### 3. Enable WSL Feature

Open PowerShell as Administrator:

```powershell
# Enable WSL and Virtual Machine Platform
wsl --install
```

**Restart your computer after running this command.**

#### 4. Verify WSL 2

After restart:

```powershell
wsl --version
wsl --set-default-version 2
```

### Run Verification Script

```powershell
# Download and run the check script
cd lab-00-prerequisites
.\check-prerequisites.ps1
```

### Next Step

Proceed to [Lab 01: Environment Setup](../lab-01-wsl-setup/) to install Ubuntu on WSL2.

---

## Linux Native

### Supported Distributions

| Distribution | Minimum Version |
|--------------|----------------|
| Ubuntu | 20.04 LTS |
| Debian | 11 (Bullseye) |
| Fedora | 38 |
| RHEL/CentOS Stream | 9 |
| openSUSE | Leap 15.5 |

### System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| CPU | 64-bit, 2 cores | 4+ cores |
| RAM | 8 GB | 16 GB |
| Storage | 20 GB free | 40 GB free |

### Install Required Software

#### Ubuntu/Debian

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install essential tools
sudo apt install -y \
    curl \
    wget \
    git \
    jq \
    unzip \
    ca-certificates \
    gnupg \
    lsb-release \
    apt-transport-https
```

#### Fedora/RHEL

```bash
# Update system
sudo dnf update -y

# Install essential tools
sudo dnf install -y \
    curl \
    wget \
    git \
    jq \
    unzip \
    ca-certificates
```

### Verify System

```bash
# Check kernel version (needs 4.19+ for eBPF)
uname -r

# Check available memory
free -h

# Check disk space
df -h /

# Check if systemd is running
systemctl --version
```

### Install Docker (Optional but Recommended)

```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER

# Log out and back in, then verify
docker --version
```

### Run Verification Script

```bash
cd lab-00-prerequisites
chmod +x check-prerequisites-linux.sh
./check-prerequisites-linux.sh
```

### Next Step

Proceed to [Lab 01: Environment Setup](../lab-01-wsl-setup/#linux-native) to configure your environment.

---

## macOS

### System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| macOS Version | 12 Monterey | 14 Sonoma+ |
| Chip | Intel or Apple Silicon | Apple Silicon |
| RAM | 8 GB | 16 GB |
| Storage | 20 GB free | 40 GB free |

### Check Your System

```bash
# Check macOS version
sw_vers

# Check chip architecture
uname -m
# arm64 = Apple Silicon, x86_64 = Intel
```

### Install Homebrew

If you don't have Homebrew installed:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Follow the post-installation instructions to add Homebrew to your PATH.

### Install Required Software

```bash
# Install essential tools
brew install \
    curl \
    wget \
    git \
    jq \
    coreutils

# Install Visual Studio Code (optional)
brew install --cask visual-studio-code
```

### Choose Your Kubernetes Approach

#### Option A: Docker Desktop (Easiest)

```bash
brew install --cask docker
```

After installation:
1. Open Docker Desktop
2. Go to Settings > Kubernetes
3. Enable Kubernetes
4. Apply & Restart

**Note:** Docker Desktop includes a built-in Kubernetes cluster, but we'll use K3s for consistency with the workshop.

#### Option B: Lima + K3s (Lightweight)

Lima creates lightweight Linux VMs on macOS:

```bash
# Install Lima
brew install lima

# Create an Ubuntu VM
limactl start --name=ubuntu template://ubuntu-lts

# Enter the VM
limactl shell ubuntu
```

#### Option C: OrbStack (Apple Silicon Recommended)

```bash
brew install --cask orbstack
```

OrbStack is a fast, lightweight alternative to Docker Desktop for Apple Silicon Macs.

### Run Verification Script

```bash
cd lab-00-prerequisites
chmod +x check-prerequisites-macos.sh
./check-prerequisites-macos.sh
```

### Next Step

Proceed to [Lab 01: Environment Setup](../lab-01-wsl-setup/#macos) to configure your environment.

---

## Troubleshooting

### Windows: "WSL 2 requires an update to its kernel component"

```powershell
wsl --update
```

### Windows: Virtualization Not Available

1. Restart and enter BIOS/UEFI (usually F2, F10, or Del during boot)
2. Find virtualization setting (Intel VT-x, AMD-V, or SVM)
3. Enable it and save changes

### Linux: Permission Denied for Docker

```bash
sudo usermod -aG docker $USER
# Log out and back in
```

### macOS: Homebrew Command Not Found

Add Homebrew to your PATH:

```bash
# For Apple Silicon
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
source ~/.zprofile

# For Intel
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
source ~/.zprofile
```

### Corporate/Managed Device

If your device is managed by IT:
- Request necessary permissions for virtualization
- Ask about proxy settings for package downloads
- Consider using a personal device for the workshop
