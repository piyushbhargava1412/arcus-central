```skill
name: markdown-validation
description: Validate markdown documents including file paths, links, cross-references, placeholders, and content quality.
```

# Markdown Validation Skills

This skill provides generic capabilities for validating markdown documents, ensuring file references are valid, links work, and content meets quality standards.

## Capabilities

### 1. File Path Validation

- **Check File Existence**: Verify all referenced file paths exist in the repository
- **Validate Relative Paths**: Ensure relative paths resolve correctly from document location
- **Detect Broken Links**: Identify markdown links `[text](path)` pointing to non-existent files
- **Check Directory References**: Verify directory paths in documentation

**Usage Example:**

```markdown
Check if `../templates/spec-template.md` exists
Validate `[Engineering Guidelines](instructions/engineering/engineering-guidelines.md)`
```

### 2. Cross-Reference Validation

- **Validate Internal Links**: Check markdown links to other files in the repository
- **Validate Anchor Links**: Verify section anchors `#heading` exist in target files
- **Identify Missing References**: Find broken or outdated cross-references
- **Flag Circular References**: Detect documents that reference each other in loops

**Validation Output:**

- Flag broken links with "⚠" marker
- Confirm valid references with "✅" marker
- List missing files or sections

### 3. Content Quality Checks

- **No Unexplained Placeholders**: Ensure all `[...]`, `TODO`, or template markers are resolved
- **Consistent Heading Levels**: Verify proper heading hierarchy (no skipped levels)
- **Valid Markdown Syntax**: Check for malformed tables, lists, or code blocks
- **No Empty Sections**: Identify sections with headers but no content
- **Proper Link Format**: Ensure links use correct markdown syntax

### 4. Structural Validation

- **Required Sections Present**: Verify expected document sections exist
- **Consistent Formatting**: Check consistent use of bullets, numbering, emphasis
- **Code Block Languages**: Ensure code blocks specify language for syntax highlighting
- **Table Formatting**: Verify tables have proper headers and alignment

## Usage Guidelines

Apply this skill when:

- Generating or updating markdown documents
- Validating documentation before committing
- Checking cross-references between related files
- Ensuring links and paths are current

**Any agent** that works with markdown (README agent, docs agent, changelog agent, etc.) can use these validation capabilities.

## Success Criteria

- ✅ All file paths point to existing files
- ✅ All links are valid and working
- ✅ No unresolved placeholders
- ✅ Proper markdown syntax throughout
- ✅ Consistent formatting
````
