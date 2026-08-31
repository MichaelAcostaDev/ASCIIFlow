#!/bin/bash
set -Eeuo pipefail

ASCIIFLOW_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ASCIIFLOW_ROOT"

source "${ASCIIFLOW_ROOT}/src/fonts.sh"

echo "=== Testing font engine ==="
echo ""

echo "1. Getting glyph for A:"
if glyph=$(get_glyph "A" "block" 2>&1); then
  echo "SUCCESS - got glyph"
  echo "Glyph length: ${#glyph}"
  echo "Glyph content:"
  echo "$glyph"
else
  echo "FAILED - no glyph"
  echo "Error: $glyph"
fi

echo ""
echo "2. Getting available fonts:"
get_available_fonts

echo ""
echo "3. Getting font height:"
height=$(get_font_height "block")
echo "Block font height: $height"
