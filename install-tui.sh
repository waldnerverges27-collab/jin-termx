#!/data/data/com.termux/files/usr/bin/bash
# install-tui.sh - Install jinx-tui for Jin-TermX
# Usage: curl -fsSL https://raw.githubusercontent.com/waldnerverges27-collab/jin-termx/main/install-tui.sh | bash

set -e

JINX_TUI_VERSION="0.1.0"
BINARY_NAME="jinx-tui"
INSTALL_DIR="${PREFIX:-/usr/local}/bin"

ARCH=$(uname -m)
case "$ARCH" in
    aarch64) ARCH_GO="arm64" ;;
    armv7l|arm) ARCH_GO="arm" ;;
    x86_64|amd64) ARCH_GO="amd64" ;;
    *)
        echo "Unsupported architecture: $ARCH"
        echo "Falling back to source build..."
        BUILD_FROM_SOURCE=true
        ;;
esac

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}╭──────────────────────────────╮${NC}"
echo -e "${BLUE}│   jinx-tui installer v${JINX_TUI_VERSION}   │${NC}"
echo -e "${BLUE}╰──────────────────────────────╯${NC}"
echo

if [[ "$BUILD_FROM_SOURCE" != "true" ]]; then
    echo -e "${YELLOW}Downloading jinx-tui (${ARCH_GO})...${NC}"
    URL="https://github.com/waldnerverges27-collab/jin-termx/releases/download/v${JINX_TUI_VERSION}/jinx-tui-linux-${ARCH_GO}"
    if curl -fsSL -o "$INSTALL_DIR/$BINARY_NAME" "$URL"; then
        chmod +x "$INSTALL_DIR/$BINARY_NAME"
        echo -e "${GREEN}Installed to $INSTALL_DIR/$BINARY_NAME${NC}"
        echo
        echo -e "Run: ${BLUE}jinx-tui${NC}"
        exit 0
    fi
    echo -e "${YELLOW}Binary download failed, building from source...${NC}"
fi

if ! command -v go &>/dev/null; then
    echo -e "${YELLOW}Installing Go...${NC}"
    pkg install golang -y
fi

echo -e "${YELLOW}Building jinx-tui from source...${NC}"
TMP_DIR=$(mktemp -d)
git clone --depth=1 https://github.com/waldnerverges27-collab/jin-termx.git "$TMP_DIR" 2>/dev/null || {
    echo -e "${RED}Failed to clone repository${NC}"
    exit 1
}

cd "$TMP_DIR/tui"
go build -ldflags="-s -w" -o "$INSTALL_DIR/$BINARY_NAME" ./cmd/jinx-tui/
chmod +x "$INSTALL_DIR/$BINARY_NAME"
rm -rf "$TMP_DIR"

echo -e "${GREEN}Built and installed to $INSTALL_DIR/$BINARY_NAME${NC}"

echo
echo -e "Run: ${BLUE}jinx-tui${NC}"
