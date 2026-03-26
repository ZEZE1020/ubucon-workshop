# Lab 00: Prerequisites

> **Duration:** 20-30 minutes (including downloads)

Welcome to the workshop! This lab makes sure your computer is ready so you can have a smooth experience.

---

## **IMPORTANT**: Pre-Workshop Checklist (Do This Before the Event!)

Conference Wi-Fi can be slow. To avoid waiting for large downloads, please **run these commands at home or on a fast connection** before you arrive.

### Step 1: Install Docker

We need Docker to run "containers," which are like lightweight packages for applications.

- **Windows:** The easiest way is to install Docker Desktop from [the Docker website](https://www.docker.com/products/docker-desktop/).
- **macOS:** We recommend Docker Desktop. You can install it with Homebrew: `brew install --cask docker`.
- **Linux:** Install the Docker command-line tools.
    ```bash
    # For Ubuntu/Debian
    curl -fsSL https://get.docker.com | sudo sh
    sudo usermod -aG docker $USER
    # IMPORTANT: Log out and log back in after running this!
    ```

### Step 2: Pre-download the Workshop Images

This is the most important pre-workshop step. Open your terminal (or PowerShell on Windows) and run the following commands. This will download all the application images we will use in the workshop, which will save you up to 30 minutes.

```bash
# Download the K3s image (for our Kubernetes cluster)
docker pull rancher/k3s:v1.28.8-k3s.1

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
After running these, you can verify the images were downloaded with the `docker images` command.

---
## System Checks

Now, follow the guide for your operating system to make sure everything else is ready.

**Jump to your OS:**
- [Windows](#windows)
- [Linux (Native)](#linux-native)
- [macOS](#macos)

---

## Windows

### System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| CPU | 64-bit with virtualization | 4+ cores |
| RAM | 8 GB | 16 GB |
| Storage | 25 GB free | 40 GB free (SSD preferred) |

#### Enable Virtualization & WSL
1.  **Enable Virtualization** in your computer's BIOS/UEFI. This is often found under "CPU Configuration" or "Security" settings.
2.  **Enable WSL:** Open PowerShell as an Administrator and run `wsl --install`. This will enable the required Windows features and install the default Ubuntu.
3.  **Restart your computer** when prompted.
4.  **Set WSL 2 as default:** After restarting, open PowerShell and run `wsl --set-default-version 2`.

### Run Verification Script
```powershell
# In PowerShell, navigate to this lab's directory
cd lab-00-prerequisites
.\check-prerequisites.ps1
```

### Next Step
Proceed to **[Lab 01: Ubuntu Pro & ESM](../lab-01-ubuntu-pro/)**.

---

## Linux (Native)

### System Requirements
| Component | Minimum | Recommended |
|-----------|---------|-------------|
| CPU | 64-bit, 2 cores | 4+ cores |
| RAM | 8 GB | 16 GB |
| Storage | 25 GB free | 40 GB free |

### Install Essential Tools
```bash
# For Ubuntu/Debian
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget git jq unzip ca-certificates
```
```bash
# For Fedora/RHEL
sudo dnf update -y
sudo dnf install -y curl wget git jq unzip ca-certificates
```

### Run Verification Script
```bash
# Navigate to this lab's directory
cd lab-00-prerequisites
chmod +x check-prerequisites-linux.sh
./check-prerequisites-linux.sh
```

### Next Step
Proceed to **[Lab 01: Ubuntu Pro & ESM](../lab-01-ubuntu-pro/)**.

---

## macOS

### System Requirements
| Component | Minimum | Recommended |
|-----------|---------|-------------|
| macOS Version | 12 Monterey | 14 Sonoma+ |
| Chip | Intel or Apple Silicon | Apple Silicon |
| RAM | 8 GB | 16 GB |
| Storage | 25 GB free | 40 GB free |

### Install Homebrew & Tools
1.  **Install Homebrew:**
    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```
2.  **Install Tools:**
    ```bash
    brew install curl wget git jq coreutils
    ```

### Run Verification Script
```bash
# Navigate to this lab's directory
cd lab-00-prerequisites
chmod +x check-prerequisites-macos.sh
./check-prerequisites-macos.sh
```

### Next Step
Proceed to **[Lab 01: Ubuntu Pro & ESM](../lab-01-ubuntu-pro/)**.

---
## Troubleshooting

### Windows: "WSL 2 requires an update to its kernel component"
Open PowerShell and run `wsl --update`. Then run `wsl --shutdown` before restarting your Ubuntu terminal.

### Linux/macOS: `docker` command fails with "permission denied"
You need to log out and log back in after adding your user to the `docker` group. This is a common issue on Linux. On macOS, ensure Docker Desktop is running.
