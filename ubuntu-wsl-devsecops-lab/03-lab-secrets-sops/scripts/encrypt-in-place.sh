#!/bin/bash
#
# 🔒 SOPS In-Place Encryption Script
# Building Secure Dev Environments with Ubuntu on WSL
#

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'
BOLD='\033[1m'

# ASCII Art
echo -e "${PURPLE}"
cat << 'EOF'
    ╔═══════════════════════════════════════════════════════════╗
    ║                                                           ║
    ║    ███████╗ ██████╗ ██████╗ ███████╗                      ║
    ║    ██╔════╝██╔═══██╗██╔══██╗██╔════╝                      ║
    ║    ███████╗██║   ██║██████╔╝███████╗                      ║
    ║    ╚════██║██║   ██║██╔═══╝ ╚════██║                      ║
    ║    ███████║╚██████╔╝██║     ███████║                      ║
    ║    ╚══════╝ ╚═════╝ ╚═╝     ╚══════╝                      ║
    ║                                                           ║
    ║         🔐 Secrets OPerationS Encryption 🔐               ║
    ║                                                           ║
    ╚═══════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${YELLOW}🕶️  'Ignorance is bliss.' - Cypher${NC}"
echo -e "${CYAN}   But encrypted secrets are better!${NC}\n"
sleep 1

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SECRETS_FILE="${SCRIPT_DIR}/../app/secrets.yaml"
KEY_FILE="${HOME}/.sops/key.txt"

# Check if sops is installed
if ! command -v sops &> /dev/null; then
    echo -e "${RED}❌ 'sops' is not installed!${NC}"
    echo -e "${CYAN}Installing sops...${NC}"
    
    # Install sops
    SOPS_VERSION="3.8.1"
    curl -LO "https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.amd64"
    sudo mv "sops-v${SOPS_VERSION}.linux.amd64" /usr/local/bin/sops
    sudo chmod +x /usr/local/bin/sops
    
    echo -e "${GREEN}✅ sops v${SOPS_VERSION} installed!${NC}"
fi

# Check if key exists
if [ ! -f "${KEY_FILE}" ]; then
    echo -e "${RED}❌ Age key not found at ${KEY_FILE}${NC}"
    echo -e "${YELLOW}Run ./generate-age-key.sh first!${NC}"
    exit 1
fi

# Check if secrets file exists
if [ ! -f "${SECRETS_FILE}" ]; then
    echo -e "${RED}❌ Secrets file not found: ${SECRETS_FILE}${NC}"
    exit 1
fi

# Set environment variable
export SOPS_AGE_KEY_FILE="${KEY_FILE}"

# Get public key from private key file
PUBLIC_KEY=$(grep "public key:" "${KEY_FILE}" | awk '{print $NF}')

echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${GREEN}▶ Encrypting Secrets${NC}"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

echo -e "${CYAN}📄 File: ${SECRETS_FILE}${NC}"
echo -e "${CYAN}🔑 Using key: ${PUBLIC_KEY:0:20}...${NC}\n"

# Show before
echo -e "${YELLOW}📋 BEFORE (cleartext - yikes! 😱):${NC}"
echo -e "${RED}$(cat "${SECRETS_FILE}" | grep -A5 'stringData:')${NC}\n"

# Encrypt in place
echo -e "${CYAN}🔄 Encrypting...${NC}"
sops --encrypt --age "${PUBLIC_KEY}" --in-place "${SECRETS_FILE}"

echo -e "${GREEN}✅ Encryption complete!${NC}\n"

# Show after
echo -e "${YELLOW}📋 AFTER (encrypted - much better! 🔒):${NC}"
echo -e "${GREEN}$(cat "${SECRETS_FILE}" | head -30)${NC}"
echo -e "${CYAN}... (truncated)${NC}\n"

# Summary
echo -e "${GREEN}"
cat << 'EOF'
    ╔═══════════════════════════════════════════════════════════╗
    ║                                                           ║
    ║   🎉 ENCRYPTION COMPLETE! 🎉                              ║
    ║                                                           ║
    ║   Your secrets are now encrypted with age!                ║
    ║                                                           ║
    ║   Useful Commands:                                        ║
    ║   ├── sops secrets.yaml          # Edit encrypted file    ║
    ║   ├── sops -d secrets.yaml       # Decrypt to stdout      ║
    ║   └── sops --rotate secrets.yaml # Rotate keys            ║
    ║                                                           ║
    ║   ✅ Safe to commit to git now!                           ║
    ║                                                           ║
    ╚═══════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${YELLOW}🔮 'You take the blue pill, the story ends.${NC}"
echo -e "${YELLOW}   You take the red pill, you stay in Wonderland,${NC}"
echo -e "${YELLOW}   and I show you how deep the rabbit hole goes.' - Morpheus${NC}\n"
