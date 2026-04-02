#!/usr/bin/env bash
# Installs a LaunchAgent that runs scripts/daily-build.sh every day at 23:59 (local time).
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LABEL="com.adityanagachandra.quartz.daily-build"
PLIST_DEST="${HOME}/Library/LaunchAgents/${LABEL}.plist"
LOG_DIR="${REPO_ROOT}/scripts/logs"
mkdir -p "$LOG_DIR"

cat > "$PLIST_DEST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>${LABEL}</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>${REPO_ROOT}/scripts/daily-build.sh</string>
  </array>
  <key>WorkingDirectory</key>
  <string>${REPO_ROOT}</string>
  <key>StartCalendarInterval</key>
  <dict>
    <key>Hour</key>
    <integer>23</integer>
    <key>Minute</key>
    <integer>59</integer>
  </dict>
  <key>StandardOutPath</key>
  <string>${LOG_DIR}/daily-build.log</string>
  <key>StandardErrorPath</key>
  <string>${LOG_DIR}/daily-build.err.log</string>
</dict>
</plist>
EOF

chmod +x "${REPO_ROOT}/scripts/daily-build.sh"
launchctl bootout "gui/$(id -u)/${LABEL}" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$PLIST_DEST"
echo "Installed ${PLIST_DEST}"
echo "Runs daily at 11:59 PM (system local time). Logs: ${LOG_DIR}/"
echo "To uninstall: launchctl bootout gui/$(id -u)/${LABEL} && rm ${PLIST_DEST}"
