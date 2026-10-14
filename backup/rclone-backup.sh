#!/usr/bin/env bash
# One-way backup of important folders to Google Drive (rclone).
#
#   local -> drive   (rclone copy: additive, never deletes remote)
#
# Safe by design: a deleted/corrupted local file stays on Drive, so a lost PC
# still has everything. Run daily via backup/systemd/rclone-backup.timer.
#
# Excludes anything inside a directory containing a '.nobackup' marker, plus
# '.git' dirs (so ~/Documents/projects is skipped).
#
# No secrets here: the OAuth token lives in ~/.config/rclone/rclone.conf.

set -uo pipefail

REMOTE="${RCLONE_REMOTE:-drive}"
BASE="${RCLONE_BASE:-omarchy}"
LOGDIR="$HOME/.local/state/rclone-backup"
LOGFILE="$LOGDIR/backup-$(date +%Y%m%d).log"

FOLDERS=(Pictures Desktop Videos Documents)

mkdir -p "$LOGDIR"

if ! command -v rclone >/dev/null 2>&1; then
    echo "rclone not installed" >&2
    exit 1
fi

FLAGS=(
    --transfers 4
    --checkers 8
    --fast-list
    --stats-one-line
    --log-level INFO
    --log-file "$LOGFILE"
    --exclude-if-present .nobackup
    --exclude ".git/**"
)

notify() {
    local urgency="$1" title="$2" body="$3"
    if command -v omarchy-notification-send >/dev/null 2>&1; then
        omarchy-notification-send -u "$urgency" "$title" "$body" 2>/dev/null || true
    elif command -v notify-send >/dev/null 2>&1; then
        notify-send -u "$urgency" "$title" "$body" 2>/dev/null || true
    fi
}

fail=0
for folder in "${FOLDERS[@]}"; do
    src="$HOME/$folder"
    if [[ ! -d "$src" ]]; then
        echo "skip (missing): $src"
        continue
    fi
    echo "==> $folder -> $REMOTE:$BASE/$folder"
    if ! rclone copy "$src" "$REMOTE:$BASE/$folder" "${FLAGS[@]}"; then
        echo "ERROR backing up $folder" >&2
        fail=1
    fi
done

if [[ "$fail" -ne 0 ]]; then
    notify critical "Backup failed" "See $LOGFILE"
    exit 1
fi

notify low "Backup complete" "Google Drive up to date"
echo "==> Backup complete."
