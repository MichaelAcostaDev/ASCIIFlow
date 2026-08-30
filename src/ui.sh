#!/usr/bin/env bash
set -Eeuo pipefail

ascii_banner() {
  cat <<'EOF'
  ASCIIFlow

  Create beautiful ASCII banners.
EOF
}

banner_intro() {
  if [[ -t 1 ]]; then
    printf '%s\n' "$(ansi_fg 36)ASCIIFlow$(reset_color)"
    printf '%s\n' "Create beautiful ASCII banners."
  else
    printf '%s\n' 'ASCIIFlow'
    printf '%s\n' 'Create beautiful ASCII banners.'
  fi
}
