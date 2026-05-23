---
name: dependency-analysis
description: Analyzes work item relationships to determine safe execution order, identify parallelizable work, and surface the critical path. Use when planning task sequencing, checking for circular dependencies, grouping work into phases, or when asked to "analyze dependencies", "find the critical path", "identify parallel tasks", or "sequence work items".
metadata:
  version: "1.0.0"
  type:
    - agents
---

# Dependency Analysis

## Purpose

Analyze work item relationships to determine safe parallel execution and identify blocking dependencies. Used by tasks planning, analysis verification, and implementation sequencing.

## Inputs

- `work_items`: list of work items with dependency notes
- `dependency_relationships`: explicit relationships between work items

## Instructions

### Step 1: Parse Dependencies
Parse dependency relationships from work item descriptions and metadata.

### Step 2: Build DAG
Build a directed acyclic graph (DAG) of work item relationships.

### Step 3: Group into Phases
Identify work item phases based on dependency depth (Setup → Foundational → Features → Polish).

### Step 4: Identify Parallelizable Work
Within each phase, identify items with no shared resource dependencies that can execute in parallel.

### Step 5: Flag Critical Path
Trace the longest dependency chain and mark each item on it as blocking.

### Step 6: Validate
Confirm no circular dependencies exist. If found, stop and report immediately.

## Output Contract

Format output using the template in `assets/dependency-report-template.md`. Returns:
- Work item dependency matrix
- Phase groupings with execution order
- Parallel execution bundles per phase
- Critical path identification

Does not return:
- Circular dependencies (error if found)

## Validation Gates

- [ ] No circular dependencies
- [ ] All work items reachable
- [ ] Parallel items have no blocking dependencies
- [ ] Critical path identified
- [ ] Phases are properly sequenced

## Troubleshooting

**`CIRCULAR_DEPENDENCY`**: Stop and report the loop with full path.  
**`AMBIGUOUS_DEPENDENCY`**: Ask for clarification on item ordering before proceeding.

