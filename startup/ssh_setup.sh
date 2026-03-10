#!/usr/bin/env bash
# Sets up SSH keys and config entries for multiple GitHub profiles.
# Each profile gets a dedicated ed25519 key and a Host block in ~/.ssh/config.

set -euo pipefail

# -- Constants ----------------------------------------------------------------
HOME=/tmp/tmp-home
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

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  GitHub SSH Setup"
echo "═══════════════════════════════════════════════════════════════"

for entry in "${PROFILES[@]}"; do
    if [[ "$entry" != *:* ]]; then
        echo "Warning: skipping malformed profile entry '$entry' (expected 'name:email')" >&2
        continue
    fi

    name="${entry%%:*}"
    email="${entry##*:}"
    setup_profile "$name" "$email"
done

# -- Post-setup guidance -------------------------------------------------------

prompt_yes_no() {
    local question="$1"
    while true; do
        read -rp "$question [y/n]: " answer
        case "$answer" in
            [Yy]*) return 0 ;;
            [Nn]*) return 1 ;;
            *)     echo "  Please answer y or n." ;;
        esac
    done
}
open_browser() {
    local url="$1"
    if command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$url" >/dev/null 2>&1 &
    elif command -v open >/dev/null 2>&1; then
        open "$url" >/dev/null 2>&1 &
    else
        echo "  Could not detect a browser opener. Visit manually: $url"
    fi
}

# Prints the public key and offers to open GitHub so the user can add it.
guide_new_key() {
    local profile="$1"
    local pub_key_file="$SSH_DIR/id_ed25519_${profile}.pub"

    echo ""
    echo "  ┌─ New key: $profile ───────────────────────────────────────────"
    echo "  │  To use this key with GitHub, you need to add the public key"
    echo "  │  to your GitHub account under:"
    echo "  │    Settings → SSH and GPG keys → New SSH key"
    echo "  │"
    echo "  │  Your public key (copy this):"
    echo "  │"
    # indent the key for readability
    sed 's/^/  │    /' "$pub_key_file"
    echo "  │"
    echo "  │  Then test with:  ssh -T $profile"
    echo "  └───────────────────────────────────────────────────────────────"

    if prompt_yes_no "  Open GitHub SSH settings in your browser now?"; then
        open_browser "https://github.com/settings/ssh/new"
        echo "  Browser opened. Paste the key above and save."
    fi
}


if [[ ${#PROFILES[@]} -gt 0 ]]; then
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "  Keys ready!"
    echo "═══════════════════════════════════════════════════════════════"
    if prompt_yes_no "  Generate new ssh keys for github?"; then
        for entry in "${PROFILES[@]}"; do
            [[ "$entry" != *:* ]] && continue
            profile="${entry%%:*}"
            if prompt_yes_no "  Generate new ssh key for $profile?"; then
                guide_new_key "$profile"
            fi
        done
    fi
fi

echo ""
echo "  All done! Quick reference for using your profiles:"
echo ""
for entry in "${PROFILES[@]}"; do
    [[ "$entry" != *:* ]] && continue
    name="${entry%%:*}"
    echo "    # Clone using the '$name' profile:"
    echo "    git clone git@${name}:YOUR_USERNAME/your-repo.git"
    echo ""
done
