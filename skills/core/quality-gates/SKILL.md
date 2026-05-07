---
name: quality-gates
description: Apply deterministic quality checks to stage artifacts with pass/fail results.
metadata:
  inputs:
    - artifact
    - checklist_template
    - gate_profile
    - guardrails (optional)
  outputs:
    - checklist
    - gate_results
    - remediation_items
---

# Quality Gates

## Purpose

Provide reusable, stage-agnostic quality validation with explicit pass/fail outcomes. Called by agents at the end of each pipeline stage to confirm the artifact is ready before the next stage begins.

## Inputs

- `artifact`: draft stage artifact to validate
- `checklist_template`: checklist structure to populate (from `.arcus/templates/checklist-template.md`)
- `gate_profile`: name of the gate set to apply — one of `spec-gates`, `plan-gates`, `tasks-gates`
- `guardrails` (optional): project-level constraints from `.github/copilot-instructions.md`

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

### `spec-gates` — used by `sdd.specify`

Validates that `spec.md` and `requirements.md` are complete, testable, and technology-agnostic.

| # | Gate | PASS condition |
|---|------|----------------|
| S1 | `arcus-artifact-meta` block present | Block exists immediately after title; `generated-by`, `template`, `arcus-version`, `generated-at` all populated |
| S2 | Required sections present | `spec.md` contains: User Scenarios, Requirements, Success Criteria |
| S2 | Required sections present | `spec.md` contains: User Scenarios, Requirements, Success Criteria |
| S3 | At least one user story | Minimum 1 user story with priority assigned (P1/P2/P3) |
| S4 | Every user story has an Independent Test | `Independent Test` field is present and non-empty on each story |
| S5 | Every user story has ≥1 Acceptance Scenario | Given/When/Then format, not a placeholder |
| S6 | Functional requirements use MUST/SHOULD/MAY | Normative language present; no vague verbs ("should maybe", "could") |
| S7 | No `[NEEDS CLARIFICATION]` markers remain unresolved | All markers either resolved or escalated to `sdd.clarify` |
| S8 | No stack/API/code details in spec | No class names, method signatures, framework names, or file paths |
| S9 | Success criteria are measurable | Each SC-XXX includes a numeric threshold or verifiable outcome |
| S10 | `requirements.md` exists and is non-empty | Testable requirements list generated alongside `spec.md` |
| S11 | Guardrail compatibility (if guardrails provided) | No requirement conflicts with a MUST rule in `copilot-instructions.md` |

---

### `plan-gates` — used by `sdd.plan`

Validates that `plan.md` is architecturally complete and traceable to the spec.

| # | Gate | PASS condition |
|---|------|----------------|
| P1 | `arcus-artifact-meta` block present | Block exists immediately after title; `generated-by`, `template`, `arcus-version`, `generated-at` all populated |
| P2 | Required sections present | `plan.md` contains: Summary, Technical Context, Project Structure, Phases, Key Design Decisions |
| P2 | Required sections present | `plan.md` contains: Summary, Technical Context, Project Structure, Phases, Key Design Decisions |
| P3 | Technical Context fully populated | No `NEEDS CLARIFICATION` remaining in Language, Storage, Testing, Target Platform fields |
| P4 | At least one Key Design Decision documented | Each decision includes: option chosen, alternatives considered, rationale |
| P5 | All spec user stories addressed | Each story from `spec.md` is traceable to ≥1 implementation phase |
| P6 | Phases are sequenced with clear dependencies | No circular phase dependencies; blocking phases marked explicitly |
| P7 | Error handling strategy present | At least one error handling approach documented |
| P8 | Observability / testing approach documented | Testing framework and strategy referenced |
| P9 | Project structure matches repo type | Structure section uses correct layout for detected project type (single / web / mobile) |
| P10 | No implementation code in plan | No function bodies, SQL statements, or config file content |
| P11 | Guardrail compatibility (if guardrails provided) | No design decision conflicts with a MUST rule in `copilot-instructions.md` |

---

### `tasks-gates` — used by `sdd.tasks`

Validates that `tasks.md` is complete, dependency-ordered, and fully traceable.

| # | Gate | PASS condition |
|---|------|----------------|
| T1 | `arcus-artifact-meta` block present | Block exists immediately after title; `generated-by`, `template`, `arcus-version`, `generated-at` all populated |
| T2 | Required sections present | `tasks.md` contains: at least one Phase block with tasks |
| T2 | Required sections present | `tasks.md` contains: at least one Phase block with tasks |
| T3 | Every task has a unique deterministic ID | Format `T001`, `T002`… no duplicates, no gaps |
| T4 | Every task references a user story | `[US1]`, `[US2]` label present on every task |
| T5 | Every task includes a file path | Concrete relative path in description (not "create a service somewhere") |
| T6 | Every spec user story has ≥1 task | No user story from `spec.md` maps to zero tasks |
| T7 | Every non-functional requirement has ≥1 task | NFRs (performance, security, observability) are not orphaned |
| T8 | Parallel markers are valid | `[P]` tasks reference different files — no two `[P]` tasks write the same file |
| T9 | Dependency declarations are acyclic | No circular task dependencies (`depends: T005 → T003 → T005`) |
| T10 | Phase ordering is consistent | Tasks in Phase N do not depend on tasks in Phase N+1 |
| T11 | Guardrail compatibility (if guardrails provided) | No task contradicts a MUST rule in `copilot-instructions.md` |

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
