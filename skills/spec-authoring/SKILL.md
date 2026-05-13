---
name: spec-authoring
description: Convert natural language feature intent into structured, technology-agnostic specification content.
metadata:
  inputs:
    - feature_description
    - spec_template
    - context_pack (optional)
    - guardrails (optional)
  outputs:
    - spec_file
    - requirements_file
    - assumptions
---

# Spec Authoring

## Purpose

Own the transformation from user intent to complete specification content while staying implementation-agnostic. Produces structured specification and requirements documents that downstream processes depend on.

## Inputs

- `feature_description`: feature narrative from user input (`$ARGUMENTS`)
- `spec_template`: structure and required headings (`.arcus/templates/spec-template.md`)
- `context_pack` (optional): story-scoped context from `.arcus/specs/<STORY-ID>/context-pack.md` — use to align spec with known repo capabilities and flows
- `guardrails` (optional): project rules from `.github/copilot-instructions.md`

---

## Processing Rules

### Rule 1 — Extract Before Writing

Before populating any section, extract the following from `feature_description`:

- **Actors**: who initiates or is affected by this feature (users, services, external systems)
- **Goals**: what each actor wants to achieve
- **Key actions**: the discrete steps or interactions involved
- **Constraints**: limits, rules, or conditions explicitly stated
- **Expected outcomes**: what success looks like from the actor's perspective
- **Implicit assumptions**: reasonable defaults the user didn't state but likely intends

Do not begin section generation until this extraction pass is complete. If `context_pack` is provided, cross-reference actors and flows against it to avoid contradicting existing repo behaviour.

### Rule 2 — Section Generation Order

Generate sections in this strict order. Do not skip or reorder:

1. **User Scenarios & Testing** — always first; forces user-perspective framing before requirements
2. **Requirements** (Functional + Key Entities) — derived from scenarios, not the other way around
3. **Success Criteria** — derived from requirements; must be measurable
4. **Edge Cases** — derived from requirements and scenarios; boundary conditions and failure paths

This order prevents the common failure mode of writing requirements first and retrofitting user stories to match them.

### Rule 3 — User Story Generation Rules

For each user story:

- Assign a priority (P1, P2, P3…) based on user value, not implementation order
- Write the story in plain language from the actor's perspective — no technical terms
- The **Independent Test** field MUST describe how this story can be verified in isolation. If a story cannot be independently tested, it is not a valid story boundary — split or merge it
- Acceptance Scenarios MUST use Given/When/Then format with concrete, observable outcomes
- Minimum 1 acceptance scenario per story; aim for 2 (happy path + one edge/failure case)
- P1 story must be deliverable as a standalone MVP — if it depends on all other stories to be useful, reprioritise

### Rule 4 — Functional Requirements Generation Rules

- Each requirement MUST use normative language: `MUST`, `SHOULD`, or `MAY`
- Each requirement MUST have a single, identifiable subject and a verifiable outcome
- Requirements MUST be technology-agnostic: no class names, method names, framework names, file paths, or database schemas
- Each requirement gets a stable ID: `FR-001`, `FR-002`…
- If a requirement cannot be stated without referencing implementation, it belongs in `plan.md`, not `spec.md`
- Mark genuinely unresolvable items with `[NEEDS CLARIFICATION: <specific question>]` — do not invent answers for high-impact unknowns

### Rule 5 — The Spec / Requirements Boundary

`spec.md` and `requirements.md` serve different purposes and must not duplicate each other:

| `spec.md` | `requirements.md` |
|-----------|-------------------|
| Narrative context, user stories, acceptance scenarios, edge cases, success criteria | Flat, testable checklist of every verifiable requirement |
| Written for humans to read and discuss | Written for machines (agents) and testers to check against |
| Structured with sections and prose | Structured as a checklist: `- [ ] REQ-001: <testable statement>` |
| Contains the "why" and "what" in context | Contains only the "what" as a bare assertion |

Every `FR-XXX` in `spec.md` MUST produce at least one corresponding `REQ-XXX` entry in `requirements.md`. Success criteria produce `SC-XXX` entries. Non-functional requirements produce `NFR-XXX` entries. No requirement in `requirements.md` should exist without a traceable source in `spec.md`.

### Rule 6 — Success Criteria Generation Rules

- Each criterion MUST include a measurable threshold (numeric, percentage, or verifiable boolean)
- Do not write criteria like "the system should be fast" — write "p95 response time under 500ms under 1000 concurrent users"
- If a threshold cannot be determined from the feature description, mark with `[NEEDS CLARIFICATION: metric not specified]`
- Assign stable IDs: `SC-001`, `SC-002`…

### Rule 7 — Handling Vague or Thin Input

When `feature_description` is vague, short, or ambiguous:

- **Do not halt** — generate the best possible spec from available information
- Apply the extraction pass (Rule 1) to identify what CAN be inferred vs what cannot
- For inferable items: apply reasonable defaults and record them explicitly in the `assumptions` output
- For high-impact unknowns (scope, security model, primary actor): insert `[NEEDS CLARIFICATION: ...]` markers — do not guess
- Cap `[NEEDS CLARIFICATION]` markers at 3 total; lower-impact unknowns get a reasonable default assumption instead
- A thin spec with honest assumptions and 2–3 clarification markers is better than a confident spec with invented requirements

### Rule 8 — Technology-Agnostic Enforcement

Before finalising any section, run a technology-leak check. Flag and remove any of the following if found in `spec.md`:

- Programming language names (Python, Java, TypeScript…) — belongs in `plan.md`
- Framework or library names (FastAPI, React, Spring…) — belongs in `plan.md`
- Database or storage engine names (PostgreSQL, Redis, S3…) — belongs in `plan.md`
- File paths, class names, method names, API endpoint paths — belongs in `plan.md`
- Infrastructure terms (Lambda, Kubernetes, Docker…) — belongs in `plan.md`

Exception: if the feature description is explicitly about a technology choice (e.g., "migrate from MySQL to PostgreSQL"), the technology name is part of the requirement — retain it.

### Rule 9 — Assumptions Handling

Every reasonable default applied during authoring MUST be recorded in the `assumptions` output as:

```
- ASSUMPTION: <what was assumed> — <why this is a reasonable default>
```

Assumptions are NOT written into `spec.md` body. They are returned as a separate output for caller review and challenge before proceeding to the clarification phase.

### Rule 10 — Refinement Iterations

This skill supports up to 3 bounded refinement passes if quality gates fail:

- Pass 1: initial generation
- Pass 2: address failed gates (missing sections, untestable requirements, clarification markers)
- Pass 3: final attempt — if still failing after pass 3, return `INSUFFICIENT_CONTEXT` with the specific unresolved issues listed

Do not enter an open-ended refinement loop. After 3 passes, stop and report.

---

## Output Contract

- Must return:
  - ordered section content compatible with `spec-template.md` (all mandatory sections populated)
  - `requirements.md` checklist with `REQ-XXX` / `SC-XXX` / `NFR-XXX` entries
  - assumptions list (explicit defaults applied during authoring)
- Must not return:
  - architecture choices, APIs, frameworks, or code guidance
  - invented answers to high-impact unknowns — use `[NEEDS CLARIFICATION]` instead
  - content that duplicates between `spec.md` and `requirements.md`

---

## Validation Gates

- [ ] All mandatory spec sections present (User Scenarios, Requirements, Success Criteria)
- [ ] Every user story has an Independent Test field
- [ ] Every user story has ≥1 Given/When/Then acceptance scenario
- [ ] All functional requirements use MUST/SHOULD/MAY
- [ ] No implementation detail leakage (technology-leak check passed)
- [ ] Success criteria are measurable (no vague adjectives without thresholds)
- [ ] `requirements.md` exists and every `FR-XXX` traces to ≥1 `REQ-XXX`
- [ ] `[NEEDS CLARIFICATION]` markers ≤ 3
- [ ] All assumptions explicitly recorded in assumptions output

---

## Failure Modes

- `EMPTY_DESCRIPTION`: stop and ask for a non-empty feature description
- `TEMPLATE_MISMATCH`: stop and report missing required section in spec template
- `INSUFFICIENT_CONTEXT`: after 3 refinement passes, return unresolved issues list — do not proceed
- `TECHNOLOGY_LEAK`: flag and remove leaked implementation details; re-run technology-leak check before returning
- `UNTRACEABLE_REQUIREMENT`: requirement in `requirements.md` has no source in `spec.md` — remove or trace it
