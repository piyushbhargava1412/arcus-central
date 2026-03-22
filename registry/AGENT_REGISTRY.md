# Agent Registry

This file maintains a registry of all available agents, their capabilities, and usage information.

**Related**: See [SKILLS_REGISTRY.md](./SKILLS_REGISTRY.md) for available reusable skills.

---

## Core Agents (6)

### sdd.specify

- **File**: `agents/core/sdd.specify.agent.md`
- **Prompt**: `prompts/core/sdd.specify.prompt.md`
- **Command**: `/sdd.specify <feature description>`
- **Purpose**: Create or update a feature specification from a natural language description
- **Role**: Specification Architect
- **Key Capabilities**:
  - Feature description parsing and requirement extraction
  - Specification creation using `spec-template.md`
  - Quality validation checklist generation
  - Bounded clarification questions (max 3)
- **Skill Chain**:
  1. `core/session-bootstrap` - Initialize context
  2. `specialized/spec/spec-authoring` - Generate specification
  3. `specialized/spec/ambiguity-detection` - Detect unresolved decisions
  4. `core/quality-gates` - Validate completeness
  5. `core/report-renderer` - Report completion
- **Guardrails**: Respects `.github/copilot-instructions.md` if present in target repo

### sdd.clarify

- **File**: `agents/core/sdd.clarify.agent.md`
- **Prompt**: `prompts/core/sdd.clarify.prompt.md`
- **Command**: `/sdd.clarify`
- **Purpose**: Resolve high-impact ambiguities in specification with targeted questions
- **Role**: Requirements Clarification Specialist
- **Key Capabilities**:
  - Ambiguity detection and prioritization
  - One-question-at-a-time interactive loop
  - Safe specification patching with conflict detection
  - Bounded clarification (max 5 questions per session)
- **Skill Chain**:
  1. `core/session-bootstrap` - Initialize context
  2. `specialized/spec/ambiguity-detection` - Identify high-impact decisions
  3. `interaction/question-orchestration` - Interactive Q&A (reusable across agents)
  4. `artifact/artifact-patcher` - Apply answers to spec (reusable)
  5. `artifact/markdown-validation` - Validate spec syntax
  6. `core/report-renderer` - Report completion
- **Guardrails**: Respects `.github/copilot-instructions.md` if present

### sdd.plan

- **File**: `agents/core/sdd.plan.agent.md`
- **Prompt**: `prompts/core/sdd.plan.prompt.md`
- **Command**: `/sdd.plan`
- **Purpose**: Generate a comprehensive implementation plan from specification and requirements
- **Role**: Senior Software Architect
- **Key Capabilities**:
  - Semantic modeling of requirements
  - Design synthesis with trade-offs and decisions
  - Technology-agnostic architecture planning
  - Component-level responsibility mapping
- **Skill Chain**:
  1. `core/session-bootstrap` - Initialize context
  2. `artifact/artifact-modeling` - Build semantic model (reusable)
  3. `reasoning/design-synthesis` - Generate design sections (reusable)
  4. `core/quality-gates` - Validate plan completeness
  5. `artifact/markdown-validation` - Validate syntax
  6. `core/report-renderer` - Report completion
- **Guardrails**: Respects `.github/copilot-instructions.md` if present

### sdd.tasks

- **File**: `agents/core/sdd.tasks.agent.md`
- **Prompt**: `prompts/core/sdd.tasks.prompt.md`
- **Command**: `/sdd.tasks`
- **Purpose**: Generate an actionable, dependency-ordered task breakdown from design artifacts
- **Role**: Execution Decomposer
- **Key Capabilities**:
  - Phase-based task organization (Setup → Foundational → User Stories → Polish)
  - Strict checklist format with IDs, labels, and file paths
  - Parallel execution identification
  - Dependency graphing
- **Skill Chain**:
  1. `core/session-bootstrap` - Initialize context
  2. `artifact/artifact-modeling` - Build semantic model (reusable)
  3. `reasoning/work-decomposition` - Generate tasks (reusable)
  4. `reasoning/dependency-analysis` - Compute dependencies (reusable)
  5. `formatting/format-enforcer` - Normalize format (reusable)
  6. `core/quality-gates` - Validate completeness
  7. `core/report-renderer` - Report completion
- **Guardrails**: Respects `.github/copilot-instructions.md` if present

### sdd.analyze

- **File**: `agents/core/sdd.analyze.agent.md`
- **Prompt**: `prompts/core/sdd.analyze.prompt.md`
- **Command**: `/sdd.analyze`
- **Purpose**: Non-destructive cross-artifact consistency and quality analysis
- **Role**: Consistency Auditor
- **Key Capabilities**:
  - Requirement-to-task traceability analysis
  - Coverage gap identification
  - Duplication and ambiguity detection
  - Severity-based finding classification (CRITICAL / HIGH / MEDIUM / LOW)
- **Skill Chain**:
  1. `core/session-bootstrap` - Initialize context
  2. `artifact/artifact-modeling` - Build semantic models (reusable)
  3. `reasoning/coverage-analysis` - Analyze traceability (reusable)
  4. `formatting/format-enforcer` - Validate format (reusable)
  5. `core/report-renderer` - Report findings
- **Guardrails**: Respects `.github/copilot-instructions.md` if present

### sdd.implement

- **File**: `agents/core/sdd.implement.agent.md`
- **Prompt**: `prompts/core/sdd.implement.prompt.md`
- **Command**: `/sdd.implement`
- **Purpose**: Execute implementation by processing all tasks defined in tasks.md
- **Role**: Task Execution Conductor
- **Key Capabilities**:
  - Dependency-safe task execution
  - Phase-by-phase progression
  - Progress tracking with completion metrics
  - Pre-implementation readiness gating
- **Skill Chain**:
  1. `core/session-bootstrap` - Initialize context
  2. `reasoning/coverage-analysis` - Check readiness (reusable)
  3. `reasoning/work-decomposition` - Re-validate tasks (reusable)
  4. `reasoning/dependency-analysis` - Compute execution order (reusable)
  5. `specialized/execution/task-execution-controller` - Execute tasks
  6. `specialized/execution/progress-tracker` - Track progress
  7. `core/report-renderer` - Report completion
- **Guardrails**: Respects `.github/copilot-instructions.md` if present

---

## Extension Agents (3)

### sdd.groom

- **File**: `agents/extensions/sdd.groom.agent.md`
- **Prompt**: `prompts/extensions/sdd.groom.prompt.md`
- **Command**: `/sdd.groom <requirement>`
- **Purpose**: Transform broad requirements into implementation-ready user stories
- **Role**: Story Grooming Strategist
- **Key Capabilities**:
  - Unstructured requirement parsing
  - User story generation with acceptance criteria
  - Repository-context-aware story scoping
  - Story file naming and organization

### sdd.instructions

- **File**: `agents/extensions/sdd.instructions.agent.md`
- **Prompt**: `prompts/extensions/sdd.instructions.prompt.md`
- **Purpose**: Create or update the copilot instruction architecture and ensure governance sync
- **Role**: Governance Curator
- **Key Capabilities**:
  - Repository structure analysis (via `specialized/repository-analysis` skill)
  - Instruction discovery and classification
  - Cross-reference validation
  - Amendment tracking with semantic versioning
  - Dependent file synchronization
  
### sdd.repo-intelligence

- **File**: `agents/extensions/sdd.repo-intelligence.agent.md`
- **Prompt**: `prompts/extensions/sdd.repo-intelligence.prompt.md`
- **Command**: `/sdd.repo-intelligence [output-dir] [--map-only | --scope-only] [context hint]`
- **Purpose**: Generate `repo_map.md` (technical topology) and `repo_scope.md` (business ownership)
- **Role**: Repository Cartographer
- **Key Capabilities**:
  - Stack-agnostic language fingerprinting (13+ languages)
  - Architecture pattern classification
  - Contract discovery (OpenAPI, Protobuf, GraphQL, etc.)
  - Data ownership detection
  - Dependency mapping
  - Infrastructure detection

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
/sdd.implement           →  code + progress (execute tasks)
```

---

## Registry Statistics

| Category | Count |
|----------|-------|
| Core agents | 6 |
| Extension agents | 3 |
| **Total agents** | **9** |
| Reusable skills | 19 (see [SKILLS_REGISTRY.md](./SKILLS_REGISTRY.md)) |
| Templates | 10 |
| Prompts | 9 |

---

## See Also

- [SKILLS_REGISTRY.md](./SKILLS_REGISTRY.md) — Registry of all 19 reusable skills, organized by capability domain
- [../SKILLS_FOLDER_MIGRATION.md](../SKILLS_FOLDER_MIGRATION.md) — Migration guide from stage-based to capability-based folder structure
- [../SKILLS_REUSABILITY_MATRIX.md](../SKILLS_REUSABILITY_MATRIX.md) — Detailed cross-stage skill usage matrix
