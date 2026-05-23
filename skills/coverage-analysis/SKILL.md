---
name: coverage-analysis
description: Computes traceability coverage between artifact levels (requirements, work items, tasks) and identifies gaps, overlaps, and coverage metrics. Use when checking requirement coverage, analyzing task-to-story traceability, tracking implementation completeness, or when asked to "check coverage", "find gaps in the plan", "analyze traceability", or "identify unmapped requirements".
metadata:
  version: "1.0.0"
  type:
    - agents
---

# Coverage Analysis

## Purpose

Compute coverage between any two artifact levels (requirements ↔ work items, work items ↔ completion). Used by task analysis, full-flow consistency analysis, and implementation progress tracking.

## Inputs

- `artifacts_models`: semantic models (from work-decomposition or external artifact modeling)
- `severity_profile`: which gaps are CRITICAL vs HIGH vs MEDIUM vs LOW

## Instructions

### Step 1: Map Top-Level to Lower-Level Items
For each top-level item (requirement/story), count assigned lower-level items (work items/tasks).

### Step 2: Verify Reverse Mapping
For each lower-level item, verify it maps to at least one top-level item.

### Step 3: Identify Gaps and Overmapping
Collect unmapped top-level items (gaps) and unmapped lower-level items (overmapping).

### Step 4: Score Gaps by Severity
Apply `severity_profile` to rank each gap: scope > security/privacy > UX > technical.

### Step 5: Compute Metrics
Calculate coverage percentage, gap count, and critical issue count.

### Step 6: Identify Overlaps
Flag items where multiple lower-level items serve a single upper-level item and note consolidation candidates.

## Output Contract

Format output using the template in `assets/coverage-report-template.md`. Returns:
- Coverage matrix: top-level ↔ lower-level counts
- Gap list: `{ item, severity, reason }`
- Overlap list: redundantly mapped items
- Metrics: total coverage %, gap count, critical issue count

Does not return:
- Design recommendations for fixing gaps

## Validation Gates

- [ ] All gaps identified
- [ ] All overlaps identified
- [ ] Severity scores assigned
- [ ] Metrics consistent

## Troubleshooting

**`UNMAPPED_TOP_ITEM`**: Report the item with zero lower-level coverage.  
**`UNMAPPED_LOWER_ITEM`**: Report the item with zero mapped parent.

