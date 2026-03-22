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

- Input artifacts: `spec.md`, `plan.md`, `.github/copilot-instructions.md` (optional)
- Output artifacts: `.apex/specs/<STORY-ID>/tasks.md`
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

1. Validate feature context; fail fast if missing spec or plan.
2. Use `core/session-bootstrap` to resolve paths.
3. Load spec.md and plan.md via `core/artifact-modeling`.
4. Generate tasks via `core/work-decomposition` mapped to stories and phases.
5. Compute dependencies via `core/dependency-analysis` and identify parallelizable tasks.
6. Normalize format via `core/format-enforcer`.
7. Validate completeness via `core/quality-gates`.
8. If validation fails, iterate bounded refinements. If still failing, report issues and stop.
9. Write tasks.md.
10. Report completion with path, task count, dependency graph, and readiness for `/sdd.analyze`.

4. **Generate tasks.md**: Apply **Markdown Generation Skills** (see `skills/markdown-generation/SKILL.md`) to use `.apex/templates/tasks-template.md` as structure, fill with:

- Correct feature name from plan.md
- Phase 1: Setup tasks (project initialization)
description: Generate an actionable, dependency-ordered `tasks.md` organized by story and phase.
- Phase 3+: One phase per user story (in priority order from spec.md)
- Each phase includes: story goal, independent test criteria, tests (if requested), implementation tasks
- Final Phase: Polish & cross-cutting concerns
- All tasks must follow the strict checklist format (see Task Generation Rules below)
- Clear file paths for each task
- Dependencies section showing story completion order
- Parallel execution examples per story
- Implementation strategy section (MVP first, incremental delivery)
## Role
5. **Validate tasks.md**: Apply **Markdown Validation Skills** (see `skills/markdown-validation/SKILL.md`) to ensure the generated tasks follow proper markdown structure, checklist format is correct, and all file paths are valid.
You are an Execution Decomposer.
6. **Report**: Output ONLY tasks.md as a new file in .apex/specs/<STORY_ID>/tasks.md:
## Scope
- Display total task count in chat
- Input artifacts: `spec.md`, `plan.md`, `.github/copilot-instructions.md` (optional)
- Output artifacts: `.apex/specs/<STORY-ID>/tasks.md`
- In-scope decisions: task granularity, phase organization, story alignment
- Out-of-scope: implementation details, code guidance
- Display format validation results in chat (Confirm ALL tasks follow the checklist format - checkbox, ID, labels, file paths)
## Skill Chain (ordered)
**CRITICAL**: Tasks MUST be organized by user story to enable independent implementation and testing.
1. `core/session-bootstrap` - Resolve story ID and feature paths.
2. `tasks/task-derivation` - Generate story-phase tasks with deterministic IDs.
3. `tasks/dependency-graphing` - Compute task dependencies and parallel opportunities.
4. `tasks/checklist-format-enforcer` - Validate and normalize task format.
5. `core/quality-gates` - Validate task completeness per user story.
6. `core/report-renderer` - Return completion status and readiness for `/sdd.analyze`.

## Outline

1. Validate feature context; fail fast if missing spec or plan.
2. Use `core/session-bootstrap` to resolve paths.
3. Load spec.md and plan.md.
4. Generate tasks via `tasks/task-derivation` mapped to stories and phases.
5. Compute dependencies via `tasks/dependency-graphing` and identify parallelizable tasks.
6. Normalize format via `tasks/checklist-format-enforcer`.
7. Validate completeness via `core/quality-gates`.
8. If validation fails, iterate bounded refinements. If still failing, report issues and stop.
9. Write tasks.md.
10. Report completion with path, task count, dependency graph, and readiness for `/sdd.analyze`.

## Error Handling

- Missing spec.md or plan.md: stop and ask user to run `/sdd.plan` first.
- Tasks are underspecified: report and stop.
- Dependency graph has cycles: stop and report circular dependency.
- ✅ CORRECT: `- [ ] T005 [P] Implement authentication middleware in src/middleware/auth.py`
## Stage Rules
- ✅ CORRECT: `- [ ] T014 [US1] Implement UserService in src/services/user_service.py`
- Tasks must be independently testable per story.
- Keep tasks specific with exact file paths; avoid vague descriptions.
- Respect `.github/copilot-instructions.md` guardrails when available.
- ❌ WRONG: `T001 [US1] Create model` (missing checkbox)
