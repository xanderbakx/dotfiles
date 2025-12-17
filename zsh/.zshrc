# ============================================================================
# HOMEBREW SETUP
# ============================================================================
setup_homebrew() {
  # Detect architecture
  if [[ "$(uname -m)" == "arm64" ]]; then
    BREW_PREFIX="/opt/homebrew"
  else
    BREW_PREFIX="/usr/local"
  fi

  # Only run if Brew exists
  if [[ -x "$BREW_PREFIX/bin/brew" ]]; then
    eval "$($BREW_PREFIX/bin/brew shellenv)"
  fi
}

setup_homebrew

# ============================================================================
# HISTORY (minimal - Atuin handles most)
# ============================================================================
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt HIST_IGNORE_SPACE

# ============================================================================
# ZSH OPTIONS
# ============================================================================
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt EXTENDED_GLOB
setopt GLOB_DOTS

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="bat"

# Starship config location
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# FZF configuration
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# Disable Alt+C binding (conflicts with AeroSpace)
export FZF_ALT_C_OPTS="--disabled"

# FZF colors (catppuccin mocha theme)
export FZF_DEFAULT_OPTS="
  --height 60%
  --layout=reverse
  --border
  --inline-info
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# ============================================================================
# COMPLETIONS
# ============================================================================
# Load and initialise completion system
autoload -Uz compinit
compinit

# ============================================================================
# FZF-TAB
# ============================================================================
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# Show hidden files in completion
zstyle ':completion:*' file-patterns '%p(D):all-files'
# preview directory's content with eza when completing zoxide
zstyle ':fzf-tab:complete:z*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:(cd|nvim)*' fzf-preview 'eza -1 -a --color=always $realpath'
# custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
# zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2
# # To make fzf-tab follow FZF_DEFAULT_OPTS.
# # NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
# zstyle ':fzf-tab:*' use-fzf-default-opts yes

# ============================================================================
# SHELDON (plugin manager)
# ============================================================================
eval "$(sheldon source)"

# ============================================================================
# TOOL INITIALIZATION
# ============================================================================

# FZF key bindings and fuzzy completion
eval "$(fzf --zsh)"

# Zoxide (better cd)
eval "$(zoxide init zsh)"

# Atuin (magical shell history)
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

# FNM (replacement for NVM)
eval "$(fnm env --use-on-cd --shell zsh)" 

# ============================================================================
# ALIASES & FUNCTIONS
# ============================================================================
if [[ -f ~/.config/zsh/aliases.zsh ]]; then
  source ~/.config/zsh/aliases.zsh
else
  echo "Warning: ~/.config/zsh/aliases.zsh not found"
fi

if [[ -f ~/.config/zsh/functions.zsh ]]; then
  source ~/.config/zsh/functions.zsh
else
  echo "Warning: ~/.config/zsh/functions.zsh not found"
fi

# ============================================================================
# LOCAL CONFIG (machine-specific, not in git)
# ============================================================================
# Source ~/.zshrc.local if it exists (for work-specific config, etc.)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# ============================================================================
# STARSHIP (prompt - load last)
# ============================================================================
eval "$(starship init zsh)"
