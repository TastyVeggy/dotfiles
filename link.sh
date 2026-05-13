#!/usr/bin/env bash

set -e

DOTFILES="$HOME/.config"

ln -sf "$DOTFILES/zsh/.zshenv" "$HOME/.zshenv"
ln -sf "$DOTFILES/x11/xinitrc" "$HOME/.xinitrc"
ln -sf "$DOTFILES/themes" "$HOME/.themes"

echo "Done linking"
