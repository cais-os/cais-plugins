# Express → Railway CI/CD Reference

Deploy Node/Express APIs to Railway with Docker. Supports staging and production
environments.

## Workflow: `.github/workflows/express.yml`

```yaml
name: Express API CI/CD

on:
    push:
        branches: [main, staging, develop]
    pull_request:
        branches: [main, staging]

env:
    NODE_VERSION: "22.x"

jobs:
    build:
        name: Docker Build
        runs-on: ubuntu-latest
        if: github.event_name == 'push'
        steps:
            - uses: actions/checkout@v6

            - name: Set up Docker Buildx
              uses: docker/setup-buildx-action@v3

            - name: Build Docker image
              uses: docker/build-push-action@v6
              with:
                  context: .
                  push: false
                  tags: api:${{ github.sha }}

    deploy-staging:
        name: Deploy to Railway (Staging)
        runs-on: ubuntu-latest
        needs: build
        if: github.ref == 'refs/heads/staging' && github.event_name == 'push'
        environment: staging
        steps:
            - uses: actions/checkout@v6

            - name: Install Railway CLI
              run: npm install -g @railway/cli

            - name: Deploy to Railway staging
              run: railway up --service api
              env:
                  RAILWAY_TOKEN: ${{ secrets.RAILWAY_TOKEN_STAGING }}

    deploy-production:
        name: Deploy to Railway (Production)
        runs-on: ubuntu-latest
        needs: build
        if: github.ref == 'refs/heads/main' && github.event_name == 'push'
        environment: production
        steps:
            - uses: actions/checkout@v6

            - name: Install Railway CLI
              run: npm install -g @railway/cli

            - name: Deploy to Railway production
              run: railway up --service api
              env:
                  RAILWAY_TOKEN: ${{ secrets.RAILWAY_TOKEN_PRODUCTION }}
```

## Required Secrets

```
RAILWAY_TOKEN_STAGING      # Railway → Project → Settings → Tokens
RAILWAY_TOKEN_PRODUCTION
```

## Dockerfile template (if not present)

```dockerfile
FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:22-alpine
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
EXPOSE 3000
CMD ["node", "dist/index.js"]
```

## Notes

- Redis + BullMQ services should be in separate Railway services, not the same
  deploy
- Pino logs integrate automatically with Axiom via Railway's log drain — no
  extra step needed
- Use `railway variables` to sync env vars instead of GitHub secrets for
  Railway-specific config

---

## Adding Quality Gates (when the project is past MVP, or the user explicitly asks for tests/lint)

Add these jobs to the workflow and wire `needs: [lint, test]` into the build
job.

```yaml
lint:
    name: Lint & Type Check
    runs-on: ubuntu-latest
    steps:
        - uses: actions/checkout@v6
        - uses: actions/setup-node@v6
          with:
              node-version: ${{ env.NODE_VERSION }}
        - run: npm ci
        - run: npm run lint
        - run: npm run type-check

test:
    name: Tests
    runs-on: ubuntu-latest
    needs: lint
    env:
        NODE_ENV: test
        DATABASE_URL: ${{ secrets.SUPABASE_URL_STAGING }}
    steps:
        - uses: actions/checkout@v6
        - uses: actions/setup-node@v6
          with:
              node-version: ${{ env.NODE_VERSION }}
        - run: npm ci
        - run: npm test -- --passWithNoTests
```

Then update the build job to gate on them:

```yaml
build:
    needs: [lint, test]
    ...
```

Also add `SUPABASE_URL_STAGING` to the required secrets when the test job is
active.
