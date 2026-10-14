#!/usr/bin/env bash
# Install / refresh the rclone backup systemd user units and enable the timer.

set -euo pipefail

DOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UNITDIR="$HOME/.config/systemd/user"
mkdir -p "$UNITDIR"

for unit in rclone-backup.service rclone-backup.timer; do
    ln -sfn "$DOTDIR/backup/systemd/$unit" "$UNITDIR/$unit"
    echo "  linked: $UNITDIR/$unit"
done

systemctl --user daemon-reload
systemctl --user enable --now rclone-backup.timer
echo "==> Backup timer enabled:"
systemctl --user list-timers rclone-backup.timer --no-pager || true
