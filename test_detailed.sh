#!/bin/bash
# More detailed debugging

ASCIIFLOW_ROOT="/mnt/c/Users/micha/OneDrive/Escritorio/programacion/Linux/ASCIIFlow"
FONTS_DIR="$ASCIIFLOW_ROOT/fonts"

declare -gA FONT_GLYPHS=()

# Test font loading with detailed output
load_font_debug() {
  local font_name="$1"
  local font_file="$FONTS_DIR/${font_name}.font"
  
  local current_char=""
  local current_glyph=""
  local char_count=0
  
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ -z "$line" ]] || [[ "$line" == \#* ]]; then
      continue
    fi
    
    if [[ "$line" =~ ^@(.+)$ ]]; then
      if [[ -n "$current_char" ]]; then
        FONT_GLYPHS["${font_name}_${current_char}"]="$current_glyph"
        echo "Stored: font_name='$font_name', char='$current_char'" >&2
      fi
      
      current_char="${BASH_REMATCH[1]}"
      current_glyph=""
      ((char_count++))
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
    echo "Stored final: font_name='$font_name', char='$current_char'" >&2
  fi
  
  echo "Parsed $char_count characters" >&2
}

load_font_debug "block"

echo "" >&2
echo "=== Checking what's actually in the array ===" >&2
echo "Total entries: ${#FONT_GLYPHS[@]}" >&2

# Print each key
echo "" >&2
echo "First 5 keys:" >&2
i=0
for key in "${!FONT_GLYPHS[@]}"; do
  echo "  Key #$i: $key (length: ${#FONT_GLYPHS[$key]})" >&2
  ((i++))
  if [[ $i -ge 5 ]]; then
    break
  fi
done

# Try to find block_A specifically
echo "" >&2
echo "Looking for 'block_A':" >&2
if [[ -n "${FONT_GLYPHS[block_A]:-}" ]]; then
  echo "  FOUND!" >&2
  echo "  Length: ${#FONT_GLYPHS[block_A]}" >&2
else
  echo "  NOT FOUND" >&2
  echo "  Trying grep approach:" >&2
  for key in "${!FONT_GLYPHS[@]}"; do
    if [[ "$key" == "block_A" ]]; then
      echo "  Found it via grep!" >&2
    fi
  done
fi

# Try to find any key starting with block_
echo "" >&2
echo "Keys starting with 'block_':" >&2
for key in "${!FONT_GLYPHS[@]}"; do
  [[ "$key" == block_* ]] && echo "  $key" >&2
done | head -5
