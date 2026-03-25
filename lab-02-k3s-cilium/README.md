# Lab 02: Kubernetes with K3s and Cilium

> **Duration:** 20 minutes

In this lab, you'll deploy a lightweight Kubernetes cluster using K3s with Cilium as the Container Network Interface (CNI).

## What You'll Learn

- Install K3s without the default Flannel CNI
- Deploy Cilium for eBPF-powered networking
- Enable Hubble for network observability
- Verify cluster health

## Why K3s + Cilium?

| Component | Purpose |
|-----------|--------|
| **K3s** | Lightweight, certified Kubernetes that runs on minimal resources |
| **Cilium** | eBPF-based networking with advanced security policies |
| **Hubble** | Real-time network flow visibility and troubleshooting |

## Installation

### Run the Installation Script

```bash
cd ~/workshops/ubucon-workshop2026/lab-02-k3s-cilium

# Make the script executable
chmod +x install-k3s-cilium.sh

# Run the installation
./install-k3s-cilium.sh
```

The script will:
1. Install K3s with Flannel disabled
2. Configure kubectl access
3. Install the Cilium CLI
4. Deploy Cilium to the cluster
5. Enable Hubble observability

### What's Happening?

**K3s Installation:**
```bash
curl -sfL https://get.k3s.io | \
    INSTALL_K3S_EXEC="--flannel-backend=none --disable-network-policy" sh -
```

- `--flannel-backend=none`: Disables the default CNI so Cilium can take over
- `--disable-network-policy`: Lets Cilium handle network policies instead of kube-proxy

**Cilium Deployment:**
```bash
cilium install --version 1.15.0
cilium hubble enable --ui
```

## Verify Installation

### Check Cluster Status

```bash
# Verify nodes are ready
kubectl get nodes

# Expected output:
# NAME          STATUS   ROLES                  AGE   VERSION
# <hostname>    Ready    control-plane,master   1m    v1.28.x+k3s1
```

### Check Cilium Status

```bash
# Cilium health check
cilium status

# Expected: All components should show "OK"
```

### Check All Pods

```bash
# View all system pods
kubectl get pods -A

# You should see:
# - cilium-* pods in kube-system
# - hubble-* pods in kube-system
# - coredns-* pods in kube-system
```

## Explore Cilium

### View Cilium Configuration

```bash
# See Cilium's configuration
cilium config view

# Check Cilium version
cilium version
```

### Test Connectivity

```bash
# Run Cilium connectivity test
cilium connectivity test
```

This deploys test pods and verifies network connectivity. It takes a few minutes.

## Launch Hubble UI

Hubble provides a visual interface for network flows:

```bash
# Start Hubble UI (opens in browser)
cilium hubble ui
```

This will:
1. Port-forward the Hubble UI service
2. Open your default browser to `http://localhost:12000`

**Note:** If the browser doesn't open automatically, manually navigate to `http://localhost:12000`.

## Understanding the Architecture

```
+-------------------------------------------------------------+
|                        WSL2 Ubuntu                          |
|  +-------------------------------------------------------+  |
|  |                    K3s Cluster                        |  |
|  |  +-------------+  +-------------+  +-------------+   |  |
|  |  |   Pod A     |  |   Pod B     |  |   Pod C     |   |  |
|  |  +------+------+  +------+------+  +------+------+   |  |
|  |         |                |                |          |  |
|  |  +------+----------------+----------------+------+   |  |
|  |  |              Cilium eBPF Dataplane            |   |  |
|  |  |    (Network Policies, Load Balancing, etc.)   |   |  |
|  |  +-----------------------------------------------+   |  |
|  |                         |                            |  |
|  |  +-----------------------+-----------------------+   |  |
|  |  |                 Hubble                        |   |  |
|  |  |         (Observability & Monitoring)          |   |  |
|  |  +-----------------------------------------------+   |  |
|  +-------------------------------------------------------+  |
+-------------------------------------------------------------+
```

## Useful Commands

| Command | Description |
|---------|-------------|
| `kubectl get nodes` | List cluster nodes |
| `kubectl get pods -A` | List all pods in all namespaces |
| `cilium status` | Check Cilium health |
| `cilium hubble ui` | Launch Hubble web UI |
| `hubble observe` | Watch network flows in terminal |
| `k3s kubectl` | Alternative kubectl if PATH issues |

## Troubleshooting

### Cilium Pods Not Starting

```bash
# Check pod status
kubectl describe pods -n kube-system -l k8s-app=cilium

# Check logs
kubectl logs -n kube-system -l k8s-app=cilium
```

### kubectl Command Not Found

```bash
# Add to PATH
export KUBECONFIG=~/.kube/config

# Or use k3s kubectl directly
sudo k3s kubectl get nodes
```

### Cluster Won't Start After WSL Restart

```bash
# Restart K3s service
sudo systemctl restart k3s

# Check service status
sudo systemctl status k3s
```

### Reset Everything

If you need to start fresh:

```bash
# Uninstall K3s (removes everything)
/usr/local/bin/k3s-uninstall.sh

# Re-run installation
./install-k3s-cilium.sh
```

## Next Step

Your Kubernetes cluster is ready! Proceed to [Lab 03: Secrets with SOPS](../lab-03-secrets-sops/).
