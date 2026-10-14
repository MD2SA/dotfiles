#!/usr/bin/env bash
# Symlink dotfiles into place. Idempotent and non-destructive:
#   - never deletes real content without backing it up first
#   - skips links that already point to the right place
#   - supports DRY_RUN=1 to preview
#
# Run from anywhere; it resolves its own location.

set -euo pipefail

DOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.config/dotfiles.local/backups/$(date +%Y%m%d_%H%M%S)"
DRY_RUN="${DRY_RUN:-0}"

# Top-level repo entries that must NOT be linked into ~/.config.
IGNORE=(
    .git .gitignore .githooks
    README.md AGENTS.md
    startup plymouth-themes backup
    .nobackup dotfiles.local
)

is_ignored() {
    local name="$1" i
    for i in "${IGNORE[@]}"; do [[ "$name" == "$i" ]] && return 0; done
    return 1
}

link() {
    local src="$1" dst="$2"

    if [[ -L "$dst" && "$(readlink -f "$dst")" == "$(readlink -f "$src")" ]]; then
        return 0
    fi

    if [[ "$DRY_RUN" == 1 ]]; then
        echo "  would link: $src -> $dst"
        return 0
    fi

    if [[ -e "$dst" || -L "$dst" ]]; then
        mkdir -p "$BACKUP_DIR"
        mv "$dst" "$BACKUP_DIR/$(basename "$dst").$(date +%s)"
        echo "  backed up: $dst -> $BACKUP_DIR/"
    fi

    mkdir -p "$(dirname "$dst")"
    ln -sfn "$src" "$dst"
    echo "  linked: $src -> $dst"
}

link_themes() {
    local theme_dir base
    mkdir -p "$HOME/.config/omarchy/themes"
    for theme_dir in "$DOTDIR"/themes/*; do
        [[ -e "$theme_dir" ]] || continue
        base="$(basename "$theme_dir")"
        link "$theme_dir" "$HOME/.config/omarchy/themes/$base"
    done
}

echo "==> Linking configs (DOTDIR=$DOTDIR)"
shopt -s dotglob nullglob

for entry in "$DOTDIR"/*; do
    name="$(basename "$entry")"
    is_ignored "$name" && continue

    case "$name" in
        bin)
            link "$entry" "$HOME/.local/bin"
            # remove a stale ~/.config/bin symlink from older setups
            if [[ -L "$HOME/.config/bin" ]]; then
                if [[ "$DRY_RUN" == 1 ]]; then
                    echo "  would remove stale: ~/.config/bin"
                else
                    rm -f "$HOME/.config/bin"
                    echo "  removed stale: ~/.config/bin"
                fi
            fi
            ;;
        themes)
            link_themes
            ;;
        uwsm-default)
            link "$entry" "$HOME/.config/uwsm/default"
            ;;
        .bash*)
            link "$entry" "$HOME/$name"
            ;;
        *)
            link "$entry" "$HOME/.config/$name"
            ;;
    esac
done

shopt -u dotglob nullglob

# --- External repos -----------------------------------------------------------
NVIMDIR="$HOME/.config/nvim"
if [[ ! -d "$NVIMDIR/.git" ]]; then
    echo "==> Cloning nvim config"
    git clone "https://github.com/MD2SA/nvim" "$NVIMDIR"
else
    echo "==> Updating nvim config"
    git -C "$NVIMDIR" pull --ff-only || true
fi

echo "==> Config linking done."
