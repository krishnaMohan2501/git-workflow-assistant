#!/bin/bash

# Git Workflow Assistant - Installation Script
# This script downloads and installs the Git Workflow Assistant

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
REPO_URL="https://github.com/yourusername/git-workflow-assistant"
SCRIPT_NAME="git-workflow.sh"
INSTALL_DIR="$HOME/.local/bin"
LOCAL_INSTALL_DIR="$HOME/git-workflow-assistant"

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

log_step() {
    echo ""
    echo -e "${CYAN}🔧 $1${NC}"
    echo "================================"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check system requirements
check_requirements() {
    log_step "Checking System Requirements"
    
    local missing_deps=()
    
    # Check Git
    if command_exists git; then
        local git_version=$(git --version | cut -d' ' -f3)
        log_success "Git found: $git_version"
    else
        log_error "Git is required but not installed"
        missing_deps+=("git")
    fi
    
    # Check Bash
    if [ -n "${BASH_VERSION:-}" ]; then
        log_success "Bash found: $BASH_VERSION"
        
        # Check Bash version (need 4.0+)
        local bash_major=$(echo "$BASH_VERSION" | cut -d'.' -f1)
        if [ "$bash_major" -lt 4 ]; then
            log_warning "Bash 4.0+ recommended, you have $BASH_VERSION"
        fi
    else
        log_error "Bash is required"
        missing_deps+=("bash")
    fi
    
    # Check Python3
    if command_exists python3; then
        local python_version=$(python3 --version | cut -d' ' -f2)
        log_success "Python3 found: $python_version"
    else
        log_warning "Python3 not found - conflict resolution features will be limited"
        log_info "Install with: sudo apt install python3 (Ubuntu) or brew install python3 (macOS)"
    fi
    
    # Check GitHub CLI
    if command_exists gh; then
        local gh_version=$(gh --version | head -1 | cut -d' ' -f3)
        log_success "GitHub CLI found: $gh_version"
    else
        log_warning "GitHub CLI not found - AI features will be limited"
        log_info "Install from: https://cli.github.com/"
    fi
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_error "Missing required dependencies: ${missing_deps[*]}"
        log_info "Please install them and run this script again"
        exit 1
    fi
}

# Detect installation method preference
choose_installation_method() {
    log_step "Choose Installation Method"
    
    echo "How would you like to install Git Workflow Assistant?"
    echo ""
    echo "1) 🌐 Download latest release (recommended)"
    echo "2) 📥 Clone from GitHub (for development)"
    echo "3) 📋 Local installation from current directory"
    echo ""
    
    read -p "Select method (1-3): " choice
    
    case "$choice" in
        1) install_from_release ;;
        2) install_from_git ;;
        3) install_from_local ;;
        *) 
            log_error "Invalid choice"
            exit 1
            ;;
    esac
}

# Install from GitHub release
install_from_release() {
    log_step "Installing from Latest Release"
    
    # Create temporary directory
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"
    
    log_info "Downloading latest release..."
    
    # Download the script directly
    if command_exists curl; then
        curl -fsSL "${REPO_URL}/raw/main/git-workflow.sh" -o "$SCRIPT_NAME"
    elif command_exists wget; then
        wget -q "${REPO_URL}/raw/main/git-workflow.sh" -O "$SCRIPT_NAME"
    else
        log_error "Neither curl nor wget found. Please install one of them."
        exit 1
    fi
    
    # Verify download
    if [ ! -f "$SCRIPT_NAME" ]; then
        log_error "Failed to download script"
        exit 1
    fi
    
    log_success "Downloaded successfully"
    
    # Install the script
    install_script "$temp_dir/$SCRIPT_NAME"
    
    # Cleanup
    cd /
    rm -rf "$temp_dir"
}

# Install from Git clone
install_from_git() {
    log_step "Installing from Git Repository"
    
    # Check if directory already exists
    if [ -d "$LOCAL_INSTALL_DIR" ]; then
        log_warning "Directory $LOCAL_INSTALL_DIR already exists"
        read -p "Remove and reinstall? (y/N): " confirm
        if [[ $confirm =~ ^[Yy]$ ]]; then
            rm -rf "$LOCAL_INSTALL_DIR"
        else
            log_info "Installation cancelled"
            exit 0
        fi
    fi
    
    log_info "Cloning repository..."
    git clone "$REPO_URL" "$LOCAL_INSTALL_DIR"
    
    cd "$LOCAL_INSTALL_DIR"
    log_success "Repository cloned successfully"
    
    # Install the script
    install_script "$LOCAL_INSTALL_DIR/$SCRIPT_NAME"
}

# Install from local directory
install_from_local() {
    log_step "Installing from Local Directory"
    
    if [ ! -f "$SCRIPT_NAME" ]; then
        log_error "Script '$SCRIPT_NAME' not found in current directory"
        log_info "Make sure you're in the git-workflow-assistant directory"
        exit 1
    fi
    
    install_script "$(pwd)/$SCRIPT_NAME"
}

# Install the script
install_script() {
    local source_script="$1"
    
    log_step "Installing Script"
    
    # Create install directory if it doesn't exist
    mkdir -p "$INSTALL_DIR"
    
    # Copy script
    cp "$source_script" "$INSTALL_DIR/$SCRIPT_NAME"
    chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
    
    log_success "Script installed to $INSTALL_DIR/$SCRIPT_NAME"
    
    # Check if install directory is in PATH
    if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
        log_warning "⚠️  $INSTALL_DIR is not in your PATH"
        add_to_path
    else
        log_success "Installation directory is already in PATH"
    fi
    
    # Create symlink for easier access
    create_symlinks
}

# Add install directory to PATH
add_to_path() {
    log_info "Adding $INSTALL_DIR to PATH..."
    
    # Detect shell
    local shell_name=$(basename "$SHELL")
    local shell_config=""
    
    case "$shell_name" in
        bash)
            if [ -f "$HOME/.bashrc" ]; then
                shell_config="$HOME/.bashrc"
            elif [ -f "$HOME/.bash_profile" ]; then
                shell_config="$HOME/.bash_profile"
            fi
            ;;
        zsh)
            shell_config="$HOME/.zshrc"
            ;;
        fish)
            shell_config="$HOME/.config/fish/config.fish"
            ;;
        *)
            log_warning "Unknown shell: $shell_name"
            ;;
    esac
    
    if [ -n "$shell_config" ]; then
        # Add PATH export to shell config
        echo "" >> "$shell_config"
        echo "# Git Workflow Assistant" >> "$shell_config"
        echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$shell_config"
        
        log_success "Added to $shell_config"
        log_info "Run 'source $shell_config' or restart your terminal"
    else
        log_warning "Could not detect shell config file"
        log_info "Manually add this to your shell config:"
        echo "export PATH=\"$INSTALL_DIR:\$PATH\""
    fi
}

# Create convenient symlinks
create_symlinks() {
    log_step "Creating Convenient Aliases"
    
    # Create shorter command aliases
    local aliases=("git-workflow" "gitflow" "gwf")
    
    for alias in "${aliases[@]}"; do
        local link_path="$INSTALL_DIR/$alias"
        if [ ! -e "$link_path" ]; then
            ln -s "$INSTALL_DIR/$SCRIPT_NAME" "$link_path"
            log_success "Created alias: $alias"
        fi
    done
    
    log_info "You can now use any of these commands:"
    echo "  • git-workflow.sh"
    echo "  • git-workflow"
    echo "  • gitflow"
    echo "  • gwf"
}

# Test installation
test_installation() {
    log_step "Testing Installation"
    
    # Test if script is accessible
    if command_exists git-workflow.sh; then
        log_success "git-workflow.sh is accessible"
        
        # Test script execution
        if git-workflow.sh --version >/dev/null 2>&1; then
            log_success "Script executes correctly"
        else
            log_warning "Script found but may have issues"
        fi
    else
        log_warning "git-workflow.sh not found in PATH"
        log_info "You can run it directly: $INSTALL_DIR/$SCRIPT_NAME"
    fi
    
    # Test GitHub CLI if available
    if command_exists gh; then
        if gh auth status >/dev/null 2>&1; then
            log_success "GitHub CLI is authenticated"
        else
            log_warning "GitHub CLI found but not authenticated"
            log_info "Run 'gh auth login' to enable AI features"
        fi
    fi
}

# Show post-installation instructions
show_post_install() {
    log_step "Installation Complete! 🎉"
    
    echo -e "${GREEN}Git Workflow Assistant has been installed successfully!${NC}"
    echo ""
    echo -e "${CYAN}📋 Quick Start:${NC}"
    echo "  git-workflow.sh              # Interactive menu"
    echo "  git-workflow.sh help         # Show help"
    echo "  git-workflow.sh git-mode     # AI command mode"
    echo "  git-workflow.sh my-branch    # Workflow mode"
    echo ""
    
    echo -e "${CYAN}🔧 Next Steps:${NC}"
    echo "  1. Restart your terminal or run: source ~/.bashrc"
    echo "  2. Run 'gh auth login' if you want AI features"
    echo "  3. Try 'git-workflow.sh' in a Git repository"
    echo ""
    
    echo -e "${CYAN}📚 Resources:${NC}"
    echo "  • Documentation: $REPO_URL"
    echo "  • Issues: $REPO_URL/issues"
    echo "  • Examples: $REPO_URL#examples"
    echo ""
    
    if [ ! -d ".git" ]; then
        echo -e "${YELLOW}
