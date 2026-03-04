#!/bin/bash
set -euo pipefail

# Only check git commit commands
input=$(cat)
tool_input=$(echo "$input" | jq -r '.tool_input.command // ""')

# Skip if not a git commit command
if ! echo "$tool_input" | grep -qE '^git commit'; then
  exit 0
fi

# Extract the commit message from -m flag (macOS-compatible, no grep -P)
commit_msg=$(echo "$tool_input" | sed -n 's/.*-m "\([^"]*\)".*/\1/p' | head -1)

# If using heredoc style, skip validation (too complex to parse)
if [ -z "$commit_msg" ]; then
  exit 0
fi

# Check Conventional Commits format
# Valid: feat(scope): message, fix: message, docs(scope): message, etc.
if ! echo "$commit_msg" | grep -qE '^(feat|fix|docs|refactor|chore|test|style|perf|ci|build|revert)(\([a-z0-9-]+\))?!?: .+'; then
  cat >&2 <<EOF
{"decision": "block", "reason": "Commit message doesn't follow Conventional Commits format. Expected: type(scope): description. Valid types: feat, fix, docs, refactor, chore, test, style, perf, ci, build, revert."}
EOF
  exit 2
fi

exit 0
