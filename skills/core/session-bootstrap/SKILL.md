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

Provide a single reusable mechanism to initialize stage context so path logic is not duplicated across agents.

## Inputs

- `user_input`: raw user command arguments
- `repository_root`: current repository root path

## Processing Rules

1. Extract `story_id` from user input (pattern like `BFCO-1234`).
2. Build canonical feature directory: `.apex/specs/<story_id>/`.
3. Build stage artifact paths under feature directory.
4. Resolve template paths from `.apex/templates/` with fallback to `templates/`.
5. Return a deterministic path map with absolute and repo-relative forms.

## Output Contract

- Must return:
  - `story_id`
  - `feature_dir`
  - `artifact_paths` (e.g., `spec.md`, `requirements.md`)
  - `template_paths` (resolved template files)
- Must not return:
  - inferred implementation choices

## Validation Gates

- [ ] Story ID extracted and valid
- [ ] Feature path follows `.apex/specs/<story_id>/`
- [ ] Required templates resolved
- [ ] Returned path map is deterministic

## Failure Modes

- `MISSING_STORY_ID`: ask user to provide explicit story ID in input
- `MISSING_TEMPLATE`: stop and report unresolved template path
- `INVALID_PATH_STATE`: stop and request repository structure verification

