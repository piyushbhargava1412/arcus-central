---
name: feature-context-pack-builder
description: Build a minimal, story-specific context pack from shared .context artifacts and persist it to .arcus/specs/<STORY-ID>/context-pack.md without scanning the full repository.
metadata:
    inputs:
      - story_description
      - story_id
    outputs:
      - context_pack
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

## Processing Rules

1. Parse story description to identify:
    - domain terms
    - user intent
    - key actions
    - entities/integrations if mentioned

2. Read shared context from:
    - `.context/repo_scope.md`
    - `.context/repo_map.md`
    - `.context/flows/*.md`

3. Match relevant flows using:
    - flow names
    - entry points
    - domain terms
    - integrations
    - scope hints

4. Select the smallest relevant set of flows:
    - prefer 1–2 primary flows
    - include more only if strongly justified

5. Extract only relevant details:
    - entry points
    - core path
    - data touchpoints
    - integrations
    - scope
    - tests

6. Add repo-level context only if directly relevant:
    - modules/packages
    - config hotspots
    - integration areas

7. Identify likely working area:
    - candidate packages/modules
    - likely classes/services if evident from selected flows

8. Capture uncertainty explicitly:
    - no matching flow
    - ambiguous mapping
    - missing context
    - weak evidence

9. Prefer a smaller pack over a broader one.

## Persistence Rules

1. Ensure directory exists:
    - `.arcus/specs/<STORY-ID>/`

2. Write file:
    - `context-pack.md`

3. If file exists:
    - overwrite it

4. Do not write story context packs into `.context/`

## Output Contract

### context_pack (`.arcus/specs/<STORY-ID>/context-pack.md`)

Must include:

- Story Summary
- Relevant Flows
- Entry Points
- Core Path
- Data Touchpoints
- Integrations
- Scope
- Likely Working Areas
- Tests
- Assumptions / Gaps

## Output Quality Rules

- minimal and focused
- derived only from shared context artifacts
- no repo-wide expansion
- no speculative broadening
- explicit about uncertainty

## Validation Gates

- [ ] story_id resolved
- [ ] shared context artifacts read
- [ ] flows selected from `.context/flows`
- [ ] scope limited to relevant areas
- [ ] output written to `.arcus/specs/<STORY-ID>/context-pack.md`

## Failure Modes

- `NO_MATCHING_FLOW`: produce partial pack with explicit gaps
- `AMBIGUOUS_MAPPING`: include bounded alternatives and mark uncertainty
- `INSUFFICIENT_CONTEXT`: report missing shared context needed for grounding

## Handoff

This skill produces temporary story-scoped context, distinct from shared repository-level intelligence.