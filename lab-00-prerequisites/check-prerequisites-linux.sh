#!/bin/bash
#
# Linux Prerequisites Check Script
# UbuCon Africa 2026 Workshop
#

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
echo "======================================================"
echo "  UbuCon Workshop Prerequisites Check (Linux)"
echo "======================================================"
echo -e "${NC}"

ALL_PASSED=true

# Check distribution
echo -e "${YELLOW}Checking Linux distribution...${NC}"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo -e "  ${GREEN}[PASS]${NC} Distribution: $NAME $VERSION"
else
    echo -e "  ${YELLOW}[WARN]${NC} Could not determine distribution"
fi

# Check kernel version
echo -e "${YELLOW}Checking kernel version...${NC}"
KERNEL_VERSION=$(uname -r | cut -d. -f1-2)
KERNEL_MAJOR=$(echo $KERNEL_VERSION | cut -d. -f1)
KERNEL_MINOR=$(echo $KERNEL_VERSION | cut -d. -f2)

if [ "$KERNEL_MAJOR" -gt 4 ] || ([ "$KERNEL_MAJOR" -eq 4 ] && [ "$KERNEL_MINOR" -ge 19 ]); then
    echo -e "  ${GREEN}[PASS]${NC} Kernel: $(uname -r) (eBPF supported)"
else
    echo -e "  ${RED}[FAIL]${NC} Kernel: $(uname -r) (need 4.19+ for eBPF)"
    ALL_PASSED=false
fi

# Check architecture
echo -e "${YELLOW}Checking architecture...${NC}"
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ] || [ "$ARCH" = "aarch64" ]; then
    echo -e "  ${GREEN}[PASS]${NC} Architecture: $ARCH"
else
    echo -e "  ${RED}[FAIL]${NC} Architecture: $ARCH (need x86_64 or aarch64)"
    ALL_PASSED=false
fi

# Check RAM
echo -e "${YELLOW}Checking system memory...${NC}"
RAM_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
RAM_GB=$((RAM_KB / 1024 / 1024))

if [ "$RAM_GB" -ge 16 ]; then
    echo -e "  ${GREEN}[PASS]${NC} RAM: ${RAM_GB} GB (excellent)"
elif [ "$RAM_GB" -ge 8 ]; then
    echo -e "  ${GREEN}[PASS]${NC} RAM: ${RAM_GB} GB (sufficient)"
else
    echo -e "  ${YELLOW}[WARN]${NC} RAM: ${RAM_GB} GB (8 GB minimum recommended)"
fi

# Check disk space
echo -e "${YELLOW}Checking disk space...${NC}"
FREE_GB=$(df -BG / | tail -1 | awk '{print $4}' | tr -d 'G')

if [ "$FREE_GB" -ge 40 ]; then
    echo -e "  ${GREEN}[PASS]${NC} Free disk space: ${FREE_GB} GB"
elif [ "$FREE_GB" -ge 20 ]; then
    echo -e "  ${GREEN}[PASS]${NC} Free disk space: ${FREE_GB} GB (minimum met)"
else
    echo -e "  ${RED}[FAIL]${NC} Free disk space: ${FREE_GB} GB (need at least 20 GB)"
    ALL_PASSED=false
fi

# Check systemd
echo -e "${YELLOW}Checking systemd...${NC}"
if command -v systemctl &> /dev/null && systemctl --version &> /dev/null; then
    echo -e "  ${GREEN}[PASS]${NC} systemd is available"
else
    echo -e "  ${RED}[FAIL]${NC} systemd not found (required for K3s)"
    ALL_PASSED=false
fi

# Check required commands
echo -e "${YELLOW}Checking required tools...${NC}"

for cmd in curl wget git; do
    if command -v $cmd &> /dev/null; then
        echo -e "  ${GREEN}[PASS]${NC} $cmd is installed"
    else
        echo -e "  ${RED}[FAIL]${NC} $cmd is not installed"
        ALL_PASSED=false
    fi
done

# Check optional tools
echo -e "${YELLOW}Checking optional tools...${NC}"

for cmd in docker jq; do
    if command -v $cmd &> /dev/null; then
        echo -e "  ${GREEN}[PASS]${NC} $cmd is installed"
    else
        echo -e "  ${CYAN}[INFO]${NC} $cmd is not installed (optional)"
    fi
done

# Check if running as root
echo -e "${YELLOW}Checking user permissions...${NC}"
if [ "$EUID" -eq 0 ]; then
    echo -e "  ${YELLOW}[WARN]${NC} Running as root (not recommended)"
else
    if sudo -n true 2>/dev/null; then
        echo -e "  ${GREEN}[PASS]${NC} User has sudo access"
    else
        echo -e "  ${CYAN}[INFO]${NC} User may need to enter password for sudo"
    fi
fi

# Summary
echo ""
echo -e "${CYAN}======================================================${NC}"
if [ "$ALL_PASSED" = true ]; then
    echo -e "  ${GREEN}All checks passed! You're ready for the workshop.${NC}"
else
    echo -e "  ${RED}Some checks failed. Please fix the issues above.${NC}"
fi
echo -e "${CYAN}======================================================${NC}"
echo ""
