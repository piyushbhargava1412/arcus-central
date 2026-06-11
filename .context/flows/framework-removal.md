# Flow: Framework Removal from Target Repository

<!-- arcus-context-meta
verification-commit: cc8d06ae9d0ee4b6a897ab41851e297f4df63e9e
generated-at: 2026-05-23T12:11:28Z
confidence: high
-->

---

## Summary

A user runs `arcus-integrate --remove` (or `integrate.sh --remove`) inside a target repository to undo the framework distribution. The script removes symlinks, copied agent/prompt/skill files, and leaves `.arcus/guidelines/` in place (preserving any AGENTS.md references).

## Entry Point

- `integrate.sh --remove` (invoked directly or via `arcus-integrate --remove`)

## Execution Path

```
arcus-integrate --remove
  └── integrate.sh (REMOVE_MODE=true, AUTO_YES=true)
        ├── Resolve TARGET_REPO (CWD)
        ├── Remove .arcus/ symlinks (templates, scripts):
        │     └── Preserve .arcus/guidelines/ (may be referenced by AGENTS.md)
        ├── Remove .github/agents/*.agent.md files
        ├── Remove .github/prompts/*.prompt.md files
        ├── Remove .github/skills/SKILL.md files and SKILLS_REGISTRY.md
        └── Report removed artifact counts
```

## Scope

- `integrate.sh` — implements removal logic via `remove_md_files()` helper and symlink cleanup
- `scripts/bash/common.sh` — provides path resolution helpers

## Notes

- `.arcus/guidelines/` is intentionally preserved to avoid breaking existing `AGENTS.md` files in the target repo
- The global `arcus-integrate` CLI itself is NOT removed by this flow; use `uninstall.sh` for that
