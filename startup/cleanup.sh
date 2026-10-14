#!/usr/bin/env bash
# Interactive cleanup: remove unwanted default apps and junk dirs.
# This is the "uninstall bloat at will" entry point. Safe to re-run.

set -euo pipefail

DOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DOTDIR"

echo "==> Removing packages / webapps / bindings"
source startup/pkg_cleanup.sh

echo "==> Cleaning home and config dirs"
source startup/dir_cleanup.sh
