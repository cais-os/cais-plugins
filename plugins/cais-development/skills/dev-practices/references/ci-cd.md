# CI/CD Conventions

Standardized GitHub Actions pipelines across all Cais products.

## Environments

Every project has three environments:

| Environment | Branch    | Purpose             |
| ----------- | --------- | ------------------- |
| Development | `dev`     | Auto-deploy on push |
| Staging     | `staging` | Auto-deploy on push |
| Production  | `main`    | Auto-deploy on push |

## Standard Job Sequence

**MVP** (start here): `deploy`

**Full project** (add gates as needed): `lint → test → build → deploy`

## Trigger Pattern

```yaml
on:
  push:
    branches: [main, staging, develop]
  pull_request:
    branches: [main, staging]
```

## Secrets Naming

```
# Vercel
VERCEL_TOKEN
VERCEL_ORG_ID
VERCEL_PROJECT_ID

# Supabase — flat names, scoped by GitHub Environment
SUPABASE_ACCESS_TOKEN
SUPABASE_ANON_KEY
SUPABASE_SERVICE_ROLE
SUPABASE_DB_PASSWORD
SUPABASE_PROJECT_ID

# Expo / EAS
EXPO_TOKEN
EXPO_APPLE_TEAM_ID

# Railway
RAILWAY_TOKEN_{ENV}

# Sentry
SENTRY_AUTH_TOKEN
SENTRY_ORG
SENTRY_PROJECT

# PostHog
POSTHOG_KEY_{ENV}
```

## Workflow Templates

### Next.js → Vercel

Vercel auto-deploys from GitHub — no workflow needed unless adding lint/test
gates.

### Expo → EAS

See `.github/workflows/expo.yml` template.

### Express → Railway

See `.github/workflows/express.yml` template.

### Supabase Migrations

See `.github/workflows/supabase.yml` template.

## Uploading Secrets from Env Files

```bash
gh secret set --env-file .env.staging  --env Staging
gh secret set --env-file .env.production --env Production
```

Re-run whenever `.env.staging` or `.env.production` changes.

## Common Mistakes

- Never hardcode tokens in YAML — use `${{ secrets.X }}`
- Never deploy to production without staging first
- Never use `ubuntu-latest` for iOS builds — use `macos-latest`

## After Creating Workflows

Output:

1. The workflow YAML file(s) created
2. A checklist of secrets to configure in GitHub
3. Branch strategy reminder (develop → staging → main)
4. Link to GitHub Actions tab
