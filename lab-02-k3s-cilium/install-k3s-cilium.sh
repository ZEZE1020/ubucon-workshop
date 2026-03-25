#!/bin/bash
#
# K3s + Cilium Installation Script
# UbuCon Africa 2026 Workshop
#

set -euo pipefail

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

print_banner() {
    echo -e "${CYAN}"
    echo "======================================================"
    echo "     K3s + Cilium Installation"
    echo "     UbuCon Africa 2026 Workshop"
    echo "======================================================"
    echo -e "${NC}"
}

print_step() {
    echo -e "\n${BOLD}${GREEN}>>> $1${NC}\n"
}

print_success() {
    echo -e "${GREEN}[OK] $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}[WARN] $1${NC}"
}

print_error() {
    echo -e "${RED}[ERROR] $1${NC}"
}

print_info() {
    echo -e "${CYAN}[INFO] $1${NC}"
}

# Main installation
main() {
    print_banner
    
    echo -e "${CYAN}This script will install K3s and Cilium on your system.${NC}"
    echo -e "${CYAN}It requires sudo privileges for installation.${NC}\n"
    sleep 2

    # Step 1: Install K3s without Flannel
    print_step "Step 1/5: Installing K3s (CNI disabled for Cilium)"
    
    print_info "Disabling Flannel and default network policy..."
    curl -sfL https://get.k3s.io | \
        INSTALL_K3S_EXEC="--flannel-backend=none --disable-network-policy --disable=traefik" \
        sh -
    
    print_success "K3s installed successfully!"

    # Step 2: Configure KUBECONFIG
    print_step "Step 2/5: Configuring KUBECONFIG"
    
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
    print_step "Step 3/5: Installing Cilium CLI"
    
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
    print_step "Step 4/5: Deploying Cilium to the cluster"
    
    print_info "This may take a few minutes..."
    cilium install --version 1.15.0
    
    print_info "Waiting for Cilium to be ready..."
    cilium status --wait
    
    print_success "Cilium is operational!"

    # Step 5: Enable Hubble (observability)
    print_step "Step 5/5: Enabling Hubble Observability"
    
    cilium hubble enable --ui
    
    print_success "Hubble UI enabled!"

    # Final Summary
    echo -e "\n${GREEN}======================================================${NC}"
    echo -e "${GREEN}     Installation Complete!${NC}"
    echo -e "${GREEN}======================================================${NC}"
    echo ""
    echo -e "${CYAN}Quick Commands:${NC}"
    echo "  kubectl get nodes         # Check nodes"
    echo "  cilium status             # Cilium health"
    echo "  cilium hubble ui          # Launch Hubble UI"
    echo "  kubectl get pods -A       # All pods"
    echo ""
    echo -e "${YELLOW}Note: Run 'source ~/.bashrc' or open a new terminal${NC}"
    echo -e "${YELLOW}to ensure KUBECONFIG is set correctly.${NC}"
    echo ""
}

# Run main function
main "$@"
