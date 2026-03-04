# Database Rules

These rules govern all structural database changes across Cais products.

## Core Principles

| Rule                             | Details                                                                                                   |
| -------------------------------- | --------------------------------------------------------------------------------------------------------- |
| **Never modify schema directly** | No ad-hoc CREATE, ALTER, DROP via SQL, Supabase MCP, or dashboard.                                        |
| **Always use migration files**   | Generate with `supabase migration new <name>`. Apply with `supabase db reset` or `supabase migration up`. |
| **Never edit past migrations**   | Always create a new migration to alter, fix, or undo previous changes.                                    |
| **Ad-hoc SQL is fine for reads** | SELECT queries and seed data during dev are OK.                                                           |

## Pre-launch Exception

If the project hasn't launched and migrations haven't been pushed to production,
existing migration files may be edited or squashed. Always confirm before doing
so.

## Migration Naming

Use `supabase migration new <description>` — let the CLI handle the timestamp.

Format: `verb_noun`, lowercase with underscores.

Common verbs: `create`, `add`, `drop`, `rename`, `alter`, `update`, `enable`,
`disable`.

**Examples:** `create_users_table`, `add_email_to_profiles`,
`drop_legacy_sessions`, `add_rls_policies_for_orders`,
`create_handle_new_user_function`

## Supabase Conventions

- Use `supabase-local` MCP for development by default
- Only use `supabase` (production) MCP when explicitly deploying to production
- Ask before executing destructive operations
