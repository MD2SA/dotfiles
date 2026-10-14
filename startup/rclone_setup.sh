#!/usr/bin/env bash
# Ensures an rclone 'drive:' remote exists. The real backup runs from
# backup/rclone-backup.sh via a systemd timer (see startup/backup_setup.sh).
#
# No secrets live in this repo: the OAuth token is written to
# ~/.config/rclone/rclone.conf, which is git-ignored.

set -euo pipefail

if ! command -v rclone >/dev/null 2>&1; then
    echo "rclone not installed; skipping (install with: sudo pacman -S rclone)"
    exit 0
fi

if ! rclone listremotes 2>/dev/null | grep -qx 'drive:'; then
    echo "==> No 'drive:' remote found; launching interactive setup."
    echo "    Name it 'drive', type 'drive', leave client_id/secret blank."
    rclone config
fi

if rclone listremotes 2>/dev/null | grep -qx 'drive:'; then
    echo "==> rclone 'drive:' remote OK"
    rclone about drive: >/dev/null 2>&1 || echo "warning: 'drive:' unreachable (check auth)"
else
    echo "warning: 'drive:' remote still missing; backups will not run"
fi
