# Notion Idea Validation Machine — Structure Plan

## Context

Cais is a 3-founder bootstrapped SaaS startup (Guilherme — dev, Gabriel —
business/strategy, Rodrigo — marketing/ads). The team needs a structured Notion
workspace to validate SaaS ideas data-first, not gut-feel. The system is
primarily for Gabriel to run full analyses on 3-5 ideas at a time, comparing
them side-by-side with a composite score weighted for their stage 1 priority:
fast revenue + automation-friendly distribution.

**Key constraints:**

- Stage 1 (bootstrapped, need quick revenue). Benchmark: BORARUN launched in 4
  weeks.
- Can execute multiple ideas in parallel (Quick Wins + Long-term Plays).
- B2C/prosumer and B2B SMB self-serve only (no enterprise).
- Both Brazil and Global markets.
- Agent-writable: Claude agents will populate these pages via Notion API.

---

## Architecture Overview

```
🎯 Idea Validation Machine (root page)
│
├── 📊 Dashboard                        ← Daily driver, embedded linked views
│
├── 🗄️ [DB] Idea Pipeline               ← CENTRAL HUB (one page per idea)
│   └── 📄 Idea Page Template            ← Full analysis with toggle drill-downs
│
├── 🗄️ [DB] Hypotheses                  ← Separate DB, embedded in idea pages via linked views
│
├── 🗄️ [DB] Market Intelligence         ← Exploratory research (not tied to one idea)
│   └── 📄 Market Research Template
│
├── 🗄️ [DB] GTM Plans                   ← 30/60/90 plans, one per greenlit idea
│   └── 📄 GTM Plan Template
│
├── 🗄️ [DB] Activity Log                ← Decisions, brainstorms, notes
│
└── 📖 Playbooks & Reference
    ├── Scoring Methodology
    ├── Lean Canvas Guide
    ├── GTM Archetype Definitions
    └── How to Use This System
```

**Relationship Model:**

```
                    ┌─────────────────┐
                    │    Market        │
                    │  Intelligence    │
                    └────────┬────────┘
                             │ many-to-many
                             │
┌──────────┐  many-to-one   ┌▼─────────────┐  one-to-one    ┌───────────┐
│Hypotheses│───────────────►│ Idea Pipeline │◄──────────────│ GTM Plans │
└──────────┘                │   (HUB)       │               └───────────┘
                            └──────┬────────┘
                                   │ many-to-many
                            ┌──────▼────────┐
                            │ Activity Log  │
                            └───────────────┘
```

---

## Database 1: Idea Pipeline (Central Hub)

### Properties

| Property                         | Type             | Details                                                                                           |
| -------------------------------- | ---------------- | ------------------------------------------------------------------------------------------------- |
| `Name`                           | Title            | Idea name                                                                                         |
| `Status`                         | Select           | `💡 Submitted` / `🔬 Under Analysis` / `✅ Validated` / `🚀 Greenlit` / `⏸️ Parked` / `❌ Killed` |
| `Idea Type`                      | Select           | `Quick Win` / `Long-term Play` / `Hybrid`                                                         |
| `SaaS Model`                     | Select           | `B2C` / `Prosumer` / `B2B SMB Self-Serve`                                                         |
| `Geography`                      | Multi-select     | `Brazil` / `Global` / `LATAM` / `US`                                                              |
| `Submitted By`                   | Person           |                                                                                                   |
| `Submission Date`                | Date             |                                                                                                   |
| `Analysis Owner`                 | Person           | Defaults to Gabriel                                                                               |
| **Scoring**                      |                  |                                                                                                   |
| `Score: Speed-to-Revenue`        | Number (1-10)    | How fast to first paying customers?                                                               |
| `Score: Team-Fit`                | Number (1-10)    | Leverages Guilherme's build speed, Rodrigo's automation, Gabriel's strategy?                      |
| `Score: Market Opportunity`      | Number (1-10)    | TAM/SAM attractiveness + growth                                                                   |
| `Score: Distribution Automation` | Number (1-10)    | How much can Rodrigo automate acquisition?                                                        |
| `Score: Competitive Landscape`   | Number (1-10)    | 10 = wide open, 1 = dominated                                                                     |
| `Composite Score`                | Formula          | `(Speed*0.30 + Distribution*0.20 + TeamFit*0.20 + Market*0.15 + Competitive*0.15) * 10` → 0-100   |
| **Build**                        |                  |                                                                                                   |
| `Dev Estimate`                   | Select           | `< 1 week` / `1-2 weeks` / `2-4 weeks` / `1-2 months` / `3+ months`                               |
| `Revenue Model`                  | Multi-select     | `Subscription` / `Freemium` / `Usage-Based` / `Marketplace Cut` / `One-time`                      |
| `Target MRR (6mo)`               | Number           | Projected MRR at 6 months (USD)                                                                   |
| `GTM Archetype`                  | Select           | `PLG` / `Sales-Led` / `Marketing-Led` / `Community-Led` / `Partnership-Led`                       |
| **Relations**                    |                  |                                                                                                   |
| `Hypotheses`                     | Relation         | → Hypotheses DB                                                                                   |
| `Hypotheses Validated`           | Rollup           | Count where Status = "Validated"                                                                  |
| `Hypotheses Total`               | Rollup           | Count all                                                                                         |
| `Hypothesis Health`              | Formula          | `validated/total * 100` → percentage                                                              |
| `GTM Plan`                       | Relation         | → GTM Plans DB                                                                                    |
| `Market Intelligence`            | Relation         | → Market Intelligence DB                                                                          |
| **Agent**                        |                  |                                                                                                   |
| `Source`                         | Select           | `AI Agent` / `Human` / `Mixed`                                                                    |
| `Reviewed`                       | Checkbox         |                                                                                                   |
| `External ID`                    | Text             | e.g., `idea-running-coach-br-001`                                                                 |
| **Meta**                         |                  |                                                                                                   |
| `Last Updated`                   | Last edited time |                                                                                                   |
| `Freshness`                      | Formula          | >14 days = 🔴 Stale, >7 = 🟡 Aging, else 🟢 Fresh                                                 |
| `Decision`                       | Select           | `Go` / `No-Go` / `Pivot` / `Pending`                                                              |
| `Decision Date`                  | Date             |                                                                                                   |
| `Decision Rationale`             | Text             |                                                                                                   |

### Views

| View           | Type                                        | Purpose                 |
| -------------- | ------------------------------------------- | ----------------------- |
| Pipeline Board | Board by Status                             | Daily overview          |
| Scorecard      | Table sorted by Composite Score desc        | Side-by-side comparison |
| Quick Wins     | Table filtered Idea Type = Quick Win        | Fast revenue focus      |
| Long-term      | Table filtered Idea Type = Long-term/Hybrid | Strategic bets          |
| Stale Ideas    | Table filtered Freshness = Stale/Aging      | Housekeeping            |

---

## Database 2: Hypotheses

### Properties

| Property            | Type     | Details                                                                                                                          |
| ------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------- |
| `Hypothesis`        | Title    | "We believe [X] because [Y]"                                                                                                     |
| `Idea`              | Relation | → Idea Pipeline                                                                                                                  |
| `Category`          | Select   | `Problem` / `Solution` / `Market Size` / `Willingness to Pay` / `Distribution` / `Technical Feasibility` / `Retention`           |
| `Status`            | Select   | `🔵 Untested` / `🧪 Testing` / `✅ Validated` / `❌ Invalidated` / `🔄 Pivoted`                                                  |
| `Evidence`          | Text     | Supporting/refuting data                                                                                                         |
| `Validation Method` | Select   | `Customer Interview` / `Landing Page` / `Ad Campaign` / `Prototype Test` / `Market Data` / `Expert Opinion` / `Competitor Proxy` |
| `Confidence`        | Select   | `Low` / `Medium` / `High`                                                                                                        |
| `Owner`             | Person   |                                                                                                                                  |
| `Due Date`          | Date     |                                                                                                                                  |
| `Source`            | Select   | `AI Agent` / `Human` / `Mixed`                                                                                                   |
| `Reviewed`          | Checkbox |                                                                                                                                  |
| `External ID`       | Text     |                                                                                                                                  |

### Views

| View             | Type                               | Purpose                |
| ---------------- | ---------------------------------- | ---------------------- |
| By Idea          | Table grouped by Idea              | Per-idea view          |
| Validation Board | Board by Status                    | Track testing progress |
| Overdue          | Table: Due < Today, still untested | Accountability         |

---

## Database 3: Market Intelligence

### Properties

| Property                              | Type                 | Details                                                                                                  |
| ------------------------------------- | -------------------- | -------------------------------------------------------------------------------------------------------- |
| `Title`                               | Title                | Research topic                                                                                           |
| `Research Type`                       | Select               | `Market Landscape` / `Trend Analysis` / `Competitor Deep-Dive` / `Technology Scan` / `Audience Research` |
| `Market / Vertical`                   | Multi-select         | Free tags: `Fitness`, `FinTech`, `EdTech`, etc.                                                          |
| `Geography`                           | Multi-select         | `Brazil` / `Global` / `LATAM` / `US`                                                                     |
| `Status`                              | Select               | `📋 Queued` / `🔬 In Progress` / `✅ Complete` / `📦 Archived`                                           |
| `Related Ideas`                       | Relation             | → Idea Pipeline (many-to-many)                                                                           |
| `Key Findings`                        | Text                 | 2-3 sentence summary                                                                                     |
| `Owner`                               | Person               |                                                                                                          |
| `Date`                                | Date                 |                                                                                                          |
| `Source` / `Reviewed` / `External ID` | Standard agent props |                                                                                                          |
| `Freshness`                           | Formula              | Same stale logic                                                                                         |

### Views

| View            | Type                           | Purpose                     |
| --------------- | ------------------------------ | --------------------------- |
| Active Research | Table, Status = In Progress    | Current work                |
| By Market       | Board by Market/Vertical       | Browse by domain            |
| Idea Generators | Table, Related Ideas not empty | Research that spawned ideas |

---

## Database 4: GTM Plans

### Properties

| Property                              | Type                 | Details                                                           |
| ------------------------------------- | -------------------- | ----------------------------------------------------------------- |
| `Plan Name`                           | Title                | "GTM: [Idea Name]"                                                |
| `Idea`                                | Relation             | → Idea Pipeline (one-to-one)                                      |
| `GTM Archetype`                       | Select               | PLG / Sales-Led / Marketing-Led / Community-Led / Partnership-Led |
| `Status`                              | Select               | `Draft` / `Active` / `Complete` / `Abandoned`                     |
| `30-Day Milestone`                    | Text                 |                                                                   |
| `60-Day Milestone`                    | Text                 |                                                                   |
| `90-Day Milestone`                    | Text                 |                                                                   |
| `Automation Level`                    | Select               | `Fully Automated` / `Mostly Automated` / `Semi-Manual` / `Manual` |
| `Owner`                               | Person               |                                                                   |
| `Source` / `Reviewed` / `External ID` | Standard agent props |                                                                   |

---

## Database 5: Activity Log

### Properties

| Property        | Type           | Details                                                                           |
| --------------- | -------------- | --------------------------------------------------------------------------------- |
| `Title`         | Title          |                                                                                   |
| `Type`          | Select         | `Brainstorm` / `Decision` / `Research Note` / `Retrospective` / `External Signal` |
| `Date`          | Date           |                                                                                   |
| `Participants`  | Person (multi) |                                                                                   |
| `Related Ideas` | Relation       | → Idea Pipeline                                                                   |
| `Summary`       | Text           |                                                                                   |
| `Source`        | Select         | `AI Agent` / `Human` / `Mixed`                                                    |

---

## Idea Page Template (Full Analysis)

Each idea page uses toggle blocks for drill-downs. Executive Summary is always
visible; everything else is collapsed by default.

### EXECUTIVE SUMMARY (always visible)

- One-paragraph pitch: what, who, why now
- Key metrics strip: Composite Score, Idea Type, Dev Estimate, Target MRR,
  Decision
- Verdict & recommendation (Gabriel's bottom line)

### ▸ LEAN CANVAS (toggle)

- Problem (top 3)
- Customer Segments
- Unique Value Proposition
- Solution
- Channels
- Revenue Streams
- Cost Structure
- Key Metrics
- Unfair Advantage

### ▸ MARKET SIZING — TAM/SAM/SOM (toggle)

- TAM with methodology
- SAM with methodology
- SOM (realistic Year 1)
- Growth rate & trends
- Data sources & confidence level
- Link to Market Intelligence pages (if applicable)

### ▸ DEMAND & SEO VALIDATION (toggle)

- Target keywords table (inline): Keyword | Search Volume | CPC | Difficulty |
  Intent
- Content gap analysis
- Commercial intent signals (high CPC = strong buying intent)
- Organic opportunity assessment
- Paid acquisition cost estimates from keyword data

### ▸ COMPETITIVE LANDSCAPE (toggle, embedded inline tables)

- **Competitor Overview Table**: Competitor | Pricing | Est. Users | GTM
  Archetype | Key Strength | Key Weakness
- **Feature Comparison Matrix**: Feature | Us | Comp A | Comp B | Comp C
  (Yes/No/Partial)
- **Pricing Comparison Table**: Tier | Us | Comp A | Comp B | Comp C
- **Distribution Strategy Teardown**: Per competitor — channels, what works,
  what we can replicate/beat
- **Competitive Moat Assessment**: What stops them copying us? What stops us
  catching them?

### ▸ HYPOTHESES (toggle, embedded linked view from Hypotheses DB)

- Filtered to: Idea = this page
- Columns: Hypothesis | Category | Status | Confidence | Evidence
- "+ New Hypothesis" button

### ▸ TEAM-FIT ASSESSMENT (toggle)

- Gabriel's role: domain insight, strategy angle
- Guilherme's role: build complexity, dev speed match
- Rodrigo's role: distribution automation potential
- Gaps / skills needed
- Overall team-fit score justification

### ▸ BUILD ASSESSMENT (toggle)

- Technical feasibility score (1-10)
- Dev estimate (from property)
- Tech stack: Frontend / Backend / AI-ML / Infra
- AI complexity: None / API Wrapper / Fine-tuned / Custom Model / Multi-model
- External dependencies & risks (APIs, data, compliance)
- MVP scope: Must-have (Week 1) / Nice-to-have (Week 2-4) / Future (Month 2+)
- Guilherme's build notes (free-form)

### ▸ SCORING BREAKDOWN (toggle)

- Speed-to-Revenue: X/10 — justification
- Team-Fit: X/10 — justification
- Market Opportunity: X/10 — justification
- Distribution Automation: X/10 — justification
- Competitive Landscape: X/10 — justification
- **COMPOSITE: X/100**

### ▸ DISTRIBUTION & AUTOMATION MAP (toggle)

- Channel assessment table: Channel | Priority | Automation Level | Tool/System
- Rodrigo's automation stack: what's automated today, what needs building,
  what's manual-only
- Influencer outreach feasibility (first contact automatable, deal stage is
  manual)
- B2B note: in-person meetings cannot be automated

### ▸ GO-TO-MARKET PLAN (toggle, embedded linked view from GTM Plans DB)

- Filtered to: Idea = this page
- Shows 30/60/90 milestones, archetype, automation level
- "+ Create GTM Plan" button (if none exists)

### ▸ NOTES & DISCUSSION (toggle)

- Free-form area
- Embedded linked view from Activity Log filtered to this idea

---

## Market Intelligence Page Template

### KEY FINDINGS (always visible)

- 2-3 sentence summary
- Linked ideas that emerged

### ▸ MARKET OVERVIEW

- Market size and growth, key players, value chain, regulatory environment

### ▸ TRENDS & SIGNALS

- Emerging trends, technology shifts, consumer behavior, timing ("why now?")

### ▸ OPPORTUNITY GAPS

- Underserved segments, feature gaps, pricing white space, geographic white
  space

### ▸ COMPETITOR MAP (exploratory)

- Full landscape table, funding/traction signals, consolidation trends

### ▸ IDEA CANDIDATES

- Specific idea concepts that emerged, one-liner + why it could work
- "Promote to Idea Pipeline" action

### ▸ DATA SOURCES & METHODOLOGY

- Sources used, confidence level, what's missing

---

## GTM Plan Page Template

### Header

- Archetype, Overall Automation Level

### ▸ DAYS 1-30: LAUNCH & LEARN

- Objective, channels, Rodrigo's automation tasks, Guilherme's build tasks,
  metrics, budget

### ▸ DAYS 31-60: OPTIMIZE & SCALE

- Objective, double-down channels, cut channels, new automation, metrics

### ▸ DAYS 61-90: GROWTH MODE

- Objective, scaling strategy, revenue target, capacity assessment

### ▸ AUTOMATION MAP (detailed table)

- Task | Tool/System | Owner | Status (Automated / In Progress / Planned /
  Manual)

### ▸ CHANNEL-BY-CHANNEL PLAYBOOK

- Per channel: strategy, automation level, budget, expected CAC, timeline

---

## Dashboard Layout

The Dashboard page is Gabriel's daily driver. Top to bottom:

**1. STATUS OVERVIEW**

- Linked view: Idea Pipeline → Pipeline Board (board by Status, shows Composite
  Score, Idea Type)

**2. SCORECARD — QUICK COMPARISON**

- Linked view: Idea Pipeline → Scorecard Table (sorted by Composite Score desc,
  all 5 scores visible)

**3. HYPOTHESIS HEALTH**

- Linked view: Hypotheses → Validation Board (board by Status, shows Idea
  relation, Confidence, Due Date)

**4. ACTION REQUIRED (two-column)**

- Left: Stale Ideas (Freshness = Stale/Aging)
- Right: Overdue Hypotheses (Due < Today, still untested)

**5. ACTIVE RESEARCH**

- Linked view: Market Intelligence → Active Research (in-progress exploratory
  work)

**6. RECENT DECISIONS**

- Linked view: Activity Log → Decisions Only (last 10, sorted by date desc)

---

## Agent Integration Pattern

Every database includes three standard properties:

- `Source` (Select): `AI Agent` / `Human` / `Mixed`
- `Reviewed` (Checkbox): human verification flag
- `External ID` (Text): idempotent key for agent upserts

**External ID convention (kebab-case):**

- Ideas: `idea-{slug}-{number}` (e.g., `idea-running-coach-br-001`)
- Hypotheses: `hyp-{idea-slug}-{number}` (e.g., `hyp-running-coach-br-003`)
- Market Intel: `mkt-{topic-slug}-{number}` (e.g., `mkt-fitness-brazil-001`)
- GTM Plans: `gtm-{idea-slug}` (e.g., `gtm-running-coach-br`)

**Agent workflow:**

1. Agent creates/updates page → sets `Source = AI Agent`, `Reviewed = unchecked`
2. Agent uses External ID to find existing pages before creating duplicates
3. Gabriel reviews → checks `Reviewed`, optionally changes Source to `Mixed`
4. Freshness formula auto-flags stale content

---

## Implementation Sequence

**Phase 1 — Foundation**

1. Create root "Idea Validation Machine" page
2. Create Idea Pipeline DB with all properties + composite score formula
3. Create Hypotheses DB with relation to Ideas
4. Create Idea Page template with all toggle sections

**Phase 2 — Supporting DBs** 5. Create Market Intelligence DB 6. Create GTM
Plans DB 7. Create Activity Log DB 8. Wire all relations between databases

**Phase 3 — Views & Dashboard** 9. Create all views on each database 10. Build
Dashboard page with 6 embedded linked views 11. Configure default sorts and
filters

**Phase 4 — Templates & Reference** 12. Finalize Market Intelligence page
template 13. Finalize GTM Plan page template 14. Create Playbooks & Reference
section (Scoring Methodology, Lean Canvas Guide, GTM Archetype Definitions, How
to Use This System)

---

## Verification

1. **Create a test idea** (e.g., BORARUN) and fill out the full template to
   validate the structure works
2. **Test hypothesis flow**: Add 3-5 hypotheses via the Hypotheses DB, verify
   they appear embedded in the idea page and the rollup/health formula works
3. **Test Market Intelligence → Idea flow**: Create a market research page, link
   it to the test idea, verify the relation appears in both directions
4. **Dashboard check**: Verify all 6 sections render correctly with the test
   data
5. **Agent readiness**: Test creating/updating a page via Notion API using
   External ID for idempotent updates
6. **Scoring**: Verify the composite score formula produces correct 0-100 values
