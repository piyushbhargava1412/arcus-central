---
name: design-synthesis
description: Transforms requirements into an actionable design organized by concern (architecture, data flow, error handling, observability, rollout). Documents decisions with rationale and trade-offs. Use when producing a design or architecture section for a spec, when asked to "synthesize the design", "create an architecture section", "document design decisions", or "design the solution".
metadata:
  version: "1.0.0"
  type:
    - agents
---

# Design Synthesis

## Purpose

Transform requirements into actionable design organized by concern (architecture, data, flow, error handling, etc.).

## Inputs

- `requirements_context`: functional/non-functional requirements, user stories, scope
- `constraints`: technical constraints, boundaries, dependencies
- `guardrails`: project-level rules from `.github/copilot-instructions.md`

## Instructions

### Step 1: Extract Key Concerns
From `requirements_context`, identify scope, actors, data entities, integrations, and quality attributes.

### Step 2: Compose Design Sections
Fill in each section of the template in `assets/design-template.md`: overview, decisions, components, data flow, error handling, observability, rollout, and backward compatibility.

### Step 3: Document Trade-offs
For each design decision, record the rationale and trade-offs considered. No decision should be undocumented.

### Step 4: Validate Against Constraints and Guardrails
Confirm the design satisfies all non-functional requirements, respects `constraints`, and does not violate `guardrails`.

### Step 5: Identify Open Questions
List any design questions that cannot be resolved from available inputs. Do not block output — include them in the Open Questions section.

## Output Contract

Format output using the template in `assets/design-template.md`. Returns:
- Ordered design sections with complete coverage
- Explicit design decisions with rationale and trade-offs
- Open design questions (if any)

Does not return:
- Implementation code or stack choices
- Contradictions with requirements

## Validation Gates

- [ ] All design sections populated
- [ ] Each decision has explicit rationale
- [ ] No implementation details
- [ ] Design consistent with requirements
- [ ] Trade-offs documented

## Troubleshooting

**`MISSING_REQUIREMENTS`**: Stop and request approved requirements before proceeding.  
**`CONFLICTING_DESIGN`**: Stop and identify the contradiction with requirements.  
**`INCOMPLETE_DESIGN`**: Stop and report the missing required section.

