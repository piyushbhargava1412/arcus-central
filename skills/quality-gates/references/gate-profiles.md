# Gate Profiles

Gate profile specifications for the `quality-gates` skill. Each profile defines a set of deterministic pass/fail checks for a specific SDD artifact type.

---

## `spec-gates` — Validate Specification Artifacts

Validates that `spec.md` and `requirements.md` are complete, testable, and technology-agnostic.

| # | Gate | PASS condition |
|---|------|----------------|
| S1 | `arcus-artifact-meta` block present | Block exists immediately after title; `generated-by`, `template`, `arcus-version`, `generated-at` all populated |
| S2 | Required sections present | `spec.md` contains: User Scenarios, Requirements, Success Criteria |
| S3 | At least one user story | Minimum 1 user story with priority assigned (P1/P2/P3) |
| S4 | Every user story has an Independent Test | `Independent Test` field is present and non-empty on each story |
| S5 | Every user story has ≥1 Acceptance Scenario | Given/When/Then format, not a placeholder |
| S6 | Functional requirements use MUST/SHOULD/MAY | Normative language present; no vague verbs ("should maybe", "could") |
| S7 | No `[NEEDS CLARIFICATION]` markers remain unresolved | All markers either resolved or flagged for follow-up |
| S8 | No stack/API/code details in spec | No class names, method signatures, framework names, or file paths |
| S9 | Success criteria are measurable | Each SC-XXX includes a numeric threshold or verifiable outcome |
| S10 | `requirements.md` exists and is non-empty | Testable requirements list generated alongside `spec.md` |
| S11 | Guardrail compatibility (if guardrails provided) | No requirement conflicts with a MUST rule in `copilot-instructions.md` |

---

## `plan-gates` — Validate Design Artifacts

Validates that `plan.md` is architecturally complete and traceable to the spec.

| # | Gate | PASS condition |
|---|------|----------------|
| P1 | `arcus-artifact-meta` block present | Block exists immediately after title; `generated-by`, `template`, `arcus-version`, `generated-at` all populated |
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

## `tasks-gates` — Validate Task Breakdown Artifacts

Validates that `tasks.md` is complete, dependency-ordered, and fully traceable.

| # | Gate | PASS condition |
|---|------|----------------|
| T1 | `arcus-artifact-meta` block present | Block exists immediately after title; `generated-by`, `template`, `arcus-version`, `generated-at` all populated |
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
