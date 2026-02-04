#!/bin/bash
# Switch aerospace config based on connected monitors.
# Only toggles default layout (accordion vs tiles).

DOTFILES_DIR="$HOME/dotfiles/aerospace"
AEROSPACE_CONFIG="$HOME/.config/aerospace/aerospace.toml"

# Detect monitor
if aerospace list-monitors 2>/dev/null | grep -qi "MSI MAG401QR"; then
  LAYOUT="tiles"
  echo "Ultrawide monitor detected"
else
  LAYOUT="accordion"
  echo "Laptop display detected"
fi

mkdir -p "$HOME/.config/aerospace"

# Build combined config (base config with layout substitution)
COMBINED="$(sed "s/LAYOUT_PLACEHOLDER/$LAYOUT/" "$DOTFILES_DIR/aerospace-base.toml")"

# Only update if config is different
if [[ "$COMBINED" != "$(cat "$AEROSPACE_CONFIG" 2>/dev/null)" ]]; then
  echo "$COMBINED" >"$AEROSPACE_CONFIG"
  aerospace reload-config
  echo "Config switched and reloaded"
else
  echo "Config already up to date"
fi
