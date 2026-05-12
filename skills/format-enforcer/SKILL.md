---
name: format-enforcer
description: Validate artifact format against schema and normalize output for consistency.
metadata:
  inputs:
    - artifact
    - format_schema
    - normalization_rules
  outputs:
    - normalized_artifact
    - violations_report
---

# Format Enforcer

## Purpose

Guarantee artifacts conform to required structure and formatting. Parameterizable by artifact type and stage. Used by tasks checklist validation, specification validation, and any cross-artifact format checks.

## Inputs

- `artifact`: content to validate and normalize
- `format_schema`: required structure (e.g., task checklist format, spec sections)
- `normalization_rules`: formatting standards (whitespace, heading levels, lists)

## Processing Rules

1. Validate artifact structure against format schema line-by-line.
2. Enforce required fields, optional fields, and structural constraints.
3. Normalize whitespace, indentation, and heading hierarchy.
4. Report violations with specific line numbers and remediation.
5. Apply corrections where safe (whitespace, capitalization).
6. Flag complex violations requiring manual review.

## Output Contract

- Must return:
  - normalized artifact with consistent formatting
  - list of violations found and actions taken
  - list of violations requiring manual review
- Must not return:
  - reformatted logic or content changes

## Validation Gates

- [ ] All required fields present
- [ ] All optional fields valid if present
- [ ] Structure conforms to schema
- [ ] Formatting is consistent
- [ ] No critical violations remain uncorrected

## Failure Modes

- `MISSING_REQUIRED_FIELD`: stop and report which fields are missing
- `INVALID_STRUCTURE`: stop and report structural mismatch
- `AMBIGUOUS_VIOLATION`: report and ask for manual review

