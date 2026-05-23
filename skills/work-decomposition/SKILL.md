---
name: work-decomposition
description: Break down requirements and design context into concrete, independently actionable work items organized by phase and priority. Use when an agent needs to generate a task breakdown from a spec, analyse coverage, or plan implementation work.
metadata:
  version: "1.0.0"
  type:
    - agents
---

# Work Decomposition

## Purpose

Decompose abstract requirements/design into concrete, independently actionable work items. Used by tasks generation, analysis (coverage analysis), and implementation planning.

## Inputs

- `requirements`: user stories with priorities from spec
- `design_context`: architecture/plan context (if available)
- `organization_model`: how to group work (by story, by component, by phase)
- `guardrails`: project-level rules

## Processing Rules

1. Extract work-driving elements: user stories, features, components, data entities.
2. Organize by specified model (stories + phases, components, priority).
3. For each work item, define:
   - Unique ID (deterministic, sequential)
   - Clear description
   - Scope (what it owns, what it doesn't)
   - Dependencies (internal and external)
   - Owner/responsible party (if applicable)
4. Mark work items that can execute in parallel.
5. Validate each work item is independently scoped and testable.
6. Ensure all requirements are mapped to at least one work item.

## Output Contract

- Must return:
  - list of work items with IDs, descriptions, scopes, dependencies
  - organization structure (phases, groups, priority)
  - parallelization opportunities
- Must not return:
  - implementation code
  - speculative assumptions

## Validation Gates

- [ ] All requirements mapped to work items
- [ ] Each work item has ID and clear scope
- [ ] Dependencies explicitly stated
- [ ] Work items are independently testable
- [ ] No orphaned requirements

## Failure Modes

- `MISSING_REQUIREMENTS`: stop and request both artifacts
- `UNMAPPED_REQUIREMENTS`: stop and identify orphaned requirements
- `CIRCULAR_DEPENDENCIES`: stop and report dependency loop

