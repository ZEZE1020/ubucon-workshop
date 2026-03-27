# Lab 00: Prerequisites

> **Duration:** 30-40 minutes (including downloads)

Welcome to the workshop! This first lab will guide you through setting up your computer and downloading all the necessary tools and files before the event.

**Please complete this entire lab at home or on a fast connection to avoid slow downloads over conference Wi-Fi.**

---

## Step 1: Clone the Workshop Repository

First, you need to get all the workshop files on your computer.

1.  Open a terminal (or PowerShell on Windows).
2.  Navigate to a directory where you want to store the workshop files (e.g., `Documents` or `Desktop`).
3.  Clone the repository using the following command.

    ```bash
    # TODO: Replace this with the correct repository URL
    git clone https://github.com/placeholder/ubucon-workshop2026.git
    ```
4.  Navigate into the newly created directory:
    ```bash
    cd ubucon-workshop2026
    ```
    You will run all commands from within this directory for the rest of the workshop.

---
## Step 2: System-Specific Setup

Now, follow the guide for your operating system.

**Jump to your OS:**
- [Windows (using PowerShell and WSL)](#windows)
- [Linux (Native)](#linux-native)
- [macOS (using Homebrew)](#macos)

---

## Windows

> **A Note on PowerShell:** For the initial Windows setup, we will use **PowerShell** to install and configure the Windows Subsystem for Linux (WSL). **Once WSL and Ubuntu are running, all other workshop labs will take place inside the Ubuntu terminal.**

### System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| CPU | 64-bit with virtualization | 4+ cores |
| RAM | 8 GB | 16 GB |
| Storage | 25 GB free | 40 GB free (SSD preferred) |

### 1. Enable Virtualization & WSL
1.  **Enable Virtualization** in your computer's BIOS/UEFI. This is often found under "CPU Configuration" or "Security" settings.
2.  **Enable WSL:** Open **PowerShell as an Administrator** and run `wsl --install`. This will enable the required Windows features and install the default Ubuntu.
3.  **Restart your computer** when prompted.
4.  **Set WSL 2 as default:** After restarting, open PowerShell and run `wsl --set-default-version 2`.

### 2. Install Docker Desktop
The easiest way to get Docker on Windows is to install Docker Desktop.
- Download and install from [the Docker website](https://www.docker.com/products/docker-desktop/){:target="_blank"}
- During setup, ensure you select the option to **use the WSL 2 based engine**.

### 3. Enable `systemd` in Ubuntu
`systemd` is a program that starts and manages other services in Linux. We will need it for Kubernetes.

1.  **Open your Ubuntu terminal.**
2.  Create or edit the WSL configuration file:
    ```bash
    sudo nano /etc/wsl.conf
    ```
3.  Add these lines to the file:
    ```ini
    [boot]
    systemd=true
    ```
4.  Save and close the file (`Ctrl+X`, then `Y`, then `Enter`).
5.  **Shut down your WSL instance.** Open **PowerShell** and run:
    ```powershell
    wsl --shutdown
    ```
6.  **Restart your Ubuntu terminal.** It will now be running with `systemd`.

### 4. Run Verification Script
```powershell
# In PowerShell, navigate into the cloned repo directory
cd lab-00-prerequisites
.\check-prerequisites.ps1
```

### Next Step
You are now ready to move to the next lab!

Proceed to **[Lab 01: Ubuntu Pro & ESM](../lab-01-ubuntu-pro/)**.

---

## Linux (Native)

### System Requirements
| Component | Minimum | Recommended |
|-----------|---------|-------------|
| CPU | 64-bit, 2 cores | 4+ cores |
| RAM | 8 GB | 16 GB |
| Storage | 25 GB free | 40 GB free |

### 1. Install Essential Tools
```bash
# For Ubuntu/Debian
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget git jq unzip ca-certificates gnupg

# For Fedora/RHEL
sudo dnf update -y
sudo dnf install -y curl wget git jq unzip ca-certificates gnupg
```

### 2. Install Docker
```bash
# For Ubuntu/Debian
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER
# IMPORTANT: Log out and log back in after running this!
```

### 3. Run Verification Script
```bash
# Navigate into the lab directory
cd lab-00-prerequisites
chmod +x check-prerequisites-linux.sh
./check-prerequisites-linux.sh
```

### Next Step
You are now ready to move to the next lab!

Proceed to **[Lab 01: Ubuntu Pro & ESM](../lab-01-ubuntu-pro/)**.

---

## macOS

### 1. Install Homebrew
If you don't have it, open your terminal and run:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Install All Workshop Tools with Brew
Homebrew can install almost everything we need for the workshop.
```bash
# Install core utilities
brew install git jq wget

# Install SOPS and age for secrets management
brew install sops age

# Install GUI applications
brew install --cask docker visual-studio-code
```
*Note: We are installing `git` via brew to ensure we have a recent version.*

### 3. Run Verification Script
```bash
# Navigate into the lab directory
cd lab-00-prerequisites
chmod +x check-prerequisites-macos.sh
./check-prerequisites-macos.sh
```

### Next Step
You are now ready to move to the next lab!

Proceed to **[Lab 01: Ubuntu Pro & ESM](../lab-01-ubuntu-pro/)**.

---
## Step 3: Pre-download the Workshop Images

This is the most important pre-workshop step. Open your terminal (or Ubuntu terminal on WSL) and run the following commands to download all the application images we will use.

```bash
# Download the Kind image (for our Kubernetes cluster)
docker pull kindest/node:v1.28.2

# Download the Cilium images (for networking)
docker pull quay.io/cilium/cilium:v1.15.1
docker pull quay.io/cilium/operator-generic:v1.15.1
docker pull quay.io/cilium/hubble-relay:v1.15.1
docker pull quay.io/cilium/hubble-ui:v0.13.0
docker pull quay.io/cilium/hubble-ui-backend:v0.13.0

# Download the Redis image (a simple database)
docker pull redis:7.2-alpine

# Download a 'curl' image (for testing connections)
docker pull curlimages/curl:8.4.0

# Download a Python image (for our own application)
docker pull ubuntu/python:3.11-22.04_edge
```

### Why are we downloading these images?

We are pre-downloading these container images to save time during the workshop. You will use them in the upcoming labs. These are the building blocks for our workshop. Here's what each one is for:

| Image Name | Purpose in Workshop |
|------------|---------------------|
| `kindest/node` | The base for our lightweight Kubernetes cluster (Lab 03). |
| `quay.io/cilium/*` | The components for Cilium networking and the Hubble UI (Lab 03 & 04). |
| `curlimages/curl` | A small utility we will use to test network connections (Lab 04). |
| `ealen/echo-server` | A simple web server for our demo application (Lab 04). |

---
## Troubleshooting

### Windows: "WSL 2 requires an update to its kernel component"
Open PowerShell and run `wsl --update`. Then run `wsl --shutdown` before restarting your Ubuntu terminal.

### Linux/macOS: `docker` command fails with "permission denied"
You need to log out and log back in after adding your user to the `docker` group. This is a common issue on Linux. On macOS, ensure Docker Desktop is running.