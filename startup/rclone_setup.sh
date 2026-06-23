#!/usr/bin/env bash

# A SCRIPT TO BE ONLY RUN ON THE STARTUP

BISYNC_DIR="$HOME/.cache/rclone/bisync"
rclone config

rclone bisync "$HOME/Pictures" "drive:omarchy/Pictures" --resync -P
rclone bisync "$HOME/Documents" "drive:omarchy/Documents" --resync -P \
    --exclude-if-present ".nobackup" \
    --exclude-if-present ".git"
