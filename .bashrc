# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

export PATH="$HOME/.local/bin:$PATH"

# XDG configs
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc

# Key shortcuts
bind -x '"\C-@f": tmux-sessionizer'

# Alias
alias clip="wl-copy"
alias vim="nvim"
alias ld="lazydocker"

## For pisid
alias mazeup="docker compose -f /home/manas/Documents/iscte/pisid/mazerun/docker-compose.yml up"
alias mazed="docker compose -f /home/manas/Documents/iscte/pisid/mazerun/docker-compose.yml down"
alias mysql-cloud='docker exec -it mysql-cloud bash -c "mysql --user=aluno --password=aluno --host=194.210.86.10"'

alias mazerun="wine /home/manas/Documents/iscte/pisid/mazerun/mazerun.exe 25 --flagMessage 1 --delay 2 --broker broker.hivemq.com --portbroker 1883"
##
