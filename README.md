# Cais Plugins

Plugin marketplace for the Cais team — an AI lab that creates and distributes
SaaS products.

## Plugins

| Plugin               | Role        | What's included                                                          |
| -------------------- | ----------- | ------------------------------------------------------------------------ |
| **cais-core**        | All         | Team conventions, product context, `/brief` command, commit hooks        |
| **cais-development** | Developer   | Dev practices, design system, `/standup`, `/review`, code reviewer agent |
| **cais-marketing**   | Marketer    | Content creation, `/draft`, brand voice checker agent                    |
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

## Contributing

See individual plugin directories under `plugins/` for details on each plugin's
skills, commands, and agents.
