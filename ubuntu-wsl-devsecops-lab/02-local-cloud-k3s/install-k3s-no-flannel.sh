#!/bin/bash
#
# 🚀 K3s + Cilium Installation Script
# Building Secure Dev Environments with Ubuntu on WSL
#

set -euo pipefail

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# ASCII Art Banner
print_banner() {
    echo -e "${CYAN}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════════════════╗
    ║                                                               ║
    ║   ██╗  ██╗██████╗ ███████╗    ██╗      █████╗ ██████╗        ║
    ║   ██║ ██╔╝╚════██╗██╔════╝    ██║     ██╔══██╗██╔══██╗       ║
    ║   █████╔╝  █████╔╝███████╗    ██║     ███████║██████╔╝       ║
    ║   ██╔═██╗  ╚═══██╗╚════██║    ██║     ██╔══██║██╔══██╗       ║
    ║   ██║  ██╗██████╔╝███████║    ███████╗██║  ██║██████╔╝       ║
    ║   ╚═╝  ╚═╝╚═════╝ ╚══════╝    ╚══════╝╚═╝  ╚═╝╚═════╝       ║
    ║                                                               ║
    ║          🐝 Powered by Cilium eBPF Magic 🐝                   ║
    ║                                                               ║
    ╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

print_step() {
    echo -e "\n${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}${GREEN}▶ $1${NC}"
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

# Main installation
main() {
    print_banner
    
    echo -e "${YELLOW}🎬 'I know kung fu.' - Neo${NC}"
    echo -e "${CYAN}   'Show me.' - Morpheus${NC}\n"
    sleep 1

    # Step 1: Install K3s without Flannel
    print_step "Installing K3s (CNI disabled for Cilium takeover)"
    
    print_info "Disabling Flannel and default network policy..."
    curl -sfL https://get.k3s.io | \
        INSTALL_K3S_EXEC="--flannel-backend=none --disable-network-policy --disable=traefik" \
        sh -
    
    print_success "K3s installed successfully!"

    # Step 2: Configure KUBECONFIG
    print_step "Configuring KUBECONFIG"
    
    mkdir -p ~/.kube
    sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
    sudo chown $(id -u):$(id -g) ~/.kube/config
    chmod 600 ~/.kube/config
    export KUBECONFIG=~/.kube/config
    
    # Add to shell profile
    if ! grep -q "KUBECONFIG" ~/.bashrc 2>/dev/null; then
        echo 'export KUBECONFIG=~/.kube/config' >> ~/.bashrc
        print_info "Added KUBECONFIG to ~/.bashrc"
    fi
    
    print_success "KUBECONFIG configured at ~/.kube/config"

    # Step 3: Install Cilium CLI
    print_step "Installing Cilium CLI"
    
    CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
    CLI_ARCH=amd64
    if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
    
    curl -L --fail --remote-name-all \
        "https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}"
    sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
    sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
    rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
    
    print_success "Cilium CLI v${CILIUM_CLI_VERSION} installed!"

    # Step 4: Install Cilium
    print_step "Deploying Cilium to the cluster"
    
    print_info "This may take a few minutes... grab a coffee ☕"
    cilium install --version 1.15.0
    
    print_info "Waiting for Cilium to be ready..."
    cilium status --wait
    
    print_success "Cilium is operational!"

    # Step 5: Enable Hubble (observability)
    print_step "Enabling Hubble Observability"
    
    cilium hubble enable --ui
    
    print_success "Hubble UI enabled!"

    # Final Summary
    echo -e "\n${GREEN}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════════════════╗
    ║                                                               ║
    ║   🎉 INSTALLATION COMPLETE! 🎉                                ║
    ║                                                               ║
    ║   Your K3s + Cilium cluster is ready!                        ║
    ║                                                               ║
    ║   Quick Commands:                                             ║
    ║   ├── kubectl get nodes         # Check nodes                 ║
    ║   ├── cilium status             # Cilium health               ║
    ║   ├── cilium hubble ui          # Launch Hubble UI            ║
    ║   └── kubectl get pods -A       # All pods                    ║
    ║                                                               ║
    ╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo -e "${YELLOW}🔮 'Welcome to the real world.' - Morpheus${NC}\n"
}

# Run main function
main "$@"
