---
description: Generate a standup summary from recent work
allowed-tools: Read, Bash(git:*)
model: haiku
---

Generate a concise standup summary based on recent activity.

Gather context:
- Recent commits: !`git log --oneline -10 --all 2>/dev/null || echo "No git repo"`
- Current branch: !`git branch --show-current 2>/dev/null || echo "N/A"`
- Uncommitted changes: !`git status --short 2>/dev/null || echo "N/A"`

Format the standup as:

**Yesterday:**
- [Summarize completed work from commits]

**Today:**
- [Infer planned work from uncommitted changes and branch context]

**Blockers:**
- [Note any if obvious from context, otherwise "None"]

Keep it brief — 3-5 bullet points per section max.
