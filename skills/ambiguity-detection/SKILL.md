---
name: ambiguity-detection
description: Identify and prioritize unresolved requirement ambiguities and produce a bounded clarification queue.
metadata:
  inputs:
    - spec_draft
    - assumptions
    - guardrails (optional)
  outputs:
    - clarification_markers
    - clarification_questions
---

# Ambiguity Detection

## Purpose

Detect high-impact uncertainty in requirements that would cause scope or UX drift and convert it into a concise clarification backlog. Primarily used by clarify stage.

## Inputs

- `spec_draft`: current specification content
- `assumptions`: explicit defaults captured during authoring
- `guardrails` (optional): project rules from `.github/copilot-instructions.md`

## Processing Rules

1. Scan for vague, conflicting, or underspecified statements.
2. Prioritize by impact: scope > security/privacy > user experience > technical detail.
3. Keep only high-impact items that cannot be resolved via reasonable defaults.
4. Cap unresolved markers at 3 total.
5. Convert markers into actionable clarification questions.
6. If guardrails provided, ensure markers/questions don't conflict with mandatory rules.

## Output Contract

- Must return:
  - up to 3 `[NEEDS CLARIFICATION: ...]` markers
  - prioritized clarification question list
- Must not return:
  - low-impact stylistic questions

## Validation Gates

- [ ] Marker count <= 3
- [ ] Each marker is specific and decision-oriented
- [ ] Questions materially affect scope or acceptance
- [ ] Defaults applied where reasonable
- [ ] Output compatible with provided guardrails (when present)

## Failure Modes

- `NO_ACTIONABLE_AMBIGUITY`: return empty clarification queue
- `OVERFLOW_AMBIGUITY`: auto-resolve lower-impact items with assumptions
- `CONFLICTING_MARKERS`: merge or rewrite overlapping markers

