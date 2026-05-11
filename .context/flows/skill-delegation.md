# Flow: Skill Delegation

## Entry Points

- **Agent Call**: Agent (orchestrator) invokes a skill with defined inputs
- **Skill Registry Lookup**: Agent consults `.github/skills/SKILLS_REGISTRY.md` to find appropriate skill for task

## Core Path

### 1. Skill Selection
- Agent identifies required capability (e.g., "build repository context")
- Looks up skill in registry: `skills/<category>/<skill-name>/SKILL.md`
- Verifies inputs/outputs match agent's needs

### 2. Skill Input Preparation
- Agent collects required inputs for skill
- Inputs may include:
  - Repository root path
  - Existing context files (repo_scope.md, repo_map.md)
  - User input/requirements
  - Configuration flags

### 3. Skill Execution
- Skill runs its processing logic:
  - **Analysis Skills**: Scan code, detect patterns, extract evidence
  - **Generation Skills**: Create artifacts (specs, plans, tasks)
  - **Validation Skills**: Check artifact quality, find ambiguities, verify test coverage
  - **Formatting Skills**: Ensure markdown/structure conforms to standards
  - **Synthesis Skills**: Combine inputs, make design decisions

### 4. Processing Rules Application
- Skill applies its defined processing rules from SKILL.md:
  - Evidence-based inference only (no speculation)
  - Confidence assignment (HIGH/MEDIUM/LOW)
  - Ignore patterns application (from `.arcus-ignore`)
  - Validation gates at each step

### 5. Output Generation & Validation
- Skill produces outputs defined in SKILL.md contract:
  - `.context/repo_scope.md` (from repository-context-builder)
  - `.context/repo_map.md` (from repository-context-builder)
  - `.context/flows/*.md` (from flow-and-scope-discovery)
  - `.context/testing-patterns.md` (from test-pattern-discovery)
  - `spec.md`, `plan.md`, `tasks.md` (from generation skills)
  - Quality gate reports (from quality-gates skill)

### 6. Result Return
- Skill returns structured result:
  - `status`: SUCCESS / FAILURE / PARTIAL
  - `output`: Generated artifact(s) or analysis results
  - `confidence`: HIGH / MEDIUM / LOW (if applicable)
  - `errors`: List of validation failures (if applicable)

### 7. Agent Result Handling
- Agent receives skill result
- On SUCCESS: Continues to next skill in delegation sequence
- On FAILURE/PARTIAL: May retry, ask user for clarification, or terminate
- After all skills complete: Agent returns final output to user

## Data Touchpoints

| Data | Type | Direction | Purpose |
|------|------|-----------|---------|
| Skill metadata | Markdown | `skills/` (read) | Skill definition + contract |
| Repository files | Files | Target repo (read) | Source to analyze |
| Ignore patterns | Config | `.arcus-ignore` (read) | Paths to exclude from analysis |
| Context files | Markdown | `.context/` (read/write) | Shared repository context |
| Generated artifacts | Markdown | Target repo (write) | Specs, plans, tasks, reports |
| Confidence metrics | Data | Skill result → Agent | Confidence levels (HIGH/MEDIUM/LOW) |
| Validation reports | Data | quality-gates → Agent | Pass/fail validation results |

## Integrations

- **Agent Orchestration**: Agent is the caller; skill is the worker
- **Markdown Validation**: Artifacts validated against templates by `markdown-validation` skill
- **Markdown Generation**: Output formatted by `markdown-generation` skill
- **Quality Gates**: Validation happens before artifact is finalized
- **Repository Analysis**: Skills may read `.arcus-ignore` to exclude paths
- **Template System**: Skills use templates from `.arcus/templates/` as structure guides

## Scope

| Scope | Items |
|-------|-------|
| **Skill Categories** | 10 categories: foundation, discovery, context, artifact, core, reasoning, specialized, formatting, maintenance, interaction |
| **Skill Count** | 20+ reusable skills |
| **Typical Agent Delegation** | 3-8 skills per agent execution (sequential) |
| **Skill Isolation** | Each skill is stateless; can be tested in isolation |
| **Input Variability** | Skills adapt to repository structure (no fixed assumptions) |
| **Output Variability** | Artifacts conform to templates but content varies by repository |

## Tests

- **Skill unit tests**: Each skill can be tested with mocked inputs/repository states
- **Integration tests**: Agent + skill delegation chain tested end-to-end
- **Validation gates**: Quality-gates skill ensures outputs meet quality standards
- **Markdown validation**: markdown-validation skill ensures format compliance
- **Evidence-based testing**: Test data includes real repository structures (no synthetic examples)

## Verification

**commit**: Unknown (skill system; not tied to specific commit)  
**confidence**: HIGH

Evidence:
- 20+ skill definitions in `skills/` with explicit inputs, outputs, processing rules
- Skill registry in `skills/SKILLS_REGISTRY.md` documents all skills
- Agent definitions show explicit delegation models (e.g., `sdd.specify.agent.md` lists 7 skill calls)
- Each skill has SKILL.md with processing rules, validation gates, failure modes
- Examples: `repository-context-builder`, `flow-and-scope-discovery`, `spec-authoring` show mature definitions

---

## Skill Categories

### Foundation Skills
- `repository-context-builder` → generates `.context/repo_scope.md` + `.context/repo_map.md`
- `test-pattern-discovery` → generates `.context/testing-patterns.md`

### Discovery Skills
- `flow-and-scope-discovery` → generates `.context/flows/*.md` (one per flow)

### Context Skills
- `feature-context-pack-builder` → builds story-specific context
- `context-refresh-from-implementation` → reconciles context after implementation

### Generation Skills
- `spec-authoring` → writes specification from requirements
- Implied skills for plan-authoring, task-authoring (not explicitly listed in file structure)

### Analysis Skills
- `coverage-analysis` → analyzes test coverage
- `dependency-analysis` → finds upstream/downstream dependencies
- `design-synthesis` → combines analysis inputs into design
- `work-decomposition` → breaks work into tasks

### Validation Skills
- `quality-gates` → validates artifact readiness (spec, plan, task, test coverage, etc.)
- `ambiguity-detection` → finds ambiguous requirements
- `markdown-validation` → checks format compliance
- `artifact-modeling` → ensures data structures match templates

### Utility Skills
- `markdown-generation` → formats output markdown
- `format-enforcer` → enforces style standards
- `artifact-patcher` → makes targeted edits to artifacts
- `session-bootstrap` → loads context before agent execution
- `report-renderer` → formats final output
- `task-execution-controller` → orchestrates task execution
- `question-orchestration` → manages user clarification sessions
- `context-drift-and-reconcile` → detects and reconciles stale context

---

## Related Flows

- [Agent Execution](agent-execution.md) — How agents orchestrate skills
- [Context Building](context-building.md) — How repository-context-builder and flow-and-scope-discovery skills work
- [Framework Integration](framework-integration.md) — How skills become available in target repos

