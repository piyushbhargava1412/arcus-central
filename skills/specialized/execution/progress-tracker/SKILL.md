```skill
name: progress-tracker
description: Update and render task progress status with completion metrics and next-step guidance.
inputs:
  - tasks_file
  - execution_log
outputs:
  - progress_report
  - completion_metrics
```

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
4. Render a status report showing:
   - Phase completion (Setup: 100%, Foundational: 60%, Story US1: 0%, ...)
   - Overall progress bar (X/Y tasks completed)
   - Next actionable task
   - Failed tasks needing attention

## Output Contract

- Must return:
  - progress report with phase breakdown
  - next actionable task with context
  - health status (on-track, behind, blocked)
- Must not return:
  - implementation code or guidance

## Validation Gates

- [ ] Counts match tasks.md
- [ ] Next task identified correctly
- [ ] Progress percentages accurate
- [ ] Report is concise and scannable

## Failure Modes

- `ALL_TASKS_COMPLETED`: emit completion summary and readiness for wrap-up
- `NO_TASKS_STARTED`: emit "No tasks started; next: [first task]"

