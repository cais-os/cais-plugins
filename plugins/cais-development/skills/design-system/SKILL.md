---
name: design-system
description: This skill should be used when building UI components, choosing colors, defining typography, creating layouts, or ensuring visual consistency across Cais products. Triggers on "design system", "UI components", "color palette", "typography", "layout patterns", "shadcn component", "Tailwind config".
version: 0.1.0
---

# Cais Design System

Shared UI conventions across Cais products. Built on shadcn/ui + Tailwind CSS.

## Base Stack

- **Component library:** shadcn/ui
- **Styling:** Tailwind CSS
- **Icons:** Lucide React
- **Animations:** Motion (Framer Motion)

## Shared Principles

- **Consistency over creativity** — use shadcn defaults unless there's a reason
- **Mobile-first** — design for small screens, scale up
- **Accessible** — follow WAI-ARIA patterns (shadcn handles most of this)
- **Dark mode** — support both themes from day one

## Component Guidelines

### When to use shadcn/ui components

Always check if shadcn/ui has the component before building a custom one. Use
`npx shadcn@latest add [component]` to add components.

### When to build custom

Only build custom when:

- shadcn doesn't have the component
- The component is product-specific (e.g., a custom chart)
- Significant behavioral differences are needed

### Component Conventions

- Place shared components in `src/components/ui/` (shadcn default)
- Place product-specific components in `src/components/`
- Use composition over configuration — prefer slots and children over props

## Tailwind Configuration

<!-- TODO: Define shared Tailwind config extensions per product -->

Each product extends the default Tailwind config. Shared tokens:

```js
// Example shared extensions
{
  extend: {
    // Add shared brand tokens here
  }
}
```

## Layout Patterns

- **Dashboard:** Sidebar + main content area
- **Marketing:** Full-width sections with max-w container
- **Auth:** Centered card layout
- **Settings:** Sidebar navigation + form content

## Quality Checklist

- [ ] Uses shadcn/ui components where available
- [ ] Responsive (mobile-first)
- [ ] Supports dark mode
- [ ] Keyboard accessible
- [ ] Consistent spacing (Tailwind scale)
