```skill
name: task-execution-controller
description: Execute tasks in phase order while respecting dependencies and applying execution policy.
inputs:
  - tasks_list
  - dependency_graph
  - execution_policy
outputs:
  - completed_tasks
  - execution_log
  - errors
```

# Task Execution Controller

## Purpose

Safely orchestrate task execution following dependency order, handling failures gracefully, and marking completion. Stage-specific to implement.

## Inputs

- `tasks_list`: approved tasks from `/sdd.tasks`
- `dependency_graph`: computed dependencies and phases
- `execution_policy`: phase-by-phase, respect dependencies, mark completed

## Processing Rules

1. Execute tasks phase-by-phase (Setup → Foundational → User Stories → Polish).
2. Within a phase, execute sequential tasks in order; execute parallelizable `[P]` tasks together.
3. For each completed task, mark `- [ ]` → `- [X]` in tasks.md.
4. On task failure:
   - Stop phase if non-parallelizable task fails
   - Continue parallel tasks if one `[P]` fails; report failure
5. Log progress after each task: task ID, status, time, errors.
6. Report final status: completed count, failed count, next task to resume.

## Output Contract

- Must return:
  - updated tasks.md with `[X]` marks
  - execution log with timestamps
  - error list (if any)
- Must not return:
  - code or implementation details
  - recommendations for fixing errors

## Validation Gates

- [ ] Tasks executed in phase order
- [ ] Dependencies respected
- [ ] Completed tasks marked
- [ ] Log is deterministic and reproducible

## Failure Modes

- `TASK_EXECUTION_FAILED`: record error, continue parallel tasks or stop phase
- `DEPENDENCY_VIOLATION`: stop and report unmet dependency
- `TASKS_FILE_CORRUPTED`: stop and ask to re-run `/sdd.tasks`

