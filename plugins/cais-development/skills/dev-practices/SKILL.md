---
name: dev-practices
description: This skill should be used when writing code, reviewing PRs, scaffolding projects, setting up CI/CD, creating database migrations, choosing tech stack, or making any development decisions for Cais products. Triggers on "start a new project", "scaffold", "set up CI/CD", "create migration", "add a table", "which framework", "tech stack".
version: 0.1.0
---

# Cais Development Practices

Apply these standards across all Cais products. Deviate only with a documented
reason in the project's CLAUDE.md.

## Tech Stack

### MVP Stack

| Layer                     | Tool                 |
| ------------------------- | -------------------- |
| Web framework             | Next.js (App Router) |
| UI                        | shadcn/ui + Tailwind |
| Web hosting               | Vercel               |
| Mobile framework          | Expo                 |
| Mobile UI                 | NativeWind           |
| Mobile state              | TanStack Query       |
| Mobile distribution       | EAS                  |
| Database + Auth + Storage | Supabase             |
| Async jobs                | Trigger.dev          |
| Version control           | GitHub               |
| CI/CD                     | GitHub Actions       |
| Payments (web)            | Stripe               |
| Payments (mobile)         | RevenueCat           |

### Extended Stack (Product-stage)

| Layer                     | Tool                        |
| ------------------------- | --------------------------- |
| Error tracking            | Sentry                      |
| Analytics + Feature flags | PostHog                     |
| Backend framework         | Express.js                  |
| Async queue               | Redis + BullMQ + Bull Board |
| Backend hosting           | Railway                     |
| Logging                   | Pino                        |
| Observability             | Axiom                       |
| VPS                       | DigitalOcean                |
| Email                     | Resend                      |
| SMS + WhatsApp            | Twilio                      |
| Cloud GPU                 | Modal                       |

### Opinionated Defaults

- **Package manager:** pnpm
- **Icons:** Lucide React
- **Animations:** Motion (Framer Motion)
- **Client state:** Zustand
- **Database access:** Raw Supabase client (no ORM)
- **Dates:** date-fns
- **Forms:** React Hook Form
- **Schema validation:** Zod

## CI/CD Standards

Refer to `references/ci-cd.md` for full CI/CD pipeline conventions including
environments, secrets naming, and workflow templates.

## Database Rules

Refer to `references/database.md` for database migration rules, naming
conventions, and Supabase-specific patterns.

## Development Environment

- **AI:** Claude Code
- **IDE:** Cursor
- **Terminal:** Ghostty
- **Browser:** Chrome
- **Containers:** Docker

## After Scaffolding

Generate a CLAUDE.md at the project root documenting:

- The stack chosen (with any deviations and why)
- Key architectural decisions
- Project-specific conventions

## Additional Resources

### Reference Files

- **`references/ci-cd.md`** — Full CI/CD pipeline conventions
- **`references/database.md`** — Database migration and schema rules
