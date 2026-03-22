```skill
name: markdown-validation
description: Validate markdown documents including file paths, links, cross-references, placeholders, and content quality.
inputs:
  - artifact
  - validation_rules
outputs:
  - validation_results
  - violations
```

# Markdown Validation

## Purpose

Ensure artifacts conform to markdown standards and quality criteria. Parameterizable by validation rules and artifact type.

## Inputs

- `artifact`: content to validate
- `validation_rules`: required structure and format standards

## Processing Rules

1. Validate artifact structure against rules
2. Check file paths and links
3. Validate heading hierarchy
4. Verify markdown syntax
5. Detect unresolved placeholders
6. Report violations with specific locations

## Output Contract

- Must return:
  - validation results with pass/fail status
  - list of violations with locations and remediation
- Must not return:
  - modified artifacts

## Validation Gates

- [ ] All required sections present
- [ ] All links are valid
- [ ] No unresolved placeholders
- [ ] Proper markdown syntax

## Failure Modes

- `INVALID_STRUCTURE`: report structural violations
- `BROKEN_LINKS`: report invalid references

