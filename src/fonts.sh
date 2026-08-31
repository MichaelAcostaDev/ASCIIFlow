#!/usr/bin/env bash
set -Eeuo pipefail

# Font loader and management
# Loads multi-line ASCII glyphs from font files

declare -g FONTS_DIR="${ASCIIFLOW_ROOT}/fonts"
declare -gA FONT_GLYPHS=()  # Stores: "fontname_character" => glyph content
declare -ga FONT_LOADED_LIST=()  # Tracks which fonts are loaded

# Trim whitespace and carriage returns from string
trim_string() {
  local str="$1"
  str="${str%$'\r'}"  # Remove trailing CR
  str="${str%$'\n'}"  # Remove trailing LF
  str="${str#${str%%[![:space:]]*}}"  # Remove leading spaces
  str="${str%${str##*[![:space:]]}}"  # Remove trailing spaces
  printf '%s' "$str"
}

# Load a font file into cache
load_font() {
  local font_name="$1"
  local font_file="$FONTS_DIR/${font_name}.font"
  
  if [[ ! -f "$font_file" ]]; then
    printf 'Error: Font file not found: %s\n' "$font_file" >&2
    return 1
  fi
  
  # Check if already loaded
  for loaded in "${FONT_LOADED_LIST[@]}"; do
    if [[ "$loaded" == "$font_name" ]]; then
      return 0
    fi
  done
  
  # Read and parse the font file
  local current_char=""
  local current_glyph=""
  
  while IFS= read -r line || [[ -n "$line" ]]; do
    # Remove Windows line endings
    line="${line%$'\r'}"
    
    # Skip empty lines and comments
    if [[ -z "$line" ]] || [[ "$line" == \#* ]]; then
      continue
    fi
    
    # Character definition line
    if [[ "$line" =~ ^@(.+)$ ]]; then
      # Save previous glyph if any
      if [[ -n "$current_char" ]]; then
        FONT_GLYPHS["${font_name}_${current_char}"]="$current_glyph"
      fi
      
      current_char="${BASH_REMATCH[1]}"
      current_char=$(trim_string "$current_char")
      current_glyph=""
      continue
    fi
    
    # Glyph content line
    if [[ -n "$current_char" ]]; then
      if [[ -z "$current_glyph" ]]; then
        current_glyph="$line"
      else
        current_glyph+=$'\n'"$line"
      fi
    fi
  done < "$font_file"
  
  # Save last glyph
  if [[ -n "$current_char" ]]; then
    FONT_GLYPHS["${font_name}_${current_char}"]="$current_glyph"
  fi
  
  # Mark as loaded
  FONT_LOADED_LIST+=("$font_name")
}

# Get glyph for a character
get_glyph() {
  local char="$1"
  local font_name="${2:-block}"
  
  # Normalize to uppercase
  char="${char^^}"
  
  # Handle space
  if [[ "$char" == " " ]]; then
    char="SPACE"
  fi
  
  # Load font if not already loaded
  load_font "$font_name" || return 1
  
  # Try to get the glyph
  local key="${font_name}_${char}"
  if [[ -n "${FONT_GLYPHS[$key]:-}" ]]; then
    printf '%s' "${FONT_GLYPHS[$key]}"
    return 0
  fi
  
  # Fallback to question mark
  key="${font_name}_?"
  if [[ -n "${FONT_GLYPHS[$key]:-}" ]]; then
    printf '%s' "${FONT_GLYPHS[$key]}"
    return 0
  fi
  
  # No glyph found
  return 1
}

# Get list of available fonts
get_available_fonts() {
  local font_file
  
  if [[ ! -d "$FONTS_DIR" ]]; then
    return
  fi
  
  for font_file in "$FONTS_DIR"/*.font; do
    if [[ -f "$font_file" ]]; then
      basename "$font_file" .font
    fi
  done | sort
}

# Get the height of glyphs in a font
get_font_height() {
  local font_name="${1:-block}"
  local test_glyph
  
  test_glyph=$(get_glyph "A" "$font_name" 2>/dev/null || printf '')
  
  if [[ -z "$test_glyph" ]]; then
    printf '6'
    return 0
  fi
  
  # Count the number of lines
  local line_count
  line_count=$(echo "$test_glyph" | wc -l)
  printf '%s' "$((line_count))"
}

# Get glyph width (character cell width)
get_glyph_width() {
  local glyph="$1"
  local first_line
  
  first_line=$(printf '%s' "$glyph" | head -n 1)
  printf '%s' "${#first_line}"
}
