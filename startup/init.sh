#!/usr/bin/env bash

# System wide alias
sudo ln -sf $(which nvim) /usr/bin/vim

echo "preparing configs"
source ./config_setup.sh
echo "removing pkgs"
source ./pkg_cleanup.sh
echo "cleaning dirs"
source ./dir_cleanup.sh

# User needs to do this twice for some reason
omarchy-restart-hyprctl
