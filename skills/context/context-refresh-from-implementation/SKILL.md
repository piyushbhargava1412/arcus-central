---
name: context-refresh-from-implementation
description: Reconcile shared `.context` artifacts with actual implementation changes by comparing changed files against story scope, flow anchors, and verification metadata, then updating only impacted context artifacts.
inputs:
  - repository_root
  - story_id
  - context_pack
outputs:
  - refreshed_context
---

# Context Refresh From Implementation

## Purpose

After implementation, reconcile shared repository context with actual code changes.

Update only impacted artifacts in:

- `.context/repo_scope.md`
- `.context/repo_map.md`
- `.context/flows/*.md`
- `.context/testing-patterns.md`

This skill is used after implementation to keep shared context aligned with reality.

## When To Use

- after story implementation is complete
- during post-implementation analyze
- during PR/merge readiness review when context must be refreshed
- after non-ARCUS code changes when selective context refresh is needed

## Non-Goals

Do not:
- generate story-local artifacts
- modify `spec.md`, `plan.md`, `tasks.md`, or `context-pack.md`
- rebuild all `.context` artifacts unless clearly required
- infer behavior without evidence from code changes
- create broad documentation outside `.context/`

## Inputs

- `repository_root`
- `story_id`
- `context_pack`

## Core Principle

Use the smallest possible implementation delta to refresh only the shared context that is actually affected.

Prefer targeted refresh over full regeneration.

## Processing Rules

### 1. Resolve story scope

Read:
- `.arcus/specs/<STORY-ID>/context-pack.md`

Use it to identify:
- relevant flows
- intended scope/packages
- likely files/areas
- tests
- assumptions/gaps

### 2. Determine implementation delta

Identify actual code changes for the story using:
- changed files on the current branch
- committed and/or staged changes relevant to the story
- git diff against the appropriate baseline when available

Prefer comparing:
- implementation changes for this story
  against
- the story scope and current shared context verification metadata

### 3. Classify changed files

Classify changes into:
- structure/modules/packages
- entry surfaces
- services/orchestrators
- repositories/entities
- integrations/adapters/events
- config
- tests

### 4. Detect context impact

Use changed files plus `context_pack` to determine whether to refresh:

#### `repo_map.md`
Refresh if changed files affect:
- module/package structure
- entry-surface locations
- config hotspots
- integration/adaptor areas

#### `repo_scope.md`
Refresh if changed files affect:
- repo responsibilities/boundaries
- runtime surfaces
- major implementation areas
- exclusions or ownership signals

#### `flows/*.md`
Refresh only impacted flow files using:
- flow names from `context_pack`
- entry points
- scope paths
- flow verification anchors if present

If a new meaningful flow emerged from implementation:
- create a new flow file

If an existing flow materially changed:
- update only that flow file

#### `testing-patterns.md`
Refresh only if implementation introduces or changes:
- recurring test conventions
- testing frameworks/libraries
- fixture/builder style
- assertion style
- Spring/integration testing style
- canonical example tests

Do not refresh for trivial one-off tests.

### 5. Update minimally

For each impacted artifact:
- preserve structure
- update only the sections affected by implementation
- refresh verification metadata
- keep content concise and evidence-backed

### 6. Refresh verification metadata

For each updated artifact, update:

- commit
- confidence

If anchors are used in the artifact format, refresh them when needed.

## Persistence Rules

- Update only inside `.context/`
- Never modify story-local artifacts
- Never overwrite unrelated flow files
- Never duplicate flow files
- Keep changes minimal and structurally consistent

## Output Contract

### refreshed_context

Must report only:

- updated shared artifacts
- newly created flow files (if any)
- unchanged artifacts intentionally skipped
- manual review items if safe refresh was not possible

Keep output concise.

## Validation Gates

- [ ] story_id resolved
- [ ] context-pack loaded
- [ ] implementation delta identified
- [ ] only impacted shared artifacts updated
- [ ] verification metadata refreshed
- [ ] no story-local artifacts modified

## Failure Modes

- `MISSING_STORY_CONTEXT`: missing `.arcus/specs/<STORY-ID>/context-pack.md`
- `NO_IMPLEMENTATION_DELTA`: no relevant code changes found
- `UNMAPPED_CHANGE`: changed file cannot be safely mapped to shared context
- `FLOW_REFRESH_AMBIGUITY`: flow impact unclear; report for manual review
- `OVERBROAD_REFRESH`: refresh scope expanded beyond evidence; abort and narrow

## Handoff

Used by:
- `sdd.analyze` (post-implementation mode)
- future review / merge-readiness agents
- manual context maintenance workflows

Produces selective shared-context refresh only.
