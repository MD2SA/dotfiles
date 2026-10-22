# Dotfiles

Personal dotfiles and setup for a fresh **Omarchy** machine. Public repo —
**never commit secrets** (see [Security](#security)).

## Quick start (new machine)

```bash
git clone https://github.com/MD2SA/dotfiles ~/.config/dotfiles
bash ~/.config/dotfiles/startup/install.sh
```

`install.sh` is idempotent and safe to re-run. It:

1. pulls the latest dotfiles,
2. enables the secret-scanning pre-commit hook,
3. symlinks all configs into place (**backing up** anything it replaces),
4. sets up SSH keys (interactive, prompts for GitHub),
5. validates the `rclone` `drive:` remote,
6. installs and enables the daily Google Drive backup timer.

Then run the interactive cleanup once (optional):

```bash
bash ~/.config/dotfiles/startup/cleanup.sh
```

## Directory structure

| Path | Purpose |
|---|---|
| `startup/` | Installer and setup scripts (`install.sh`, `cleanup.sh`, `config_setup.sh`, `ssh_setup.sh`, `rclone_setup.sh`, `backup_setup.sh`) |
| `backup/` | Google Drive backup script, systemd units and restore script |
| `bin/` | Personal executables, linked to `~/.local/bin` |
| `hypr/` | Hyprland behavior/layout config |
| `omarchy/` | Omarchy shell, plugins, hooks, extensions |
| `opencode/` | OpenCode config + local English speech-to-text (linked file by file) |
| `themes/manas/` | Theme (colors, foot, hyprlock, shell, wallpapers) |
| `foot/`, `btop/`, `tmux/`, `tmux-sessionizer/` | App configs |
| `.githooks/` | Pre-commit secret guard |

### How linking works

`startup/config_setup.sh` links every top-level entry to `~/.config/<name>`,
with these special cases:

- `bin` -> `~/.local/bin`
- `opencode/*` -> individual files under `~/.config/opencode` (runtime state stays untracked)
- `themes/*` -> `~/.config/omarchy/themes/*`
- `uwsm-default` -> `~/.config/uwsm/default`
- `.bash*` -> `~$HOME/.bash*`

It never deletes real content: anything replaced is moved to
`~/.config/dotfiles.local/backups/<timestamp>/`. Preview with `DRY_RUN=1`.

## Backup to Google Drive

One-way, additive backup (`rclone copy`, never deletes the remote):

```
local  ->  drive:omarchy/<folder>
```

Folders: `Pictures`, `Desktop`, `Videos`, `Documents`.

- Runs daily via `rclone-backup.timer` (`Persistent=true`).
- Skips any directory containing a `.nobackup` marker file
  (e.g. `Documents/projects/.nobackup`) and any `.git` contents.
- Logs to `~/.local/state/rclone-backup/backup-YYYYMMDD.log`.
- Notifies on completion/failure.

Manual run / status:

```bash
bash ~/.config/dotfiles/backup/rclone-backup.sh
systemctl --user list-timers rclone-backup.timer
journalctl --user -u rclone-backup.service
```

Restore on a new machine:

```bash
bash ~/.config/dotfiles/backup/restore.sh            # all folders
bash ~/.config/dotfiles/backup/restore.sh Documents  # a single folder
```

### Recommended: create your own Google client_id

**Google Drive via `rclone`'s shared client_id will stop working
during 2026**. Create your own to avoid interruption:
<https://rclone.org/drive/#making-your-own-client-id>. Then re-auth:

```bash
rclone config reconnect drive:
```

The OAuth token lives in `~/.config/rclone/rclone.conf` (git-ignored).

## Security

This repo is **public**. Secrets are kept out of it:

- `~/.config/rclone/rclone.conf` (Drive token)
- `~/.config/dotfiles.local/ssh-profiles` (SSH profile names + emails)
- `~/.config/gws-omarchy-calendar/` (calendar credentials)
- `~/.ssh`, `~/.gnupg`

A pre-commit hook (`.githooks/pre-commit`, enabled via `core.hooksPath`) blocks
commits that contain secret-looking content or secret filenames, and also runs
`gitleaks` if installed. Override only if you are certain:
`git commit --no-verify`.

Restore secrets manually on a new machine (Bitwarden or similar).

## Theme

Apply the custom theme:

```bash
omarchy theme set manas
```

See `themes/manas/` for `colors.toml`, `foot.ini`, `hyprland.lua`,
`hyprlock.conf`, `shell.toml`.
