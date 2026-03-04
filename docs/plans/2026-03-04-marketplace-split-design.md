# Cais Plugins Marketplace — Design Doc

**Date:** 2026-03-04 **Status:** Approved

## Summary

Split the monolithic `cais` plugin into 4 role-based plugins distributed via a
`cais-plugins` marketplace. Each team member installs `cais-core` plus their
role-specific plugin.

## Plugins

| Plugin             | Purpose                                    | Skills                            | Commands          | Agents                  |
| ------------------ | ------------------------------------------ | --------------------------------- | ----------------- | ----------------------- |
| `cais-core`        | Shared conventions, product context, hooks | team-conventions, product-context | /brief            | —                       |
| `cais-development` | Dev practices, design system, code review  | dev-practices, design-system      | /standup, /review | code-standards-reviewer |
| `cais-marketing`   | Content creation, brand voice              | content-creation                  | /draft            | brand-voice-checker     |
| `cais-business`    | Business strategy, pitches, metrics        | business-ops                      | /pitch            | —                       |

## Directory Structure

```
cais-plugins/
├── .claude-plugin/
│   └── marketplace.json
├── plugins/
│   ├── cais-core/
│   │   ├── .claude-plugin/plugin.json
│   │   ├── skills/
│   │   │   ├── team-conventions/SKILL.md
│   │   │   └── product-context/
│   │   │       ├── SKILL.md
│   │   │       └── references/products/
│   │   ├── commands/brief.md
│   │   ├── hooks/
│   │   │   ├── hooks.json
│   │   │   └── scripts/check-commit-message.sh
│   │   └── CLAUDE.md
│   ├── cais-development/
│   │   ├── .claude-plugin/plugin.json
│   │   ├── skills/
│   │   │   ├── dev-practices/
│   │   │   │   ├── SKILL.md
│   │   │   │   └── references/ (ci-cd.md, database.md)
│   │   │   └── design-system/SKILL.md
│   │   ├── commands/ (standup.md, review.md)
│   │   └── agents/code-standards-reviewer.md
│   ├── cais-marketing/
│   │   ├── .claude-plugin/plugin.json
│   │   ├── skills/content-creation/SKILL.md
│   │   ├── commands/draft.md
│   │   └── agents/brand-voice-checker.md
│   └── cais-business/
│       ├── .claude-plugin/plugin.json
│       ├── skills/business-ops/SKILL.md
│       └── commands/pitch.md
└── README.md
```

## Marketplace Schema

`marketplace.json` at root lists all 4 plugins with relative path sources. Uses
`pluginRoot: "./plugins"` metadata for cleaner source paths.

## Installation Flow

```bash
# Add marketplace (once)
/plugin marketplace add owner/cais-plugins

# Per role:
/plugin install cais-core@cais-plugins
/plugin install cais-development@cais-plugins   # developer
/plugin install cais-marketing@cais-plugins      # marketer
/plugin install cais-business@cais-plugins       # businessman
```

## Migration Notes

- All skill/command/agent content is moved as-is from `cais/`
- Update cross-references in CLAUDE.md to use new plugin namespaces
- Update commands that reference skills from other plugins
- Remove old `cais/` directory after migration
- Hooks (commit message validation) move to `cais-core`

## Decisions

- **Monorepo:** Single repo for all plugins + marketplace. Easier to maintain
  for a 3-person team.
- **Shared core:** `cais-core` holds cross-role conventions. Avoids duplication.
- **Naming:** `cais-*` prefix matches team identity.
- **No MCP servers yet:** `.mcp.json` was empty, so not included. Can be added
  per-plugin later.
