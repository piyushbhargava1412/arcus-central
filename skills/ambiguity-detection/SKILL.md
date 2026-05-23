---
name: ambiguity-detection
description: Identifies and prioritizes unresolved requirement ambiguities in a specification draft and produces a bounded clarification queue. Use when analyzing a spec for gaps, detecting vague or conflicting requirements, or when asked to "identify ambiguities", "clarify requirements", "find gaps in the spec", or "review requirements for clarity".
metadata:
  version: "1.0.0"
  type:
    - agents
---

# Ambiguity Detection

## Purpose

Detect high-impact uncertainty in requirements that would cause scope or UX drift and convert it into a concise clarification backlog.

## Inputs

- `spec_draft`: current specification content
- `assumptions`: explicit defaults captured during authoring
- `guardrails` (optional): project rules from `.github/copilot-instructions.md`

## Instructions

### Step 1: Scan for Ambiguity
Scan `spec_draft` for vague, conflicting, or underspecified statements.

### Step 2: Prioritize by Impact
Rank findings in this order: scope > security/privacy > user experience > technical detail. Keep only high-impact items that cannot be resolved via reasonable defaults.

### Step 3: Cap and Convert
Cap unresolved markers at 3 total. Convert each marker into an actionable clarification question.

### Step 4: Apply Guardrails
If `guardrails` are provided, ensure all markers and questions are compatible with mandatory project rules.

## Output Contract

Returns:
- Up to 3 `[NEEDS CLARIFICATION: ...]` markers
- Prioritized clarification question list

Does not return:
- Low-impact stylistic questions

## Validation Gates

- [ ] Marker count <= 3
- [ ] Each marker is specific and decision-oriented
- [ ] Questions materially affect scope or acceptance
- [ ] Defaults applied where reasonable
- [ ] Output compatible with provided guardrails (when present)

## Troubleshooting

**`NO_ACTIONABLE_AMBIGUITY`**: Return empty clarification queue.  
**`OVERFLOW_AMBIGUITY`**: Auto-resolve lower-impact items with assumptions.  
**`CONFLICTING_MARKERS`**: Merge or rewrite overlapping markers.

