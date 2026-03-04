# Expo → EAS CI/CD Reference

Build and submit Expo apps via EAS Build. Handles preview builds for PRs and
production builds for main.

## Workflow: `.github/workflows/expo.yml`

```yaml
name: Expo CI/CD

on:
    push:
        branches: [main, staging, develop]
    pull_request:
        branches: [main, staging]

jobs:
    build-preview:
        name: EAS Build (Preview)
        runs-on: ubuntu-latest
        if: github.event_name == 'pull_request'
        steps:
            - uses: actions/checkout@v6

            - uses: actions/setup-node@v6
              with:
                  node-version: "22.x"

            - name: Setup EAS
              uses: expo/expo-github-action@v8
              with:
                  eas-version: latest
                  token: ${{ secrets.EXPO_TOKEN }}

            - run: npm ci

            - name: EAS Build (preview)
              run: eas build --platform all --profile preview --non-interactive
              env:
                  EXPO_TOKEN: ${{ secrets.EXPO_TOKEN }}

    build-staging:
        name: EAS Build (Staging)
        runs-on: ubuntu-latest
        if: github.ref == 'refs/heads/staging' && github.event_name == 'push'
        environment: staging
        steps:
            - uses: actions/checkout@v6

            - uses: actions/setup-node@v6
              with:
                  node-version: "22.x"

            - name: Setup EAS
              uses: expo/expo-github-action@v8
              with:
                  eas-version: latest
                  token: ${{ secrets.EXPO_TOKEN }}

            - run: npm ci

            - name: EAS Update (staging OTA)
              run: eas update --branch staging --message "Staging update from ${{ github.sha }}"
              env:
                  EXPO_TOKEN: ${{ secrets.EXPO_TOKEN }}

    build-production:
        name: EAS Build (Production)
        runs-on: ubuntu-latest
        if: github.ref == 'refs/heads/main' && github.event_name == 'push'
        environment: production
        steps:
            - uses: actions/checkout@v6

            - uses: actions/setup-node@v6
              with:
                  node-version: "22.x"

            - name: Setup EAS
              uses: expo/expo-github-action@v8
              with:
                  eas-version: latest
                  token: ${{ secrets.EXPO_TOKEN }}

            - run: npm ci

            - name: EAS Build (production)
              run: eas build --platform all --profile production --non-interactive
              env:
                  EXPO_TOKEN: ${{ secrets.EXPO_TOKEN }}

            - name: EAS Submit (production)
              run: eas submit --platform all --latest --non-interactive
              env:
                  EXPO_TOKEN: ${{ secrets.EXPO_TOKEN }}
                  APPLE_TEAM_ID: ${{ secrets.APPLE_TEAM_ID }}
```

## Required Secrets

```
EXPO_TOKEN        # expo.dev → Account → Access Tokens
APPLE_TEAM_ID     # Apple Developer Portal → Membership
```

## Required eas.json profiles

```json
{
    "build": {
        "preview": {
            "distribution": "internal",
            "android": { "buildType": "apk" }
        },
        "staging": {
            "distribution": "internal",
            "channel": "staging"
        },
        "production": {
            "channel": "production",
            "autoIncrement": true
        }
    },
    "submit": {
        "production": {
            "ios": { "appleTeamId": "YOUR_TEAM_ID" },
            "android": { "track": "internal" }
        }
    }
}
```

## Notes

- OTA updates via `eas update` are used for staging (faster iteration)
- Full native builds via `eas build` are used for production (store submission)
- `macos-latest` runner is only needed for builds that require a Mac (simulator
  testing); EAS handles the actual iOS build in their cloud

---

## Adding Quality Gates (when the project is past MVP, or the user explicitly asks for tests/lint)

Add these jobs to the workflow and wire `needs: [lint, test]` into the build
jobs.

```yaml
lint:
    name: Lint & Type Check
    runs-on: ubuntu-latest
    steps:
        - uses: actions/checkout@v6
        - uses: actions/setup-node@v6
          with:
              node-version: "22.x"
        - run: npm ci
        - run: npm run lint
        - run: npm run type-check

test:
    name: Tests
    runs-on: ubuntu-latest
    needs: lint
    steps:
        - uses: actions/checkout@v6
        - uses: actions/setup-node@v6
          with:
              node-version: "22.x"
        - run: npm ci
        - run: npm test -- --passWithNoTests
```

Then update each build job to gate on them:

```yaml
build-preview:
    needs: [lint, test]
    ...

build-staging:
    needs: [lint, test]
    ...

build-production:
    needs: [lint, test]
    ...
```
