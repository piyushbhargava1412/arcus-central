# Skills Registry

This file maintains a registry of all available reusable skills, organized by capability domain and cross-stage usage.

**Quick Start**: See [Overview](#overview) for skill count and reusability metrics. Skills are documented by capability domain: [Core Skills](#core-skills-), [Artifact Operations](#artifact-operations-skills-), [Reasoning & Decomposition](#reasoning--decomposition-skills-), [Specialized Skills](#specialized-skills-), and others. Check [Skill Reusability Matrix](#skill-reusability-matrix) to understand which skills are core (used by multiple agents) vs specialized.

**For Developers**: Use this registry to find reusable skills, understand skill inputs/outputs, and see which agents use each skill.

**For Architects**: Check the reusability matrix to understand which skills are core (used by multiple agents) vs specialized (execution-specific).

**For Tools/Scripts**: This registry is machine-readable. Extract skill file paths and agent usage information to validate framework completeness.

**Related**: See [AGENT_REGISTRY.md](./AGENT_REGISTRY.md) for agent discovery and workflow information.

---

## Overview

The SDD framework provides **22 reusable skills** organized by capability domain. Skills are stage-agnostic, meaning they can be used by multiple agents across the SDD lifecycle.

**Reusability Levels**:
- 🟢 **Core** (3 skills): Used by all or most agents
- 🟦 **Shared** (8 skills): Used by 2-4 agents
- 🟨 **Multi-Use** (4 skills): Used by 2-3 agents
- 🟪 **Specialized** (8 skills): Used by 1-2 agents (narrow context)

---

## Core Skills (🟢)

These skills are foundational and used by all or most agents across the SDD lifecycle.

### `core/session-bootstrap`

- **File**: `skills/core/session-bootstrap/SKILL.md`
- **Purpose**: Initialize stage context and resolve canonical artifact/template paths
- **Inputs**: `user_input`, `repository_root`
- **Outputs**: `story_id`, `feature_dir`, `artifact_paths`, `template_paths`
- **Used By**: All 6 core agents (`specify`, `clarify`, `plan`, `tasks`, `analyze`, `implement`)
- **Reusability**: ⭐⭐⭐⭐⭐ (6/6 agents)
- **Key Responsibilities**:
  - Extract story ID from user input
  - Build canonical feature directory path (`.arcus/specs/<STORY-ID>/`)
  - Resolve template paths
  - Ensure deterministic path generation

### `core/report-renderer`

- **File**: `skills/core/report-renderer/SKILL.md`
- **Purpose**: Render concise, deterministic stage completion reports for chat output
- **Inputs**: `stage_name`, `output_paths`, `status`, `warnings`
- **Outputs**: `chat_report`
- **Used By**: All 6 core agents (`specify`, `clarify`, `plan`, `tasks`, `analyze`, `implement`)
- **Reusability**: ⭐⭐⭐⭐⭐ (6/6 agents)
- **Key Responsibilities**:
  - Generate compact status summaries
  - Include artifact paths and readiness info
  - Preserve deterministic output format
  - Keep reports scannable and action-oriented

### `core/quality-gates`

- **File**: `skills/core/quality-gates/SKILL.md`
- **Purpose**: Apply deterministic quality checks to stage artifacts with pass/fail results
- **Inputs**: `artifact`, `checklist_template`, `gate_profile`, `guardrails` (optional)
- **Outputs**: `checklist`, `gate_results`, `remediation_items`
- **Used By**: 4 agents (`specify`, `plan`, `tasks`, `analyze`)
- **Reusability**: ⭐⭐⭐⭐ (4/5 agents)
- **Key Responsibilities**:
  - Validate artifacts against stage-specific gates
  - Record pass/fail with evidence
  - Generate remediation items
  - Support bounded re-validation loops

---

## Artifact Operations Skills (🟦)

These skills handle artifact creation, modification, and validation.

### `artifact/artifact-modeling`

- **File**: `skills/artifact/artifact-modeling/SKILL.md`
- **Purpose**: Build semantic models of artifacts for analysis and traceability
- **Inputs**: `artifacts`, `artifact_types`
- **Outputs**: `semantic_models`, `traceability_mappings`
- **Used By**: 3 agents (`plan`, `tasks`, `analyze`)
- **Reusability**: ⭐⭐⭐⭐ (3/5 agents)
- **Key Responsibilities**:
  - Extract entities from spec/plan/tasks
  - Build invertible traceability mappings
  - Assign stable identifiers
  - Create queryable indices for coverage analysis

### `artifact/artifact-patcher`

- **File**: `skills/artifact/artifact-patcher/SKILL.md`
- **Purpose**: Apply patches into artifacts with conflict detection and audit trail
- **Inputs**: `artifact_draft`, `patches`, `patch_mappings`
- **Outputs**: `patched_artifact`, `change_log`
- **Used By**: 2+ agents (`clarify`, `plan`, extensions)
- **Reusability**: ⭐⭐⭐ (2+/5 agents, extends to `groom`)
- **Key Responsibilities**:
  - Locate and replace markers in artifacts
  - Detect conflicts with existing content
  - Preserve artifact structure
  - Maintain change audit trail

### `artifact/markdown-generation`

- **File**: `skills/artifact/markdown-generation/SKILL.md`
- **Purpose**: Generate well-formatted markdown documents with proper structure
- **Inputs**: `content`, `format_style`
- **Outputs**: `formatted_markdown`
- **Used By**: 3+ agents (extensions: `groom`, `instructions`, `context-builder`)
- **Reusability**: ⭐⭐⭐ (3+ agents, specialized use)
- **Key Responsibilities**:
  - Create proper heading hierarchy
  - Format tables, lists, code blocks
  - Maintain markdown syntax validity
  - Apply consistent styling

### `artifact/markdown-validation`

- **File**: `skills/artifact/markdown-validation/SKILL.md`
- **Purpose**: Validate markdown documents including paths, links, and quality
- **Inputs**: `artifact`, `validation_rules`
- **Outputs**: `validation_results`, `violations`
- **Used By**: 2+ agents (`clarify`, `analyze`, extensions)
- **Reusability**: ⭐⭐⭐ (2+/5 agents)
- **Key Responsibilities**:
  - Validate artifact structure against rules
  - Check file paths and links
  - Detect unresolved placeholders
  - Report violations with specific locations

---

## Reasoning & Decomposition Skills (🟦)

These skills handle design, decomposition, and analysis reasoning.

### `reasoning/design-synthesis`

- **File**: `skills/reasoning/design-synthesis/SKILL.md`
- **Purpose**: Decompose requirements into comprehensive design with decisions and trade-offs
- **Inputs**: `requirements_context`, `constraints`, `guardrails`
- **Outputs**: `design_sections`, `design_decisions`
- **Used By**: 2 agents (`plan`, `analyze`, potentially new stages)
- **Reusability**: ⭐⭐ (2/5 agents, extends to future stages)
- **Key Responsibilities**:
  - Extract architectural concerns from requirements
  - Compose design sections (architecture, data, error handling, etc.)
  - Document design trade-offs with rationale
  - Validate design against guardrails

### `reasoning/work-decomposition`

- **File**: `skills/reasoning/work-decomposition/SKILL.md`
- **Purpose**: Break requirements/design into concrete work items organized by phase/priority
- **Inputs**: `requirements`, `design_context`, `organization_model`, `guardrails`
- **Outputs**: `work_items`, `organization_structure`
- **Used By**: 3 agents (`tasks`, `analyze`, `implement`)
- **Reusability**: ⭐⭐⭐⭐ (3/5 agents)
- **Key Responsibilities**:
  - Extract work-driving elements (stories, features, components)
  - Organize by specified model (story-phase, component, priority)
  - Define unique IDs and clear scopes
  - Mark parallelizable items
  - Validate work item independence and testability

### `reasoning/dependency-analysis`

- **File**: `skills/reasoning/dependency-analysis/SKILL.md`
- **Purpose**: Analyze work item relationships and compute execution order
- **Inputs**: `work_items`, `dependency_relationships`
- **Outputs**: `dependency_graph`, `execution_phases`, `parallel_opportunities`
- **Used By**: 3 agents (`tasks`, `analyze`, `implement`)
- **Reusability**: ⭐⭐⭐⭐ (3/5 agents)
- **Key Responsibilities**:
  - Parse dependency relationships
  - Build directed acyclic graph (DAG)
  - Identify execution phases
  - Detect parallel opportunities
  - Flag critical paths

### `reasoning/coverage-analysis`

- **File**: `skills/reasoning/coverage-analysis/SKILL.md`
- **Purpose**: Analyze traceability between artifact levels and identify coverage gaps
- **Inputs**: `artifacts_models`, `severity_profile`
- **Outputs**: `coverage_matrix`, `gap_list`, `overlap_list`, `metrics`
- **Used By**: 2 agents (`analyze`, `implement`)
- **Reusability**: ⭐⭐ (2/5 agents)
- **Key Responsibilities**:
  - Map top-level items to lower-level items
  - Detect unmapped requirements (gaps)
  - Detect overmapped tasks (overlaps)
  - Score gaps by severity
  - Compute coverage metrics

---

## User Interaction Skills (🟨)

These skills handle user interaction patterns.

### `interaction/question-orchestration`

- **File**: `skills/interaction/question-orchestration/SKILL.md`
- **Purpose**: Conduct interactive questioning with recommendations and answer capture
- **Inputs**: `question_queue`, `max_questions`, `user_interaction_mode`
- **Outputs**: `answered_questions`, `response_mappings`
- **Used By**: 2+ agents (`clarify`, `analyze`, extensions like `context-builder`)
- **Reusability**: ⭐⭐⭐ (2+/5 agents)
- **Key Responsibilities**:
  - Present one question at a time
  - Provide recommended answers with options
  - Capture and validate responses
  - Respect iteration limits
  - Map answers to artifact sections

---

## Output Formatting Skills (🟨)

These skills handle output formatting and validation.

### `formatting/format-enforcer`

- **File**: `skills/formatting/format-enforcer/SKILL.md`
- **Purpose**: Validate artifact format against schema and normalize output
- **Inputs**: `artifact`, `format_schema`, `normalization_rules`
- **Outputs**: `normalized_artifact`, `format_violations`
- **Used By**: 2-3 agents (`tasks`, `analyze`, extensions)
- **Reusability**: ⭐⭐⭐ (2-3/5 agents)
- **Key Responsibilities**:
  - Validate structure against schema
  - Enforce required/optional fields
  - Normalize whitespace and formatting
  - Report violations with line numbers
  - Apply safe corrections

---

## Foundation & Discovery Skills (🟦)

These skills establish baseline repository context for all downstream operations.

### `foundation/repository-context-builder`

- **File**: `skills/foundation/repository-context-builder/SKILL.md`
- **Purpose**: Build or refresh baseline repository context by analyzing repository structure
- **Inputs**: `repository_root`
- **Outputs**: `repo_scope`, `repo_map`
- **Used By**: 1 agent (`context-builder`)
- **Reusability**: ⭐⭐ (foundational to all operations)
- **Key Responsibilities**:
  - Generate `.context/repo_scope.md`
  - Generate `.context/repo_map.md`
  - Analyze repository structure and tech stack
  - Extract implementation evidence
  - Build navigation artifacts for downstream agents

### `discovery/flow-and-scope-discovery`

- **File**: `skills/discovery/flow-and-scope-discovery/SKILL.md`
- **Purpose**: Identify business flows and map each flow to implementation scope
- **Inputs**: `repo_scope`, `repo_map`
- **Outputs**: `flows`
- **Used By**: 1 agent (`context-builder`)
- **Reusability**: ⭐⭐ (discovery-specific)
- **Key Responsibilities**:
  - Identify key business flows
  - Map flows to implementation scope
  - Persist each flow as separate file in `.context/flows/`
  - Document flow-to-feature relationships

---

## Context & Maintenance Skills (🟨)

These skills manage feature-specific context and detect/reconcile context drift.

### `context/feature-context-pack-builder`

- **File**: `skills/context/feature-context-pack-builder/SKILL.md`
- **Purpose**: Build minimal story-specific context pack from shared artifacts
- **Inputs**: `story_description`, `story_id`
- **Outputs**: `context_pack`
- **Used By**: Multiple agents (spec, plan, tasks phases)
- **Reusability**: ⭐⭐⭐ (multi-stage usage)
- **Key Responsibilities**:
  - Reference `.context/repo_scope.md`
  - Reference `.context/repo_map.md`
  - Reference `.context/flows/*.md`
  - Build story-specific context pack
  - Write to `.arcus/specs/<STORY-ID>/context-pack.md`

### `maintenance/context-drift-and-reconcile`

- **File**: `skills/maintenance/context-drift-and-reconcile/SKILL.md`
- **Purpose**: Detect and reconcile drift between code and shared context artifacts
- **Inputs**: `repository_root`
- **Outputs**: `updated_context`
- **Used By**: 1+ agent (start of story work)
- **Reusability**: ⭐⭐ (maintenance/lifecycle)
- **Key Responsibilities**:
  - Use verification commits and git diff
  - Detect changes to repository structure
  - Update impacted `.context/` files
  - Preserve context integrity
  - Minimize drift-introduced changes

---

## Specialized Skills (🟪)

These skills are context-specific or narrow in scope, used by 1-2 agents.

### Specification Domain

#### `specialized/spec/spec-authoring`

- **File**: `skills/specialized/spec/spec-authoring/SKILL.md`
- **Purpose**: Convert natural language into structured, technology-agnostic specifications
- **Inputs**: `feature_description`, `spec_template`, `guardrails`
- **Outputs**: `spec_sections`, `assumptions`
- **Used By**: 1 agent (`specify`)
- **Reusability**: ⭐ (1/5 agents - spec-specific)
- **Key Responsibilities**:
  - Extract actors, goals, constraints
  - Populate spec sections in template order
  - Capture defaults as assumptions
  - Keep language technology-agnostic

#### `specialized/spec/ambiguity-detection`

- **File**: `skills/specialized/spec/ambiguity-detection/SKILL.md`
- **Purpose**: Identify and prioritize unresolved requirement ambiguities
- **Inputs**: `spec_draft`, `assumptions`, `guardrails`
- **Outputs**: `clarification_markers`, `prioritized_questions`
- **Used By**: 1 agent (`clarify`)
- **Reusability**: ⭐ (1/5 agents - spec-specific)
- **Key Responsibilities**:
  - Scan for vague/conflicting statements
  - Prioritize by impact (scope > security > UX > technical)
  - Cap markers at 3 total
  - Convert to actionable questions

### Execution Domain

#### `specialized/execution/task-execution-controller`

- **File**: `skills/specialized/execution/task-execution-controller/SKILL.md`
- **Purpose**: Execute tasks in phase order respecting dependencies
- **Inputs**: `tasks_list`, `dependency_graph`, `execution_policy`
- **Outputs**: `completed_tasks`, `execution_log`, `errors`
- **Used By**: 1 agent (`implement`)
- **Reusability**: ⭐ (1/5 agents - execution-specific)
- **Key Responsibilities**:
  - Execute phase-by-phase
  - Respect dependencies
  - Mark completed tasks
  - Handle failures gracefully
  - Maintain execution log

---

## Skill Reusability Matrix

### By Domain

| Domain | Skills | Total Use | Avg Reuse |
|--------|--------|-----------|-----------|
| Core | 3 | 18 agent-calls | ⭐⭐⭐⭐⭐ |
| Artifact | 4 | 9 agent-calls | ⭐⭐⭐ |
| Reasoning | 4 | 8 agent-calls | ⭐⭐⭐⭐ |
| Foundation | 1 | 2 agent-calls | ⭐⭐ |
| Discovery | 1 | 2 agent-calls | ⭐⭐ |
| Context | 1 | 3+ agent-calls | ⭐⭐⭐ |
| Maintenance | 1 | 2+ agent-calls | ⭐⭐ |
| Interaction | 1 | 2+ agent-calls | ⭐⭐⭐ |
| Formatting | 1 | 2-3 agent-calls | ⭐⭐⭐ |
| Specialized | 6 | 8 agent-calls | ⭐ |

### By Agent

| Agent | Skills Used | Core | Artifact | Reasoning | Context | Specialized |
|-------|-------------|------|----------|-----------|---------|-------------|
| context-builder | 5 | 2 | 1 | - | 2 | - |
| specify | 5 | 3 | - | - | - | 2 |
| clarify | 6 | 3 | 2 | - | - | 1 |
| plan | 6 | 3 | 1 | 1 | - | - |
| tasks | 7 | 3 | 1 | 3 | - | - |
| analyze | 5 | 3 | 1 | 1 | - | - |
| implement | 7 | 3 | - | 3 | - | 2 |

---

## Skills by Usage Level

### 🟢 Used by All Agents (3)
- `core/session-bootstrap` (all agents)
- `core/report-renderer` (all agents)
- `core/quality-gates` (universal validator)

### 🟦 Widely Reusable (8)
- `artifact/artifact-modeling` (3 agents)
- `artifact/artifact-patcher` (2+ agents)
- `artifact/markdown-generation` (3+ agents)
- `artifact/markdown-validation` (2+ agents)
- `reasoning/design-synthesis` (2 agents)
- `reasoning/work-decomposition` (3 agents)
- `reasoning/dependency-analysis` (3 agents)
- `reasoning/coverage-analysis` (2 agents)

### 🟨 Multi-Agent Context & Formatting (4)
- `context/feature-context-pack-builder` (multi-stage)
- `interaction/question-orchestration` (2+ agents)
- `formatting/format-enforcer` (2-3 agents)
- `discovery/flow-and-scope-discovery` (1 agent, foundational)

### 🟪 Specialized/Narrow (8)
- `foundation/repository-context-builder` (foundational)
- `maintenance/context-drift-and-reconcile` (lifecycle)
- `specialized/spec/spec-authoring` (1 agent)
- `specialized/spec/ambiguity-detection` (1 agent)
- `specialized/execution/task-execution-controller` (1 agent)

---

## Overall Statistics

| Metric | Value |
|--------|-------|
| **Total Skills** | 22 |
| **Reusable (used 2+ agents/stages)** | 14 (64%) |
| **Specialized/Domain-Specific** | 8 (36%) |
| **Skills by domain** | 10 domains |
| **Total skill uses** | 50+ agent-skill connections |
| **Average skill reuse** | 2.2 agents per skill |

---

## See Also

- [AGENT_REGISTRY.md](./AGENT_REGISTRY.md) — Agent discovery and workflow information
