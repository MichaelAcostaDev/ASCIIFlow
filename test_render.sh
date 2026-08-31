#!/bin/bash
set -Eeuo pipefail

ASCIIFLOW_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ASCIIFLOW_ROOT"

# Load modules
source "${ASCIIFLOW_ROOT}/src/fonts.sh"
source "${ASCIIFLOW_ROOT}/src/renderer.sh"
source "${ASCIIFLOW_ROOT}/src/cli.sh"

# Run the test
echo "Testing basic rendering:"
render_text "HELLO" "block"
