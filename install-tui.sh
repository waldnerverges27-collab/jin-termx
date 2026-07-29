#!/data/data/com.termux/files/usr/bin/bash
# install-tui.sh - Install jinx-tui for Jin-TermX
# Usage: curl -fsSL https://raw.githubusercontent.com/waldnerverges27-collab/jin-termx/main/install-tui.sh | bash

set -e

JINX_TUI_VERSION="0.1.0"
BINARY_NAME="jinx-tui"
INSTALL_DIR="${PREFIX:-/usr/local}/bin"
REPO="waldnerverges27-collab/jin-termx"
BRANCH="main"

ARCH=$(uname -m)
case "$ARCH" in
    aarch64) ARCH_GO="arm64" ;;
    armv7l|arm) ARCH_GO="arm" ;;
    x86_64|amd64) ARCH_GO="amd64" ;;
    *)
        echo -e "\033[0;31mUnsupported architecture: $ARCH\033[0m"
        exit 1
        ;;
esac

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}╭──────────────────────────────╮${NC}"
echo -e "${BLUE}│   jinx-tui installer v${JINX_TUI_VERSION}   │${NC}"
echo -e "${BLUE}╰──────────────────────────────╯${NC}"
echo

# Descargar binario pre-compilado desde el propio repo
BINARY="jinx-tui-${ARCH_GO}"
URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}/bin/${BINARY}"
echo -e "${YELLOW}Downloading ${BINARY}...${NC}"

if curl -fsSL -o "$INSTALL_DIR/$BINARY_NAME" "$URL"; then
    chmod +x "$INSTALL_DIR/$BINARY_NAME"
    echo -e "${GREEN}✔ Installed to $INSTALL_DIR/$BINARY_NAME${NC}"
    echo
    echo -e "Run: ${BLUE}jinx-tui${NC}"
    exit 0
else
    echo -e "${RED}✗ Download failed${NC}"
    echo -e "Check: ${URL}"
    exit 1
fi
