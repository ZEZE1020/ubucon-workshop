#!/bin/bash
#
# SOPS In-Place Encryption Script
# UbuCon Africa 2026 Workshop
#
# Supports: Linux, macOS, WSL
#

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}"
echo "======================================================"
echo "     SOPS In-Place Encryption"
echo "     UbuCon Africa 2026 Workshop"
echo "======================================================"
echo -e "${NC}"

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Linux*)  echo "linux" ;;
        Darwin*) echo "macos" ;;
        *)       echo "unknown" ;;
    esac
}

OS=$(detect_os)

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SECRETS_FILE="${SCRIPT_DIR}/../app/secrets.yaml"
KEY_FILE="${HOME}/.sops/key.txt"

# Check if sops is installed
if ! command -v sops &> /dev/null; then
    echo -e "${YELLOW}[INFO] 'sops' is not installed. Installing...${NC}"
    
    SOPS_VERSION="3.8.1"
    
    case $OS in
        linux)
            ARCH=$(uname -m)
            case $ARCH in
                x86_64)  SOPS_ARCH="amd64" ;;
                aarch64) SOPS_ARCH="arm64" ;;
                *)       echo -e "${RED}[ERROR] Unsupported architecture: $ARCH${NC}"; exit 1 ;;
            esac
            curl -LO "https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.${SOPS_ARCH}"
            sudo mv "sops-v${SOPS_VERSION}.linux.${SOPS_ARCH}" /usr/local/bin/sops
            sudo chmod +x /usr/local/bin/sops
            ;;
        macos)
            if command -v brew &> /dev/null; then
                brew install sops
            else
                ARCH=$(uname -m)
                case $ARCH in
                    x86_64) SOPS_ARCH="amd64" ;;
                    arm64)  SOPS_ARCH="arm64" ;;
                    *)      echo -e "${RED}[ERROR] Unsupported architecture: $ARCH${NC}"; exit 1 ;;
                esac
                curl -LO "https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.darwin.${SOPS_ARCH}"
                sudo mv "sops-v${SOPS_VERSION}.darwin.${SOPS_ARCH}" /usr/local/bin/sops
                sudo chmod +x /usr/local/bin/sops
            fi
            ;;
        *)
            echo -e "${RED}[ERROR] Unsupported OS. Please install 'sops' manually.${NC}"
            exit 1
            ;;
    esac
    
    echo -e "${GREEN}[OK] sops installed!${NC}"
fi

# Check if key exists
if [ ! -f "${KEY_FILE}" ]; then
    echo -e "${RED}[ERROR] Age key not found at ${KEY_FILE}${NC}"
    echo -e "${YELLOW}Run ./generate-age-key.sh first!${NC}"
    exit 1
fi

# Check if secrets file exists
if [ ! -f "${SECRETS_FILE}" ]; then
    echo -e "${RED}[ERROR] Secrets file not found: ${SECRETS_FILE}${NC}"
    exit 1
fi

# Check if already encrypted
if grep -q "sops:" "${SECRETS_FILE}" 2>/dev/null; then
    echo -e "${YELLOW}[WARN] File appears to already be encrypted.${NC}"
    read -p "Re-encrypt anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${CYAN}[INFO] Skipping encryption.${NC}"
        exit 0
    fi
    # Decrypt first before re-encrypting
    echo -e "${CYAN}[INFO] Decrypting first...${NC}"
    export SOPS_AGE_KEY_FILE="${KEY_FILE}"
    sops --decrypt --in-place "${SECRETS_FILE}"
fi

# Set environment variable
export SOPS_AGE_KEY_FILE="${KEY_FILE}"

# Get public key from private key file
PUBLIC_KEY=$(grep "public key:" "${KEY_FILE}" | awk '{print $NF}')

echo -e "\n${CYAN}>>> Encrypting Secrets${NC}\n"

echo -e "${CYAN}File: ${SECRETS_FILE}${NC}"
echo -e "${CYAN}Using key: ${PUBLIC_KEY:0:20}...${NC}\n"

# Show before
echo -e "${YELLOW}BEFORE (cleartext):${NC}"
echo -e "${RED}$(cat "${SECRETS_FILE}" | grep -A5 'stringData:' || echo 'No stringData found')${NC}\n"

# Encrypt in place
echo -e "${CYAN}Encrypting...${NC}"
sops --encrypt --age "${PUBLIC_KEY}" --in-place "${SECRETS_FILE}"

echo -e "${GREEN}[OK] Encryption complete!${NC}\n"

# Show after
echo -e "${YELLOW}AFTER (encrypted):${NC}"
echo -e "${GREEN}$(head -25 "${SECRETS_FILE}")${NC}"
echo -e "${CYAN}... (truncated)${NC}\n"

# Summary
echo -e "${GREEN}======================================================${NC}"
echo -e "${GREEN}     Encryption Complete!${NC}"
echo -e "${GREEN}======================================================${NC}"
echo ""
echo "Useful Commands:"
echo "  sops ../app/secrets.yaml          # Edit encrypted file"
echo "  sops -d ../app/secrets.yaml       # Decrypt to stdout"
echo "  sops --rotate ../app/secrets.yaml # Rotate keys"
echo ""
echo -e "${GREEN}[OK] Safe to commit to git now!${NC}"
echo ""
