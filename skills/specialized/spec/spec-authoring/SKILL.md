```skill
name: spec-authoring
description: Convert natural language feature intent into structured, technology-agnostic specification content.
inputs:
  - feature_description
  - spec_template
  - guardrails
outputs:
  - spec_sections
  - assumptions
```

# Spec Authoring

## Purpose

Own the transformation from user intent to complete specification content while staying implementation-agnostic. Primarily used by specify stage.

## Inputs

- `feature_description`: feature narrative from user input
- `spec_template`: structure and required headings
- `guardrails`: project rules from `.github/copilot-instructions.md`

## Processing Rules

1. Extract actors, goals, key actions, constraints, and expected outcomes.
2. Populate required spec sections in template order.
3. Capture reasonable defaults as explicit assumptions.
4. Keep requirements testable, unambiguous, and user-value oriented.
5. Keep success criteria measurable and technology-agnostic.

## Output Contract

- Must return:
  - ordered section content compatible with `spec-template.md`
  - assumptions list
- Must not return:
  - architecture choices, APIs, frameworks, or code guidance

## Validation Gates

- [ ] Mandatory sections are present
- [ ] Requirements are testable
- [ ] Success criteria are measurable
- [ ] No implementation detail leakage

## Failure Modes

- `EMPTY_DESCRIPTION`: stop and ask for non-empty description
- `TEMPLATE_MISMATCH`: stop and report missing required section
- `INSUFFICIENT_CONTEXT`: emit bounded clarifications for unresolved high-impact items

