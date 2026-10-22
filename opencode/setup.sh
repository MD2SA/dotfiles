#!/usr/bin/env bash
# Local speech-to-text for OpenCode: whisper.cpp binary + English-only model.
# Idempotent. The plugin itself is linked by startup/config_setup.sh.
#
# Usage: bash opencode/setup.sh   (DRY_RUN=1 to preview)

set -euo pipefail

DRY_RUN="${DRY_RUN:-0}"
MODEL_DIR="$HOME/.local/share/whisper-cpp"
MODEL="$MODEL_DIR/ggml-base.en-q5_1.bin"
MODEL_URL="https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.en-q5_1.bin"
MODEL_SHA256="4baf70dd0d7c4247ba2b81fafd9c01005ac77c2f9ef064e00dcf195d0e2fdd2f"

if ! command -v whisper-cli >/dev/null 2>&1; then
    if [[ "$DRY_RUN" == 1 ]]; then
        echo "  would install: whisper-cpp"
    else
        echo "==> Installing whisper-cpp"
        sudo pacman -S --needed --noconfirm whisper-cpp
    fi
fi

verify_model() {
    [[ -f "$MODEL" ]] || return 1
    echo "$MODEL_SHA256  $MODEL" | sha256sum -c --status >/dev/null 2>&1
}

if ! verify_model; then
    if [[ "$DRY_RUN" == 1 ]]; then
        echo "  would download: $MODEL"
    else
        echo "==> Downloading Whisper model"
        mkdir -p "$MODEL_DIR"
        curl -fL --progress-bar -o "$MODEL.part" "$MODEL_URL"
        echo "$MODEL_SHA256  $MODEL.part" | sha256sum -c --status
        mv "$MODEL.part" "$MODEL"
    fi
fi
