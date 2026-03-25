# Lab 01: Environment Setup

> **Duration:** 10-15 minutes

In this lab, you'll set up your development environment for the workshop.

**Jump to your OS:**
- [Windows (WSL2)](#windows-wsl2)
- [Linux (Native)](#linux-native)
- [macOS](#macos)

---

## Windows (WSL2)

### Install Ubuntu on WSL2

#### Option 1: Command Line (Recommended)

Open PowerShell or Windows Terminal:

```powershell
# Install Ubuntu 24.04 LTS
wsl --install -d Ubuntu-24.04
```

#### Option 2: Microsoft Store

1. Open Microsoft Store
2. Search for "Ubuntu 24.04 LTS"
3. Click "Get" and then "Install"

### Initial Configuration

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

### Update and Install Tools

```bash
# Update package lists and upgrade installed packages
sudo apt update && sudo apt upgrade -y

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

### Configure Git

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### WSL Configuration (Optional)

Create a WSL configuration file for better performance:

```bash
# Create .wslconfig in Windows user directory
cat << 'EOF' | sudo tee /mnt/c/Users/$USER/.wslconfig
[wsl2]
memory=8GB
processors=4
swap=2GB
localhostForwarding=true
EOF
```

Restart WSL after creating this file:

```powershell
# In PowerShell
wsl --shutdown
```

### VS Code Integration

```bash
# Open current directory in VS Code
code .
```

### Clone the Workshop Repository

```bash
mkdir -p ~/workshops && cd ~/workshops
git clone https://gitlab.com/swo6933113/ubucon-workshop2026.git
cd ubucon-workshop2026
```

### Next Step

Proceed to [Lab 02: K3s + Cilium](../lab-02-k3s-cilium/).

---

## Linux Native

### Update System

#### Ubuntu/Debian

```bash
sudo apt update && sudo apt upgrade -y
```

#### Fedora

```bash
sudo dnf update -y
```

### Install Essential Tools

#### Ubuntu/Debian

```bash
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

#### Fedora

```bash
sudo dnf install -y \
    curl \
    wget \
    git \
    jq \
    unzip \
    ca-certificates
```

### Configure Git

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Install Docker (Optional)

```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER

# Log out and back in for group changes to take effect
```

### Clone the Workshop Repository

```bash
mkdir -p ~/workshops && cd ~/workshops
git clone https://gitlab.com/swo6933113/ubucon-workshop2026.git
cd ubucon-workshop2026
```

### Verify Setup

```bash
# Check kernel version (needs 4.19+ for eBPF)
uname -r

# Check systemd
systemctl --version

# Check git
git --version
```

### Next Step

Proceed to [Lab 02: K3s + Cilium](../lab-02-k3s-cilium/).

---

## macOS

### Install Homebrew (if not installed)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Follow the post-installation instructions to add Homebrew to your PATH.

### Install Essential Tools

```bash
brew install \
    curl \
    wget \
    git \
    jq \
    coreutils
```

### Configure Git

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Set Up Container Environment

Choose ONE of the following options:

#### Option A: Docker Desktop (Easiest)

```bash
brew install --cask docker
```

Open Docker Desktop and complete the setup wizard.

#### Option B: Lima (Lightweight Linux VMs)

```bash
# Install Lima
brew install lima

# Create an Ubuntu VM with K3s
limactl start --name=k3s template://k3s

# Or create a plain Ubuntu VM
limactl start --name=ubuntu template://ubuntu-lts
```

To enter the VM:

```bash
limactl shell k3s
# or
limactl shell ubuntu
```

#### Option C: OrbStack (Apple Silicon Recommended)

```bash
brew install --cask orbstack
```

OrbStack provides fast Linux VMs and Docker on macOS.

### Clone the Workshop Repository

```bash
mkdir -p ~/workshops && cd ~/workshops
git clone https://gitlab.com/swo6933113/ubucon-workshop2026.git
cd ubucon-workshop2026
```

### Important Note for macOS Users

K3s runs natively on Linux. On macOS, you have two options:

1. **Use Lima/OrbStack VM**: Run K3s inside a Linux VM (recommended)
2. **Use Docker Desktop's Kubernetes**: Enable Kubernetes in Docker Desktop settings

For the best workshop experience, we recommend using Lima:

```bash
# Start Lima VM and enter it
limactl start --name=workshop template://ubuntu-lts
limactl shell workshop

# Now you're in a Linux environment - continue with Lab 02
```

### Next Step

Proceed to [Lab 02: K3s + Cilium](../lab-02-k3s-cilium/).

---

## Troubleshooting

### Windows: Ubuntu Runs Very Slowly

1. Check if you're using WSL 2:
   ```powershell
   wsl -l -v
   ```
2. If showing version 1, convert:
   ```powershell
   wsl --set-version Ubuntu-24.04 2
   ```

### Linux: Permission Denied for Docker

```bash
sudo usermod -aG docker $USER
# Log out and back in
```

### macOS: Lima VM Won't Start

```bash
# Check Lima status
limactl list

# Stop and restart
limactl stop workshop
limactl start workshop
```

### All Platforms: Git Clone Fails

If you're behind a proxy:

```bash
git config --global http.proxy http://proxy.example.com:8080
git config --global https.proxy http://proxy.example.com:8080
```

## Quick Reference

| Platform | Shell | Package Manager |
|----------|-------|----------------|
| Windows (WSL) | bash | apt |
| Ubuntu/Debian | bash | apt |
| Fedora | bash | dnf |
| macOS | zsh | brew |
| macOS (Lima) | bash | apt (inside VM) |
