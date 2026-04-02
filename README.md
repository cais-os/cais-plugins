# Cais Plugins

Internal skills, conventions, and MCP servers for the Cais team.

## Plugins

| Plugin           | Who it's for | What you get                                       |
| ---------------- | ------------ | -------------------------------------------------- |
| **cais-core**    | Everyone     | Team conventions, tech stack defaults, MCP servers |
| **cais-farol**   | Farol team   | Market research and competitive analysis           |
| **cais-flow**    | Flow team    | Messaging automation                               |
| **cais-content** | Content team | Content generation and distribution                |

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

Official third-party plugin marketplaces we use. Add each one in Claude Code and
**enable auto-update** so skills stay current:

| Tool / Framework | Install command                                          |
| ---------------- | -------------------------------------------------------- |
| Expo             | `/plugin marketplace add expo/skills`                    |
| Railway          | `/plugin marketplace add railwayapp/railway-skills`      |
| Vercel           | `/plugin marketplace add vercel-labs/agent-skills`       |
| Supabase         | `/plugin marketplace add supabase/agent-skills`          |
| PostHog          | `/plugin marketplace add PostHog/posthog-for-claude`     |

After adding a marketplace, enable auto-update in the `/plugin` menu under
Marketplaces.

---

## Recommended Official Plugins

These are from the Anthropic official marketplace (`claude-plugins-official`)
which is pre-installed in Claude Code. Just run `/plugin install` for each:

| Plugin         | Install command                                            | What it does                          |
| -------------- | ---------------------------------------------------------- | ------------------------------------- |
| Stripe         | `/plugin install stripe@claude-plugins-official`           | Payment integration best practices    |
| RevenueCat     | `/plugin install revenuecat@claude-plugins-official`       | In-app purchase management            |
| Sentry         | `/plugin install sentry@claude-plugins-official`           | Error monitoring and issue tracking   |
| Figma          | `/plugin install figma@claude-plugins-official`            | Design-to-code workflows              |
| Notion         | `/plugin install notion@claude-plugins-official`           | Workspace and database integration    |
| Postman        | `/plugin install postman@claude-plugins-official`          | API lifecycle management              |
| Playwright     | `/plugin install playwright@claude-plugins-official`       | Browser automation and E2E testing    |
| Chrome DevTools | `/plugin install chrome-devtools-mcp@claude-plugins-official` | Live Chrome inspection and debugging |
| Slack          | `/plugin install slack@claude-plugins-official`            | Team messaging integration            |
| GitHub         | `/plugin install github@claude-plugins-official`           | Repository and PR management          |
| Superpowers    | `/plugin install superpowers@claude-plugins-official`      | Brainstorming, debugging, TDD skills  |
| Feature Dev    | `/plugin install feature-dev@claude-plugins-official`      | Guided feature development workflow   |
| PR Review      | `/plugin install pr-review-toolkit@claude-plugins-official` | Comprehensive PR review agents       |
| Plugin Dev     | `/plugin install plugin-dev@claude-plugins-official`       | Tools for building Claude Code plugins |

---

## Recommended MCPs

We don't bundle remote MCPs in the plugin to avoid duplication between Claude
Code and Claude Desktop. Instead, each team member adds them individually.

### Built-in connectors (Claude Desktop)

These are first-party integrations — just enable them in Claude Desktop under
**Connectors**:

| Connector       | What it does                          |
| --------------- | ------------------------------------- |
| GitHub          | Issues, PRs, code search              |
| Gmail           | Email search and drafts               |
| Google Calendar | Events, scheduling, free time         |
| Google Drive    | File search and access                |
| Figma           | Design context and screenshots        |
| Notion          | Pages, databases, search              |
| Canva           | Design generation and editing         |
| Excalidraw      | Diagrams and whiteboarding            |
| Sentry          | Error tracking and issue management   |
| Stripe          | Payments, subscriptions, customers    |
| Supabase        | Database, auth, edge functions        |
| PostHog         | Analytics, feature flags, experiments |
| Vercel          | Deployments, projects, logs           |

### Local MCPs (bundled in cais-core)

These are included in the `cais-core` plugin and work automatically in Claude
Code. They require local tools (Node.js, Docker) to be installed:

| Server         | Transport | What it does                                                 |
| -------------- | --------- | ------------------------------------------------------------ |
| github         | HTTP      | GitHub Copilot API (needs `GITHUB_PAT`)                      |
| supabase-local | HTTP      | Local Supabase dev instance                                  |
| Railway        | stdio     | Railway project management                                   |
| next-devtools  | stdio     | Next.js dev tools                                            |
| shadcn         | stdio     | shadcn/ui component management                               |
| trigger        | stdio     | Trigger.dev task management                                  |
| n8n            | stdio     | n8n workflow automation (needs `N8N_MCP_*`)                  |
| digitalocean   | stdio     | DigitalOcean infrastructure (needs `DIGITALOCEAN_API_TOKEN`) |
| redis          | stdio     | Redis via Docker                                             |
| playwright     | stdio     | Browser automation and testing                               |
