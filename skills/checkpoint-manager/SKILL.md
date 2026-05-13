---
name: checkpoint-manager
description: Create lightweight session checkpoints to resume work across multiple sessions at any stage without reloading full context.
metadata:
  inputs:
    - story_id
    - current_stage
    - workflow_name (optional)
    - tasks_file_path (optional)
    - execution_summary
    - position_snapshot (optional)
    - progress_items (optional)
    - resume_hint (optional)
    - checkpoint_metrics (optional)
    - artifacts_updated (optional)
    - last_completed_task_id (optional)
    - blockers
    - last_commit_hash (optional)
  outputs:
    - checkpoint_file_path
    - checkpoint_token_estimate
    - checkpoint_stage
---

# Session Checkpoint Manager

## Purpose

Enable seamless resumption across session breaks for any workflow. Maintains a lightweight, human-readable checkpoint that provides instant orientation: what workflow was active, what slice of work was completed, and what should happen next.

Reduces context reload overhead from ~8K tokens (full artifact reload) to ~300 tokens (checkpoint load).

## Inputs

- `story_id`: Current story identifier (e.g., `FEAT-AUTH-001`)
- `current_stage`: Current stage/phase/step label supplied by the caller. Treat as opaque text, not an enumerated SDD-only value.
- `workflow_name` (optional): Higher-level workflow label (e.g., `sdd`, `afk`, `release-train`, `migration-runbook`). Defaults to `unspecified-workflow` if omitted.
- `tasks_file_path`: Path to a task list/checklist file if the caller wants task-derived progress. Optional for every workflow.
- `execution_summary`: Brief summary of what was accomplished in the last interaction (2-3 sentences max)
- `position_snapshot` (optional): Caller-supplied bullet-sized summary of current position. Use this as the primary source of truth instead of inventing stage-specific structure.
- `progress_items` (optional): 2-6 concise `label: value` entries describing counts, progress, status, or readiness.
- `resume_hint` (optional): Recommended next action phrased in workflow-native terms.
- `checkpoint_metrics` (optional): Compact structured metrics the caller needs preserved (tokens, coverage, decisions, findings, files changed, etc.).
- `artifacts_updated` (optional): List of artifact paths created or updated during the last slice.
- `last_completed_task_id`: ID of the most recently completed task (e.g., `T012`) when relevant
- `blockers`: Any active blockers, failures, or special conditions blocking next steps (empty if none)
- `last_commit_hash`: (OPTIONAL) Git commit hash if code was committed; omit if no commit yet

## Processing Rules

1. **Treat the checkpoint as workflow-agnostic**:
  - Do not assume SDD stages or a fixed lifecycle.
  - Treat `current_stage` as an opaque label.
  - Prefer caller-provided `position_snapshot`, `progress_items`, `resume_hint`, `checkpoint_metrics`, and `artifacts_updated` over inferred text.

2. **Derive the current position using the lightest reliable source**:
  - If `position_snapshot` is provided, use it directly.
  - Else if `tasks_file_path` is provided and appears to be a checklist, compute lightweight progress by counting complete vs incomplete items and identifying the next incomplete item when possible.
  - Else derive a 1-3 bullet position summary from `execution_summary`, `checkpoint_metrics`, and `artifacts_updated`.
  - Never reopen or restate full artifact contents just to populate the checkpoint.

3. **Compute progress opportunistically, not by workflow name**:
  - If a checklist-like `tasks_file_path` is present, count completed vs remaining work items.
  - If `progress_items` is provided, preserve those labels and values as-is.
  - If both exist, prefer caller-provided labels and use task-derived progress only to fill obvious gaps.
  - If no meaningful progress signal exists, omit percentages rather than inventing them.

4. **Build checkpoint content** with a stable, generic structure:

```markdown
# Session Checkpoint

**Last Updated**: <ISO timestamp>
**Workflow**: <workflow_name>
**Stage**: <current_stage>
**Status**: In Progress | Complete
**Story**: <STORY-ID>

## Current Position
[Workflow-native snapshot bullets]

## Last Interaction Summary
- What: <2-3 sentence summary of what was accomplished>
- Blockers: None | <brief list of blocking issues>
- Next Step: <recommended action>

## Key Metrics
- <label>: <value>

## Artifacts Updated
- <path>

## Code State
- Code Committed: Yes | No
- Last Commit: <hash> (if available) | Uncommitted changes present
- Status: Ready to continue | Needs manual review before resuming

---

arcus-artifact-meta:
  artifact-type: session-checkpoint
  arcus-version: <version>
  generated-at: <ISO timestamp>
  story-id: <STORY-ID>
  workflow: <workflow_name>
  stage: <current_stage>
```

### Generic Snapshot Construction

Use the following prioritization when composing `## Current Position`:

1. Caller-supplied `position_snapshot`
2. Task-derived progress from `tasks_file_path`
3. Compact summary derived from `execution_summary` and `checkpoint_metrics`

When task-derived progress is available, the preferred bullets are:

```markdown
## Current Position
- Progress: X/Y items (Z%)
- Last Completed: <item-id-or-summary>
- Next Focus: <next-item-or-resume-hint>
- Status: <in progress | blocked | complete>
```

When no task list exists, prefer caller-native bullets such as:

```markdown
## Current Position
- Position: <current workflow-native state>
- Coverage: <if provided>
- Decisions: <if provided>
- Readiness: <ready / blocked / awaiting review / complete>
```

5. **Add metadata block** with workflow, stage, artifact version, and timestamp.

6. **Determinism**: Always use same ordering (Header → Position → Summary → Metrics → Artifacts → Code State). Omit empty sections rather than adding placeholders.

7. **Brevity**: Checkpoint MUST stay under 500 tokens:
  - Summary: 1-3 sentences focused on "what changed" not "how"
  - Blockers: list IDs or brief phrases only
  - Metrics: preserve only values likely needed for resumption
  - Artifact paths: include only touched artifacts, not inventories

## Output Contract

- Must return:
  - Path to written file: `.arcus/specs/<STORY-ID>/SESSION_CHECKPOINT.md`
  - Token estimate of checkpoint size
  - Workflow + stage identifiers (for recovery logic)
  - File is human-readable markdown
- Must not return:
  - Implementation code or detailed logs
  - Architecture or design details (those stay in plan.md)
  - Duplicate information from artifact files
  - Full artifact content

## Validation Gates

- [ ] Checkpoint file is valid markdown
- [ ] Workflow and stage fields are present
- [ ] Stage field matches current_stage input
- [ ] Current Position is derived from caller data or cheap local evidence
- [ ] Checkpoint token count < 500
- [ ] If task-derived progress is used: percentages match tasks file count
- [ ] If a next item is shown: it is grounded in caller data or tasks file
- [ ] No unresolved placeholders

## Failure Modes

- `MISSING_STAGE`: Stop and request which workflow stage the caller is in
- `MALFORMED_TASKS_FILE`: Ignore task-derived progress, note the issue, and fall back to caller-provided snapshot
- `MISSING_EXECUTION_SUMMARY`: Stop and request brief summary of what was done
- `CHECKPOINT_TOO_LARGE`: Trim execution summary until <500 tokens
- `UNCOMMITTED_CHANGES`: Note in "Code State" section with warning ⚠

## Usage Patterns

### Pattern 1: Checklist-Driven Implementation Session
```
Batch 1 → Call checkpoint-manager → SESSION_CHECKPOINT.md written
Batch 2 → Call checkpoint-manager → SESSION_CHECKPOINT.md updated
[Session breaks]
New session: Load checkpoint → User sees "Resuming <workflow>/<stage>: 12/23 items, Next: T013"
```

### Pattern 2: Design or Discovery Session Without tasks.md
```
Workflow generates spec/design/context artifacts
[Session breaks mid-stream]
New session: Load checkpoint → User sees "Resuming <workflow>/<stage>: decisions captured, 2 open gaps, Next: resolve ambiguity on auth boundary"
```

### Pattern 3: AFK Autonomous Run
```
Architect stage completes
Test generation completes
[Run halts before code stage resumes]
New session: Load checkpoint → User sees "Resuming afk/code: architect + test complete, Next: execute 6 implementation items"
```

## Load at Session Start (Stage-Agnostic)

When any process resumes in a new session:

```
1. Bootstrap loads story context
2. If SESSION_CHECKPOINT.md exists:
   - Read checkpoint
  - Extract `workflow` and `stage`
  - Display orientation: "✓ Resuming <STORY> at <workflow>/<stage>: <position-summary>"
   - Show next recommended action
3. If no checkpoint:
   - Display: "Starting fresh with story artifacts"
4. If code state shows "Uncommitted changes":
   - Warn user: "⚠ Uncommitted changes present. Review before resuming?"
```

## Example Checkpoints

### Example 1: Checklist-Driven Session

```markdown
# Session Checkpoint

**Last Updated**: 2026-05-04T14:30:00Z
**Workflow**: sdd
**Stage**: implement
**Status**: In Progress
**Story**: FEAT-AUTH-001

## Current Position
- Progress: 12/23 tasks (52%)
- Last Completed: T012 (Update error handler)
- Next Focus: T013 (Add retry logic)
- Status: In progress

## Last Interaction Summary
- What: Implemented robust error handling with proper logging, added exponential backoff retry mechanism, updated TypeScript types for error responses.
- Blockers: None
- Next Step: Continue with implementation phase to implement T013

## Key Metrics
- Files Changed: 4
- Tests Passing: 18

## Code State
- Code Committed: No
- Status: Uncommitted changes present

---

arcus-artifact-meta:
  artifact-type: session-checkpoint
  arcus-version: 1.2.0
  generated-at: 2026-05-04T14:30:00Z
  story-id: FEAT-AUTH-001
  workflow: sdd
  stage: implement
```

**Token estimate**: ~250 tokens

### Example 2: Discovery Session Without Task File

```markdown
# Session Checkpoint

**Last Updated**: 2026-05-04T10:15:00Z
**Workflow**: discovery
**Stage**: ambiguity-review
**Status**: In Progress
**Story**: FEAT-PAYMENT-023

## Current Position
- Position: Requirement boundaries reviewed; refund handling still open
- Coverage: 2/5 ambiguity clusters resolved
- Readiness: Awaiting stakeholder input

## Last Interaction Summary
- What: Resolved authentication scope ambiguity (Q1) and clarified payment provider fallback behavior (Q2). Identified 3 remaining open questions about refund handling, currency conversion edge cases, and webhook retry strategy.
- Blockers: Blocked on stakeholder clarification for refund handling requirements
- Next Step: Wait for stakeholder input on refund handling, then continue ambiguity review

## Artifacts Updated
- .arcus/specs/FEAT-PAYMENT-023/spec.md

## Code State
- Code Committed: N/A (specification phase)

---

arcus-artifact-meta:
  artifact-type: session-checkpoint
  arcus-version: 1.2.0
  generated-at: 2026-05-04T10:15:00Z
  story-id: FEAT-PAYMENT-023
  workflow: discovery
  stage: ambiguity-review
```

**Token estimate**: ~280 tokens

### Example 3: AFK Session Snapshot

```markdown
# Session Checkpoint

**Last Updated**: 2026-05-04T16:45:00Z
**Workflow**: afk
**Stage**: testgen
**Status**: In Progress
**Story**: FEAT-AUTH-001

## Current Position
- Position: Architect output complete; test plan generated; code stage not started
- Decisions: 6 captured
- Coverage: 24 test cases traced to 6 work items
- Readiness: Ready for code execution

## Last Interaction Summary
- What: Completed autonomous architect and test-generation slices. Generated execution log, architect output, and test plan with full traceability.
- Blockers: None
- Next Step: Resume AFK code stage and execute the remaining implementation items

## Key Metrics
- token_consumed_architect: 82000
- token_consumed_test_generation: 41000
- test_case_count: 24

## Artifacts Updated
- .arcus/specs/FEAT-AUTH-001/architect-output.md
- .arcus/specs/FEAT-AUTH-001/test-plan.md
- .arcus/specs/FEAT-AUTH-001/EXECUTION_LOG.md

## Code State
- Code Committed: No
- Status: Ready to continue

---

arcus-artifact-meta:
  artifact-type: session-checkpoint
  arcus-version: 1.2.0
  generated-at: 2026-05-04T16:45:00Z
  story-id: FEAT-AUTH-001
  workflow: afk
  stage: testgen
```

**Token estimate**: ~270 tokens

## Integration Points

**1. After any process completes a workflow slice:**
- If user might break session (implementation batches, design reviews, autonomous stages)
- Call checkpoint-manager to record current state

**2. At start of any session when story exists:**
- Check for SESSION_CHECKPOINT.md
- Load and display to orient user
- Use workflow + stage fields to show workflow-native next steps

**3. Workflow-specific cadence:**
- Use after any resumable batch, slice, milestone, or checkpoint-worthy pause
- Prefer writing after meaningful state change, not after every trivial sub-step
- Skip only when another artifact already serves as the authoritative live checkpoint and adds no new resume value
