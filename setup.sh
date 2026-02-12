#!/bin/bash

# Dotfiles Setup Script
# Usage: ./setup.sh

set -e

echo "🚀 Setting up dotfiles configuration..."
echo "================================"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}⚠${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1"; }
info() { echo -e "${BLUE}ℹ${NC} $1"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# Check OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Check if pacman is available (Arch Linux)
    if command -v pacman &> /dev/null; then
        PKG_MANAGER="sudo pacman -Syu --noconfirm"
        PKG_INSTALL="sudo pacman -S --noconfirm"
    else
        # Fallback to apt for other distros
        PKG_MANAGER="sudo apt update && sudo apt upgrade -y"
        PKG_INSTALL="sudo apt install -y"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    PKG_MANAGER="brew"
    PKG_INSTALL="brew install"
fi

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Function to backup and symlink
backup_and_symlink() {
    local src="$1"
    local dest="$2"
    local dest_dir=$(dirname "$dest")
    
    if [[ -e "$dest" ]]; then
        if [[ -L "$dest" ]]; then
            warn "Removing existing symlink: $dest"
            rm "$dest"
        else
            warn "Backing up: $dest → $BACKUP_DIR/"
            mv "$dest" "$BACKUP_DIR/"
        fi
    fi
    
    mkdir -p "$dest_dir"
    ln -sf "$src" "$dest"
    log "Linked: $src → $dest"
}

# Install Zsh configuration
install_zsh() {
    echo ""
    info "Installing Zsh configuration..."
    
    # Install dependencies
    if ! command -v zsh &> /dev/null; then
        log "Installing Zsh..."
        if command -v pacman &> /dev/null; then
            $PKG_INSTALL zsh curl git
        else
            $PKG_INSTALL zsh curl git
        fi
    else
        warn "Zsh already installed"
    fi
    
    # Install Oh My Zsh
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log "Installing Oh My Zsh..."
        RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        warn "Oh My Zsh already installed"
    fi
    
    # Install plugins
    local plugins_dir="$HOME/.oh-my-zsh/custom/plugins"
    mkdir -p "$plugins_dir"
    
    # Syntax highlighting
    if [[ ! -d "$plugins_dir/zsh-syntax-highlighting" ]]; then
        log "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$plugins_dir/zsh-syntax-highlighting"
    fi
    
    # Auto suggestions
    if [[ ! -d "$plugins_dir/zsh-autosuggestions" ]]; then
        log "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$plugins_dir/zsh-autosuggestions"
    fi
    
    # FZF plugin
    if [[ ! -d "$plugins_dir/fzf" ]]; then
        log "Installing fzf plugin..."
        git clone https://github.com/unixorn/fzf-zsh-plugin.git "$plugins_dir/fzf"
    fi
    
    # Install FZF
    if ! command -v fzf &> /dev/null; then
        log "Installing FZF..."
        if command -v pacman &> /dev/null; then
            $PKG_INSTALL fzf
        else
            $PKG_INSTALL fzf
        fi
    fi
    
    # Optional: fd for better file searching
    if command -v fd &> /dev/null; then
        warn "fd already installed (enhanced fzf file search)"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        log "Installing fd for better file search..."
        if command -v pacman &> /dev/null; then
            $PKG_INSTALL fd
        else
            $PKG_INSTALL fd-find
        fi
    fi
    
    # Link Zsh config
    backup_and_symlink "$SCRIPT_DIR/zsh/.zshrc" "$HOME/.zshrc"
    backup_and_symlink "$SCRIPT_DIR/zsh/custom/themes" "$HOME/.oh-my-zsh/custom/themes"
    
    # Set Zsh as default shell
    if [[ "$SHELL" != "$(which zsh)" ]]; then
        log "Setting Zsh as default shell..."
        chsh -s $(which zsh)
    else
        warn "Zsh is already the default shell"
    fi
}

# Future: install_zellij() { ... }
# Future: install_nvim() { ... }

# Main installation
main() {
    echo "Available configurations:"
    echo "1) zsh"
    echo "2) all"
    echo ""
    read -p "Choose what to install (1-2): " choice
    
    case $choice in
        1)
            install_zsh
            ;;
        2)
            install_zsh
            warn "More configurations coming soon (tmux, nvim, etc.)"
            ;;
        *)
            error "Invalid choice"
            exit 1
            ;;
    esac
    
    echo ""
    echo "🎉 Installation complete!"
    echo "================================"
    echo "📋 What's been configured:"
    
    if [[ "$choice" == "1" || "$choice" == "2" ]]; then
        echo "   • Zsh with Oh My Zsh"
        echo "   • Custom themes and plugins"
        echo "   • FZF integration"
    fi
    
    echo ""
    echo "🚀 To start using:"
    echo "   exec zsh"
    echo ""
    echo "💡 Backup location: $BACKUP_DIR"
    echo "📖 Check README.md for more details"
}

# Run main function
main "$@"
