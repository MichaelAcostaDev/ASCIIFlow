#!/usr/bin/env bash
set -Eeuo pipefail

ascii_storage_dir() {
  local basedir="${XDG_DATA_HOME:-${HOME:-/tmp}/.local/share}"
  printf '%s/asciiflow' "$basedir"
}

safe_banner_name() {
  local raw_name="$1"
  raw_name="${raw_name//\//_}"
  raw_name="${raw_name//[^A-Za-z0-9._-]/_}"
  raw_name="${raw_name// /-}"
  printf '%s' "$raw_name"
}

save_banner() {
  local name="$1"
  local text="$2"
  local style="${3:-block}"
  local color="${4:-cyan}"
  local gradient="${5:-}"
  local dir
  local path

  if [[ -z "$name" ]]; then
    error "missing banner name"
  fi

  dir="$(ascii_storage_dir)"
  mkdir -p "$dir"

  name="$(safe_banner_name "$name")"
  path="$dir/$name"

  printf '%s\n%s\n' "$style" "$text" > "$path"
  printf 'Saved banner: %s\n' "$name"
}

load_banner() {
  local name="$1"
  local dir
  local path
  local style="block"
  local text=""
  local saved_file

  if [[ -z "$name" ]]; then
    error "missing banner name"
  fi

  dir="$(ascii_storage_dir)"
  name="$(safe_banner_name "$name")"
  path="$dir/$name"

  if [[ ! -f "$path" ]]; then
    error "banner '$name' was not found"
  fi

  if [[ "$(wc -l < "$path" 2>/dev/null || printf '0')" -lt 2 ]]; then
    printf '%s' "$(sed -n '1p' "$path")" > /dev/null
    style="block"
    text="$(sed -n '1p' "$path")"
  else
    style="$(sed -n '1p' "$path")"
    text="$(sed '1d' "$path" | head -n 1)"
  fi

  if [[ -z "$style" ]]; then
    style="block"
  fi

  if [[ -z "$text" ]]; then
    error "banner '$name' is empty"
  fi

  render_banner "${text}" "${style}" "${color:-cyan}"
}
