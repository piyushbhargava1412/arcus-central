# Checkpoint Examples

Three annotated examples illustrating checkpoint output across different workflow types.

---

## Example 1: Checklist-Driven Implementation Session

**Scenario**: Mid-implementation batch break; tasks.md available.

```markdown
# Session Checkpoint

**Last Updated**: 2026-05-04T14:30:00Z
**Workflow**: sdd
**Stage**: implement
**Status**: In Progress
**Story**: FEAT-AUTH-001

## Current Position
- Progress: 12/23 tasks (52%)
- Last Completed: T012 (Update error handler)
- Next Focus: T013 (Add retry logic)
- Status: In progress

## Last Interaction Summary
- What: Implemented robust error handling with proper logging, added exponential backoff retry mechanism, updated TypeScript types for error responses.
- Blockers: None
- Next Step: Continue with implementation phase to implement T013

## Key Metrics
- Files Changed: 4
- Tests Passing: 18

## Code State
- Code Committed: No
- Status: Uncommitted changes present

---

arcus-artifact-meta:
  artifact-type: session-checkpoint
  arcus-version: 1.2.0
  generated-at: 2026-05-04T14:30:00Z
  story-id: FEAT-AUTH-001
  workflow: sdd
  stage: implement
```

**Token estimate**: ~250 tokens

---

## Example 2: Discovery Session Without Task File

**Scenario**: Ambiguity review interrupted; no tasks.md; caller-native position bullets used.

```markdown
# Session Checkpoint

**Last Updated**: 2026-05-04T10:15:00Z
**Workflow**: discovery
**Stage**: ambiguity-review
**Status**: In Progress
**Story**: FEAT-PAYMENT-023

## Current Position
- Position: Requirement boundaries reviewed; refund handling still open
- Coverage: 2/5 ambiguity clusters resolved
- Readiness: Awaiting stakeholder input

## Last Interaction Summary
- What: Resolved authentication scope ambiguity (Q1) and clarified payment provider fallback behavior (Q2). Identified 3 remaining open questions about refund handling, currency conversion edge cases, and webhook retry strategy.
- Blockers: Blocked on stakeholder clarification for refund handling requirements
- Next Step: Wait for stakeholder input on refund handling, then continue ambiguity review

## Artifacts Updated
- .arcus/specs/FEAT-PAYMENT-023/spec.md

## Code State
- Code Committed: N/A (specification phase)

---

arcus-artifact-meta:
  artifact-type: session-checkpoint
  arcus-version: 1.2.0
  generated-at: 2026-05-04T10:15:00Z
  story-id: FEAT-PAYMENT-023
  workflow: discovery
  stage: ambiguity-review
```

**Token estimate**: ~280 tokens

---

## Example 3: AFK Autonomous Run

**Scenario**: AFK workflow halted between test-generation and code stages.

```markdown
# Session Checkpoint

**Last Updated**: 2026-05-04T16:45:00Z
**Workflow**: afk
**Stage**: testgen
**Status**: In Progress
**Story**: FEAT-AUTH-001

## Current Position
- Position: Architect output complete; test plan generated; code stage not started
- Decisions: 6 captured
- Coverage: 24 test cases traced to 6 work items
- Readiness: Ready for code execution

## Last Interaction Summary
- What: Completed autonomous architect and test-generation slices. Generated execution log, architect output, and test plan with full traceability.
- Blockers: None
- Next Step: Resume AFK code stage and execute the remaining implementation items

## Key Metrics
- token_consumed_architect: 82000
- token_consumed_test_generation: 41000
- test_case_count: 24

## Artifacts Updated
- .arcus/specs/FEAT-AUTH-001/architect-output.md
- .arcus/specs/FEAT-AUTH-001/test-plan.md
- .arcus/specs/FEAT-AUTH-001/EXECUTION_LOG.md

## Code State
- Code Committed: No
- Status: Ready to continue

---

arcus-artifact-meta:
  artifact-type: session-checkpoint
  arcus-version: 1.2.0
  generated-at: 2026-05-04T16:45:00Z
  story-id: FEAT-AUTH-001
  workflow: afk
  stage: testgen
```

**Token estimate**: ~270 tokens
