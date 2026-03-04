#!/bin/bash
set -euo pipefail

input=$(cat)
tool_input=$(echo "$input" | jq -r '.tool_input.command // ""')

# Only check git commit commands
if ! echo "$tool_input" | grep -qE 'git commit'; then
  exit 0
fi

# Get staged files
staged_files=$(git diff --cached --name-only 2>/dev/null || true)

if [ -z "$staged_files" ]; then
  exit 0
fi

# Find which plugins have staged changes (excluding plugin.json itself)
missing_bumps=()

for plugin_dir in plugins/*/; do
  plugin_name=$(basename "$plugin_dir")

  # Check if any files in this plugin are staged (excluding plugin.json)
  plugin_changes=$(echo "$staged_files" | grep "^plugins/${plugin_name}/" | grep -v ".claude-plugin/plugin.json" || true)

  if [ -z "$plugin_changes" ]; then
    continue
  fi

  # This plugin has changes — check if plugin.json is also staged
  manifest_staged=$(echo "$staged_files" | grep "^plugins/${plugin_name}/.claude-plugin/plugin.json" || true)

  if [ -z "$manifest_staged" ]; then
    missing_bumps+=("$plugin_name")
    continue
  fi

  # plugin.json is staged — verify the version field actually changed
  version_changed=$(git diff --cached -- "plugins/${plugin_name}/.claude-plugin/plugin.json" | grep '"version"' || true)

  if [ -z "$version_changed" ]; then
    missing_bumps+=("$plugin_name")
  fi
done

if [ ${#missing_bumps[@]} -gt 0 ]; then
  plugins_list=$(printf ", %s" "${missing_bumps[@]}")
  plugins_list=${plugins_list:2} # trim leading ", "
  cat >&2 <<EOF
{"decision": "block", "reason": "Version bump required. The following plugins have staged changes but their version in .claude-plugin/plugin.json was not bumped: ${plugins_list}. Bump the version (patch for fixes, minor for new features, major for breaking changes) and stage the file before committing."}
EOF
  exit 2
fi

exit 0
