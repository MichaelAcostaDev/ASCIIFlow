#!/usr/bin/env bash
set -Eeuo pipefail

declare -A FONT_5X7=(
  [SPACE]=$'00000\n00000\n00000\n00000\n00000\n00000\n00000'
  [A]=$'01110\n10001\n10001\n11111\n10001\n10001\n10001'
  [B]=$'11110\n10001\n10001\n11110\n10001\n10001\n11110'
  [C]=$'01110\n10001\n10000\n10000\n10000\n10001\n01110'
  [D]=$'11110\n10001\n10001\n10001\n10001\n10001\n11110'
  [E]=$'11111\n10000\n10000\n11110\n10000\n10000\n11111'
  [F]=$'11111\n10000\n10000\n11110\n10000\n10000\n10000'
  [G]=$'01110\n10001\n10000\n10111\n10001\n10001\n01110'
  [H]=$'10001\n10001\n10001\n11111\n10001\n10001\n10001'
  [I]=$'01110\n00100\n00100\n00100\n00100\n00100\n01110'
  [J]=$'00111\n00010\n00010\n00010\n10010\n10010\n01100'
  [K]=$'10001\n10010\n10100\n11000\n10100\n10010\n10001'
  [L]=$'10000\n10000\n10000\n10000\n10000\n10000\n11111'
  [M]=$'10001\n11011\n10101\n10001\n10001\n10001\n10001'
  [N]=$'10001\n11001\n10101\n10011\n10001\n10001\n10001'
  [O]=$'01110\n10001\n10001\n10001\n10001\n10001\n01110'
  [P]=$'11110\n10001\n10001\n11110\n10000\n10000\n10000'
  [Q]=$'01110\n10001\n10001\n10001\n10101\n10010\n01101'
  [R]=$'11110\n10001\n10001\n11110\n10100\n10010\n10001'
  [S]=$'01111\n10000\n10000\n01110\n00001\n00001\n11110'
  [T]=$'11111\n00100\n00100\n00100\n00100\n00100\n00100'
  [U]=$'10001\n10001\n10001\n10001\n10001\n10001\n01110'
  [V]=$'10001\n10001\n10001\n10001\n10001\n01010\n00100'
  [W]=$'10001\n10001\n10001\n10101\n10101\n10101\n01010'
  [X]=$'10001\n10001\n01010\n00100\n01010\n10001\n10001'
  [Y]=$'10001\n10001\n01010\n00100\n00100\n00100\n00100'
  [Z]=$'11111\n00001\n00010\n00100\n01000\n10000\n11111'
  [ZERO]=$'01110\n10001\n10011\n10101\n11001\n10001\n01110'
  [ONE]=$'00100\n01100\n00100\n00100\n00100\n00100\n01110'
  [TWO]=$'01110\n10001\n00001\n00010\n00100\n01000\n11111'
  [THREE]=$'11110\n00001\n00001\n01110\n00001\n00001\n11110'
  [FOUR]=$'00010\n00110\n01010\n10010\n11111\n00010\n00010'
  [FIVE]=$'11111\n10000\n10000\n11110\n00001\n00001\n11110'
  [SIX]=$'01110\n10000\n10000\n11110\n10001\n10001\n01110'
  [SEVEN]=$'11111\n00001\n00010\n00100\n01000\n01000\n01000'
  [EIGHT]=$'01110\n10001\n10001\n01110\n10001\n10001\n01110'
  [NINE]=$'01110\n10001\n10001\n01111\n00001\n00001\n01110'
  [DASH]=$'00000\n00000\n00000\n11111\n00000\n00000\n00000'
  [DOT]=$'00000\n00000\n00000\n00000\n00000\n00110\n00110'
  [COLON]=$'00000\n00110\n00110\n00000\n00110\n00110\n00000'
  [EXCLAMATION]=$'00100\n00100\n00100\n00100\n00100\n00000\n00100'
  [QUESTION]=$'01110\n10001\n00001\n00010\n00100\n00000\n00100'
  [SLASH]=$'00001\n00010\n00100\n01000\n10000\n00000\n00000'
  [AMPERSAND]=$'01110\n10001\n10001\n01110\n10101\n10001\n01010'
  [APOSTROPHE]=$'00100\n00100\n00000\n00000\n00000\n00000\n00000'
  [DOLLAR]=$'00100\n00100\n01110\n00100\n01110\n00100\n00100'
)

declare -A FONT_3X5=(
  [SPACE]=$'000\n000\n000\n000\n000'
  [A]=$'011\n101\n101\n111\n101'
  [B]=$'110\n101\n110\n101\n110'
  [C]=$'011\n100\n100\n100\n011'
  [D]=$'110\n101\n101\n101\n110'
  [E]=$'111\n100\n110\n100\n111'
  [F]=$'111\n100\n110\n100\n100'
  [G]=$'011\n100\n101\n101\n011'
  [H]=$'101\n101\n111\n101\n101'
  [I]=$'111\n010\n010\n010\n111'
  [J]=$'011\n001\n001\n101\n010'
  [K]=$'101\n110\n100\n110\n101'
  [L]=$'100\n100\n100\n100\n111'
  [M]=$'101\n111\n101\n101\n101'
  [N]=$'101\n111\n111\n101\n101'
  [O]=$'010\n101\n101\n101\n010'
  [P]=$'110\n101\n110\n100\n100'
  [Q]=$'010\n101\n101\n011\n001'
  [R]=$'110\n101\n110\n101\n101'
  [S]=$'011\n100\n010\n001\n110'
  [T]=$'111\n010\n010\n010\n010'
  [U]=$'101\n101\n101\n101\n010'
  [V]=$'101\n101\n101\n010\n010'
  [W]=$'101\n101\n101\n111\n101'
  [X]=$'101\n101\n010\n101\n101'
  [Y]=$'101\n101\n010\n010\n010'
  [Z]=$'111\n001\n010\n100\n111'
  [ZERO]=$'010\n101\n101\n101\n010'
  [ONE]=$'001\n011\n001\n001\n011'
  [TWO]=$'010\n101\n001\n010\n111'
  [THREE]=$'111\n001\n010\n001\n111'
  [FOUR]=$'001\n011\n101\n111\n001'
  [FIVE]=$'111\n100\n110\n001\n110'
  [SIX]=$'010\n100\n110\n101\n010'
  [SEVEN]=$'111\n001\n010\n100\n100'
  [EIGHT]=$'010\n101\n010\n101\n010'
  [NINE]=$'010\n101\n011\n001\n010'
  [DASH]=$'000\n000\n111\n000\n000'
  [DOT]=$'000\n000\n000\n010\n010'
  [EXCLAMATION]=$'010\n010\n010\n000\n010'
  [QUESTION]=$'010\n101\n001\n010\n000'
  [SLASH]=$'001\n010\n100\n000\n000'
)

font_key_for_char() {
  local ch="$1"
  local upper="${ch^^}"

  case "$upper" in
    " ") printf '%s' "SPACE" ;;
    "'") printf '%s' "APOSTROPHE" ;;
    "/") printf '%s' "SLASH" ;;
    ".") printf '%s' "DOT" ;;
    ":") printf '%s' "COLON" ;;
    "!") printf '%s' "EXCLAMATION" ;;
    "?") printf '%s' "QUESTION" ;;
    "-") printf '%s' "DASH" ;;
    "&") printf '%s' "AMPERSAND" ;;
    "0") printf '%s' "ZERO" ;;
    "1") printf '%s' "ONE" ;;
    "2") printf '%s' "TWO" ;;
    "3") printf '%s' "THREE" ;;
    "4") printf '%s' "FOUR" ;;
    "5") printf '%s' "FIVE" ;;
    "6") printf '%s' "SIX" ;;
    "7") printf '%s' "SEVEN" ;;
    "8") printf '%s' "EIGHT" ;;
    "9") printf '%s' "NINE" ;;
    *) printf '%s' "$upper" ;;
  esac
}

font_pattern() {
  local char="$1"
  local style="${2:-block}"
  local key
  key="$(font_key_for_char "$char")"

  case "$style" in
    block|banner|shadow|digital)
      printf '%s' "${FONT_5X7[$key]:-${FONT_5X7[SPACE]}}"
      ;;
    small|minimal)
      printf '%s' "${FONT_3X5[$key]:-${FONT_3X5[SPACE]}}"
      ;;
    slant)
      local pattern="${FONT_5X7[$key]:-${FONT_5X7[SPACE]}}"
      pattern="${pattern//1//}"
      pattern="${pattern//0/ }"
      printf '%s' "$pattern"
      ;;
    *)
      printf '%s' "${FONT_5X7[$key]:-${FONT_5X7[SPACE]}}"
      ;;
  esac
}

render_char_pattern() {
  local char="$1"
  local style="$2"
  local pattern
  local output=""
  local line
  local rows=()

  pattern="$(font_pattern "$char" "$style")"
  IFS=$'\n' read -r -a rows <<< "$pattern"

  for line in "${rows[@]}"; do
    case "$style" in
      block|banner|shadow)
        line="${line//1/#}"
        line="${line//0/ }"
        ;;
      digital)
        line="${line//1/█}"
        line="${line//0/ }"
        ;;
      slant)
        line="${line//1//}"
        line="${line//0/ }"
        ;;
      small|minimal)
        line="${line//1/#}"
        line="${line//0/ }"
        ;;
      *)
        line="${line//1/#}"
        line="${line//0/ }"
        ;;
    esac
    output+="${line}"$'\n'
  done

  printf '%s' "$output"
}

render_style_text() {
  local text="$1"
  local style="${2:-block}"
  local char
  local pattern
  local -a combined=()
  local -a rows=()
  local i
  local row

  for ((i=0; i<${#text}; i++)); do
    char="${text:i:1}"
    pattern="$(render_char_pattern "$char" "$style")"
    IFS=$'\n' read -r -a rows <<< "$pattern"
    for row in "${!rows[@]}"; do
      combined[$row]="${combined[$row]:-}${rows[$row]} "
    done
  done

  printf '%s\n' "${combined[@]}"
}

render_banner() {
  local text="$1"
  local style="${2:-block}"
  local color="${3:-cyan}"
  local gradient="${4:-}"
  local style_text
  local line
  local output=()

  style_text="$(render_style_text "$text" "$style")"
  IFS=$'\n' read -r -a output <<< "$style_text"

  if [[ -n "$gradient" ]]; then
    for line in "${output[@]}"; do
      printf '%s\n' "$(apply_color_to_line "$line" "$color" "$gradient")"
    done
    return
  fi

  for line in "${output[@]}"; do
    printf '%s\n' "$(apply_color_to_line "$line" "$color" "")"
  done
}

list_styles() {
  printf 'Available styles:\n'
  printf '  block\n  small\n  minimal\n  banner\n  slant\n  shadow\n  digital\n'
}

preview_styles() {
  local style
  for style in block small minimal banner slant shadow digital; do
    printf '\n[%s]\n' "$style"
    render_banner "ASCIIFlow" "$style" cyan ""
  done
}
