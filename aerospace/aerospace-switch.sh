#!/bin/bash
# Switch aerospace config based on connected monitors
# Combines base config with monitor-specific window rules

DOTFILES_DIR="$HOME/dotfiles/aerospace"
AEROSPACE_CONFIG="$HOME/.config/aerospace/aerospace.toml"
BASE_CONFIG="$DOTFILES_DIR/aerospace-base.toml"

# Check if CF791 ultrawide is connected
if aerospace list-monitors 2>/dev/null | grep -qi "CF791"; then
    WINDOWS_CONFIG="$DOTFILES_DIR/aerospace-ultrawide.toml"
    echo "CF791 ultrawide detected"
else
    WINDOWS_CONFIG="$DOTFILES_DIR/aerospace-laptop.toml"
    echo "No ultrawide detected - using laptop config"
fi

# Build combined config
COMBINED=$(cat "$BASE_CONFIG"; echo ""; cat "$WINDOWS_CONFIG")

# Only update if config is different
if [ "$COMBINED" != "$(cat "$AEROSPACE_CONFIG" 2>/dev/null)" ]; then
    echo "$COMBINED" > "$AEROSPACE_CONFIG"
    aerospace reload-config
    echo "Config switched and reloaded"
else
    echo "Config already up to date"
fi

