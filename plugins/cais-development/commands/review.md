---
description: Code review with Cais team standards
allowed-tools: Read, Grep, Glob, Bash(git:*)
argument-hint: [file-or-pr-number]
---

Review code changes against Cais development standards.

Context:

- Changed files:
  !`git diff --name-only HEAD~1 2>/dev/null || git diff --name-only --cached 2>/dev/null || echo "No changes found"`

Review each changed file for:

1. **Conventions** — follows Cais naming and structure conventions
2. **Stack alignment** — uses approved tools from the dev-practices skill
3. **Security** — no hardcoded secrets, proper input validation
4. **Quality** — no obvious bugs, clear logic, appropriate error handling
5. **Tests** — business-critical paths have test coverage

If a specific file was provided as argument ($ARGUMENTS), focus the review on
that file. If a PR number was provided, use `gh pr diff $ARGUMENTS` to get the
changes.

Format findings as:

### [filename]

- **[severity]**: [description] (line X)

Severity levels: critical, warning, suggestion
