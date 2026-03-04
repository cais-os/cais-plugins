# Cais Plugins

Plugin marketplace for the Cais team — an AI lab that creates and distributes
SaaS products.

## Plugins

| Plugin               | Role        | What's included                                                          |
| -------------------- | ----------- | ------------------------------------------------------------------------ |
| **cais-core**        | All         | Team conventions, product context, `/brief` command, commit hooks        |
| **cais-development** | Developer   | Dev practices, design system, `/standup`, `/review`, code reviewer agent |
| **cais-marketing**   | Marketer    | Content creation, humanizer-pro, `/draft`, brand voice checker agent     |
| **cais-business**    | Businessman | Business ops, `/pitch` command                                           |

## Installation

### 1. Add the marketplace

```bash
/plugin marketplace add your-org/cais-plugins
```

### 2. Install plugins for your role

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

| Server           | Type | Auth                                                    |
| ---------------- | ---- | ------------------------------------------------------- |
| **github**       | HTTP | OAuth — authenticate once when prompted by Claude Code  |
| **figma-desktop** | HTTP | None — connects to the Figma desktop app on `localhost` |

### cais-development (developers)

| Server            | Type  | Auth                                           |
| ----------------- | ----- | ---------------------------------------------- |
| **supabase-local** | HTTP  | None — connects to local Supabase on port 54321 |
| **Railway**       | stdio | None — runs via `npx`                          |
| **next-devtools** | stdio | None — runs via `npx`                          |
| **shadcn**        | stdio | None — runs via `npx`                          |
| **trigger**       | stdio | None — runs via `npx`                          |
| **sentry**        | HTTP  | OAuth — authenticate once when prompted        |
| **n8n**           | stdio | Env vars (see below)                           |
| **digitalocean**  | stdio | Env var (see below)                            |

### Environment variables for MCP servers

Some servers require env vars that each team member sets in their own shell
profile (`~/.zshrc` or `~/.bashrc`). These are **never committed** to the repo.

```bash
# n8n (only if you use n8n workflows)
export N8N_MCP_URL="https://your-n8n-instance.com/mcp"
export N8N_MCP_TOKEN="your-n8n-api-token"

# DigitalOcean (only if you manage infrastructure)
export DIGITALOCEAN_API_TOKEN="dop_v1_your-token-here"
```

After adding these, restart your terminal or run `source ~/.zshrc`.

Servers that need env vars you haven't set will fail silently — this is fine.
Only set the ones you actually use.

## Bundled Skills

Skills are bundled directly inside plugins. When you install a plugin, its skills
become available as slash commands (e.g., `/cais-marketing:humanizer-pro`).

### Third-party skills

Some skills (like `humanizer-pro`) are copies of external skills bundled into
our plugins for team-wide distribution. These are **static copies** — they don't
auto-update from the original source.

To update a bundled third-party skill, re-copy the files from the upstream
source into the plugin's `skills/` directory.

## Contributing

See individual plugin directories under `plugins/` for details on each plugin's
skills, commands, and agents.
