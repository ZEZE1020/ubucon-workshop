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
If you get an error that the `kubectl` command is not found, you can run this command to fix it:
```bash
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```
You can also run kubectl commands directly through K3s:
```bash
sudo k3s kubectl get nodes
```

### Cilium pods are stuck or have errors
This sometimes happens if the default networking wasn't disabled correctly. The fastest way to fix this is to start over.
```bash
# This command will completely remove K3s
/usr/local/bin/k3s-uninstall.sh

# Then, re-run the installation script
./install-k3s-cilium.sh
```

## Next Step

Your Kubernetes cluster is up and running! Next, we'll learn how to manage secret information like passwords and API keys.

Proceed to **[Lab 04: Secrets with SOPS](../lab-04-secrets-sops/)**.
