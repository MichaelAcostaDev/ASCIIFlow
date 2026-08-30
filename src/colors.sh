#!/usr/bin/env bash
set -Eeuo pipefail

ASCIIFLOW_USE_COLOR=1
ASCIIFLOW_COLOR_DEPTH=8

ansi_escape() {
  local code="$1"
  if (( ASCIIFLOW_USE_COLOR == 0 )); then
    printf ''
  else
    printf '\033[%sm' "$code"
  fi
}

ansi_fg() {
  local code="$1"
  printf '%s' "$(ansi_escape "$code")"
}

ansi_truecolor() {
  local r="$1"
  local g="$2"
  local b="$3"
  if (( ASCIIFLOW_USE_COLOR == 0 )); then
    printf ''
  else
    printf '\033[38;2;%s;%s;%sm' "$r" "$g" "$b"
  fi
}

rgb_to_ansi256() {
  local r="$1"
  local g="$2"
  local b="$3"
  local code=0
  if (( r == 0 && g == 0 && b == 0 )); then
    printf '0'
    return
  fi

  local rr=$((r / 256))
  local gg=$((g / 256))
  local bb=$((b / 256))
  code=$((16 + (rr * 36) + (gg * 6) + bb))
  if (( rr == 5 )); then
    code=$((232 + ((gg * 10) + bb)))
  fi
  printf '%s' "$code"
}

resolve_basic_color() {
  local color="$1"
  case "$color" in
    black) printf '30' ;;
    red) printf '31' ;;
    green) printf '32' ;;
    yellow) printf '33' ;;
    blue) printf '34' ;;
    magenta) printf '35' ;;
    cyan) printf '36' ;;
    white|gray) printf '37' ;;
    bright-red) printf '91' ;;
    bright-green) printf '92' ;;
    bright-yellow) printf '93' ;;
    bright-blue) printf '94' ;;
    bright-magenta) printf '95' ;;
    bright-cyan) printf '96' ;;
    bright-white) printf '97' ;;
    orange) printf '33' ;;
    purple) printf '35' ;;
    default) printf '39' ;;
    *) printf '36' ;;
  esac
}

resolve_color() {
  local color_name="${1:-${ASCIIFLOW_COLOR_DEFAULT:-cyan}}"
  if [[ "$color_name" == "" ]]; then
    printf '%s' "$(resolve_basic_color cyan)"
    return
  fi

  case "$color_name" in
    black|red|green|yellow|blue|magenta|cyan|white|gray|orange|purple|default|bright-red|bright-green|bright-yellow|bright-blue|bright-magenta|bright-cyan|bright-white)
      printf '%s' "$(resolve_basic_color "$color_name")"
      ;;
    *)
      printf '%s' "$(resolve_basic_color cyan)"
      ;;
  esac
}

detect_color_capabilities() {
  if [[ "${NO_COLOR:-0}" == "1" || "${ASCIIFLOW_NO_COLOR:-0}" == "1" ]]; then
    ASCIIFLOW_USE_COLOR=0
    ASCIIFLOW_COLOR_DEPTH=0
    return
  fi

  if [[ ! -t 1 ]]; then
    ASCIIFLOW_USE_COLOR=0
    ASCIIFLOW_COLOR_DEPTH=0
    return
  fi

  if [[ -n "${TERM:-}" ]] && [[ "$TERM" == "dumb" ]]; then
    ASCIIFLOW_USE_COLOR=0
    ASCIIFLOW_COLOR_DEPTH=0
    return
  fi

  local colors=8
  if command -v tput >/dev/null 2>&1; then
    colors="$(tput colors 2>/dev/null || printf '8')"
  fi

  if [[ "$colors" =~ ^[0-9]+$ ]]; then
    ASCIIFLOW_COLOR_DEPTH="$colors"
  else
    ASCIIFLOW_COLOR_DEPTH=8
  fi

  if (( ASCIIFLOW_COLOR_DEPTH < 8 )); then
    ASCIIFLOW_USE_COLOR=0
  fi
}

gradient_palette() {
  local preset="$1"
  case "$preset" in
    sunset) printf '%s' '255:95:31 255:158:64 255:199:88 124:211:242 59:130:246 91:33:182' ;;
    ocean) printf '%s' '11:94:214 30:144:255 22:163:74 34:197:94 125:211:252 14:116:144' ;;
    aurora) printf '%s' '16:185:129 52:211:153 45:212:191 59:130:246 168:85:247 192:132:252' ;;
    fire) printf '%s' '255:87:34 255:140:0 255:193:7 249:115:22 239:68:68 190:24:93' ;;
    neon) printf '%s' '34:211:238 59:130:246 168:85:247 236:72:153 244:114:182 250:204:21' ;;
    purple) printf '%s' '88:28:135 147:51:234 168:85:247 192:132:252 216:180:254 244:114:182' ;;
    *) printf '%s' '255:95:31 255:158:64 255:199:88 124:211:242 59:130:246 91:33:182' ;;
  esac
}

gradient_color_for_index() {
  local index="$1"
  local total="${2:-1}"
  local preset="${3:-sunset}"
  local color_values
  local -a palette=()
  local ratio
  local segment
  local fraction
  local r1 g1 b1 r2 g2 b2
  local r g b
  local ansi_code

  color_values="$(gradient_palette "$preset")"
  read -r -a palette <<< "$color_values"

  if (( total <= 1 )); then
    ratio=0
  else
    ratio=$(awk -v i="$index" -v t="$total" 'BEGIN { printf "%.6f", i / (t - 1) }')
  fi

  local steps=$(( ${#palette[@]} - 1 ))
  local scaled
  scaled=$(awk -v r="$ratio" -v s="$steps" 'BEGIN { printf "%.6f", r * s }')
  segment=$(awk -v s="$scaled" 'BEGIN { printf "%d", int(s) }')
  if (( segment >= steps )); then segment=$((steps - 1)); fi
  fraction=$(awk -v s="$scaled" -v seg="$segment" 'BEGIN { printf "%.6f", s - seg }')

  IFS=':' read -r r1 g1 b1 <<< "${palette[$segment]}"
  IFS=':' read -r r2 g2 b2 <<< "${palette[$((segment + 1))]}"

  r=$(awk -v a="$r1" -v b="$r2" -v f="$fraction" 'BEGIN { printf "%d", a + (b - a) * f }')
  g=$(awk -v a="$g1" -v b="$g2" -v f="$fraction" 'BEGIN { printf "%d", a + (b - a) * f }')
  b=$(awk -v a="$b1" -v b="$b2" -v f="$fraction" 'BEGIN { printf "%d", a + (b - a) * f }')

  if (( ASCIIFLOW_USE_COLOR == 0 )); then
    printf ''
    return
  fi

  if (( ASCIIFLOW_COLOR_DEPTH >= 256 )); then
    ansi_code=$(rgb_to_ansi256 "$r" "$g" "$b")
    printf '\033[38;5;%sm' "$ansi_code"
  else
    printf '\033[38;2;%s;%s;%sm' "$r" "$g" "$b"
  fi
}

apply_color_to_line() {
  local line="$1"
  local color_name="${2:-${ASCIIFLOW_COLOR_DEFAULT:-cyan}}"
  local gradient_name="${3:-}"
  local char_index=0
  local total_chars
  local out=""
  local ch=""
  local color_code=""

  total_chars=${#line}
  if [[ -n "$gradient_name" ]]; then
    for ((i=0; i<${#line}; i++)); do
      ch="${line:i:1}"
      if [[ "$ch" == " " ]]; then
        out+=" "
      else
        color_code="$(gradient_color_for_index "$char_index" "$total_chars" "$gradient_name")"
        out+="${color_code}${ch}"
        char_index=$((char_index + 1))
      fi
    done
    printf '%s' "$out"
    return
  fi

  color_code="$(ansi_escape "$(resolve_color "$color_name")")"
  if [[ "$color_code" == "" ]]; then
    printf '%s' "$line"
    return
  fi

  for ((i=0; i<${#line}; i++)); do
    ch="${line:i:1}"
    if [[ "$ch" == " " ]]; then
      out+=" "
    else
      out+="${color_code}${ch}"
    fi
  done
  printf '%s' "$out"
}

reset_color() {
  if (( ASCIIFLOW_USE_COLOR == 0 )); then
    printf ''
  else
    printf '\033[0m'
  fi
}
