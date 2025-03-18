#!/bin/bash

# Set strict error handling
set -e

# Function to create directory structure
setup_dir() {
    local package=$1
    local target=$2
    
    # Create the directory if it doesn't exist
    mkdir -p "$package/$target"
    
    # If there are files in the package root, move them to the target
    find "$package" -maxdepth 1 -type f -exec mv {} "$package/$target/" \;
}

# Setup ghostty
if [ -d "ghostty" ]; then
    setup_dir "ghostty" ".config/ghostty"
fi

# Setup nvim
if [ -d "nvim" ]; then
    setup_dir "nvim" ".config/nvim"
fi

# Setup tmux
if [ -d "tmux" ]; then
    setup_dir "tmux" ".config/tmux"
fi

# zsh files should be in home directory, so we'll keep them as is
# but ensure they're in the correct structure for stow
if [ -d "zsh" ]; then
    # zsh files should be directly in the package root since they go to home
    :
fi

echo "Directory structure has been set up correctly for stow!" 