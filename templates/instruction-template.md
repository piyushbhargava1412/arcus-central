# Copilot Instruction Architecture: [PROJECT_NAME]

**Version**: [VERSION_NUMBER]  
**Last Updated**: [DATE_ISO_FORMAT]  
**Framework**: [SDD_OR_FRAMEWORK_NAME]

<!--
  CRITICAL INSTRUCTIONS FOR GENERATING THIS FILE:

  This file should be MINIMAL - it's a lightweight project-specific index, not full documentation.

  1. RESPECT .arcus-ignore:
     - Check for .arcus-ignore file in project root
     - DO NOT mention ignored paths anywhere (especially NOT .arcus/, .github/agents/, .github/prompts/)
     - Treat ignored paths as if they don't exist

  2. NEVER DUPLICATE CONTENT:
     - DO NOT repeat engineering principles from instruction files
     - DO NOT repeat architecture guidelines from instruction files
     - DO NOT repeat language/testing/infra standards from instruction files
     - REFERENCE these files instead - users will read them directly
     - This avoids violating DRY (Don't Repeat Yourself)

  3. REFERENCE REPO-INTELLIGENCE OUTPUTS:
     - If `docs/repo_map.md` and `docs/repo_scope.md` exist (from /sdd.repo-intelligence):
       * DO NOT duplicate their content — REFERENCE specific sections instead
       * Tech Stack → reference `docs/repo_map.md#tech-stack`
       * System Functionalities → reference `docs/repo_scope.md#business-capabilities`
       * Key Modules → reference `docs/repo_map.md#module--package-map`
       * Configuration → reference `docs/repo_map.md#configuration`
     - Only add a 1-2 line project summary in Project Context — NOT full tables
     - This avoids content drift when repo_map/repo_scope are regenerated

  4. DOCUMENT ONLY PROJECT-SPECIFIC CONTENT:
     - Project context (name, purpose, actual tech stack)
     - Application features found in actual code (NOT framework features)
     - Application modules found in actual code (NOT .arcus/ or .github/)
     - If no application code exists, state "No application code found"

  5. NEVER DOCUMENT FRAMEWORK/TOOLING:
     - DO NOT document agents (they're in .arcus-ignore)
     - DO NOT document templates (they're in .arcus-ignore)
     - DO NOT document scripts (they're in .arcus-ignore)
     - DO NOT document .arcus/ or .github/ directories
-->

---

## Project Context

### Repository Summary

| Field | Value |
|---|---|
| **Repository** | `[PROJECT_NAME]` |
| **Purpose** | [1-2 sentence project description] |
| **Stage** | [e.g., "Initial setup", "Active development", "Prototype"] |
| **Architecture Style** | [e.g., "Monolith", "Microservices", "Client-server"] |
| **Primary Languages** | [e.g., "Java 21", "Python 3.11 / TypeScript"] |
| **Authoritative Tech Docs** | [`docs/repo_map.md`](../docs/repo_map.md) · [`docs/repo_scope.md`](../docs/repo_scope.md) |

### Technology Stack

<!--
  DO NOT duplicate the full tech stack table here.
  If docs/repo_map.md exists, reference it with a 1-line summary.
-->

> **Full tech stack details**: See [`docs/repo_map.md` → Tech Stack](../docs/repo_map.md#tech-stack)

### Key Application Modules

<!--
  DO NOT duplicate the modules table here.
  If docs/repo_map.md exists, reference it.
-->

> **Full module map**: See [`docs/repo_map.md` → Module / Package Map](../docs/repo_map.md#module--package-map)

### Known Configuration Constraints

<!--
  DO NOT duplicate configuration tables here.
  If docs/repo_map.md exists, reference it.
  Only list project-specific constraints that agents MUST be aware of (e.g., hardcoded values, tech debt).
-->

> **Full configuration**: See [`docs/repo_map.md` → Configuration](../docs/repo_map.md#configuration)

---

## System Functionalities

<!--
  DO NOT duplicate features/capabilities here.
  If docs/repo_scope.md exists, reference it.
  Only add project-specific behavioral notes that agents MUST follow.
-->

> **Full feature list & capabilities**: See [`docs/repo_scope.md` → Business Capabilities](../docs/repo_scope.md#business-capabilities)

---

## Engineering Standards & Guidelines

<!--
  DO NOT repeat content from instruction files here.
  Instruction files are the source of truth - reference them instead.
  This follows DRY (Don't Repeat Yourself) principle.

  DO NOT add status tables showing whether instruction files exist.
  Just reference the files - users will see if they exist when they follow the links.

  CRITICAL: Dynamically discover all instruction files:
  - Search for ALL .md files recursively under `instructions/` folder
  - Group by subfolder (engineering/, architecture/, languages/, infra/, testing/, etc.)
  - For EACH discovered file that has content:
    * Use markdown link format: - **[Title]**: See [path/to/file.md](path/to/file.md)
    * File names are self-explanatory, no summary needed
  - For files that are empty or don't exist:
    * Use format: "Reference: `path/to/file.md` — N/A (not yet created)"
    * Do NOT create markdown links for non-existent files
  
  BENEFIT: When new instruction files are added to instructions/ folder, 
  they will automatically appear here without manual updates.
-->

All engineering principles, architecture guidelines, language standards, testing requirements, and infrastructure patterns are defined in the following instruction files:

### Core Guidelines

<!--
  The examples below are SAMPLES ONLY.
  Dynamically discover and list ALL instruction files found in instructions/ folder.
  Organize by subfolder and use the file name to derive the display label.
-->

- **Engineering Principles**: See [../.arcus/instructions/engineering/engineering-guidelines.md](../.arcus/instructions/engineering/engineering-guidelines.md)
- **Architecture Guidelines**: See [../.arcus/instructions/architecture/architecture-guidelines.md](../.arcus/instructions/architecture/architecture-guidelines.md)
- **Language & Coding Standards**: See [../.arcus/instructions/languages/language-guidelines.md](../.arcus/instructions/languages/language-guidelines.md)
- **Infrastructure Standards**: See [../.arcus/instructions/infra/infrastructure-guidelines.md](../.arcus/instructions/infra/infrastructure-guidelines.md)
- **Testing Guidelines**: See [../.arcus/instructions/testing/testing-guidelines.md](../.arcus/instructions/testing/testing-guidelines.md)

<!--
  If additional instruction files are found in instructions/ subfolders,
  list them here following the same pattern.
-->

### Project-Specific Overrides

<!--
  Only add content here if this project has SPECIFIC overrides or exceptions
  to the standards defined in instruction files.
  If no overrides exist, leave this section empty or state "None".
-->

[None - Follow all standards defined in instruction files]

OR

- [Specific override with justification]

---

## Agent Behavioral Rules

### Repository Analysis

1. **ALWAYS** check `.arcus-ignore` before analyzing repository
2. **ALWAYS** exclude paths matching `.arcus-ignore` patterns
3. **NEVER** mention ignored paths in any artifacts
4. **ONLY** document application code (not framework/tooling)

### Code Generation

1. **READ** architecture guidelines from `../.arcus/instructions/architecture/` before generating code
2. **READ** language standards from `../.arcus/instructions/languages/` before generating code
3. **VALIDATE** against engineering principles from `../.arcus/instructions/engineering/`
4. **RESPECT** existing architecture and module boundaries

### Quality Assurance

1. **ENFORCE** testing requirements defined in `../.arcus/instructions/testing/`
2. **VALIDATE** infrastructure changes against `../.arcus/instructions/infra/`
3. **CHECK** cross-references point to valid files
4. **ENSURE** no unexplained bracket tokens `[...]` remain in artifacts

For detailed agent behavior rules, see instruction files referenced above.

---

## Amendment Log

| Version     | Date       | Change Summary | Type                |
| ----------- | ---------- | -------------- | ------------------- |
| [VERSION_1] | [DATE_ISO] | [SUMMARY]      | [MAJOR/MINOR/PATCH] |

---

**Maintained by**: `sdd.instructions` agent  
**Next Review**: [DATE_ISO]
