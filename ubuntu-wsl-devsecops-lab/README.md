# 🔐 Ubuntu WSL DevSecOps Lab

> **Building Secure Dev Environments with Ubuntu on WSL**  
> *"Welcome to the real world." - Morpheus*

[![Ubuntu](https://img.shields.io/badge/Ubuntu-WSL2-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](https://ubuntu.com/wsl)
[![K3s](https://img.shields.io/badge/K3s-Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)](https://k3s.io)
[![Cilium](https://img.shields.io/badge/Cilium-eBPF-F8C517?style=for-the-badge&logo=cilium&logoColor=black)](https://cilium.io)

## 🎯 Workshop Overview

This hands-on workshop teaches you how to build a secure, production-grade development environment using:

- **Ubuntu on WSL2** - Linux development on Windows
- **K3s** - Lightweight Kubernetes
- **Cilium** - eBPF-powered networking & security
- **SOPS + age** - GitOps-friendly secrets management
- **Canonical Chiseled Containers** - Distroless security

## 📁 Lab Structure

```
ubuntu-wsl-devsecops-lab/
├── 02-local-cloud-k3s/          # K3s + Cilium installation
│   └── install-k3s-no-flannel.sh
├── 03-lab-secrets-sops/         # Secrets management lab
│   ├── app/                     # FastAPI demo app
│   │   ├── main.py
│   │   ├── requirements.txt
│   │   ├── Dockerfile
│   │   └── secrets.yaml
│   └── scripts/                 # SOPS automation
│       ├── generate-age-key.sh
│       └── encrypt-in-place.sh
└── 04-lab-network-cilium/       # Network security lab
    ├── manifests/               # K8s deployments
    │   ├── 01-redis-backend.yaml      # The Oracle 🔮
    │   ├── 02-fastapi-backend.yaml    # Neo 🦸
    │   └── 03-compromised-frontend.yaml # Agent Smith 🕵️
    └── policies/
        └── strict-zero-trust.yaml     # Cilium policies
```

## 🚀 Quick Start

### Lab 1: Install K3s + Cilium

```bash
cd 02-local-cloud-k3s
chmod +x install-k3s-no-flannel.sh
./install-k3s-no-flannel.sh
```

### Lab 2: Secrets Management with SOPS

```bash
cd 03-lab-secrets-sops/scripts
chmod +x *.sh
./generate-age-key.sh
./encrypt-in-place.sh
```

### Lab 3: Zero Trust Networking with Cilium

```bash
cd 04-lab-network-cilium

# Deploy the Matrix!
kubectl apply -f manifests/

# Apply Zero Trust policies
kubectl apply -f policies/

# Watch Agent Smith get blocked!
hubble observe --namespace matrix --verdict DROPPED
```

## 🎬 The Matrix Theme

Our network lab uses a Matrix theme for memorable demonstrations:

| Pod | Character | Role |
|-----|-----------|------|
| `the-oracle` | The Oracle | Redis database (protected resource) |
| `neo` | Neo | FastAPI backend (trusted service) |
| `agent-smith` | Agent Smith | Attacker pod (blocked by Cilium) |

## 🛡️ Security Features Demonstrated

1. **Distroless Containers** - Minimal attack surface with Canonical Chiseled Ubuntu
2. **Encrypted Secrets** - SOPS + age for GitOps-safe secrets
3. **Zero Trust Networking** - Cilium eBPF policies block unauthorized traffic
4. **Network Observability** - Hubble UI visualizes all traffic flows

## 📚 Resources

- [Ubuntu WSL Documentation](https://ubuntu.com/wsl)
- [K3s Documentation](https://docs.k3s.io)
- [Cilium Documentation](https://docs.cilium.io)
- [SOPS Documentation](https://github.com/getsops/sops)

## 🎉 Workshop Credits

**UbuCon Workshop 2026**  
*Building Secure Dev Environments with Ubuntu on WSL*

---

> *"You have to let it all go, Neo. Fear, doubt, and disbelief. Free your mind."* - Morpheus
