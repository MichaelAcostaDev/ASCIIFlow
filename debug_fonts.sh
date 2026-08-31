#!/bin/bash
set -Eeuo pipefail

ASCIIFLOW_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ASCIIFLOW_ROOT"

# Load modules
source "${ASCIIFLOW_ROOT}/src/fonts.sh"

# Test 1: Check if font files exist
echo "=== Test 1: Font Files ==="
ls -la fonts/ || echo "No fonts directory"

# Test 2: Check if we can get available fonts
echo -e "\n=== Test 2: Available Fonts ===" 
get_available_fonts

# Test 3: Try to get a single glyph
echo -e "\n=== Test 3: Get Glyph A ===" 
glyph=$(get_glyph "A" "block" 2>&1 || echo "ERROR")
echo "Glyph result: [$glyph]"

# Test 4: Check font cache
echo -e "\n=== Test 4: Load Font ===" 
load_font "block" 2>&1 || echo "Load failed"
echo "Font loaded"

# Test 5: Get glyph again
echo -e "\n=== Test 5: Get Glyph After Load ===" 
glyph=$(get_glyph "A" "block" 2>&1 || echo "ERROR")
echo "Glyph result: [$glyph]"
