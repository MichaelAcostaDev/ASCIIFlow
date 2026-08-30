#!/usr/bin/env bash
set -Eeuo pipefail

TARGET_DIR="${HOME}/.local/bin"
SHARE_DIR="${HOME}/.local/share/asciiflow"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_BIN="$TARGET_DIR/asciiflow"

info() { printf '%s\n' "$1"; }
warn() { printf 'Warning: %s\n' "$1" >&2; }
error() { printf 'Error: %s\n' "$1" >&2; exit 1; }

if [[ ! -d "$SOURCE_DIR" ]]; then
  error "project directory not found: $SOURCE_DIR"
fi

if ! command -v bash >/dev/null 2>&1; then
  error "bash is required but not installed"
fi

mkdir -p "$TARGET_DIR" "$SHARE_DIR"
if [[ ! -w "$TARGET_DIR" || ! -w "$SHARE_DIR" ]]; then
  error "cannot write to $TARGET_DIR or $SHARE_DIR; fix permissions and retry"
fi

cp -R "$SOURCE_DIR"/. "$SHARE_DIR/"
cp "$SOURCE_DIR/asciiflow" "$TARGET_BIN"
chmod +x "$TARGET_BIN"
chmod +x "$SHARE_DIR/install.sh" "$SHARE_DIR/uninstall.sh" "$SHARE_DIR/tests/run.sh"

info "Installed ASCIIFlow to $TARGET_BIN"
info "Project files are stored in $SHARE_DIR"
info "Make sure $TARGET_DIR is in your PATH."
info "If not, add this line to your shell config:"
info "  export PATH=\"$TARGET_DIR:\$PATH\""
