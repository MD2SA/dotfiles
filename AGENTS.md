# AGENTS.md

Guidance for agents working in this repository.

## What this repo is

Personal **Omarchy** dotfiles. It is a **public** GitHub repo, deployed by
symlinking files into `~/.config`. There is no build system; changes are plain
config/scripts.

## Golden rules

- **Never commit secrets.** This repo is public. Tokens, keys and passwords live
  outside it (`~/.config/rclone/rclone.conf`, `~/.config/dotfiles.local/`,
  `~/.config/gws-omarchy-calendar/`, `~/.ssh`, `~/.gnupg`). A pre-commit hook
  (`.githooks/pre-commit`) blocks secret-looking content; do not bypass it.
- Keep scripts **idempotent** and **non-destructive**: back up before replacing,
  support `DRY_RUN=1` where it makes sense.
- Do **not** hardcode `/home/<user>` paths; use `$HOME` / XDG variables.
- No comments unless they explain non-obvious behavior (this codebase favours a
  few high-value comments).

## Useful commands

```bash
# Syntax-check all shell scripts
for f in startup/*.sh backup/*.sh .githooks/pre-commit; do bash -n "$f" || exit 1; done

# Preview config linking without changing anything
DRY_RUN=1 bash startup/config_setup.sh

# Run the installer (idempotent)
bash startup/install.sh

# Run a backup now (uploads to Google Drive)
bash backup/rclone-backup.sh

# Pre-commit hook (secret scan) on demand
./.githooks/pre-commit
```

## Backup specifics

- `backup/rclone-backup.sh` uses `rclone copy` (one-way, additive). Do not switch
  to `sync` — that would propagate local deletions to the remote.
- Exclusions: `--exclude-if-present .nobackup` (marker **files** only) and
  `--exclude ".git/**"`. Do **not** use `--exclude-if-present .git`: `.git` is a
  directory and rclone errors with "is a directory not a file".
- `--exclude-if-present` only works with marker *files*, never directories.
- The `drive:` OAuth token cannot be committed; it is interactive to set up.

## When adding a new app config

Add the top-level file/dir to the repo; `config_setup.sh` links it automatically
to `~/.config/<name>`. Add an entry to `IGNORE` in `config_setup.sh` if it must
not be linked.
