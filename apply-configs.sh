#!/bin/bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

usage() {
  echo "Usage: $0 [command]"
  echo ""
  echo "Commands:"
  echo "  brewfile          Install packages from Brewfile"
  echo ""
  echo "Note: Raycast import is disabled due to a bug in Raycast's import feature."
  echo "      Use update-configs.sh to export settings for backup purposes."
  echo ""
  exit 0
}

apply_brewfile() {
  echo ""
  echo "Which Brewfile do you want to install?"
  echo "  1) Brewfile (personal)"
  echo "  2) Brewfile.work (work)"
  echo ""
  read -p "Enter choice [1-2]: " choice
  
  local target
  case "$choice" in
    1) target="Brewfile" ;;
    2) target="Brewfile.work" ;;
    *) error "Invalid choice" ;;
  esac
  
  local file="$DOTFILES_DIR/$target"
  
  if [[ ! -f "$file" ]]; then
    error "$target not found"
  fi
  
  info "Installing packages from $target..."
  brew bundle install --file="$file"
  success "Packages installed from $target"
}

# NOTE: Raycast import is disabled due to a bug in Raycast v1.103+
# where importing a .rayconfig file always fails with "wrong format" error,
# even when exporting and importing on the same machine/version.
# The export in update-configs.sh still works for backup purposes.

main() {
  case "${1:-}" in
    brewfile)
      apply_brewfile
      ;;
    --help|-h|"")
      usage
      ;;
    *)
      error "Unknown command: $1"
      ;;
  esac
}

main "$@"

