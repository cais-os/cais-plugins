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

## File Structure

Every product follows this general pattern:

```
product-name/
├── .claude/           # AI conventions for this product
│   └── CLAUDE.md
├── .github/           # CI/CD workflows
├── src/               # Source code
├── supabase/          # Database migrations
└── README.md
```

## Documentation Standards

- Every product has a CLAUDE.md at the project root.
- Architecture decisions go in CLAUDE.md, not separate ADR files.
- Keep READMEs focused on setup and usage, not architecture.

## Decision Making

- When multiple valid approaches exist, document the trade-offs briefly and pick
  one.
- Favor consistency with existing patterns over "better" alternatives.
- If deviating from team conventions, document why in the project CLAUDE.md.

## Specialized Preferences

These skills contain detailed rules for specific domains. **Invoke them
automatically** when the conversation enters their scope — don't wait for the
user to ask.

| Skill                    | Invoke when                                                  |
| ------------------------ | ------------------------------------------------------------ |
| `tech-stack-preferences` | Starting a project, choosing frameworks, adding dependencies |
| `database-preferences`   | Schema changes, migrations, RLS policies, SQL DDL            |
| `ci-cd-preferences`      | Creating or editing GitHub Actions workflows, deploy config  |

## Supabase MCP

- Use `supabase-local` by default for development
- Only use `supabase` (production) when I explicitly mention production, cloud,
  or deployment
- When in doubt, ask before executing destructive operations
