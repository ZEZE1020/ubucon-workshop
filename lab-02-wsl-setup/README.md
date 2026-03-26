# Lab 02: Setting Up Your Environment

> **Duration:** 15-20 minutes

In this lab, you'll get your computer ready for the rest of the workshop. For Windows users, we'll enable a feature called `systemd`, which is needed to run tools like Kubernetes.

**Jump to your OS:**
- [Windows (WSL2)](#windows-wsl2)
- [Linux (Native)](#linux-native)
- [macOS](#macos)

---

## Windows (WSL2)

### Step 1: Install Ubuntu on WSL2

#### Option 1: Command Line (Recommended)

Open PowerShell or Windows Terminal and run:

```powershell
# This command will download and install the latest Ubuntu LTS release
wsl --install -d Ubuntu
```
This will create a new Ubuntu instance. You will be prompted to create a username and password.

#### Option 2: Microsoft Store

1. Open the Microsoft Store application.
2. Search for "Ubuntu 24.04 LTS".
3. Click "Get" and then "Install".

### Step 2: Enable `systemd`

`systemd` is a program that starts and manages other services in Linux. We need it for Kubernetes. While newer versions of WSL turn this on automatically, it's good to know how to do it yourself.

1.  **Open your Ubuntu terminal.**

2.  **Create or edit the WSL configuration file** using the `nano` text editor.

    ```bash
    sudo nano /etc/wsl.conf
    ```

3.  **Add these two lines to the file.** This tells WSL to use `systemd` when it boots up.

    ```ini
    [boot]
    systemd=true
    ```

4.  **Save and close the file.** In `nano`, press `Ctrl+X`, then `Y` to confirm, and `Enter`.

5.  **Shut down your WSL instance.** This change requires a full restart of WSL. Open **PowerShell** or Windows Terminal and run:

    ```powershell
    wsl --shutdown
    ```

6.  **Restart your Ubuntu terminal.** When you open it again, it will be running with `systemd`.

7.  **Verify `systemd` is running.** Check that `systemd` is the first process running:
    ```bash
    ps -p 1 -o comm=
    ```
    The output should be `systemd`.

### Step 3: Update and Install Tools

```bash
# Update package lists and upgrade installed packages
sudo apt update && sudo apt upgrade -y

# Install essential tools
sudo apt install -y curl wget git jq unzip ca-certificates gnupg
```

### Step 4: Configure Git

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Step 5: Clone the Workshop Repository

```bash
mkdir -p ~/workshops && cd ~/workshops
git clone https://gitlab.com/swo6933113/ubucon-workshop2026.git
cd ubucon-workshop2026
```

### Next Step

You are now ready to deploy Kubernetes!

Proceed to **[Lab 03: K3s + Cilium](../lab-03-k3s-cilium/)**.

---

## Linux (Native)

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
sudo apt install -y curl wget git jq unzip ca-certificates gnupg apt-transport-https
```

#### Fedora

```bash
sudo dnf install -y curl wget git jq unzip ca-certificates
```

### Configure Git

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Install Docker (If not already installed)

```bash
# For Ubuntu/Debian
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
# Check your kernel version
uname -r

# Check that systemd is active
systemctl --version

# Check your git version
git --version
```

### Next Step

Proceed to **[Lab 03: K3s + Cilium](../lab-03-k3s-cilium/)**.

---

## macOS

### Install Homebrew (if not installed)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Follow the on-screen instructions to add Homebrew to your PATH.

### Install Essential Tools

```bash
brew install curl wget git jq coreutils
```

### Configure Git

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Set Up Docker

The easiest way to get a container environment on macOS is with Docker Desktop.

```bash
brew install --cask docker
```

Open Docker Desktop from your Applications folder and complete the setup wizard.

### Clone the Workshop Repository

```bash
mkdir -p ~/workshops && cd ~/workshops
git clone https://gitlab.com/swo6933113/ubucon-workshop2026.git
cd ubucon-workshop2026
```

### Next Step

Proceed to **[Lab 03: K3s + Cilium](../lab-03-k3s-cilium/)**.

---

## Troubleshooting

### Windows: `wsl.conf` changes not taking effect
Make sure you run `wsl --shutdown` in PowerShell after saving the file. This is required to apply the new settings.

### Linux: Permission Denied for Docker
You need to log out and log back in after adding your user to the `docker` group with `sudo usermod -aG docker $USER`.

### All Platforms: Git Clone Fails
If you are on a school or corporate network, you may need to configure Git to use a proxy:
```bash
git config --global http.proxy http://proxy.example.com:8080
git config --global https.proxy http://proxy.example.com:8080
```
