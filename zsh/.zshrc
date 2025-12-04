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
# HISTORY
# ============================================================================
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY          # Write timestamp
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_VERIFY               # Don't execute immediately on history expansion

# ============================================================================
# ZSH OPTIONS
# ============================================================================
setopt AUTO_CD
setopt AUTO_PUSHD                # cd pushes old dir onto stack
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt CORRECT                   # Spelling correction
setopt EXTENDED_GLOB             # Extended globbing
setopt NO_CASE_GLOB              # Case insensitive globbing


# ============================================================================
# FZF CONFIGURATION
# ============================================================================
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Better FZF colors (catppuccin mocha theme)
export FZF_DEFAULT_OPTS=" \
    --height 60% \
    --layout=reverse \
    --border \
    --inline-info \
    --preview-window='right:60%:wrap' \
    --color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
    --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
    --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
    --color=selected-bg:#45475A \
    --color=border:#6C7086,label:#CDD6F4"

# Load fzf (only once)
source <(fzf --zsh)

# ============================================================================
# COMPLETION SYSTEM (must be before carapace)
# ============================================================================
autoload -Uz compinit
compinit

# ============================================================================
# CARAPACE
# ============================================================================
source <(carapace _carapace)

# ============================================================================
# ALIASES
# ============================================================================
# Eza (better ls)
alias ls='eza --icons'
alias l='eza -l --icons --git -a'
alias ll='eza -l --icons --git'
alias la='eza -la --icons --git'
alias lt='eza --tree --level=2 --long --icons --git'
alias ltree='eza --tree --level=2 --icons --git'

# Utils
alias v='nvim'
alias c='clear'
alias cat='bat'
alias pn='pnpm'
alias sail='./vendor/bin/sail'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias dl='cd ~/Downloads'
alias dt='cd ~/Desktop'
alias dv='cd ~/Developer/'

# ============================================================================
# FUNCTIONS
# ============================================================================
# cd and list
cx() { cd "$@" && l; }

# Fuzzy cd
fcd() { cd "$(fd --type d --hidden --follow --exclude .git | fzf)" && l; }

# Fuzzy find file and copy to clipboard
f() { fd --type f --hidden --follow --exclude .git | fzf | pbcopy; }

# Fuzzy find and edit in nvim
fv() { nvim "$(fd --type f --hidden --follow --exclude .git | fzf)"; }

# Fuzzy find aerospace spaces
ff() { aerospace list-windows --all | fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort' }

# ============================================================================
# KEY BINDINGS
# ============================================================================
bindkey -e  # Emacs mode
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# ============================================================================
# INTEGRATIONS
# ============================================================================
# Zoxide (smarter cd)
eval "$(zoxide init zsh)"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Herd
export PATH="$HOME/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="$HOME/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

# Starship prompt
eval "$(starship init zsh)"

# Atuin (magical shell history)
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

# ============================================================================
# ZINIT INSTALLER 
# ============================================================================
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

# Register zinit's own completion
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# ============================================================================
# COMPLETION
# ============================================================================
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'

# Show hidden files in completion
setopt globdots

# Use eza instead of ls in fzf-tab previews
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'

# ============================================================================
# PLUGINS
# ============================================================================

# Load OMZ git lib (defines git_current_branch function) and plugin (aliases)
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git

# Load other plugins with turbo mode
zinit wait lucid light-mode for \
  atinit"zicdreplay" \
      zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions \
      Aloxaf/fzf-tab \
      OMZP::sudo \
      OMZP::command-not-found

