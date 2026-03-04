# Cais Plugins — Repository Rules

## Repository Overview

This repo is the **team plugin marketplace** for Cais — an AI lab that builds
and distributes SaaS products. It contains four plugins, each targeting a
different role:

| Plugin               | Audience   | Use for                                            |
| -------------------- | ---------- | -------------------------------------------------- |
| **cais-core**        | Everyone   | Shared conventions, product context, commit hooks  |
| **cais-development** | Developers | Dev practices, design system, CI/CD, MCP servers   |
| **cais-marketing**   | Marketers  | Content creation, brand voice, WhatsApp Cloud API  |
| **cais-business**    | Business   | Strategy, pitch frameworks, metrics, Stripe/RevCat |

**Placement heuristic:** if a skill/command/agent is useful to everyone, put it
in `cais-core`. If it targets a specific role, put it in that role's plugin.

---

## Directory Structure

Every plugin follows this layout:

```
plugins/<plugin-name>/
├── CLAUDE.md              # Plugin-level instructions (loaded into context)
├── .mcp.json              # MCP server configurations (optional)
├── agents/                # Agent definitions (optional)
│   └── <agent-name>.md
├── commands/              # Slash commands (optional)
│   └── <command-name>.md
├── hooks/                 # Lifecycle hooks (optional)
│   ├── hooks.json
│   └── scripts/
│       └── <script>.sh
└── skills/                # Skills — the primary extension type
    └── <skill-name>/
        ├── SKILL.md       # Frontmatter + prompt (required)
        ├── references/    # Supporting docs (optional)
        ├── scripts/       # Helper scripts (optional)
        ├── templates/     # File templates (optional)
        └── rules/         # Rule files (optional)
```

The root `.claude-plugin/marketplace.json` registers all plugins with their
versions and metadata.

---

## Creating a Skill

Skills live in `plugins/<plugin>/skills/<skill-name>/SKILL.md`.

### Frontmatter

```yaml
---
name: my-skill-name
description: >-
  When to trigger this skill. Include trigger phrases like "create a widget",
  "set up auth", etc. This text appears in the skill picker.
version: 1.0.0
---
```

| Field         | Required | Notes                                      |
| ------------- | -------- | ------------------------------------------ |
| `name`        | Yes      | Kebab-case, must match the directory name  |
| `description` | Yes      | Explains WHEN the skill should be invoked  |
| `version`     | No       | Semver — omit if the skill is experimental |

### Body

The body is a Markdown prompt that Claude follows when the skill is invoked.
Write it as direct instructions.

### Optional subdirectories

Only create these when they add value — don't create empty dirs:

- **`references/`** — supporting `.md` docs (e.g., API specs, product context)
- **`scripts/`** — shell scripts the skill can invoke via `Bash`
- **`templates/`** — file templates the skill copies into projects
- **`rules/`** — rule files for linting or validation

---

## Creating a Command

Commands live in `plugins/<plugin>/commands/<command-name>.md`.

### Frontmatter

```yaml
---
description: Short description of what the command does
argument-hint: [required-arg] [optional-arg]
allowed-tools: Read, Grep, Glob, Bash(git:*)
model: haiku
---
```

| Field           | Required | Notes                                            |
| --------------- | -------- | ------------------------------------------------ |
| `description`   | Yes      | Shown in the command picker                      |
| `argument-hint` | No       | Describes expected arguments in the UI           |
| `allowed-tools` | No       | Comma-separated tool names the command may use   |
| `model`         | No       | Override model (e.g., `haiku` for fast commands) |

### Template variables

- `$ARGUMENTS` — the full argument string
- `$1`, `$2`, … — positional arguments

### Inline shell

Prefix a line with `!` followed by a backtick-quoted shell expression to run it
inline: `` !`git log --oneline -5` ``

---

## Creating an Agent

Agents live in `plugins/<plugin>/agents/<agent-name>.md`.

### Frontmatter

```yaml
---
name: my-agent
description: >-
  When to invoke this agent. Include <example> blocks with <commentary>
  so Claude knows how to use it proactively.
model: haiku
color: cyan
tools: ["Read", "Grep", "Glob"]
---
```

| Field         | Required | Notes                                              |
| ------------- | -------- | -------------------------------------------------- |
| `name`        | Yes      | Kebab-case slug                                    |
| `description` | Yes      | Include `<example>` XML blocks with `<commentary>` |
| `model`       | No       | `haiku`, `sonnet`, `opus`, or `inherit`            |
| `color`       | No       | UI accent: `magenta`, `cyan`, `green`, etc.        |
| `tools`       | No       | JSON array of tool names the agent can use         |

The body is the agent's system prompt, written in Markdown.

---

## Hooks & MCP Config

### hooks.json

Lives in `plugins/<plugin>/hooks/hooks.json`:

```json
{
  "description": "What this hook set does",
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "ToolName",
        "hooks": [
          {
            "type": "command",
            "command": "bash ${CLAUDE_PLUGIN_ROOT}/hooks/scripts/my-script.sh",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

- `${CLAUDE_PLUGIN_ROOT}` resolves to the plugin's root directory at runtime.
- Scripts go in `hooks/scripts/`.
- Hook events: `PreToolUse`, `PostToolUse`, `Notification`, etc.

### .mcp.json

Lives in `plugins/<plugin>/.mcp.json`. Each key is a server name:

**HTTP transport:**

```json
{
  "server-name": {
    "type": "http",
    "url": "https://example.com/mcp",
    "headers": { "Authorization": "Bearer ${ENV_VAR}" }
  }
}
```

**Stdio transport:**

```json
{
  "server-name": {
    "type": "stdio",
    "command": "npx",
    "args": ["@package/name"],
    "env": { "API_KEY": "${API_KEY}" }
  }
}
```

Environment variables use `${VAR_NAME}` syntax and are resolved from the user's
shell environment. Never commit actual secrets.

---

## Naming Conventions

- **kebab-case everywhere** — skill dirs, command files, agent files, MCP server
  keys.
- The `name` field in frontmatter **must match** the directory or file name
  (without extension).
- Plugin names follow the pattern `cais-<role>`.

---

## Commit Messages

Use [Conventional Commits](https://www.conventionalcommits.org/) with the plugin
name as scope:

```
feat(cais-core): add new tech-stack skill
fix(cais-development): correct Railway MCP config
docs(cais-marketing): update content-creation references
refactor(cais-business): simplify pitch command
chore: update marketplace metadata
```

- `feat` — new skill, command, agent, hook, or MCP server
- `fix` — bug fix or correction
- `docs` — documentation changes only
- `refactor` — restructure without behavior change
- `chore` — maintenance, dependency updates

---

## Version Bumping

**Every time you make changes to a plugin, you MUST bump its version in
`.claude-plugin/marketplace.json` before committing.**

- Use [Semantic Versioning](https://semver.org/):
  - **patch** (e.g. `1.2.0` → `1.2.1`) — bug fixes, typo corrections, minor
    tweaks
  - **minor** (e.g. `1.2.1` → `1.3.0`) — new skills, commands, hooks, agents, or
    MCP servers added
  - **major** (e.g. `1.3.0` → `2.0.0`) — breaking changes to existing skills,
    commands, or plugin structure
- The version field lives in each plugin's entry inside the root
  `.claude-plugin/marketplace.json`.
- If a single commit touches multiple plugins, bump each one independently.
- **Also bump the top-level `metadata.version`** in
  `.claude-plugin/marketplace.json` whenever any plugin is added, removed, or
  the marketplace structure itself changes.

---

## Quality Checklist

Before committing changes to any plugin, verify:

- [ ] **Frontmatter is valid** — all required fields present, YAML parses
      correctly
- [ ] **Name matches directory/file** — `name` field equals the kebab-case dir
      or filename
- [ ] **Correct plugin** — skill placed in the right plugin for its audience
- [ ] **Version bumped** — plugin version in `marketplace.json` incremented
      (minor for new content, patch for fixes)
- [ ] **No secrets** — no API keys, tokens, or passwords in committed files
- [ ] **Conventional Commit** — message follows `type(scope): description`
      format
- [ ] **README updated (plugin changes)** — if a plugin was added, renamed, or
      removed, update the plugin table and install instructions in `README.md`
- [ ] **README updated (env variables)** — if an MCP server was added or removed
      that requires a new environment variable (or removes one), update the
      setup instructions in `README.md` so users know which keys to configure
