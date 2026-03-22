```skill
name: quality-gates
description: Apply deterministic quality checks to stage artifacts and return pass/fail results with actionable fixes.
inputs:
  - artifact
  - checklist_template
  - gate_profile
  - guardrails (optional)
outputs:
  - checklist
  - gate_results
  - remediation_items
```

# Quality Gates

## Purpose

Provide reusable, stage-agnostic quality validation with explicit pass/fail outcomes.

## Inputs

- `artifact`: draft stage artifact (for this phase, `spec.md`)
- `checklist_template`: checklist structure to populate
- `gate_profile`: gate set for the current stage
- `guardrails` (optional): project-level constraints from `.github/copilot-instructions.md`

## Processing Rules

1. Load stage gate profile and evaluate each gate.
2. Record pass/fail with concise evidence from artifact content.
3. Generate remediation items for failed gates.
4. Support bounded re-validation loops for updated artifacts.
5. When guardrails are provided, validate artifact compatibility with mandatory rules.

## Output Contract

- Must return:
  - rendered checklist with status updates
  - gate result summary
  - prioritized remediation list
- Must not return:
  - implementation-specific design recommendations

## Validation Gates

- [ ] Mandatory sections complete
- [ ] Language is clear and testable
- [ ] Success criteria are measurable
- [ ] No stack/API/code details in requirements artifacts
- [ ] Mandatory guardrails are satisfied when provided

## Failure Modes

- `GATE_PROFILE_MISSING`: stop and report missing profile/config
- `UNRESOLVED_FAILURES`: return unresolved gate list after max iterations
- `INVALID_CHECKLIST_TEMPLATE`: stop and report template mismatch

