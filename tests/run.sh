#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

PATH="$HOME/.local/bin:$PATH"
export PATH

PASS=0
FAIL=0

assert_contains() {
  local label="$1"
  local command="$2"
  local expected="$3"
  local output

  set +e
  output=$(bash -lc "$command" 2>&1)
  local code=$?
  set -e

  if printf '%s' "$output" | grep -Fq "$expected"; then
    printf 'PASS: %s\n' "$label"
    PASS=$((PASS + 1))
    return 0
  fi

  printf 'FAIL: %s\n' "$label"
  printf '  command: %s\n' "$command"
  printf '  expected to contain: %s\n' "$expected"
  printf '  exit code: %s\n' "$code"
  printf '  output:\n%s\n' "${output:-<no output>}"
  FAIL=$((FAIL + 1))
  return 1
}

assert_not_contains() {
  local label="$1"
  local command="$2"
  local unexpected="$3"
  local output

  if output=$(bash -lc "$command" 2>&1); then
    if printf '%s' "$output" | grep -Fq "$unexpected"; then
      printf 'FAIL: %s\n' "$label"
      printf '  command: %s\n' "$command"
      printf '  unexpected sequence present: %s\n' "$unexpected"
      printf '  output:\n%s\n' "$output"
      FAIL=$((FAIL + 1))
      return 1
    fi
  fi

  printf 'PASS: %s\n' "$label"
  PASS=$((PASS + 1))
  return 0
}

assert_exit_code() {
  local label="$1"
  local command="$2"
  local expected="$3"
  local output
  set +e
  output=$(bash -lc "$command" 2>&1)
  local code=$?
  set -e

  if [[ "$code" == "$expected" ]]; then
    printf 'PASS: %s\n' "$label"
    PASS=$((PASS + 1))
    return 0
  fi

  printf 'FAIL: %s\n' "$label"
  printf '  command: %s\n' "$command"
  printf '  expected exit code %s but got %s\n' "$expected" "$code"
  printf '  output:\n%s\n' "$output"
  FAIL=$((FAIL + 1))
  return 1
}

assert_contains "help_long" "./asciiflow --help" "ASCIIFlow"
assert_contains "help_short" "./asciiflow -h" "Usage:"
assert_contains "version_long" "./asciiflow --version" "ASCIIFlow 0.1.1"
assert_contains "version_short" "./asciiflow -v" "ASCIIFlow 0.1.1"
assert_contains "list_long" "./asciiflow --list" "block"
assert_contains "list_short" "./asciiflow -l" "block"
assert_exit_code "random_default" "./asciiflow --random" 0
assert_exit_code "random_with_text" "./asciiflow --random 'Hello'" 0
assert_exit_code "style_valid_short" "./asciiflow -s block 'Hello World'" 0
assert_exit_code "style_valid_long" "./asciiflow --style block 'Hello World'" 0
assert_exit_code "style_invalid" "./asciiflow --style foo 'Hello'" 1
assert_exit_code "missing_text" "./asciiflow" 1
assert_exit_code "unknown_option" "./asciiflow --foo" 1
assert_contains "unknown_option_text" "./asciiflow --foo" "unknown option '--foo'"
assert_exit_code "special_chars" "./asciiflow 'Hello?!-_/.:@#'" 0
assert_not_contains "no_color_flag" "./asciiflow --no-color --style minimal 'Hello'" $'\033'
assert_not_contains "no_color_env" "NO_COLOR=1 ./asciiflow --style minimal 'Hello'" $'\033'

BANNER_NAME="test_banner_$$"
assert_contains "save_banner" "XDG_DATA_HOME="$ROOT/.tmp-data" ./asciiflow --save $BANNER_NAME 'Hello World'" "Saved banner"
assert_exit_code "load_banner" "XDG_DATA_HOME=\"$ROOT/.tmp-data\" ./asciiflow --load $BANNER_NAME" 0
assert_exit_code "missing_saved" "XDG_DATA_HOME="$ROOT/.tmp-data" ./asciiflow --load missing_banner_$$" 1
assert_exit_code "install" "./install.sh" 0
assert_exit_code "uninstall" "./uninstall.sh" 0

printf '\nSummary: %s passed, %s failed\n' "$PASS" "$FAIL"
if [[ "$FAIL" -ne 0 ]]; then
  exit 1
fi
