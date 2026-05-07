---
name: coverage-analysis
description: Analyze traceability between work items and requirements; identify gaps, overlaps, and coverage metrics.
metadata:
  inputs:
    - artifacts_models
    - severity_profile
  outputs:
    - coverage_matrix
    - gap_list
    - overlap_list
    - metrics
---

# Coverage Analysis

## Purpose

Compute coverage between any two artifact levels (requirements ↔ work items, work items ↔ completion). Used by task analysis, full-flow consistency analysis, and implementation progress tracking.

## Inputs

- `artifacts_models`: semantic models (from work-decomposition or external artifact modeling)
- `severity_profile`: which gaps are CRITICAL vs HIGH vs MEDIUM vs LOW

## Processing Rules

1. For each top-level item (requirement/story), count assigned lower-level items (work items/tasks).
2. For each lower-level item, verify it maps to at least one top-level item.
3. Identify unmapped top-level items (gaps) and unmapped lower-level items (overmapping).
4. Score each gap by severity: scope > security/privacy > UX > technical.
5. Compute coverage percentage and overall metrics.
6. Identify overlaps (multiple lower items serving one upper item) and potential consolidation.

## Output Contract

- Must return:
  - coverage matrix: top-level ↔ lower-level counts
  - gap list: `{ item, severity, reason }`
  - overlap list: redundantly mapped items
  - metrics: total coverage %, gap count, critical issue count
- Must not return:
  - design recommendations for fixing gaps

## Validation Gates

- [ ] All gaps identified
- [ ] All overlaps identified
- [ ] Severity scores assigned
- [ ] Metrics consistent

## Failure Modes

- `UNMAPPED_TOP_ITEM`: report item with zero lower-level coverage
- `UNMAPPED_LOWER_ITEM`: report item with zero mapped parent

