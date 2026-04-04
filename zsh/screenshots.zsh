export SCREENSHOTS_DIR="$HOME/Pictures/Screenshots"

get_lss() {
    local latest=($SCREENSHOTS_DIR/*.png(Nom[1]))
    
    if [[ -n "$latest" ]]; then
        echo "$latest"
    fi
}

alias -g lss='$(get_lss)'
