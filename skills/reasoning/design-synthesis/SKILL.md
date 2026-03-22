```skill
name: design-synthesis
description: Decompose requirements into comprehensive design/architecture with decisions and trade-offs.
inputs:
  - requirements_context
  - constraints
  - guardrails
outputs:
  - design_sections
  - design_decisions
```

# Design Synthesis

## Purpose

Transform requirements into actionable design organized by concern (architecture, data, flow, error handling, etc.). Decoupled from specific phase; used by planning, implementation design, and analysis stages.

## Inputs

- `requirements_context`: functional/non-functional requirements, user stories, scope
- `constraints`: technical constraints, boundaries, dependencies
- `guardrails`: project-level rules from `.github/copilot-instructions.md`

## Processing Rules

1. Extract key concerns from requirements (scope, actors, data, integrations, quality attributes).
2. Compose design sections: overview, decisions, components, data flow, error handling, observability, rollout, backward compatibility.
3. Document key design trade-offs and rationale for each decision.
4. Validate design against guardrails and constraints.
5. Keep design technology-agnostic (no stack choices at design level).
6. Ensure design satisfies all non-functional requirements.

## Output Contract

- Must return:
  - ordered design sections with complete coverage
  - explicit design decisions with rationale and trade-offs
  - identification of open design questions (if any)
- Must not return:
  - implementation code or stack choices
  - contradictions with requirements

## Validation Gates

- [ ] All design sections populated
- [ ] Each decision has explicit rationale
- [ ] No implementation details
- [ ] Design consistent with requirements
- [ ] Trade-offs documented

## Failure Modes

- `MISSING_REQUIREMENTS`: stop and request approved requirements
- `CONFLICTING_DESIGN`: stop and identify contradiction with requirements
- `INCOMPLETE_DESIGN`: stop and report missing required section

