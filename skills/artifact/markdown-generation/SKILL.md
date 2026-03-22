```skill
name: markdown-generation
description: Generate well-formatted markdown documents with proper structure, syntax, and readability.
inputs:
  - content
  - format_style
outputs:
  - formatted_markdown
```

# Markdown Generation

## Purpose

Provide reusable capabilities for generating well-structured, properly formatted markdown documents with consistent style and readability across all artifact types.

## Inputs

- `content`: document content to format
- `format_style`: target format (report, list, table, etc.)

## Processing Rules

1. Create proper heading hierarchy (H1 for title, H2 for sections, etc.)
2. Format tables with alignment and proper spacing
3. Create lists with consistent bullet/numbering
4. Apply emphasis (bold, italic, code) appropriately
5. Include code blocks with language specification
6. Maintain logical content flow

## Output Contract

- Must return:
  - well-formatted markdown suitable for rendering
- Must not return:
  - invalid markdown syntax
  - malformed tables or lists

## Validation Gates

- [ ] Proper heading hierarchy
- [ ] Consistent formatting throughout
- [ ] Valid markdown syntax
- [ ] Appropriate use of formatting elements

## Failure Modes

- `MALFORMED_INPUT`: stop and report formatting issue

