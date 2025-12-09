# ============================================================================
# NEOVIM
# ============================================================================
alias v='nvim'
alias vi='nvim'
alias nv='nvim'
alias vimconfig='nvim ~/.config/nvim'
alias vzsh='nvim ~/.zshrc'

# ============================================================================
# EZA (better ls)
# ============================================================================
# Basic
alias ls='eza --icons --color=always'
alias l='eza --icons --color=always --long --git --all --group --group-directories-first'
alias lt='eza --icons --color=always --tree --level=2 --long --git'
alias ltree='eza --icons --color=always --tree --level=2 --long --git'
alias lsa='eza -lah --icons --git --color=always'        # all with hidden

# ============================================================================
# ZOXIDE (better cd)
# ============================================================================
alias cd='z'
alias zi='zi'      # interactive zoxide
alias zz='z -'     # go to previous directory

# ============================================================================
# BAT (better cat)
# ============================================================================
alias cat='bat'

# ============================================================================
# NAVIGATION
# ============================================================================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# Common directories
alias dl='cd ~/Downloads'
alias dt='cd ~/Desktop'
alias dv='cd ~/Developer'
alias doc='cd ~/Documents'
alias dev='cd ~/Developer'
alias dots='cd ~/dotfiles'
alias conf='cd ~/.config'

# ============================================================================
# UTILS
# ============================================================================
alias cl='clear'
alias pn='pnpm'
alias sail='./vendor/bin/sail'
