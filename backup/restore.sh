#!/usr/bin/env bash
# Restore folders from Google Drive onto a new machine.
#   local <- drive   (rclone copy)
#
# Usage: bash backup/restore.sh [folder...]   (default: all)

set -euo pipefail

REMOTE="${RCLONE_REMOTE:-drive}"
BASE="${RCLONE_BASE:-omarchy}"

FOLDERS=("$@")
if [[ ${#FOLDERS[@]} -eq 0 ]]; then
    FOLDERS=(Pictures Desktop Videos Documents)
fi

for folder in "${FOLDERS[@]}"; do
    echo "==> restoring $folder"
    mkdir -p "$HOME/$folder"
    rclone copy "$REMOTE:$BASE/$folder" "$HOME/$folder" --progress
done

echo "==> Restore complete."
