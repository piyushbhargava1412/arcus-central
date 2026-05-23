# Flow: Feature Story Scaffolding

<!-- arcus-context-meta
verification-commit: cc8d06ae9d0ee4b6a897ab41851e297f4df63e9e
generated-at: 2026-05-23T12:11:28Z
confidence: high
-->

---

## Summary

A developer runs `create-new-feature.sh` inside a target repository (via the `.arcus/scripts/` symlink) to scaffold the story artifact directory for a new feature. The script resolves the current git branch as the story ID, creates `.arcus/specs/<STORY-ID>/`, and emits the canonical paths for spec, plan, and tasks files.

## Entry Point

- `scripts/bash/create-new-feature.sh` — invoked from a target repo via `.arcus/scripts/create-new-feature.sh`

## Execution Path

```
create-new-feature.sh [--json] [--short-name <name>] [--number N] <feature_description>
  ├── source common.sh (get_repo_root, get_current_branch, get_feature_paths)
  ├── Resolve CURRENT_BRANCH from: SPECIFY_FEATURE env var → git branch → latest .arcus/specs/ dir → "main"
  ├── check_feature_branch: reject main/master/develop; warn if branch doesn't follow <id>-<description> convention
  ├── Resolve FEATURE_DIR: .arcus/specs/<CURRENT_BRANCH>/
  │     └── Canonicalize: if branch matches BFCO-<num>-... and .arcus/specs/BFCO-<num>/ exists, prefer it
  ├── mkdir -p FEATURE_DIR
  └── Output: canonical spec.md, plan.md, tasks.md paths (JSON if --json flag)
```

## Scope

- `scripts/bash/create-new-feature.sh` — entry point and orchestrator
- `scripts/bash/common.sh` — shared helpers: `get_repo_root`, `get_current_branch`, `check_feature_branch`, `get_feature_paths`

## Key Paths Emitted

| Variable        | Value                                  |
|-----------------|----------------------------------------|
| `FEATURE_DIR`   | `.arcus/specs/<STORY-ID>/`             |
| `FEATURE_SPEC`  | `.arcus/specs/<STORY-ID>/spec.md`      |
| `IMPL_PLAN`     | `.arcus/specs/<STORY-ID>/plan.md`      |
| `TASKS`         | `.arcus/specs/<STORY-ID>/tasks.md`     |

## Notes

- Story ID is derived from the git branch name; no user prompt unless branch is invalid
- `SPECIFY_FEATURE` environment variable overrides branch-based detection
- Branch names matching `BFCO-<num>-*` get a canonicalized directory (`BFCO-<num>` prefix only)
