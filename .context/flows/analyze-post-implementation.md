# Flow: Analyze (Post-Implementation)

**Agent**: `sdd.analyze`  
**Purpose**: Verify implementation completeness against specification, detect context drift, and recommend `.context/` updates if needed.  

In-scope:
- Verify all spec requirements implemented and acceptance criteria met.  
- Evaluate test coverage and integration regressions; detect context drift and flag `.context/` refresh if required.

Inputs:
- Implementation artifacts (code + tests), `spec.md`, `tasks.md`, `.context/` artifacts

Outputs:
- Verification report, suggested `.context/` updates (if drift detected), release readiness assessment

Primary skills used:
- `coverage-analysis`
- `context-sync`
- `report-renderer`  

Entry criteria: Implementation completed for a release or milestone; tests available.  
Exit criteria: Verification report created; `.context/` refreshed if drift detected.

