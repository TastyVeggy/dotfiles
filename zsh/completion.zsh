export ZSH_COMPDUMP="$ZSH_CACHE_DIR/zcompdump"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
_comp_options+=(globdots)

zmodload zsh/complist

autoload -Uz compinit
compinit -d "$ZSH_COMPDUMP"
