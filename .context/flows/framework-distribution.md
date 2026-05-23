# Flow: Framework Distribution

<!-- arcus-context-meta
verification-commit: cc8d06ae9d0ee4b6a897ab41851e297f4df63e9e
generated-at: 2026-05-23T12:11:28Z
confidence: high
-->

---

## Summary

A user runs `arcus-integrate` (or `integrate.sh`) from within a target repository to distribute the SDD framework. The script creates symlinks for templates/scripts/guidelines, copies agents/prompts/skills as read-only files, seeds `.arcus-ignore`, and writes integration metadata.

## Entry Point

- `integrate.sh` — invoked directly or via the `arcus-integrate` system command (installed by `install-cli.sh`)

## Execution Path

```
arcus-integrate [--sync | --yes | --remove]
  └── integrate.sh
        ├── Parse arguments (--sync, --yes, --remove)
        ├── Resolve CENTRAL_REPO (from script location)
        ├── Resolve TARGET_REPO (first positional arg or CWD)
        ├── [SYNC / FIRST RUN] Create .arcus/ symlinks:
        │     ├── .arcus/templates  → <central>/templates
        │     ├── .arcus/scripts    → <central>/scripts/bash
        │     └── .arcus/guidelines → <central>/guidelines
        ├── [SYNC / FIRST RUN] Copy read-only agent/prompt/skill files:
        │     ├── .github/agents/   ← <central>/agents/**/*.agent.md  (chmod 444)
        │     ├── .github/prompts/  ← <central>/prompts/**/*.prompt.md (chmod 444)
        │     └── .github/skills/   ← <central>/skills/ (chmod 444)
        ├── [FIRST RUN ONLY] Copy .arcus-ignore to target root
        └── Write .arcus-metadata.json (version, paths, timestamp)
```

## Scope

- `integrate.sh` — orchestrates the entire distribution
- `scripts/bash/common.sh` — provides shared helper functions (path resolution)

## Related Tests

None — distribution is validated manually by inspecting symlinks and file presence.
