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
  - feature description (`$ARGUMENTS`)
  - `.arcus/templates/spec-template.md`
  - `.arcus/templates/checklist-template.md`
  - `.context/repo_scope.md`
  - `.context/repo_map.md`
  - `.context/testing-patterns.md`
  - `.context/flows/*.md`
- Optional:
  - `.github/copilot-instructions.md` (guardrails)
- Output artifacts:
  - `.arcus/specs/<STORY-ID>/context-pack.md`
  - `.arcus/specs/<STORY-ID>/spec.md`
  - `.arcus/specs/<STORY-ID>/requirements.md`
- Out-of-scope:
  - implementation design
  - stack decisions
  - code generation
  - repo-wide scanning when `.context/` is available

## Execution Steps (follow skill definitions in order)

1. Follow steps in `.github/skills/core/session-bootstrap/SKILL.md` — Resolve story ID, feature paths, and environment context.
2. Follow steps in `.github/skills/context/context-sync/SKILL.md` — Detect and reconcile any drift in `.context/` before use (repo-wide mode — no context_pack).
3. Follow steps in `.github/skills/context/feature-context-pack-builder/SKILL.md` — Build a minimal story-scoped context pack from `.context/` artifacts.
4. Follow steps in `.github/skills/specialized/spec/spec-authoring/SKILL.md` — Transform feature description into structured spec content.
5. Follow steps in `.github/skills/specialized/spec/ambiguity-detection/SKILL.md` — Identify high-impact unknowns; emit ≤3 clarification markers.
6. Follow steps in `.github/skills/core/quality-gates/SKILL.md` — Validate spec and requirements completeness against `spec-gates` profile.
7. Follow steps in `.github/skills/core/report-renderer/SKILL.md` — Return completion status, assumptions summary, and readiness for `/sdd.clarify`.

## Outline

### 0. Sync Latest Code

Ensure the working branch is reconciled with latest `main` before scanning any files. Use safe repo workflow (stash if needed; do not force-overwrite local changes).

### 1. Parse Input

- If `$ARGUMENTS` is empty → stop immediately with: "Please provide a feature description to specify."
- If `$ARGUMENTS` is a story ID only (no description) → stop and ask: "Please provide a feature description alongside the story ID."

### 2. Resolve Paths

Derive canonical paths for this story:
- `FEATURE_DIR` = `.arcus/specs/<STORY-ID>/`
- `CONTEXT_PACK` = `FEATURE_DIR/context-pack.md`
- `SPEC_FILE` = `FEATURE_DIR/spec.md`
- `REQUIREMENTS_FILE` = `FEATURE_DIR/requirements.md`

If `STORY-ID` cannot be determined from input, derive it from the current git branch name (format: `###-feature-name`). If still unresolvable → stop and ask user to provide a story ID.

### 3. Verify Bootstrap Context Exists

Check that `.context/` artifacts exist:
- `.context/repo_scope.md`
- `.context/repo_map.md`

If either is missing → stop with: "Repository context is missing. Run `/sdd.context-builder` first, then retry."

Do not attempt to generate or infer `.context/` content — this agent is a consumer, not a producer of shared context.

### 4. Drift Reconcile

Run `context/context-sync` in repo-wide mode (no `context_pack` — it hasn't been built yet):
- The skill reads verification commits from `.context/` artifacts and compares to current HEAD
- If context is already current → skill returns immediately with no work done
- If drift is detected → skill updates only impacted `.context/` artifacts and reports what changed
- If drift is significant → surface it to the user and suggest running `/sdd.context-builder` for a full rebuild
- Do not block on drift; surface it and let the user decide

### 5. Build Context Pack

Run `context/feature-context-pack-builder` to produce a minimal story-scoped context pack:
- Relevant flows from `.context/flows/*.md` that overlap with the feature description
- Relevant sections from `.context/repo_scope.md` (business capabilities)
- Relevant sections from `.context/repo_map.md` (modules and entry points likely touched)
- Testing patterns from `.context/testing-patterns.md`

The context pack must be minimal — prefer 1–2 primary flows over broad coverage. Write to `context-pack.md`.

### 6. Load Templates

Load from `.arcus/templates/`:
- `spec-template.md` — required sections and structure for `spec.md`
- `checklist-template.md` — structure for `requirements.md`

If either template is missing → stop and ask user to run `arcus-integrate --sync`.

### 7. Generate Spec

Run `specialized/spec/spec-authoring` with:
- `feature_description`: the user's `$ARGUMENTS`
- `spec_template`: loaded in step 6
- `context_pack`: produced in step 5
- `guardrails`: `.github/copilot-instructions.md` if present

The skill generates sections in this order: User Scenarios → Requirements → Success Criteria → Edge Cases.

Key constraints enforced by the skill (do not re-implement here — delegate fully):
- User stories ordered by priority (P1 first), each with an Independent Test field
- Functional requirements use MUST/SHOULD/MAY; no implementation detail leakage
- Success criteria are measurable with numeric or verifiable thresholds
- Assumptions recorded separately, not embedded in spec body

### 8. Ambiguity Detection

Run `specialized/spec/ambiguity-detection` against the generated spec draft:
- Cap at 3 `[NEEDS CLARIFICATION: ...]` markers
- Prioritise by impact: scope > security > UX > technical detail
- Lower-impact unknowns resolved with explicit assumptions instead

If 0 markers are produced → spec is sufficiently clear; note this in the report.
If markers remain after spec generation → they are left in `spec.md` for `sdd.clarify` to resolve interactively. Do not attempt to resolve them here.

### 9. Generate Requirements

Using the checklist template and the spec content, produce `requirements.md` as a flat, testable checklist:
- Every `FR-XXX` in spec → at least one `REQ-XXX` entry
- Every success criterion → one `SC-XXX` entry
- Every non-functional requirement → one `NFR-XXX` entry
- Format: `- [ ] REQ-001: <testable statement>`

`requirements.md` must not duplicate spec prose — it is a machine-readable checklist only.

### 10. Quality Gates

Run `core/quality-gates` with `gate_profile: spec-gates`:
- Max 3 refinement passes
- On each failed gate, apply targeted fix to the relevant spec section and re-run
- If gates still failing after 3 passes → stop, report unresolved gate failures, do not write outputs

Do not proceed to step 11 if any CRITICAL gate is failing.

### 11. Write Outputs

Write all three artifacts atomically in this order:
1. `context-pack.md` (story context)
2. `spec.md` (feature specification)
3. `requirements.md` (testable checklist)

Before writing `spec.md` and `requirements.md`, populate the `arcus-artifact-meta` block in the template with:
- `arcus-version`: read from `.arcus-metadata.json` → `version` field; use `unknown` if unavailable
- `generated-at`: current ISO timestamp (`YYYY-MM-DDThh:mm:ssZ`)

All files written to `FEATURE_DIR`. Create the directory if it does not exist.

### 11.5. Create Session Checkpoint

After successful spec validation and before reporting:
- Call `session/checkpoint-manager` with:
  * story_id: <STORY-ID>
  * current_stage: `specify`
  * execution_summary: "Specification created with X user stories and Y functional requirements"
  * blockers: [any remaining ambiguities or assumptions that may need clarification]
- Checkpoint is written to `.arcus/specs/<STORY-ID>/SESSION_CHECKPOINT.md`

### 12. Report

Return a concise completion report via `core/report-renderer` including:
- Paths of written files
- User story count and priority breakdown (P1/P2/P3)
- Functional requirement count
- Clarification markers remaining (if any) — with instruction to run `/sdd.clarify` next
- Assumptions list (explicit defaults applied during spec authoring)
- Readiness status for next stage: `/sdd.clarify` (if markers exist) or `/sdd.plan` (if spec is clear)

## Error Handling

- Empty or missing `$ARGUMENTS`: stop and ask for a feature description.
- Missing `.context/`: stop and instruct to run `/sdd.context-builder` first.
- Missing templates: stop and instruct to run `arcus-integrate --sync`.
- Quality gates failing after 3 passes: stop, report unresolved issues, do not write partial outputs.
- Story ID unresolvable: stop and ask user to provide it explicitly.

## Stage Rules

- WHAT and WHY only — no HOW, no stack decisions, no implementation details
- Use `.context/` + `context-pack.md` as the only sources of repository intelligence
- No repo-wide scanning when `.context/` is available
- Record all reasonable defaults as explicit assumptions — never silently invent requirements
- Respect `.github/copilot-instructions.md` guardrails when present
- Do not resolve `[NEEDS CLARIFICATION]` markers — leave them for `/sdd.clarify`
- Do not write partial outputs — all three artifacts written together or not at all
