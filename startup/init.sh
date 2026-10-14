#!/usr/bin/env bash
# Legacy entry point -> delegates to the installer.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec bash "$HERE/install.sh"
