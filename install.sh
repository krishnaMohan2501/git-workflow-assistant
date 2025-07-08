#!/bin/bash

# Git Workflow Assistant - Simple Installer
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

REPO_URL="https://github.com/krishnaMohan2501/git-workflow-assistant"
INSTALL_DIR="$HOME/.local/bin"

echo -e "${BLUE}🚀 Installing Git Workflow Assistant${NC}"
echo "=================================================="

# Check requirements
echo -e "${BLUE}Checking requirements...${NC}"
if ! command -v git >/dev/null 2>&1; then
    echo -e "${RED}❌ Git is required but not installed${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Git found${NC}"

if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
    echo -e "${RED}❌ curl or wget is required${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Download tool found${NC}"

# Create install directory
mkdir -p "$INSTALL_DIR"

# Download script
echo -e "${BLUE}Downloading script...${NC}"
if command -v curl >/dev/null 2>&1; then
    curl -fsSL "${REPO_URL}/raw/main/git-workflow.sh" -o "$INSTALL_DIR/git-workflow.sh"
else
    wget -q "${REPO_URL}/raw/main/git-workflow.sh" -O "$INSTALL_DIR/git-workflow.sh"
fi

# Make executable
chmod +x "$INSTALL_DIR/git-workflow.sh"

# Create aliases
echo -e "${BLUE}Creating aliases...${NC}"
ln -sf "$INSTALL_DIR/git-workflow.sh" "$INSTALL_DIR/git-workflow" 2>/dev/null || true
ln -sf "$INSTALL_DIR/git-workflow.sh" "$INSTALL_DIR/gitflow" 2>/dev/null || true

echo -e "${GREEN}✅ Script installed to: $INSTALL_DIR/git-workflow.sh${NC}"

# Check PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo -e "${YELLOW}⚠️  $INSTALL_DIR is not in your PATH${NC}"
    echo "Add this to your shell config (~/.bashrc, ~/.zshrc, etc.):"
    echo "export PATH=\"$INSTALL_DIR:\$PATH\""
else
    echo -e "${GREEN}✅ Installation directory is in PATH${NC}"
fi

# Test installation
echo -e "${BLUE}Testing installation...${NC}"
if "$INSTALL_DIR/git-workflow.sh" --version >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Installation successful!${NC}"
else
    echo -e "${YELLOW}⚠️  Installation completed but script may have issues${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Git Workflow Assistant installed!${NC}"
echo ""
echo "Usage:"
echo "  $INSTALL_DIR/git-workflow.sh         # Full path"
echo "  git-workflow.sh                      # If in PATH"
echo "  git-workflow                         # Alias"
echo ""
echo "Quick start:"
echo "  git-workflow.sh --help               # Show help"
echo "  git-workflow.sh                      # Interactive menu"
echo ""
echo -e "${BLUE}📚 Documentation: ${REPO_URL}${NC}"
