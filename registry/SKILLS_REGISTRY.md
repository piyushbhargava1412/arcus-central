# Skills Registry

This file maintains a registry of all available reusable skills, organized by capability domain and cross-stage usage.

**Related**: See [AGENT_REGISTRY.md](./AGENT_REGISTRY.md) for agent discovery and workflow information.

---

## Overview

The SDD framework provides **19 reusable skills** organized by capability domain. Skills are stage-agnostic, meaning they can be used by multiple agents across the SDD lifecycle.

**Reusability Levels**:
- 🟢 **Core** (3 skills): Used by all or most agents
- 🟦 **Shared** (8 skills): Used by 2-4 agents
- 🟨 **Multi-Use** (2 skills): Used by 2-3 agents
- 🟪 **Specialized** (6 skills): Used by 1-2 agents (narrow context)

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
  - Build canonical feature directory path (`.apex/specs/<STORY-ID>/`)
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
- **Used By**: 3+ agents (extensions: `groom`, `instructions`, `repo-intelligence`)
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
- **Used By**: 2+ agents (`clarify`, `analyze`, extensions like `repo-intelligence`)
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

#### `specialized/execution/progress-tracker`

- **File**: `skills/specialized/execution/progress-tracker/SKILL.md`
- **Purpose**: Track and render implementation progress
- **Inputs**: `tasks_file`, `execution_log`
- **Outputs**: `progress_report`, `completion_metrics`
- **Used By**: 1 agent (`implement`)
- **Reusability**: ⭐ (1/5 agents - execution-specific)
- **Key Responsibilities**:
  - Count completed/failed/pending tasks
  - Compute completion percentages
  - Identify next actionable task
  - Render status report

### Repository Analysis Domain

#### `specialized/repository-analysis`

- **File**: `skills/specialized/repository-analysis/SKILL.md`
- **Purpose**: Analyze repository structure and apply ignore patterns
- **Inputs**: `repository_root`, `analysis_scope`
- **Outputs**: `repository_model`, `analysis_results`
- **Used By**: 2 extensions (`instructions`, `repo-intelligence`)
- **Reusability**: ⭐⭐ (2 extensions)
- **Key Responsibilities**:
  - Process `.apex-ignore` patterns
  - Traverse repository structure
  - Identify modules and patterns
  - Extract tech stack from code
  - Build evidence-backed analysis

---

## Skill Reusability Matrix

### By Domain

| Domain | Skills | Total Use | Avg Reuse |
|--------|--------|-----------|-----------|
| Core | 3 | 16 agent-calls | ⭐⭐⭐⭐⭐ |
| Artifact | 4 | 9 agent-calls | ⭐⭐⭐ |
| Reasoning | 4 | 8 agent-calls | ⭐⭐⭐⭐ |
| Interaction | 1 | 2+ agent-calls | ⭐⭐⭐ |
| Formatting | 1 | 2-3 agent-calls | ⭐⭐⭐ |
| Specialized | 6 | 8 agent-calls | ⭐ |

### By Agent

| Agent | Skills Used | Core | Artifact | Reasoning | Specialized |
|-------|-------------|------|----------|-----------|-------------|
| specify | 5 | 3 | - | - | 2 |
| clarify | 6 | 3 | 2 | - | 1 |
| plan | 6 | 3 | 1 | 1 | - |
| tasks | 7 | 3 | 1 | 3 | - |
| analyze | 5 | 3 | 1 | 1 | - |
| implement | 7 | 3 | - | 3 | 2 |

---

## Skills by Usage Level

### 🟢 Used by All Agents (3)
- `core/session-bootstrap` (6/6)
- `core/report-renderer` (6/6)
- `core/quality-gates` (4/6, universal validator)

### 🟦 Widely Reusable (8)
- `artifact/artifact-modeling` (3/5)
- `artifact/artifact-patcher` (2+/5)
- `artifact/markdown-generation` (3+)
- `artifact/markdown-validation` (2+/5)
- `reasoning/design-synthesis` (2/5)
- `reasoning/work-decomposition` (3/5)
- `reasoning/dependency-analysis` (3/5)
- `reasoning/coverage-analysis` (2/5)

### 🟨 Multi-Agent (2)
- `interaction/question-orchestration` (2+/5)
- `formatting/format-enforcer` (2-3/5)

### 🟪 Specialized/Narrow (6)
- `specialized/spec/spec-authoring` (1/5)
- `specialized/spec/ambiguity-detection` (1/5)
- `specialized/execution/task-execution-controller` (1/5)
- `specialized/execution/progress-tracker` (1/5)
- `specialized/repository-analysis` (2 extensions)

---

## Overall Statistics

| Metric | Value |
|--------|-------|
| **Total Skills** | 19 |
| **Reusable (used 2+ agents/stages)** | 13 (68%) |
| **Stage-specific/Narrow** | 6 (32%) |
| **Skills by domain** | 6 domains |
| **Total skill uses** | 40+ agent-skill connections |
| **Average skill reuse** | 2.1 agents per skill |

---

## See Also

- [AGENT_REGISTRY.md](./AGENT_REGISTRY.md) — Agent discovery and workflow information
