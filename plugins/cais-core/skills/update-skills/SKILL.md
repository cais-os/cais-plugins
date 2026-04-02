---
name: update-skills
description: >-
  Install and update recommended standalone skills from the team manifest.
  Use when setting up a new machine, onboarding, or when told to update skills.
  Triggers on "update skills", "install skills", "setup skills",
  "install recommended skills".
disable-model-invocation: true
allowed-tools: Bash(npx:*) Read
---

# Update Skills

Install and update standalone skills recommended for the Cais team. These are
skills that don't come from an official plugin marketplace and need to be
installed via `npx skills add`.

## Step 1 — Read the manifest

Read the manifest file at `${CLAUDE_SKILL_DIR}/skills-manifest.json`. This file
lists all recommended standalone skills with their source repos and skill names.

## Step 2 — Check what's already installed

Run `npx skills ls -g` to see what's currently installed globally.

## Step 3 — Install missing skills

For each entry in the manifest, run:

```bash
npx skills add <source> --skill <name> -g -y -a claude-code
```

If a skill is already installed, `npx skills add` will skip it. Run the command
for all manifest entries regardless — it's safe to re-run.

## Step 4 — Update all skills

After installing any missing skills, run:

```bash
npx skills update
```

This updates all globally installed skills to their latest versions.

## Step 5 — Report results

Tell the user:
- How many skills were installed or updated
- Any errors that occurred
- Remind them that plugin-based skills (Expo, Railway, etc.) are updated
  separately via `/plugin marketplace update`
