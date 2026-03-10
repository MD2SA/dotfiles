#!/usr/bin/env bash

set -e
shopt -s dotglob nullglob


mkdir -p "$HOME/.config"
DOTDIR="$HOME/.config/dotfiles"

IGNORE_DIRS=(
    ".git"
    ".gitignore"
    "startup"
    "plymouth-themes"
)

dotfiles=("$DOTDIR"/*)
if [ ${#dotfiles[@]} -eq 0 ]; then
    # if ssh fails try https
    git clone "git@github.com/MD2SA/dotfiles" "$DOTDIR" || \
    git clone "https://github.com/MD2SA/dotfiles" "$DOTDIR"
else
    git -C "$DOTDIR" pull --rebase
fi

for file in "$DOTDIR"/*; do
    name="$(basename "$file")"

    # skip ignore dirs/files
    skip=false
    for ignored in "${IGNORE_DIRS[@]}"; do
        if [[ "$name" == "$ignored" ]]; then
            skip=true
            break
        fi
    done
    $skip && continue

    if [[ "$name" == "bin" ]]; then
        target="$HOME/.local/bin"
    elif [[ "$name" == .bash* ]]; then
        target="$HOME/$name"
    else
        target="$HOME/.config/$name"
    fi

    if [ -L "$target" ] || [ -d "$target" ]; then
        rm -rf "$target"
    fi

    ln -sf "$file" "$target"
done


NVIMDIR="$HOME/.config/nvim"
if [ ${#NVIMDIR[@]} -eq 0 ]; then
    git clone "https://github.com/MD2SA/nvim" "$NVIMDIR"
else
    git -C "$NVIMDIR" pull
fi

shopt -u dotglob nullglob

# NEXT STEPS
#
# DELETE CRAP and config crap
# MAKE a manas restart script that calls all omarchy-restart-scripts
