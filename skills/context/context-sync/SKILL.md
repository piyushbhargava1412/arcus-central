---
name: context-sync
description: Detect drift between current code and shared .context artifacts using verification commits and git diff, then update only impacted artifacts. Operates in repo-wide mode (story start) or story-scoped mode (post-implementation) depending on whether a context_pack is provided.
metadata:
  inputs:
    - repository_root
    - story_id (optional — required for story-scoped mode)
    - context_pack (optional — triggers story-scoped mode when provided)
  outputs:
    - updated_context
---

# Context Sync

## Purpose

Keep shared `.context/` artifacts aligned with the actual codebase using minimal, targeted updates.

Updates only impacted artifacts in:

- `.context/repo_scope.md`
- `.context/repo_map.md`
- `.context/flows/*.md`
- `.context/testing-patterns.md`

## Operating Modes

This skill operates in one of two modes determined by whether `context_pack` is provided:

### Repo-Wide Mode (no `context_pack`)

Used at the **start of a new story** to catch any changes that landed on `main` since the last context update — regardless of who made them or which story they belonged to.

- Drift source: all commits between `verification-commit` and current `HEAD`
- Scope: entire repository change set
- Callers: `sdd.specify`

### Story-Scoped Mode (`context_pack` provided)

Used **after implementation** to reconcile context with the specific changes made during this story.

- Drift source: this story's implementation changes, focused through `context_pack` scope
- Scope: story-relevant files and flows identified in `context_pack`
- Callers: `sdd.analyze` (post-implementation), `sdd.close`

## When To Use

- At the start of every new story — before building story context (repo-wide mode)
- After story implementation is complete (story-scoped mode)
- During story closure (story-scoped mode)
- After non-ARCUS code changes when selective context refresh is needed

## Non-Goals

Do not:
- rebuild all `.context/` artifacts from scratch — use `sdd.context-builder` for that
- generate story-specific artifacts (`spec.md`, `plan.md`, `tasks.md`, `context-pack.md`)
- scan the entire repository unless git diff fallback is required
- update artifacts outside `.context/`
- infer behaviour without evidence from code changes

## Inputs

- `repository_root`: path to the target repository root
- `story_id` (optional): story identifier — required in story-scoped mode
- `context_pack` (optional): loaded from `.arcus/specs/<STORY-ID>/context-pack.md` — presence triggers story-scoped mode

## Core Principle

Use the smallest possible change set to update only the shared context that is actually affected. Always check freshness before doing any work.

---

## Processing Rules

### 0. Freshness Check (Early Exit)

Before any analysis, determine whether a sync is actually needed:

1. Read the `arcus-context-meta` block from `.context/repo_scope.md`
2. Extract `verification-commit`
3. Run: `git -C <repository_root> rev-parse HEAD` → `CURRENT_HEAD`
4. Compare:
  - If `verification-commit == CURRENT_HEAD` → context is already current; **return immediately** with: `"Context already current — no sync needed (verification-commit matches HEAD)"`. Do not proceed further.
  - If `verification-commit` is behind `CURRENT_HEAD` or is `unknown` → proceed.

If git is unavailable → skip freshness check and proceed; log `GIT_UNAVAILABLE` warning.
If `.context/repo_scope.md` is missing or has no `arcus-context-meta` block → skip freshness check and proceed; log `NO_VERIFICATION_COMMIT` warning.

---

### 1. Verify Shared Context Exists

Required artifacts:
- `.context/repo_scope.md`
- `.context/repo_map.md`
- `.context/flows/` (directory)
- `.context/testing-patterns.md`

If any are missing → STOP and instruct baseline context creation via `/sdd.context-builder`.

---

### 2. Determine Sync Scope

**Repo-wide mode** (no `context_pack`):
- Compute `changed_files` = `git diff <verification-commit>..<CURRENT_HEAD> --name-only`
- Apply `.arcus-ignore` patterns to exclude irrelevant files
- If `verification-commit` is `unknown` → fallback: `git diff HEAD~10..HEAD --name-only`; log `NO_VERIFICATION_COMMIT` warning

**Story-scoped mode** (`context_pack` provided):
- Load `context_pack` to identify:
  - relevant flows
  - intended scope / packages
  - likely files / areas
  - tests
  - assumptions / gaps
- Compute `changed_files` = git diff of story branch changes
- Cross-reference `changed_files` against `context_pack` scope to focus impact detection
- Files outside story scope are noted as `SCOPE_DEVIATION` but still evaluated for context impact

---

### 3. Classify Changed Files

Group changed files into:

- `structure` — directory layout, module/package reorganisation
- `entry-surfaces` — controllers, listeners, schedulers, Lambda handlers
- `services` — service classes, orchestrators, use cases
- `repositories` — DAOs, stores, repositories
- `integrations` — adapters, event producers/consumers, external clients
- `config` — application config, infrastructure config, env files
- `tests` — test files, fixtures, test utilities

---

### 4. Impact Detection

Determine which `.context/` artifacts are affected:

#### `repo_map.md`
Refresh if changed files fall into:
- `structure`, `entry-surfaces`, `services`, `integrations`, `config`

#### `repo_scope.md`
Refresh if changed files fall into:
- `entry-surfaces`, `integrations`, `services` (when they indicate new capabilities or boundary changes)

#### `flows/*.md`
Match changed files against each flow file using:
- flow's declared entry points
- flow's core path classes
- flow's scope packages
- `context_pack` flow names and scope paths (story-scoped mode only)

Refresh only flow files where changed files overlap with the flow's scope.

If a new entry surface is detected with no matching flow → create a new flow file.
If a flow's entry surface was removed → mark flow as `status: stale` in its meta block rather than deleting.

#### `testing-patterns.md`
Refresh if changed files fall into `tests` AND the changes introduce or alter:
- test frameworks or libraries
- fixture/builder/factory patterns
- assertion styles
- Spring/integration testing conventions

Do not refresh for trivial one-off test additions that don't alter established patterns.

---

### 5. Apply Updates

For each impacted artifact:
- Read current content
- Update only the sections affected by the classified changes
- Preserve structure, headings, and formatting
- Keep content concise and evidence-backed

For unaffected artifacts: do not touch them.

---

### 6. Refresh Verification Metadata

For each updated artifact, write the updated `arcus-context-meta` block:

```
<!-- arcus-context-meta
verification-commit: <CURRENT_HEAD>
generated-at: <current ISO timestamp>
confidence: <updated level>
-->
```

Leave unmodified artifacts' meta blocks unchanged.

---

## Persistence Rules

- Update only inside `.context/`
- Preserve structure and format of each artifact
- Do not duplicate flow files
- Do not overwrite unrelated artifacts
- Keep updates minimal — targeted section updates, not full regeneration

---

## Output Contract

Must report:

- early exit message if context was already current
- mode used (repo-wide or story-scoped)
- list of updated artifacts with reason
- list of newly created flow files (if any)
- list of skipped artifacts (confirmed fresh or not impacted)
- manual review items (if `UNMAPPED_CHANGE` or `FLOW_SYNC_AMBIGUITY` occurred)
- `SCOPE_DEVIATION` warnings (story-scoped mode only)

Keep output concise and scannable.

---

## Validation Gates

- [ ] freshness check performed before any analysis
- [ ] operating mode determined correctly (repo-wide vs story-scoped)
- [ ] shared context artifacts confirmed present
- [ ] changed files classified correctly
- [ ] only impacted artifacts updated
- [ ] `arcus-context-meta` block refreshed on every updated artifact with `CURRENT_HEAD`
- [ ] unmodified artifacts left completely unchanged

---

## Failure Modes

- `CONTEXT_ALREADY_CURRENT`: early exit — verification-commit matches HEAD; no work needed
- `MISSING_CONTEXT`: one or more required `.context/` artifacts absent — stop and instruct to run `/sdd.context-builder`
- `GIT_UNAVAILABLE`: git not found — skip freshness check, use fallback diff where possible
- `NO_VERIFICATION_COMMIT`: `arcus-context-meta` block absent or commit is `unknown` — use fallback diff
- `MISSING_ROOT`: repository root unresolved — stop and report
- `UNMAPPED_CHANGE`: changed file cannot be mapped to any `.context/` artifact — log for manual review, continue
- `FLOW_SYNC_AMBIGUITY`: changed file matches multiple flows — log for manual review, update most specific match only
- `SCOPE_DEVIATION`: changed file is outside story scope (story-scoped mode) — log warning, still evaluate for context impact
- `OVERBROAD_REFRESH`: refresh scope would require rewriting >50% of an artifact — abort that artifact's refresh, report for manual `/sdd.context-builder` run

---

## Handoff

Used by:
- `sdd.specify` (repo-wide mode — before feature context pack building)
- `sdd.analyze` (story-scoped mode — post-implementation)
- `sdd.close` (story-scoped mode — before archiving)

Do NOT use for:
- initial context generation → use `sdd.context-builder` instead
- full context rebuild after major restructuring → use `sdd.context-builder` instead
