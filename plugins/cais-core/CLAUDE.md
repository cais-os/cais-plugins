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
feat(scope): add new feature
fix(scope): fix a bug
docs(scope): update documentation
refactor(scope): restructure without behavior change
chore(scope): maintenance tasks
```

## Quality Standards

- Every product ships with CI/CD from day one.
- Write tests for business-critical paths.
- Document architecture decisions in project CLAUDE.md files.
