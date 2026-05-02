# Flow: Specify

**Agent**: `sdd.specify`  
**Purpose**: Create or update a feature specification (WHAT / WHY) from a natural language feature description.  

In-scope:
- Parse feature description, extract requirements, produce `spec.md`, `requirements.md`, `context-pack.md`  
- Validate spec completeness via quality gates

Inputs:
- Feature description (user input)  
- `.context/` artifacts and templates

Outputs:
- `.arcus/specs/<ID>/spec.md`  
- `.arcus/specs/<ID>/requirements.md`  
- `.arcus/specs/<ID>/context-pack.md`

Primary skills used:
- `core/session-bootstrap`  
- `context/feature-context-pack-builder`  
- `specialized/spec/spec-authoring`  
- `specialized/spec/ambiguity-detection`  
- `core/quality-gates`  

Entry criteria: developer supplies feature description.  
Exit criteria: Spec created; no high-impact ambiguities remain.

