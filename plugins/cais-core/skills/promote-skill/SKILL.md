---
name: promote-skill
description: >-
  Use when promoting a local skill to the team marketplace. Triggers on
  "promote skill", "share skill with team", "add to cais plugins",
  "move skill to marketplace", "publish skill".
version: 1.0.0
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(cp:*), Bash(rm:*), Bash(git:*), Bash(mkdir:*), Bash(ls:*), Bash(cat:*), Bash(find:*)
---

# Promote Skill

You are helping a team member promote a personal/project skill into the
cais-plugins marketplace so the whole team can use it.

## Step 1 — Identify the source skill

Look for the skill in these locations (in order):

1. **User-scope:** `~/.claude/skills/<skill-name>/SKILL.md`
2. **Project-scope:** `<project-root>/.claude/skills/<skill-name>/SKILL.md`

If the user hasn't specified which skill, list available skills from both
locations using `Glob`:

```
~/.claude/skills/*/SKILL.md
.claude/skills/*/SKILL.md
```

Ask the user to pick one if multiple exist.

## Step 2 — Determine the target plugin

Ask or infer which plugin this skill belongs in:

| Plugin               | Audience   | Use for                                    |
| -------------------- | ---------- | ------------------------------------------ |
| **cais-core**        | Everyone   | Shared conventions, product context        |
| **cais-development** | Developers | Dev tools, design system, CI/CD            |
| **cais-marketing**   | Marketers  | Content, brand voice, community            |
| **cais-business**    | Business   | Strategy, pitch, metrics                   |

## Step 3 — Locate the cais-plugins repository

Use this three-step discovery:

### 3a. Search common parent directories

Search for a git repo whose `origin` remote matches the cais-plugins GitHub URL.
Check these directories:

```bash
for dir in ~ ~/Projetos ~/Projects ~/repos ~/code ~/dev ~/src; do
  if [ -d "$dir" ]; then
    find "$dir" -maxdepth 3 -name ".git" -type d 2>/dev/null | while read gitdir; do
      repo_dir="$(dirname "$gitdir")"
      remote=$(git -C "$repo_dir" remote get-url origin 2>/dev/null || true)
      if echo "$remote" | grep -q "cais-plugins"; then
        echo "$repo_dir"
      fi
    done
  fi
done
```

### 3b. Check environment variable

If step 3a finds nothing, check `$CAIS_PLUGINS_PATH`:

```bash
echo "${CAIS_PLUGINS_PATH:-not set}"
```

### 3c. Ask the user

If both above fail, ask: "Where is your local clone of the cais-plugins repo?"

## Step 4 — Pull latest main

```bash
cd <cais-plugins-path>
git checkout main
git pull origin main
```

## Step 5 — Copy skill files

Copy the entire skill directory:

```bash
cp -r <source-skill-dir> <cais-plugins>/plugins/<plugin>/skills/<skill-name>/
```

## Step 6 — Review and adapt

Read the copied `SKILL.md` and check for:

- [ ] **Frontmatter is valid** — `name` matches directory, `description` is
      present, `version` is set
- [ ] **No hardcoded paths** — replace any user-specific paths with generic
      instructions or `${CLAUDE_PLUGIN_ROOT}`
- [ ] **No secrets** — remove any API keys, tokens, or passwords
- [ ] **Trigger phrases** — `description` includes trigger phrases so Claude
      knows when to invoke it
- [ ] **References are included** — if the skill has `references/`, `scripts/`,
      `templates/`, or `rules/` dirs, make sure they were copied

Fix any issues found.

## Step 7 — Bump the version

Open `.claude-plugin/marketplace.json` and apply a **minor** bump to the target
plugin's version (e.g., `1.4.0` → `1.5.0`).

## Step 8 — Commit and push

By default, commit directly to `main` and push (small team workflow):

```bash
git add plugins/<plugin>/skills/<skill-name>/ .claude-plugin/marketplace.json
git commit -m "feat(<plugin>): add <skill-name> skill

Promoted from local skills to team marketplace.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
git push origin main
```

**If the user prefers a PR workflow**, create a branch instead:

```bash
git checkout -b feat/<plugin>/<skill-name>
git add plugins/<plugin>/skills/<skill-name>/ .claude-plugin/marketplace.json
git commit -m "feat(<plugin>): add <skill-name> skill"
git push -u origin feat/<plugin>/<skill-name>
```

Then create a PR with `gh pr create`.

**Always ask before pushing.** Confirm with the user:
"Ready to push to main? Or would you prefer a PR?"

## Step 9 — Delete the local copy

After the push succeeds, remove the source skill to prevent duplicate conflicts:

```bash
rm -rf <source-skill-dir>
```

Tell the user: "The local copy at `<path>` has been removed. The skill is now
available to the whole team via the `<plugin>` plugin."

## Summary template

After completing all steps, print:

```
Promoted: <skill-name>
  From:   <source-path>
  To:     plugins/<plugin>/skills/<skill-name>/
  Plugin: <plugin> (bumped to <new-version>)
  Commit: <commit-hash>
  Local copy: deleted
```
