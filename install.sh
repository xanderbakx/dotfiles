#!/bin/bash

# Set strict error handling
set -e

# Print colorful messages
print_message() {
    echo -e "\033[1;34m==>\033[0m \033[1m$1\033[0m"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Homebrew if not installed
if ! command_exists brew; then
    print_message "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    print_message "Homebrew already installed"
fi

# Install GNU stow if not already installed
if ! command_exists stow; then
    print_message "Installing GNU stow..."
    brew install stow
fi

# Update Homebrew and install all dependencies from Brewfile
print_message "Installing packages from Brewfile..."
brew bundle

# Create necessary directories if they don't exist
print_message "Creating necessary directories..."
mkdir -p ~/.config

# Stow all configuration directories
print_message "Setting up dotfiles..."
for dir in */ ; do
    if [ -d "$dir" ] && [ "$dir" != "." ] && [ "$dir" != ".." ] && [ "$dir" != ".git/" ]; then
        print_message "Stowing ${dir%/}..."
        stow -v -R -t $HOME "${dir%/}"
    fi
done

# Additional setup for specific tools
if command_exists nvim; then
    print_message "Setting up Neovim..."
    # Add any specific Neovim setup here if needed
fi

if command_exists tmux; then
    print_message "Setting up tmux..."
    # Install TPM (Tmux Plugin Manager) if it doesn't exist
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        git clone https://github.com/tmux-plugins/tpm $HOME/.local/bin/tmux/plugins/tpm
    fi
fi

print_message "Installation complete! 🎉"
print_message "Please restart your terminal for all changes to take effect." 