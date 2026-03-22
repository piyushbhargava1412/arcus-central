```skill
name: report-renderer
description: Render concise, deterministic stage completion reports for chat output.
inputs:
  - stage_name
  - output_paths
  - status
  - warnings
outputs:
  - chat_report
```

# Report Renderer

## Purpose

Standardize completion summaries across agents so users get consistent, low-noise status outputs.

## Inputs

- `stage_name`: current workflow stage
- `output_paths`: generated/updated artifact paths
- `status`: pass/fail and readiness information
- `warnings`: optional deferred risks or unresolved items

## Processing Rules

1. Render a compact status summary with critical details first.
2. Include only stage-relevant artifact paths and readiness guidance.
3. Preserve deterministic ordering for reproducible outputs.
4. Keep wording concise and action-oriented.

## Output Contract

- Must return:
  - one concise markdown report suitable for chat
- Must not return:
  - extra files, long narratives, or duplicate status blocks

## Validation Gates

- [ ] Includes stage status and next-step readiness
- [ ] Includes updated output paths
- [ ] Includes unresolved warnings when present
- [ ] No redundant explanatory text

## Failure Modes

- `MISSING_STATUS`: stop and request status payload
- `MISSING_OUTPUT_PATHS`: render with explicit "no artifact updates" note
- `INCONSISTENT_INPUTS`: flag and request corrected reporting payload

