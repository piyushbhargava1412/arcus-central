# Agent Registry

This file maintains a registry of all available agents, their capabilities, and usage information.

## Core Agents (6)

### sdd.specify

- **File**: `agents/core/sdd.specify.agent.md`
- **Prompt**: `prompts/core/sdd.specify.prompt.md`
- **Command**: `/sdd.specify <feature description>`
- **Purpose**: Create or update a feature specification from a natural language description
- **Key Capabilities**:
  - Feature description parsing and requirement extraction
  - Specification creation using `spec-template.md`
  - Quality validation checklist generation
  - Clarification question formatting (max 3)

### sdd.clarify

- **File**: `agents/core/sdd.clarify.agent.md`
- **Prompt**: `prompts/core/sdd.clarify.prompt.md`
- **Command**: `/sdd.clarify`
- **Purpose**: Identify underspecified areas in a spec and encode answers back into the spec
- **Key Capabilities**:
  - Structured ambiguity & coverage scanning (11 categories)
  - Sequential interactive questioning (max 5 questions)
  - Recommended answers with reasoning
  - Incremental spec updates after each answer

### sdd.plan

- **File**: `agents/core/sdd.plan.agent.md`
- **Prompt**: `prompts/core/sdd.plan.prompt.md`
- **Command**: `/sdd.plan`
- **Purpose**: Generate a comprehensive implementation plan from spec and requirements
- **Key Capabilities**:
  - Technical context and design overview
  - Constitution alignment check
  - Component-level responsibility mapping
  - Error handling, observability, and rollout planning

### sdd.tasks

- **File**: `agents/core/sdd.tasks.agent.md`
- **Prompt**: `prompts/core/sdd.tasks.prompt.md`
- **Command**: `/sdd.tasks`
- **Purpose**: Generate an actionable, dependency-ordered task breakdown from design artifacts
- **Key Capabilities**:
  - Phase-based task organization (Setup → Foundational → User Stories → Polish)
  - Strict checklist format (checkbox + TaskID + priority + story label + file path)
  - Parallel execution marking
  - User story independence and independent test criteria

### sdd.analyze

- **File**: `agents/core/sdd.analyze.agent.md`
- **Prompt**: `prompts/core/sdd.analyze.prompt.md`
- **Command**: `/sdd.analyze`
- **Purpose**: Non-destructive cross-artifact consistency and quality analysis
- **Key Capabilities**:
  - Duplication, ambiguity, and underspecification detection
  - Constitution alignment validation
  - Coverage gap analysis (requirements ↔ tasks)
  - Severity-based finding classification (CRITICAL / HIGH / MEDIUM / LOW)

### sdd.implement

- **File**: `agents/core/sdd.implement.agent.md`
- **Prompt**: `prompts/core/sdd.implement.prompt.md`
- **Command**: `/sdd.implement`
- **Purpose**: Execute implementation by processing all tasks defined in tasks.md
- **Key Capabilities**:
  - Checklist-driven task execution with progress tracking
  - Pre-implementation checklist validation
  - Ignore file creation per detected tech stack
  - Phase-by-phase execution with dependency respect

---

## Extension Agents (3)

### sdd.groom
- **File**: `agents/extensions/sdd.groom.agent.md`
- **Prompt**: `prompts/extensions/sdd.groom.prompt.md`
- **Command**: `/sdd.groom <requirement>`
- **Purpose**: Transform broad business or technical requirements into structured, implementation-ready user stories
- **Key Capabilities**:
  - Unstructured requirement parsing
  - User story generation (8-section template)
  - Acceptance criteria definition
  - Repository-context-aware story scoping

### sdd.review

- **File**: `agents/extensions/sdd.review.agent.md`
- **Purpose**: Review specifications, code, and deliverables
- **Key Capabilities**:
  - Code review
  - Specification review
  - Quality review
  - Compliance review
  - Feedback generation

### sdd.instructions

- **File**: `agents/extensions/sdd.instructions.agent.md`
- **Reusable Skills**: Uses 3 reusable skills:
  - `repository-analysis/SKILL.md` - Repository analysis and ignore pattern processing (reusable by any agent)
  - `markdown-validation/SKILL.md` - Validate file paths, links, and markdown quality (reusable by any agent)
  - `markdown-generation/SKILL.md` - Format and structure markdown documents (reusable by any agent)
- **Deployment**: Skills deployed to `.github/skills/{skill-name}/SKILL.md` in target repos
- **Purpose**: Create or update the copilot instruction architecture and ensure all dependent components stay in sync with governance standards
- **Architecture**: Uses reusable skills for generic capabilities; instruction-specific procedures are inline in agent file
- **Key Capabilities**:
  - Repository structure analysis (via repository-analysis skill)
  - Ignore pattern processing (via repository-analysis skill)
  - Instruction file loading and parsing
  - Content classification and version management
  - Cross-reference validation (via markdown-validation skill)
  - Markdown formatting and generation (via markdown-generation skill)
  - Amendment log management
  - Semantic versioning (MAJOR/MINOR/PATCH)
  - Sync validation report generation
  - Dependent file updates
  - Cross-reference validation (via Validation Skills)
  - Sync validation reporting (via Output Generation Skills)
  - Amendment tracking with MAJOR/MINOR/PATCH versioning (via Version Management Skills)
  - Dependent file synchronization (via Documentation Skills)
- **Skills Categories**:
  1. Repository Analysis Skills
  2. Instruction Management Skills
  3. Validation Skills
  4. Documentation Skills
  5. Version Management Skills
  6. Output Generation Skills
  
### sdd.repo-intelligence
- **File**: `agents/extensions/sdd.repo-intelligence.agent.md`
- **Prompt**: `prompts/extensions/sdd.repo-intelligence.prompt.md`
- **Command**: `/sdd.repo-intelligence [output-dir] [--map-only | --scope-only] [context hint]`
- **Purpose**: Scan a repository and generate `repo_map.md` (technical topology) and `repo_scope.md` (ownership + interfaces) for onboarding and cross-repo reasoning
- **Key Capabilities**:
  - Stack-agnostic fingerprinting (13+ languages: Java, Node, Go, Python, C#, Rust, Ruby, PHP, Kotlin, Scala, etc.)
  - Entry point detection (Spring Boot, Lambda, CLI, main functions)
  - Architectural pattern classification (Domain, Application, API, Infrastructure, Events, Config, Shared)
  - Contract discovery (OpenAPI, Protobuf, GraphQL, Avro, AsyncAPI, JSON Schema)
  - Data ownership detection (JPA, EF Core, Django, Mongoose, Prisma, TypeORM, GORM, ActiveRecord)
  - Dependency mapping (imports + manifest parsing)
  - Infrastructure detection (Docker, CI/CD, Terraform, Helm, K8s, Serverless)
  - Evidence-based output with file path citations
  - Confidence & Unknowns reporting


---

## Agent Workflow

The typical SDD workflow follows this sequence:

```
/sdd.repo-intelligence  →  repo_map.md + repo_scope.md (repo onboarding)
        ↓
/sdd.groom              →  user stories (from broad requirements)
        ↓
/sdd.specify             →  spec.md (feature specification)
        ↓
/sdd.clarify             →  spec.md updated (ambiguities resolved)
        ↓
/sdd.plan                →  plan.md (implementation plan)
        ↓
/sdd.tasks               →  tasks.md (task breakdown)
        ↓
/sdd.analyze             →  analysis report (consistency check)
        ↓
/sdd.implement           →  code (execute tasks)
```

---

## File Counts

| Category | Count |
|----------|-------|
| Core agents | 6 |
| Extension agents | 3 |
| Core prompts | 6 |
| Extension prompts | 3 |
| Templates | 10 |
| **Total agent files** | **9** |
