# OpenCode

Config for OpenCode + local English speech-to-text (no API, no cost).

## What is tracked

| Path | Purpose |
|---|---|
| `cli.json` | CLI settings (linked to `~/.config/opencode/cli.json`) |
| `opencode.json` | Server config (linked to `~/.config/opencode/opencode.json`) |
| `plugins/voice-dictation/` | Vendored TUI dictation plugin |
| `setup.sh` | Installs `whisper-cpp` and the Whisper model |

`service.json` (contains the local API password), `node_modules` and session
state are intentionally **not** tracked.

## Speech-to-text

The plugin is [nachosag/opencode-voice-dictation](https://github.com/nachosag/opencode-voice-dictation),
vendored at upstream commit `fbfa1cdc6700fe960b89f5b0e1db4dced7258683` with two
local changes:

- default keybind `alt+v` (upstream: `insert`)
- language fixed to `en`; silent recordings are dropped before Whisper runs
  (upstream hallucinated words such as "you" on noise)

Runtime pieces live outside the repo:

- `/usr/bin/whisper-cli` from the `whisper-cpp` package
- `~/.local/share/whisper-cpp/ggml-base.en-q5_1.bin` (57 MB, downloaded by `setup.sh`)

Press `alt+v` to start/stop recording; the transcript is staged in the prompt,
not sent. `/dictate` does the same if the key does not register. RAM peaks at
~220 MB only while transcribing; no process stays resident.

The model is English-only on purpose. For other languages, download a
multilingual ggml model and select it with `/dictate-model`, then set the
language with `/dictate-language`.

## Fresh machine

`startup/config_setup.sh` symlinks `cli.json` and `opencode.json`, copies the
plugin into `~/.config/opencode/plugins/` (OpenCode's loader rejects symlinked
plugin files), and runs `setup.sh`. The installer is idempotent (`DRY_RUN=1` to
preview) and needs `sudo` for the pacman package.

## Revert

```bash
rm -rf ~/.config/opencode/plugins/voice-dictation
rm ~/.local/share/whisper-cpp/ggml-base.en-q5_1.bin
sudo pacman -Rns whisper-cpp
```
