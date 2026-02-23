#!/usr/bin/env bash

VERSION="1.0-beta"

HOME_ITEMS=(
    ".viminfo" ".wget-hsts" ".lesshst" ".bash_history" ".python_history"
    "Templates" "Public" "Music" "Desktop"
)

SPECIAL_ITEMS=(
    "Work" ".vim" ".gnupg" ".claude"
)

CONFIG_ITEMS=(
    "1Password" "Typora" "chromium" "fastfetch" "htop" "kitty" "lazygit" "xournalpp"
)

GIT_FILE=".git-credentials"

exit_cancelled() {
    gum log --level error "Cancelled!"
    exit 1
}

delete_item() {
    local path="$1"
    [[ ! -e "$path" ]] && return
    gum log --level info "Deleting: ~/$path"
    rm -rf "$path" 2>/dev/null || gum log --level warn "Failed to delete ~/$path"
}

move_with_backup() {
    local src="$1" dst="$2"
    [[ ! -e "$src" ]] && return
    [[ -e "$dst" ]] && mv "$dst" "$dst.backup.$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$(dirname "$dst")"
    mv "$src" "$dst" && gum log --level info "Moved ~/$src → ~/$dst"
}

choose_items() {
    local title="$1"; shift
    local items=("$@")
    [[ ${#items[@]} -eq 0 ]] && return 1
    gum style --foreground 214 --bold "$title (${#items[@]})"
    local opts=()
    for i in "${items[@]}"; do opts+=(" • $i"); done
    gum choose --no-limit --cursor.foreground 39 --selected.foreground 82 --height 15 \
        --header "Select items to DELETE (space = mark)" "${opts[@]}"
}

clear
gum style --foreground 39 --bold --align center \
    "  ___ _           _          " \
    " / _ \ | ___ _ __ | |__   ___ " \
    "| | | |/ _ \ '_ \| '_ \ / _ \\" \
    "| |_| |  __/ | | | |_) |  __/" \
    " \___/ \___|_| |_|_.__/ \___|" \
    "" " Personal Cleaner v$VERSION"

gum spin --spinner dot --title "Scanning your home..." -- sleep 1.2

to_delete_home=()
for f in "${HOME_ITEMS[@]}"; do [[ -e "$HOME/$f" ]] && to_delete_home+=("$f"); done

to_delete_special=()
for f in "${SPECIAL_ITEMS[@]}"; do [[ -e "$HOME/$f" ]] && to_delete_special+=("$f"); done

to_delete_config=()
for f in "${CONFIG_ITEMS[@]}"; do [[ -e "$HOME/.config/$f" ]] && to_delete_config+=("$f"); done

total=$((${#to_delete_home[@]} + ${#to_delete_special[@]} + ${#to_delete_config[@]}))
[[ $total -eq 0 ]] && { gum style --foreground 82 --bold "✓ Already clean!"; exit 0; }

gum style --foreground 214 --bold "Found $total items to clean"

gum style --foreground 51 --italic "Space = select   Enter = confirm"

selected_home=()
[[ ${#to_delete_home[@]} -gt 0 ]] && mapfile -t selected_home <<< "$(choose_items "Home items" "${to_delete_home[@]}")"

selected_special=()
[[ ${#to_delete_special[@]} -gt 0 ]] && mapfile -t selected_special <<< "$(choose_items "Important items (careful!)" "${to_delete_special[@]}")"

selected_config=()
[[ ${#to_delete_config[@]} -gt 0 ]] && mapfile -t selected_config <<< "$(choose_items "Config items" "${to_delete_config[@]}")"

final=()
for i in "${selected_home[@]}"; do [[ -n "$i" ]] && final+=("$HOME/${i#• }"); done
for i in "${selected_special[@]}"; do [[ -n "$i" ]] && final+=("$HOME/${i#• }"); done
for i in "${selected_config[@]}"; do [[ -n "$i" ]] && final+=("$HOME/.config/${i#• }"); done

[[ ${#final[@]} -eq 0 ]] && { gum log --level info "Nothing selected. Exiting."; exit 0; }

clear
gum style --foreground 196 --bold --border double --padding "1 3" --width 60 --align center \
    "!!! FINAL CHANCE !!!" "" \
    "You will delete ${#final[@]} items" \
    "This cannot be undone!"

echo ""
gum style --foreground 214 "Items to be deleted:"
for path in "${final[@]}"; do echo " • ~/${path#$HOME/}"; done

gum confirm "Proceed with deletion?" --default=false --timeout 45s || { gum log --level info "Cancelled!"; exit 0; }

[[ -f "$HOME/$GIT_FILE" ]] && move_with_backup "$HOME/$GIT_FILE" "$HOME/.config/git/credentials"

errors=0
for path in "${final[@]}"; do delete_item "${path#$HOME/}" || ((errors++)); done

echo ""
if [[ $errors -eq 0 ]]; then
    gum style --foreground 82 --bold --border double --padding "1 3" \
        "✓ Cleaned!" "Deleted ${#final[@]} items successfully."
else
    gum style --foreground 214 --bold "⚠ $errors items could not be deleted"
fi

echo ""
gum style --foreground 240 "Press Enter to exit..."
read -r </dev/tty

exit $((errors > 0))
