```skill
name: artifact-patcher
description: Apply accepted answers or changes into artifact sections with conflict detection and audit trail.
inputs:
  - artifact_draft
  - patches
  - patch_mappings
outputs:
  - patched_artifact
  - change_log
```

# Artifact Patcher

## Purpose

Safely integrate patches (clarifications, updates, corrections) into any artifact (spec, plan, etc.), detecting conflicts and maintaining audit trail. Decoupled from specific artifact type.

## Inputs

- `artifact_draft`: current artifact content (spec.md, plan.md, etc.)
- `patches`: user-provided answers/changes mapped to artifact locations
- `patch_mappings`: where each patch belongs (section, heading, marker replacement)

## Processing Rules

1. Locate relevant markers or sections in artifact (e.g., `[NEEDS CLARIFICATION: ...]`, old content).
2. Replace marker/content with patch value.
3. Detect if new patch conflicts with existing artifact content.
4. If conflict found, replace old content with patch and log change.
5. Preserve artifact structure and heading hierarchy.
6. Remove resolved markers; do not duplicate.
7. Maintain deterministic ordering.

## Output Contract

- Must return:
  - updated artifact with all patches integrated
  - change log showing what changed, why, and where
- Must not return:
  - duplicate markers
  - speculative assumptions

## Validation Gates

- [ ] All patches applied
- [ ] No conflicting markers remain
- [ ] Artifact structure preserved
- [ ] Markdown syntax valid
- [ ] Changes logged for audit

## Failure Modes

- `MARKER_NOT_FOUND`: stop and report unresolved marker
- `CONFLICTING_PATCHES`: stop and ask user to clarify conflict
- `TEMPLATE_SYNTAX_ERROR`: stop and report structural issue

