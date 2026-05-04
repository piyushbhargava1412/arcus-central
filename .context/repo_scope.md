# Repository Scope: ARCUS SDD Central

**Generated**: April 29, 2026  
**Source**: Repository structure analysis  
**Confidence**: HIGH

---

## Overview

ARCUS Central is the authoritative distribution hub for Spec Driven Development (SDD) framework components. It provides hardened agents, skills, prompts, templates, scripts, and instruction architecture that can be integrated into any target repository to enable spec-driven development workflows. This is a **framework distribution and orchestration hub**, not a business service.

## Strategic Objectives

ARCUS addresses critical challenges in agentic AI-driven development:

| Objective | Problem Solved | Mechanism |
|-----------|---|---|
| **Reduce Hallucinations** | LLMs generate plausible but incorrect information | Stage-driven workflows with quality gates; evidence-based context only |
| **Optimize Token Utilization** | Loading entire repository exhausts context windows | Selective context loading (only relevant `.context/` + story-specific pack) |
| **Improve Selective Context Loading** | Analysis paralysis from too much information | Repository-context-builder generates `.context/` boundaries; agents load only what's needed |
| **Enable Reliable Agentic Development** | Agents make unpredictable decisions without structure | 9-stage workflow with defined entry/exit criteria per stage |
| **Support Continuous Improvement** | Framework improves based on team feedback | Modular agent/skill design; easy to swap implementations |

## Business Capabilities

### Owned

- **SDD Framework Distribution**: Provides CLI command (`arcus-integrate`) to integrate standardized SDD framework into target repositories
- **Agent Architecture**: Develops, refines, and distributes 10 core and extension agents that guide specification, planning, analysis, and implementation workflows
- **Skills System**: Builds reusable, focused skill implementations that agents delegate to for specific capabilities (context building, flow discovery, analysis, code generation, etc.)
- **Template Library**: Maintains spec, plan, task, checklist, software design document, and story templates used across all integrated repositories
- **Instruction Architecture**: Curates engineering, architecture, language, infrastructure, and testing guidelines that can be inherited by target repositories
- **Registry & Discovery**: Maintains agent and skill registries that enable discovery, composition, and delegation
- **Integration Automation**: Provides bash scripts that handle symlink creation, read-only file copies, and framework lifecycle management across multiple target repositories
- **Documentation**: Documents framework structure, integration process, CLI usage, and agent capabilities for downstream teams

### Out of Scope

- **Business Service Implementation**: Does not implement any business domain logic (orders, payments, notifications, etc.)
- **Code Generation**: Does not generate production code directly (agents may guide implementation, but do not emit code)
- **CI/CD Pipeline Management**: Does not own pipeline definitions or deployment infrastructure
- **Data Storage/Persistence**: Does not own data models or databases
- **Event Production/Consumption**: Framework may reference event patterns used in target repos, but does not own event publishing infrastructure

## Component Architecture

### Agent System (10 agents)

| Agent | Role | Responsibility |
|-------|------|-----------------|
| `sdd.specify` | Specification Architect | Create specifications from feature descriptions |
| `sdd.clarify` | Requirements Clarifier | Clarify ambiguous requirements with stakeholders |
| `sdd.plan` | Project Planner | Create project plans and execution roadmaps |
| `sdd.tasks` | Task Decomposer | Break work into granular, testable tasks |
| `sdd.analyze` | Technical Analyst | Analyze technical scope and dependencies |
| `sdd.implement` | Implementation Guide | Guide implementation with architecture and patterns |
| `sdd.groom` | Story Groomer | Refine and prepare stories for intake |
| `sdd.context-builder` | Context Builder | Initialize or reset shared ARCUS repository context |
| `sdd.instructions` | Instruction Architect | Manage repository-specific guidelines and instruction context |
| `sdd.close` | Story Completion Steward | Generate completion summaries, refresh `.context/`, and archive story artifacts |

## Development Workflow Stages

ARCUS separates development into 9 stages, each with defined entry/exit criteria, applicable agents, and quality gates:

### Bootstrap Stages (One-Time Setup per Target Repo)

| Stage | Purpose | Agent | Artifacts | Frequency |
|-------|---------|-------|-----------|-----------|
| **1. Context Building** | Generate `.context/repo_scope.md`, `.context/repo_map.md`, `.context/flows/`, `.context/testing-patterns.md` | `sdd.context-builder` | `.context/repo_scope.md`, `.context/repo_map.md`, `.context/flows/*.md`, `.context/testing-patterns.md` | Once per repo (refresh if business/tech changes) |
| **2. Copilot Instructions** | Create `.github/copilot-instructions.md` with repo-specific guardrails | `sdd.instructions` | `.github/copilot-instructions.md` | Once per repo (update as guidelines evolve) |

### Story/Requirement Development Stages (per feature)

| Stage | Purpose | Agent | Input | Output | Quality Gate |
|-------|---------|-------|-------|--------|--------------|
| **3. Specify** | Create comprehensive specification from feature description | `sdd.specify` | Feature description + context + templates | `spec.md`, `requirements.md`, `context-pack.md` | Ambiguity detection; no TBDs |
| **4. Clarify** | Remove ambiguities and confirm interpretation with stakeholders | `sdd.clarify` | Spec + context | Updated spec, clarification notes | All questions answered |
| **5. Plan** | Break specification into phased execution plan | `sdd.plan` | Spec + context | `plan.md` with milestones | Plan is achievable in phases |
| **6. Tasks** | Decompose plan into granular, testable tasks | `sdd.tasks` | Plan + spec + context | `tasks.md` with acceptance criteria | All requirements traced to tasks |
| **7. Pre-Implementation Analyze** | Assess scope, dependencies, risks, estimated effort | `sdd.analyze` | Tasks + plan + spec + repo context | Analysis report | Dependencies identified; risks mitigated |
| **8. Implement** | Guided implementation with architectural patterns | `sdd.implement` | Analysis + tasks + guidelines | Implementation guide + code suggestions | Code passes quality gates |
| **9. Post-Implementation Analyze** | Verify completeness, coverage, align with spec; detect context drift and refresh if needed | `sdd.analyze` (re-run) | Implementation + spec + test results | Verification report + updated `.context/` (if drift detected) | All acceptance criteria met; context aligned |

### Stage Transitions

Stages flow sequentially; each stage's output feeds next stage's input. **No stage is skipped** — this ensures:

- ✅ Requirements are unambiguous before planning
- ✅ Plans are traceable to specifications
- ✅ Tasks are traceable to plans
- ✅ Implementation references tasks
- ✅ Verification covers all original requirements

---

### Skills System (22 reusable skills)

Organized by capability domain:

- **Foundation** (2): `repository-context-builder`, `test-pattern-discovery`
- **Discovery** (1): `flow-and-scope-discovery`
- **Context** (2): `feature-context-pack-builder`, `context-sync` (unified repo-wide and story-scoped modes)
- **Artifact** (4): `artifact-modeling`, `artifact-patcher`, `markdown-generation`, `markdown-validation`
- **Core** (3): `session-bootstrap`, `quality-gates`, `report-renderer`
- **Session** (1): `checkpoint-manager` — Enables lightweight session checkpoint creation and resumption across any SDD stage (~300 tokens vs ~8K full reload)
- **Reasoning** (4): `coverage-analysis`, `dependency-analysis`, `design-synthesis`, `work-decomposition`
- **Specialized** (5): `spec-authoring`, `ambiguity-detection`, `task-execution-controller`, `progress-tracker`
- **Formatting** (1): `format-enforcer`
- **Interaction** (1): `question-orchestration`

### Template Library (11 templates)

- `spec-template.md` - Specification template
- `plan-template.md` - Project plan template
- `tasks-template.md` - Task breakdown template
- `checklist-template.md` - Checklist template
- `user-story.template.md` - User story template
- `software-design-document.template.md` - SDD template
- `agent-file-template.md` - New agent template
- `instruction-template.md` - Instruction architecture template
- `repo_scope.template.md` - Repository scope template
- `repo_map.template.md` - Repository map template
- `stories/groom-story-template.md` - Groom story template

## Integration Model

### Distribution Strategy

| Artifact | Distribution Method | Mutability | Purpose |
|----------|---------------------|-----------|---------|
| `.arcus/templates/` | Symlink to central | Read-only | Templates shared across all integrated repos |
| `.arcus/guidelines/` | Symlink to central | Read-only | Guidelines shared across all integrated repos |
| `.arcus/scripts/` | Symlink to central | Read-only | Automation scripts shared across all integrated repos |
| `.github/agents/*.md` | Copy (chmod 444) | Read-only | IntelliJ agent discovery (symlinks not supported) |
| `.github/prompts/*.md` | Copy (chmod 444) | Read-only | SDD prompt definitions for agents |
| `.github/skills/` | Symlink | Read-only | Shared skill definitions |
| `.arcus-ignore` | Copy once | **Editable** | Per-project ignore patterns (never overwritten) |

### One-Way Flow

Central → Target repositories. Pull model — target repos invoke `arcus-integrate` command to sync latest framework.

- On first integration: Symlinks created, files copied, `.arcus-ignore` seeded
- On re-sync (`--sync`): Symlinks recreated, copies refreshed (`.arcus-ignore` preserved)
- On removal (`--remove`): Managed artifacts removed; `.arcus/guidelines/` preserved if referenced in `.github/copilot-instructions.md`

## Data Flows

### Framework Integration Flow

```
User (target repo) → arcus-integrate command → resolve central repo path
→ create symlinks (.arcus/) → copy agent/prompt files → copy .arcus-ignore
→ validate symlinks/permissions → write metadata → success
```

### Agent Execution in Target Repo

```
User → Copilot agent tab → Invoke /sdd.specify (or other agent)
→ Agent loads shared .context/repo_scope.md, .context/repo_map.md, .context/flows/*.md
→ Agent delegates to skills (via skill registry)
→ Skills perform analysis, generation, validation
→ Output spec.md, plan.md, tasks.md, or other artifacts
```

### Skill Delegation Pattern

```
Agent (orchestrator) → delegates to skill → skill analyzes/generates → returns result
Example: sdd.specify → feature-context-pack-builder → analyze repo state → return context pack
```

## Integration Surfaces

### External Interfaces

- **CLI Command**: `arcus-integrate` (shell command — installs to `/usr/local/bin/`)
- **Copilot Agent Picker**: Discovers agents from `.github/agents/*.agent.md` in integrated repos
- **Skill Registry**: Central `registry/SKILLS_REGISTRY.md` documents all available skills
- **Agent Registry**: Central `registry/AGENT_REGISTRY.md` documents all agents and their capabilities
- **Documentation**: README, ARCUS_INTEGRATION_GUIDE, STRUCTURE guide users through setup

### Configuration Files

- `.arcus-ignore`: Patterns to exclude during repository analysis
- `.arcus-metadata.json`: Metadata about integration state (version, timestamp, paths)
- `VERSION`: Framework version (semantic versioning)

## Non-Functional Characteristics

| Aspect | Value | Notes                                                                                                   |
|--------|-------|---------------------------------------------------------------------------------------------------------|
| **Distribution Model** | One-way (Central → Target) | Pull-based; target repos invoke integration command                                                     |
| **Synchronization** | Manual symlink re-creation | Requires explicit `--sync` flag; not automatic                                                          |
| **Scalability** | Unbounded | Same command works for 1 repo or 100+ repos                                                             |
| **Consistency** | Via symlinks | Changes in central propagate instantly to all repos (for symlinked content)                             |
| **Mutability** | Mostly read-only | Templates, guidelines, scripts immutable; `.arcus-ignore` editable per-project                          |
| **Durability** | ~Per-repo** | Integration metadata stored in `.arcus-metadata.json` and git history                                   |
| **Safety** | Write-protected | Read-only permissions (chmod 444 on files, chmod a-w on central source) prevent accidental modification |

## Dependencies

### Upstream (Framework Depends On)

- **Bash / zsh**: Shell scripting (integration scripts)
- **Python 3**: Relative path calculation during integration
- **Git**: Version control (for framework itself)
- **Markdown**: Documentation and template format

### Downstream (Target Repos Depend On Framework)

- All repositories integrated via `arcus-integrate` depend on:
  - Symlinks to central `.arcus/templates/`, `.arcus/scripts/`, `.arcus/guidelines/`
  - Copied agent/prompt files in `.github/agents/`, `.github/prompts/`
  - Skill definitions from `.github/skills/`
  - Context artifacts (`.context/repo_scope.md`, `.context/repo_map.md`, `.context/flows/`)

## Extensibility Points

- **New Agents**: Can be added to `agents/core/` or `agents/extensions/` and registered
- **New Skills**: Can be added to `skills/*/` and included in skill registry
- **New Templates**: Can be added to `templates/` and referenced by agents
- **New Guidelines**: Can be added to `guidelines/` and inherited by integrated repos
- **Prompts**: New prompts for agents can be added to `prompts/` and copied to target repos

---

## Confidence & Unknowns

### Confidently Inferred

| Aspect | Confidence | Evidence |
|--------|-----------|----------|
| Purpose (framework hub) | HIGH | README, STRUCTURE, INTEGRATION_GUIDE, agent definitions |
| Distribution model | HIGH | integrate.sh, install-cli.sh, ARCUS_INTEGRATION_GUIDE.md |
| Agent architecture | HIGH | agents/ folder structure, agent definitions with delegation models |
| Skills system | HIGH | skills/ folder with 20+ skills, each with SKILL.md definition |
| Integration command | HIGH | install-cli.sh, integrate.sh, arcus-integrate referenced throughout docs |
| Template system | HIGH | templates/ folder with 11 templates, referenced in agent specs |
| One-way sync flow | HIGH | ARCUS_INTEGRATION_GUIDE.md explicit about pull model and symlinks vs copies |

### Not Found (Checked but Absent)

- No unit tests detected for framework itself (skills/agents have internal validation gates, but no dedicated test suite)
- No event producers/consumers (framework is synchronous; does not produce/consume events)
- No database/persistence (framework is declarative; state lives in git + `.arcus-metadata.json`)
- No exposed REST/gRPC/HTTP APIs (framework is distributed via CLI, not networked)
- No non-functional SLAs documented (framework is development-time, not production-critical)

---

## See Also

- [repo_map.md](repo_map.md) — Technical topology, directory structure, tech stack
- [flows/](./flows/) — Key execution flows (integration, agent execution, skill delegation)
- [testing-patterns.md](testing-patterns.md) — How framework components are validated

