# Flow: Implement

**Agent**: `sdd.implement`  
**Purpose**: Guide phased execution of tasks and track progress while enforcing readiness and quality gates.  

In-scope:
- Validate readiness, execute phases respecting dependencies, and track progress with completion metrics.  
- Coordinate with task execution controller skill where applicable.

Inputs:
- `tasks.md`, `plan.md`, `spec.md`, `.context/` artifacts

Outputs:
- Implementation progress artifacts (task status updates, reports) and source artifacts in target repository

Primary skills used:
- `specialized/execution/task-execution-controller`  
- `reasoning/work-decomposition`  
- `reasoning/dependency-analysis`  
- `core/report-renderer`

Entry criteria: Pre-implementation analysis passed and execution environment ready.  
Exit criteria: Phases completed and tasks marked done; readiness for post-implementation analysis.

