---
name: checkpoint-manager
description: Create lightweight session checkpoints to resume work across multiple sessions at any stage without reloading full context.
metadata:
  inputs:
    - story_id
    - current_stage
    - tasks_file_path (optional)
    - execution_summary
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

Enable seamless resumption across session breaks at any stage. Maintains a lightweight, human-readable checkpoint that provides instant orientation: what stage was active, what was done, what's next.

Reduces context reload overhead from ~8K tokens (full artifact reload) to ~300 tokens (checkpoint load).

## Inputs

- `story_id`: Current story identifier (e.g., `FEAT-AUTH-001`)
- `current_stage`: Which workflow stage is active
- `tasks_file_path`: Path to `.arcus/specs/<STORY-ID>/tasks.md` (only if in tasks/implement/analyze stages; optional for earlier stages)
- `execution_summary`: Brief summary of what was accomplished in the last interaction (2-3 sentences max)
- `last_completed_task_id`: ID of the most recently completed task (e.g., `T012`) — only relevant for implement/analyze stages
- `blockers`: Any active blockers, failures, or special conditions blocking next steps (empty if none)
- `last_commit_hash`: (OPTIONAL) Git commit hash if code was committed; omit if no commit yet

## Processing Rules

1. **Derive current position** based on stage:
  - `specify`: No tasks yet; checkpoint focuses on spec readiness
  - `clarify`: Tracks ambiguities resolved; spec iteration state
  - `plan`: Tracks design decisions made; plan completeness
  - `tasks`: Checkpoint not needed (tasks are the checkpoint); skip if possible
  - `implement`: Parse tasks.md to compute progress, next task
  - `analyze`: Track analysis findings and context refresh status
  - `close`: Track archived stories

2. **Compute progress** (stage-dependent):
  - **implement**: Count `[X]` vs total, identify next `[ ]`
  - **other stages**: Track artifacts generated (spec, plan, tasks, etc.)

3. **Build checkpoint content** with stage-aware structure:

```markdown
# Session Checkpoint

**Last Updated**: <ISO timestamp>
**Stage**: <specify | clarify | plan | tasks | implement | analyze | close>
**Status**: In Progress | Complete
**Story**: <STORY-ID>

## Current Position
[Stage-specific content — see below]

## Last Interaction Summary
- What: <2-3 sentence summary of what was accomplished>
- Blockers: None | <brief list of blocking issues>
- Next Step: <recommended action>

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
  stage: <stage>
```

### Stage-Specific Content

**For `specify` stage:**
```markdown
## Current Position
- Spec Status: Draft | Pending review | Validated
- User Stories: N defined
- Requirements: M extracted
- Coverage: X% complete
- Next: Review spec.md or proceed to clarification phase
```

**For `clarify` stage:**
```markdown
## Current Position
- Ambiguities Resolved: N/M
- Spec Version: Iteration K
- Readiness: Ready for design | Needs more clarification
- Next: Proceed to design phase
```

**For `plan` stage:**
```markdown
## Current Position
- Design Components: N defined
- Decisions Made: M
- Plan Status: Draft | Pending review | Validated
- Next: Review plan.md or proceed to task breakdown phase
```

**For `tasks` stage:**
```markdown
## Current Position
- Tasks Created: N total
- Dependency Validation: Complete | Pending
- Task Status: Ready for implementation | Needs refinement
- Next: Review tasks.md or proceed to implementation phase
```

**For `implement` stage:**
```markdown
## Current Position
- Progress: X/Y tasks (Z%)
- Last Completed: <task-id> (<task-title>)
- Next Task: <task-id> (<task-title>)
- Batch Status: Last batch completed | Batch in progress
- Blockers: None | <brief list>
- Next: Proceed with implementation or perform analysis review
```

**For `analyze` stage:**
```markdown
## Current Position
- Analysis Type: Pre-implementation gaps | Post-implementation reconciliation
- Findings: N issues identified (M critical, X medium, Y low)
- Status: Review required | Remediation needed | Ready to proceed
- Next: Address findings or proceed with implementation
```

**For `close` stage:**
```markdown
## Current Position
- Story Status: Closed | Closing
- Tasks Completed: X/Y
- Context Refreshed: Yes | No | Skipped
- Archival: Completed | Pending
- Next: Story is archived or manual cleanup needed
```

4. **Add metadata block** with stage, artifact version, and timestamp.

5. **Determinism**: Always use same ordering (Header → Position → Summary → Code State).

6. **Brevity**: Checkpoint MUST stay under 500 tokens:
  - Summary: 1-3 sentences focused on "what changed" not "how"
  - Blockers: list IDs only
  - Task titles: use ID + brief title only (derive from tasks.md)

## Output Contract

- Must return:
  - Path to written file: `.arcus/specs/<STORY-ID>/SESSION_CHECKPOINT.md`
  - Token estimate of checkpoint size
  - Stage identifier (for recovery logic)
  - File is human-readable markdown
- Must not return:
  - Implementation code or detailed logs
  - Architecture or design details (those stay in plan.md)
  - Duplicate information from artifact files
  - Full artifact content

## Validation Gates

- [ ] Checkpoint file is valid markdown
- [ ] Stage field matches current_stage input
- [ ] All required sections present for the stage
- [ ] Checkpoint token count < 500
- [ ] If implement stage: percentages match tasks.md task count
- [ ] If implement stage: next task identified correctly
- [ ] No unresolved placeholders

## Failure Modes

- `MISSING_STAGE`: Stop and request which workflow stage the caller is in
- `MALFORMED_TASKS_FILE`: Stop (implement stage only). Cannot compute progress.
- `MISSING_EXECUTION_SUMMARY`: Stop and request brief summary of what was done
- `CHECKPOINT_TOO_LARGE`: Trim execution summary until <500 tokens
- `UNCOMMITTED_CHANGES`: Note in "Code State" section with warning ⚠

## Usage Patterns

### Pattern 1: During `implement` (multi-batch session)
```
Batch 1 → Call checkpoint-manager → SESSION_CHECKPOINT.md written
Batch 2 → Call checkpoint-manager → SESSION_CHECKPOINT.md updated
[Session breaks]
New session: Load checkpoint → User sees "Resuming implement: 12/23 tasks, Next: T013"
```

### Pattern 2: During `specify` (interactive clarification)
```
Specification phase generates spec.md
[User asks clarifying questions]
[Session breaks mid-clarification]
New session: Load checkpoint → User sees "Resuming specify: Spec draft, 5 stories defined, Next: resolve 3 ambiguities"
```

### Pattern 3: During `analyze` (post-implementation review)
```
Analysis phase identifies gaps
[User decides to remediate]
[Session breaks during remediation planning]
New session: Load checkpoint → User sees "Resuming analyze: 3 issues found, 1 critical, Next: review critical issue"
```

## Load at Session Start (Stage-Agnostic)

When any process resumes in a new session:

```
1. Bootstrap loads story context
2. If SESSION_CHECKPOINT.md exists:
   - Read checkpoint
   - Extract current_stage
   - Display orientation: "✓ Resuming <STORY> at <stage>: <position-summary>"
   - Show next recommended action
3. If no checkpoint:
   - Display: "Starting fresh with story artifacts"
4. If code state shows "Uncommitted changes":
   - Warn user: "⚠ Uncommitted changes present. Review before resuming?"
```

## Example Checkpoints

### Example 1: Implement Stage (Multi-batch)

```markdown
# Session Checkpoint

**Last Updated**: 2026-05-04T14:30:00Z
**Stage**: implement
**Status**: In Progress
**Story**: FEAT-AUTH-001

## Current Position
- Progress: 12/23 tasks (52%)
- Last Completed: T012 (Update error handler)
- Next Task: T013 (Add retry logic)
- Batch Status: Last batch completed
- Blockers: None

## Last Interaction Summary
- What: Implemented robust error handling with proper logging, added exponential backoff retry mechanism, updated TypeScript types for error responses.
- Blockers: None
- Next Step: Continue with implementation phase to implement T013

## Code State
- Code Committed: No
- Status: Uncommitted changes present

---

arcus-artifact-meta:
  artifact-type: session-checkpoint
  arcus-version: 1.2.0
  generated-at: 2026-05-04T14:30:00Z
  story-id: FEAT-AUTH-001
  stage: implement
```

**Token estimate**: ~250 tokens

### Example 2: Clarify Stage (Mid-conversation)

```markdown
# Session Checkpoint

**Last Updated**: 2026-05-04T10:15:00Z
**Stage**: clarify
**Status**: In Progress
**Story**: FEAT-PAYMENT-023

## Current Position
- Ambiguities Resolved: 2/5
- Spec Version: Iteration 3
- Readiness: Needs more clarification (3 open questions remain)
- Next: Continue with clarification phase to resolve remaining ambiguities

## Last Interaction Summary
- What: Resolved authentication scope ambiguity (Q1) and clarified payment provider fallback behavior (Q2). Identified 3 remaining open questions about refund handling, currency conversion edge cases, and webhook retry strategy.
- Blockers: Blocked on stakeholder clarification for refund handling requirements
- Next Step: Wait for stakeholder input on Q3, then continue clarification phase

## Code State
- Code Committed: N/A (specification phase)

---

arcus-artifact-meta:
  artifact-type: session-checkpoint
  arcus-version: 1.2.0
  generated-at: 2026-05-04T10:15:00Z
  story-id: FEAT-PAYMENT-023
  stage: clarify
```

**Token estimate**: ~280 tokens

### Example 3: Analyze Stage (Post-implementation)

```markdown
# Session Checkpoint

**Last Updated**: 2026-05-04T16:45:00Z
**Stage**: analyze
**Status**: In Progress
**Story**: FEAT-AUTH-001

## Current Position
- Analysis Type: Post-implementation reconciliation
- Findings: 3 issues identified (1 critical, 1 medium, 1 low)
- Status: Remediation needed
- Next: Address critical issue (implementation scope drift) before closing

## Last Interaction Summary
- What: Completed post-implementation analysis. Found that error retry logic was implemented more broadly than originally scoped (affected 2 additional modules). Updated context artifacts to reflect actual implementation footprint.
- Blockers: Critical finding: scope drift vs. spec (review before close)
- Next Step: Proceed with implementation phase to remediate or accept scope expansion

## Code State
- Code Committed: Yes
- Last Commit: abc1234 (2026-05-04 14:45)

---

arcus-artifact-meta:
  artifact-type: session-checkpoint
  arcus-version: 1.2.0
  generated-at: 2026-05-04T16:45:00Z
  story-id: FEAT-AUTH-001
  stage: analyze
```

**Token estimate**: ~270 tokens

## Integration Points

**1. After any process completes a stage segment:**
- If user might break session (implementation batches, clarification loops, analysis reviews)
- Call checkpoint-manager to record current state

**2. At start of any session when story exists:**
- Check for SESSION_CHECKPOINT.md
- Load and display to orient user
- Use stage field to show stage-specific next steps

**3. Stage-specific calls:**
- `implement`: After each batch completion
- `clarify`: After each clarification resolved
- `analyze`: After analysis findings generated
- `specify`: After spec validation gates pass
- `plan`: After plan validation gates pass
- `tasks`: Skip (tasks.md is the checkpoint)
- `close`: After archival complete
