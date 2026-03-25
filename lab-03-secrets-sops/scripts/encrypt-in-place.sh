#!/bin/bash
#
# SOPS In-Place Encryption Script
# UbuCon Africa 2026 Workshop
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

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SECRETS_FILE="${SCRIPT_DIR}/../app/secrets.yaml"
KEY_FILE="${HOME}/.sops/key.txt"

# Check if sops is installed
if ! command -v sops &> /dev/null; then
    echo -e "${YELLOW}[INFO] 'sops' is not installed. Installing...${NC}"
    
    SOPS_VERSION="3.8.1"
    curl -LO "https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.amd64"
    sudo mv "sops-v${SOPS_VERSION}.linux.amd64" /usr/local/bin/sops
    sudo chmod +x /usr/local/bin/sops
    
    echo -e "${GREEN}[OK] sops v${SOPS_VERSION} installed!${NC}"
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

# Set environment variable
export SOPS_AGE_KEY_FILE="${KEY_FILE}"

# Get public key from private key file
PUBLIC_KEY=$(grep "public key:" "${KEY_FILE}" | awk '{print $NF}')

echo -e "\n${CYAN}>>> Encrypting Secrets${NC}\n"

echo -e "${CYAN}File: ${SECRETS_FILE}${NC}"
echo -e "${CYAN}Using key: ${PUBLIC_KEY:0:20}...${NC}\n"

# Show before
echo -e "${YELLOW}BEFORE (cleartext):${NC}"
echo -e "${RED}$(cat "${SECRETS_FILE}" | grep -A5 'stringData:')${NC}\n"

# Encrypt in place
echo -e "${CYAN}Encrypting...${NC}"
sops --encrypt --age "${PUBLIC_KEY}" --in-place "${SECRETS_FILE}"

echo -e "${GREEN}[OK] Encryption complete!${NC}\n"

# Show after
echo -e "${YELLOW}AFTER (encrypted):${NC}"
echo -e "${GREEN}$(cat "${SECRETS_FILE}" | head -25)${NC}"
echo -e "${CYAN}... (truncated)${NC}\n"

# Summary
echo -e "${GREEN}======================================================${NC}"
echo -e "${GREEN}     Encryption Complete!${NC}"
echo -e "${GREEN}======================================================${NC}"
echo ""
echo "Useful Commands:"
echo "  sops secrets.yaml          # Edit encrypted file"
echo "  sops -d secrets.yaml       # Decrypt to stdout"
echo "  sops --rotate secrets.yaml # Rotate keys"
echo ""
echo -e "${GREEN}[OK] Safe to commit to git now!${NC}"
echo ""
