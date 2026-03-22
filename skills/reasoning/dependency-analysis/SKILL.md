```skill
name: dependency-analysis
description: Analyze work item relationships and compute execution order while identifying parallelizable work.
inputs:
  - work_items
  - dependency_relationships
outputs:
  - dependency_graph
  - execution_phases
  - parallel_opportunities
```

# Dependency Analysis

## Purpose

Analyze work item relationships to determine safe parallel execution and identify blocking dependencies. Used by tasks planning, analysis verification, and implementation sequencing.

## Inputs

- `work_items`: list of work items with dependency notes
- `dependency_relationships`: explicit relationships between work items

## Processing Rules

1. Parse dependency relationships from work item descriptions and metadata.
2. Build a directed acyclic graph (DAG) of work item relationships.
3. Identify work item phases based on dependencies (Setup → Foundational → Features → Polish).
4. Identify which work items can execute in parallel (no shared resource dependencies).
5. Flag critical paths and blocking work items.
6. Suggest parallel execution batches per phase/story.
7. Validate no circular dependencies exist.

## Output Contract

- Must return:
  - work item dependency matrix
  - phase groupings with execution order
  - list of `{ phase, parallelizable_items }` execution bundles
  - critical path identification
- Must not return:
  - circular dependencies (error if found)

## Validation Gates

- [ ] No circular dependencies
- [ ] All work items reachable
- [ ] Parallel items have no blocking dependencies
- [ ] Critical path identified
- [ ] Phases are properly sequenced

## Failure Modes

- `CIRCULAR_DEPENDENCY`: stop and report loop with path
- `AMBIGUOUS_DEPENDENCY`: ask for clarification on item ordering

