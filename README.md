# Cais Plugins

Shared skills, integrations, and conventions for the Cais team.

## Plugins

| Plugin               | Who it's for | What you get                                                             |
| -------------------- | ------------ | ------------------------------------------------------------------------ |
| **cais-core**        | Everyone     | Team conventions, product context, tech stack defaults, commit standards |
| **cais-development** | Developers   | Dev practices, design system, Railway/Next.js/React skills, code review  |
| **cais-marketing**   | Marketers    | Content creation, brand voice checks, WhatsApp API, Canva                |
| **cais-business**    | Business     | Business ops, pitch frameworks, Stripe, RevenueCat                       |

## Installation

1. Open Terminal and add your environment variables:
   ```sh
   # Cais plugins
   echo 'export GITHUB_PAT="your-token"' >> ~/.zshrc
   echo 'export N8N_MCP_URL="your-url"' >> ~/.zshrc
   echo 'export N8N_MCP_TOKEN="your-token"' >> ~/.zshrc
   echo 'export DIGITALOCEAN_API_TOKEN="your-token"' >> ~/.zshrc
   ```
2. Open Claude Code and add the marketplace:
   ```
   /plugin marketplace add cais-os/cais-plugins
   ```
3. Explore the marketplace section and install all Cais plugins:
   ```
   /plugin
   ```
4. Add the following to your personal `~/.claude/CLAUDE.md`:
   ```markdown
   ## Team Conventions

   - **Always apply Cais team conventions.** At the start of every conversation,
     use the `team-conventions` skill from `cais-core` to load company-wide naming
     conventions, file structure patterns, documentation standards, and
     decision-making guidelines.
   - This applies to all work — new projects, feature development, code reviews,
     and refactoring.
   ```
