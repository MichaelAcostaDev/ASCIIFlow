#!/bin/bash
set -Eeuo pipefail

ASCIIFLOW_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ASCIIFLOW_ROOT"

# Manual test of font loading
declare -gA FONT_CACHE=()
FONTS_DIR="$ASCIIFLOW_ROOT/fonts"

echo "=== Manual Font Loading Debug ==="
echo "FONTS_DIR: $FONTS_DIR"

# Manually read the file
font_file="$FONTS_DIR/block.font"
echo "Font file: $font_file"
echo ""

# Check first few lines
echo "First 20 lines of block.font:"
head -20 "$font_file"
echo ""

# Now try to parse it manually
echo "=== Manual Parsing ===" 
current_char=""
current_glyph=""

while IFS= read -r line || [[ -n "$line" ]]; do
  if [[ -z "$line" ]] || [[ "$line" == \#* ]]; then
    continue
  fi
  
  if [[ "$line" =~ ^@(.+)$ ]]; then
    if [[ -n "$current_char" ]]; then
      echo "Storing: FONT_CACHE[block:$current_char]"
      FONT_CACHE["block:${current_char}"]="$current_glyph"
    fi
    current_char="${BASH_REMATCH[1]}"
    current_glyph=""
    echo "Found character: $current_char"
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

# Save last glyph
if [[ -n "$current_char" ]]; then
  echo "Storing final: FONT_CACHE[block:$current_char]"
  FONT_CACHE["block:${current_char}"]="$current_glyph"
fi

echo ""
echo "=== Cache Contents ===" 
echo "Total cache entries: ${#FONT_CACHE[@]}"
for key in "${!FONT_CACHE[@]}"; do
  echo "Key: $key (Length: ${#FONT_CACHE[$key]})"
done

echo ""
echo "=== Attempting to retrieve A ===" 
retrieved_glyph="${FONT_CACHE['block:A']:-NOT FOUND}"
echo "Retrieved glyph for A: [$retrieved_glyph]"
