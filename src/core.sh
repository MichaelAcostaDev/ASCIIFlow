#!/usr/bin/env bash
set -Eeuo pipefail

ASCIIFLOW_VERSION="0.1.0"
ASCIIFLOW_STYLE_DEFAULT="block"
ASCIIFLOW_COLOR_DEFAULT="cyan"
ASCIIFLOW_GRADIENT_DEFAULT=""
ASCIIFLOW_DATA_DIR="${XDG_DATA_HOME:-${HOME:-/tmp}/.local/share}/asciiflow"

usage() {
  cat <<'EOF'
ASCIIFlow 0.1.0

Usage:
  asciiflow [options] [text]
  asciiflow --save NAME [text]
  asciiflow --load NAME

Options:
  --style STYLE        Select a built-in style.
  --color COLOR        Force a color name or ANSI palette value.
  --gradient NAME      Apply a gradient preset.
  --random             Pick a random style and color.
  --list               List available styles.
  --preview            Show all built-in styles.
  --save NAME [text]   Save a banner to XDG storage.
  --load NAME          Load a previously saved banner.
  --no-color           Disable colors.
  --help, -h           Show help.
  --version, -v        Show the current version.

Examples:
  asciiflow "Michael"
  asciiflow --style block "Arch Linux"
  asciiflow --style minimal "Hello"
  asciiflow --random
  asciiflow --list
  asciiflow --preview
  asciiflow --save my-banner "Welcome"
  asciiflow --load my-banner

Styles:
  block small minimal banner slant shadow digital

Gradients:
  sunset ocean aurora fire neon purple
EOF
}

version() {
  printf 'ASCIIFlow %s\n' "$ASCIIFLOW_VERSION"
}

error() {
  printf 'Error: %s\n' "$1" >&2
  exit 1
}

trim_text() {
  local text="$1"
  text="${text#${text%%[![:space:]]*}}"
  text="${text%${text##*[![:space:]]}}"
  printf '%s' "$text"
}

resolve_style() {
  local requested="${1:-$ASCIIFLOW_STYLE_DEFAULT}"
  case "$requested" in
    block|small|minimal|banner|slant|shadow|digital) printf '%s' "$requested" ;;
    *) return 1 ;;
  esac
}

choose_random_style() {
  local styles=(block small minimal banner slant shadow digital)
  printf '%s' "${styles[$RANDOM % ${#styles[@]}]}"
}

choose_random_gradient() {
  local gradients=(sunset ocean aurora fire neon purple)
  printf '%s' "${gradients[$RANDOM % ${#gradients[@]}]}"
}

choose_random_color() {
  local colors=(red green blue cyan magenta yellow white purple orange)
  printf '%s' "${colors[$RANDOM % ${#colors[@]}]}"
}

main() {
  local -a positional=()
  local save_name=""
  local load_name=""
  local style=""
  local color=""
  local gradient=""
  local random_mode=0
  local list_mode=0
  local preview_mode=0
  local help_mode=0
  local version_mode=0
  local no_color=0
  local text=""
  local raw_text=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --style)
        if [[ $# -lt 2 ]]; then error "missing value for --style"; fi
        style="$2"
        shift 2
        ;;
      --color)
        if [[ $# -lt 2 ]]; then error "missing value for --color"; fi
        color="$2"
        shift 2
        ;;
      --gradient)
        if [[ $# -lt 2 ]]; then
          gradient="sunset"
          shift
        else
          gradient="$2"
          shift 2
        fi
        ;;
      --random)
        random_mode=1
        shift
        ;;
      --list)
        list_mode=1
        shift
        ;;
      --preview)
        preview_mode=1
        shift
        ;;
      --save)
        if [[ $# -lt 2 ]]; then error "missing value for --save"; fi
        save_name="$2"
        shift 2
        ;;
      --load)
        if [[ $# -lt 2 ]]; then error "missing value for --load"; fi
        load_name="$2"
        shift 2
        ;;
      --no-color)
        no_color=1
        shift
        ;;
      --help|-h)
        help_mode=1
        shift
        ;;
      --version|-v)
        version_mode=1
        shift
        ;;
      --)
        shift
        positional+=("$@")
        break
        ;;
      -*)
        error "unknown option: $1"
        ;;
      *)
        positional+=("$1")
        shift
        ;;
    esac
  done

  if [[ "$no_color" -eq 1 ]]; then
    export NO_COLOR=1
  fi

  detect_color_capabilities

  if [[ "$help_mode" -eq 1 ]]; then
    usage
    exit 0
  fi

  if [[ "$version_mode" -eq 1 ]]; then
    version
    exit 0
  fi

  if [[ -n "$save_name" ]]; then
    if [[ ${#positional[@]} -eq 0 ]]; then
      error "missing text for --save"
    fi
    raw_text="${positional[*]}"
    save_banner "$save_name" "$raw_text" "$style" "$color" "$gradient"
    exit 0
  fi

  if [[ -n "$load_name" ]]; then
    load_banner "$load_name"
    exit 0
  fi

  if [[ "$list_mode" -eq 1 ]]; then
    list_styles
    exit 0
  fi

  if [[ "$preview_mode" -eq 1 ]]; then
    preview_styles
    exit 0
  fi

  if [[ "$random_mode" -eq 1 ]]; then
    if [[ -n "$style" ]]; then
      style="$style"
    else
      style="$(choose_random_style)"
    fi
    if [[ -n "$gradient" ]]; then
      :
    else
      gradient="$(choose_random_gradient)"
    fi
    if [[ -n "$color" ]]; then
      :
    else
      color="$(choose_random_color)"
    fi
    raw_text="${positional[*]:-ASCIIFlow}"
    if [[ -z "$raw_text" ]]; then
      raw_text="ASCIIFlow"
    fi
    render_banner "$raw_text" "$style" "$color" "$gradient"
    exit 0
  fi

  if [[ ${#positional[@]} -eq 0 ]]; then
    error "missing input text"
  fi

  raw_text="${positional[*]}"
  raw_text="$(trim_text "$raw_text")"
  if [[ -z "$raw_text" ]]; then
    error "missing input text"
  fi

  if [[ -z "$style" ]]; then
    style="$ASCIIFLOW_STYLE_DEFAULT"
  fi
	if [[ ! -n "$style" ]]; then
	 style="$ASCIIFLOW_STYLE_DEFAULT"
	fi

  if [[ -z "$color" ]]; then
    color="$ASCIIFLOW_COLOR_DEFAULT"
  fi

  if [[ ! "$style" =~ ^(block|small|minimal|banner|slant|shadow|digital)$ ]]; then
    error "style '$style' was not found.\nAvailable styles:\n  block\n  small\n  minimal\n  banner\n  slant\n  shadow\n  digital"
  fi

  render_banner "$raw_text" "$style" "$color" "$gradient"
}
