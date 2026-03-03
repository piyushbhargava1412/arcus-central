# Copilot Instruction Architecture: [PROJECT_NAME]

**Version**: [VERSION_NUMBER]  
**Last Updated**: [DATE_ISO_FORMAT]  
**Framework**: [SDD_OR_FRAMEWORK_NAME]

<!--
  CRITICAL INSTRUCTIONS FOR GENERATING THIS FILE:

  This file should be MINIMAL - it's a lightweight project-specific index, not full documentation.

  1. RESPECT .apex-ignore:
     - Check for .apex-ignore file in project root
     - COMPLETELY EXCLUDE all matching files/folders from analysis
     - DO NOT mention ignored paths anywhere (especially NOT .apex/, .github/agents/, .github/prompts/)
     - Treat ignored paths as if they don't exist

  2. NEVER DUPLICATE CONTENT:
     - DO NOT repeat engineering principles from instruction files
     - DO NOT repeat architecture guidelines from instruction files
     - DO NOT repeat language/testing/infra standards from instruction files
     - REFERENCE these files instead - users will read them directly
     - This avoids violating DRY (Don't Repeat Yourself)

  3. DOCUMENT ONLY PROJECT-SPECIFIC CONTENT:
     - Project context (name, purpose, actual tech stack)
     - Application features found in actual code (NOT framework features)
     - Application modules found in actual code (NOT .apex/ or .github/)
     - If no application code exists, state "No application code found"

  4. NEVER DOCUMENT FRAMEWORK/TOOLING:
     - DO NOT document agents (they're in .apex-ignore)
     - DO NOT document templates (they're in .apex-ignore)
     - DO NOT document scripts (they're in .apex-ignore)
     - DO NOT document .apex/ or .github/ directories
-->

---

## Project Context

### Repository Summary

**[PROJECT_NAME]** is [PROJECT_DESCRIPTION or "a new project with no application code yet"].

**Current State**: [e.g., "Initial setup" or "Active development" or "No application code found"]

### Technology Stack

<!--
  List ONLY technologies found in actual application code (non-ignored paths).
  If no application code exists, state "No application code to infer from" for each category.
-->

- **Languages**: [e.g., Python 3.11, TypeScript, Java 17 or "Not yet determined"]
- **Frameworks**: [e.g., FastAPI, React, Spring Boot or "Not yet determined"]
- **Data Storage**: [e.g., PostgreSQL, MongoDB, DynamoDB or "Not applicable"]
- **Infrastructure**: [e.g., Docker, Kubernetes, AWS, GCP or "Not applicable"]

### Architecture Style

**[ARCHITECTURE_CLASSIFICATION or "No architecture defined yet"]**

<!--
  Only describe architecture if application code exists.
  Don't assume architecture patterns that aren't implemented.
-->

### Key Application Modules

<!--
  CRITICAL: Only list APPLICATION modules that actually exist in non-ignored paths.
  DO NOT list .apex/, .github/, node_modules/, or any ignored directories.
  If no application modules found, state "No application modules defined yet".
-->

[No application modules defined yet]

OR

| Module          | Purpose   | Location      |
| --------------- | --------- | ------------- |
| [MODULE_NAME_1] | [PURPOSE] | [FOLDER_PATH] |
| [MODULE_NAME_2] | [PURPOSE] | [FOLDER_PATH] |

---

## Application Features

<!--
  CRITICAL RULES:
  - ONLY document APPLICATION features that actually exist in code
  - DO NOT document framework features (agents, templates, scripts)
  - DO NOT document hypothetical or example features
  - If NO features found, state "No features implemented yet"
-->

[No features implemented yet]

OR

### [FEATURE_NAME_1]

- **Location**: [FILE_OR_FOLDER_PATH]
- **Description**: [WHAT_IT_DOES]
- **Layer**: [API_SERVICE_DOMAIN_INFRA]

### [FEATURE_NAME_2]

- **Location**: [FILE_OR_FOLDER_PATH]
- **Description**: [WHAT_IT_DOES]
- **Layer**: [API_SERVICE_DOMAIN_INFRA]

---

## Engineering Standards & Guidelines

<!--
  DO NOT repeat content from instruction files here.
  Instruction files are the source of truth - reference them instead.
  This follows DRY (Don't Repeat Yourself) principle.

  DO NOT add status tables showing whether instruction files exist.
  Just reference the files - users will see if they exist when they follow the links.
-->

All engineering principles, architecture guidelines, language standards, testing requirements, and infrastructure patterns are defined in the following instruction files:

### Core Guidelines

- **Engineering Principles**: See [.apex/instructions/engineering/engineering-guidelines.md](.apex/instructions/engineering/engineering-guidelines.md)
  - Code quality standards, testing requirements, code review checklist, documentation expectations, Git workflow

- **Architecture Guidelines**: See [.apex/instructions/architecture/architecture-guidelines.md](.apex/instructions/architecture/architecture-guidelines.md)
  - Architecture principles, patterns, technology decisions, security architecture, disaster recovery

- **Language & Coding Standards**: See [.apex/instructions/languages/language-guidelines.md](.apex/instructions/languages/language-guidelines.md)
  - Language-specific conventions for Python, JavaScript/TypeScript, Java, Go, SQL

- **Infrastructure Standards**: See [.apex/instructions/infra/infrastructure-guidelines.md](.apex/instructions/infra/infrastructure-guidelines.md)
  - Environment management, deployment strategies, monitoring, logging, network security

- **Testing Guidelines**: See [.apex/instructions/testing/testing-guidelines.md](.apex/instructions/testing/testing-guidelines.md)
  - Testing strategy, unit/integration/E2E testing, performance testing, coverage goals

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

1. **ALWAYS** check `.apex-ignore` before analyzing repository
2. **ALWAYS** exclude paths matching `.apex-ignore` patterns
3. **NEVER** mention ignored paths in any artifacts
4. **ONLY** document application code (not framework/tooling)

### Code Generation

1. **READ** architecture guidelines from `.apex/instructions/architecture/` before generating code
2. **READ** language standards from `.apex/instructions/languages/` before generating code
3. **VALIDATE** against engineering principles from `.apex/instructions/engineering/`
4. **RESPECT** existing architecture and module boundaries

### Quality Assurance

1. **ENFORCE** testing requirements defined in `.apex/instructions/testing/`
2. **VALIDATE** infrastructure changes against `.apex/instructions/infra/`
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
