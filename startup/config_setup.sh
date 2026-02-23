#!/usr/bin/env bash

set -e
shopt -s dotglob nullglob


mkdir -p "$HOME/.config"
DOTDIR="$HOME/.config/dotfiles"

# User does not have git credentials stored yet
if [[ ! -f "$HOME/.git-credentials" && ! -f "$HOME/.config/git/credentials" ]]; then
    git config --global credential.helper store

	# Opening tokens page for auth
	if command -v xdg-open >/dev/null 2>&1; then
		xdg-open "https://github.com/settings/tokens" >/dev/null 2>&1 &
	elif command -v open >/dev/null 2>&1; then
		open "https://github.com/settings/tokens" >/dev/null 2>&1 &
	fi
fi

dotfiles=("$DOTDIR"/*)
if [ ${#dotfiles[@]} -eq 0 ]; then
    git clone "https://github.com/MD2SA/dotfiles" "$DOTDIR"
else
    git -C "$DOTDIR" pull
fi

for file in "$DOTDIR"/*; do
    name="$(basename "$file")"

    [[ "$name" == .git* || "$name" == startup ]] && continue

    if [[ "$name" == .bash* ]]; then
        target="$HOME/$name"
    else
        target="$HOME/.config/$name"
    fi

    if [ -L "$target" ] || [ -d "$target" ]; then
        rm -rf "$target"
    fi

    ln -sf "$file" "$target"
done


# Note to future: make nvim a submodule of dotfiles
rm -rf "$HOME/.config/nvim"
git clone "https://github.com/MD2SA/nvim" "$HOME/.config/nvim"

shopt -u dotglob nullglob

# NEXT STEPS
#
# DELETE CRAP and config crap
# MAKE a manas restart script that calls all omarchy-restart-scripts
