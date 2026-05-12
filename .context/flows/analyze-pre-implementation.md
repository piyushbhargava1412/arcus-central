# Flow: Analyze (Pre-Implementation)

**Agent**: `sdd.analyze`  
**Purpose**: Run a non-destructive, cross-artifact quality and readiness analysis before implementation.  

In-scope:
- Assess requirement→task traceability, dependency completeness, test strategy, and technical readiness.  
- Produce a severity-classified analysis report; do NOT modify source artifacts.

Inputs:
- `spec.md`, `plan.md`, `tasks.md`, `.context/` artifacts

Outputs:
- Analysis report (CRITICAL/HIGH/MEDIUM/LOW findings)

Primary skills used:
- `coverage-analysis`
- `dependency-analysis`
- `report-renderer`
- `quality-gates`

Entry criteria: `tasks.md` present; team intends to proceed to implementation.  
Exit criteria: Analysis report issued and blockers addressed.

