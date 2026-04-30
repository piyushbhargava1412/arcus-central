```skill
name: session-bootstrap
description: Resolve feature identity and canonical artifact/template paths for the current SDD stage.
inputs:
  - user_input
  - repository_root
outputs:
  - story_id
  - feature_dir
  - artifact_paths
  - template_paths
```

# Session Bootstrap

## Purpose

Provide a single reusable mechanism to initialize stage context so path logic is not duplicated across agents. Resolves a story ID from available sources and builds all canonical artifact paths for the current stage.

## Inputs

- `user_input`: raw user command arguments (`$ARGUMENTS`)
- `repository_root`: current repository root path

## Processing Rules

### Rule 1 — Story ID Resolution (three-step cascade)

Attempt each step in order. Stop at the first successful resolution.

**Step 1 — Explicit ID in user input**

Scan `user_input` for a token that looks like a story or ticket identifier:
- Any alphanumeric token containing a hyphen (e.g., `PROJ-123`, `ABC-456`, `feat-007`)
- Any numeric prefix token (e.g., `001`, `042`)
- Any short slug that does not read as a natural language word (e.g., `add-auth`, `payment-v2`)

If a clear identifier token is found → use it as `story_id`.

**Step 2 — Derive from git branch name**

If no explicit ID in user input:
- Run: `git -C <repository_root> rev-parse --abbrev-ref HEAD`
- Use the branch name directly as `story_id`
- Strip any characters illegal in file/directory names (`\ / : * ? " < > |`)
- Examples:
  - Branch `PROJ-123` → `story_id = PROJ-123`
  - Branch `001-payment-flow` → `story_id = 001-payment-flow`
  - Branch `add-user-authentication` → `story_id = add-user-authentication`
- No format enforcement — any branch name is a valid story ID

**Step 3 — Ask the user**

If git is unavailable or HEAD is detached:
- Stop and ask: "Please provide a story ID (e.g., the ticket number or branch name for this feature)."
- Do not proceed until a story ID is supplied.
- Do not guess or generate a story ID.

### Rule 2 — Feature Directory

Build the canonical feature directory from the resolved `story_id`:

```
feature_dir = <repository_root>/.arcus/specs/<story_id>/
```

If the directory does not yet exist, note it for creation — do not create it here. Creation is the responsibility of the calling agent's write step.

### Rule 3 — Artifact Paths

Build stage artifact paths under `feature_dir`:

| Artifact | Path |
|----------|------|
| Context pack | `feature_dir/context-pack.md` |
| Specification | `feature_dir/spec.md` |
| Requirements | `feature_dir/requirements.md` |
| Plan | `feature_dir/plan.md` |
| Tasks | `feature_dir/tasks.md` |

Return only the paths relevant to the calling agent's stage — do not return all paths to every agent.

### Rule 4 — Template Paths

Resolve template paths from `.arcus/templates/` (symlinked to central):

| Template | Path |
|----------|------|
| Spec template | `.arcus/templates/spec-template.md` |
| Checklist template | `.arcus/templates/checklist-template.md` |
| Plan template | `.arcus/templates/plan-template.md` |
| Tasks template | `.arcus/templates/tasks-template.md` |
| Story template | `.arcus/templates/stories/story-template.md` |

If a required template is missing → return `MISSING_TEMPLATE` with the specific path.

### Rule 5 — Deterministic Output

All returned paths must be:
- Absolute (prefixed with `repository_root`)
- Consistent across repeated calls with the same inputs
- Free of trailing slashes on directory paths

## Output Contract

- Must return:
  - `story_id` — the resolved identifier string
  - `feature_dir` — absolute path to `.arcus/specs/<story_id>/`
  - `artifact_paths` — map of artifact name → absolute path (stage-relevant only)
  - `template_paths` — map of template name → absolute path
- Must not return:
  - inferred implementation choices
  - paths outside `.arcus/specs/` or `.arcus/templates/`

## Validation Gates

- [ ] Story ID resolved via one of the three cascade steps
- [ ] Story ID contains no illegal filename characters
- [ ] Feature path follows `.arcus/specs/<story_id>/`
- [ ] Required templates resolved and paths confirmed
- [ ] Returned path map is deterministic and absolute

## Failure Modes

- `MISSING_STORY_ID`: git unavailable or HEAD detached and no ID in user input — ask user to provide one explicitly
- `MISSING_TEMPLATE`: required template file not found at expected path — stop and instruct user to run `arcus-integrate --sync`
- `INVALID_PATH_STATE`: repository root cannot be resolved — stop and ask user to verify they are inside a valid repository
