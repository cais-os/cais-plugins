# Cais Plugins

Internal skills, conventions, and MCP servers for the Cais team.

## Plugins

| Plugin           | Who it's for   | What you get                                        |
| ---------------- | -------------- | --------------------------------------------------- |
| **cais-core**    | Everyone       | Team conventions, tech stack defaults, MCP servers   |
| **cais-farol**   | Farol team     | Market research and competitive analysis             |
| **cais-flow**    | Flow team      | Messaging automation                                 |
| **cais-content** | Content team   | Content generation and distribution                  |

## Installation

### 1. Environment variables

Add these to your shell profile (`~/.zshrc` or `~/.bashrc`):

```sh
# Required for MCP servers in cais-core
export GITHUB_PAT="your-github-personal-access-token"
export N8N_MCP_URL="your-n8n-mcp-url"
export N8N_MCP_TOKEN="your-n8n-mcp-token"
export DIGITALOCEAN_API_TOKEN="your-digitalocean-api-token"
```

### 2. Add the Cais marketplace

```
/plugin marketplace add cais-os/cais-plugins
```

### 3. Install the plugins you need

```
/plugin
```

Browse the marketplace and install `cais-core` (everyone) plus any product
plugins relevant to you.

### 4. Add team conventions to your CLAUDE.md

Add this to `~/.claude/CLAUDE.md`:

```markdown
## Team Conventions

- **Always apply Cais team conventions.** At the start of every conversation,
  use the `team-conventions` skill from `cais-core` to load company-wide naming
  conventions, file structure patterns, documentation standards, and
  decision-making guidelines.
- This applies to all work — new projects, feature development, code reviews,
  and refactoring.
```

### 5. Install standalone skills

Run `/update-skills` in Claude Code to install recommended standalone skills
from the team manifest.

## Recommended Plugin Marketplaces

These are official third-party plugin marketplaces we use. Add each one and
enable auto-update:

| Tool / Framework   | Install command                                          |
| ------------------ | -------------------------------------------------------- |
| Expo               | `/plugin marketplace add expo/skills`                    |
| Railway            | `/plugin marketplace add railwayapp/railway-skills`      |

After adding a marketplace, enable auto-update in the `/plugin` menu under
Marketplaces so skills stay current.

## Recommended Remote MCPs

Add these individually in Claude Code or Claude Desktop settings. They are
**not** bundled in the plugin to avoid duplication across environments:

| Service     | URL                                |
| ----------- | ---------------------------------- |
| Stripe      | `https://mcp.stripe.com/`         |
| Figma       | `https://mcp.figma.com/mcp`       |
| Notion      | `https://mcp.notion.com/mcp`      |
| Sentry      | `https://mcp.sentry.dev/mcp`      |
| Vercel      | `https://mcp.vercel.com`          |
| PostHog     | `https://mcp.posthog.com/mcp`     |
| Axiom       | `https://mcp.axiom.co/mcp`        |
| Postman     | `https://mcp.postman.com/mcp`     |
| Supabase    | `https://mcp.supabase.com/mcp`    |
| Canva       | `https://mcp.canva.com/mcp`       |
| RevenueCat  | `https://mcp.revenuecat.ai/mcp`   |
| Excalidraw  | `https://mcp.excalidraw.com/mcp`  |
