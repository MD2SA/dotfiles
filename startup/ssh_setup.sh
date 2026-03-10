#!/usr/bin/env bash
# Sets up SSH keys and config entries for multiple GitHub profiles.
# Each profile gets a dedicated ed25519 key and a Host block in ~/.ssh/config.

set -euo pipefail

# -- Constants ----------------------------------------------------------------
SSH_DIR="$HOME/.ssh"
CONFIG_FILE="$SSH_DIR/config"

PROFILES=(
    # Format: "name:email"
    "personal:albuquerque2158@gmail.com"
    "iscte:mssae@iscte-iul.pt"
)

# -- Setup ---------------------------------------------------------------------
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"
touch "$CONFIG_FILE"
chmod 600 "$CONFIG_FILE"

# -- Functions -----------------------------------------------------------------

# Generates an ed25519 SSH key for the given profile if one doesn't already exist.
# Prints the key file path on stdout.
generate_ssh_key() {
    local profile="$1"
    local email="$2"
    local key_file="$SSH_DIR/id_ed25519_${profile}"

    if [[ ! -f "$key_file" ]]; then
        ssh-keygen -t ed25519 -C "$email" -f "$key_file"
        chmod 600 "$key_file"
        echo "Generated new key for profile '$profile'." >&2
    else
        echo "Key for profile '$profile' already exists, skipping." >&2
    fi

    echo "$key_file"
}

# Appends a Host block to the SSH config file if one doesn't already exist.
add_host_to_config() {
    local profile="$1"
    local key_file="$2"

    if grep -qxF "Host $profile" "$CONFIG_FILE"; then
        echo "Config already contains profile '$profile', skipping." >&2
        return
    fi

    cat >> "$CONFIG_FILE" <<EOF

Host $profile
    HostName github.com
    User git
    IdentityFile $key_file
EOF
    echo "Added host '$profile' to SSH config." >&2
}

# Creates a key and config entry for a single profile.
setup_profile() {
    local profile="$1"
    local email="$2"
    local key_file

    key_file=$(generate_ssh_key "$profile" "$email")
    add_host_to_config "$profile" "$key_file"
}

# -- Main ----------------------------------------------------------------------
for entry in "${PROFILES[@]}"; do
    if [[ "$entry" != *:* ]]; then
        echo "Warning: skipping malformed profile entry '$entry' (expected 'name:email')" >&2
        continue
    fi

    name="${entry%%:*}"
    email="${entry##*:}"
    setup_profile "$name" "$email"
done
