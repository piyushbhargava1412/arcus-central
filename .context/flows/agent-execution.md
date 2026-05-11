# Flow: Agent Execution

## Entry Points

- **Copilot Agent Picker**: User invokes `/sdd.specify`, `/sdd.plan`, `/sdd.analyze`, etc. from IntelliJ Copilot tab
- **Agent Tab**: Agent appears in dropdown because:
  - `integrate.sh` copied agent definitions to `.github/agents/*.agent.md`
  - IntelliJ discovers agents from this directory
  - Files are read-only (chmod 444) to prevent accidental modification

## Core Path

### 1. Agent Discovery & Loading
- Copilot reads agent metadata from `.github/agents/<agent-name>.agent.md`
- Agent file contains:
  - `description`: What the agent does
  - `Role`: The agent's persona/responsibility
  - `Scope`: Input artifacts, output artifacts, out-of-scope items
  - `Delegation Model`: Which skills to call and in what order

### 2. Context Loading (Agent Bootstrap)
- Agent calls `core/session-bootstrap` skill
- Bootstrap loads:
  - `.context/repo_scope.md` (repository business scope)
  - `.context/repo_map.md` (technical topology)
  - `.context/flows/*.md` (business flows)
  - `.context/testing-patterns.md` (testing conventions)
  - `.arcus/templates/` and `.arcus/guidelines/` (if needed)
  - `.github/copilot-instructions.md` (optional repo-local guardrails)

### 3. User Input Processing
- Agent receives user input (feature description, requirement, etc.)
- Input is specific to agent role:
  - `sdd.specify`: Feature description → specification
  - `sdd.plan`: Specification → project plan
  - `sdd.analyze`: Code scope → technical analysis
  - `sdd.implement`: Plan + spec → implementation guide

### 4. Skill Delegation (Core Path)
- Agent does NOT perform work directly
- Agent orchestrates calls to reusable skills in sequence
- Each skill has inputs/outputs defined in `skills/**/SKILL.md`
- Example for `sdd.specify`:
  1. → `feature-context-pack-builder` (build story-local context)
  2. → `spec-authoring` (write specification)
  3. → `ambiguity-detection` (find gaps)
  4. → `quality-gates` (validate spec readiness)
  5. → `report-renderer` (format output)

### 5. Artifact Generation
- Skills produce artifacts:
  - Specifications: `.arcus/specs/<STORY-ID>/spec.md`
  - Plans: `.arcus/plans/<PLAN-ID>/plan.md`
  - Task breakdowns: `.arcus/tasks/<TASK-ID>/tasks.md`
  - Analysis reports: `.arcus/analysis/<ANALYSIS-ID>/report.md`
- Artifacts are markdown files checked into git

### 6. Output & Handoff
- Agent returns structured output:
  - Generated artifact (spec, plan, tasks, etc.)
  - Quality gates results (pass/fail/warnings)
  - Confidence metrics (if applicable)
  - Next recommended action

## Data Touchpoints

| Data                | Type | Direction | Purpose |
|---------------------|------|-----------|---------|
| Agent metadata      | Markdown | `.github/agents/` (read) | Defines agent behavior |
| User input          | Text | User → Agent | Feature/requirement/code to analyze |
| Repo scope context  | Markdown | `.context/repo_scope.md` (read) | Business boundaries, capabilities |
| Repo map context    | Markdown | `.context/repo_map.md` (read) | Technical structure, entry points |
| Flow definitions    | Markdown | `.context/flows/*.md` (read) | Business flows to respect |
| Testing patterns    | Markdown | `.context/testing-patterns.md` (read) | Test conventions to follow |
| Templates           | Markdown | `.arcus/templates/` (read) | Spec, plan, task, checklist templates |
| Guidelines          | Markdown | `.arcus/guidelines/` (read) | Engineering, architecture, testing guidelines |
| Generated artifacts | Markdown | `.arcus/specs/`, `.arcus/plans/`, etc. (write) | Specification, plans, tasks |
| Git history         | Git | Project `.git/` (read) | Optional: detect recent changes |

## Integrations

- **Copilot Integration**: Agent is discovered via `.github/agents/*.agent.md`
- **Skill System**: Agent delegates to 1+ skills via defined interfaces
- **Template System**: Agent uses templates from `.arcus/templates/`
- **Guidelines**: Agent applies guidelines from `.arcus/guidelines/`
- **Git**: Agent can read git history for context (optional; via skills)
- **Markdown Validation**: Agent calls quality gates to validate artifacts before handoff

## Scope

| Scope | Items |
|-------|-------|
| **Agents** | 10 agents: 7 core + 3 extension |
| **Skills Called** | Varies by agent; range 3-8 skills per execution |
| **Input Artifacts** | User input + `.context/` files + `.arcus/` resources |
| **Output Artifacts** | spec.md, plan.md, tasks.md, analysis reports, etc. |
| **Target Repo State** | Read-only (context loading) + write (artifact generation) |
| **Exclusions** | Does not modify source code, configuration files, or git .gitignore |

## Tests

- **Agent logic**: Each agent's delegation model is testable by simulating skill responses
- **Skill isolation**: Each skill has validation gates (quality-gates skill)
- **Integration**: End-to-end test: Run `/sdd.specify` with test input; validate spec.md output format
- **Context loading**: Verify `.context/*` files are correctly loaded and not required (graceful if missing)
- **Artifact validation**: Markdown validation ensures generated artifacts conform to templates

## Verification

**commit**: Unknown (agent system; not tied to specific commit)  
**confidence**: HIGH

Evidence:
- Agent definitions in `agents/core/` and `agents/extensions/` with explicit role, scope, delegation
- Skill registry in `skills/SKILLS_REGISTRY.md` documents all available skills
- `sdd.specify.agent.md` shows complete delegation model (7 steps)
- Templates in `templates/` match output structures
- Integration guide documents how IntelliJ discovers agents

---

## Related Flows

- [Skill Delegation](skill-delegation.md) — How agents call skills
- [Context Building](context-building.md) — How `.context/` files are created before agents run
- [Framework Integration](framework-integration.md) — How agents are distributed to target repos

