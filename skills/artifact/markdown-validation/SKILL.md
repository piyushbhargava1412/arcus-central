---
name: markdown-validation
description: Validate markdown documents for structural integrity, syntax correctness, link validity, placeholder resolution, and formatting consistency. Parameterizable by artifact type via validation_rules.
metadata:
  inputs:
    - artifact
    - validation_rules
    - artifact_type (optional)
  outputs:
    - validation_results
    - violations
---

# Markdown Validation

## Purpose

Perform mechanical validation of any markdown artifact — checking structure, syntax, links, placeholders, and formatting consistency. The skill does not define what sections an artifact should contain (that is the responsibility of `quality-gates` or the calling agent) — it verifies that what is present is well-formed and complete.

## Inputs

- `artifact`: content to validate (raw markdown string or file path)
- `validation_rules`: structure contract for this artifact — passed by the caller, typically referencing a template or quality-gates profile (e.g., `spec-gates`, `plan-gates`, or a custom list of required sections)
- `artifact_type` (optional): hint for artifact-specific checks — one of `spec`, `plan`, `tasks`, `story`, `context`, `report`, `instructions`, `flow`, `summary`

## Processing Rules

### Rule 1 — Heading Hierarchy

- H1 (`#`) must appear exactly once, as the first heading in the document
- Headings must not skip levels — H3 must not appear before H2 in the same section
- Headings must not be empty
- Report: heading level, line number, violation description

### Rule 2 — Required Sections Check

- Load the section list from `validation_rules`
- For each required section, check that a matching heading exists in the document
- Section matching is case-insensitive and trims whitespace
- If a required section is missing → record as `MISSING_SECTION` violation with the expected heading
- Report: missing section name, nearest actual heading found

### Rule 3 — Placeholder Detection

Scan for unresolved placeholder tokens in these formats:
- `[PLACEHOLDER]` — square bracket tokens in all caps or title case
- `[DATE]`, `[FEATURE NAME]`, `[STORY-ID]`, `[ISO-TIMESTAMP]` — common ARCUS template placeholders
- `[NEEDS CLARIFICATION: ...]` — acceptable in spec.md at draft stage; flag as warning not error
- `YYYY-MM-DD` appearing literally (not as a date value) — indicates unresolved date
- `[ARCUS_VERSION]` appearing literally — indicates unresolved meta block value

For each unresolved placeholder:
- Record as `UNRESOLVED_PLACEHOLDER` violation with line number and token value
- Distinguish between ERROR (blocking) and WARNING (non-blocking) based on artifact stage

### Rule 4 — Link and Path Validation

- For every markdown link `[text](path)`:
  - If path is a relative file path (starts with `.`, `/`, or a directory name): verify the path is syntactically valid (correct format, no illegal characters)
  - If path is a URL: verify it is syntactically valid (has scheme, host)
  - Flag `#anchor` links where the anchor text does not match any heading in the same document
- For every bare URL in the document (not wrapped in link syntax): flag as `BARE_URL` warning — should use link syntax
- Do not attempt to fetch remote URLs — path format validation only

### Rule 5 — Markdown Syntax Checks

- **Tables**: every table must have a header row and a separator row (`|---|`); column count must be consistent across all rows; flag misaligned tables
- **Code blocks**: every fenced code block (`` ``` ``) must be closed; code blocks should specify a language identifier — flag missing language as warning
- **Bold/italic**: unclosed `**` or `*` markers; flag mismatched emphasis
- **Lists**: mixed ordered and unordered list items at the same indent level; inconsistent list marker style within a block
- **Blank lines**: two or more consecutive blank lines compress to one — flag excessive blank lines as style warning

### Rule 6 — arcus-artifact-meta Block (ARCUS artifacts only)

If `artifact_type` is one of `spec`, `plan`, `tasks`, `summary`:
- Check for the `<!-- arcus-artifact-meta ... -->` HTML comment block immediately after the H1 title
- Verify all four fields are present and non-empty: `generated-by`, `template`, `arcus-version`, `generated-at`
- Verify `generated-at` is a valid ISO 8601 timestamp
- If block is absent → `MISSING_META_BLOCK` (LOW severity, non-blocking)
- If `arcus-version` is a placeholder (`[ARCUS_VERSION]`) → `UNRESOLVED_PLACEHOLDER` violation

### Rule 7 — arcus-context-meta Block (context artifacts only)

If `artifact_type` is `context` or `flow`:
- Check for the `<!-- arcus-context-meta ... -->` HTML comment block immediately after the H1 title
- Verify fields present: `verification-commit`, `generated-at`, `confidence`
- If block is absent → `MISSING_META_BLOCK` (LOW severity, non-blocking)

### Rule 8 — Terminology Consistency

- Scan for the same concept referred to by multiple names within the same document
- Flag only high-confidence divergences (same noun, significantly different spelling/casing) — not stylistic variations
- Record as `TERMINOLOGY_DRIFT` warning with the conflicting terms and their line numbers

### Rule 9 — Empty Sections

- A section heading followed immediately by another heading (no content between them) is an empty section
- Flag as `EMPTY_SECTION` warning with heading name and line number
- Exception: sections that are intentionally empty per their template (e.g., "Project-Specific Overrides: None")

## Output Contract

- Must return:
  - `validation_results`: overall PASS / FAIL / WARN status
  - `violations`: list of `{ rule, severity, line, description, remediation }` per finding
    - Severity levels: `ERROR` (blocks writing), `WARNING` (non-blocking, noted in report)
  - Summary counts: error count, warning count
- Must not return:
  - modified artifact content
  - remediated versions of the artifact

## Severity Guide

| Severity | Meaning | Blocks writing? |
|----------|---------|-----------------|
| ERROR | Structural or syntax issue that renders the artifact incomplete or unreadable | Yes |
| WARNING | Quality issue that should be addressed but does not prevent use | No |

## Validation Gates

- [ ] H1 present exactly once as first heading
- [ ] No heading level skips
- [ ] All `validation_rules` required sections present
- [ ] No unresolved ERROR-level placeholders
- [ ] All relative links are syntactically valid
- [ ] All tables have header + separator rows with consistent column counts
- [ ] All fenced code blocks are closed
- [ ] `arcus-artifact-meta` or `arcus-context-meta` block checked for relevant artifact types

## Failure Modes

- `MISSING_SECTION`: required section heading not found in document
- `UNRESOLVED_PLACEHOLDER`: template token not replaced with actual value
- `MISSING_META_BLOCK`: `arcus-artifact-meta` or `arcus-context-meta` block absent (LOW, non-blocking)
- `INVALID_HEADING_HIERARCHY`: heading levels skipped or H1 appears more than once
- `BROKEN_LINK`: relative path is syntactically invalid or anchor does not resolve
- `MALFORMED_TABLE`: table missing separator row or has inconsistent column count
- `UNCLOSED_CODE_BLOCK`: fenced code block opened but never closed
- `EMPTY_SECTION`: section heading with no content before next heading
- `TERMINOLOGY_DRIFT`: same concept referred to by multiple names
- `BARE_URL`: URL not wrapped in link syntax
