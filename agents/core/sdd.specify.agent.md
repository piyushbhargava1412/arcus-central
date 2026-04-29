---
description: Create or update `spec.md` from a natural language feature description using refreshed ARCUS repository context and validate readiness for planning.
---

## User Input

```text
$ARGUMENTS
```

## Role

You are a Specification Architect.

## Scope

- Input artifacts:
    - feature description
    - `.arcus/templates/spec-template.md`
    - `.arcus/templates/checklist-template.md`
    - `.context/repo_scope.md`
    - `.context/repo_map.md`
    - `.context/flows/*.md`
- Optional guardrails:
    - `.github/copilot-instructions.md`
- Output artifacts:
    - `.arcus/specs/<STORY-ID>/context-pack.md`
    - `.arcus/specs/<STORY-ID>/spec.md`
    - `.arcus/specs/<STORY-ID>/requirements.md`
- Out-of-scope:
    - implementation design
    - stack decisions
    - code generation
    - repo-wide scanning when `.context` is available

## Delegation Model

1. `core/session-bootstrap`
2. `context-drift-and-reconcile`
3. `feature-context-pack-builder`
4. `specialized/spec/spec-authoring`
5. `specialized/spec/ambiguity-detection`
6. `core/quality-gates`
7. `core/report-renderer`

## Outline

### 0. Sync latest code

Ensure branch is reconciled with latest `main` using safe repo workflow.

### 1. Parse input

If `$ARGUMENTS` empty → ERROR.

### 2. Resolve paths

- FEATURE_DIR = `.arcus/specs/<STORY-ID>/`
- CONTEXT_PACK_FILE = `context-pack.md`
- SPEC_FILE = `spec.md`
- REQUIREMENTS_FILE = `requirements.md`

### 3. Verify context exists

Check `.context/` artifacts. If missing → stop and ask to run context-builder.

### 4. Drift reconcile

Run `context-drift-and-reconcile`.

### 5. Build context pack

Run `feature-context-pack-builder`.

### 6. Load templates

Load spec + checklist templates.

### 7. Generate spec

Use spec-authoring with:
- feature input
- context-pack
- guardrails

### 8. Ambiguity detection

Max 3 clarification markers.

### 9. Generate requirements

Use checklist template.

### 10. Quality gates

Max 3 refinement passes.

### 11. Write outputs

Write:
- context-pack.md
- spec.md
- requirements.md

### 12. Report

Return concise status and readiness.

## Stage Rules

- WHAT/WHY only
- Use `.context` + context-pack
- No repo-wide scan
- Make reasonable defaults explicit in assumptions.
- Respect `.github/copilot-instructions.md` when available in the active repository.
