#!/bin/bash
# sync-opencode-config.sh - Sync OpenCode config from remote URL
# Usage: ./sync-opencode-config.sh [remote_url]

CONFIG_URL="${1:-$OPENCODE_CONFIG_URL}"
CONFIG_DIR="${APPDATA:-$HOME/AppData/Roaming/opencode}"
CONFIG_PATH="$CONFIG_DIR/opencode.json"

if [ -z "$CONFIG_URL" ]; then
  echo "Usage: ./sync-opencode-config.sh <remote_url>"
  echo "Or set OPENCODE_CONFIG_URL env var"
  exit 1
fi

echo "📥 Downloading: $CONFIG_URL"
echo "📍 Saving to: $CONFIG_PATH"

mkdir -p "$CONFIG_DIR"

if command -v curl &> /dev/null; then
  curl -fsSL "$CONFIG_URL" -o "$CONFIG_PATH"
elif command -v wget &> /dev/null; then
  wget -q "$CONFIG_URL" -O "$CONFIG_PATH"
else
  echo "❌ curl or wget required"
  exit 1
fi

if [ $? -eq 0 ]; then
  echo "✅ Config synced!"
  cat "$CONFIG_PATH" | head -5
else
  echo "❌ Sync failed"
  exit 1
fi