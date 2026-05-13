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

## Execution Steps (follow skill definitions in order)

1. Validate feature context exists; fail fast if missing spec or requirements.
2. Use `session-bootstrap` to resolve paths.
   - If SESSION_CHECKPOINT.md exists with stage=plan: Display to user: "✓ Resuming planning: M design decisions made, N components defined"
   - If no checkpoint: Display: "Starting design planning"
3. Load context-pack.md (if present) and use it as primary story context.
4. Load spec.md and requirements.md.
5. Generate plan via `design-synthesis` with design sections matching plan-template.md.
6. Ensure planning remains scoped to context-pack; avoid broad repository scanning unless required.
7. Run `quality-gates` to validate plan completeness and consistency with spec.
8. Validate plan.md syntax via `markdown-validation`.
9. If quality gates fail, iterate bounded refinements. If still failing, report issues and stop.
10. Write plan.md.
11. Create session checkpoint:
    - Call `checkpoint-manager` with:
      * story_id: <STORY-ID>
      * workflow_name: `sdd`
      * current_stage: `plan`
      * execution_summary: "Design approved with X components and Y key technical decisions"
      * position_snapshot: "Plan drafted and validated with design components, sequencing, and technical decisions captured"
      * progress_items:
        - `Design Components: X`
        - `Key Decisions: Y`
      * resume_hint: "Proceed to task breakdown once design blockers are cleared"
      * checkpoint_metrics:
        - `phase_count: P`
        - `open_design_questions: Q`
      * artifacts_updated:
        - `.arcus/specs/<STORY-ID>/plan.md`
      * blockers: [if any design decisions remain unresolved]
    - Checkpoint is written to `.arcus/specs/<STORY-ID>/SESSION_CHECKPOINT.md`
12. Report completion with path, design overview, and readiness for `/sdd.tasks`.

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
