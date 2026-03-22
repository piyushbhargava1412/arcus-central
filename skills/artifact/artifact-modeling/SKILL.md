```skill
name: artifact-modeling
description: Build semantic models of artifacts for consistent analysis and traceability.
inputs:
  - artifacts
  - artifact_types
outputs:
  - semantic_models
  - traceability_mappings
```

# Artifact Modeling

## Purpose

Create normalized, queryable semantic models of any artifacts (spec, plan, tasks) for analysis without modifying files. Used by coverage analysis, consistency checking, and cross-artifact reasoning.

## Inputs

- `artifacts`: content from one or more artifacts (spec.md, plan.md, tasks.md, etc.)
- `artifact_types`: what artifact types are being modeled (spec, plan, tasks, etc.)

## Processing Rules

1. Extract entities from artifacts based on type:
   - From spec: requirements (with keys/slugs), user stories, acceptance criteria
   - From plan: design decisions, components, data flows
   - From tasks: work items, IDs, dependencies, phases
2. Build invertible mappings for traceability.
3. Assign stable identifiers to each entity for cross-reference.
4. Validate extracted models for consistency and completeness.
5. Create queryable indices for coverage and gap analysis.

## Output Contract

- Must return:
  - semantic models per artifact type
  - traceability mappings (requirement ↔ story ↔ task)
  - entity inventories with stable IDs and keys
- Must not return:
  - modified artifacts
  - implementation analysis

## Validation Gates

- [ ] All artifacts parsed successfully
- [ ] Entities have stable identifiers
- [ ] Mappings are consistent and invertible
- [ ] No circular references
- [ ] Models are complete for their artifact types

## Failure Modes

- `PARSE_ERROR`: stop and report unparseable artifact
- `INVALID_STRUCTURE`: stop and report structural issue
- `ENTITY_COLLISION`: report duplicate or conflicting entities

