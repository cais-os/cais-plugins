# Cais Plugins Marketplace Split — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to
> implement this plan task-by-task.

**Goal:** Split the monolithic `cais` plugin into 4 role-based plugins
(cais-core, cais-development, cais-marketing, cais-business) and create a
marketplace to distribute them.

**Architecture:** Monorepo with `marketplace.json` at root referencing 4 plugin
directories under `plugins/`. Each plugin has its own `plugin.json` manifest,
skills, commands, agents, and/or hooks. The old `cais/` directory is removed
after migration.

**Tech Stack:** Claude Code plugins (markdown skills, JSON manifests, bash
hooks)

---

### Task 1: Initialize git repo and create directory structure

**Files:**

- Create: `plugins/cais-core/.claude-plugin/` (directory)
- Create: `plugins/cais-development/.claude-plugin/` (directory)
- Create: `plugins/cais-marketing/.claude-plugin/` (directory)
- Create: `plugins/cais-business/.claude-plugin/` (directory)

**Step 1: Initialize git**

```bash
cd /Users/guilhermenovak/Projetos/Cais/cais-plugins
git init
```

**Step 2: Create all plugin directory trees**

```bash
mkdir -p plugins/cais-core/.claude-plugin
mkdir -p plugins/cais-core/skills/team-conventions
mkdir -p plugins/cais-core/skills/product-context/references/products
mkdir -p plugins/cais-core/commands
mkdir -p plugins/cais-core/hooks/scripts

mkdir -p plugins/cais-development/.claude-plugin
mkdir -p plugins/cais-development/skills/dev-practices/references
mkdir -p plugins/cais-development/skills/design-system
mkdir -p plugins/cais-development/commands
mkdir -p plugins/cais-development/agents

mkdir -p plugins/cais-marketing/.claude-plugin
mkdir -p plugins/cais-marketing/skills/content-creation
mkdir -p plugins/cais-marketing/commands
mkdir -p plugins/cais-marketing/agents

mkdir -p plugins/cais-business/.claude-plugin
mkdir -p plugins/cais-business/skills/business-ops
mkdir -p plugins/cais-business/commands
```

**Step 3: Commit**

```bash
git add plugins/
git commit -m "chore: scaffold plugin directory structure for marketplace split"
```

---

### Task 2: Create marketplace.json

**Files:**

- Create: `.claude-plugin/marketplace.json`

**Step 1: Create the marketplace manifest**

Write `.claude-plugin/marketplace.json`:

```json
{
  "name": "cais-plugins",
  "owner": {
    "name": "Cais"
  },
  "metadata": {
    "description": "Plugin marketplace for the Cais team — an AI lab that creates and distributes SaaS products.",
    "version": "1.0.0",
    "pluginRoot": "./plugins"
  },
  "plugins": [
    {
      "name": "cais-core",
      "source": "./plugins/cais-core",
      "description": "Shared team conventions, product context, and commit hooks for all Cais roles.",
      "version": "1.0.0",
      "category": "team",
      "tags": ["conventions", "shared", "hooks"]
    },
    {
      "name": "cais-development",
      "source": "./plugins/cais-development",
      "description": "Development practices, design system, code review, and standup for Cais developers.",
      "version": "1.0.0",
      "category": "development",
      "tags": ["dev", "code-review", "ci-cd", "design-system"]
    },
    {
      "name": "cais-marketing",
      "source": "./plugins/cais-marketing",
      "description": "Content creation, brand voice, and drafting tools for Cais marketers.",
      "version": "1.0.0",
      "category": "marketing",
      "tags": ["content", "brand", "copywriting"]
    },
    {
      "name": "cais-business",
      "source": "./plugins/cais-business",
      "description": "Business strategy, pitch frameworks, and metrics for Cais business operations.",
      "version": "1.0.0",
      "category": "business",
      "tags": ["strategy", "pitch", "metrics"]
    }
  ]
}
```

**Step 2: Commit**

```bash
git add .claude-plugin/marketplace.json
git commit -m "feat: add marketplace.json for cais-plugins marketplace"
```

---

### Task 3: Create cais-core plugin

**Files:**

- Create: `plugins/cais-core/.claude-plugin/plugin.json`
- Copy: `cais/skills/team-conventions/SKILL.md` →
  `plugins/cais-core/skills/team-conventions/SKILL.md`
- Copy: `cais/skills/product-context/SKILL.md` →
  `plugins/cais-core/skills/product-context/SKILL.md`
- Copy: `cais/commands/brief.md` → `plugins/cais-core/commands/brief.md`
- Copy: `cais/hooks/hooks.json` → `plugins/cais-core/hooks/hooks.json`
- Copy: `cais/hooks/scripts/check-commit-message.sh` →
  `plugins/cais-core/hooks/scripts/check-commit-message.sh`
- Create: `plugins/cais-core/CLAUDE.md` (updated from `cais/CLAUDE.md`)

**Step 1: Create plugin.json**

Write `plugins/cais-core/.claude-plugin/plugin.json`:

```json
{
  "name": "cais-core",
  "version": "1.0.0",
  "description": "Shared Cais team conventions, product context, and commit message hooks for all roles.",
  "author": {
    "name": "Cais"
  },
  "keywords": ["team", "conventions", "saas", "startup"]
}
```

**Step 2: Copy skills, commands, and hooks**

```bash
cp cais/skills/team-conventions/SKILL.md plugins/cais-core/skills/team-conventions/SKILL.md
cp cais/skills/product-context/SKILL.md plugins/cais-core/skills/product-context/SKILL.md
cp cais/commands/brief.md plugins/cais-core/commands/brief.md
cp cais/hooks/hooks.json plugins/cais-core/hooks/hooks.json
cp cais/hooks/scripts/check-commit-message.sh plugins/cais-core/hooks/scripts/check-commit-message.sh
chmod +x plugins/cais-core/hooks/scripts/check-commit-message.sh
```

**Step 3: Create updated CLAUDE.md**

Write `plugins/cais-core/CLAUDE.md` — this is the team-wide conventions file,
updated to reference the new plugin namespaces:

```markdown
# Cais — Team Conventions

Cais is an AI lab that creates and distributes SaaS products. These instructions
apply to all team members using Claude Code.

## Team

- **Developer** — builds and maintains products
- **Marketer** — creates content and manages growth
- **Businessman** — handles strategy, pitches, and operations

## General Rules

- Follow the `team-conventions` skill for naming and file structure conventions.
- Follow the `dev-practices` skill (cais-development plugin) for all development
  work.
- Follow the `content-creation` skill (cais-marketing plugin) for marketing and
  content work.
- Follow the `business-ops` skill (cais-business plugin) for strategy and
  operations work.
- Use the `product-context` skill to document each SaaS product.
- Use the `design-system` skill (cais-development plugin) when working on UI
  across products.

## Communication

- Be direct and concise — startup pace, no fluff.
- Default to async communication. Document decisions in writing.
- When building a new product or feature, start with a brief (use
  `/cais-core:brief`).

## Commit Messages

Use Conventional Commits format:
```

feat(scope): add new feature fix(scope): fix a bug docs(scope): update
documentation refactor(scope): restructure without behavior change chore(scope):
maintenance tasks

```
## Quality Standards

- Every product ships with CI/CD from day one.
- Write tests for business-critical paths.
- Document architecture decisions in project CLAUDE.md files.
```

**Step 4: Commit**

```bash
git add plugins/cais-core/
git commit -m "feat(cais-core): add shared conventions, product context, brief command, and hooks"
```

---

### Task 4: Create cais-development plugin

**Files:**

- Create: `plugins/cais-development/.claude-plugin/plugin.json`
- Copy: `cais/skills/dev-practices/SKILL.md` →
  `plugins/cais-development/skills/dev-practices/SKILL.md`
- Copy: `cais/skills/dev-practices/references/ci-cd.md` →
  `plugins/cais-development/skills/dev-practices/references/ci-cd.md`
- Copy: `cais/skills/dev-practices/references/database.md` →
  `plugins/cais-development/skills/dev-practices/references/database.md`
- Copy: `cais/skills/design-system/SKILL.md` →
  `plugins/cais-development/skills/design-system/SKILL.md`
- Copy: `cais/commands/standup.md` →
  `plugins/cais-development/commands/standup.md`
- Copy: `cais/commands/review.md` →
  `plugins/cais-development/commands/review.md`
- Copy: `cais/agents/code-standards-reviewer.md` →
  `plugins/cais-development/agents/code-standards-reviewer.md`

**Step 1: Create plugin.json**

Write `plugins/cais-development/.claude-plugin/plugin.json`:

```json
{
  "name": "cais-development",
  "version": "1.0.0",
  "description": "Cais development practices, design system, code review, and standup tools.",
  "author": {
    "name": "Cais"
  },
  "keywords": ["dev", "saas", "ci-cd", "design-system"]
}
```

**Step 2: Copy all files**

```bash
cp cais/skills/dev-practices/SKILL.md plugins/cais-development/skills/dev-practices/SKILL.md
cp cais/skills/dev-practices/references/ci-cd.md plugins/cais-development/skills/dev-practices/references/ci-cd.md
cp cais/skills/dev-practices/references/database.md plugins/cais-development/skills/dev-practices/references/database.md
cp cais/skills/design-system/SKILL.md plugins/cais-development/skills/design-system/SKILL.md
cp cais/commands/standup.md plugins/cais-development/commands/standup.md
cp cais/commands/review.md plugins/cais-development/commands/review.md
cp cais/agents/code-standards-reviewer.md plugins/cais-development/agents/code-standards-reviewer.md
```

**Step 3: Commit**

```bash
git add plugins/cais-development/
git commit -m "feat(cais-development): add dev practices, design system, standup, review, and code reviewer"
```

---

### Task 5: Create cais-marketing plugin

**Files:**

- Create: `plugins/cais-marketing/.claude-plugin/plugin.json`
- Copy: `cais/skills/content-creation/SKILL.md` →
  `plugins/cais-marketing/skills/content-creation/SKILL.md`
- Copy: `cais/commands/draft.md` → `plugins/cais-marketing/commands/draft.md`
- Copy: `cais/agents/brand-voice-checker.md` →
  `plugins/cais-marketing/agents/brand-voice-checker.md`

**Step 1: Create plugin.json**

Write `plugins/cais-marketing/.claude-plugin/plugin.json`:

```json
{
  "name": "cais-marketing",
  "version": "1.0.0",
  "description": "Cais content creation, brand voice, and drafting tools for marketers.",
  "author": {
    "name": "Cais"
  },
  "keywords": ["marketing", "content", "brand", "copywriting"]
}
```

**Step 2: Copy all files**

```bash
cp cais/skills/content-creation/SKILL.md plugins/cais-marketing/skills/content-creation/SKILL.md
cp cais/commands/draft.md plugins/cais-marketing/commands/draft.md
cp cais/agents/brand-voice-checker.md plugins/cais-marketing/agents/brand-voice-checker.md
```

**Step 3: Commit**

```bash
git add plugins/cais-marketing/
git commit -m "feat(cais-marketing): add content creation, draft command, and brand voice checker"
```

---

### Task 6: Create cais-business plugin

**Files:**

- Create: `plugins/cais-business/.claude-plugin/plugin.json`
- Copy: `cais/skills/business-ops/SKILL.md` →
  `plugins/cais-business/skills/business-ops/SKILL.md`
- Copy: `cais/commands/pitch.md` → `plugins/cais-business/commands/pitch.md`

**Step 1: Create plugin.json**

Write `plugins/cais-business/.claude-plugin/plugin.json`:

```json
{
  "name": "cais-business",
  "version": "1.0.0",
  "description": "Cais business operations, pitch frameworks, and metrics for strategy work.",
  "author": {
    "name": "Cais"
  },
  "keywords": ["business", "strategy", "pitch", "metrics"]
}
```

**Step 2: Copy all files**

```bash
cp cais/skills/business-ops/SKILL.md plugins/cais-business/skills/business-ops/SKILL.md
cp cais/commands/pitch.md plugins/cais-business/commands/pitch.md
```

**Step 3: Commit**

```bash
git add plugins/cais-business/
git commit -m "feat(cais-business): add business ops skill and pitch command"
```

---

### Task 7: Update cross-references in commands

Commands that reference skills from other plugins need updating. Specifically:

**Files:**

- Modify: `plugins/cais-marketing/commands/draft.md` — references
  `product-context` and `content-creation` skills
- Modify: `plugins/cais-business/commands/pitch.md` — references
  `product-context` and `business-ops` skills

**Step 1: Update draft.md**

In `plugins/cais-marketing/commands/draft.md`, update the references:

- "Check if the product has a context file in the product-context skill" →
  "Check if the product has a context file in the product-context skill (from
  the cais-core plugin)"
- "following the content-creation skill's templates" → keep as-is (same plugin)
- "quality checklist from the content-creation skill" → keep as-is (same plugin)

**Step 2: Update pitch.md**

In `plugins/cais-business/commands/pitch.md`, update:

- "Check the product-context skill" → "Check the product-context skill (from the
  cais-core plugin)"

**Step 3: Commit**

```bash
git add plugins/cais-marketing/commands/draft.md plugins/cais-business/commands/pitch.md
git commit -m "docs: update cross-plugin references in draft and pitch commands"
```

---

### Task 8: Create root .gitignore and README

**Files:**

- Create: `.gitignore`
- Create: `README.md` (root marketplace README)

**Step 1: Create .gitignore**

Write `.gitignore`:

```
.DS_Store
*.swp
*.swo
*~
```

**Step 2: Create README.md**

Write `README.md` — a marketplace README explaining what this is, listing the 4
plugins, and showing installation instructions. Model it after the existing
`cais/README.md` but updated for the marketplace structure:

````markdown
# Cais Plugins

Plugin marketplace for the Cais team — an AI lab that creates and distributes
SaaS products.

## Plugins

| Plugin               | Role        | What's included                                                          |
| -------------------- | ----------- | ------------------------------------------------------------------------ |
| **cais-core**        | All         | Team conventions, product context, `/brief` command, commit hooks        |
| **cais-development** | Developer   | Dev practices, design system, `/standup`, `/review`, code reviewer agent |
| **cais-marketing**   | Marketer    | Content creation, `/draft`, brand voice checker agent                    |
| **cais-business**    | Businessman | Business ops, `/pitch` command                                           |

## Installation

### 1. Add the marketplace

```bash
/plugin marketplace add your-org/cais-plugins
```
````

### 2. Install plugins for your role

**Developer:**

```bash
/plugin install cais-core@cais-plugins
/plugin install cais-development@cais-plugins
```

**Marketer:**

```bash
/plugin install cais-core@cais-plugins
/plugin install cais-marketing@cais-plugins
```

**Businessman:**

```bash
/plugin install cais-core@cais-plugins
/plugin install cais-business@cais-plugins
```

## Auto-configure for a project

Add to your project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "cais-plugins": {
      "source": { "source": "github", "repo": "your-org/cais-plugins" }
    }
  },
  "enabledPlugins": {
    "cais-core@cais-plugins": true
  }
}
```

## Contributing

See individual plugin directories under `plugins/` for details on each plugin's
skills, commands, and agents.

````
**Step 3: Commit**

```bash
git add .gitignore README.md
git commit -m "docs: add root .gitignore and marketplace README"
````

---

### Task 9: Validate and test

**Step 1: Validate marketplace structure**

```bash
claude plugin validate .
```

Expected: No errors. Warnings are OK.

**Step 2: Test each plugin loads**

```bash
claude --plugin-dir ./plugins/cais-core --plugin-dir ./plugins/cais-development --plugin-dir ./plugins/cais-marketing --plugin-dir ./plugins/cais-business
```

Inside the session, run `/help` and verify all 4 plugin namespaces appear with
their commands:

- `/cais-core:brief`
- `/cais-development:standup`
- `/cais-development:review`
- `/cais-marketing:draft`
- `/cais-business:pitch`

**Step 3: Test a command from each plugin**

Try `/cais-core:brief test-product` and `/cais-development:standup` to verify
they work.

---

### Task 10: Remove old cais/ directory and final commit

**Step 1: Remove the old monolithic plugin**

```bash
rm -rf cais/
```

**Step 2: Commit**

```bash
git add -A
git commit -m "chore: remove old monolithic cais plugin after marketplace migration"
```

**Step 3: Final check**

```bash
git log --oneline
```

Verify all commits are clean and in order.
