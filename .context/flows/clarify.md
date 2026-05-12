# Flow: Clarify

**Agent**: `sdd.clarify`  
**Purpose**: Resolve high-impact ambiguities in specifications using bounded, interactive questions.  

In-scope:
- Prioritize ambiguities, conduct one-question-at-a-time interactive loop (max 5), and apply answers to specification artifacts.  
- Validate updated spec via markdown validation and quality gates.

Inputs:
- `spec.md` produced by `sdd.specify`  
- `.context/` artifacts

Outputs:
- Updated `spec.md` with clarifications recorded

Primary skills used:
- `ambiguity-detection`
- `question-orchestration`
- `artifact-patcher`
- `markdown-validation`  

Entry criteria: `spec.md` exists and contains ambiguous items.  
Exit criteria: All high-impact ambiguities resolved or explicitly deferred.

