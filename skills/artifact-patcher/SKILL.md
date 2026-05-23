---
name: artifact-patcher
description: Safely integrates patches (clarifications, updates, corrections) into any artifact (spec, plan, tasks) with conflict detection and an audit trail. Use when applying accepted answers to clarification markers, updating artifact sections from user feedback, or when asked to "apply patches", "update the spec with answers", "resolve clarification markers", or "integrate changes into the artifact".
metadata:
  version: "1.0.0"
  type:
    - agents
---

# Artifact Patcher

## Purpose

Safely integrate patches (clarifications, updates, corrections) into any artifact (spec, plan, etc.), detecting conflicts and maintaining audit trail. Decoupled from specific artifact type.

## Inputs

- `artifact_draft`: current artifact content (spec.md, plan.md, etc.)
- `patches`: user-provided answers/changes mapped to artifact locations
- `patch_mappings`: where each patch belongs (section, heading, marker replacement)

## Instructions

### Step 1: Locate Patch Targets
Locate the relevant markers or sections in the artifact (e.g., `[NEEDS CLARIFICATION: ...]`, outdated content) using `patch_mappings`.

### Step 2: Apply Patches
Replace each located marker or content block with the corresponding patch value. Remove resolved markers; do not duplicate them.

### Step 3: Detect Conflicts
Check whether any new patch value conflicts with existing artifact content. If a conflict is found, replace the old content with the patch and log the change.

### Step 4: Preserve Structure
Maintain artifact heading hierarchy, deterministic ordering, and valid Markdown syntax throughout.

### Step 5: Produce Change Log
Return a change log recording what changed, why, and where for audit purposes.

## Output Contract

Returns:
- Updated artifact with all patches integrated
- Change log showing what changed, why, and where

Does not return:
- Duplicate markers
- Speculative assumptions

## Validation Gates

- [ ] All patches applied
- [ ] No conflicting markers remain
- [ ] Artifact structure preserved
- [ ] Markdown syntax valid
- [ ] Changes logged for audit

## Troubleshooting

**`MARKER_NOT_FOUND`**: Stop and report the unresolved marker.  
**`CONFLICTING_PATCHES`**: Stop and ask the user to clarify the conflict.  
**`TEMPLATE_SYNTAX_ERROR`**: Stop and report the structural issue.

