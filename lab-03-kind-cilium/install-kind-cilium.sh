#!/bin/bash

set -e

# Function to detect the environment
detect_environment() {
    if grep -qi microsoft /proc/version 2>/dev/null; then
        echo "wsl"
    elif [ -f /.dockerenv ]; then
        echo "docker"
    elif [ -d /lima ]; then
        echo "lima"
    elif [ "$(uname)" = "Darwin" ]; then
        echo "macos"
    else
        echo "linux"
    fi
}

# Main installation logic
main() {
    echo "     UbuCon Kenya 2026 Workshop"
    echo "----------------------------------------"
    echo " Lab 03: Kubernetes Networking with Kind and Cilium"
    echo "----------------------------------------"

    # Detect environment
    local env
    env=$(detect_environment)
    echo "INFO: Detected environment: $env"

    # Install Kind
    echo "INFO: Installing Kind..."
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind

    # Create a Kind cluster
    echo "INFO: Creating a Kind cluster..."
    cat <<EOF | kind create cluster --name ubucon-workshop --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  disableDefaultCNI: true
EOF

    # Install Cilium CLI
    echo "INFO: Installing Cilium CLI..."
    CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
    CLI_ARCH=amd64
    if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
    curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
    sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
    sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
    rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}

    # Install Cilium
    echo "INFO: Installing Cilium..."
    cilium install --version 1.15.0

    # Enable Hubble
    echo "INFO: Enabling Hubble..."
    cilium hubble enable --ui

    echo "----------------------------------------"
    echo "SUCCESS: Lab 3 setup with Kind and Cilium is complete!"
    echo "----------------------------------------"
}

# Run the installation
main