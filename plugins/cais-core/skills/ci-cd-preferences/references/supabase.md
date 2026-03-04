# Supabase CI/CD Reference

Deploy Supabase (migrations, functions, config, secrets) to staging and
production. Applies to staging and production only — never to dev.

## Workflow: `.github/workflows/supabase.yml`

```yaml
name: Supabase Deploy

on:
  push:
    branches: [main, staging]

jobs:
  deploy-staging:
    name: Deploy to Staging
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/staging'
    environment: staging

    env:
      SUPABASE_ACCESS_TOKEN: ${{ secrets.SUPABASE_ACCESS_TOKEN }}
      SUPABASE_DB_PASSWORD: ${{ secrets.SUPABASE_DB_PASSWORD }}
      SUPABASE_PROJECT_ID: ${{ secrets.SUPABASE_PROJECT_ID }}

    steps:
      - uses: actions/checkout@v4

      - uses: supabase/setup-cli@v1
        with:
          version: latest

      - run: supabase link --project-ref $SUPABASE_PROJECT_ID
      - run: supabase db push
      - run: supabase functions deploy
      - run: supabase config push
      # Add secrets set steps here as needed, e.g.:
      # - run: supabase secrets set MY_SECRET=${{ secrets.MY_SECRET }}

  deploy-production:
    name: Deploy to Production
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    environment: production

    env:
      SUPABASE_ACCESS_TOKEN: ${{ secrets.SUPABASE_ACCESS_TOKEN }}
      SUPABASE_DB_PASSWORD: ${{ secrets.SUPABASE_DB_PASSWORD }}
      SUPABASE_PROJECT_ID: ${{ secrets.SUPABASE_PROJECT_ID }}

    steps:
      - uses: actions/checkout@v4

      - uses: supabase/setup-cli@v1
        with:
          version: latest

      - run: supabase link --project-ref $SUPABASE_PROJECT_ID
      - run: supabase db push
      - run: supabase functions deploy
      - run: supabase config push
      # Add secrets set steps here as needed, e.g.:
      # - run: supabase secrets set MY_SECRET=${{ secrets.MY_SECRET }}
```

## Required Secrets

Each GitHub environment (`staging`, `production`) has its own isolated secret
store — secrets share the same names across environments because the values
differ per environment (sourced from `.env.staging` / `.env.production`):

```
SUPABASE_ACCESS_TOKEN
SUPABASE_DB_PASSWORD
SUPABASE_PROJECT_ID
```

Add additional secrets per project (e.g. `OPENAI_API_KEY`, `STRIPE_SECRET_KEY`)
to both environment secret stores and include them as `supabase secrets set`
steps.

## CI Workflow: `.github/workflows/ci.yaml`

Runs on every PR to validate migrations and keep generated types in sync.

```yaml
name: CI

on:
  pull_request:
  workflow_dispatch:

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - uses: supabase/setup-cli@v1
        with:
          version: latest

      - name: Start Supabase local development setup
        run: supabase db start

      - name: Verify generated types are checked in
        run: |
          supabase gen types typescript --local > types.gen.ts
          if ! git diff --ignore-space-at-eol --exit-code --quiet types.gen.ts; then
            echo "Detected uncommitted changes after build. See status below:"
            git diff
            exit 1
          fi
```

## Notes

- Triggers on every push to `main`/`staging` — no path filter
- Staging deploys from `staging` branch; production deploys from `main`
- Secret isolation is handled by GitHub environments, not by secret name
  suffixes
- Never run `supabase db reset` in CI — destructive on remote
- Generate types locally
  (`supabase gen types typescript --local > types.gen.ts`) and commit them; the
  CI workflow enforces they stay in sync
