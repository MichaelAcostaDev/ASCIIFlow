#!/usr/bin/env bash
set -Eeuo pipefail

# ASCIIFlow Test Suite - comprehensive tests for the ASCII rendering engine

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export ASCIIFLOW_ROOT="$PROJECT_ROOT"

# Source modules
source "${ASCIIFLOW_ROOT}/src/fonts.sh"
source "${ASCIIFLOW_ROOT}/src/renderer.sh"
source "${ASCIIFLOW_ROOT}/src/cli.sh"

# Colors for test output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Helper function to run a test
run_test() {
  local test_name="$1"
  local test_command="$2"
  
  ((TESTS_RUN++))
  
  if eval "$test_command" &>/dev/null; then
    printf "${GREEN}✓${NC} %s\n" "$test_name"
    ((TESTS_PASSED++))
    return 0
  else
    printf "${RED}✗${NC} %s\n" "$test_name"
    ((TESTS_FAILED++))
    return 1
  fi
}

# Helper to check if text exists in output
contains() {
  local haystack="$1"
  local needle="$2"
  echo "$haystack" | grep -q "$needle"
}

# ============ FONT LOADING TESTS ============
printf "\n${BLUE}=== Font Loading Tests ===${NC}\n"

run_test "Font files exist" "[[ -f '$ASCIIFLOW_ROOT/fonts/block.font' && -f '$ASCIIFLOW_ROOT/fonts/digital.font' && -f '$ASCIIFLOW_ROOT/fonts/banner.font' && -f '$ASCIIFLOW_ROOT/fonts/small.font' ]]"

# ============ GLYPH RETRIEVAL TESTS ============
printf "\n${BLUE}=== Glyph Retrieval Tests ===${NC}\n"

run_test "Get glyph for A (block)" "[[ -n \$(get_glyph 'A' 'block' 2>/dev/null) ]]"
run_test "Get glyph for B (block)" "[[ -n \$(get_glyph 'B' 'block' 2>/dev/null) ]]"
run_test "Get glyph for space (block)" "[[ -n \$(get_glyph ' ' 'block' 2>/dev/null) ]]"
run_test "Get glyph for 0 (block)" "[[ -n \$(get_glyph '0' 'block' 2>/dev/null) ]]"
run_test "Get glyph for 9 (block)" "[[ -n \$(get_glyph '9' 'block' 2>/dev/null) ]]"

# ============ SINGLE CHARACTER RENDERING TESTS ============
printf "\n${BLUE}=== Single Character Rendering ===${NC}\n"

local output_a
output_a=$(render_text "A" "block" 2>/dev/null || echo "")
run_test "Render A produces output" "[[ -n '$output_a' ]]"
run_test "Render A produces multiple lines" "[[ \$(echo '$output_a' | wc -l) -eq 6 ]]"

# ============ TEXT RENDERING TESTS ============
printf "\n${BLUE}=== Text Rendering Tests ===${NC}\n"

local output_hello
output_hello=$(render_text "HELLO" "block" 2>/dev/null || echo "")
run_test "Render HELLO produces output" "[[ -n '$output_hello' ]]"
run_test "Render HELLO produces 6 lines" "[[ \$(echo '$output_hello' | wc -l) -eq 6 ]]"

local output_world
output_world=$(render_text "WORLD" "block" 2>/dev/null || echo "")
run_test "Render WORLD produces output" "[[ -n '$output_world' ]]"

local output_asciiflow
output_asciiflow=$(render_text "ASCIIFlow" "block" 2>/dev/null || echo "")
run_test "Render ASCIIFlow produces output" "[[ -n '$output_asciiflow' ]]"

# ============ MULTIPLE FONT TESTS ============
printf "\n${BLUE}=== Multiple Font Rendering ===${NC}\n"

run_test "Render with digital font" "[[ -n \$(render_text 'A' 'digital' 2>/dev/null) ]]"
run_test "Render with banner font" "[[ -n \$(render_text 'A' 'banner' 2>/dev/null) ]]"
run_test "Render with small font" "[[ -n \$(render_text 'A' 'small' 2>/dev/null) ]]"

# Test that digital font produces different output than block
local digital_a
digital_a=$(render_text "A" "digital" 2>/dev/null || echo "")
run_test "Digital font produces different output than block" "[[ '$output_a' != '$digital_a' ]]"

# ============ SPACE HANDLING TESTS ============
printf "\n${BLUE}=== Space Handling Tests ===${NC}\n"

local output_space
output_space=$(render_text "HI THERE" "block" 2>/dev/null || echo "")
run_test "Text with spaces renders" "[[ -n '$output_space' ]]"
run_test "Text with spaces produces 6 lines" "[[ \$(echo '$output_space' | wc -l) -eq 6 ]]"

# ============ NUMBER RENDERING TESTS ============
printf "\n${BLUE}=== Number Rendering Tests ===${NC}\n"

local output_numbers
output_numbers=$(render_text "0123456789" "block" 2>/dev/null || echo "")
run_test "Render numbers produces output" "[[ -n '$output_numbers' ]]"
run_test "Render numbers produces 6 lines" "[[ \$(echo '$output_numbers' | wc -l) -eq 6 ]]"

# ============ SPECIAL CHARACTER TESTS ============
printf "\n${BLUE}=== Special Character Tests ===${NC}\n"

local output_special
output_special=$(render_text "A.B!" "block" 2>/dev/null || echo "")
run_test "Special characters render" "[[ -n '$output_special' ]]"

# ============ FONT HEIGHT DETECTION TESTS ============
printf "\n${BLUE}=== Font Height Detection ===${NC}\n"

run_test "Block font height is 6" "[[ \$(get_font_height 'block') -eq 6 ]]"
run_test "Banner font height is 5" "[[ \$(get_font_height 'banner') -eq 5 ]]"
run_test "Small font height is 5" "[[ \$(get_font_height 'small') -eq 5 ]]"
run_test "Digital font height is 5" "[[ \$(get_font_height 'digital') -eq 5 ]]"

# ============ TERMINAL WIDTH TESTS ============
printf "\n${BLUE}=== Terminal Width Detection ===${NC}\n"

run_test "Terminal width is positive" "[[ \$(get_terminal_width) -gt 0 ]]"
run_test "Terminal width is reasonable" "[[ \$(get_terminal_width) -gt 20 ]]"

# ============ CLI INTERFACE TESTS ============
printf "\n${BLUE}=== CLI Interface Tests ===${NC}\n"

# Test help
local help_output
help_output=$(cd "$PROJECT_ROOT" && bash asciiflow --help 2>&1 || echo "")
run_test "Help flag works" "[[ -n '$help_output' ]]"
run_test "Help contains 'Usage'" "$(contains '$help_output' 'Usage')"

# Test version
local version_output
version_output=$(cd "$PROJECT_ROOT" && bash asciiflow --version 2>&1 || echo "")
run_test "Version flag works" "[[ -n '$version_output' ]]"
run_test "Version contains 'ASCIIFlow'" "$(contains '$version_output' 'ASCIIFlow')"

# Test list
local list_output
list_output=$(cd "$PROJECT_ROOT" && bash asciiflow --list 2>&1 || echo "")
run_test "List flag works" "[[ -n '$list_output' ]]"
run_test "List contains 'block'" "$(contains '$list_output' 'block')"
run_test "List contains 'digital'" "$(contains '$list_output' 'digital')"

# Test rendering via CLI
local cli_output
cli_output=$(cd "$PROJECT_ROOT" && bash asciiflow "TEST" 2>&1 || echo "")
run_test "CLI rendering works" "[[ -n '$cli_output' ]]"

# Test font flag
local font_output
font_output=$(cd "$PROJECT_ROOT" && bash asciiflow -f digital "A" 2>&1 || echo "")
run_test "Font flag works" "[[ -n '$font_output' ]]"

# ============ EDGE CASES ============
printf "\n${BLUE}=== Edge Case Tests ===${NC}\n"

run_test "Uppercase and lowercase work" "[[ -n \$(render_text 'AaBbCc' 'block' 2>/dev/null) ]]"
run_test "Mixed alphanumeric works" "[[ -n \$(render_text 'A1B2C3' 'block' 2>/dev/null) ]]"
run_test "Long text renders" "[[ -n \$(render_text 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' 'block' 2>/dev/null) ]]"

# ============ VISUAL INSPECTION ============
printf "\n${BLUE}=== Visual Inspection ===${NC}\n"
printf "Sample banner output (block font):\n"
cd "$PROJECT_ROOT"
bash asciiflow "Hello" 2>/dev/null || true
printf "\n"

printf "Sample banner output (digital font):\n"
bash asciiflow -f digital "Hi" 2>/dev/null || true
printf "\n"

# ============ TEST SUMMARY ============
printf "\n${BLUE}=== Test Summary ===${NC}\n"
printf "Tests run: %s\n" "$TESTS_RUN"
printf "${GREEN}Passed: %s${NC}\n" "$TESTS_PASSED"
if [[ $TESTS_FAILED -gt 0 ]]; then
  printf "${RED}Failed: %s${NC}\n" "$TESTS_FAILED"
  exit 1
else
  printf "${GREEN}All tests passed!${NC}\n"
  exit 0
fi
