---
name: artifact-modeling
description: Builds normalized, queryable semantic models of specification artifacts (spec, plan, tasks) for coverage analysis, consistency checking, and cross-artifact traceability. Use when analyzing artifact relationships, checking requirement coverage, performing cross-artifact reasoning, or when asked to "model artifacts", "build traceability mappings", or "extract entities from the spec".
metadata:
  version: "1.0.0"
  type:
    - agents
---

# Artifact Modeling

## Purpose

Create normalized, queryable semantic models of any artifacts (spec, plan, tasks) for analysis without modifying files. Used by coverage analysis, consistency checking, and cross-artifact reasoning.

## Inputs

- `artifacts`: content from one or more artifacts (spec.md, plan.md, tasks.md, etc.)
- `artifact_types`: what artifact types are being modeled (spec, plan, tasks, etc.)

## Instructions

### Step 1: Extract Entities
Extract entities from each artifact based on its type:
- From spec: requirements (with keys/slugs), user stories, acceptance criteria
- From plan: design decisions, components, data flows
- From tasks: work items, IDs, dependencies, phases

### Step 2: Assign Stable Identifiers
Assign stable, unique identifiers to each entity for consistent cross-reference across artifacts.

### Step 3: Build Traceability Mappings
Build invertible mappings linking entities across artifact types (requirement ↔ story ↔ task).

### Step 4: Create Queryable Indices
Create queryable indices for downstream coverage and gap analysis.

### Step 5: Validate Models
Validate extracted models for consistency, completeness, and absence of circular references.

## Output Contract

Returns:
- Semantic models per artifact type
- Traceability mappings (requirement ↔ story ↔ task)
- Entity inventories with stable IDs and keys

Does not return:
- Modified artifacts
- Implementation analysis

## Validation Gates

- [ ] All artifacts parsed successfully
- [ ] Entities have stable identifiers
- [ ] Mappings are consistent and invertible
- [ ] No circular references
- [ ] Models are complete for their artifact types

## Troubleshooting

**`PARSE_ERROR`**: Stop and report the unparseable artifact.  
**`INVALID_STRUCTURE`**: Stop and report the structural issue.  
**`ENTITY_COLLISION`**: Report duplicate or conflicting entities.

