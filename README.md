# Building Secure Dev Environments with Ubuntu on WSL

> **UbuCon Africa 2026 - Nairobi, Kenya**

[![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04_LTS-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](https://ubuntu.com)
[![WSL](https://img.shields.io/badge/WSL2-Windows-0078D4?style=for-the-badge&logo=windows&logoColor=white)](https://learn.microsoft.com/en-us/windows/wsl/)
[![K3s](https://img.shields.io/badge/K3s-Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)](https://k3s.io)
[![Cilium](https://img.shields.io/badge/Cilium-eBPF-F8C517?style=for-the-badge&logo=cilium&logoColor=black)](https://cilium.io)

## Welcome! Karibu!

This hands-on workshop will guide you through building a secure, production-grade development environment using Ubuntu on Windows Subsystem for Linux (WSL). You'll learn industry best practices for container security, secrets management, and network policies.

**By the end of this workshop, you will:**
- Set up Ubuntu on WSL2 with a local Kubernetes cluster (K3s)
- Implement GitOps-friendly secrets encryption with SOPS and age
- Build minimal-attack-surface containers using Canonical Chiseled images
- Apply Zero Trust network policies with Cilium eBPF
- Visualize network traffic and security events with Hubble

## Prerequisites

Before starting, ensure you have:

| Requirement | Minimum | Recommended |
|-------------|---------|-------------|
| Windows Version | Windows 10 (Build 19041+) | Windows 11 |
| RAM | 8 GB | 16 GB |
| Free Disk Space | 20 GB | 40 GB |
| WSL Version | WSL 2 | WSL 2 |

**Software to install beforehand:**
- [Windows Terminal](https://aka.ms/terminal) (recommended)
- [Visual Studio Code](https://code.visualstudio.com/) with [Remote - WSL extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl)

## Workshop Structure

Follow the labs in order. Each lab builds on the previous one.

```
.
├── lab-00-prerequisites/     # System requirements & initial setup
├── lab-01-wsl-setup/         # Ubuntu on WSL2 installation
├── lab-02-k3s-cilium/        # Kubernetes cluster with Cilium CNI
├── lab-03-secrets-sops/      # Secrets management with SOPS + age
└── lab-04-network-policies/  # Zero Trust networking with Cilium
```

| Lab | Title | Duration | Description |
|-----|-------|----------|-------------|
| 00 | [Prerequisites](lab-00-prerequisites/) | 10 min | Verify system requirements |
| 01 | [WSL Setup](lab-01-wsl-setup/) | 15 min | Install Ubuntu on WSL2 |
| 02 | [K3s + Cilium](lab-02-k3s-cilium/) | 20 min | Deploy local Kubernetes cluster |
| 03 | [Secrets with SOPS](lab-03-secrets-sops/) | 25 min | Encrypt secrets for GitOps |
| 04 | [Network Policies](lab-04-network-policies/) | 30 min | Implement Zero Trust networking |

**Total Duration:** ~2 hours

## Quick Navigation

- **New to WSL?** Start with [Lab 00](lab-00-prerequisites/)
- **WSL already installed?** Jump to [Lab 02](lab-02-k3s-cilium/)
- **Just here for Cilium?** Check [Lab 04](lab-04-network-policies/)

## Technologies Covered

| Technology | Purpose | Why It Matters |
|------------|---------|----------------|
| **Ubuntu on WSL2** | Linux environment on Windows | Native Linux tooling without dual-boot |
| **K3s** | Lightweight Kubernetes | Production-grade K8s that runs anywhere |
| **Cilium** | eBPF-based networking | Kernel-level security and observability |
| **SOPS + age** | Secrets encryption | Safe to commit encrypted secrets to Git |
| **Chiseled Containers** | Distroless images | Minimal attack surface, no shell access |
| **Hubble** | Network observability | Visualize and debug network flows |

## Getting Help

During the workshop:
- Raise your hand for instructor assistance
- Check the troubleshooting section in each lab's README
- Ask your neighbor - pair programming encouraged!

After the workshop:
- Open an issue in this repository
- Join the [Ubuntu Discourse](https://discourse.ubuntu.com/)
- Connect with the [Cilium Slack community](https://cilium.io/slack)

## Resources

**Documentation:**
- [Ubuntu WSL Guide](https://ubuntu.com/wsl)
- [K3s Documentation](https://docs.k3s.io)
- [Cilium Documentation](https://docs.cilium.io)
- [SOPS GitHub](https://github.com/getsops/sops)
- [Canonical Chiseled Containers](https://ubuntu.com/blog/combining-distroless-and-ubuntu-chiselled-containers)

**Community:**
- [Ubuntu Kenya Community](https://ubuntu.com/community)
- [Cloud Native Nairobi](https://community.cncf.io/nairobi/)

## License

This workshop material is licensed under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).

---

**Happy Learning! Enjoy the workshop!**
