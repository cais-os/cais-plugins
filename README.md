# Cais Plugins

Plugin marketplace for the Cais team — an AI lab that creates and distributes
SaaS products.

## Plugins

| Plugin               | Role        | What's included                                                                           |
| -------------------- | ----------- | ----------------------------------------------------------------------------------------- |
| **cais-core**        | All         | Team conventions, product context, tech stack & DB preferences, CI/CD standards, `/brief` |
| **cais-development** | Developer   | Dev practices, design system, Next.js/React/Railway/Redis skills, `/standup`, `/review`   |
| **cais-marketing**   | Marketer    | Content creation, humanizer-pro, WhatsApp Cloud API, Central Station, `/draft`            |
| **cais-business**    | Businessman | Business ops, `/pitch` command                                                            |

## Installation

### Recommended: Install official Anthropic plugins

We recommend all team members install relevant plugins from the
[Claude official Anthropic plugin marketplace](https://github.com/anthropics/claude-code-plugins).

> These are maintained by Anthropic and complement our internal Cais plugins
> below.

### 1. Add the Cais marketplace

```bash
/plugin marketplace add your-org/cais-plugins
```

### 2. Install Cais plugins for your role

**Developer:**

```bash
/plugin install cais-core@cais-plugins
/plugin install cais-development@cais-plugins
```

**Marketer:**

```bash
/plugin install cais-core@cais-plugins
/plugin install cais-marketing@cais-plugins
```

**Businessman:**

```bash
/plugin install cais-core@cais-plugins
/plugin install cais-business@cais-plugins
```

## Auto-configure for a project

Add to your project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "cais-plugins": {
      "source": { "source": "github", "repo": "your-org/cais-plugins" }
    }
  },
  "enabledPlugins": {
    "cais-core@cais-plugins": true
  }
}
```

## Bundled MCP Servers

Plugins bundle MCP server configurations via `.mcp.json` files. When you install
a plugin, its MCP servers become available automatically — no manual
`~/.claude.json` editing.

### cais-core (everyone)

| Server            | Type | Auth                                                    |
| ----------------- | ---- | ------------------------------------------------------- |
| **github**        | HTTP | OAuth — authenticate once when prompted by Claude Code  |
| **figma-desktop** | HTTP | None — connects to the Figma desktop app on `localhost` |

### cais-development (developers)

| Server             | Type  | Auth                                            |
| ------------------ | ----- | ----------------------------------------------- |
| **supabase-local** | HTTP  | None — connects to local Supabase on port 54321 |
| **Railway**        | stdio | None — runs via `npx`                           |
| **next-devtools**  | stdio | None — runs via `npx`                           |
| **shadcn**         | stdio | None — runs via `npx`                           |
| **trigger**        | stdio | None — runs via `npx`                           |
| **sentry**         | HTTP  | OAuth — authenticate once when prompted         |
| **n8n**            | stdio | Env vars (see below)                            |
| **digitalocean**   | stdio | Env var (see below)                             |
| **redis**          | stdio | Env vars (see below) — runs via Docker          |

### Environment variables for MCP servers

Some servers require env vars that each team member sets in their own shell
profile (`~/.zshrc` or `~/.bashrc`). These are **never committed** to the repo.

```bash
# n8n (only if you use n8n workflows)
export N8N_MCP_URL="https://your-n8n-instance.com/mcp"
export N8N_MCP_TOKEN="your-n8n-api-token"

# DigitalOcean (only if you manage infrastructure)
export DIGITALOCEAN_API_TOKEN="dop_v1_your-token-here"

# Redis (only if you use Redis MCP)
export REDIS_HOST="localhost"
export REDIS_PORT="6379"
export REDIS_USERNAME=""
export REDIS_PASSWORD=""
```

After adding these, restart your terminal or run `source ~/.zshrc`.

Servers that need env vars you haven't set will fail silently — this is fine.
Only set the ones you actually use.

## Bundled Skills

Skills are bundled directly inside plugins. When you install a plugin, its
skills become available as slash commands (e.g.,
`/cais-marketing:humanizer-pro`).

### Third-party skills

Some skills (like `humanizer-pro`) are copies of external skills bundled into
our plugins for team-wide distribution. These are **static copies** — they don't
auto-update from the original source.

To update a bundled third-party skill, re-copy the files from the upstream
source into the plugin's `skills/` directory.

## Contributing

See individual plugin directories under `plugins/` for details on each plugin's
skills, commands, and agents.
