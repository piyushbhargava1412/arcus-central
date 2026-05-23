# Format Style Rules

Per-type formatting rules applied by the `markdown-generation` skill based on the `format_style` input.

---

## `document` — Spec, Plan, Instructions

- Full heading hierarchy (H1 → H2 → H3)
- Prose paragraphs for context; lists for enumerable items
- Tables for structured comparative data
- Horizontal rules (`---`) between major sections

---

## `report` — Analysis Report, Validation Report

- Lead with a summary table of findings
- Use consistent severity labels: CRITICAL / HIGH / MEDIUM / LOW
- Each finding row: ID, Category, Severity, Location, Summary, Recommendation
- Metrics block at the end with counts
- Next Actions block as the final section

---

## `checklist` — Requirements, Tasks

- All items use checkbox syntax: `- [ ] ID: description`
- Group items by phase or category under H2 headers
- No prose paragraphs — checklist items only
- Dependencies section at the end if applicable

---

## `story` — Groom Output

- Follow story-template.md section order exactly
- Narrative section: **As a** / **I want to** / **So that** on separate lines
- Acceptance criteria: Given/When/Then on separate indented lines

---

## `summary` — Completion Summary

- Lead with status line and key metadata
- Delivered section: grouped by user story
- Deferred section: task IDs with descriptions
- Context Updated section: list of artifact paths
- Keep the entire document under 60 lines

---

## `flow` — `.context/flows/*.md`

- Each section is a bullet list, not prose
- Entry points, core path, scope: one item per line
- `arcus-context-meta` block immediately after H1

---

## `index` — `copilot-instructions.md` Sections

- Reference links only — no duplicated content
- Format: `- [Label](path/to/file.md)`
- Group by category under H3 headers
