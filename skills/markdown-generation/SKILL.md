```skill
name: markdown-generation
description: Generate well-formatted markdown documents with proper structure, syntax, and readability.
```

# Markdown Generation Skills

This skill provides generic capabilities for generating well-structured, properly formatted markdown documents with consistent style and readability.

## Capabilities

### 1. Document Structure

- **Create Proper Heading Hierarchy**: Use H1 for title, H2 for main sections, H3+ for subsections
- **Organize Content Logically**: Group related information into clear sections
- **Add Table of Contents**: Generate ToC for longer documents with navigation links
- **Include Metadata**: Add frontmatter or header metadata when needed
- **Proper Document Flow**: Ensure logical progression from introduction to conclusion

**Example Structure:**

```markdown
# Document Title

Brief introduction...

## Main Section 1

Content...

### Subsection 1.1

Details...

## Main Section 2

More content...
```

### 2. Markdown Formatting

- **Format Tables**: Create properly aligned tables with headers
- **Style Lists**: Use appropriate bullet points, numbered lists, or task lists
- **Format Code Blocks**: Include language specification for syntax highlighting
- **Apply Emphasis**: Use bold, italic, and code formatting appropriately
- **Create Blockquotes**: Format quotes and callouts correctly
- **Add Horizontal Rules**: Use `---` for visual separation

**Formatting Examples:**

````markdown
| Column 1 | Column 2 |
| -------- | -------- |
| Value A  | Value B  |

- Bullet point
  - Nested item

1. Numbered item
2. Another item

```javascript
const code = "formatted";
```
````

**Bold** and _italic_ text

````

### 3. Link and Reference Management

- **Create Internal Links**: Link to other sections or files in repository
- **Format External Links**: Properly format URLs to external resources
- **Use Reference-Style Links**: Organize links at document bottom for readability
- **Add Image References**: Include images with alt text and proper paths

**Link Examples:**
```markdown
[Internal link](./other-file.md)
[Section link](#heading-name)
[External link](https://example.com)
![Image alt text](./images/diagram.png)
````

### 4. Content Organization

- **Use Consistent Style**: Apply consistent formatting throughout document
- **Add Visual Hierarchy**: Use formatting to guide reader attention
- **Include Examples**: Provide code examples, templates, or samples
- **Add Callouts**: Use blockquotes or badges for important notes
- **Proper Spacing**: Maintain readability with appropriate line breaks

### 5. Quality Standards

- **Clear Language**: Write concise, understandable text
- **Logical Flow**: Ensure information progresses naturally
- **Complete Sentences**: Avoid fragments or unclear statements
- **Proper Grammar**: Use correct spelling and punctuation
- **Consistent Terminology**: Use same terms for same concepts throughout

## Usage Guidelines

Apply this skill when:

- Creating new markdown documents (README, docs, guides)
- Formatting existing content for better readability
- Generating reports or summaries
- Producing structured output for users

**Any agent** that generates markdown (README agent, docs agent, report agent, changelog agent, etc.) can use these formatting capabilities.

## Templates and Examples

### Report Template

```markdown
# [Report Title]

## Summary

Brief overview...

## Details

### Section 1

Content...

### Section 2

More content...

## Conclusion

Final thoughts...
```

### Documentation Template

````markdown
# [Feature Name]

## Overview

What it does...

## Usage

How to use it...

## Examples

```javascript
// Code example
```

## Notes

Important information...
````

## Success Criteria

- ✅ Proper heading hierarchy
- ✅ Consistent formatting throughout
- ✅ Valid markdown syntax
- ✅ Clear and readable structure
- ✅ Appropriate use of formatting elements
