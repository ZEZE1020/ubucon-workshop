# Building Secure Dev Environments with Ubuntu

> **UbuCon Africa 2026 - Nairobi, Kenya**

[![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04_LTS-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](https://ubuntu.com)
[![Linux](https://img.shields.io/badge/Linux-Native-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://ubuntu.com/download)
[![macOS](https://img.shields.io/badge/macOS-Supported-000000?style=for-the-badge&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![WSL](https://img.shields.io/badge/WSL2-Windows-0078D4?style=for-the-badge&logo=windows&logoColor=white)](https://learn.microsoft.com/en-us/windows/wsl/)

## Welcome! Karibu!

This hands-on workshop will guide you through building a secure, development environment. You'll learn industry best practices for container security, secrets management, and network policies.

**Works on:** Windows (WSL2), Linux (Ubuntu/Debian/Fedora), and macOS

**By the end of this workshop, you will:**
- Set up a local Kubernetes cluster (K3s)
- Implement GitOps-friendly secrets  with SOPS and age
- Build minimal-attack-surface containers using Canonical Chiseled images
- Apply network policies with Cilium eBPF
- Visualize network traffic and security events with Hubble

## Choose Your Path

| Your OS | Start Here | Notes |
|---------|------------|-------|
| **Windows 10/11** | [Lab 00: Prerequisites](lab-00-prerequisites/) | Uses WSL2 with Ubuntu |
| **Ubuntu/Debian** | [Lab 00: Prerequisites](lab-00-prerequisites/#linux-native) | Native Linux |
| **Fedora/RHEL** | [Lab 00: Prerequisites](lab-00-prerequisites/#linux-native) | Native Linux |
| **macOS** | [Lab 00: Prerequisites](lab-00-prerequisites/#macos) | Uses Docker Desktop or Lima |

## Prerequisites

### Minimum Requirements (All Platforms)

| Requirement | Minimum | Recommended |
|-------------|---------|-------------|
| RAM | 8 GB | 16 GB |
| Free Disk Space | 20 GB | 40 GB |
| CPU | 64-bit, 2 cores | 4+ cores |

### Platform-Specific Requirements

| Platform | Additional Requirements |
|----------|------------------------|
| **Windows** | Windows 10 Build 19041+ or Windows 11, WSL2 enabled |
| **Linux** | systemd-based distro (Ubuntu 20.04+, Debian 11+, Fedora 38+) |
| **macOS** | macOS 12 Monterey+, Apple Silicon or Intel |

## Workshop Structure

Follow the labs in order. Each lab builds on the previous one.

```
.
├── lab-00-prerequisites/     # System setup (OS-specific)
├── lab-01-environment/       # Development environment setup
├── lab-02-k3s-cilium/        # Kubernetes cluster with Cilium CNI
├── lab-03-secrets-sops/      # Secrets management with SOPS + age
└── lab-04-network-policies/  # Zero Trust networking with Cilium
```

| Lab | Title | Duration | Description |
|-----|-------|----------|-------------|
| 00 | [Prerequisites](lab-00-prerequisites/) | 10-15 min | System setup (varies by OS) |
| 01 | [Environment Setup](lab-01-wsl-setup/) | 10-15 min | Dev environment configuration |
| 02 | [K3s + Cilium](lab-02-k3s-cilium/) | 20 min | Deploy local Kubernetes cluster |
| 03 | [Secrets with SOPS](lab-03-secrets-sops/) | 25 min | Encrypt secrets for GitOps |
| 04 | [Network Policies](lab-04-network-policies/) | 30 min | Implement Zero Trust networking |

**Total Duration:** ~1.5-2 hours

## Quick Navigation

- **New to this?** Start with [Lab 00](lab-00-prerequisites/)
- **Environment ready?** Jump to [Lab 02](lab-02-k3s-cilium/)
- **Just here for Cilium?** Check [Lab 04](lab-04-network-policies/)

## Technologies Covered

| Technology | Purpose | Why It Matters |
|------------|---------|----------------|
| **K3s** | Lightweight Kubernetes | Production-grade K8s that runs anywhere |
| **Cilium** | eBPF-based networking | Kernel-level security and observability |
| **SOPS + age** | Secrets encryption | Safe to commit encrypted secrets to Git |
| **Chiseled Containers** | Distroless images | Minimal attack surface, no shell access |
| **Hubble** | Network observability | Visualize and debug network flows |

## Getting Help

During the workshop:
- Raise your hand for assistance
- Check the troubleshooting section in each lab's README
- Ask your neighbor - pair programming encouraged!

After the workshop:
- Open an issue in this repository
- Join the [Ubuntu Discourse](https://discourse.ubuntu.com/)
- Connect with the [Cilium Slack community](https://cilium.io/slack)

## Resources

**Documentation:**
- [Ubuntu Download](https://ubuntu.com/download)
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
