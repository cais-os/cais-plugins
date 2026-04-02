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

---

## Recommended Plugin Marketplaces

Official third-party plugin marketplaces we use. Add each one in Claude Code
and **enable auto-update** so skills stay current:

| Tool / Framework   | Install command                                          |
| ------------------ | -------------------------------------------------------- |
| Expo               | `/plugin marketplace add expo/skills`                    |
| Railway            | `/plugin marketplace add railwayapp/railway-skills`      |

After adding a marketplace, enable auto-update in the `/plugin` menu under
Marketplaces.

---

## Recommended MCPs

We don't bundle remote MCPs in the plugin to avoid duplication between Claude
Code and Claude Desktop. Instead, each team member adds them individually.

### Built-in connectors (Claude Desktop)

These are first-party integrations — just enable them in Claude Desktop under
**Connectors**:

| Connector        | What it does                          |
| ---------------- | ------------------------------------- |
| GitHub           | Issues, PRs, code search              |
| Gmail            | Email search and drafts               |
| Google Calendar  | Events, scheduling, free time         |
| Google Drive     | File search and access                |
| Figma            | Design context and screenshots        |
| Notion           | Pages, databases, search              |
| Canva            | Design generation and editing         |
| Excalidraw       | Diagrams and whiteboarding            |
| Sentry           | Error tracking and issue management   |
| Stripe           | Payments, subscriptions, customers    |
| Supabase         | Database, auth, edge functions        |
| PostHog          | Analytics, feature flags, experiments |
| Vercel           | Deployments, projects, logs           |

### Custom connectors (manual setup)

These require manual URL configuration in Claude Desktop or Claude Code:

| Service     | URL                                | Notes                       |
| ----------- | ---------------------------------- | --------------------------- |
| Axiom       | `https://mcp.axiom.co/mcp`        | Observability and logging   |
| Postman     | `https://mcp.postman.com/mcp`     | API testing and collections |
| RevenueCat  | `https://mcp.revenuecat.ai/mcp`   | In-app purchases and subs   |

### Local MCPs (bundled in cais-core)

These are included in the `cais-core` plugin and work automatically in Claude
Code. They require local tools (Node.js, Docker) to be installed:

| Server         | Transport | What it does                        |
| -------------- | --------- | ----------------------------------- |
| github         | HTTP      | GitHub Copilot API (needs `GITHUB_PAT`) |
| supabase-local | HTTP      | Local Supabase dev instance         |
| Railway        | stdio     | Railway project management          |
| next-devtools  | stdio     | Next.js dev tools                   |
| shadcn         | stdio     | shadcn/ui component management      |
| trigger        | stdio     | Trigger.dev task management         |
| n8n            | stdio     | n8n workflow automation (needs `N8N_MCP_*`) |
| digitalocean   | stdio     | DigitalOcean infrastructure (needs `DIGITALOCEAN_API_TOKEN`) |
| redis          | stdio     | Redis via Docker                    |
| playwright     | stdio     | Browser automation and testing      |
