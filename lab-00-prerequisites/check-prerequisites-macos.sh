#!/bin/bash
#
# macOS Prerequisites Check Script
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
echo "  UbuCon Workshop Prerequisites Check (macOS)"
echo "======================================================"
echo -e "${NC}"

ALL_PASSED=true

# Check macOS version
echo -e "${YELLOW}Checking macOS version...${NC}"
MACOS_VERSION=$(sw_vers -productVersion)
MACOS_MAJOR=$(echo $MACOS_VERSION | cut -d. -f1)

if [ "$MACOS_MAJOR" -ge 12 ]; then
    echo -e "  ${GREEN}[PASS]${NC} macOS version: $MACOS_VERSION"
else
    echo -e "  ${RED}[FAIL]${NC} macOS version: $MACOS_VERSION (need 12 Monterey+)"
    ALL_PASSED=false
fi

# Check architecture
echo -e "${YELLOW}Checking architecture...${NC}"
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
    echo -e "  ${GREEN}[PASS]${NC} Architecture: Apple Silicon ($ARCH)"
elif [ "$ARCH" = "x86_64" ]; then
    echo -e "  ${GREEN}[PASS]${NC} Architecture: Intel ($ARCH)"
else
    echo -e "  ${RED}[FAIL]${NC} Architecture: $ARCH (unsupported)"
    ALL_PASSED=false
fi

# Check RAM
echo -e "${YELLOW}Checking system memory...${NC}"
RAM_BYTES=$(sysctl -n hw.memsize)
RAM_GB=$((RAM_BYTES / 1024 / 1024 / 1024))

if [ "$RAM_GB" -ge 16 ]; then
    echo -e "  ${GREEN}[PASS]${NC} RAM: ${RAM_GB} GB (excellent)"
elif [ "$RAM_GB" -ge 8 ]; then
    echo -e "  ${GREEN}[PASS]${NC} RAM: ${RAM_GB} GB (sufficient)"
else
    echo -e "  ${YELLOW}[WARN]${NC} RAM: ${RAM_GB} GB (8 GB minimum recommended)"
fi

# Check disk space
echo -e "${YELLOW}Checking disk space...${NC}"
FREE_BLOCKS=$(df -g / | tail -1 | awk '{print $4}')

if [ "$FREE_BLOCKS" -ge 40 ]; then
    echo -e "  ${GREEN}[PASS]${NC} Free disk space: ${FREE_BLOCKS} GB"
elif [ "$FREE_BLOCKS" -ge 20 ]; then
    echo -e "  ${GREEN}[PASS]${NC} Free disk space: ${FREE_BLOCKS} GB (minimum met)"
else
    echo -e "  ${RED}[FAIL]${NC} Free disk space: ${FREE_BLOCKS} GB (need at least 20 GB)"
    ALL_PASSED=false
fi

# Check Homebrew
echo -e "${YELLOW}Checking Homebrew...${NC}"
if command -v brew &> /dev/null; then
    BREW_VERSION=$(brew --version | head -1)
    echo -e "  ${GREEN}[PASS]${NC} Homebrew: $BREW_VERSION"
else
    echo -e "  ${RED}[FAIL]${NC} Homebrew not installed"
    echo -e "  ${CYAN}[INFO]${NC} Install with: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
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

# Check container runtime options
echo -e "${YELLOW}Checking container runtime...${NC}"

CONTAINER_FOUND=false

if command -v docker &> /dev/null; then
    if docker info &> /dev/null; then
        echo -e "  ${GREEN}[PASS]${NC} Docker is installed and running"
        CONTAINER_FOUND=true
    else
        echo -e "  ${YELLOW}[WARN]${NC} Docker is installed but not running"
    fi
fi

if command -v limactl &> /dev/null; then
    echo -e "  ${GREEN}[PASS]${NC} Lima is installed"
    CONTAINER_FOUND=true
fi

if command -v orb &> /dev/null; then
    echo -e "  ${GREEN}[PASS]${NC} OrbStack is installed"
    CONTAINER_FOUND=true
fi

if [ "$CONTAINER_FOUND" = false ]; then
    echo -e "  ${YELLOW}[WARN]${NC} No container runtime found"
    echo -e "  ${CYAN}[INFO]${NC} Install one of: Docker Desktop, Lima, or OrbStack"
    echo -e "  ${CYAN}[INFO]${NC}   brew install --cask docker"
    echo -e "  ${CYAN}[INFO]${NC}   brew install lima"
    echo -e "  ${CYAN}[INFO]${NC}   brew install --cask orbstack"
fi

# Check optional tools
echo -e "${YELLOW}Checking optional tools...${NC}"

for cmd in jq code; do
    if command -v $cmd &> /dev/null; then
        echo -e "  ${GREEN}[PASS]${NC} $cmd is installed"
    else
        echo -e "  ${CYAN}[INFO]${NC} $cmd is not installed (optional)"
    fi
done

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
