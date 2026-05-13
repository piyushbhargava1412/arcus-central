---
description: Initialize or reset ARCUS shared repository context by generating `.context/repo_scope.md`, `.context/repo_map.md`, `.context/flows/*.md`, and `.context/testing-patterns.md`.
---

 
## Purpose

Bootstrap the shared ARCUS context for a repository.

Generate only:

- `.context/repo_scope.md`
- `.context/repo_map.md`
- `.context/flows/*.md`
- `.context/testing-patterns.md`

This agent is for first-time ARCUS initialization or rare baseline reset after major structural change.

## When To Use

Use this agent when:

- ARCUS has just been integrated into a repository
- shared context artifacts do not yet exist
- existing shared context is no longer trustworthy after major repository restructuring

Do not use this agent for normal story work.

## Out of Scope

Do not:

- generate `spec.md`, `requirements.md`, or story-local context packs
- reconcile drift for routine story starts
- implement code or propose implementation design
- create broad documentation artifacts outside `.context/`
- create aggregate documents such as:
  - `business_flows.md`
  - `all_flows.md`
  - `technical_integrations.md`

## Execution Steps (follow skill definitions in order)

### 1. Build shared repository context

Invoke `repository-context-builder` and follow its Processing Rules.

This skill is responsible for creating or refreshing:

- `.context/repo_scope.md`
- `.context/repo_map.md`

The agent must not independently generate these files.

### 2. Discover and persist flows
Invoke `flow-and-scope-discovery` and follow its Processing Rules.

This skill is responsible for creating or refreshing:

- one file per flow under `.context/flows/`

The agent must not aggregate all flows into a single file.

### 3. Discover and persist test-writing patterns
Invoke `test-pattern-discovery` and follow its Processing Rules.

This skill is responsible for creating or refreshing:

- `.context/testing-patterns.md`

The agent must not infer test conventions without repository evidence.

## Execution Rules

- Always run repository context building before flow discovery
- Always run test pattern discovery after repository context exists
- Always persist outputs only under `.context/`
- Always generate one file per flow
- Keep outputs concise, structured, and optimized for selective downstream loading
- Prefer updating existing context files over duplicating them
- Do not perform repo-wide documentation writing beyond the required shared context artifacts
- Respect `.arcus-ignore` to exclude irrelevant paths
- Write `arcus-context-meta` block to both files with verification-commit and generated-at

## Expected Output

After successful execution, the repository must contain:

- `.context/repo_scope.md`
- `.context/repo_map.md`
- `.context/flows/*.md`
- `.context/testing-patterns.md`

## Completion

Return only:

- whether shared repository context was created or refreshed
- how many flow files were created or updated
- whether testing patterns were created or refreshed
- whether the repository is ready for story-level ARCUS workflow
