#!/bin/bash
set -Eeuo pipefail

ASCIIFLOW_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

declare -g FONTS_DIR="$ASCIIFLOW_ROOT/fonts"
declare -gA FONT_GLYPHS=()
declare -ga FONT_LOADED_LIST=()

load_font() {
  local font_name="$1"
  local font_file="$FONTS_DIR/${font_name}.font"
  
  echo "DEBUG: Loading font $font_name from $font_file" >&2
  
  if [[ ! -f "$font_file" ]]; then
    echo "DEBUG: Font file not found" >&2
    return 1
  fi
  
  local current_char=""
  local current_glyph=""
  local line_num=0
  
  while IFS= read -r line || [[ -n "$line" ]]; do
    ((line_num++))
    
    if [[ -z "$line" ]] || [[ "$line" == \#* ]]; then
      continue
    fi
    
    if [[ "$line" =~ ^@(.+)$ ]]; then
      if [[ -n "$current_char" ]]; then
        FONT_GLYPHS["${font_name}_${current_char}"]="$current_glyph"
        echo "DEBUG: Stored glyph for '$current_char' (length: ${#current_glyph})" >&2
      fi
      
      current_char="${BASH_REMATCH[1]}"
      current_glyph=""
      echo "DEBUG: Found char marker for '$current_char'" >&2
      continue
    fi
    
    if [[ -n "$current_char" ]]; then
      if [[ -z "$current_glyph" ]]; then
        current_glyph="$line"
      else
        current_glyph+=$'\n'"$line"
      fi
    fi
  done < "$font_file"
  
  if [[ -n "$current_char" ]]; then
    FONT_GLYPHS["${font_name}_${current_char}"]="$current_glyph"
    echo "DEBUG: Stored final glyph for '$current_char'" >&2
  fi
  
  FONT_LOADED_LIST+=("$font_name")
  echo "DEBUG: Font $font_name loaded. Total glyphs: ${#FONT_GLYPHS[@]}" >&2
}

get_glyph() {
  local char="$1"
  local font_name="${2:-block}"
  
  echo "DEBUG: get_glyph called with char='$char', font='$font_name'" >&2
  
  char="${char^^}"
  
  if [[ "$char" == " " ]]; then
    char="SPACE"
  fi
  
  echo "DEBUG: Normalized char to '$char'" >&2
  
  load_font "$font_name" || {
    echo "DEBUG: Failed to load font" >&2
    return 1
  }
  
  local key="${font_name}_${char}"
  echo "DEBUG: Looking for key '$key'" >&2
  echo "DEBUG: All keys in FONT_GLYPHS:" >&2
  for k in "${!FONT_GLYPHS[@]}"; do
    echo "DEBUG:   Key (first 30 chars): ${k:0:30}" >&2
  done | head -10
  
  if [[ -n "${FONT_GLYPHS[$key]:-}" ]]; then
    echo "DEBUG: Found glyph for $key!" >&2
    printf '%s' "${FONT_GLYPHS[$key]}"
    return 0
  fi
  
  echo "DEBUG: Not found, trying fallback" >&2
  key="${font_name}_?"
  if [[ -n "${FONT_GLYPHS[$key]:-}" ]]; then
    printf '%s' "${FONT_GLYPHS[$key]}"
    return 0
  fi
  
  echo "DEBUG: get_glyph failed" >&2
  return 1
}

echo "=== Testing ==="
result=$(get_glyph "A" "block" 2>/dev/null || echo "FAILED")
echo "Result: $result"
