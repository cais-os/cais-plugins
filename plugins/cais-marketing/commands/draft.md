---
description: Draft content following product brand guidelines
argument-hint: [content-type] [product-name]
---

Draft content using the Cais content-creation skill guidelines.

Content type: $1 Product: $2

Follow this process:

1. Check if the product has a context file in the product-context skill (from
   the cais-core plugin)
2. Load the product's brand voice from its project CLAUDE.md if available
3. Draft the content following the content-creation skill's templates

If content type is not specified, ask which type:

- Blog post
- Social media (Twitter/X, LinkedIn)
- Landing page copy
- Email campaign
- Product description

If the product is not specified, ask which Cais product this content is for.

Apply the quality checklist from the content-creation skill before presenting
the final draft.
