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
# COMPLETION SYSTEM
# ============================================================================
autoload -Uz compinit
compinit

# ============================================================================
# CARAPACE
# ============================================================================
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

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
setopt GLOB_DOTS

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================
# FZF
#export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow \
#  --exclude .git \
#  --exclude node_modules \
#  --exclude .cache \
#  --exclude .vite
#  --exclude dist \
#  --exclude .DS_Store'
#export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
#export FZF_ALT_C_COMMAND='fd --type d --hidden --follow \
#  --exclude .git \
#  --exclude node_modules \
#  --exclude .cache \
#  --exclude .vite \
#  --exclude dist'
#
## FZF Styles
#export FZF_DEFAULT_OPTS='
#    --height 60%
#    --layout=reverse
#    --border
#    --info=inline
#    --preview-window=right:60%:border-left
#    --preview "if [ -d {} ]; then eza -la --icons --git --color=always {}; \
#        elif command -v bat >/dev/null 2>&1; then bat --style=plain --color=always {}; \
#        else cat {}; fi"
#    --color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8
#    --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC
#    --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8
#    --color=selected-bg:#45475A
#    --color=border:#6C7086,label:#CDD6F4'

# Herd
export PATH="$HOME/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="$HOME/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

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
# PLUGINS
# ============================================================================
# Load OMZ immediately (not turbo)
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# Load fzf-tab without wait (so it loads before completion zstyles)
zinit lucid wait for \
  Aloxaf/fzf-tab

# Load other plugins with turbo mode
zinit wait lucid for \
 atinit"zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

# ============================================================================
# COMPLETION
# ============================================================================
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

#zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Show hidden files in completion
#_comp_options+=(globdots)
#zstyle ':completion:*' file-patterns '%p(D):globbed-files' '*:all-files'
#
#zstyle ':fzf-tab:*' use-fzf-default-opts yes

# Use eza instead of ls in fzf-tab previews
#zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -la $realpath'
#zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always ${~realpath}'

# disable sort when completing `git checkout`
#zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
#zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
#zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
#zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
#zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
#zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
#zstyle ':fzf-tab:*' switch-group '<' '>'

# ============================================================================
# FZF (load after zinit plugins)
# ============================================================================
source <(fzf --zsh)

# ============================================================================
# ALIASES
# ============================================================================
# Eza (better ls)
alias ls='eza --icons --color=always'
alias l='eza -l --icons --git -a --color=always'
alias ll='eza -l --icons --git --color=always'
alias lt='eza --tree --level=2 --long --icons --git --color=always'
alias ltree='eza --tree --level=2 --icons --git --color=always'

# Zoxide (better cd)
alias cd='z'

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
# INTEGRATIONS
# ============================================================================
# Zoxide (smarter cd)
eval "$(zoxide init zsh)"

# Starship prompt
eval "$(starship init zsh)"

# Atuin (magical shell history)
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

# FNM (replacement for NVM)
eval "$(fnm env --use-on-cd --shell zsh)" 

# ============================================================================
# LOCAL CONFIG (machine-specific, not in git)
# ============================================================================
# Source ~/.zshrc.local if it exists (for work-specific config, etc.)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

