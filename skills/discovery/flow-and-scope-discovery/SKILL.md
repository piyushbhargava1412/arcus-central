---
name: flow-and-scope-discovery
description: Identify business flows and persist each flow as a separate file in .context/flows using repo_scope and repo_map as primary inputs.
inputs:
  - repo_scope
  - repo_map
outputs:
  - flows
---

# Flow and Scope Discovery

## Purpose

Identify key business flows and map each flow to its associated implementation scope.

Persist each discovered flow as its own file under:

- `.context/flows/`

## When To Use

- after repository context is built
- after major context refresh
- before story-level context building

## Non-Goals

Do not:
- build story-specific context
- reconcile drift from git commits
- infer flows without code anchors
- aggregate flows into a single document
- create a separate integrations document
- create overly broad flows

## Inputs

- `repo_scope`
- `repo_map`

## Core Principle

Each flow must be:
- small
- specific
- independently readable
- evidence-backed

## Processing Rules

### 1. Capture verification metadata

Before generating any flow files:
- Read `verification-commit` from the `arcus-context-meta` block of `repo_scope.md` — use this as `CURRENT_COMMIT`
- Capture the current ISO timestamp as `GENERATED_AT`
- If `verification-commit` is `unknown` or missing: use `unknown`

### 2. Identify entry surfaces

Use `repo_map` to identify:
- controllers
- listeners / consumers
- schedulers / jobs

### 3. Group into flows

Group entry surfaces into flows only when there is evidence of shared:
- orchestration path
- domain purpose
- downstream interactions

Prefer narrower flows over broad groupings.

### 4. Trace minimal path

For each flow, capture only:
- entry points
- primary service/orchestrator
- repositories/entities (if evident)
- integrations/events (if evident)
- related tests (if evident)

### 5. Define scope

Capture:
- relevant packages/modules
- small set of key classes

### 6. Keep flows tight

Each flow must represent one execution path, not a subsystem.

Examples:
- `email-resend-request-handling`
- `communication-status-update`

### 7. Assign confidence

- high: clear evidence
- medium: partial trace
- low: weak trace (prefer omission)

## Persistence Rules

1. Ensure directory exists:
  - `.context/flows/`

2. Persist one file per flow:
  - `.context/flows/<flow-name>.md`

3. Naming:
  - kebab-case
  - concise and specific

4. If file exists:
  - update it
  - do not duplicate

5. Never create:
  - `business_flows.md`
  - `all_flows.md`
  - `technical_integrations.md`

6. Integrations must be captured:
  - in `repo_scope.md` (high-level), or
  - within the relevant flow file

7. Write the `arcus-context-meta` block at the top of every flow file immediately after the header:

```
<!-- arcus-context-meta
verification-commit: <CURRENT_COMMIT>
generated-at: <GENERATED_AT>
confidence: <high | medium | low>
-->
```

## Output Contract

Each flow file must include:

- `arcus-context-meta` block with `verification-commit`, `generated-at`, `confidence`
- Flow Name
- Entry Points
- Core Path
- Data Touchpoints (if evident)
- Integrations (if evident)
- Scope
- Tests (if evident)

## Recommended Structure

```md
# Flow: <Flow Name>

<!-- arcus-context-meta
verification-commit: <hash or unknown>
generated-at: <ISO-TIMESTAMP>
confidence: high | medium | low
-->

## Entry Points
- ...

## Core Path
- ...

## Data Touchpoints
- ...

## Integrations
- ...

## Scope
- ...

## Tests
- ...
```

## Validation Gates

- [ ] flows mapped to real entry points
- [ ] each flow has core path
- [ ] scope defined
- [ ] no speculative flows
- [ ] one file per flow
- [ ] no aggregated flow document created
- [ ] `arcus-context-meta` block written to every flow file with `verification-commit`

## Failure Modes

- `NO_ENTRY_SURFACES`: no controllers/listeners/schedulers found — report and stop
- `INSUFFICIENT_TRACE`: cannot trace a minimal path for a candidate flow — omit that flow, continue others
- `OVER_GENERALIZATION`: detected flow covers too many entry surfaces — split into narrower flows
- `DUPLICATE_FLOW_MATCH`: two flow files would cover the same entry surface — merge or disambiguate

## Handoff

Used by:
- `context-drift-and-reconcile`
- `feature-context-pack-builder`

Produces reusable flow-level context only.
