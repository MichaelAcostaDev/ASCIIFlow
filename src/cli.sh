#!/usr/bin/env bash
set -Eeuo pipefail

# ASCIIFlow CLI Interface
# Simplified command-line handling

ASCIIFLOW_VERSION="1.0.0"

# Print usage/help
show_help() {
  cat <<'EOF'
ASCIIFlow - Generate beautiful ASCII text banners

Usage:
  asciiflow "text"
  asciiflow -f FONT "text"
  asciiflow -l
  asciiflow -h
  asciiflow -v

Options:
  -f, --font FONT    Use a specific font (default: block)
  -l, --list         List available fonts
  -h, --help         Show this help message
  -v, --version      Show version

Examples:
  asciiflow "Hello"
  asciiflow -f digital "Hello World"
  asciiflow -f small "Arch Linux"
  asciiflow --list

Fonts:
  block              Large block letters (default)
  digital            Digital/7-segment style
  banner             Banner style
  small              Compact small letters

EOF
}

# Print version
show_version() {
  printf 'ASCIIFlow %s\n' "$ASCIIFLOW_VERSION"
}

# List available fonts
list_fonts() {
  printf 'Available fonts:\n'
  while IFS= read -r font; do
    if [[ -n "$font" ]]; then
      printf '  %s\n' "$font"
    fi
  done < <(get_available_fonts)
}

# Main CLI parser
parse_cli() {
  local font="block"
  local text=""
  local show_help_flag=0
  local show_version_flag=0
  local list_fonts_flag=0
  
  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        show_help_flag=1
        shift
        ;;
      -v|--version)
        show_version_flag=1
        shift
        ;;
      -l|--list)
        list_fonts_flag=1
        shift
        ;;
      -f|--font)
        if [[ $# -lt 2 ]]; then
          printf 'Error: -f requires a font name\n' >&2
          return 1
        fi
        font="$2"
        shift 2
        ;;
      -*)
        printf 'Error: unknown option: %s\n' "$1" >&2
        printf 'Run ''asciiflow -h'' for help\n' >&2
        return 1
        ;;
      *)
        # All remaining args are the text
        text="$@"
        break
        ;;
    esac
  done
  
  # Handle flags
  if [[ $show_help_flag -eq 1 ]]; then
    show_help
    return 0
  fi
  
  if [[ $show_version_flag -eq 1 ]]; then
    show_version
    return 0
  fi
  
  if [[ $list_fonts_flag -eq 1 ]]; then
    list_fonts
    return 0
  fi
  
  # Require text
  if [[ -z "$text" ]]; then
    printf 'Error: no text provided\n' >&2
    printf 'Run ''asciiflow -h'' for help\n' >&2
    return 1
  fi
  
  # Validate font
  if ! font_exists "$font"; then
    printf 'Error: unknown font: %s\n' "$font" >&2
    printf 'Run ''asciiflow -l'' to list available fonts\n' >&2
    return 1
  fi
  
  # Render the text
  render_colored "$text" "$font"
}

# Check if a font exists
font_exists() {
  local font="$1"
  local font_file="${ASCIIFLOW_ROOT}/fonts/${font}.font"
  
  [[ -f "$font_file" ]]
}
