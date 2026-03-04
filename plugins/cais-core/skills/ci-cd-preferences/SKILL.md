---
name: ci-cd-preferences
description: >
  Use this skill whenever the user needs to create, update, review, or debug GitHub Actions
  workflows for any project in their stack. Triggers on requests like "set up CI/CD", "create
  a pipeline", "add GitHub Actions", "configure deployment", "set up tests in CI", "add workflow",
  "automate deploys", "set up staging deploy", or whenever a new project is scaffolded and
  needs CI/CD. Also triggers when the user asks about secrets, environments, or deployment
  automation. Always use this skill — don't write GitHub Actions YAML from scratch without it.
---

# CI/CD Skill

Standardizes GitHub Actions pipelines across all projects in the stack:
**Next.js → Vercel**, **Expo → EAS**, **Express/Node → Railway**, **Supabase
migrations**.

## Quick Reference

| Project Type  | Workflow file to create          | Reference doc            |
| ------------- | -------------------------------- | ------------------------ |
| Expo / Mobile | `.github/workflows/expo.yml`     | `references/expo.md`     |
| Express / API | `.github/workflows/express.yml`  | `references/express.md`  |
| Supabase DB   | `.github/workflows/supabase.yml` | `references/supabase.md` |

**Always read the relevant reference file before writing any YAML.**

---

## Core Principles

### Environments

Every project has three environments. Always configure all three:

| Environment | Branch    | Purpose             |
| ----------- | --------- | ------------------- |
| Development | `dev`     | Auto-deploy on push |
| Staging     | `staging` | Auto-deploy on push |
| Production  | `main`    | Auto-deploy on push |

> GitHub environment names are case-sensitive — use whatever casing matches your
> GitHub Settings → Environments. Capitalized (`Production`, `Staging`) is the
> convention here.

### Standard Job Sequence

**MVP default** (start here):

```
deploy
```

**Full project** (add gates as the project grows):

```
lint → test → build → deploy
```

Jobs always run in this order. `deploy` only runs after all previous jobs
succeed. Use `needs:` to enforce dependency between jobs.

> Start simple. Add lint/test gates when the project grows.

### Secrets Naming Convention

Always use this naming pattern for GitHub Secrets:

```
# Vercel
VERCEL_TOKEN
VERCEL_ORG_ID
VERCEL_PROJECT_ID

# Supabase — flat names, scoped by GitHub Environment (not by suffix)
SUPABASE_ACCESS_TOKEN
SUPABASE_ANON_KEY
SUPABASE_SERVICE_ROLE
SUPABASE_DB_PASSWORD
SUPABASE_PROJECT_ID

# Expo / EAS
EXPO_TOKEN
EXPO_APPLE_TEAM_ID

# Railway
RAILWAY_TOKEN_{ENV}         # RAILWAY_TOKEN_STAGING, RAILWAY_TOKEN_PRODUCTION

# Sentry (when configured)
SENTRY_AUTH_TOKEN
SENTRY_ORG
SENTRY_PROJECT

# PostHog (when configured)
POSTHOG_KEY_{ENV}
```

> Supabase secrets use flat names (no `_{ENV}` suffix). Isolation comes from
> targeting different GitHub Environments (`Staging`, `Production`), each with
> its own secret values.

### Standard Trigger Pattern

```yaml
on:
  push:
    branches: [main, staging, develop]
  pull_request:
    branches: [main, staging]
```

---

## Step-by-Step Workflow

### 1. Identify the project type

Ask if not obvious. Check for `next.config.*`, `app.json`/`app.config.ts`,
`Dockerfile`, or Supabase migrations.

### 2. Read the reference file

Open the corresponding file from `references/`. Do not write YAML without it.

### 3. Check for existing workflows

```bash
ls .github/workflows/
```

If files exist, review before creating new ones to avoid conflicts.

### 4. Generate the workflow file(s)

Follow the template in the reference file exactly. Always:

- Use `actions/checkout@v6`
- Pin Node to match `.nvmrc` if present; otherwise use current LTS (`22.x`)
- Use `pnpm` if `pnpm-lock.yaml` exists, `npm` otherwise

### 5. Upload secrets from env files (when present)

Check if `.env.staging` or `.env.production` exist in the project root:

```bash
ls .env.staging .env.production 2>/dev/null
```

If they exist, ask the user to confirm, then run:

```bash
gh secret set --env-file .env.staging  --env Staging
gh secret set --env-file .env.production --env Production
```

**Requirements:** `gh` must be authenticated (`gh auth status`) and the env
files must use `KEY=value` format (no spaces around `=`, comments with `#` are
fine).

> **Re-run `gh secret set` whenever `.env.staging` or `.env.production`
> changes** — it's idempotent and overwrites existing values. Treat it as part
> of the env file update workflow, not a one-time setup.

> **Supabase Edge Function secrets are a separate system.** The `gh secret set`
> command above uploads secrets to GitHub Actions. Edge Function runtime secrets
> must be set via `supabase secrets set KEY=VALUE` inside the workflow (using
> env vars already loaded from GitHub Secrets). See `references/supabase.md`.

### 6. Generate the secrets checklist

After creating workflows (and uploading from env files if applicable), output a
checklist of any remaining secrets that must be added manually to GitHub →
Settings → Secrets and variables → Actions (e.g. tokens not stored in env files
like `VERCEL_TOKEN`, `EXPO_TOKEN`, `RAILWAY_TOKEN_*`).

### 6. Create environment protection rules (when asked)

For `production` environment: require at least 1 reviewer before deploy.

---

## Observability (product-stage)

When Sentry and PostHog are in the project, add these steps to the `build` job:

```yaml
- name: Create Sentry release
  uses: getsentry/action-release@v3
  env:
    SENTRY_AUTH_TOKEN: ${{ secrets.SENTRY_AUTH_TOKEN }}
    SENTRY_ORG: ${{ secrets.SENTRY_ORG }}
    SENTRY_PROJECT: ${{ secrets.SENTRY_PROJECT }}
  with:
    environment: ${{ env.ENVIRONMENT }}
```

---

## Common Mistakes to Avoid

- ❌ Never hardcode tokens, URLs, or keys in YAML — always use
  `${{ secrets.X }}`
- ❌ Never deploy to production without first deploying to staging in the same
  pipeline
- ❌ Never use `ubuntu-latest` for mobile builds — use `macos-latest` for iOS
  steps

---

## After Creating Workflows

Always output:

1. ✅ The workflow YAML file(s) created
2. 🔑 A checklist of secrets to configure in GitHub
3. 🌿 Branch strategy reminder (develop → staging → main)
4. 🔗 Link to GitHub Actions tab: `https://github.com/<org>/<repo>/actions`

Update `CLAUDE.md` at project root with the CI/CD setup if it exists.
