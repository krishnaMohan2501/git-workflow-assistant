#!/bin/bash

# Git Workflow Assistant - Installation Script (FIXED)
# This script downloads and installs the Git Workflow Assistant
# FIX: Moved argument parsing to the beginning to handle --uninstall correctly

set -euo pipefail

# Handle command line arguments FIRST - before any other operations
case "${1:-}" in
    --help|-h)
        echo "Git Workflow Assistant Installer"
        echo ""
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --help, -h          Show this help"
        echo "  --version, -v       Show version"
        echo "  --uninstall         Uninstall the script"
        echo "  --check-deps        Check dependencies only"
        echo ""
        echo "Examples:"
        echo "  $0                  # Interactive installation"
        echo "  $0 --check-deps     # Check system requirements"
        echo "  $0 --uninstall      # Remove installation"
        echo ""
        echo "Remote usage:"
        echo "  curl -fsSL https://raw.githubusercontent.com/krishnaMohan2501/git-workflow-assistant/main/install.sh | bash"
        echo "  curl -fsSL https://raw.githubusercontent.com/krishnaMohan2501/git-workflow-assistant/main/install.sh | bash -s -- --uninstall"
        exit 0
        ;;
    --version|-v)
        echo "Git Workflow Assistant Installer v1.0.1"
        exit 0
        ;;
    --uninstall)
        # FIXED: Move uninstall logic to the beginning
        echo -e "\033[0;34m🗑️  Uninstalling Git Workflow Assistant\033[0m"
        echo "========================================"
        
        # Configuration (same as main script)
        INSTALL_DIR="$HOME/.local/bin"
        SCRIPT_NAME="git-workflow.sh"
        
        # Colors
        RED='\033[0;31m'
        GREEN='\033[0;32m'
        YELLOW='\033[1;33m'
        BLUE='\033[0;34m'
        CYAN='\033[0;36m'
        NC='\033[0m'
        
        uninstalled_count=0
        
        # Remove main script
        if [ -f "$INSTALL_DIR/$SCRIPT_NAME" ]; then
            rm "$INSTALL_DIR/$SCRIPT_NAME"
            echo -e "${GREEN}✅ Removed main script: $INSTALL_DIR/$SCRIPT_NAME${NC}"
            ((uninstalled_count++))
        fi
        
        # Remove aliases
        local aliases=("git-workflow" "gitflow" "gwf")
        for alias in "${aliases[@]}"; do
            if [ -f "$INSTALL_DIR/$alias" ]; then
                rm "$INSTALL_DIR/$alias"
                echo -e "${GREEN}✅ Removed alias: $alias${NC}"
                ((uninstalled_count++))
            fi
        done
        
        # Remove cloned repository if exists
        if [ -d "$HOME/git-workflow-assistant" ]; then
            echo ""
            echo -e "${YELLOW}Found cloned repository at $HOME/git-workflow-assistant${NC}"
            read -p "Remove cloned repository? (y/N): " remove_repo
            if [[ $remove_repo =~ ^[Yy]$ ]]; then
                rm -rf "$HOME/git-workflow-assistant"
                echo -e "${GREEN}✅ Removed repository: $HOME/git-workflow-assistant${NC}"
                ((uninstalled_count++))
            fi
        fi
        
        # Clean up temporary files
        rm -f /tmp/.git-workflow-fixed /tmp/git_cmd 2>/dev/null
        
        # Check for PATH entries in shell configs
        echo ""
        echo -e "${BLUE}🔍 Checking shell configurations...${NC}"
        
        local shell_configs=(
            "$HOME/.bashrc"
            "$HOME/.bash_profile" 
            "$HOME/.zshrc"
            "$HOME/.config/fish/config.fish"
        )
        
        local found_path_entries=false
        for config in "${shell_configs[@]}"; do
            if [ -f "$config" ] && grep -q "$INSTALL_DIR" "$config" 2>/dev/null; then
                echo -e "${YELLOW}⚠️  Found PATH entry in: $config${NC}"
                echo "   You may want to manually remove lines containing: $INSTALL_DIR"
                found_path_entries=true
            fi
        done
        
        # Verify uninstallation
        echo ""
        echo -e "${BLUE}🔍 Verifying uninstallation...${NC}"
        
        if command -v git-workflow.sh >/dev/null 2>&1; then
            echo -e "${YELLOW}⚠️  git-workflow.sh still found in PATH${NC}"
            echo "   Location: $(which git-workflow.sh)"
            echo "   You may need to restart your terminal or remove it manually"
        else
            echo -e "${GREEN}✅ git-workflow.sh no longer in PATH${NC}"
        fi
        
        # Summary
        echo ""
        echo -e "${CYAN}📊 Uninstallation Summary${NC}"
        echo "========================"
        if [ $uninstalled_count -eq 0 ]; then
            echo -e "${YELLOW}⚠️  No Git Workflow Assistant files found to remove${NC}"
            echo "   The tool may not have been installed or was already removed"
        else
            echo -e "${GREEN}✅ Successfully removed $uninstalled_count file(s)${NC}"
        fi
        
        if [ "$found_path_entries" = true ]; then
            echo -e "${YELLOW}⚠️  Manual cleanup required for shell configuration files${NC}"
        fi
        
        echo ""
        echo -e "${GREEN}🎉 Git Workflow Assistant uninstallation complete!${NC}"
        echo ""
        echo "To verify removal, restart your terminal and run:"
        echo "  git-workflow.sh --version"
        echo "This should return 'command not found'"
        
        exit 0
        ;;
    --check-deps)
        echo -e "\033[0;34m🔍 Checking dependencies only...\033[0m"
        # We'll define check_requirements function below and call it
        ;;
    "")
        # No arguments - continue to main installation
        ;;
    *)
        echo -e "\033[0;31m❌ Unknown option: $1\033[0m"
        echo ""
        echo "Run '$0 --help' for usage information"
        echo ""
        echo "Or use remote installation:"
        echo "  curl -fsSL https://raw.githubusercontent.com/krishnaMohan2501/git-workflow-assistant/main/install.sh | bash"
        exit 1
        ;;
esac

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
REPO_URL="https://github.com/krishnaMohan2501/git-workflow-assistant"
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

# Handle --check-deps if it was the argument
if [ "${1:-}" = "--check-deps" ]; then
    check_requirements
    echo -e "${GREEN}✅ Dependency check complete${NC}"
    exit 0
fi

# Detect installation method preference
choose_installation_method() {
    log_step "Choose Installation Method"
    
    # Check if running in non-interactive mode (piped input)
    if [ ! -t 0 ]; then
        log_info "🤖 Non-interactive mode detected - using recommended method"
        log_info "📥 Downloading latest release..."
        install_from_release
        return
    fi
    
    echo "How would you like to install Git Workflow Assistant?"
    echo ""
    echo "1) 🌐 Download latest release (recommended)"
    echo "2) 📥 Clone from GitHub (for development)"
    echo "3) 📋 Local installation from current directory"
    echo ""
    
    # Use timeout to prevent hanging
    if command_exists timeout; then
        choice=$(timeout 30 bash -c 'read -p "Select method (1-3): " choice; echo $choice' 2>/dev/null || echo "1")
    else
        read -p "Select method (1-3): " choice
    fi
    
    # Default to 1 if no input or timeout
    choice=${choice:-1}
    
    case "$choice" in
        1) install_from_release ;;
        2) install_from_git ;;
        3) install_from_local ;;
        *) 
            log_warning "Invalid choice '$choice', using default (Download latest release)"
            install_from_release
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
    
    # Fix line endings (Windows CRLF → Unix LF)
    echo -e "${BLUE}Fixing line endings...${NC}"
    if command -v dos2unix >/dev/null 2>&1; then
        dos2unix "$INSTALL_DIR/git-workflow.sh" 2>/dev/null
    elif command -v sed >/dev/null 2>&1; then
        sed -i '' 's/\r$//' "$INSTALL_DIR/git-workflow.sh" 2>/dev/null || sed -i 's/\r$//' "$INSTALL_DIR/git-workflow.sh" 2>/dev/null
    elif command -v tr >/dev/null 2>&1; then
        tr -d '\r' < "$INSTALL_DIR/git-workflow.sh" > "$INSTALL_DIR/git-workflow.sh.tmp"
        mv "$INSTALL_DIR/git-workflow.sh.tmp" "$INSTALL_DIR/git-workflow.sh"
    fi
    
    # Make executable
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
    
    # Test installation with better line ending detection
    if "$INSTALL_DIR/git-workflow.sh" --version >/dev/null 2>&1; then
        log_success "✅ Installation successful!"
    elif echo 'exec: Failed to execute process' | grep -q "Windows line endings"; then
        log_warning "⚠️  Detected line ending issues, applying additional fixes..."
        # Additional line ending fixes for stubborn cases
        python3 -c "
import sys
with open('$INSTALL_DIR/git-workflow.sh', 'rb') as f:
    content = f.read()
content = content.replace(b'\r\n', b'\n').replace(b'\r', b'\n')
with open('$INSTALL_DIR/git-workflow.sh', 'wb') as f:
    f.write(content)
" 2>/dev/null || true
        chmod +x "$INSTALL_DIR/git-workflow.sh"
        
        # Test again
        if "$INSTALL_DIR/git-workflow.sh" --version >/dev/null 2>&1; then
            log_success "✅ Installation successful after line ending fix!"
        else
            log_warning "⚠️  Installation completed but script may have issues"
        fi
    else
        log_warning "⚠️  Installation completed but script may have issues"
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
        echo -e "${YELLOW}💡 Tip: Navigate to a Git repository to test the script!${NC}"
    else
        echo -e "${GREEN}🚀 You're in a Git repository - try running 'git-workflow.sh' now!${NC}"
    fi
}

# Main installation flow
main() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║              Git Workflow Assistant Installer            ║"
    echo "║                                                          ║"
    echo "║  🚀 AI-powered Git workflow automation                   ║"
    echo "║  🤖 Natural language git commands                        ║"
    echo "║  🔄 Intelligent branch management                        ║"
    echo "║  🛡️  Automatic conflict resolution                       ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    
    # Check if running as root
    if [ "$EUID" -eq 0 ]; then
        log_warning "Running as root is not recommended"
        log_info "The script will be installed for the current user only"
        read -p "Continue anyway? (y/N): " continue_root
        if [[ ! $continue_root =~ ^[Yy]$ ]]; then
            log_info "Installation cancelled"
            exit 0
        fi
    fi
    
    # Run installation steps
    check_requirements
    choose_installation_method
    test_installation
    show_post_install
    
    echo -e "${GREEN}🎉 Happy Git workflow automation!${NC}"
}

# Only run main if no arguments were provided (handled at the top)
if [ $# -eq 0 ]; then
    main
fi
