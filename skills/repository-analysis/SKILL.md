```skill
name: repository-analysis
description: Repository analysis capabilities including ignore pattern processing, structure analysis, and codebase classification for instruction agent.
```

# Repository Analysis Skills

This skill provides capabilities for analyzing repository structure, respecting ignore patterns, and classifying codebases to enable accurate instruction generation.

## Capabilities

### 1. Ignore Pattern Processing

- **Check for .apex-ignore File**: Locate and read `.apex-ignore` file in project root
- **Parse Ignore Patterns**: Interpret gitignore-style syntax patterns
- **Apply Exclusion Filters**: Filter out all matching files and folders from analysis
- **Validate No Ignored References**: Ensure no ignored paths are mentioned in outputs

**Critical Rules**:

- Completely exclude matching files/folders from analysis
- Treat ignored paths as if they don't exist in the repository
- Common patterns: `node_modules/`, `dist/`, `.git/`, `build/`, `vendor/`, `.github/agents/`, `.apex/`

### 2. Repository Structure Analysis

- **Scan Directory Tree**: Traverse repository structure respecting ignore patterns
- **Identify Modules**: Recognize application modules in non-ignored paths
- **Detect Architecture Style**: Infer architecture from actual code structure
- **Map Features to Modules**: Link implemented features to responsible modules
- **Extract Technology Stack**: Identify languages, frameworks, and tools from actual code

**Critical Rules**:

- ONLY document what actually exists (NEVER guess or assume)
- If no codebase found: Document as "No application code found"
- Respect existing architecture—do NOT violate module boundaries
- Distinguish between application code and framework/tooling code

### 3. Codebase Classification

- **Classify Project Stage**: Determine if initial setup, active development, or no application code
- **Identify Architecture Pattern**: Recognize microservices, monolith, layered, etc.
- **List Application Modules**: Enumerate only APPLICATION modules (exclude framework paths)
- **Catalog Features**: Document only features with actual implementation

## Usage Guidelines

**Always use this skill as the first step** before any instruction creation or update to ensure accurate understanding of the repository state.

## Success Criteria

- ✅ All ignore patterns respected
- ✅ Only actual implementation documented
- ✅ No framework paths in application modules list
- ✅ Architecture accurately identified
