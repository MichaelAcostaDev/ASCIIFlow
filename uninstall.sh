#!/usr/bin/env bash
set -Eeuo pipefail

TARGET_BIN="${HOME}/.local/bin/asciiflow"
SHARE_DIR="${HOME}/.local/share/asciiflow"

info() { printf '%s\n' "$1"; }
warn() { printf 'Warning: %s\n' "$1" >&2; }

if [[ -f "$TARGET_BIN" ]]; then
  rm -f "$TARGET_BIN"
  info "Removed ASCIIFlow from $TARGET_BIN"
else
  warn "ASCIIFlow is not installed at $TARGET_BIN"
fi

if [[ -d "$SHARE_DIR" ]]; then
  rm -rf "$SHARE_DIR"
  info "Removed ASCIIFlow data from $SHARE_DIR"
fi

exit 0
