# Copilot Instruction Architecture: [PROJECT_NAME]

**Version**: [VERSION_NUMBER]  
**Last Updated**: [DATE_ISO_FORMAT]  
**Framework**: [SDD_OR_FRAMEWORK_NAME]

<!--
  CRITICAL INSTRUCTIONS FOR GENERATING THIS FILE:

  1. RESPECT .apex-ignore:
     - Check for .apex-ignore file in project root
     - COMPLETELY EXCLUDE all matching files/folders from analysis
     - DO NOT mention ignored paths anywhere in this document
     - Treat ignored paths as if they don't exist

  2. NEVER ASSUME OR INVENT:
     - Only document features/modules that ACTUALLY exist in non-ignored code
     - If no features found, state "No features implemented yet" (don't use examples)
     - If no modules found, state "No modules defined" (don't use placeholders)
     - Empty sections should say "N/A" or "Not applicable" instead of fake data

  3. DOCUMENT REALITY:
     - This file reflects the ACTUAL state of the repository
     - Don't document framework features as if they're your application features
     - Don't assume architecture patterns that aren't implemented
-->

---

## Project Context

### Repository Summary

**[PROJECT_NAME]** is a [PROJECT_DESCRIPTION].

**Key Purpose**: [PRIMARY_BUSINESS_OBJECTIVE]

### Technology Stack

- **Languages**: [e.g., Python 3.11, TypeScript, Java 17]
- **Frameworks**: [e.g., FastAPI, React, Spring Boot]
- **Data Storage**: [e.g., PostgreSQL, MongoDB, DynamoDB or N/A]
- **Infrastructure**: [e.g., Docker, Kubernetes, AWS, GCP]
- **Testing Tools**: [e.g., pytest, Jest, JUnit]
- **Build/Deploy**: [e.g., GitHub Actions, GitLab CI, Jenkins]

### Architecture Style

**[ARCHITECTURE_CLASSIFICATION]** (e.g., monolith, microservices, modular monolith, layered, clean, etc.)

**Key Characteristics**:

- [CHARACTERISTIC_1]
- [CHARACTERISTIC_2]
- [CHARACTERISTIC_3]

### Key Modules

<!--
  CRITICAL: Only list modules that actually exist in non-ignored paths.
  If no modules found, state "No modules defined" or remove this section.
  Do NOT include paths matching .apex-ignore patterns.
-->

| Module          | Purpose   | Responsibility     |
| --------------- | --------- | ------------------ |
| [MODULE_NAME_1] | [PURPOSE] | [RESPONSIBLE_TEAM] |
| [MODULE_NAME_2] | [PURPOSE] | [RESPONSIBLE_TEAM] |
| [MODULE_NAME_3] | [PURPOSE] | [RESPONSIBLE_TEAM] |

---

## System Functionalities

<!--
  ACTION REQUIRED: Identify and document ALL implemented functionalities.

  CRITICAL RULES:
  - ONLY document features that actually exist in the codebase
  - NEVER assume, guess, or invent features (no examples, no placeholders)
  - EXCLUDE any files/folders matching .apex-ignore patterns
  - If NO features found in non-ignored paths, state: "No application features implemented yet"
  - If section is empty, remove the subsections below or use "N/A"

  For each ACTUAL system/feature found, capture:
  - Name and location (file/folder path in non-ignored areas)
  - What it does (description based on actual code)
  - Why it exists (responsibility)
  - Which layer it operates in (API, Service, Domain, Infrastructure, etc.)
  - Dependencies on other systems

  Do NOT document:
  - Files/folders matching .apex-ignore patterns
  - Hypothetical or example features
  - Framework/tooling features (unless they're part of your application)
-->

### Core Features

#### [FEATURE_NAME_1]

- **Location**: [FILE_OR_FOLDER_PATH]
- **Description**: [WHAT_IT_DOES]
- **Responsibility**: [WHO_OWNS_IT]
- **Layer**: [API_SERVICE_DOMAIN_INFRA_ETC]

#### [FEATURE_NAME_2]

- **Location**: [FILE_OR_FOLDER_PATH]
- **Description**: [WHAT_IT_DOES]
- **Responsibility**: [WHO_OWNS_IT]
- **Layer**: [API_SERVICE_DOMAIN_INFRA_ETC]

### Supporting Systems

#### [SYSTEM_NAME]

- **Location**: [FILE_OR_FOLDER_PATH]
- **Description**: [WHAT_IT_DOES]
- **Layer**: [INFRASTRUCTURE_TESTING_DEPLOYMENT_ETC]

---

## Engineering Principles

<!--
  ACTION REQUIRED: Define the non-negotiable values and constraints of this project.
  Each principle should have:
  - A P-level (P1=Non-negotiable, P2=Mandatory, P3=Recommended)
  - A clear definition
  - Specific rules (use MUST/SHOULD/MAY)
  - Rationale explaining why this principle matters
-->

### P1 - Non-Negotiable Principles

#### Principle 1: [PRINCIPLE_NAME]

**Definition**: [CLEAR_DEFINITION]

**Rules**:

- MUST [RULE_1]
- MUST [RULE_2]
- MUST NOT [VIOLATION]

**Rationale**: [WHY_THIS_MATTERS]

---

#### Principle 2: [PRINCIPLE_NAME]

**Definition**: [CLEAR_DEFINITION]

**Rules**:

- MUST [RULE_1]
- MUST NOT [VIOLATION]

**Rationale**: [WHY_THIS_MATTERS]

---

### P2 - Mandatory Principles

#### Principle 3: [PRINCIPLE_NAME]

**Definition**: [CLEAR_DEFINITION]

**Rules**:

- MUST [RULE_1]
- SHOULD [GUIDANCE]

**Rationale**: [WHY_THIS_MATTERS]

---

### P3 - Recommended Principles

#### Principle 4: [PRINCIPLE_NAME]

**Definition**: [CLEAR_DEFINITION]

**Rules**:

- SHOULD [GUIDANCE]
- MAY [OPTION]

**Rationale**: [WHY_THIS_MATTERS]

---

## Architecture Guidelines

### System Boundaries

<!--
  Define the major systems or modules and their boundaries.
  Use folder structure as the primary organizational principle.
  Define what each system owns and what it doesn't own.
-->

```
[PROJECT_ROOT]/
├── [MODULE_A]/          ← Owns: [RESPONSIBILITY]
├── [MODULE_B]/          ← Owns: [RESPONSIBILITY]
├── [MODULE_C]/          ← Owns: [RESPONSIBILITY]
└── shared/              ← Owns: [SHARED_RESPONSIBILITY]
```

### Module Interaction Rules

| From       | To         | Allowed | Reason   |
| ---------- | ---------- | ------- | -------- |
| [MODULE_A] | [MODULE_B] | ✅/❌   | [REASON] |
| [MODULE_B] | [MODULE_C] | ✅/❌   | [REASON] |

### Dependency Management Rules

- [MODULE_A] MUST NOT depend on [MODULE_B] (forward dependency violation)
- [MODULE_C] SHOULD depend on [INTERFACE] instead of [IMPLEMENTATION]
- Circular dependencies MUST NOT exist between [MODULE_X] and [MODULE_Y]
- All external dependencies MUST be declared in [DEPENDENCY_FILE]

### Layering Rules

**Layer 1: [LAYER_NAME]** (e.g., API, Presentation)

- Responsibility: [WHAT]
- Constraints: [WHAT_NOT]

**Layer 2: [LAYER_NAME]** (e.g., Business Logic, Service)

- Responsibility: [WHAT]
- Constraints: [WHAT_NOT]

**Layer 3: [LAYER_NAME]** (e.g., Data Access, Repository)

- Responsibility: [WHAT]
- Constraints: [WHAT_NOT]

### No Circular Dependencies

MUST NOT create circular dependencies:

- [MODULE_A] → [MODULE_B] → [MODULE_A] ❌
- [SYSTEM_X] → [SYSTEM_Y] → [SYSTEM_Z] → [SYSTEM_X] ❌

---

## Infrastructure Standards

### Deployment Model

**Environment Separation**:

| Environment | Purpose   | Deployment Strategy |
| ----------- | --------- | ------------------- |
| [ENV_NAME]  | [PURPOSE] | [HOW]               |
| [ENV_NAME]  | [PURPOSE] | [HOW]               |
| [ENV_NAME]  | [PURPOSE] | [HOW]               |

### Configuration Management

- **Environment Variables**: [WHICH_TOOL] for [WHICH_CONFIGS]
- **Secrets Storage**: [VAULT/TOOL] for [SENSITIVE_DATA]
- **Feature Flags**: [TOOL_OR_MECHANISM]
- **Database Migrations**: [TOOL] (e.g., Flyway, Alembic)

### Deployment Expectations

- **Build Pipeline**: [DESCRIPTION]
- **Test Before Deployment**: [MINIMUM_REQUIRED]
- **Rollback Strategy**: [HOW]
- **Health Checks**: [WHAT_TO_MONITOR]
- **Monitoring/Logging**: [WHICH_TOOLS]

---

## Language & Code Conventions

### Naming Conventions

- **Files**: [CONVENTION] (e.g., snake_case for Python, camelCase for JS)
- **Classes/Types**: [CONVENTION]
- **Functions/Methods**: [CONVENTION]
- **Constants**: [CONVENTION]
- **Folders**: [CONVENTION]

### Error Handling Rules

- MUST catch errors at [WHICH_LAYER]
- MUST log errors with [REQUIRED_INFORMATION]
- MUST NOT expose internal details to [EXTERNAL_CONSUMER]
- Recovery strategy: [HOW_TO_RECOVER]

### Testing Requirements

- **Unit Tests**: [COVERAGE_TARGET]% coverage required
- **Integration Tests**: MUST test [WHICH_INTERACTIONS]
- **End-to-End Tests**: MUST test [WHICH_USER_WORKFLOWS]
- **Test Framework**: [TOOL] (e.g., pytest, Jest, JUnit)
- **Test Location**: [FOLDER_CONVENTION]

### Logging Standards

- **Format**: [LOG_FORMAT] (e.g., JSON, plaintext)
- **Levels**: Use [LOG_LEVEL] for [USE_CASE]
- **What to Log**: [REQUIRED_INFORMATION]
- **What NOT to Log**: [SENSITIVE_DATA_NEVER]
- **Log Retention**: [TIME_PERIOD]

---

## Repository Governance

### Folder Responsibilities

| Folder        | Owner  | Responsibilities | Rules         |
| ------------- | ------ | ---------------- | ------------- |
| [FOLDER_PATH] | [TEAM] | [WHAT_THEY_OWN]  | [CONSTRAINTS] |
| [FOLDER_PATH] | [TEAM] | [WHAT_THEY_OWN]  | [CONSTRAINTS] |

### Ownership Boundaries

- **[OWNER_A]** owns all files in [FOLDER_A], responsible for [DECISIONS]
- **[OWNER_B]** owns all files in [FOLDER_B], responsible for [DECISIONS]
- Cross-ownership decisions: [HOW_TO_RESOLVE_CONFLICTS]

### Registry/Discovery Rules

- **Service Registry**: [LOCATION_OR_TOOL]
- **API Documentation**: [LOCATION] (e.g., `/docs`, OpenAPI)
- **Architecture Decisions**: [LOCATION] (e.g., `ADR/`, `docs/architecture/`)
- **Dependency Registry**: [LOCATION] (e.g., `go.mod`, `package.json`, `pom.xml`)

### Analysis Exclusions

**`.apex-ignore` File**: Controls which files/folders are excluded from repository analysis.

- **Location**: Project root (`.apex-ignore`)
- **Purpose**: Exclude build artifacts, dependencies, and irrelevant paths from structure analysis
- **Syntax**: Gitignore-style patterns (one per line, # for comments)
- **Common Exclusions**:
  - Dependencies: `node_modules/`, `vendor/`, `venv/`
  - Build outputs: `dist/`, `build/`, `target/`
  - VCS metadata: `.git/`, `.svn/`
  - IDE files: `.vscode/`, `.idea/`
- **Agent Behavior**: Instructions agent MUST respect .apex-ignore patterns when analyzing repository

### Amendment Procedure

When updating this instruction file:

1. **Identify Change Type**:
   - MAJOR: Principle removal, fundamental redefinition
   - MINOR: New principle, expanded guidance, new mandatory rule
   - PATCH: Clarification, wording fixes, typo corrections

2. **Version Bump**: Update header `**Version**: X.Y.Z`

3. **Date Update**: Set `**Last Updated**: [ISO_DATE]`

4. **Amendment Log**: Add entry to log below

5. **Sync Dependent Files**: Update all referenced files

6. **Communication**: Notify teams of changes

---

## Agent Behavioral Rules

### Golden Rule: Repository Awareness First

**CRITICAL**: This instruction file should reflect the ACTUAL state of the repository.

**BEFORE** generating any code, specification, or plan:

0. **Respect .apex-ignore**
   - Check for `.apex-ignore` in project root
   - Exclude ALL matching paths from analysis and documentation
   - Treat ignored paths as if they don't exist
   - NEVER mention ignored files/folders in this instruction file

1. **Read entire repository structure**
   - **Check for `.apex-ignore`**: If present, exclude matching patterns from analysis
   - Identify all modules, layers, and components (respecting ignore patterns)
   - Detect technology stack and existing patterns (from non-ignored files only)
   - Understand existing conventions and naming
   - Skip analysis of paths matching .apex-ignore patterns (e.g., node_modules/, dist/, .git/)
   - **If no application code found**: Document reality (don't assume features exist)

2. **Infer implicit contracts**
   - What does each folder own?
   - What dependencies already exist?
   - What patterns are being followed?

3. **Identify functional capabilities**
   - What features exist (do NOT guess)
   - Who owns each feature (responsibility)
   - How do features interact?

4. **Respect existing architecture**
   - MUST NOT violate defined boundaries
   - MUST NOT introduce circular dependencies
   - MUST NOT break separation of concerns
   - MUST follow existing naming and patterns

### Code Generation Rules

When creating code or specifications:

- **Validate against architecture**: Check boundary compliance before generation
- **Preserve contracts**: Respect defined module responsibilities
- **No speculative abstractions**: Only implement what's explicitly needed
- **Minimal code**: Avoid unnecessary abstractions or comments
- **Explicit over implicit**: Prefer clear contracts over implicit behavior

### Mandatory Validations

Before finalizing any artifact:

- [ ] No architectural boundaries violated
- [ ] No circular dependencies introduced
- [ ] No duplicate logic across modules
- [ ] All naming conventions followed
- [ ] All dependencies explicitly declared
- [ ] No speculative abstractions added
- [ ] Code is minimal and testable

### Escalation Rules

If a request would:

- Break module boundaries
- Introduce circular dependencies
- Violate the architecture
- Conflict with existing patterns

**STOP and EXPLAIN**:

1. The architectural violation
2. Why it's a problem
3. Compliant alternatives (if any)
4. Request confirmation before proceeding

---

## Amendment Log

| Version     | Date       | Change Summary | Type                |
| ----------- | ---------- | -------------- | ------------------- |
| [VERSION_1] | [DATE_ISO] | [SUMMARY]      | [MAJOR/MINOR/PATCH] |
| [VERSION_2] | [DATE_ISO] | [SUMMARY]      | [MAJOR/MINOR/PATCH] |

---

**Document Owner**: [OWNER_NAME_OR_TEAM]  
**Last Review**: [DATE_ISO]  
**Next Review**: [DATE_ISO]
