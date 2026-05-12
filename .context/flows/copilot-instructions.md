# Flow: Copilot Instructions Generation

**Agent**: `sdd.instructions`  
**Purpose**: Produce repository-specific copilot instruction architecture (`.github/copilot-instructions.md`) that encodes guardrails derived from `.context/repo_scope.md` and `.context/repo_map.md`.  

In-scope:
- Read `.context/repo_scope.md` and `.context/repo_map.md`  
- Synthesize repository-specific guardrails and instruction fragments  
- Emit `.github/copilot-instructions.md` (copy mode for IntelliJ discovery)

Inputs:
- `.context/repo_scope.md`, `.context/repo_map.md`  

Outputs:
- `.github/copilot-instructions.md` (repository-level copilot instructions)

Primary skills used:
- `session-bootstrap`
- `report-renderer`  

Entry criteria: up-to-date `.context/` artifacts.  
Exit criteria: Copilot instructions written and reviewed.

