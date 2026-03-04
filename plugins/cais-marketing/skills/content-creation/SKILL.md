---
name: content-creation
description: This skill should be used when creating marketing content, writing blog posts, drafting social media copy, creating landing page text, writing email campaigns, or defining brand voice for any Cais product. Triggers on "write a blog post", "draft social copy", "create landing page", "email campaign", "brand voice", "content strategy".
version: 0.1.0
---

# Cais Content Creation

Each Cais product has its own brand voice and audience. This skill provides the
framework for creating consistent content across products.

## Content Workflow

1. Identify the target product (check `product-context` skill for product
   details)
2. Load the product's brand voice from its project CLAUDE.md
3. Draft content following the structure below
4. Review against the product's brand guidelines

## Content Types

### Blog Posts

- **Length:** 800–1,500 words for standard posts
- **Structure:** Hook → Problem → Solution → CTA
- **SEO:** Include target keyword in title, first paragraph, and subheadings
- **Tone:** Match the product's brand voice

### Social Media

- **Twitter/X:** Under 280 chars, punchy, link to full content
- **LinkedIn:** Professional angle, 1–3 paragraphs, actionable insight
- **Format:** Lead with the insight, not the product

### Landing Pages

- **Hero:** Clear value proposition in one sentence
- **Benefits:** 3–5 key benefits with supporting details
- **Social proof:** Testimonials, metrics, logos
- **CTA:** Single clear action

### Email Campaigns

- **Subject line:** Under 50 chars, specific benefit or curiosity
- **Body:** One idea per email, clear CTA
- **Sequence:** Welcome → Value → Value → Soft pitch → Hard pitch

## Brand Voice Template

<!-- TODO: Each product should define these in their project CLAUDE.md -->

When creating content for a product, define:

- **Personality:** (e.g., "Expert but approachable")
- **Tone:** (e.g., "Confident, not arrogant")
- **Vocabulary:** (e.g., "Technical terms are OK, jargon is not")
- **Audience:** (e.g., "Developers building SaaS products")

## Quality Checklist

- [ ] Matches product brand voice
- [ ] Has a clear CTA
- [ ] No filler or fluff
- [ ] Factually accurate
- [ ] Proofread for grammar and clarity
