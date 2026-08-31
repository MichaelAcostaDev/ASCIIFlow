#!/bin/bash
# Minimal test - no error checking

ASCIIFLOW_ROOT="/mnt/c/Users/micha/OneDrive/Escritorio/programacion/Linux/ASCIIFlow"
FONTS_DIR="$ASCIIFLOW_ROOT/fonts"

declare -gA FONT_GLYPHS=()
declare -ga FONT_LOADED_LIST=()

load_font() {
  local font_name="$1"
  local font_file="$FONTS_DIR/${font_name}.font"
  
  echo "Loading font: $font_name" >&2
  
  if [[ ! -f "$font_file" ]]; then
    echo "Font file not found: $font_file" >&2
    return 1
  fi
  
  local current_char=""
  local current_glyph=""
  
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ -z "$line" ]] || [[ "$line" == \#* ]]; then
      continue
    fi
    
    if [[ "$line" =~ ^@(.+)$ ]]; then
      if [[ -n "$current_char" ]]; then
        FONT_GLYPHS["${font_name}_${current_char}"]="$current_glyph"
      fi
      
      current_char="${BASH_REMATCH[1]}"
      current_glyph=""
      echo "Found character: $current_char" >&2
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
  fi
  
  FONT_LOADED_LIST+=("$font_name")
  echo "Font loaded. Cache size: ${#FONT_GLYPHS[@]}" >&2
}

get_glyph() {
  local char="$1"
  local font_name="${2:-block}"
  
  char="${char^^}"
  
  if [[ "$char" == " " ]]; then
    char="SPACE"
  fi
  
  load_font "$font_name"
  
  local key="${font_name}_${char}"
  echo "Looking for key: $key" >&2
  echo "Cache has: ${#FONT_GLYPHS[@]} entries" >&2
  
  if [[ -n "${FONT_GLYPHS[$key]:-}" ]]; then
    printf '%s' "${FONT_GLYPHS[$key]}"
    return 0
  fi
  
  key="${font_name}_?"
  if [[ -n "${FONT_GLYPHS[$key]:-}" ]]; then
    printf '%s' "${FONT_GLYPHS[$key]}"
    return 0
  fi
  
  echo "Glyph not found!" >&2
  return 1
}

echo "=== Test ===" >&2
glyph=$(get_glyph "A" "block" 2>&1)
exit_code=$?

echo "Exit code: $exit_code" >&2
echo "Glyph output length: ${#glyph}" >&2
echo "Glyph output:" >&2
echo "$glyph" >&2
