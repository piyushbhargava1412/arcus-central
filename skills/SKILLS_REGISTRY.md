# Skills Registry

## Quick Start: How ARCUS Skills Work

**For agents using skills:**

Skills are **reusable instruction sets** (markdown files) that you implement directly.

**When you see "implement skill X":**

1. **Find** the skill: Look up skill name in this registry (e.g., search for "repository-context-builder")
2. **Identify** the file path from the registry entry (e.g., `repository-context-builder/SKILL.md`)
3. **Construct** full path: `.github/skills/` + file path = `.github/skills/repository-context-builder/SKILL.md`
4. **Read** the SKILL.md file completely
5. **Implement**: Follow the Processing Rules section step-by-step yourself
   - Do NOT invoke tools, agents, or functions
   - Do NOT delegate — perform the work directly per the documented instructions
6. **Output**: Write results per the Output Contract section

**Key rule**: Skills are markdown documentation you implement, not agents you invoke.

---

## Overview

The SDD framework provides **23 reusable skills** organized by capability domain. Skills are stage-agnostic, meaning they can be used by multiple agents across the SDD lifecycle.

**Reusability Levels**:
- 🟢 **Core** (3 skills): Used by all or most agents
- 🟦 **Shared** (8 skills): Used by 2-4 agents
- 🟨 **Multi-Use** (5 skills): Used by 2-3 agents
- 🟪 **Specialized** (6 skills): Used by 1-2 agents (narrow context)

---

## Core Skills (🟢)

These skills are foundational and used by all or most agents across the SDD lifecycle.

### `session-bootstrap`

- **File**: `session-bootstrap/SKILL.md`
- **Purpose**: Resolve a story ID from user input or git branch and return canonical artifact and template paths for the current SDD stage
- **Inputs**: `user_input`, `repository_root`
- **Outputs**: `story_id`, `feature_dir`, `artifact_paths`, `template_paths`
- **Used By**: All core agents (`specify`, `clarify`, `plan`, `tasks`, `analyze`, `implement`, `close`)
- **Reusability**: ⭐⭐⭐⭐⭐ (7/7 agents)
- **Key Responsibilities**:
  - Extract story ID from user input (3-step cascade: explicit → git branch → ask user)
  - Build canonical feature directory path (`.arcus/specs/<STORY-ID>/`)
  - Resolve template paths
  - Ensure deterministic path generation

### `report-renderer`

- **File**: `report-renderer/SKILL.md`
- **Purpose**: Render concise, deterministic stage completion reports for chat output with status, artifact paths, and next-step recommendations
- **Inputs**: `stage_name`, `output_paths`, `status`, `warnings`
- **Outputs**: `chat_report`
- **Used By**: All core agents (`specify`, `clarify`, `plan`, `tasks`, `analyze`, `implement`, `close`)
- **Reusability**: ⭐⭐⭐⭐⭐ (7/7 agents)
- **Key Responsibilities**:
  - Generate compact status summaries
  - Include artifact paths and readiness info
  - Preserve deterministic output format
  - Keep reports scannable and action-oriented

### `quality-gates`

- **File**: `quality-gates/SKILL.md`
- **Purpose**: Apply deterministic quality checks to spec, plan, or tasks artifacts with explicit pass/fail gate results and prioritised remediation items
- **Inputs**: `artifact`, `checklist_template`, `gate_profile`, `guardrails` (optional)
- **Outputs**: `checklist`, `gate_results`, `remediation_items`
- **Used By**: 3 agents (`specify`, `plan`, `tasks`)
- **Reusability**: ⭐⭐⭐⭐ (3 agents)
- **Gate Profiles**: `spec-gates`, `plan-gates`, `tasks-gates`
- **Key Responsibilities**:
  - Validate artifacts against stage-specific gate profiles
  - Read and validate `arcus-artifact-meta` block
  - Record pass/fail with evidence citations
  - Generate remediation items
  - Support bounded re-validation loops (max 3 passes)

---

## Artifact Operations Skills (🟦)

These skills handle artifact creation, modification, and validation.

### `artifact-modeling`

- **File**: `artifact-modeling/SKILL.md`
- **Purpose**: Build semantic models of artifacts for analysis and traceability
- **Inputs**: `artifacts`, `artifact_types`
- **Outputs**: `semantic_models`, `traceability_mappings`
- **Used By**: 3 agents (`plan`, `tasks`, `analyze`)
- **Reusability**: ⭐⭐⭐⭐ (3 agents)
- **Key Responsibilities**:
  - Extract entities from spec/plan/tasks
  - Build invertible traceability mappings
  - Assign stable identifiers
  - Create queryable indices for coverage analysis

### `artifact-patcher`

- **File**: `artifact-patcher/SKILL.md`
- **Purpose**: Apply patches into artifacts with conflict detection and audit trail
- **Inputs**: `artifact_draft`, `patches`, `patch_mappings`
- **Outputs**: `patched_artifact`, `change_log`
- **Used By**: 2+ agents (`clarify`, `plan`, extensions)
- **Reusability**: ⭐⭐⭐ (2+ agents)
- **Key Responsibilities**:
  - Locate and replace markers in artifacts
  - Detect conflicts with existing content
  - Preserve artifact structure
  - Maintain change audit trail

### `markdown-generation`

- **File**: `markdown-generation/SKILL.md`
- **Purpose**: Generate well-formatted markdown documents with correct structure, syntax, and readability for any ARCUS artifact type
- **Inputs**: `content`, `format_style`
- **Outputs**: `formatted_markdown`
- **Used By**: 4+ agents (`groom`, `instructions`, `close`, `context-builder`)
- **Reusability**: ⭐⭐⭐ (4+ agents)
- **Key Responsibilities**:
  - Create proper heading hierarchy
  - Format tables, lists, code blocks
  - Maintain markdown syntax validity
  - Apply consistent styling

### `markdown-validation`

- **File**: `markdown-validation/SKILL.md`
- **Purpose**: Validate markdown documents for structural integrity, syntax correctness, link validity, placeholder resolution, and formatting consistency
- **Inputs**: `artifact`, `validation_rules`
- **Outputs**: `validation_results`, `violations`
- **Used By**: 3+ agents (`clarify`, `analyze`, `close`, extensions)
- **Reusability**: ⭐⭐⭐ (3+ agents)
- **Key Responsibilities**:
  - Validate artifact structure against rules
  - Check file paths and links
  - Detect unresolved placeholders
  - Report violations with specific locations

---

## Reasoning & Decomposition Skills (🟦)

These skills handle design, decomposition, and analysis reasoning.

### `design-synthesis`

- **File**: `design-synthesis/SKILL.md`
- **Purpose**: Decompose requirements into comprehensive design with decisions and trade-offs
- **Inputs**: `requirements_context`, `constraints`, `guardrails`
- **Outputs**: `design_sections`, `design_decisions`
- **Used By**: 2 agents (`plan`, `analyze`)
- **Reusability**: ⭐⭐ (2 agents)
- **Key Responsibilities**:
  - Extract architectural concerns from requirements
  - Compose design sections (architecture, data, error handling, etc.)
  - Document design trade-offs with rationale
  - Validate design against guardrails

### `work-decomposition`

- **File**: `work-decomposition/SKILL.md`
- **Purpose**: Break down requirements and design context into concrete, independently actionable work items organized by phase and priority
- **Inputs**: `requirements`, `design_context`, `organization_model`, `guardrails`
- **Outputs**: `work_items`, `organization_structure`
- **Used By**: 3 agents (`tasks`, `analyze`, `implement`)
- **Reusability**: ⭐⭐⭐⭐ (3 agents)
- **Key Responsibilities**:
  - Extract work-driving elements (stories, features, components)
  - Organize by specified model (story-phase, component, priority)
  - Define unique IDs and clear scopes
  - Mark parallelizable items
  - Validate work item independence and testability

### `dependency-analysis`

- **File**: `dependency-analysis/SKILL.md`
- **Purpose**: Analyze work item relationships and compute execution order
- **Inputs**: `work_items`, `dependency_relationships`
- **Outputs**: `dependency_graph`, `execution_phases`, `parallel_opportunities`
- **Used By**: 3 agents (`tasks`, `analyze`, `implement`)
- **Reusability**: ⭐⭐⭐⭐ (3 agents)
- **Key Responsibilities**:
  - Parse dependency relationships
  - Build directed acyclic graph (DAG)
  - Identify execution phases
  - Detect parallel opportunities
  - Flag critical paths

### `coverage-analysis`

- **File**: `coverage-analysis/SKILL.md`
- **Purpose**: Analyze traceability between artifact levels and identify coverage gaps
- **Inputs**: `artifacts_models`, `severity_profile`
- **Outputs**: `coverage_matrix`, `gap_list`, `overlap_list`, `metrics`
- **Used By**: 2 agents (`analyze`, `implement`)
- **Reusability**: ⭐⭐ (2 agents)
- **Key Responsibilities**:
  - Map top-level items to lower-level items
  - Detect unmapped requirements (gaps)
  - Detect overmapped tasks (overlaps)
  - Score gaps by severity
  - Compute coverage metrics

---

## User Interaction Skills (🟨)

### `question-orchestration`

- **File**: `question-orchestration/SKILL.md`
- **Purpose**: Conduct interactive questioning one question at a time with recommendations, answer capture, and configurable iteration limits
- **Inputs**: `question_queue`, `max_questions`, `user_interaction_mode`
- **Outputs**: `answered_questions`, `response_mappings`
- **Used By**: 2+ agents (`clarify`, `instructions`)
- **Reusability**: ⭐⭐⭐ (2+ agents)
- **Key Responsibilities**:
  - Present one question at a time
  - Provide recommended answers with options
  - Capture and validate responses
  - Respect iteration limits
  - Map answers to artifact sections

---

## Output Formatting Skills (🟨)

### `format-enforcer`

- **File**: `format-enforcer/SKILL.md`
- **Purpose**: Validate and normalize artifact formatting against a provided schema
- **Inputs**: `artifact`, `format_schema`, `normalization_rules`
- **Outputs**: `normalized_artifact`, `format_violations`
- **Used By**: 2-3 agents (`tasks`, `analyze`, extensions)
- **Reusability**: ⭐⭐⭐ (2-3 agents)
- **Key Responsibilities**:
  - Validate structure against schema
  - Enforce required/optional fields
  - Normalize whitespace and formatting
  - Report violations with line numbers
  - Apply safe corrections

---

## Foundation & Discovery Skills (🟦)

These skills establish baseline repository context for all downstream operations.

### `repository-context-builder`

- **File**: `repository-context-builder/SKILL.md`
- **Purpose**: Build or refresh baseline repository context by analyzing repository structure and generating repo_scope.md and repo_map.md in .context/ using only code evidence
- **Inputs**: `repository_root`
- **Outputs**: `repo_scope`, `repo_map`
- **Used By**: 1 agent (`context-builder`)
- **Reusability**: ⭐⭐ (foundational to all operations)
- **Key Responsibilities**:
  - Generate `.context/repo_scope.md` with `arcus-context-meta` block
  - Generate `.context/repo_map.md` with `arcus-context-meta` block
  - Capture current git HEAD commit as `verification-commit`
  - Analyze repository structure and tech stack
  - Extract implementation evidence

### `test-pattern-discovery`

- **File**: `test-pattern-discovery/SKILL.md`
- **Purpose**: Analyze existing tests in a repository and persist shared testing conventions to .context/testing-patterns.md
- **Inputs**: `repository_root`, `repo_scope`, `repo_map`
- **Outputs**: `testing_patterns`
- **Used By**: 1 agent (`context-builder`)
- **Reusability**: ⭐⭐ (foundational)
- **Key Responsibilities**:
  - Identify test roots and frameworks
  - Capture recurring test conventions with evidence
  - Generate `.context/testing-patterns.md` with `arcus-context-meta` block

### `flow-and-scope-discovery`

- **File**: `flow-and-scope-discovery/SKILL.md`
- **Purpose**: Identify business flows from repository entry surfaces and persist each as a separate file in .context/flows/
- **Inputs**: `repo_scope`, `repo_map`
- **Outputs**: `flows`
- **Used By**: 1 agent (`context-builder`)
- **Reusability**: ⭐⭐ (discovery-specific)
- **Key Responsibilities**:
  - Identify key business flows from entry surfaces
  - Map flows to implementation scope
  - Persist each flow as separate file in `.context/flows/` with `arcus-context-meta` block
  - Keep flows small, specific, and independently readable

---

## Session Management Skills (🟨)

These skills manage session state and context persistence across multiple work sessions.

### `checkpoint-manager`

- **File**: `checkpoint-manager/SKILL.md`
- **Purpose**: Create lightweight workflow-native checkpoints to resume work across multiple sessions without reloading full context
- **Inputs**: `story_id`, `current_stage`, `workflow_name` (optional), `tasks_file_path` (optional), `execution_summary`, `position_snapshot` (optional), `progress_items` (optional), `resume_hint` (optional), `checkpoint_metrics` (optional), `artifacts_updated` (optional), `last_completed_task_id` (optional), `blockers`, `last_commit_hash` (optional)
- **Outputs**: `checkpoint_file_path`, `checkpoint_token_estimate`, `checkpoint_stage`
- **Used By**: Core and extension agents including `specify`, `clarify`, `plan`, `implement`, `analyze`, `close`, and `afk`
- **Reusability**: ⭐⭐⭐⭐⭐ (multi-workflow)
- **Key Responsibilities**:
  - Create workflow-native lightweight checkpoints (< 500 tokens)
  - Capture current position, progress signals, blockers, and next steps
  - Support resumption across arbitrary workflows and stage labels
  - Enable ~300-token context reload vs ~8K full artifact reload
  - Provide deterministic, human-readable checkpoint content
  - Integrate with session-bootstrap for checkpoint loading at session start

---

## Context Skills (🟨)

These skills manage feature-specific context and keep shared context aligned with code.

### `feature-context-pack-builder`

- **File**: `feature-context-pack-builder/SKILL.md`
- **Purpose**: Build minimal story-specific context pack from shared `.context/` artifacts
- **Inputs**: `story_description`, `story_id`
- **Outputs**: `context_pack`
- **Used By**: `specify` (and indirectly all downstream agents via context-pack)
- **Reusability**: ⭐⭐⭐ (multi-stage usage)
- **Key Responsibilities**:
  - Select 1-2 relevant flows from `.context/flows/`
  - Extract relevant sections from `repo_scope.md` and `repo_map.md`
  - Build minimal story-scoped context pack
  - Write to `.arcus/specs/<STORY-ID>/context-pack.md`

### `context-sync`

- **File**: `context-sync/SKILL.md`
- **Purpose**: Detect and reconcile drift between code and shared `.context/` artifacts using git verification commits. Operates in repo-wide or story-scoped mode.
- **Inputs**: `repository_root`, `story_id` (optional), `context_pack` (optional)
- **Outputs**: `updated_context`
- **Used By**: 3 agents (`specify`, `analyze`, `close`)
- **Reusability**: ⭐⭐⭐ (3 agents, two modes)
- **Modes**:
  - **Repo-wide** (no `context_pack`): catches all changes since last verification — used by `sdd.specify`
  - **Story-scoped** (`context_pack` provided): targets only story-relevant changes — used by `sdd.analyze` and `sdd.close`
- **Key Responsibilities**:
  - Freshness check first — early exit if `verification-commit` matches HEAD
  - Compute git diff between `verification-commit` and `CURRENT_HEAD`
  - Classify changed files and detect impact on `.context/` artifacts
  - Update only impacted artifacts; refresh `arcus-context-meta` blocks

---

## Specialized Skills (🟪)

These skills are context-specific or narrow in scope, used by 1-2 agents.

### Specification Domain

#### `spec-authoring`

- **File**: `spec-authoring/SKILL.md`
- **Purpose**: Convert a natural language feature description into structured, technology-agnostic spec.md and requirements.md content
- **Inputs**: `feature_description`, `spec_template`, `context_pack` (optional), `guardrails` (optional)
- **Outputs**: `spec_sections`, `requirements_list`, `assumptions`
- **Used By**: 2 agents (`specify`, `groom`)
- **Reusability**: ⭐⭐ (2 agents)
- **Key Responsibilities**:
  - Extract actors, goals, constraints from feature description
  - Generate sections in order: User Scenarios → Requirements → Success Criteria → Edge Cases
  - Enforce technology-agnostic language (no stack/API/code details)
  - Record assumptions separately from spec body
  - Enforce spec/requirements.md boundary

#### `ambiguity-detection`

- **File**: `ambiguity-detection/SKILL.md`
- **Purpose**: Identify and prioritize unresolved requirement ambiguities
- **Inputs**: `spec_draft`, `assumptions`, `guardrails`
- **Outputs**: `clarification_markers`, `prioritized_questions`
- **Used By**: 2 agents (`specify`, `clarify`)
- **Reusability**: ⭐⭐ (2 agents)
- **Key Responsibilities**:
  - Scan for vague/conflicting statements
  - Prioritize by impact (scope > security > UX > technical)
  - Cap markers at 3 total
  - Convert to actionable questions

### Execution Domain

#### `task-execution-controller`

- **File**: `task-execution-controller/SKILL.md`
- **Purpose**: Execute approved tasks from tasks.md in strict phase order, respecting dependencies, and persisting progress atomically after each task
- **Inputs**: `tasks_list`, `dependency_graph`, `execution_policy`, `context_pack` (optional)
- **Outputs**: `completed_tasks`, `execution_log`, `errors`
- **Used By**: 1 agent (`implement`)
- **Reusability**: ⭐ (execution-specific)
- **Key Responsibilities**:
  - Execute phase-by-phase (Setup → Foundational → Stories → Polish)
  - Translate tasks into concrete actions (CREATE FILE, EDIT FILE, CREATE DIRECTORY, RUN COMMAND)
  - Enforce file ownership — no two parallel tasks write the same file
  - Mark completed tasks atomically in `tasks.md`
  - Handle failures gracefully per phase type

---

## Skill Reusability Matrix

### By Domain

| Domain | Skills | Agents Using | Avg Reuse |
|--------|--------|-------------|-----------|
| Core | 3 | 7 agents each | ⭐⭐⭐⭐⭐ |
| Artifact | 4 | 2-4 agents | ⭐⭐⭐ |
| Reasoning | 4 | 2-3 agents | ⭐⭐⭐ |
| Foundation | 2 | 1 agent (foundational) | ⭐⭐ |
| Discovery | 1 | 1 agent (foundational) | ⭐⭐ |
| Session | 1 | 7 agents (checkpoint recovery) | ⭐⭐⭐⭐⭐ |
| Context | 2 | 1-3 agents | ⭐⭐⭐ |
| Interaction | 1 | 2+ agents | ⭐⭐⭐ |
| Formatting | 1 | 2-3 agents | ⭐⭐⭐ |
| Specialized | 5 | 1-2 agents | ⭐ |

### By Agent

| Agent | Core | Artifact | Reasoning | Session | Context | Interaction | Formatting | Specialized |
|-------|:----:|:--------:|:---------:|:-------:|:-------:|:-----------:|:----------:|:-----------:|
| context-builder | 2 | 1 | - | - | 1 | - | - | 2 (foundation) |
| specify | 3 | - | - | 1 | 2 | - | - | 2 |
| clarify | 3 | 2 | - | 1 | - | 1 | - | 1 |
| plan | 3 | 1 | 1 | 1 | - | - | - | - |
| tasks | 3 | 1 | 3 | 1 | - | - | 1 | - |
| analyze | 3 | 1 | 2 | 1 | 1 | - | 1 | - |
| implement | 3 | - | 3 | 1 | - | - | - | 1 |
| groom | 2 | 2 | - | - | - | - | - | 1 |
| instructions | 2 | 2 | - | - | - | 1 | 1 | - |
| close | 3 | 2 | - | 1 | 1 | - | - | - |

---

## Skills by Usage Level

### 🟢 Used by All/Most Agents (4)
- `session-bootstrap` (all 10 agents)
- `report-renderer` (all 10 agents)
- `quality-gates` (3 core agents — spec, plan, tasks)
- `checkpoint-manager` (core + extension agents)

### 🟦 Widely Reusable (8)
- `artifact-modeling` (3 agents)
- `artifact-patcher` (2+ agents)
- `markdown-generation` (4+ agents)
- `markdown-validation` (3+ agents)
- `design-synthesis` (2 agents)
- `work-decomposition` (3 agents)
- `dependency-analysis` (3 agents)
- `coverage-analysis` (2 agents)

### 🟨 Multi-Agent Context & Formatting (5)
- `feature-context-pack-builder` (multi-stage)
- `context-sync` (3 agents, 2 modes)
- `question-orchestration` (2+ agents)
- `format-enforcer` (2-3 agents)
- `flow-and-scope-discovery` (1 agent, foundational)

### 🟪 Specialized/Narrow (5)
- `repository-context-builder` (foundational)
- `test-pattern-discovery` (foundational)
- `spec-authoring` (2 agents)
- `ambiguity-detection` (2 agents)
- `task-execution-controller` (1 agent)

---

## Overall Statistics

| Metric | Value |
|--------|-------|
| **Total Skills** | 22 |
| **Reusable (used by 2+ agents)** | 16 (73%) |
| **Specialized/Domain-Specific** | 5 (23%) |
| **Skills by domain** | 10 domains |
| **Agents covered** | 10 (6 core + 4 extensions) |

---

## Changelog

| Version | Change |
|---------|--------|
| Current | Moved registry to `skills/SKILLS_REGISTRY.md` for co-location with skills; updated File paths to be relative (no `skills/` prefix) |
| Current | Added "Quick Start: How ARCUS Skills Work" section at top of registry for runtime skill discovery |
| Current | Added `checkpoint-manager` skill and Session Management domain to enable lightweight workflow-native checkpoint creation and resumption across arbitrary workflows (~300 tokens vs ~8K full reload) |
| Current | Updated checkpoint-using agents across SDD and AFK workflows to integrate checkpoint-manager for session persistence |
| Current | Enhanced `session-bootstrap` with Rule 5 to load SESSION_CHECKPOINT.md at session start for automatic resumption |
| Current | Merged `context-drift-and-reconcile` + `context-refresh-from-implementation` → `context-sync` (two-mode unified skill) |
| Current | Removed `specialized/repository-analysis` (stale, unused) |
| Current | Added `sdd.close` agent to registry |
| Current | Added `test-pattern-discovery` (was missing from registry) |
| Current | Updated Purpose descriptions for 13 refactored skills to match skill-builder conventions |

---

## See Also

- [AGENT_REGISTRY.md](../registry/AGENT_REGISTRY.md) — Agent discovery and workflow information

