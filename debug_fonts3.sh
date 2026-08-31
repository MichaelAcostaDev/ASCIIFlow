#!/bin/bash
set -Eeuo pipefail

ASCIIFLOW_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ASCIIFLOW_ROOT"

# Direct test without using the module
declare -gA FONT_CACHE=()
FONTS_DIR="$ASCIIFLOW_ROOT/fonts"

load_font() {
  local font_name="$1"
  local font_file="$FONTS_DIR/${font_name}.font"
  
  echo "Loading font: $font_name from $font_file"
  
  local current_char=""
  local current_glyph=""
  
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ -z "$line" ]] || [[ "$line" == \#* ]]; then
      continue
    fi
    
    if [[ "$line" =~ ^@(.+)$ ]]; then
      if [[ -n "$current_char" ]]; then
        FONT_CACHE["${font_name}:${current_char}"]="$current_glyph"
        echo "Stored glyph for $current_char (length: ${#current_glyph})"
      fi
      
      current_char="${BASH_REMATCH[1]}"
      current_glyph=""
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
    FONT_CACHE["${font_name}:${current_char}"]="$current_glyph"
    echo "Stored final glyph for $current_char (length: ${#current_glyph})"
  fi
}

echo "=== Loading font ==="
load_font "block"

echo ""
echo "=== Cache contents ==="
echo "Total entries: ${#FONT_CACHE[@]}"

echo ""
echo "=== Checking for A ==="
if [[ -v FONT_CACHE["block:A"] ]]; then
  echo "FOUND: block:A"
  echo "Content length: ${#FONT_CACHE[block:A]}"
  echo "First 50 chars: ${FONT_CACHE[block:A]:0:50}"
else
  echo "NOT FOUND: block:A"
fi

echo ""
echo "=== Checking first key ==="
first_key="${!FONT_CACHE[@]}"
echo "First key in array: $first_key"

echo ""
echo "=== All keys ==="
for key in "${!FONT_CACHE[@]}"; do
  echo "$key"
done | head -5
