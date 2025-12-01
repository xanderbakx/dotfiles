# Homebrew
if [[ "$(uname -m)" == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Set ZDOTDIR if not already set
export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"
echo "CONFIG ZSHENV LOADED"
