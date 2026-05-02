# Flow: Plan

**Agent**: `sdd.plan`  
**Purpose**: Generate a phased implementation plan (HOW) from a validated specification.  

In-scope:
- Produce architecture sections, design decisions, phased milestones, and component responsibility mappings.  
- Surface trade-offs and risks.

Inputs:
- `spec.md` (clarified)  
- `.context/repo_map.md` for technical topology

Outputs:
- `plan.md` with phases and milestones

Primary skills used:
- `artifact/artifact-modeling`  
- `reasoning/design-synthesis`  
- `reasoning/dependency-analysis`  
- `core/quality-gates`

Entry criteria: clarified spec and repo_map available.  
Exit criteria: Plan reviewed and passes quality gates.

