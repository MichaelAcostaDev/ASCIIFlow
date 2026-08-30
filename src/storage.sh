#!/usr/bin/env bash
set -Eeuo pipefail

ascii_storage_dir() {
  local basedir="${XDG_DATA_HOME:-${HOME:-/tmp}/.local/share}"
  printf '%s/asciiflow' "$basedir"
}

safe_banner_name() {
  local raw_name="$1"
  raw_name="${raw_name//\//_}"
  raw_name="${raw_name// /-}"
  printf '%s' "$raw_name"
}

save_banner() {
  local name="$1"
  local text="$2"
  local style="${3:-block}"
  local color="${4:-cyan}"
  local gradient="${5:-}"
  local path
  local dir

  if [[ -z "$name" ]]; then
    error "missing banner name"
  fi

  dir="$(ascii_storage_dir)"
  mkdir -p "$dir"

  name="$(safe_banner_name "$name")"
  path="$dir/$name"

  printf '%s|%s|%s|%s\n' "$style" "$color" "$gradient" "$text" > "$path"
  printf 'Saved banner to %s\n' "$path"
}

load_banner() {
  local name="$1"
  local dir
  local path
  local payload
  local style="block"
  local color="cyan"
  local gradient=""
  local text=""

  if [[ -z "$name" ]]; then
    error "missing banner name"
  fi

  dir="$(ascii_storage_dir)"
  name="$(safe_banner_name "$name")"
  path="$dir/$name"

  if [[ ! -f "$path" ]]; then
    error "banner '$name' was not found"
  fi

  payload="$(cat "$path")"
  IFS='|' read -r style color gradient text <<< "$payload"

  if [[ -z "$text" ]]; then
    text="$payload"
  fi

  if [[ -z "$style" ]]; then
    style="block"
  fi
  if [[ -z "$color" ]]; then
    color="cyan"
  fi

  render_banner "$text" "$style" "$color" "$gradient"
}
