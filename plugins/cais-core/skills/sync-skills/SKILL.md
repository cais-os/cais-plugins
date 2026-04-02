---
name: sync-skills
description: >-
  Sync the standalone skills manifest with your locally installed skills.
  For plugin contributors only. Reads npx skills ls -g and updates the
  manifest in the cais-plugins repo. Triggers on "sync skills",
  "sync skills manifest", "update skills manifest".
disable-model-invocation: true
allowed-tools: Bash(npx:*) Read Write Edit
---

# Sync Skills Manifest

Update the standalone skills manifest based on your locally installed global
skills. This is a **contributor-only** workflow — it updates the manifest file
that `/update-skills` reads.

## Step 1 — Locate the cais-plugins repo

The manifest lives at:
`plugins/cais-core/skills/update-skills/skills-manifest.json`

If you're not in the cais-plugins repo, search for it:

```bash
for dir in ~ ~/Projetos ~/Projects ~/repos ~/code ~/dev ~/src; do
  if [ -d "$dir" ]; then
    find "$dir" -maxdepth 3 -name "marketplace.json" -path "*/.claude-plugin/*" 2>/dev/null | while read f; do
      repo_dir="$(dirname "$(dirname "$f")")"
      if grep -q "cais-plugins" "$f" 2>/dev/null; then
        echo "$repo_dir"
      fi
    done
  fi
done
```

## Step 2 — Read current global skills

Run `npx skills ls -g` and parse the output to get all installed skill names
and their locations.

## Step 3 — Read the current manifest

Read `plugins/cais-core/skills/update-skills/skills-manifest.json` to see
what's currently listed.

## Step 4 — Compare and propose changes

Show the contributor:
- Skills installed locally but **not in the manifest** (candidates to add)
- Skills in the manifest but **not installed locally** (candidates to remove)

**Important:** Only include skills that should be shared with the team. Skip
personal or experimental skills. Ask the contributor to confirm each
addition/removal.

## Step 5 — Update the manifest

Edit `skills-manifest.json` with the confirmed changes. Group skills by source
repo. Maintain the existing JSON structure:

```json
{
  "source": "<github-org/repo>",
  "names": ["skill-1", "skill-2"],
  "description": "<brief description of this source>"
}
```

## Step 6 — Report

Show the updated manifest and remind the contributor to commit and push:

```
Manifest updated. To share with the team:
  git add plugins/cais-core/skills/update-skills/skills-manifest.json
  git commit -m "feat(cais-core): update standalone skills manifest"
  git push
```
