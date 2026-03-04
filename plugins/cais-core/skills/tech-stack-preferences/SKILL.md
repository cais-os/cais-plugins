---
name: tech-stack-preferences
description: This skill should be used when the user starts a new project, says "scaffold a new app", "create a new project", "set up a new service", "add a new component", or asks which tools or frameworks to use. Provides the user's default technology baseline for web, mobile, back-end, and infrastructure.
version: 1.0.0
---

# Preferred Tech Stack

Apply this stack as the default baseline when starting a new project or adding
new components to an existing one. Deviate only when there is a clear technical
reason — and document why in `CLAUDE.md`.

## MVP Stack

### Web

- **Framework:** Next.js with App Router
- **UI:** shadcn/ui + Tailwind
- **Hosting:** Vercel

### Mobile

- **Framework:** Expo
- **UI:** NativeWind
- **Mobile State / Data:** TanStack Query
- **Distribution:** EAS

### Back-end

- **Database + Auth + Storage:** Supabase
- **Async Jobs:** Trigger.dev

### Infrastructure

- **Version Control:** GitHub
- **Environments:** Development · Staging · Production
- **CI/CD:** GitHub Actions
- **Payments (web):** Stripe
- **Payments (mobile):** RevenueCat

### Development Environment

- **AI:** Claude Code
- **IDE:** Cursor
- **Terminal:** Ghostty
- **Browser:** Chrome
- **Containers:** Docker

## Extended Stack (Product-stage)

### Observability

- **Error Tracking:** Sentry
- **Analytics + A/B + Feature Flags:** PostHog

### Serverless / Back-end Services

- **Framework:** Express.js
- **Async Queue:** Redis + BullMQ + Bull Board
- **Hosting:** Railway
- **Logging:** Pino
- **Observability:** Axiom

### Add-ons

- **Monorepo Tooling:** Turborepo (only when build performance is needed)
- **VPS:** DigitalOcean
- **Email:** Resend
- **SMS + WhatsApp:** Twilio
- **Cloud GPU:** Modal

## Opinionated Defaults

Apply these across all projects unless there's a clear reason not to.

### Tooling

- **Package manager:** pnpm
- **Icons:** Lucide React
- **Animations:** Framer Motion (now Motion)

### Data & State

- **Client state:** Zustand
- **Database access:** Raw Supabase client (no ORM)
- **Dates:** date-fns

### Forms & Validation

- **Forms:** React Hook Form
- **Schema validation:** Zod (forms, API boundaries, env vars)

## After Scaffolding

Generate a `CLAUDE.md` at `.claude/CLAUDE.md` documenting:

- The stack chosen for this project (with any deviations from the default and
  why)
- Key architectural decisions made during scaffolding
- Any project-specific conventions to follow going forward
