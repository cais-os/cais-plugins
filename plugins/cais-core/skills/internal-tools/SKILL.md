---
name: internal-tools
description: >-
  Use when scaffolding a new internal tool, creating a dashboard app, setting up
  a new Cais product UI, or when the user says "new internal app", "create a
  dashboard", "scaffold internal tool", or "start a new product UI". Standardizes
  the UI shell across all Cais internal products.
version: 1.0.0
---

# Internal Tools UI Standard

Every Cais internal tool (Farol, Flow, Content, etc.) must share the same UI
shell so the suite feels cohesive. This skill defines the layout, theme, and
navigation conventions.

## Prerequisites

Before applying this skill, also invoke:

- **`scaffolding-preferences`** — for monorepo folder structure, gitignore
  templates, and terminal layout
- **`tech-stack-preferences`** — for the full stack (Next.js, shadcn, Tailwind,
  etc.)
- **`team-conventions`** — for naming, file structure, and commit conventions

## Theme

Use shadcn's **neutral** (default) color scheme. Do not customize the base
theme — consistency across the suite is more important than per-app branding.

When initializing shadcn, accept the defaults:

```bash
pnpm dlx shadcn@latest init
```

This gives you the neutral palette out of the box.

## Base Layout

Install the `dashboard-01` block as the starting point:

```bash
pnpm dlx shadcn@latest add dashboard-01
```

This installs a sidebar layout with charts and a data table. After installing:

1. Strip the sample content (charts, data table) but keep the layout skeleton
   (sidebar + inset content area)
2. Replace the sidebar header with the `CaisSidebarHeader` component (see below)
3. Customize the sidebar navigation groups for the product's actual pages

## Sidebar Structure

Every internal tool sidebar follows this structure:

```
Sidebar
├── SidebarHeader → CaisSidebarHeader (app title + suite switcher)
├── SidebarContent
│   └── SidebarGroup (one per navigation section)
│       ├── SidebarGroupLabel
│       └── SidebarMenu → SidebarMenuItem → SidebarMenuButton
├── SidebarFooter → User profile / settings (when auth is present)
└── SidebarRail
```

## Suite Switcher (CaisSidebarHeader)

Copy the template from this skill into the project:

```
templates/cais-sidebar-header.tsx → src/components/cais-sidebar-header.tsx
```

After copying, customize it:

1. **Update the `CAIS_APPS` array** — set the correct URLs for deployed apps and
   assign a distinct Lucide icon to each product
2. **Pass the current app's name and icon** as props when rendering:

```tsx
import { Search } from "lucide-react"
import { CaisSidebarHeader } from "@/components/cais-sidebar-header"

// In your AppSidebar component:
<CaisSidebarHeader appName="Farol" appIcon={Search} />
```

The component renders:

- The current app name with its icon in a branded square
- A "Suite" label below the name
- A `ChevronsUpDown` chevron indicating the dropdown
- A `DropdownMenu` listing all Cais apps — the current one shows a check mark,
  the others are links to their deployed URLs

## Content Area

The content area (inside `SidebarInset`) should include:

1. **Site header** — with `SidebarTrigger` (hamburger toggle) and breadcrumbs
2. **Page content** — whatever the product needs

Keep the site header pattern from `dashboard-01`:

```tsx
<header className="flex h-12 shrink-0 items-center gap-2 border-b px-4">
  <SidebarTrigger className="-ml-1" />
  <Separator orientation="vertical" className="mr-2 data-[orientation=vertical]:h-4" />
  <Breadcrumb>...</Breadcrumb>
</header>
```

## Conventions

- **Icons:** Use Lucide React exclusively (already in the stack via shadcn)
- **Sidebar width:** Keep the default `--sidebar-width` from `dashboard-01`
  (`calc(var(--spacing) * 72)`)
- **Responsiveness:** The sidebar collapses automatically on mobile via shadcn's
  built-in behavior — don't override this
- **Dark mode:** Support it from day one using shadcn's `ThemeProvider` — the
  neutral palette works well in both modes
