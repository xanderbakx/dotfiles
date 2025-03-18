#!/bin/bash

# Set strict error handling
set -e
set -o pipefail

# Log file setup
LOGFILE="$HOME/.dotfiles_install.log"
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')

# Print colorful messages
print_message() {
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1"
    echo -e "\033[1;34m==>\033[0m \033[1m$1\033[0m"
    echo "$msg" >> "$LOGFILE"
}

print_error() {
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1"
    echo -e "\033[1;31m==>\033[0m \033[1m$1\033[0m" >&2
    echo "$msg" >> "$LOGFILE"
}

print_warning() {
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] [WARNING] $1"
    echo -e "\033[1;33m==>\033[0m \033[1m$1\033[0m"
    echo "$msg" >> "$LOGFILE"
}

# Error handler
handle_error() {
    local line_num=$1
    local error_code=$2
    print_error "Error occurred in script at line $line_num (Error code: $error_code)"
    print_error "Check the log file at $LOGFILE for more details"
    exit 1
}

# Set up error handling
trap 'handle_error ${LINENO} $?' ERR

# Initialize log file
echo "=== Dotfiles Installation Log - $TIMESTAMP ===" > "$LOGFILE"
print_message "Starting installation..."
print_message "Log file created at $LOGFILE"

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Select configuration type
select_config() {
    echo "Please select your configuration type:"
    echo "1) Personal"
    echo "2) Work"
    read -p "Enter your choice (1/2): " choice
    
    case $choice in
        1)
            print_message "Selected personal configuration"
            BREWFILE="Brewfile"
            IS_WORK=false
            ;;
        2)
            print_message "Selected work configuration"
            BREWFILE="Brewfile.work"
            IS_WORK=true
            ;;
        *)
            print_error "Invalid choice. Please select 1 for Personal or 2 for Work."
            exit 1
            ;;
    esac
}

# Verify system requirements
check_system() {
    print_message "Checking system requirements..."
    
    # Check OS
    if [[ "$(uname)" != "Darwin" ]]; then
        print_error "This script is only supported on macOS"
        exit 1
    fi
    
    # Check if Git is installed
    if ! command_exists git; then
        print_error "Git is required but not installed"
        exit 1
    fi
    
    print_message "System requirements met"
}

# Run the configuration selection
select_config
check_system

# Detect system architecture and set Homebrew paths
ARCH="$(uname -m)"
print_message "Detected architecture: $ARCH"

if [[ "${ARCH}" == "arm64" ]]; then
    HOMEBREW_PREFIX="/opt/homebrew"
    HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}"
    HOMEBREW_SHELLENV="${HOMEBREW_PREFIX}/bin/brew shellenv"
    print_message "Configuring for Apple Silicon Mac"
else
    HOMEBREW_PREFIX="/usr/local"
    HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew"
    HOMEBREW_SHELLENV="${HOMEBREW_PREFIX}/bin/brew shellenv"
    print_message "Configuring for Intel Mac"
fi

# Install Homebrew if not installed
if ! command_exists brew; then
    print_message "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
        print_error "Failed to install Homebrew"
        exit 1
    }
    
    # Add Homebrew to PATH based on architecture
    if [[ ! -f "$HOME/.zshrc" ]] || ! grep -q "brew shellenv" "$HOME/.zshrc"; then
        print_message "Setting up Homebrew PATH in .zshrc"
        if [[ "${ARCH}" == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zshrc"
        else
            echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "$HOME/.zshrc"
        fi
    fi
    eval "$($HOMEBREW_SHELLENV)"
else
    print_message "Homebrew already installed"
fi

# Ensure Homebrew is in PATH for the rest of the script
eval "$($HOMEBREW_SHELLENV)"

# Install GNU stow if not already installed
if ! command_exists stow; then
    print_message "Installing GNU stow..."
    brew install stow || {
        print_error "Failed to install GNU stow"
        exit 1
    }
fi

# Check if selected Brewfile exists
if [ ! -f "$BREWFILE" ]; then
    print_error "Could not find $BREWFILE. Please ensure it exists in the current directory."
    exit 1
fi

# Update Homebrew and install all dependencies from selected Brewfile
print_message "Installing packages from $BREWFILE..."
print_message "Updating Homebrew..."
brew update || print_warning "Homebrew update failed, continuing with installation"

print_message "Installing packages from $BREWFILE..."
brew bundle --file="$BREWFILE" || {
    print_error "Failed to install some packages from $BREWFILE"
    print_error "Please check the log file for details"
    exit 1
}

# Create necessary directories if they don't exist
print_message "Creating necessary directories..."
mkdir -p ~/.config
mkdir -p ~/.local/bin
mkdir -p ~/.local/share

# Set up correct directory structure for stow
print_message "Setting up directory structure..."
if [ -f "./setup_dirs.sh" ]; then
    ./setup_dirs.sh || {
        print_error "Failed to set up directory structure"
        exit 1
    }
else
    print_error "setup_dirs.sh not found"
    exit 1
fi

# Stow all configuration directories
print_message "Setting up dotfiles..."
for dir in */ ; do
    if [ -d "$dir" ] && [ "$dir" != "." ] && [ "$dir" != ".." ] && [ "$dir" != ".git/" ]; then
        print_message "Stowing ${dir%/}..."
        stow -v -R --no-folding -t $HOME "${dir%/}" || {
            print_error "Failed to stow ${dir%/}"
            exit 1
        }
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
    mkdir -p "$HOME/.config/tmux/plugins"
    if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
        print_message "Installing Tmux Plugin Manager..."
        git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm" || {
            print_warning "Failed to install Tmux Plugin Manager"
        }
    fi
fi

# Apply macOS settings only for personal configuration
if [ "$IS_WORK" = false ] && [ -f "./macos/.macos" ]; then
    print_message "Applying personal macOS settings..."
    ./macos/.macos || {
        print_warning "Failed to apply some macOS settings"
    }
else
    if [ "$IS_WORK" = true ]; then
        print_message "Skipping macOS settings for work configuration"
    else
        print_warning "macOS settings script not found at ./macos/.macos"
    fi
fi

print_message "Installation complete! 🎉"
print_message "Log file available at: $LOGFILE"
print_message "Please restart your terminal for all changes to take effect." 