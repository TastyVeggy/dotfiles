open() {
    zathura $1 & disown
}

rn_lss() {
  local latest=$(ls -t ~/Pictures/Screenshots/*.png 2>/dev/null | head -n 1)
  
  if [[ -n "$latest" ]]; then
    mv "$latest" "$HOME/Pictures/Screenshots/$1.png"
    echo "Renamed latest screenshot to: $1.png"
  else
    echo "No screenshots found."
  fi
}
