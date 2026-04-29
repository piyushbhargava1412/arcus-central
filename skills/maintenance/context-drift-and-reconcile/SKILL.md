---
name: context-drift-and-reconcile
description: Detect drift between current code and shared context artifacts using verification commits and git diff, then update only impacted files in .context.
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

## When To Use

- after syncing with latest `main`
- at the start of every new story
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

- **verification commit recorded in context artifacts**
  vs
- **current HEAD after sync**

NOT by local uncommitted changes.

---

## Drift Baseline

1. Read verification metadata from:
    - `.context/repo_scope.md`
    - `.context/repo_map.md`
    - `.context/flows/*.md`

2. Each artifact may contain:
   - Verification 
     - commit: <hash>
     - confidence: high | medium | low 
   - Anchors (optional) - <file-path>

3. If verification commit is missing:
   - mark artifact as stale candidate

---

## Processing Rules

### 1. Resolve repository root
Stop if unresolved.

---

### 2. Verify shared context exists

Required:
- `.context/repo_scope.md`
- `.context/repo_map.md`
- `.context/flows/`

If missing:
→ STOP and instruct baseline context creation

---

### 3. Determine current state

- Ensure repository is synced with latest `main`
- Identify current `HEAD`

---

### 4. Evaluate each artifact independently

For each artifact:

#### Case A: verification commit == HEAD
→ Artifact is fresh → skip

#### Case B: verification commit behind HEAD
→ Potential drift → continue

#### Case C: verification commit missing
→ Mark for refresh

---

### 5. Compute drift window

For each stale candidate: 
changed_files = git diff <verification_commit>.HEAD


If commit unavailable:
→ fallback to bounded recent diff

---

### 6. Classify changes

Group changed files into:

- structure/modules/packages
- entry surfaces (controllers/listeners/schedulers)
- services/orchestrators
- repositories/entities
- integrations/adapters/events
- config
- tests

---

### 7. Impact detection

Determine if artifact is affected.

#### For repo_map:
- changes in structure, packages, modules

#### For repo_scope:
- changes in responsibilities, boundaries, entry surfaces, runtime signals

#### For flows:
- match changed files with:
    - entry points
    - core path classes
    - scope packages
    - anchors (if present)

---

### 8. Apply updates

- Update only impacted artifacts
- Do not touch unaffected ones

#### Flow-specific:
- update matching flow
- if new entry surface detected → create new flow
- if flow invalid → update or mark

---

### 9. Refresh verification metadata

For each updated artifact:
commit: <current HEAD>
confidence: updated level


---

## Persistence Rules

- Update only inside `.context/`
- Preserve structure and format
- Do not duplicate flows
- Do not overwrite unrelated artifacts
- Keep updates minimal

---

## Output Contract

### updated_context

Return only:

- list of updated artifacts
- list of new/modified flows

No verbose explanations.

---

## Output Quality Rules

- git-based drift detection (verification → HEAD)
- minimal updates only
- no full rebuild unless required
- no speculative mapping
- explicit handling of uncertainty

---

## Validation Gates

- [ ] repository root resolved
- [ ] shared context exists
- [ ] verification commit read
- [ ] drift window computed correctly
- [ ] only impacted artifacts updated
- [ ] verification metadata refreshed

---

## Failure Modes

- `MISSING_ROOT`: repository root unresolved
- `MISSING_CONTEXT`: baseline context missing
- `NO_VERIFICATION_COMMIT`: fallback used
- `UNMAPPED_CHANGE`: mark for review
- `FLOW_MATCH_FAILURE`: create new flow instead of guessing

---

## Handoff

Used before:
- `feature-context-pack-builder`
- specify agent
- plan agent

Maintains shared repository intelligence.
Does not produce story-local artifacts.
    