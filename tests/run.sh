#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

PASS=0
FAIL=0

assert_contains() {
  local label="$1"
  local command="$2"
  local expected="$3"
  local output

  if output=$(bash -lc "$command" 2>&1); then
    if printf '%s' "$output" | grep -Fq "$expected"; then
      printf 'PASS: %s\n' "$label"
      PASS=$((PASS + 1))
      return 0
    fi
  fi

  printf 'FAIL: %s\n' "$label"
  printf '  command: %s\n' "$command"
  printf '  expected to contain: %s\n' "$expected"
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
  printf '  expected exit code %s but got %s\n' "$expected" "$code"
  printf '  output:\n%s\n' "$output"
  FAIL=$((FAIL + 1))
  return 1
}

assert_contains "help" "./asciiflow --help" "ASCIIFlow"
assert_contains "version" "./asciiflow --version" "ASCIIFlow"
assert_contains "list" "./asciiflow --list" "block"
assert_contains "preview" "./asciiflow --preview" "block"
assert_exit_code "random" "./asciiflow --random" 0
assert_exit_code "missing style" "./asciiflow --style does-not-exist 'hello'" 1
assert_exit_code "empty input" "./asciiflow ''" 1
assert_not_contains "no color flag" "./asciiflow --no-color --style minimal 'Hello'" $'\033'
assert_not_contains "no color env" "NO_COLOR=1 ./asciiflow --style minimal 'Hello'" $'\033'

BANNER_NAME="test_banner_$$"
assert_contains "save banner" "./asciiflow --save $BANNER_NAME 'Hello'" "Saved banner"
assert_exit_code "load banner" "./asciiflow --load $BANNER_NAME" 0
assert_exit_code "install" "./install.sh" 0
assert_exit_code "uninstall" "./uninstall.sh" 0

printf '\nSummary: %s passed, %s failed\n' "$PASS" "$FAIL"
if [[ "$FAIL" -ne 0 ]]; then
  exit 1
fi
