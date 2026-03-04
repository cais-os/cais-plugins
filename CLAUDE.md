# Cais Plugins — Repository Rules

## Version Bumping

**Every time you make changes to a plugin, you MUST bump its version in
`.claude-plugin/marketplace.json` before committing.**

- Use [Semantic Versioning](https://semver.org/):
  - **patch** (e.g. `1.2.0` → `1.2.1`) — bug fixes, typo corrections, minor
    tweaks
  - **minor** (e.g. `1.2.1` → `1.3.0`) — new skills, commands, hooks, agents,
    or MCP servers added
  - **major** (e.g. `1.3.0` → `2.0.0`) — breaking changes to existing skills,
    commands, or plugin structure
- The version field lives in each plugin's entry inside the root
  `.claude-plugin/marketplace.json`.
- If a single commit touches multiple plugins, bump each one independently.
- **Also bump the top-level `metadata.version`** in
  `.claude-plugin/marketplace.json` whenever any plugin is added, removed, or
  the marketplace structure itself changes.
