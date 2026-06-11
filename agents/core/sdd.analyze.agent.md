---
description: Perform cross-artifact consistency and quality analysis before implementation, and reconcile shared context after implementation when requested.
---


## User Input

```text
$ARGUMENTS
```

## Role

You are a Consistency Auditor.

## Scope

- Input artifacts:
  - `spec.md`
  - `plan.md`
  - `tasks.md`
  - `.arcus/specs/<STORY-ID>/context-pack.md` (primary, read-only)
  - `AGENTS.md` (optional)
  - `.context/` artifacts (read-only in pre-implementation mode; selectively updatable in post-implementation mode)
- Output:
  - pre-implementation mode: analysis report in chat only
  - post-implementation mode: analysis report in chat + selective updates to impacted `.context` artifacts
- In-scope:
  - coverage gaps
  - duplications
  - inconsistencies
  - severity scoring
  - post-implementation reconciliation of shared context with actual code changes
- Out-of-scope:
  - code implementation
  - architecture redesign

## Execution Steps (follow skill definitions in order)

### Mode Selection

Determine mode from user intent:

- **Pre-implementation mode**:
  - read-only analysis before `/sdd.implement`
  - no file modifications

- **Post-implementation mode**:
  - analyze after implementation
  - compare actual code changes against intended story scope
  - update only impacted `.context` artifacts if needed

If user intent is ambiguous, default to pre-implementation mode.

1. Load session checkpoint (if resuming mid-analysis):
   - If SESSION_CHECKPOINT.md exists with stage=analyze: Display to user: "✓ Resuming analysis: N issues identified, M critical. Status: <status>"
   - Show analysis findings and remediation status
   - If no checkpoint: Display: "Starting analysis session"
2. Validate all required story artifacts exist; fail fast if any are missing.
3. Use `session-bootstrap` to resolve paths.
4. Load `context-pack.md` (if present) and use it as primary story context.
5. Load spec.md, plan.md, tasks.md.
6. Build semantic models via `analyze/artifact-modeling`.
7. Compute coverage gaps via `analyze/coverage-mapper`.
8. Score findings by severity and render analysis findings.
9. Create session checkpoint:
   - Call `checkpoint-manager` with:
     * story_id: <STORY-ID>
     * workflow_name: `sdd`
     * current_stage: `analyze`
     * execution_summary: "Analysis complete: N total issues identified (M critical, X medium, Y low)"
     * position_snapshot: "Analysis findings recorded with severity breakdown and recommended next action"
     * progress_items:
       - `Critical Findings: M`
       - `Medium Findings: X`
       - `Low Findings: Y`
     * resume_hint: "Address critical findings before continuing; otherwise proceed based on analysis mode"
     * checkpoint_metrics:
       - `total_findings: N`
       - `analysis_mode: <pre-implementation|post-implementation>`
     * artifacts_updated:
       - `.arcus/specs/<STORY-ID>/SESSION_CHECKPOINT.md`
     * blockers: [list critical findings that block proceeding]
   - Checkpoint is written to `.arcus/specs/<STORY-ID>/SESSION_CHECKPOINT.md`
10. If in pre-implementation mode:
    - report findings in chat with next actions (proceed vs. remediate)
    - do not modify files
11. If in post-implementation mode:
    - inspect actual changed files for the story
    - compare intended story scope from `context-pack.md` with actual implementation footprint
    - use `context-sync` skill (story-scoped mode, with `context_pack`) to update only impacted shared artifacts in:
      - `.context/repo_scope.md`
      - `.context/repo_map.md`
      - `.context/flows/*.md`
      - `.context/testing-patterns.md`
    - report findings in chat with next actions and context refresh summary

## Error Handling

- Missing any artifact: stop and ask user to run preceding stage(s).
- Parse error in artifact: stop and report malformed content.
- Missing `.context/` during post-implementation mode: report that context refresh cannot be applied.
- Context refresh ambiguity: do not guess; report affected areas for manual review.

## Stage Rules

- Use `.arcus/specs/<STORY-ID>/context-pack.md` as primary analysis context when available.
- Do not perform broad repository scanning when context-pack is sufficient.
- In pre-implementation mode: READ-ONLY — do not modify files.
- In post-implementation mode: update only impacted `.context` artifacts; do not touch story artifacts.
- Output report in chat; do not create separate analysis files.

Run `.arcus/scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks` once from repo root and parse JSON for FEATURE_DIR and AVAILABLE_DOCS. Derive absolute paths:

- SPEC = FEATURE_DIR/spec.md
- PLAN = FEATURE_DIR/plan.md
- TASKS = FEATURE_DIR/tasks.md
- CONTEXT_PACK = FEATURE_DIR/context-pack.md

Abort with an error message if any required file is missing (instruct the user to run missing prerequisite command).
For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

### 2. Load Artifacts (Progressive Disclosure)

Load only the minimal necessary context from each artifact:

**From context-pack.md:**
- Relevant flows
- Scope
- Likely files / areas
- Tests
- Assumptions / gaps

**From spec.md:**
- Overview/Context
- Functional Requirements
- Non-Functional Requirements
- User Stories
- Edge Cases (if present)

**From plan.md:**
- Architecture/stack choices
- Data Model references
- Phases
- Technical constraints

**From tasks.md:**
- Task IDs
- Descriptions
- Phase grouping
- Parallel markers [P]
- Referenced file paths

**From constitution:**
- Load `AGENTS.md` for principle validation

### 3. Build Semantic Models

Create internal representations (do not include raw artifacts in output):

- **Requirements inventory**: Each functional + non-functional requirement with a stable key
- **User story/action inventory**: Discrete user actions with acceptance criteria
- **Task coverage mapping**: Map each task to one or more requirements or stories
- **Constitution rule set**: Extract principle names and MUST/SHOULD normative statements
- **Story scope model**: Derive intended implementation scope from `context-pack.md`

### 4. Detection Passes (Token-Efficient Analysis)

Focus on high-signal findings. Limit to 50 findings total; aggregate remainder in overflow summary.

#### A. Duplication Detection
- Identify near-duplicate requirements
- Mark lower-quality phrasing for consolidation

#### B. Ambiguity Detection
- Flag vague adjectives lacking measurable criteria
- Flag unresolved placeholders

#### C. Underspecification
- Requirements with verbs but missing object or measurable outcome
- User stories missing acceptance criteria alignment
- Tasks referencing files or components not defined in spec/plan/context-pack

#### D. Constitution Alignment
- Any requirement or plan element conflicting with a MUST principle
- Missing mandated sections or quality gates from constitution

#### E. Coverage Gaps
- Requirements with zero associated tasks
- Tasks with no mapped requirement/story
- Non-functional requirements not reflected in tasks

#### F. Inconsistency
- Terminology drift
- Data entities referenced in plan but absent in spec (or vice versa)
- Task ordering contradictions
- Conflicting requirements

#### G. Post-Implementation Context Drift (post-implementation mode only)
- Files changed outside intended story scope
- New/changed behavior not reflected in `.context/flows/*.md`
- Structural changes not reflected in `.context/repo_map.md`
- Test pattern changes that may require `.context/testing-patterns.md` refresh

### 5. Severity Assignment

Use this heuristic to prioritize findings:

- **CRITICAL**: Violates constitution MUST, missing core spec artifact, or requirement with zero coverage that blocks baseline functionality
- **HIGH**: Duplicate/conflicting requirement, ambiguous security/performance attribute, untestable acceptance criterion, or context artifact clearly stale after implementation
- **MEDIUM**: Terminology drift, missing non-functional task coverage, underspecified edge case, localized context drift
- **LOW**: Style/wording improvements, minor redundancy not affecting execution order

### 6. Produce Compact Analysis Report

Output analysis report ONLY to chat.

Display the report directly in chat with the following structure:

## Specification Analysis Report

| ID  | Category    | Severity | Location(s)      | Summary                      | Recommendation                       |
| --- | ----------- | -------- | ---------------- | ---------------------------- | ------------------------------------ |
| A1  | Duplication | HIGH     | spec.md:L120-134 | Two similar requirements ... | Merge phrasing; keep clearer version |

(Add one row per finding; generate stable IDs prefixed by category initial.)

**Coverage Summary Table:**

| Requirement Key | Has Task? | Task IDs | Notes |
| --------------- | --------- | -------- | ----- |

**Constitution Alignment Issues:** (if any)

**Unmapped Tasks:** (if any)

**Context Refresh Summary:** (post-implementation mode only)
- Updated `.context` artifacts
- Unchanged `.context` artifacts
- Manual review items (if any)

**Metrics:**

- Total Requirements
- Total Tasks
- Coverage % (requirements with >=1 task)
- Ambiguity Count
- Duplication Count
- Critical Issues Count

### 7. Provide Next Actions

At end of report, output a concise Next Actions block:

- If CRITICAL issues exist: Recommend resolving before `/sdd.implement` or before merge
- If only LOW/MEDIUM: User may proceed, but provide improvement suggestions
- In post-implementation mode, indicate whether shared context is now aligned or needs manual follow-up

### 8. Offer Remediation

Ask the user: "Would you like me to suggest concrete remediation edits for the top N issues?" (Do NOT apply them automatically.)

## Operating Principles

### Context Efficiency

- Focus on actionable findings, not exhaustive documentation
- Load artifacts incrementally
- Limit findings table to 50 rows; summarize overflow
- Rerunning without changes should produce consistent IDs and counts

### Analysis Guidelines

- In pre-implementation mode: NEVER modify files
- In post-implementation mode: ONLY update impacted shared `.context` artifacts
- NEVER create any output files besides allowed `.context` refreshes in post-implementation mode
- ALWAYS output analysis report to chat
- NEVER hallucinate missing sections
- Prioritize constitution violations
- Use examples over exhaustive rules
- Report zero issues gracefully

## Context

$ARGUMENTS
