```skill
name: task-execution-controller
description: Execute tasks in phase order while respecting dependencies, applying execution policy, and persisting progress atomically.
inputs:
  - tasks_list
  - dependency_graph
  - execution_policy
  - context_pack (optional)
outputs:
  - completed_tasks
  - execution_log
  - errors
```

# Task Execution Controller

## Purpose

Safely orchestrate task execution following dependency order, handling failures gracefully, and marking completion. Translates each task in `tasks.md` into concrete LLM actions (file creation, code writing, file editing) and persists progress atomically after each task. Stage-specific to `sdd.implement`.

## Inputs

- `tasks_list`: approved tasks from `tasks.md` produced by `/sdd.tasks`
- `dependency_graph`: computed dependencies and phases from `reasoning/dependency-analysis`
- `execution_policy`: phase-by-phase, respect dependencies, mark completed
- `context_pack` (optional): story-scoped context from `context-pack.md` — used to constrain file scope and validate task targets

---

## Execution Model

This skill executes inside an LLM-driven coding agent. Every task translates into one or more of the following **concrete actions**:

### Action Types

| Action | When to use | How to apply |
|--------|-------------|--------------|
| **CREATE FILE** | Task targets a file path that does not yet exist | Write the complete file content in one pass. Prefer complete files over stubs. |
| **EDIT FILE** | Task targets an existing file (add a function, update a class, extend config) | Read the current file first, apply a targeted edit — never rewrite the entire file unless the task explicitly requires it |
| **CREATE DIRECTORY** | Task requires a new directory structure | Create the directory and any required `__init__.py`, `index.ts`, or equivalent entry file for the language |
| **RUN COMMAND** | Task requires shell execution (migrations, codegen, dependency install) | Emit the exact command as a shell code block; do not execute silently |

### File Ownership Rule

Each file has exactly one **owner task** — the task responsible for creating or defining its primary content. Subsequent tasks that modify the same file are **editors**, not owners.

- Owner task: writes the full initial file
- Editor task: reads the current file state, applies a targeted change only
- Two tasks MUST NOT be marked `[P]` (parallel) if they write to the same file — this is enforced by `reasoning/dependency-analysis` upstream but verified here before execution

### What "Complete" Means Per Task Type

| Task type | Completion signal |
|-----------|------------------|
| Create file | File exists at the declared path with non-empty, syntactically valid content |
| Edit file | Target section/function/class is updated; rest of file is unchanged |
| Create directory | Directory exists; entry file present if required by language conventions |
| Run command | Command emitted and confirmed runnable; output noted in execution log |
| Write test | Test file exists; test function names match acceptance criteria in spec |

---

## Processing Rules

### Rule 1 — Phase Execution Order

Execute phases in this strict sequence — never skip or reorder:

1. **Setup** — project structure, config files, dependency manifests
2. **Foundational** — base models, shared infrastructure, database schema, auth framework
3. **User Story phases** (US1 → US2 → US3…) — in priority order (P1 first)
4. **Polish** — error handling, logging, observability, code cleanup

Do not begin a phase until all non-parallel tasks in the preceding phase are marked `[X]`.

### Rule 2 — Within-Phase Execution

Within a phase:

- Execute sequential tasks strictly in task ID order
- Execute `[P]`-marked tasks as a batch — but verify file ownership before starting the batch:
  - If two `[P]` tasks write to the same file → demote to sequential, log a warning
  - If `[P]` tasks write to different files → execute as a batch, report each result individually
- After each task (sequential or parallel batch), persist `tasks.md` before moving to the next

### Rule 3 — Atomic Persistence

After every completed task:

1. Mark `- [ ] TXXX` → `- [X] TXXX` in `tasks.md`
2. Write `tasks.md` to disk immediately
3. Only then proceed to the next task

Never batch multiple task completions before writing. If execution is interrupted, `tasks.md` reflects the exact last confirmed state.

### Rule 4 — Task Interpretation

Before executing a task, parse it to extract:

- **Task ID**: `T001`, `T002`… — used for logging and marking
- **Phase label**: `[Setup]`, `[US1]`… — for phase gate enforcement
- **Parallel marker**: `[P]` present or absent
- **File path**: the concrete relative path in the description — this is the execution target
- **Action type**: infer from description verb (Create/Add/Implement/Extend/Configure/Run)

If a task description is ambiguous about the target file path, do not guess — stop and report `AMBIGUOUS_TASK_TARGET` with the task ID.

### Rule 5 — Code Generation Standards

When writing code as part of a task:

- Follow the language and framework conventions declared in `plan.md` Technical Context
- Follow any coding standards in `.github/copilot-instructions.md` or `instructions/` files
- Write complete, runnable code — not pseudocode, not stubs with `TODO` comments, not placeholder implementations
- If a task requires external dependencies not yet in the dependency manifest, add them and note the addition in the execution log
- Tests are first-class tasks — if a task is a test task, write real tests with real assertions, not `assert True`

### Rule 6 — Failure Handling

On task failure:

- **Sequential task fails**: stop the current phase immediately. Record the failure in the execution log with: task ID, file path, error description, last attempted action. Do not mark the task `[X]`. Report to the agent with recommended next steps.
- **Parallel task fails**: do not stop the batch. Complete remaining `[P]` tasks in the batch. After the batch, report all failures together. Do not mark failed tasks `[X]`.
- **Partial file write**: if a file was partially written before failure, note it explicitly in the error log — do not leave a corrupt file silently

### Rule 7 — Scope Enforcement

If `context_pack` is provided:

- Cross-check each task's target file path against the `Likely files / areas` section of `context_pack.md`
- If a task writes to a file outside the declared story scope, log a `SCOPE_DEVIATION` warning — do not block execution, but surface it in the final report
- Never modify files listed under `.arcus-ignore` patterns
- Never modify framework files under `.github/agents/`, `.github/prompts/`, `.github/skills/`, `.arcus/`

---

## Output Contract

- Must return:
  - updated `tasks.md` with `[X]` marks on completed tasks (persisted atomically)
  - execution log with: task ID, action type, file path, status, timestamp for each task
  - error list with task ID and failure description for each failed task
- Must not return:
  - design recommendations or architecture changes
  - speculative code not tied to a specific task
  - modifications to framework artifacts (`.arcus/`, `.github/agents/`, `.github/skills/`)

---

## Validation Gates

- [ ] Tasks executed strictly in phase order
- [ ] Parallel tasks verified to have non-overlapping file ownership before batch execution
- [ ] Every completed task marked `[X]` and persisted before next task begins
- [ ] No task executed outside declared story scope without a logged `SCOPE_DEVIATION`
- [ ] Execution log entries present for every attempted task (pass or fail)

---

## Failure Modes

- `TASK_EXECUTION_FAILED`: record error and file path, continue parallel tasks or stop phase per Rule 6
- `DEPENDENCY_VIOLATION`: stop and report unmet dependency — do not execute out-of-order
- `TASKS_FILE_CORRUPTED`: stop and ask user to re-run `/sdd.tasks`
- `AMBIGUOUS_TASK_TARGET`: stop and report task ID — task description does not contain a resolvable file path
- `SCOPE_DEVIATION`: log warning and continue — task targets a file outside declared story scope
- `FILE_OWNERSHIP_CONFLICT`: two `[P]` tasks write the same file — demote to sequential and log
