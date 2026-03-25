# Lab 01: Ubuntu on WSL2 Setup

> **Duration:** 15 minutes

In this lab, you'll install Ubuntu on WSL2 and configure it for development.

## Install Ubuntu

### Option 1: Command Line (Recommended)

Open PowerShell or Windows Terminal:

```powershell
# Install Ubuntu 24.04 LTS
wsl --install -d Ubuntu-24.04
```

### Option 2: Microsoft Store

1. Open Microsoft Store
2. Search for "Ubuntu 24.04 LTS"
3. Click "Get" and then "Install"

## Initial Configuration

After installation, Ubuntu will launch automatically. Create your user account:

```
Enter new UNIX username: yourname
New password: ********
Retype new password: ********
```

**Tips for username:**
- Use lowercase letters only
- Keep it short (you'll type it often)
- Avoid spaces and special characters

## Update the System

Always start with a fresh update:

```bash
# Update package lists and upgrade installed packages
sudo apt update && sudo apt upgrade -y
```

## Install Essential Tools

Install the tools we'll need for the workshop:

```bash
# Install essential packages
sudo apt install -y \
    curl \
    wget \
    git \
    jq \
    unzip \
    ca-certificates \
    gnupg \
    lsb-release
```

## Configure Git

Set up your Git identity:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Verify configuration
git config --list
```

## WSL Configuration (Optional but Recommended)

Create a WSL configuration file for better performance:

```bash
# Create .wslconfig in Windows user directory
cat << 'EOF' | sudo tee /mnt/c/Users/$USER/.wslconfig
[wsl2]
memory=8GB
processors=4
swap=2GB
localhostForwarding=true

[experimental]
sparseVhd=true
autoMemoryReclaim=gradual
EOF
```

**Note:** Adjust `memory` and `processors` based on your system. Restart WSL after creating this file:

```powershell
# In PowerShell
wsl --shutdown
```

## Verify Installation

Run these commands to verify everything is working:

```bash
# Check Ubuntu version
lsb_release -a

# Check WSL version
cat /proc/version

# Check available memory
free -h

# Check disk space
df -h /
```

Expected output should show:
- Ubuntu 24.04 LTS
- WSL2 kernel version
- Allocated memory from .wslconfig

## VS Code Integration

Open your Ubuntu home directory in VS Code:

```bash
# From Ubuntu terminal
code .
```

This will:
1. Install VS Code Server in WSL (first time only)
2. Open VS Code connected to your Ubuntu environment

## Clone the Workshop Repository

```bash
# Create a workspace directory
mkdir -p ~/workshops && cd ~/workshops

# Clone this repository
git clone https://gitlab.com/swo6933113/ubucon-workshop2026.git
cd ubucon-workshop2026

# Verify the structure
ls -la
```

## Troubleshooting

### "The WSL 2 kernel file is not found"

```powershell
# In PowerShell (Admin)
wsl --update
```

### Ubuntu Runs Very Slowly

1. Check if you're using WSL 2:
   ```powershell
   wsl -l -v
   ```
2. If showing version 1, convert:
   ```powershell
   wsl --set-version Ubuntu-24.04 2
   ```

### "Permission denied" Errors

Ensure you're not working in `/mnt/c/` (Windows filesystem). Stay in your Linux home directory (`~`) for best performance.

### Network Issues Behind Proxy

If you're behind a corporate proxy:

```bash
# Add to ~/.bashrc
export http_proxy="http://proxy.example.com:8080"
export https_proxy="http://proxy.example.com:8080"
export no_proxy="localhost,127.0.0.1"
```

## Quick Reference

| Command | Description |
|---------|-------------|
| `wsl` | Start default WSL distribution |
| `wsl -l -v` | List installed distributions |
| `wsl --shutdown` | Stop all WSL instances |
| `wsl --update` | Update WSL kernel |
| `explorer.exe .` | Open current directory in Windows Explorer |
| `code .` | Open current directory in VS Code |

## Next Step

Your Ubuntu environment is ready! Proceed to [Lab 02: K3s + Cilium](../lab-02-k3s-cilium/).
