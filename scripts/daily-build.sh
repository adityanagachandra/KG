#!/usr/bin/env bash
# Nightly static build (output: public/). Run manually or via LaunchAgent.
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
exec npx quartz build -d content
