#!/bin/bash
set -Eeuo pipefail

ASCIIFLOW_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ASCIIFLOW_ROOT"

declare -gA FONT_CACHE=()
FONTS_DIR="$ASCIIFLOW_ROOT/fonts"

load_font() {
  local font_name="$1"
  local font_file="$FONTS_DIR/${font_name}.font"
  
  local current_char=""
  local current_glyph=""
  
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ -z "$line" ]] || [[ "$line" == \#* ]]; then
      continue
    fi
    
    if [[ "$line" =~ ^@(.+)$ ]]; then
      if [[ -n "$current_char" ]]; then
        FONT_CACHE["${font_name}:${current_char}"]="$current_glyph"
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
  fi
}

load_font "block"

echo "=== Testing retrieval ==="
echo "Total cache size: ${#FONT_CACHE[@]}"
echo ""

# Try different approaches
echo "1. Direct array access test:"
value="${FONT_CACHE[block:G]:-EMPTY}"
echo "block:G = length $( [[ "$value" != "EMPTY" ]] && echo ${#value} || echo "NOT FOUND")"

echo ""
echo "2. List all keys (first 10):"
i=0
for key in "${!FONT_CACHE[@]}"; do
  echo "Key $i: [Redacted - contains special chars], length: ${#FONT_CACHE[$key]}"
  ((i++))
  if [[ $i -ge 10 ]]; then
    break
  fi
done

echo ""
echo "3. Try to get specific font strings:"
echo "Total unique font prefixes:"
for key in "${!FONT_CACHE[@]}"; do
  echo "$key"
done | cut -d: -f1 | sort -u | wc -l

echo ""
echo "4. Try rendering directly:"
# Get the glyph for 'A' - let's construct the key safely
key_to_find="block:A"
if [[ -v FONT_CACHE["$key_to_find"] ]]; then
  glyph="${FONT_CACHE[$key_to_find]}"
  echo "Found A!"
  echo "$glyph"
else
  echo "A not found. Looking for alternative..."
  # Look for what we DO have
  for key in "${!FONT_CACHE[@]}"; do
    [[ "$key" == *":A" ]] && echo "Found key ending in :A: $key"
  done
fi
