# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/npm/bin:$PATH"

# XDG configs
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export MAVEN_OPTS="-Dmaven.repo.local=$XDG_DATA_HOME/maven/repository"
export MAVEN_ARGS="--settings $XDG_CONFIG_HOME/maven/settings.xml"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export NUGET_PACKAGES="$XDG_CACHE_HOME"/NuGetPackages
export XCOMPOSEFILE="$XDG_CONFIG_HOME"/X11/xcompose
export GNUPGHOME="$HOME/.local/share/gnupg"
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"

# Key shortcuts
bind -x '"\C-@f": tmux-sessionizer'

# Alias
alias clip="wl-copy"
alias vim="nvim"
alias ld="lazydocker"
cpp() {
    file="$1"
    name="$(basename "${file%.*}")"
    out="/tmp/$name"

    g++ -std=gnu++20 -O2 -Wall "$file" -o "$out" && "$out"
}

## For pisid
alias mazeup="docker compose -f /home/manas/Documents/iscte/pisid/mazerun/docker-compose.yml up"
alias mazed="docker compose -f /home/manas/Documents/iscte/pisid/mazerun/docker-compose.yml down"
alias mazerun="wine /home/manas/Documents/iscte/pisid/mazerun/server/mazerun.exe 25 --flagMessage 1 --delay 2 --broker broker.hivemq.com --portbroker 1883"
##

# pnpm
export PNPM_HOME="/home/manas/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Add JBang to environment
alias j!=jbang
export PATH="$HOME/.jbang/bin:$PATH"

alias nh='HISTFILE=/dev/null'
