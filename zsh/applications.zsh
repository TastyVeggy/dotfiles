eval "$(fzf --zsh)" # Set up fzf key bindings and fuzzy completion
export FZF_DEFAULT_OPTS="--ignore-case"
export FZF_ALT_C_COMMAND='fd --type d --hidden --strip-cwd-prefix'
export FZF_CTRL_T_COMMAND='fd --hidden --strip-cwd-prefix'
