# Bridging the Divide: Cloud-Native Skills on Any Laptop

> **UbuCon Kenya 2026 - Nairobi, Kenya**

[![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04_LTS-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](https://ubuntu.com){:target="_blank"}
[![WSL](https://img.shields.io/badge/WSL2-Windows-0078D4?style=for-the-badge&logo=windows&logoColor=white)](https://learn.microsoft.com/en-us/windows/wsl/){:target="_blank"}
[![Kubernetes](https://img.shields.io/badge/Kubernetes-Kind-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kind.sigs.k8s.io/){:target="_blank"}
[![Cilium](https://img.shields.io/badge/Cilium-eBPF-2394F4?style=for-the-badge&logo=cilium&logoColor=white)](https://cilium.io/){:target="_blank"}

## Welcome! 

Many of us start learning to code on Windows laptops, but find that many cloud tools work best on Linux. This workshop helps you bridge that gap without needing to buy a new computer. We will use the Windows Subsystem for Linux (WSL) to run Ubuntu and learn modern development skills right from your own machine.

**By the end of this workshop, you will be able to:**
- Set up Ubuntu on Windows using WSL.
- Secure your code with free tools from Ubuntu Pro.
- Run a local Kubernetes cluster with Kind.
- Manage secret keys and passwords for your applications.
- Build smaller, more secure container images.
- Control network traffic between your applications using Cilium.
- See how your applications communicate with the Hubble UI.

## Workshop Structure

Follow the labs in order. Each one builds on the last.

| Lab | Title | Duration | Description |
|-----|-------|----------|-------------|
| 00 | [Prerequisites](lab-00-prerequisites/) | 15 min | Check your system and install essential tools. |
| 01 | [Ubuntu Pro & ESM](lab-01-ubuntu-pro/) | 15 min | Enable extra security updates for your applications. |
| 02 | [WSL & Systemd Setup](lab-02-wsl-setup/) | 15 min | Configure the Ubuntu environment on Windows. |
| 03 | [Kind + Cilium](lab-03-kind-cilium/) | 20 min | Deploy a local Kubernetes cluster. |
| 04 | [Visualizing Network Policies](lab-04-cilium-demo/) | 25 min | Implement and visualize Zero Trust security with Cilium and Hubble. |

**Total Duration:** ~2 hours

## Why These Technologies?

These tools are popular, powerful, and work well on a laptop.

| Technology | Purpose | Why It's Useful |
|------------|---------|----------------|
| **Ubuntu on WSL** | The Foundation | Run the most popular operating system for cloud servers on your Windows PC. |
| **Ubuntu Pro** | Extra Security | Get free access to security patches that keep your applications safe. |
| **Kind Kubernetes**| Local Kubernetes | A simple version of Kubernetes that's easy to run on your laptop. |
| **Cilium** | Networking & Observability | A modern way to manage and visualize network connections between your apps. |

## Getting Help

During the workshop:
- Raise your hand for assistance.
- Check the troubleshooting section in each lab's README.
- Ask your neighbor—we encourage collaboration!

After the workshop:
- Open an issue in this repository.
- Connect with the [Ubuntu Kenya LoCo Team](https://discourse.ubuntu.com/c/community/circles/ubuntu-ke/421){:target="_blank"}
- Join the [Cloud Native Nairobi community](https://community.cncf.io/nairobi/){:target="_blank"}

## License

This workshop material is licensed under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/){:target="_blank"}

---

**Ready to build? Let's get started!**