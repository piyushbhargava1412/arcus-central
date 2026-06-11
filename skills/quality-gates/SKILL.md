---
name: quality-gates
description: Apply deterministic quality checks to spec, plan, or tasks artifacts with explicit pass/fail gate results and prioritised remediation items. Use when validating stage readiness before handoff to the next SDD phase, or when the user asks to check or validate an artifact.
metadata:
  version: "1.0.0"
  type:
    - agents
---

# Quality Gates

## Purpose

Provide reusable quality validation with explicit pass/fail outcomes. Validates artifacts for structural completeness, internal consistency, and readiness for downstream processing.

## Inputs

- `artifact`: draft stage artifact to validate
- `checklist_template`: checklist structure to populate (from `.arcus/templates/checklist-template.md`)
- `gate_profile`: name of the gate set to apply — one of `spec-gates`, `plan-gates`, `tasks-gates`
- `guardrails` (optional): project-level constraints from `AGENTS.md`

## Processing Rules

1. Load the gate profile matching `gate_profile` input (see Gate Profiles below).
2. Read the `arcus-artifact-meta` HTML comment block from the artifact (immediately after the title line):
  - Extract: `generated-by`, `template`, `arcus-version`, `generated-at`
  - If block is absent: flag `MISSING_META_BLOCK` as a LOW severity finding — do not fail the gate, but note it
  - If `arcus-version` differs from the current ARCUS version (read from `.arcus-metadata.json`): flag `TEMPLATE_VERSION_DRIFT` as MEDIUM severity — the artifact may have been generated from an older template
3. Evaluate each gate against the artifact content — record PASS / FAIL with a concise evidence citation (e.g., `spec.md: FR-003 has no measurable outcome`).
4. Generate a prioritised remediation item for every FAIL.
5. When `guardrails` are provided, run guardrail compatibility as an additional gate pass.
6. Support bounded re-validation loops (max 3 iterations) for updated artifacts. After max iterations, return `UNRESOLVED_FAILURES`.
7. Aggregate results into a gate result summary with overall PASS / FAIL status.

## Gate Profiles

Full gate specifications for all three profiles are in [references/gate-profiles.md](references/gate-profiles.md).

Available profiles:
- `spec-gates` — validates `spec.md` and `requirements.md` (S1–S11)
- `plan-gates` — validates `plan.md` (P1–P11)
- `tasks-gates` — validates `tasks.md` (T1–T11)

## Output Contract

- Must return:
  - rendered checklist with PASS/FAIL status per gate and evidence citations
  - gate result summary (overall PASS / FAIL + counts)
  - prioritised remediation list for all FAILs
- Must not return:
  - implementation-specific design recommendations
  - content written to any artifact file (quality gates are read-only)

## Failure Modes

- `GATE_PROFILE_MISSING`: stop and report — `gate_profile` input does not match any defined profile
- `UNRESOLVED_FAILURES`: return unresolved gate list after max 3 re-validation iterations
- `INVALID_CHECKLIST_TEMPLATE`: stop and report template structure mismatch
- `ARTIFACT_UNREADABLE`: stop and report if the target artifact cannot be parsed
- `MISSING_META_BLOCK`: `arcus-artifact-meta` block absent — LOW severity, note in report, do not fail gate
- `TEMPLATE_VERSION_DRIFT`: `arcus-version` in artifact differs from current ARCUS version — MEDIUM severity, artifact may have been generated from an older template; suggest regenerating
