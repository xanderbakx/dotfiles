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
  echo "  brewfile          Update Brewfile from current machine's packages"
  echo "  raycast           Export Raycast config"
  echo "  all               Update all configs"
  echo ""
  exit 0
}

update_brewfile() {
  echo ""
  echo "Which Brewfile are you updating?"
  echo "  1) Brewfile (personal machine)"
  echo "  2) Brewfile.work (work machine)"
  echo ""
  read -p "Enter choice [1-2]: " choice
  
  local target
  case "$choice" in
    1) target="Brewfile" ;;
    2) target="Brewfile.work" ;;
    *) error "Invalid choice" ;;
  esac
  
  local file="$DOTFILES_DIR/$target"
  
  info "Dumping current Homebrew packages to $target..."
  
  # Create backup
  if [[ -f "$file" ]]; then
    cp "$file" "$file.backup"
    info "Backup created: $target.backup"
  fi
  
  # Dump current state
  brew bundle dump --file="$file" --force --describe
  
  success "Updated $target with current Homebrew packages"
  echo ""
  echo "Review changes with: git diff $target"
}

update_raycast() {
  local raycast_dir="$DOTFILES_DIR/raycast"
  local rayconfig="$raycast_dir/Raycast.rayconfig"
  local downloads_dir="$HOME/Downloads"
  
  info "Exporting Raycast configuration..."
  
  # Check if Raycast is installed
  if ! [[ -d "/Applications/Raycast.app" ]]; then
    error "Raycast is not installed"
  fi
  
  # Create backup
  if [[ -f "$rayconfig" ]]; then
    cp "$rayconfig" "$rayconfig.backup"
    info "Backup created: Raycast.rayconfig.backup"
  fi
  
  mkdir -p "$raycast_dir"
  
  echo ""
  echo "Export Raycast settings:"
  echo ""
  echo "  1. Open Raycast (⌘+Space)"
  echo "  2. Type 'Export Settings & Data'"
  echo "  3. Save to Downloads (default location)"
  echo ""
  
  read -p "Press Enter when done, or 'q' to skip: " response
  if [[ "$response" == "q" ]]; then
    warn "Skipped Raycast export"
    return
  fi
  
  # Find the most recent Raycast export in Downloads
  local latest_export
  latest_export=$(find "$downloads_dir" -maxdepth 1 -name "Raycast*.rayconfig" -type f -print0 2>/dev/null | xargs -0 ls -t 2>/dev/null | head -n1)
  
  if [[ -n "$latest_export" ]]; then
    mv "$latest_export" "$rayconfig"
    success "Moved $(basename "$latest_export") → Raycast.rayconfig"
  else
    warn "No Raycast export found in Downloads"
    echo "Looking for: $downloads_dir/Raycast*.rayconfig"
  fi
}

main() {
  case "${1:-}" in
    brewfile)
      update_brewfile
      ;;
    raycast)
      update_raycast
      ;;
    all)
      update_brewfile
      update_raycast
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

