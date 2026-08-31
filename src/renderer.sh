#!/usr/bin/env bash
set -Eeuo pipefail

# Core ASCII rendering engine
# Composes multi-line glyphs horizontally to create banners

source "${ASCIIFLOW_ROOT}/src/fonts.sh"

# Render text with a given font
# Arguments: text, font_name
# Output: multi-line banner
render_text() {
  local text="$1"
  local font_name="${2:-block}"
  local height
  local i j char glyph
  local -a line1 line2 line3 line4 line5 line6 line7
  
  # Get font height
  height=$(get_font_height "$font_name")
  
  # Process each character
  for ((i=0; i<${#text}; i++)); do
    char="${text:i:1}"
    
    # Get the glyph
    if [[ "$char" == " " ]]; then
      # Add spacing for spaces
      for ((j=1; j<=height; j++)); do
        eval "line${j}+=('   ')"
      done
      continue
    fi
    
    glyph=$(get_glyph "$char" "$font_name" 2>/dev/null || get_glyph "?" "$font_name" 2>/dev/null || echo "")
    
    if [[ -z "$glyph" ]]; then
      # Add blank space
      for ((j=1; j<=height; j++)); do
        eval "line${j}+=('   ')"
      done
      continue
    fi
    
    # Split glyph into lines and add to output
    local -a glyph_arr=()
    while IFS= read -r gline; do
      glyph_arr+=("$gline")
    done <<< "$glyph"
    
    for ((j=0; j<height; j++)); do
      if [[ $j -lt ${#glyph_arr[@]} ]]; then
        eval "line$((j+1))+=('${glyph_arr[$j]}')"
      else
        eval "line$((j+1))+=('  ')"
      fi
    done
    
    # Add space between characters
    for ((j=1; j<=height; j++)); do
      eval "line${j}+=(' ')"
    done
  done
  
  # Output all lines
  for ((i=1; i<=height; i++)); do
    local -n line_var="line$i"
    printf '%s\n' "${line_var[*]}"
  done
}

# Render text with a color (simple implementation)
# Arguments: text, font_name, color
render_colored() {
  local text="$1"
  local font_name="${2:-block}"
  local color="${3:-}"
  local output
  local line
  
  output=$(render_text "$text" "$font_name")
  
  if [[ -n "$color" ]]; then
    # Apply color if colors are supported and not disabled
    if [[ -z "${NO_COLOR:-}" ]] && [[ -t 1 ]]; then
      case "$color" in
        red) color_code=31 ;;
        green) color_code=32 ;;
        yellow) color_code=33 ;;
        blue) color_code=34 ;;
        magenta) color_code=35 ;;
        cyan) color_code=36 ;;
        white) color_code=37 ;;
        *) color_code=36 ;; # default to cyan
      esac
      
      # Apply color to output
      while IFS= read -r line; do
        printf '\033[%sm%s\033[0m\n' "$color_code" "$line"
      done <<< "$output"
    else
      printf '%s\n' "$output"
    fi
  else
    printf '%s\n' "$output"
  fi
}

# Get terminal width
get_terminal_width() {
  if [[ -t 1 ]]; then
    # Try to get actual terminal width
    if command -v tput &>/dev/null; then
      tput cols
    elif [[ -n "${COLUMNS:-}" ]]; then
      printf '%s' "$COLUMNS"
    else
      printf '80'  # Default fallback
    fi
  else
    printf '80'
  fi
}

# Check if text will fit in terminal
will_fit_in_terminal() {
  local text="$1"
  local font_name="${2:-block}"
  local width
  local max_width
  
  width=$(render_text "$text" "$font_name" | head -1 | wc -c)
  max_width=$(get_terminal_width)
  
  if [[ $width -le $max_width ]]; then
    return 0
  else
    return 1
  fi
}
