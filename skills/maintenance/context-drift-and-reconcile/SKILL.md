---
name: context-drift-and-reconcile
description: Detect drift between current code and shared context artifacts using arcus-context-meta verification commits and git diff, then update only impacted files in .context.
inputs:
  - repository_root
outputs:
  - updated_context
---

# Context Drift and Reconcile

## Purpose

Ensure shared repository context is aligned with the latest code after sync.

Update only impacted artifacts in:

- `.context/repo_scope.md`
- `.context/repo_map.md`
- `.context/flows/*.md`
- `.context/testing-patterns.md`

## When To Use

- after syncing with latest `main`
- at the start of every new story (called by `sdd.specify`)
- before building story context

## Non-Goals

Do not:
- rebuild all context unnecessarily
- generate story-specific context
- scan entire repository unless fallback required
- update artifacts outside `.context/`

## Inputs

- `repository_root`

## Core Principle

Drift is determined by comparing:

- **`verification-commit` recorded in each artifact's `arcus-context-meta` block**
  vs
- **current HEAD after sync**

NOT by local uncommitted changes.

---

## Reading Verification Metadata

Each `.context/` artifact contains an `arcus-context-meta` HTML comment block immediately after its header:

```
<!-- arcus-context-meta
verification-commit: <hash>
generated-at: <ISO-TIMESTAMP>
confidence: high | medium | low
-->
```

To read the verification commit for an artifact:
1. Open the file
2. Locate the `<!-- arcus-context-meta` block
3. Extract the `verification-commit:` value
4. If the block is absent or `verification-commit` is `unknown` → mark artifact as stale candidate

---

## Processing Rules

### 1. Resolve repository root

Stop with `MISSING_ROOT` if unresolvable.

### 2. Verify shared context exists

Required artifacts:
- `.context/repo_scope.md`
- `.context/repo_map.md`
- `.context/flows/` (directory)
- `.context/testing-patterns.md`

If any are missing → STOP and instruct baseline context creation via `/sdd.context-builder`.

### 3. Determine current HEAD

Run: `git -C <repository_root> rev-parse HEAD`

Store as `CURRENT_HEAD`.

If git unavailable → use fallback (bounded recent diff on modified files). Log `GIT_UNAVAILABLE` warning.

### 4. Evaluate each artifact independently

Apply to: `repo_scope.md`, `repo_map.md`, all `flows/*.md`, `testing-patterns.md`

For each artifact, read `verification-commit` from its `arcus-context-meta` block:

#### Case A: `verification-commit` == `CURRENT_HEAD`
→ Artifact is fresh → skip, no update needed

#### Case B: `verification-commit` is behind `CURRENT_HEAD`
→ Potential drift → proceed to drift window computation

#### Case C: `verification-commit` is `unknown` or block is missing
→ Mark as stale candidate → proceed to drift window computation using fallback

### 5. Compute drift window

For each stale candidate:

```
changed_files = git diff <verification-commit>..<CURRENT_HEAD> --name-only
```

If `verification-commit` is `unknown`:
→ Fallback: use `git diff HEAD~10..HEAD --name-only` (bounded recent diff)
→ Log `NO_VERIFICATION_COMMIT` warning

Apply `.arcus-ignore` patterns to exclude irrelevant changed files before impact detection.

### 6. Classify changed files

Group changed files from the drift window into:

- `structure` — directory layout, module/package reorganisation
- `entry-surfaces` — controllers, listeners, schedulers, Lambda handlers
- `services` — service classes, orchestrators, use cases
- `repositories` — DAOs, stores, repositories
- `integrations` — adapters, event producers/consumers, external clients
- `config` — application config, infrastructure config, env files
- `tests` — test files, fixtures, test utilities

### 7. Impact detection

Determine which `.context/` artifacts are affected by the classified changes:

#### `repo_map.md`
Refresh if changed files fall into:
- `structure`, `entry-surfaces`, `services`, `integrations`, `config`

#### `repo_scope.md`
Refresh if changed files fall into:
- `entry-surfaces`, `integrations`, `services` (when they indicate new capabilities or boundary changes)

#### `flows/*.md`
For each stale flow file, match changed files against:
- flow's declared entry points
- flow's core path classes
- flow's scope packages

Refresh only flow files where changed files overlap with the flow's scope.
If a new `entry-surface` is detected that matches no existing flow → create a new flow file.

#### `testing-patterns.md`
Refresh if changed files fall into:
- `tests` — when changes introduce new frameworks, assertion styles, fixture patterns, or test structural conventions
- Do NOT refresh for trivial one-off test additions that don't alter the established pattern

### 8. Apply updates

For each impacted artifact:

1. Read the current artifact content
2. Update only the sections affected by the changed files — do not rewrite unrelated sections
3. Preserve structure, headings, and formatting
4. Write the updated `arcus-context-meta` block with:
  - `verification-commit: <CURRENT_HEAD>`
  - `generated-at: <current ISO timestamp>`
  - `confidence: <updated level>`

For unaffected artifacts:
- Do not touch them
- Do not update their `arcus-context-meta` block

#### Flow-specific update rules:
- Changed files overlap with existing flow scope → update that flow file only
- New entry surface with no matching flow → create new flow file with full `arcus-context-meta` block
- Existing flow's entry surface removed → mark flow as `status: stale` in its meta block rather than deleting

### 9. Refresh verification metadata

For every artifact that was updated, overwrite its `arcus-context-meta` block:

```
<!-- arcus-context-meta
verification-commit: <CURRENT_HEAD>
generated-at: <current ISO timestamp>
confidence: <high | medium | low>
-->
```

For artifacts that were skipped (Case A), leave their meta block unchanged.

---

## Persistence Rules

- Update only inside `.context/`
- Preserve structure and format of each artifact
- Do not duplicate flow files
- Do not overwrite unrelated artifacts
- Keep updates minimal — targeted section updates, not full regeneration

---

## Output Contract

Return only:

- list of updated artifacts with reason (which changed files triggered the update)
- list of newly created flow files (if any)
- list of skipped artifacts (confirmed fresh)
- list of manual review items (if `UNMAPPED_CHANGE` or `FLOW_REFRESH_AMBIGUITY` occurred)
- **flow index staleness flag**: if new or modified flow files were detected, note that `.github/copilot-instructions.md` Business Flows section may be stale — suggest running `/sdd.instructions` to regenerate the index

No verbose explanations. Keep output scannable.

---

## Validation Gates

- [ ] repository root resolved
- [ ] all four `.context/` artifact types checked
- [ ] `arcus-context-meta` block read from each artifact
- [ ] drift window computed correctly per artifact
- [ ] only impacted artifacts updated
- [ ] `arcus-context-meta` block refreshed on every updated artifact with `CURRENT_HEAD`
- [ ] skipped artifacts left completely unchanged

---

## Failure Modes

- `MISSING_ROOT`: repository root unresolved — stop and report
- `MISSING_CONTEXT`: one or more required `.context/` artifacts absent — stop and instruct to run `/sdd.context-builder`
- `GIT_UNAVAILABLE`: git not found — use bounded recent diff fallback, log warning
- `NO_VERIFICATION_COMMIT`: `arcus-context-meta` block absent or commit is `unknown` — use fallback diff, log warning
- `UNMAPPED_CHANGE`: changed file cannot be mapped to any `.context/` artifact — log for manual review, continue with other files
- `FLOW_REFRESH_AMBIGUITY`: changed file matches multiple flows — log for manual review, update most specific matching flow only
- `OVERBROAD_REFRESH`: refresh scope would require rewriting more than 50% of an artifact — abort that artifact's refresh, report for manual `/sdd.context-builder` run

---

## Handoff

Used before:
- `feature-context-pack-builder`
- `sdd.specify` (step 4)

Maintains shared repository intelligence.
Does not produce story-local artifacts.
