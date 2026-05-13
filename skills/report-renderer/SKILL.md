---
name: report-renderer
description: Render concise, deterministic stage completion reports for chat output.
metadata: 
  inputs:
    - stage_name
    - output_paths
    - status
    - warnings
  outputs:
    - chat_report
---

# Report Renderer

## Purpose

Standardize completion summaries across workflows so users get consistent, low-noise status outputs.

## Inputs

- `stage_name`: current workflow stage
- `output_paths`: generated/updated artifact paths
- `status`: pass/fail and readiness information
- `warnings`: optional deferred risks or unresolved items

## Processing Rules

**For analyze stage**: Include severity breakdown of findings (one summary per severity level).
  - Format: "✓ Analysis: N issues (M CRITICAL, X MEDIUM, Y LOW) | Ready to [proceed / remediate]"
  - List each CRITICAL finding inline
  - Group MEDIUM/LOW findings: "2 MEDIUM issues found (see tasks.md for details)"

**For all other stages**: Use ultra-concise one-liner.
  - Format: "✓ <stage-action>: <key-metric> | Ready for /<next-stage>"
  - Examples:
    - Specify: "✓ Spec generated: 5 stories, 12 requirements | Ready for clarification"
    - Plan: "✓ Design approved: 4 components, 7 decisions | Ready for task breakdown"
    - Implement: "✓ 23/23 tasks done | Ready to review or archive"

1. Preserve deterministic ordering for reproducible outputs.
2. Keep wording concise and action-oriented.
3. Always include the next recommended action.

## Output Contract

- Must return:
  - **For analyze**: 4-6 lines max (severity counts + CRITICAL issues + next action)
  - **For all other stages**: 1-2 lines max (stage result + next action)
  - Markdown formatted, suitable for chat
- Must not return:
  - extra files, long narratives, redundant blocks, or summary artifacts
  - implementation code, detailed logs, or full artifact listings
  - multi-line progress bars or phase breakdowns (those belong in progress-tracker)

## Validation Gates

- [ ] Includes stage status and next-step readiness
- [ ] Includes updated output paths
- [ ] Includes unresolved warnings when present
- [ ] No redundant explanatory text

## Failure Modes

- `MISSING_STATUS`: stop and request status payload
- `MISSING_OUTPUT_PATHS`: render with explicit "no artifact updates" note
- `INCONSISTENT_INPUTS`: flag and request corrected reporting payload

