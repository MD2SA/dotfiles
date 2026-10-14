#!/usr/bin/env bash
# One-shot installer for a fresh Omarchy machine.
#
# Idempotent: safe to re-run. Clones the (public) repo if missing, links all
# configs, sets up SSH keys, validates the rclone remote and installs the
# backup systemd units. Interactive cleanup lives in startup/cleanup.sh.
#
# Usage:  bash startup/install.sh

set -euo pipefail

DOTDIR="$HOME/.config/dotfiles"
REPO_HTTPS="https://github.com/MD2SA/dotfiles"

if [[ ! -d "$DOTDIR/.git" ]]; then
    echo "==> Cloning dotfiles"
    mkdir -p "$(dirname "$DOTDIR")"
    git clone "$REPO_HTTPS" "$DOTDIR"
fi

cd "$DOTDIR"

# Enable the secret-scanning pre-commit guard (public repo).
git config core.hooksPath .githooks

if [[ "${DOTFILES_SKIP_PULL:-0}" != 1 ]]; then
    echo "==> Updating dotfiles"
    git pull --ff-only || echo "warning: could not pull, continuing"
fi

# vim -> nvim (best effort; needs sudo, ignored if unavailable)
if command -v nvim >/dev/null 2>&1; then
    sudo ln -sf "$(command -v nvim)" /usr/bin/vim 2>/dev/null || true
fi

echo "==> SSH keys"
source startup/ssh_setup.sh

echo "==> App configs"
source startup/config_setup.sh

echo "==> rclone remote"
source startup/rclone_setup.sh

echo "==> Backup units"
if [[ -f startup/backup_setup.sh ]]; then
    source startup/backup_setup.sh
fi

omarchy-restart-hyprctl 2>/dev/null || true
echo "==> Install complete. Run 'bash startup/cleanup.sh' to trim bloat."
