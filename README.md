# Dotfiles

Personal dotfiles, configurations, and setup scripts.

## Directory Structure

This repository separates the initial system setup from daily scripts and application configurations:

### `startup/`
Contains the core scripts to bootstrap and configure a fresh system install. You generally don't need to touch these after the initial setup.

* **`init.sh`**: The main entry point. Run this to execute all setup processes.
* **Setup Modules**: Other scripts handle specific tasks:
  * `ssh_setup.sh`: Sets up SSH keys
  * `config_setup.sh`: Links system config files
  * `rclone_setup.sh`: Configures cloud storage
  * `dir_cleanup.sh`, `pkg_cleanup.sh`: Cleans up defaults

### `bin/`
Personal standalone scripts and executables (e.g., `tmux-sessionizer`, `open-github`, `manas-launch-webapp`). 
These should be added to the system's `$PATH` so they can be run from anywhere.

### Application Configs
The remaining directories (`hypr/`, `waybar/`, `tmux/`, `ghostty/`, etc.) contain specific application configurations. The setup scripts will automatically symlink or place these into `~/.config/`.
