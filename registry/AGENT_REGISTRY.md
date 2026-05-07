# Agent Registry

This file maintains a registry of all available agents, their capabilities, and usage information.

**Quick Start**: Scroll to [Agent Workflow](#agent-workflow) to see the recommended SDD process sequence. Then find your starting agent in the [Core Agents](#core-agents-6) or [Extension Agents](#extension-agents-4) sections.

**For Developers**: Use this registry to discover agents, understand their roles, and see which skills each agent uses.

**For Tools/Scripts**: This registry is machine-readable. Extract agent file paths from the "File" field and skill chains from the delegation models.

**Related**: See [SKILLS_REGISTRY.md](./SKILLS_REGISTRY.md) for available reusable skills and reusability analysis.

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
  - Session checkpoint lookup/creation/update for resumption across sessions
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
  - Session checkpoint lookup/creation/update for resumption across sessions
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
  - Session checkpoint lookup/creation/update for resumption across sessions
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
  - Session checkpoint lookup/creation/update for resumption across sessions
- **Skill Chain**:
   1. `core/session-bootstrap` - Initialize context (load existing checkpoint if present)
   2. `artifact/artifact-modeling` - Build semantic models (reusable)
   3. `reasoning/coverage-analysis` - Analyze traceability (reusable)
   4. `formatting/format-enforcer` - Validate format (reusable)
   5. `session/checkpoint-manager` - Create session checkpoint for analysis resumption
   6. `core/report-renderer` - Report findings
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
  - Session checkpoint lookup/creation/update for resumption across sessions
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

## Extension Agents (4)

### sdd.context-builder

- **File**: `agents/extensions/sdd.context-builder.agent.md`
- **Prompt**: `prompts/extensions/sdd.context-builder.prompt.md`
- **Command**: `/sdd.context-builder`
- **Purpose**: Initialize or reset ARCUS shared repository context by generating `.context/repo_scope.md`, `.context/repo_map.md`, `.context/flows/`, and `.context/testing-patterns.md`
- **Role**: Context Bootstrapper
- **Key Capabilities**:
  - Repository structure analysis and evidence extraction
  - Repository scope and map generation (business + technical context)
  - Business flow discovery and mapping
  - Testing pattern identification
  - First-time ARCUS integration context bootstrap
  - Baseline reset after major structural changes
- **Skill Chain**:
  1. `core/session-bootstrap` - Initialize repository context
  2. `foundation/repository-context-builder` - Analyze repository and generate repo_scope.md + repo_map.md
  3. `discovery/flow-and-scope-discovery` - Discover business flows and generate flows/*.md files
  4. `foundation/test-pattern-discovery` - Analyze testing patterns and generate testing-patterns.md
  5. `core/quality-gates` - Validate context artifacts
  6. `core/report-renderer` - Report completion
- **Guardrails**: Respects `.github/copilot-instructions.md` if present. Applies `.arcus-ignore` patterns during analysis.

### sdd.groom

- **File**: `agents/extensions/sdd.groom.agent.md`
- **Prompt**: `prompts/extensions/sdd.groom.prompt.md`
- **Command**: `/sdd.groom <requirement>`
- **Purpose**: Transform broad requirements into implementation-ready user stories refined and prepared for intake
- **Role**: Story Grooming Strategist
- **Key Capabilities**:
  - Unstructured requirement parsing and intent extraction
  - User story generation with acceptance criteria and test scenarios
  - Repository-context-aware story scoping
  - Story file naming, organizing, and artifact generation
  - Dependency identification between stories
- **Guardrails**: Respects `.github/copilot-instructions.md` if present. Leverages `.context/repo_scope.md` and `.context/repo_map.md` for scoping.

### sdd.instructions

- **File**: `agents/extensions/sdd.instructions.agent.md`
- **Prompt**: `prompts/extensions/sdd.instructions.prompt.md`
- **Command**: `/sdd.instructions`
- **Purpose**: Create or update the copilot instruction architecture and ensure all dependent components stay in governance sync
- **Role**: Governance Curator
- **Key Capabilities**:
  - Repository structure analysis
  - Instruction discovery and classification
  - Cross-reference validation between guidelines
  - Amendment tracking with semantic versioning
  - Dependent file synchronization (ensures updates propagate)
  - Governance compliance checking
- **Guardrails**: Respects `.github/copilot-instructions.md` as canonical. Validates against `.arcus/guidelines/` baseline.

### sdd.close

- **File**: `agents/extensions/sdd.close.agent.md`
- **Prompt**: `prompts/extensions/sdd.close.prompt.md`
- **Command**: `/sdd.close`
- **Purpose**: Close a completed story by generating a completion summary, refreshing shared context, and archiving story artifacts
- **Role**: Story Completion Steward
- **Key Capabilities**:
  - Story completion summary generation
  - Story-scoped context refresh and drift detection
  - Artifact archival and housekeeping
  - Completion reporting with deferred items tracking
- **Skill Chain**:
  1. `core/session-bootstrap` - Resolve story ID and paths
  2. `context/context-sync` - Refresh impacted `.context/` artifacts (story-scoped)
  3. `artifact/markdown-generation` - Format completion summary
  4. `artifact/markdown-validation` - Validate summary structure
  5. `core/report-renderer` - Report closure and completion status
- **Guardrails**: Does NOT implement any code. Closure is optional; skipping does not break the pipeline. Context refresh failure does not prevent story archival.

---

## Agent Workflow


**Context Bootstrap** (one-time):
```
1. /sdd.context-builder    →  Initialize repository context (.context/)
2. /sdd.instructions       →  Create copilot instructions (.github/copilot-instructions.md)
```

**Development**
The typical SDD workflow follows this sequence:

```
/sdd.specify             →  spec.md (feature specification)
        ↓
/sdd.clarify             →  spec.md updated (ambiguities resolved)
        ↓
/sdd.plan                →  plan.md (implementation plan)
        ↓
/sdd.tasks               →  tasks.md (task breakdown)
        ↓
/sdd.analyze             →  analysis report (pre-implementation consistency check)
        ↓
/sdd.implement           →  code + progress (execute tasks)
        ↓
/sdd.analyze             →  analysis report (post-implementation verification)
        ↓
/sdd.close               →  completion summary + archived story (optional)
```


---

## Registry Statistics

| Category | Count |
|----------|-------|
| Core agents | 6 |
| Extension agents | 4 |
| **Total agents** | **10** |
| Reusable skills | 23 (see [SKILLS_REGISTRY.md](./SKILLS_REGISTRY.md)) — now includes session checkpoint management |
| Templates | 11 |
| Prompts | 10 |

---

## See Also

- [SKILLS_REGISTRY.md](./SKILLS_REGISTRY.md) — Registry of all 23 reusable skills, organized by capability domain with reusability matrices. Now includes session checkpoint management for multi-session resumption.
