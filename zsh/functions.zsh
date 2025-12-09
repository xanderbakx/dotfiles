# ============================================================================
# NAVIGATION FUNCTIONS
# ============================================================================
# cd and list
cx() { cd "$@" && l; }

# Fuzzy cd
fcd() { cd "$(fd --type d --hidden --follow --exclude .git | fzf)" && l; }

# ============================================================================
# FILE OPERATIONS
# ============================================================================
# Fuzzy find file and copy to clipboard
f() { fd --type f --hidden --follow --exclude .git | fzf | pbcopy; }

# Fuzzy find and edit in nvim
fv() { nvim "$(fd --type f --hidden --follow --exclude .git | fzf)"; }

# ============================================================================
# WINDOW MANAGEMENT
# ============================================================================
# Fuzzy find aerospace spaces
ff() { aerospace list-windows --all | fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort' }