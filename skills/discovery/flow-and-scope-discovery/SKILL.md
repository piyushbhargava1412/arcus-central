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

### 1. Identify entry surfaces

Use `repo_map` to identify:
- controllers
- listeners / consumers
- schedulers / jobs

### 2. Group into flows

Group entry surfaces into flows only when there is evidence of shared:
- orchestration path
- domain purpose
- downstream interactions

Prefer narrower flows over broad groupings.

### 3. Trace minimal path

For each flow, capture only:
- entry points
- primary service/orchestrator
- repositories/entities (if evident)
- integrations/events (if evident)
- related tests (if evident)

### 4. Define scope

Capture:
- relevant packages/modules
- small set of key classes

### 5. Keep flows tight

Each flow must represent one execution path, not a subsystem.

Examples:
- `email-resend-request-handling`
- `communication-status-update`

### 6. Assign confidence

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

## Output Contract

Each flow file must include:

- Flow Name
- Entry Points
- Core Path
- Data Touchpoints (if evident)
- Integrations (if evident)
- Scope
- Tests (if evident)
- Verification:
    - commit
    - confidence

## Recommended Structure

```md
# Flow: <Flow Name>

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

## Verification
commit: <hash or unknown>
confidence: high | medium | low
```

## Validation Gates

- [ ] flows mapped to real entry points
- [ ] each flow has core path
- [ ] scope defined
- [ ] no speculative flows
- [ ] one file per flow
- [ ] no aggregated flow document created

## Failure Modes

- NO_ENTRY_SURFACES
- INSUFFICIENT_TRACE
- OVER_GENERALIZATION
- DUPLICATE_FLOW_MATCH

## Handoff

Used by:
- context-drift-and-reconcile
- feature-context-pack-builder

Produces reusable flow-level context only.
