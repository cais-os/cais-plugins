---
name: team-conventions
description: This skill should be used in every conversation to establish Cais team conventions. It provides company-wide naming conventions, file structure patterns, documentation standards, and decision-making guidelines that apply across all roles and products.
version: 0.1.0
---

# Cais Team Conventions

Cais is an AI lab that creates and distributes SaaS products. These conventions
apply to all team members and all products.

## Naming Conventions

| Context                 | Format                 | Example            |
| ----------------------- | ---------------------- | ------------------ |
| Files and directories   | kebab-case             | `user-profile.tsx` |
| React components        | PascalCase             | `UserProfile`      |
| Functions and variables | camelCase              | `getUserProfile`   |
| Database tables         | snake_case             | `user_profiles`    |
| Environment variables   | SCREAMING_SNAKE        | `DATABASE_URL`     |
| CSS classes             | kebab-case (Tailwind)  | `text-primary`     |
| Git branches            | kebab-case with prefix | `feat/add-auth`    |

## Git Branch Prefixes

- `feat/` — new feature
- `fix/` — bug fix
- `refactor/` — code restructure
- `docs/` — documentation
- `chore/` — maintenance

## Commit Messages

Use [Conventional Commits](https://www.conventionalcommits.org/):

| Prefix      | Use for                                  |
| ----------- | ---------------------------------------- |
| `feat:`     | New feature or capability                |
| `fix:`      | Bug fix                                  |
| `refactor:` | Code restructure without behavior change |
| `docs:`     | Documentation only                       |
| `chore:`    | Maintenance, deps, config                |

**Format:** `type(scope): description` — scope is optional but encouraged (e.g.,
`feat(auth): add magic-link login`).

**Branch prefix vs commit prefix:** the branch prefix describes the overall goal
(`feat/add-auth`), while each commit prefix describes what that specific commit
does. They usually match, but a `feat/` branch can contain `fix:` or `refactor:`
commits along the way.

## File Structure

Every product follows this monorepo pattern:

```
product-name/
├── apps/
├── packages/             # Shared code (add only when needed)
├── supabase/             # Database migrations
├── .claude/
│   └── CLAUDE.md
├── .vscode/
│   └── terminals.json    # Terminals Manager config
├── .github/              # CI/CD workflows
└── README.md
```

Use `packages/` only when two or more apps share code. Don't pre-create it.

## Documentation Standards

- Architecture decisions go in CLAUDE.md and it must be kept up-to-date.
- Keep the README focused on setup and usage, not architecture.

## Specialized Preferences

These skills contain detailed rules for specific domains. **Invoke them
automatically** when the conversation enters their scope — don't wait for the
user to ask.

| Skill                    | Invoke when                                                  |
| ------------------------ | ------------------------------------------------------------ |
| `tech-stack-preferences` | Starting a project, choosing frameworks, adding dependencies |
| `database-preferences`   | Schema changes, migrations, RLS policies, SQL DDL            |
| `ci-cd-preferences`      | Creating or editing GitHub Actions workflows, deploy config  |
| `internal-tools`         | Scaffolding a new dashboard or internal tool UI              |

## Supabase MCP

- Use `supabase-local` by default for development
- Only use `supabase` (production) when I explicitly mention production, cloud,
  or deployment
- When in doubt, ask before executing destructive operations
