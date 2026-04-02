---
name: modify-cais-plugin
description: >-
  Use when creating or editing cais plugin skills, commands, or agents in the
  cais-plugins repo. Triggers on "create skill", "new skill", "edit skill",
  "add command", "add agent", "update cais plugin", "new command", "new agent".
version: 1.0.0
---

# Modify Skill

You are helping a contributor create or edit a skill, command, or agent inside
the cais-plugins repository. Follow these steps exactly.

## Step 1 — Determine what to create or edit

Ask the user (or infer from context):

1. **Type:** skill, command, or agent?
2. **Action:** creating new or editing existing?
3. **Target plugin:** which plugin?
   - `cais-core` — shared across all team members
   - `cais-farol` — market research (Farol product)
   - `cais-flow` — messaging automation (Flow product)
   - `cais-content` — content generation (Content product)

If the user isn't sure which plugin, use this heuristic: if it's useful to
everyone, it goes in `cais-core`. Otherwise, pick the product-specific plugin.

## Step 2 — Name and conflict check

- Choose a **kebab-case** name (e.g., `my-new-skill`).
- Check that no existing skill/command/agent uses the same name in any plugin.
  Use `Glob` to search: `plugins/*/skills/<name>/SKILL.md`,
  `plugins/*/commands/<name>.md`, `plugins/*/agents/<name>.md`.
- If a conflict exists, suggest an alternative name.

## Step 3 — Create the files

### For a Skill

Create `plugins/<plugin>/skills/<name>/SKILL.md` with this template:

```yaml
---
name: <name>
description: >-
  <When this skill should be invoked. Include trigger phrases.>
version: 1.0.0
---
```

Then write the skill body — direct Markdown instructions for Claude.

Only add subdirectories when they provide value:

- `references/` — supporting docs (API specs, product context)
- `scripts/` — shell scripts the skill can invoke
- `templates/` — file templates for scaffolding
- `rules/` — validation or linting rules

Do NOT create empty subdirectories.

### For a Command

Create `plugins/<plugin>/commands/<name>.md` with this template:

```yaml
---
description: <Short description shown in the command picker>
argument-hint: [arg-name]
allowed-tools: Read, Grep, Glob
---
```

Use `$ARGUMENTS` for the full argument string, `$1`/`$2` for positional args.
Only include `allowed-tools` if the command needs specific tools. Only include
`model` if a lighter model (e.g., `haiku`) is sufficient.

### For an Agent

Create `plugins/<plugin>/agents/<name>.md` with this template:

```yaml
---
name: <name>
description: >-
  When to invoke this agent. Include example blocks:

  <example>
  Context: <when this situation arises>
  user: "<what the user might say>"
  assistant: "<how the assistant should respond>"
  <commentary>
  <why this agent is the right choice>
  </commentary>
  </example>

model: haiku
color: cyan
tools: ["Read", "Grep", "Glob"]
---
```

The body is the agent's system prompt.

## Step 4 — Write the content

- Write clear, direct instructions in the body.
- For skills: explain step-by-step what Claude should do when invoked.
- For commands: write the prompt template using `$ARGUMENTS` / `$1` / `$2`.
- For agents: write a focused system prompt that defines the agent's role.

## Step 5 — Bump the version

Open `.claude-plugin/marketplace.json` and bump the target plugin's version:

- **New** skill/command/agent → **minor** bump (e.g., `1.4.0` → `1.5.0`)
- **Edit** to existing → **patch** bump (e.g., `1.4.0` → `1.4.1`)

## Step 6 — Commit

Use Conventional Commits with the plugin name as scope:

- New: `feat(<plugin>): add <name> <type>`
- Edit: `fix(<plugin>): update <name> <type>` or
  `refactor(<plugin>): improve <name> <type>`

## Validation Checklist

Before finishing, verify all of these:

- [ ] `name` in frontmatter matches the directory/file name (kebab-case)
- [ ] `description` is present and explains when to trigger
- [ ] Placed in the correct plugin for the target audience
- [ ] No empty subdirectories created
- [ ] Version bumped in `marketplace.json`
- [ ] Commit message follows Conventional Commits format
