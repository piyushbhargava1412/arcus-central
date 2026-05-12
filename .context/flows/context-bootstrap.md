# Flow: Context Bootstrap

**Agent**: `sdd.context-builder`  
**Purpose**: Initialize or refresh repository-shared ARCUS context so agents can operate with selective, evidence-based context.  
**Evidence paths**: `agents/`, `skills/`, `templates/`, `prompts/`, `scripts/`, `registry/`  

In-scope:
- Generate `.context/repo_scope.md` (business scope + confidence notes)  
- Generate `.context/repo_map.md` (technical topology + entry points)  
- Discover flows → one file per flow under `.context/flows/`  
- Discover testing patterns → `.context/testing-patterns.md`

Inputs:
- Repository filesystem (top-level directories and files)  
- `.arcus-ignore` (if present)  

Outputs:
- `.context/repo_scope.md`  
- `.context/repo_map.md`  
- `.context/flows/*.md`  
- `.context/testing-patterns.md`

Primary skills used:
- `repository-context-builder`
- `flow-and-scope-discovery`
- `test-pattern-discovery`  

Entry criteria: repository reachable; no active integration locks.  
Exit criteria: `.context/` artifacts created or updated; quality gates passed.

