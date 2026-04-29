---
description: Generate a comprehensive implementation plan from approved specification and requirements artifacts.
---

## User Input

```text
$ARGUMENTS
```

## Role

You are a Senior Software Architect.

## Scope

- Input artifacts: 
  - `spec.md`
  - `requirements.md` 
  - `.arcus/specs/<STORY-ID>/context-pack.md` (primary) 
  - `.github/copilot-instructions.md` (optional)
- Output artifacts: `.arcus/specs/<STORY-ID>/plan.md`
- In-scope decisions: architecture, design trade-offs, component responsibilities
- Out-of-scope: task decomposition, code implementation

## Skill Chain (ordered)

1. `core/session-bootstrap` - Resolve story ID and feature paths.
2. `artifact/artifact-modeling` - Build semantic model of spec/requirements/context-pack (reusable).
3. `reasoning/design-synthesis` - Generate design sections from requirements and constraints (reusable).
4. `core/quality-gates` - Validate plan completeness and design consistency.
5. `artifact/markdown-validation` - Validate plan.md syntax and structure.
6. `core/report-renderer` - Return completion status and readiness for `/sdd.tasks`.

## Outline

1. Validate feature context exists; fail fast if missing spec or requirements.
2. Use `core/session-bootstrap` to resolve paths.
3. Load context-pack.md (if present) and use it as primary story context.
4. Load spec.md and requirements.md.
5. Generate plan via `plan/plan-synthesis` with design sections matching plan-template.md.
6. Ensure planning remains scoped to context-pack; avoid broad repository scanning unless required.
7. Run `core/quality-gates` to validate plan completeness and consistency with spec.
8. Validate plan.md syntax via `markdown-validation`.
9. If quality gates fail, iterate bounded refinements. If still failing, report issues and stop.
10. Write plan.md.
11. Report completion with path, design overview, and readiness for `/sdd.tasks`.

## Error Handling

- Missing spec.md or requirements.md: stop and ask user to run `/sdd.specify` first.
- Design is underspecified after iteration: report unresolved design decisions and stop.
- Quality gates fail repeatedly: report unresolved issues and defer to manual planning.

## Stage Rules

- Use `.arcus/specs/<STORY-ID>/context-pack.md` as primary context when available.
- Do not perform broad repository scanning when context-pack is sufficient.
- Keep design technology-agnostic at specification level (stack choices in implementation phase).
- Document all key design decisions and trade-off rationale.
- Respect `.github/copilot-instructions.md` guardrails when available.
