# Flow: Tasks

**Agent**: `sdd.tasks`  
**Purpose**: Produce a dependency-ordered, acceptance-criteria-bearing task breakdown from the implementation plan.  

In-scope:
- Decompose plan into phases, stories, and granular tasks with IDs and file paths.  
- Compute dependencies and parallelization opportunities.

Inputs:
- `plan.md`  
- `spec.md`  
- `.context/` artifacts

Outputs:
- `tasks.md` (dependency-ordered) stored under `.arcus/specs/<ID>/tasks.md`

Primary skills used:
- `work-decomposition`
- `dependency-analysis`
- `quality-gates`
- `format-enforcer`

Entry criteria: `plan.md` exists and has measurable milestones.  
Exit criteria: `tasks.md` created with traceability to spec and plan.

