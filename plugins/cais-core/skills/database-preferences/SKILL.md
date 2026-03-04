---
name: database-preferences
description: Use when performing any database schema change, creating or editing migration files, running Supabase CLI database commands (supabase db, supabase migration), writing SQL DDL (CREATE, ALTER, DROP), adding or modifying RLS policies, or creating database functions/triggers. Triggers on phrases like "add a table", "create migration", "modify schema", "add RLS", "add a column", "drop index", "rename column", "create function", "add trigger", "enable RLS".
version: 1.0.0
---

# Database Change Rules

These rules govern **all structural database changes**. Follow them exactly —
deviate only if the user explicitly overrides for a specific operation.

## Core Principles

| Rule | Details |
|------|---------|
| **Never modify schema directly** | No ad-hoc CREATE, ALTER, DROP via SQL, Supabase MCP, or dashboard. Applies to tables, columns, indexes, RLS policies, functions, triggers, and enums. |
| **Always use migration files** | Generate with the project's migration tool (e.g., `supabase migration new <name>`). Apply with `supabase db reset` or `supabase migration up`. |
| **Never edit past migrations** | Always create a new migration to alter, fix, or undo previous changes. Assume migrations may have been applied to production or shared environments. |
| **Ad-hoc SQL is fine for reads** | SELECT queries, seed data during development, and one-off debugging are okay — structural changes are not. |

## Pre-launch Exception

If the user **explicitly** states the project hasn't launched and migrations
haven't been pushed to production, you may edit, squash, or consolidate existing
migration files. **Always confirm before doing so** — don't infer project state
on your own.

## Migration Naming Conventions

- Use `supabase migration new <description>` — let the CLI handle the timestamp.
- Format: `verb_noun`, lowercase with underscores.
- Common verbs: `create`, `add`, `drop`, `rename`, `alter`, `update`, `enable`,
  `disable`.

**Examples:**
`create_users_table`, `add_email_to_profiles`, `drop_legacy_sessions`,
`add_rls_policies_for_orders`, `rename_role_to_user_role`,
`create_handle_new_user_function`
