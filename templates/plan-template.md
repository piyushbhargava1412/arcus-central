# Implementation Plan: [FEATURE]

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]
**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note**: This template is filled in by the `/sdd.plan` command. See `.arcus/templates/plan-template.md` for the execution workflow.

## Summary

[Extract from feature spec: primary requirement + technical approach from research]

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: [e.g., Python 3.11, Swift 5.9, Rust 1.75 or NEEDS CLARIFICATION]  
**Primary Dependencies**: [e.g., FastAPI, UIKit, LLVM or NEEDS CLARIFICATION]  
**Storage**: [if applicable, e.g., PostgreSQL, CoreData, files or N/A]  
**Testing**: [e.g., pytest, XCTest, cargo test or NEEDS CLARIFICATION]  
**Target Platform**: [e.g., Linux server, iOS 15+, WASM or NEEDS CLARIFICATION]
**Project Type**: [single/web/mobile - determines source structure]  
**Performance Goals**: [domain-specific, e.g., 1000 req/s, 10k lines/sec, 60 fps or NEEDS CLARIFICATION]  
**Constraints**: [domain-specific, e.g., <200ms p95, <100MB memory, offline-capable or NEEDS CLARIFICATION]  
**Scale/Scope**: [domain-specific, e.g., 10k users, 1M LOC, 50 screens or NEEDS CLARIFICATION]

---

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/sdd.plan command output)
├── research.md          # Phase 0 output (/sdd.plan command)
├── data-model.md        # Phase 1 output (/sdd.plan command)
├── quickstart.md        # Phase 1 output (/sdd.plan command)
├── contracts/           # Phase 1 output (/sdd.plan command)
└── tasks.md             # Phase 2 output (/sdd.tasks command - NOT created by /sdd.plan)
```

### Source Code (repository root)

<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```text
# [REMOVE IF UNUSED] Option 1: Single project (DEFAULT)
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/

# [REMOVE IF UNUSED] Option 2: Web application (when "frontend" + "backend" detected)
backend/
├── src/
│   ├── models/
│   ├── services/
│   └── api/
└── tests/

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   └── services/
└── tests/

# [REMOVE IF UNUSED] Option 3: Mobile + API (when "iOS/Android" detected)
api/
└── [same as backend above]

ios/ or android/
└── [platform-specific structure: feature modules, UI flows, platform tests]
```

**Structure Decision**: [Document the selected structure and reference the real
directories captured above]

---

## Constitution Check

[Verify alignment with `.github/copilot-instructions.md`. List any trade-offs or exceptions.]

---

## Design Overview

- High-level approach to solving the requirement
- How the solution fits into existing architecture
- Key design philosophy (extend existing patterns vs. introduce new ones)

---

## Key Design Decisions

| Decision     | Rationale           | Alternative Considered                     |
| ------------ | ------------------- | ------------------------------------------ |
| [Decision 1] | [Why this approach] | [What else was evaluated and why rejected] |
| [Decision 2] | [Why this approach] | [What else was evaluated and why rejected] |

---

## Component-Level Responsibilities

[Identify which existing components/services/modules are involved. Describe their responsibilities at a conceptual level.]

Example:

- **Lambda: send-email-lambda** → Orchestrates email sending workflow
- **Service: SES Integration** → Handles communication with AWS SES
- **Data Store: DynamoDB** → Persists delivery status (if applicable)

---

## Data & Control Flow

[Describe how data flows through the system and how control is passed between components.]

### Data Model Changes

[OPTIONAL - Only if new entities or significant schema changes are needed]

- Entity: [Name]
  - Fields: [list key fields]
  - Relationships: [describe how it relates to existing entities]
  - Validation: [any constraints]

### API/Contract Changes

[OPTIONAL - Only if endpoints or message contracts change]

- Endpoint: [HTTP method] `/[path]`
  - Request: [payload structure]
  - Response: [payload structure]
  - Error Cases: [edge cases]

---

## Error Handling & Edge Cases

- **Failure scenarios**: How are failures detected and handled?
- **Partial success**: Can operations complete partially? How is state managed?
- **Idempotency**: How are duplicate requests handled?
- **Timeouts/Retries**: What are retry policies and backoff strategies?
- **Data consistency**: How is consistency maintained across services?

---

## Observability & Operations

- **Logging**: What should be logged at each stage? Log levels?
- **Metrics**: What metrics should be collected? (e.g., success rate, latency)
- **Alerts**: What conditions warrant alerts?
- **Runbooks**: Are there manual operational procedures needed?

---

## Rollout & Backward Compatibility

- **Deployment strategy**: Can this be deployed gradually? Feature flags needed?
- **Producer/Consumer compatibility**: Will existing clients/producers work with this change?
- **Database migrations**: Any schema changes and migration strategy (if applicable)
- **Rollback plan**: How can this be safely rolled back?

---

## Complexity Justification

[OPTIONAL - Only if design introduces complexity that deviates from constitution]

| Complexity | Why Needed | Simpler Alternative & Why It Won't Work |
| ---------- | ---------- | --------------------------------------- |
| [Example]  | [Reason]   | [What simpler approach was considered]  |
