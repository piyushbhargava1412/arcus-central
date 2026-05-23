---
name: markdown-generation
description: Generate well-formatted markdown documents with correct structure, syntax, and readability for any ARCUS artifact type. Use when an agent needs to produce a spec, plan, tasks, flow, report, or context document and must ensure consistent formatting, correct heading hierarchy, and resolved placeholder tokens.
metadata:
  version: "1.0.0"
  type:
    - agents
---

# Markdown Generation

## Purpose

Produce correctly structured, consistently formatted markdown output for any artifact type. This skill handles the mechanical formatting — heading hierarchy, table alignment, code blocks, lists, frontmatter — so that callers can focus on content, not syntax.

## Inputs

- `content`: structured content to format (section data, tables, lists, prose)
- `format_style`: target output format — one of `document`, `report`, `checklist`, `story`, `summary`, `flow`, `index`
- `artifact_type` (optional): specific artifact hint — one of `spec`, `plan`, `tasks`, `story`, `context`, `report`, `instructions`, `flow`, `summary`, `completion-summary`

## Processing Rules

### Rule 1 — Document Structure

Every generated document must follow this structure:

```
# [Document Title]          ← H1, exactly one, first line
                            ← arcus-artifact-meta or arcus-context-meta block if applicable
[metadata fields]           ← bold key-value pairs (e.g., **Branch**: `main`)
                            ← blank line
---                         ← horizontal rule to separate header from body
                            ← blank line
## [Section 1]              ← H2 for top-level sections
...
### [Subsection]            ← H3 for subsections
```

- H1 appears exactly once
- Never skip heading levels (H3 cannot follow H1 directly)
- Use `---` horizontal rules only to separate major structural divisions — not between every section
- Always include a blank line before and after headings

### Rule 2 — Metadata Blocks

**`arcus-artifact-meta` block** (for `spec`, `plan`, `tasks`, `summary` artifact types):
Place immediately after the H1 title, before any other content:

```markdown
<!-- arcus-artifact-meta
generated-by: <process-name>
template: <template-filename>
arcus-version: <version>
generated-at: <ISO-8601-timestamp>
-->
```

**`arcus-context-meta` block** (for `context`, `flow` artifact types):
```markdown
<!-- arcus-context-meta
verification-commit: <hash or unknown>
generated-at: <ISO-8601-timestamp>
confidence: high | medium | low
-->
```

Never place these blocks mid-document. Never omit them for artifact types that require them.

### Rule 3 — Tables

- Every table must have a header row and a separator row
- Separator row uses `---` with optional alignment markers: `---` (left), `:---:` (centre), `---:` (right)
- Column count must be identical across all rows including header and separator
- Pad columns with spaces for readability — columns should visually align
- Use sentence case for column headers (not ALL CAPS)
- For wide tables, prefer fewer columns with more descriptive content over many narrow columns

```markdown
| Column A     | Column B     | Column C       |
|--------------|--------------|----------------|
| value one    | value two    | value three    |
```

### Rule 4 — Lists

- Use unordered lists (`-`) for items with no inherent order
- Use ordered lists (`1.`) for steps, sequences, or ranked items
- Be consistent within a document — do not mix `-` and `*` as bullet markers
- Indent nested list items by 2 spaces
- Do not use lists for single-item content — use prose instead
- List items should be parallel in structure (all start with a verb, or all start with a noun, etc.)

### Rule 5 — Code Blocks

- Always specify a language identifier for fenced code blocks:
  ```markdown
  ```bash
  git status
  ```
  ```
  ```markdown
  ```java
  public class Foo {}
  ```
  ```
- For shell commands: use `bash` or `sh`
- For file paths, configuration snippets, or pseudo-code with no specific language: use `text`
- For inline code (`backtick`): use for file names, paths, command names, identifiers, and short values — not for entire sentences
- Never use a code block for content that is better expressed as a table or list

### Rule 6 — Emphasis

- **Bold** (`**text**`): section labels, key terms introduced for the first time, critical warnings
- *Italic* (`*text*`): titles of documents or artifacts when referenced inline, light emphasis
- `Code` (backtick): file paths, command names, values, identifiers
- Do not use bold for decorative emphasis or to highlight random phrases
- Do not nest bold inside italic or vice versa

### Rule 7 — Format Style Rules

Apply the appropriate formatting rules based on `format_style`. See [references/format-style-rules.md](references/format-style-rules.md) for the full per-type specification.

Available styles: `document`, `report`, `checklist`, `story`, `summary`, `flow`, `index`

### Rule 8 — Whitespace and Spacing

- One blank line between paragraphs
- One blank line before and after headings
- One blank line before and after code blocks and tables
- No trailing whitespace on any line
- No more than one consecutive blank line
- End every document with a single newline character

### Rule 9 — Placeholders

When generating from a template, replace ALL placeholder tokens before returning:
- `[DATE]` → current date in `YYYY-MM-DD` format
- `[ISO-TIMESTAMP]` → current timestamp in `YYYY-MM-DDThh:mm:ssZ` format
- `[ARCUS_VERSION]` → value from `.arcus-metadata.json` → `version`
- `[FEATURE NAME]`, `[STORY-ID]` → values from session context
- If a value cannot be determined → use `unknown` not the raw placeholder token
- Never return a document containing unresolved `[PLACEHOLDER]` tokens

## Output Contract

- Must return:
  - well-formed markdown with correct heading hierarchy
  - all placeholder tokens resolved
  - artifact-appropriate meta block present (where required)
  - consistent formatting throughout
- Must not return:
  - invalid markdown syntax
  - unresolved placeholder tokens
  - mixed formatting styles within a single document
  - duplicate H1 headings

## Validation Gates

- [ ] H1 present exactly once as first element
- [ ] No heading level skips
- [ ] All placeholder tokens resolved
- [ ] arcus-artifact-meta or arcus-context-meta block present where required
- [ ] All tables have header + separator rows with consistent column counts
- [ ] All fenced code blocks have language identifiers and are closed
- [ ] format_style rules applied correctly for the target artifact type
- [ ] No trailing whitespace; no consecutive blank lines

## Failure Modes

- `MALFORMED_INPUT`: content structure cannot be mapped to the target format — stop and report
- `UNRESOLVABLE_PLACEHOLDER`: a required placeholder value cannot be determined — use `unknown`, log warning
- `TEMPLATE_MISMATCH`: `artifact_type` does not match the content structure provided — report and proceed with best match
- `MISSING_META_BLOCK_DATA`: required fields for `arcus-artifact-meta` block are unavailable — use `unknown` for missing fields, log warning
