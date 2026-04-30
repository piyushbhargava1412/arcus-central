---
description: Generate an actionable, dependency-ordered `tasks.md` organized by story and phase.
---

## User Input

```text
$ARGUMENTS
```

## Role

You are an Execution Decomposer.

## Scope

- Input artifacts: 
  - `spec.md`
  - `plan.md`
  - `.arcus/specs/<STORY-ID>/context-pack.md` (primary)
  - `.github/copilot-instructions.md` (optional)
- Output artifacts: `.arcus/specs/<STORY-ID>/tasks.md`
- In-scope decisions: task granularity, phase organization, story alignment
- Out-of-scope: implementation details, code guidance

## Skill Chain (ordered)

1. `core/session-bootstrap` - Resolve story ID and feature paths.
2. `artifact/artifact-modeling` - Build semantic model of spec/requirements (reusable).
3. `reasoning/work-decomposition` - Generate story-phase tasks with deterministic IDs (reusable).
4. `reasoning/dependency-analysis` - Compute task dependencies and parallel opportunities (reusable).
5. `formatting/format-enforcer` - Validate and normalize task format (reusable).
6. `core/quality-gates` - Validate task completeness per user story.
7. `core/report-renderer` - Return completion status and readiness for `/sdd.analyze`.

## Outline

1. Validate feature context; fail fast if missing `spec.md` or `plan.md`.
2. Use `core/session-bootstrap` to resolve story ID and feature paths.
3. Load `context-pack.md` (if present) and use it as primary story context.
4. Load `spec.md` and `plan.md` via `artifact/artifact-modeling`.
5. Generate tasks via `reasoning/work-decomposition` mapped to stories and phases.
6. Compute dependencies via `reasoning/dependency-analysis` and identify parallelizable tasks.
7. Normalize format via `formatting/format-enforcer` using `.arcus/templates/tasks-template.md`.
8. Validate completeness via `core/quality-gates`.
9. If validation fails, iterate bounded refinements; if still failing, report issues and stop.
10. Write `.arcus/specs/<STORY-ID>/tasks.md`.
11. Report completion with: file path, task count, dependency graph summary, and readiness status for `/sdd.analyze`.

## Task Generation Rules

- Use `.arcus/specs/<STORY-ID>/context-pack.md` as primary context when available.
- Do not perform broad repository scanning when context-pack is sufficient.


- Tasks MUST be organized by user story to enable independent implementation and testing.
- Each task line MUST follow the checklist format:
    - Example (CORRECT): `- [ ] T005 [P] Implement authentication middleware in src/middleware/auth.py`
    - Example (INCORRECT): `T001 [US1] Create model` (missing checkbox and file path)
- Deterministic task IDs: use a stable prefix per story and incremental numeric suffixes (e.g., `T001`, `T002`).
- Each task must include:
    - Checkbox (`- [ ]` or `- [x]`)
    - Task ID
    - Story label (e.g., `[US1]`)
    - Short action description
    - Exact file path(s) when applicable
    - Optional labels: `[P]` for priority, `[D]` for dependency note
- Phase organization:
    - Phase 1: Setup tasks (initialization, scaffolding)
    - Phase N: One phase per user story in priority order from `spec.md`
    - Final Phase: Polish & cross-cutting concerns
- Include a Dependencies section listing task IDs and their prerequisites.
- Include an Implementation strategy section (MVP first, incremental delivery).

## Output / Report

- Write `.arcus/specs/<STORY-ID>/tasks.md` and ensure markdown follows the templates.
- In chat/report: display total task count, show a dependency graph summary, and confirm format validation.
- Confirm ALL tasks follow the checklist format (checkbox, ID, labels, file paths).

## Error Handling

- Missing `spec.md` or `plan.md`: stop and instruct user to run `/sdd.plan` first.
- Tasks are underspecified: report which tasks lack required fields and stop.
- Dependency graph has cycles: stop and report the circular dependency details.

## Stage Rules / Examples

- ✅ CORRECT: `- [ ] T014 [US1] Implement UserService in src/services/user_service.py`
- ✅ CORRECT: `- [ ] T005 [P] Implement authentication middleware in src/middleware/auth.py`
- ❌ WRONG: `T001 [US1] Create model` (missing checkbox and path)

## Validation

- After generation run `skills/markdown-validation` to ensure the generated `tasks.md` meets structure and template constraints.
- `core/quality-gates` must mark the tasks as complete before signaling readiness for `/sdd.analyze`.
