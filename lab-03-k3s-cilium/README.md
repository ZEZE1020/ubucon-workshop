# Lab 03: Running Kubernetes with K3s and Cilium

> **Duration:** 20 minutes

In this lab, you'll start a local Kubernetes cluster using **K3s** and install **Cilium** to handle networking between your applications.

---

### A Note on Kubernetes: Why K3s instead of Kind?

The original workshop idea was to use `kind` (Kubernetes in Docker). However, we chose **K3s** for a few key reasons to make the workshop run better for everyone:

1.  **Uses Less Memory:** K3s is a smaller version of Kubernetes, so it runs more easily on laptops with less RAM.
2.  **Easier to Use:** K3s is simpler to install and manage, which lets us focus on the fun parts of the workshop.
3.  **Restarts Automatically:** If you reboot your computer, the K3s cluster will start back up on its own.

By using K3s, we can get a Kubernetes cluster running quickly and reliably on any machine.

---

## What You'll Do

- Install the K3s Kubernetes cluster.
- Install the Cilium networking tool.
- Open the Hubble dashboard to see network activity.
- Check that everything is installed correctly.

## Installation

The best way to get started is to use the installation script in this lab's directory.

1.  Navigate to the lab directory:
    ```bash
    cd ~/workshops/ubucon-workshop2026/lab-03-k3s-cilium
    ```

2.  Make the script executable:
    ```bash
    chmod +x install-k3s-cilium.sh
    ```

3.  Run the installation script:
    ```bash
    ./install-k3s-cilium.sh
    ```

This script does all the work for you:
- **Installs K3s:** Downloads and runs the K3s installer. It includes a setting to disable the default networking so we can use Cilium instead.
- **Installs Cilium CLI:** Downloads the command-line tool for Cilium.
- **Installs Cilium:** Deploys the Cilium components into your K3s cluster.
- **Enables Hubble:** Sets up the Hubble dashboard so we can see what's happening in our cluster.

## Verify the Installation

After the script is done, let's make sure everything is working.

### Check Your Cluster
Verify that your K3s cluster is running.
```bash
kubectl get nodes
```
You should see your local machine listed with a `Ready` status.
```text
NAME          STATUS   ROLES                  AGE   VERSION
<hostname>    Ready    control-plane,master   2m    v1.28.8-k3s.1
```

### Check Cilium Status
Cilium has a command to check its own status.
```bash
cilium status --wait
```
This command will wait for all the parts of Cilium to start up correctly.

### Check All Pods
You can see all the small applications (called "pods") running in your cluster.
```bash
kubectl get pods -A
```
You should see pods for `coredns`, `cilium`, and `hubble` in the `kube-system` area (this is called a "namespace").

## Explore with the Hubble UI

Hubble lets you see the network connections in your cluster.

1.  **Start the Hubble UI:**
    ```bash
    cilium hubble ui
    ```
    This command will open the Hubble dashboard in your web browser at `http://localhost:12000`.

2.  **Explore the UI:**
    - It will look empty right now because we haven't deployed our own applications yet.
    - We will use this dashboard later in the workshop to see our network rules in action.

## Troubleshooting

### `kubectl` command not found
If you get an error that the `kubectl` command is not found, you likely need to set the `KUBECONFIG` environment variable.
```bash
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```
To make this permanent, add the line to your `~/.bashrc` file.

You can also run `kubectl` commands directly through the `k3s` binary:
```bash
sudo k3s kubectl get nodes
```

### Cilium pods are stuck or have errors
This can happen if K3s was not started with the default networking disabled. The fastest way to fix this is to uninstall and reinstall.
```bash
# This command will completely remove K3s from your system
/usr/local/bin/k3s-uninstall.sh

# Then, re-run the installation script from this lab
./install-k3s-cilium.sh
```

### (WSL) K3s service fails to start
This is often because `systemd` is not enabled in your WSL distribution.
1.  Verify `systemd` is running with `ps -p 1 -o comm=`. The output should be `systemd`.
2.  If it is not, follow the instructions in **[Lab 02](../lab-02-wsl-setup/)** to enable it, then try the installation again.

### (WSL) High CPU or Memory Usage
By default, WSL can consume a large amount of your system's resources. To limit this, you can create a `.wslconfig` file.
1.  Open Notepad or another text editor on your **Windows** machine.
2.  Create a file in your user profile folder at `C:\Users\<YourUsername>\.wslconfig`.
3.  Add the following content to the file to limit WSL to 2GB of RAM and 2 CPU cores. Adjust as needed.
    ```ini
    [wsl2]
    memory=2GB
    processors=2
    ```
4.  Save the file and then run `wsl --shutdown` in PowerShell for the changes to take effect.

### (WSL) Accessing K3s from Windows
To use `kubectl` from your Windows machine (if you have it installed), you need to:
1.  Copy the K3s config file from WSL to Windows:
    ```powershell
    # Run this in PowerShell
    wsl cat /etc/rancher/k3s/k3s.yaml > $env:USERPROFILE\.kube\k3s-config.yaml
    ```
2.  Find your WSL instance's IP address:
    ```powershell
    # Run this in PowerShell
    wsl hostname -I
    ```
3.  Edit the `k3s-config.yaml` file on Windows and replace `127.0.0.1` with the IP address of your WSL instance.
4.  Point your `KUBECONFIG` environment variable to this new file.

## Next Step

Your Kubernetes cluster is up and running! Next, we'll learn how to manage secret information like passwords and API keys.

Proceed to **[Lab 04: Secrets with SOPS](../lab-04-secrets-sops/)**.
