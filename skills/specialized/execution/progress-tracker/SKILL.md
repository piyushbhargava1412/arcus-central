---
name: progress-tracker
description: Update and render task progress status with completion metrics and next-step guidance.
metadata:
  inputs:
    - tasks_file
    - execution_log
  outputs:
    - progress_report
---

# Progress Tracker

## Purpose

Maintain a clear, up-to-date view of implementation progress and guide the next actionable task. Stage-specific to implement.

## Inputs

- `tasks_file`: current tasks.md with completed checkboxes
- `execution_log`: timestamped log of completed/failed tasks

## Processing Rules

1. Count total tasks, completed tasks, failed tasks, pending tasks.
2. Compute completion percentage per phase and overall.
3. Identify the next pending task by phase order.
4. Render a single-line status report:
  - Format: "✓ X/Y (Z%) | Phase: <name> | Next: <task-id> | Status: <health>"
  - Example: "✓ 12/15 (80%) | Phase: Stories [US1] | Next: T008 | Status: on-track"
  - Only list failed tasks if count > 0: "| Failed: 2"

## Output Contract

- Must return:
  - single-line progress report (one-liner, max 120 chars)
  - format exactly: `✓/⚠/✗ X/Y (Z%) | Phase: <name> | Next: <task-id> | Status: <health>` (+ `| Failed: N` if failures exist)
  - health status: `on-track` (normal), `behind` (>50% of phase delayed), `blocked` (critical failures)
- Must not return:
  - implementation code or guidance
  - multi-line reports, phase breakdowns, or progress bars
  - detailed task context (task ID only, no descriptions)

## Validation Gates

- [ ] Counts match tasks.md
- [ ] Next task identified correctly
- [ ] Progress percentages accurate
- [ ] Report is concise and scannable

## Failure Modes

- `ALL_TASKS_COMPLETED`: emit completion summary and readiness for wrap-up
- `NO_TASKS_STARTED`: emit "No tasks started; next: [first task]"

