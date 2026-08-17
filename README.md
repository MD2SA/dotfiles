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
The remaining directories (`hypr/`, `omarchy/`, `tmux/`, etc.) contain specific application configurations. The setup scripts will automatically symlink or place these into `~/.config/`.

## Config Organization Pattern

Configs are organized by their purpose:

### Style/Theme Configs → `themes/manas/`
- `colors.toml` - Color palette
- `foot.ini` - Terminal colors
- `hyprland.lua` - Window border colors
- `hyprlock.conf` - Lock screen appearance
- `backgrounds/` - Wallpapers

### Behavior/Layout Configs → `hypr/`
- `hyprland.lua` - Main entry point
- `bindings.lua` - Keybindings
- `monitors.lua` - Monitor setup
- `input.lua` - Input settings
- `looknfeel.lua` - Gaps, border size, rounding
- `hypridle.conf` - Idle behavior

### Shell Configs → `omarchy/`
- `shell.json` - Bar layout, idle settings
- `shell.toml` - Font base-size
- `branding/` - Custom branding
- `extensions/` - Menu extensions
- `hooks/` - Lifecycle hooks

### Terminal Configs → `foot/`
- `foot.ini` - Terminal settings (colors loaded from theme)

## Theme System

Themes are stored in `themes/` directory and symlinked to `~/.config/omarchy/themes/`. When you apply a theme with `omarchy theme set manas`, it loads:
- Color palette from `colors.toml`
- Terminal colors from `foot.ini`
- Border colors from `hyprland.lua`
- Lock screen colors from `hyprlock.conf`

To customize a theme, edit files in `themes/manas/` and reapply with `omarchy theme set manas`.

## Shell Customization

### Bar Appearance
**File:** `~/.config/omarchy/shell.json`
- `"transparent": true/false` - Enable/disable bar transparency
- `"position"`: "top", "bottom", "left", "right" - Bar position
- `"layout"` - Widget arrangement and settings

**File:** `~/.config/dotfiles/themes/manas/shell.toml`
- `[bar]` section - Bar colors, alpha, size
- `[notifications]` section - Notification popup styling
- `[menu]` section - Menu popup styling
- `[workspaces]` section - Workspace indicator colors and spacing

### Bar Transparency
To make the bar fully transparent:
1. Set `"transparent": true` in `shell.json`
2. Set `background-alpha = 0.0` in `shell.toml` under `[bar]`

### Workspace Spacing
Edit `~/.config/dotfiles/themes/manas/shell.toml`:
```toml
[workspaces]
spacing = 4  # Adjust pixel spacing between workspace indicators
active-color = "#89b4fa"  # Active workspace color
inactive-color = "#585b70"  # Inactive workspace color
urgent-color = "#f38ba8"  # Urgent workspace color
```

### Notifications
**Cloned plugin:** `~/.config/omarchy/plugins/manas.notifications/`
- `Service.qml` - Main notification service
- `components/NotificationCard.qml` - Notification appearance

**Theme colors:** Edit `shell.toml` under `[notifications]`:
```toml
[notifications]
background = "#1e1e2e"
background-alpha = 0.95
text = "#cdd6f4"
border = "#89b4fa"
border-width = 1
border-radius = 12
```

### Quick Menu
**File:** `~/.config/omarchy/extensions/omarchy-menu.jsonc`
- Add custom menu items
- Override existing items
- Create submenus

**Theme colors:** Edit `shell.toml` under `[menu]`:
```toml
[menu]
background = "#1e1e2e"
background-alpha = 0.95
text = "#cdd6f4"
border = "#89b4fa"
border-width = 1
border-radius = 12
```

### Apply Changes
```bash
omarchy restart shell  # Reload shell with new settings
omarchy theme set manas  # Reapply theme (if you edited theme files)
```

### Available Widgets
Add/remove widgets in `shell.json` under `bar.layout`:
- `omarchy.menu` - Menu launcher
- `omarchy.workspaces` - Workspace switcher
- `omarchy.clock` - Date/time
- `omarchy.media` - Music player
- `omarchy.audio` - Volume controls
- `omarchy.network` - Network status
- `omarchy.bluetooth` - Bluetooth
- `omarchy.power` - Battery/power
- `omarchy.tray` - System tray
- `omarchy.indicators` - Status indicators
- `omarchy.weather` - Weather
- `omarchy.agents` - AI agents

### Custom Modules
Add custom command or QML modules in `shell.json`:
```json
{
  "id": "my-module",
  "type": "command",
  "exec": "~/.config/omarchy/bar/scripts/my-script",
  "interval": 5,
  "tooltip": "My Module"
}
```
