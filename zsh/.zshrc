# ============================================================================
# ZINIT SETUP
# ============================================================================
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Load annexes for gh-r support
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# ============================================================================
# PLUGINS - Using turbo mode for faster startup
# ============================================================================

# Fast syntax highlighting (faster than zsh-syntax-highlighting)
zinit lucid for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
    blockf \
    zsh-users/zsh-completions \
    atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

# fzf-tab
zinit light Aloxaf/fzf-tab

# OMZ snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

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
setopt HIST_IGNORE_DUPS
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
# COMPLETION
# ============================================================================
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'

# Use eza instead of ls in fzf-tab previews
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'

# ============================================================================
# FZF CONFIGURATION
# ============================================================================
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Better FZF colors (catppuccin mocha theme)
export FZF_DEFAULT_OPTS="
    --height 60%
    --layout=reverse
    --border
    --inline-info
    --preview-window='right:60%:wrap'
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# Load fzf (only once)
source <(fzf --zsh)

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
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && l; }

# Fuzzy find file and copy to clipboard
f() { echo "$(find . -type f -not -path '*/.*' | fzf)" | pbcopy }

# Fuzzy find and edit in nvim
fv() { nvim "$(find . -type f -not -path '*/.*' | fzf)" }

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
export PATH="/Users/xander/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/Users/xander/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

# Starship prompt
eval "$(starship init zsh)"

# Atuin (magical shell history)
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"
