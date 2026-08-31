#!/usr/bin/env bash
set -Eeuo pipefail

TARGET_DIR="${HOME}/.local/bin"
SHARE_DIR="${HOME}/.local/share/asciiflow"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_BIN="$TARGET_DIR/asciiflow"

info() { printf '%s\n' "$1"; }
warn() { printf 'Warning: %s\n' "$1" >&2; }
error() { printf 'Error: %s\n' "$1" >&2; exit 1; }

shell_rc_file() {
  local shell_name="${1:-${SHELL##*/}}"
  case "$shell_name" in
    bash) printf '%s/.bashrc' "$HOME" ;;
    zsh) printf '%s/.zshrc' "$HOME" ;;
    *) printf '%s/.profile' "$HOME" ;;
  esac
}

append_shell_path() {
  local shell_name="${1:-${SHELL##*/}}"
  local path_line="export PATH=\"$TARGET_DIR:\$PATH\""
  local rc_file
  rc_file="$(shell_rc_file "$shell_name")"

  if [[ ! -f "$rc_file" ]]; then
    touch "$rc_file"
  fi

  if ! grep -Fqx "$path_line" "$rc_file" 2>/dev/null; then
    printf '\n%s\n' "$path_line" >> "$rc_file"
    info "Added PATH export to $rc_file"
  fi
}

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

if [[ "${1:-}" == "--shell" ]]; then
  shell_name="${2:-${SHELL##*/}}"
  append_shell_path "$shell_name"
fi

cp -R "$SOURCE_DIR/src" "$SHARE_DIR/"
cp "$SOURCE_DIR/asciiflow" "$SHARE_DIR/asciiflow"
cp "$SOURCE_DIR/install.sh" "$SHARE_DIR/install.sh"
cp "$SOURCE_DIR/uninstall.sh" "$SHARE_DIR/uninstall.sh"
cp "$SOURCE_DIR/LICENSE" "$SHARE_DIR/LICENSE"
cp "$SOURCE_DIR/README.md" "$SHARE_DIR/README.md"
cp -R "$SOURCE_DIR/tests" "$SHARE_DIR/tests"
cp "$SOURCE_DIR/asciiflow" "$TARGET_BIN"
chmod +x "$TARGET_BIN" "$SHARE_DIR/asciiflow" "$SHARE_DIR/install.sh" "$SHARE_DIR/uninstall.sh" "$SHARE_DIR/tests/run.sh"

if [[ ":$PATH:" == *":$TARGET_DIR:"* ]]; then
  info "ASCIIFlow installed successfully."
  info ""
  info "Run:"
  info "  asciiflow \"Hello\""
  exit 0
fi

info "ASCIIFlow installed successfully."
info ""
info "The command was installed to:"
info "  $TARGET_BIN"
info ""
info "Add $TARGET_DIR to your PATH to use 'asciiflow' from new terminals."
info "In your current shell, run:"
info "  export PATH=\"$HOME/.local/bin:\$PATH\""
