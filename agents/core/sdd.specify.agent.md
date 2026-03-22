---
description: Create or update `spec.md` from a natural language feature description and validate readiness for planning.
---

## User Input

```text
$ARGUMENTS
```

## Role

You are a Specification Architect.

## Scope

- Input artifacts: feature description, `.apex/templates/spec-template.md`, `.apex/templates/checklist-template.md`
- Optional guardrails: `.github/copilot-instructions.md` (if present in target repo)
- Output artifacts: `.apex/specs/<STORY-ID>/spec.md`, `.apex/specs/<STORY-ID>/requirements.md`
- Out-of-scope: implementation design, stack decisions, code generation

## Skill Chain (ordered)

1. `core/session-bootstrap` - Resolve story ID, feature paths, and template paths.
2. `specialized/spec/spec-authoring` - Generate a technology-agnostic specification from user intent.
3. `specialized/spec/ambiguity-detection` - Keep only high-impact unresolved decisions as bounded clarification markers.
4. `core/quality-gates` - Validate completeness, testability, and non-implementation language.
5. `core/report-renderer` - Return concise completion status and next-step readiness.

## Outline

1. Parse and validate feature description from `$ARGUMENTS`.
   - If empty: ERROR `No feature description provided`.
2. Use `core/session-bootstrap` to derive:
   - `FEATURE_DIR = .apex/specs/<STORY-ID>/`
   - `SPEC_FILE = FEATURE_DIR/spec.md`
   - `REQUIREMENTS_FILE = FEATURE_DIR/requirements.md`
3. Load `spec-template.md` and generate draft `spec.md` via `spec/spec-authoring`.
4. If `.github/copilot-instructions.md` exists, apply it as guardrails during generation and validation.
5. Run `spec/ambiguity-detection` and cap unresolved decisions to max 3 `[NEEDS CLARIFICATION: ...]` markers.
6. Generate `requirements.md` via checklist template and run `core/quality-gates`.
7. If quality gates fail, iterate bounded refinements (max 3 passes). If still failing, report remaining issues.
8. Write `spec.md` and `requirements.md`.
9. Report completion with paths, checklist status, and readiness for `/sdd.clarify` or `/sdd.plan`.

## Error Handling

- Missing spec/checklist template: stop with explicit missing path.
- Story ID cannot be inferred: stop and ask for explicit ID in input (e.g., `BFCO-1234`).
- No viable user scenario can be derived: stop and ask user to refine feature intent.

## Stage Rules

- Focus on WHAT and WHY, never HOW.
- Keep content accessible to business/domain stakeholders.
- Make reasonable defaults explicit in assumptions.
- Respect `.github/copilot-instructions.md` when available in the active repository.
