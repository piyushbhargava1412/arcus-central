---
name: repository-context-builder
description: Build or refresh baseline repository context by analyzing repository structure and generating repo_scope and repo_map artifacts in .context using only code evidence.
inputs:
  - repository_root
outputs:
  - repo_scope
  - repo_map
---

# Repository Context Builder

## Purpose

Generate baseline repository context by creating or updating:

- `.context/repo_scope.md`
- `.context/repo_map.md`

These define repository boundaries and navigation for downstream flow discovery and feature context building.

## When To Use

- initial repo onboarding
- repo context missing or outdated
- before flow discovery

## Non-Goals

Do not:
- infer business flows
- build story-specific context
- reconcile drift from commits
- recommend code changes

## Inputs

- `repository_root`

## Processing Rules

1. Resolve repository root; stop if unresolved.
2. Apply ignore rules:
  - `.arcus-ignore` if present
  - exclude build/generated/vendor/cache/IDE folders
3. Traverse only non-ignored areas.
4. Use only evidence from:
  - directory structure
  - build/config files
  - source/test/config roots
  - package layout
  - Spring entry surfaces (controllers/listeners/schedulers)
  - adapter/integration areas
5. Extract:
  - repository purpose (only if clearly evident)
  - major implementation areas
  - module/package structure
  - source/test/config roots
  - entry surface locations
  - tech stack signals
  - shared/common areas
6. Prefer omission over weak inference.
7. Assign confidence: high / medium / low.
8. Capture the current git HEAD commit hash before writing outputs:
  - Run: `git -C <repository_root> rev-parse HEAD`
  - Store as `CURRENT_COMMIT`
  - If git is unavailable or the repo has no commits: use `unknown`
9. Capture the current ISO timestamp: `GENERATED_AT`

## Persistence Rules

1. Ensure `.context/` exists.
2. Write:
  - `repo_scope.md`
  - `repo_map.md`
3. If files exist → update them (do not duplicate).
4. Preserve structure; replace outdated content.
5. Do not write outside `.context/`.
6. Write the `arcus-context-meta` block at the top of every artifact immediately after the header:

```
<!-- arcus-context-meta
verification-commit: <CURRENT_COMMIT>
generated-at: <GENERATED_AT>
confidence: <high | medium | low>
-->
```

## Output Contract

### repo_scope (`.context/repo_scope.md`)

Must include:

- `arcus-context-meta` block with `verification-commit`, `generated-at`, `confidence`
- Purpose (1–2 lines)
- Core Responsibilities (bullets)
- Major Implementation Areas
- Key Entry Surfaces
- Tech Stack Signals
- Boundaries / Exclusions (if evident)
- Source/Test/Config Roots

### repo_map (`.context/repo_map.md`)

Must include:

- `arcus-context-meta` block with `verification-commit`, `generated-at`, `confidence`
- Top-Level Structure
- Key Packages / Modules
- Entry Surface Locations
- Config Hotspots
- Integration / Adapter Areas
- Test Locations
- Notable Patterns (if evident)

## Validation Gates

- [ ] repository root resolved
- [ ] ignore rules applied
- [ ] outputs evidence-backed
- [ ] both files created/updated
- [ ] `arcus-context-meta` block written to both files with a non-empty `verification-commit`
- [ ] no speculative flows/contracts

## Failure Modes

- `MISSING_ROOT`: repository root unresolved — stop and report
- `PARSE_ERROR`: file cannot be read — stop and report
- `INSUFFICIENT_EVIDENCE`: not enough structure to build context — report what was found and stop
- `CONTEXT_TOO_WEAK`: confidence too low across all areas — report and stop
- `GIT_UNAVAILABLE`: git not found or repo has no commits — use `unknown` for verification-commit, continue

## Handoff

Used by:
- `flow-and-scope-discovery`
- `context-sync`
- `feature-context-pack-builder`
