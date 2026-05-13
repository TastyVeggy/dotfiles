setopt extendedglob

source_if() { [[ -f "$1" ]] && source "$1" }

source_if "$ZDOTDIR/completion.zsh"
source_if "$ZDOTDIR/vim_ctrls.zsh"
source_if "$ZDOTDIR/aliases.zsh"
source_if "$ZDOTDIR/functions.zsh"
source_if "$ZDOTDIR/screenshots.zsh"
source_if "$ZDOTDIR/school.zsh"
source_if "$ZDOTDIR/languages.zsh"
source_if "$ZDOTDIR/applications.zsh"

PROMPT="%~%F{green} 〉%f"
RPROMPT='%F{242}%D{%H:%M:%S}%f'

HISTFILE="$HOME/.cache/history"
HISTSIZE=1000
SAVEHIST=1000

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# distrobox stuff. MUST BE LAST CUZ HOME IS CHANGED
CONTAINER_DIR="$ZSH_DIR/containers"
if [[ -d "$CONTAINER_DIR" && -n "$CONTAINER_ID" ]]; then
    source_if "$CONTAINER_DIR/$CONTAINER_ID"
fi
