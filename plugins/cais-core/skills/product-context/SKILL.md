---
name: product-context
description: This skill should be used when discussing a specific Cais product, its features, audience, positioning, or roadmap. It provides a template for documenting product context and should be referenced when creating content, pitches, or features for any product. Triggers on "what does [product] do", "product overview", "who is this for", "product roadmap", "feature list".
version: 0.1.0
---

# Cais Product Context

Cais creates and distributes multiple SaaS products. Each product should be
documented using the template below.

## Product Registry

<!-- TODO: Add each product as it's created -->

Document each product in `references/products/` with one file per product:

```
references/products/
├── product-a.md
├── product-b.md
└── product-c.md
```

## Product Documentation Template

Use this template for each product file:

```markdown
# [Product Name]

## One-liner

[What it does in one sentence]

## Problem

[What pain point does it solve?]

## Target Audience

[Who is this for? Be specific.]

## Core Features

- [Feature 1]
- [Feature 2]
- [Feature 3]

## Tech Stack

[Any deviations from Cais defaults and why]

## Business Model

[How it makes money — subscription, usage-based, etc.]

## Key Metrics

- [North star metric]
- [Secondary metrics]

## Competitors

[Key competitors and how we differentiate]

## Status

[Development stage: Idea | MVP | Beta | Live | Mature]

## Links

- Repo: [URL]
- Live: [URL]
- Dashboard: [URL]
```

## Usage

When working on a specific product, load its context file from
`references/products/[product-name].md` to ensure consistency across content,
code, and business decisions.

## Additional Resources

### Reference Files

- **`references/products/`** — Individual product documentation files
