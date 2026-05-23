---
name: checkpoint-manager
description: Creates lightweight session checkpoints to enable seamless resumption across session breaks for any workflow. Use when completing a workflow slice that may be interrupted, at the end of an implementation batch, when asked to "save progress", "create a checkpoint", "capture session state", or "record where we left off".
metadata:
  version: "1.0.0"
  type:
    - agents
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

## Instructions

### Step 1: Derive Current Position
Use the lightest reliable source, in priority order:
1. Caller-supplied `position_snapshot` — use directly.
2. `tasks_file_path` (if present and checklist-like) — count complete vs incomplete items; identify next incomplete item.
3. Derive 1-3 bullet summary from `execution_summary`, `checkpoint_metrics`, and `artifacts_updated`.

Never reopen or restate full artifact contents just to populate the checkpoint.

### Step 2: Compute Progress
- If a checklist-like `tasks_file_path` is present, count completed vs remaining items.
- If `progress_items` is provided, preserve those labels and values as-is.
- If both exist, prefer caller-provided labels; use task-derived progress only to fill obvious gaps.
- If no meaningful progress signal exists, omit percentages rather than inventing them.

### Step 3: Build Checkpoint Content
Fill in the template from `assets/checkpoint-template.md` using the inputs. Apply these constraints:
- Treat `current_stage` as an opaque label — do not assume SDD stages or a fixed lifecycle.
- Ordering: Header → Position → Summary → Metrics → Artifacts → Code State.
- Omit empty optional sections rather than adding placeholders.
- Checkpoint MUST stay under 500 tokens: summaries 1-3 sentences, blockers as brief phrases only, metrics limited to resumption-critical values, artifact paths limited to touched files only.

### Step 4: Write and Return
Write the checkpoint to `.arcus/specs/<STORY-ID>/SESSION_CHECKPOINT.md`. Return:
- Path to the written file
- Token estimate of checkpoint size
- Workflow and stage identifiers (for recovery logic)

## Output Contract

Returns:
- Path to written file: `.arcus/specs/<STORY-ID>/SESSION_CHECKPOINT.md`
- Token estimate of checkpoint size
- Workflow + stage identifiers (for recovery logic)
- File is human-readable markdown

Does not return:
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

## Troubleshooting

**`MISSING_STAGE`**: Stop and request which workflow stage the caller is in.  
**`MALFORMED_TASKS_FILE`**: Ignore task-derived progress, note the issue, and fall back to caller-provided snapshot.  
**`MISSING_EXECUTION_SUMMARY`**: Stop and request a brief summary of what was done.  
**`CHECKPOINT_TOO_LARGE`**: Trim execution summary until under 500 tokens.  
**`UNCOMMITTED_CHANGES`**: Note in "Code State" section with warning ⚠.

## Examples

See [references/examples.md](references/examples.md) for three annotated checkpoint examples covering:
- Checklist-driven implementation sessions
- Discovery sessions without a task file
- AFK autonomous runs

## Integration Points

**After any workflow slice completes** — call when the user might break session (implementation batches, design reviews, autonomous stages).

**At session start when a story exists** — check for `SESSION_CHECKPOINT.md`, load and display to orient the user. Use `workflow` + `stage` fields to show workflow-native next steps.

**Workflow cadence** — write after meaningful state change, not after every trivial sub-step. Skip only when another artifact already serves as the authoritative live checkpoint.
