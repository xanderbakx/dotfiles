#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE=""

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

usage() {
  echo "Usage: $0 [--personal|--work]"
  echo ""
  echo "Options:"
  echo "  --personal    Install personal Brewfile packages"
  echo "  --work        Install work Brewfile packages"
  echo "  (no option)   Interactive prompt to choose"
  exit 0
}

select_profile() {
  # Check for command line argument
  case "${1:-}" in
    --personal) PROFILE="personal"; return ;;
    --work) PROFILE="work"; return ;;
    --help|-h) usage ;;
    "") ;; # No argument, will prompt
    *) error "Unknown option: $1. Use --help for usage." ;;
  esac
  
  # Interactive selection
  echo ""
  echo "Select installation profile:"
  echo "  1) Personal"
  echo "  2) Work"
  echo ""
  read -p "Enter choice [1-2]: " choice
  
  case "$choice" in
    1) PROFILE="personal" ;;
    2) PROFILE="work" ;;
    *) error "Invalid choice" ;;
  esac
}

# ==============================================================================
# Xcode Command Line Tools
# ==============================================================================
install_xcode_cli() {
  if ! xcode-select -p &>/dev/null; then
    info "Installing Xcode Command Line Tools..."
    xcode-select --install
    # Wait for installation
    until xcode-select -p &>/dev/null; do
      sleep 5
    done
    success "Xcode CLI tools installed"
  else
    success "Xcode CLI tools already installed"
  fi
}

# ==============================================================================
# Homebrew
# ==============================================================================
install_homebrew() {
  if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add to path for this session
    if [[ "$(uname -m)" == "arm64" ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    else
      eval "$(/usr/local/bin/brew shellenv)"
    fi
    success "Homebrew installed"
  else
    success "Homebrew already installed"
  fi
}

install_brew_packages() {
  local brewfile="$DOTFILES_DIR/Brewfile"
  if [[ "$PROFILE" == "work" ]]; then
    brewfile="$DOTFILES_DIR/Brewfile.work"
  fi
  
  info "Installing Homebrew packages from $(basename "$brewfile")..."
  brew bundle --file="$brewfile"
  success "Homebrew packages installed ($PROFILE profile)"
}

# ==============================================================================
# Backup & Stow
# ==============================================================================
backup_existing() {
  local backup_dir="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
  local files_to_backup=(
    "$HOME/.zshrc"
    "$HOME/.zshenv"
    "$HOME/.config/nvim"
    "$HOME/.config/tmux"
    "$HOME/.config/ghostty"
    "$HOME/.config/aerospace"
    "$HOME/.config/atuin"
    "$HOME/.config/sketchybar"
    "$HOME/.config/starship"
  )
  
  local needs_backup=false
  for file in "${files_to_backup[@]}"; do
    if [[ -e "$file" && ! -L "$file" ]]; then
      needs_backup=true
      break
    fi
  done
  
  if $needs_backup; then
    info "Backing up existing dotfiles to $backup_dir..."
    mkdir -p "$backup_dir"
    for file in "${files_to_backup[@]}"; do
      if [[ -e "$file" && ! -L "$file" ]]; then
        mv "$file" "$backup_dir/"
        warn "Backed up $(basename "$file")"
      fi
    done
    success "Backup complete"
  else
    success "No existing files to backup"
  fi
}

stow_dotfiles() {
  info "Stowing dotfiles..."
  cd "$DOTFILES_DIR"
  
  # Create ~/.config if it doesn't exist
  mkdir -p "$HOME/.config"
  
  # Packages that go to ~/.config (uses default target from .stowrc)
  stow --restow aerospace atuin ghostty nvim sketchybar starship tmux
  
  # Packages that go to ~/ (override default target)
  stow --restow -t ~ --ignore='.zcompdump' zsh zshenv
  
  success "Dotfiles stowed"
}

# ==============================================================================
# Post-install Setup
# ==============================================================================
install_tmux_plugins() {
  local tpm_path="$HOME/.config/tmux/plugins/tpm"
  if [[ ! -d "$tpm_path" ]]; then
    info "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$tpm_path"
    success "TPM installed"
  else
    success "TPM already installed"
  fi
  
  # Install tmux plugins
  if [[ -f "$tpm_path/bin/install_plugins" ]]; then
    info "Installing tmux plugins..."
    "$tpm_path/bin/install_plugins"
    success "Tmux plugins installed"
  fi
}

install_zinit() {
  local zinit_path="$HOME/.local/share/zinit/zinit.git"
  if [[ ! -d "$zinit_path" ]]; then
    info "Installing Zinit..."
    mkdir -p "$(dirname "$zinit_path")"
    git clone https://github.com/zdharma-continuum/zinit "$zinit_path"
    success "Zinit installed"
  else
    success "Zinit already installed"
  fi
}

install_atuin() {
  if [[ ! -d "$HOME/.atuin" ]]; then
    info "Installing Atuin..."
    curl -fsSL https://setup.atuin.sh | bash
    success "Atuin installed"
  else
    success "Atuin already installed"
  fi
}

# ==============================================================================
# Main
# ==============================================================================
main() {
  select_profile "$1"
  
  echo ""
  echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║       Dotfiles Installation            ║${NC}"
  echo -e "${BLUE}║       Profile: ${PROFILE}                      ║${NC}"
  echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
  echo ""
  
  install_xcode_cli
  install_homebrew
  install_brew_packages
  backup_existing
  stow_dotfiles
  install_tmux_plugins
  install_zinit
  install_atuin
  
  echo ""
  echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║       Installation Complete!           ║${NC}"
  echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
  echo ""
  echo "Next steps:"
  echo "  1. Restart your terminal or run: exec zsh"
  echo "  2. Open tmux and press prefix + I to finish plugin setup"
  echo ""
}

main "$@"
