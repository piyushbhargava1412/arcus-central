---
name: feature-context-pack-builder
description: Builds a minimal, story-scoped context pack from shared .context artifacts and writes it to .arcus/specs/STORY-ID/context-pack.md without scanning the full repository. Use at the start of a new story, after drift reconciliation, before specification and planning, or when asked to "build context for this story", "create a context pack", or "load story context".
metadata:
  version: "1.0.0"
  type:
    - agents
---

# Feature Context Pack Builder

## Purpose

Generate a minimal context pack for a single story using shared context artifacts:

- `.context/repo_scope.md`
- `.context/repo_map.md`
- `.context/flows/*.md`

Write output to:

- `.arcus/specs/<STORY-ID>/context-pack.md`

## When To Use

- at the start of a new story
- after drift reconciliation
- before specification and planning

## Non-Goals

Do not:
- scan the full repository
- rediscover flows
- update shared context artifacts
- expand scope beyond relevant areas

## Inputs

- `story_description`
- `story_id`

## Instructions

### Step 1: Parse Story Description
Extract from `story_description`:
- Domain terms
- User intent and key actions
- Entities and integrations if mentioned

### Step 2: Read Shared Context
Read all of:
- `.context/repo_scope.md`
- `.context/repo_map.md`
- `.context/flows/*.md`

### Step 3: Match and Select Relevant Flows
Match flows using flow names, entry points, domain terms, integrations, and scope hints. Select the smallest relevant set — prefer 1–2 primary flows; include more only if strongly justified.

### Step 4: Extract Relevant Details
From selected flows, extract only: entry points, core path, data touchpoints, integrations, scope, and tests. Add repo-level context (modules, config hotspots, integration areas) only if directly relevant.

### Step 5: Identify Likely Working Area
Derive candidate packages/modules and likely classes/services from selected flows.

### Step 6: Capture Uncertainty
Explicitly record: no matching flow, ambiguous mapping, missing context, or weak evidence. Prefer a smaller pack over a broader one.

### Step 7: Write Output
Ensure `.arcus/specs/<STORY-ID>/` exists. Write (or overwrite) `context-pack.md` using the template in `assets/context-pack-template.md`. Do not write into `.context/`.

## Output Contract

Format output using the template in `assets/context-pack-template.md`. The written file must include all ten sections: Story Summary, Relevant Flows, Entry Points, Core Path, Data Touchpoints, Integrations, Scope, Likely Working Areas, Tests, and Assumptions / Gaps.

Output must be:
- Minimal and focused
- Derived only from shared context artifacts
- Explicit about uncertainty — never speculative

Does not return:
- Repo-wide expansions
- Content not grounded in `.context/` artifacts

## Validation Gates

- [ ] story_id resolved
- [ ] shared context artifacts read
- [ ] flows selected from `.context/flows`
- [ ] scope limited to relevant areas
- [ ] output written to `.arcus/specs/<STORY-ID>/context-pack.md`

## Troubleshooting

**`NO_MATCHING_FLOW`**: Produce a partial pack with explicit gaps noted in Assumptions / Gaps.  
**`AMBIGUOUS_MAPPING`**: Include bounded alternatives and mark uncertainty explicitly.  
**`INSUFFICIENT_CONTEXT`**: Report which shared context artifact is missing and stop.