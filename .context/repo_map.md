# Repository Map: ARCUS SDD Central

**Generated**: April 29, 2026  
**Source**: Repository structure analysis  
**Confidence**: HIGH

---

## Overview

ARCUS Central is a Bash/Markdown-based framework distribution hub written entirely in shell scripts and Markdown documentation. It coordinates agents, skills, templates, and instruction architecture for spec-driven development workflows. The primary runtime is **Bash/zsh** for integration scripts; **Markdown** for all artifact definitions (agents, skills, prompts, templates, guidelines). No compiled code or traditional application entry point.

## Directory Structure

```
bigfin_arcus-central/
├── README.md                              # Project overview
├── ARCUS_INTEGRATION_GUIDE.md              # Integration guide & CLI reference
├── VERSION                                # Framework version (semantic)
│
├── agents/                                # Agent definitions (10 files)
│   ├── core/                              # Core agents (6)
│   │   ├── sdd.specify.agent.md           # Specification creation
│   │   ├── sdd.clarify.agent.md           # Requirement clarification
│   │   ├── sdd.plan.agent.md              # Project planning
│   │   ├── sdd.tasks.agent.md             # Task decomposition
│   │   ├── sdd.analyze.agent.md           # Technical analysis
│   │   └── sdd.implement.agent.md         # Implementation guidance
│   └── extensions/                        # Extension agents (4)
│       ├── sdd.context-builder.agent.md   # Repository context building
│       ├── sdd.groom.agent.md             # Story grooming
│       ├── sdd.instructions.agent.md      # Instruction architecture
│       └── sdd.close.agent.md             # Story closure, context refresh, archiving
│
├── skills/                                # Skill implementations (22 skills)
│   ├── foundation/
│   │   ├── repository-context-builder/    # Builds repo_scope.md + repo_map.md
│   │   └── test-pattern-discovery/        # Discovers testing patterns
│   ├── discovery/
│   │   └── flow-and-scope-discovery/      # Maps business flows
│   ├── context/
│   │   ├── feature-context-pack-builder/  # Builds story-local context
│   │   └── context-sync/                  # Detects and reconciles code/context drift
│   ├── artifact/
│   │   ├── artifact-modeling/
│   │   ├── artifact-patcher/
│   │   ├── markdown-generation/
│   │   └── markdown-validation/
│   ├── core/
│   │   ├── session-bootstrap/
│   │   ├── quality-gates/
│   │   └── report-renderer/
│   ├── session/
│   │   └── checkpoint-manager/            # Creates lightweight session checkpoints for resumption
│   ├── reasoning/
│   │   ├── coverage-analysis/
│   │   ├── dependency-analysis/
│   │   ├── design-synthesis/
│   │   └── work-decomposition/
│   ├── specialized/
│   │   ├── spec/
│   │   │   ├── spec-authoring/
│   │   │   └── ambiguity-detection/
│   │   └── execution/
│   │       ├── task-execution-controller/
│   │       └── progress-tracker/
│   ├── formatting/
│   │   └── format-enforcer/
│   └── interaction/
│       └── question-orchestration/
│
├── prompts/                               # Agent prompts (9 files)
│   ├── core/                              # Core prompts (6)
│   │   ├── sdd.specify.prompt.md
│   │   ├── sdd.clarify.prompt.md
│   │   ├── sdd.plan.prompt.md
│   │   ├── sdd.tasks.prompt.md
│   │   ├── sdd.analyze.prompt.md
│   │   └── sdd.implement.prompt.md
│   └── extensions/                        # Extension prompts (3)
│       ├── sdd.groom.prompt.md
│       ├── sdd.instructions.prompt.md
│       └── sdd.close.prompt.md
│
├── templates/                             # Document templates (11)
│   ├── spec-template.md
│   ├── plan-template.md
│   ├── tasks-template.md
│   ├── checklist-template.md
│   ├── user-story.template.md
│   ├── software-design-document.template.md
│   ├── agent-file-template.md
│   ├── instruction-template.md
│   ├── repo_scope.template.md
│   ├── repo_map.template.md
│   └── stories/
│       └── groom-story-template.md
│
├── guidelines/                          # Engineering guidelines (6 domains)
│   ├── architecture/
│   │   └── architecture-guidelines.md
│   ├── engineering/
│   │   ├── engineering-guidelines.md
│   │   └── clean-code-guidelines.md
│   ├── languages/
│   │   ├── language-guidelines.md
│   │   ├── java.md
│   │   ├── nodejs.md
│   │   └── python.md
│   ├── infra/
│   │   └── infrastructure-guidelines.md
│   ├── security/
│   │   └── security.md
│   └── testing/
│       ├── testing-guidelines.md
│       └── tdd-guidelines.md
│
├── scripts/bash/                          # Automation scripts (5)
│   ├── common.sh                          # Shared utilities
│   ├── check-prerequisites.sh              # System requirements check
│   ├── create-new-feature.sh               # Feature creation helper
│   ├── setup-plan.sh                       # Planning setup
│   └── update-agent-context.sh             # Agent context updater
│
├── registry/                              # Component registries
│   ├── AGENT_REGISTRY.md                  # Agent capabilities index
│   └── SKILLS_REGISTRY.md                 # Skill definitions index
│
├── docs/                                  # Supporting documentation
│   ├── parking_lot.txt
│   └── SDD-Flow-Diagram.md
│
├── .arcus/                                # Local symlinks (created on first setup)
│   ├── templates → ../../templates
│   ├── scripts → ../../scripts
│   └── guidelines → ../../guidelines
│
├── .github/                               # GitHub integration
│   ├── agents/                            # Read-only copies of agent files
│   ├── prompts/                           # Read-only copies of prompt files
│   └── skills/                            # Symlink to skills/
│
├── .arcus-ignore                          # Ignore patterns for agent analysis
├── .arcus-metadata.json                   # Integration state metadata
├── .editorconfig                          # Editor configuration
├── .gitignore                             # Git ignore rules
│
├── integrate.sh                           # Main integration script
├── install-cli.sh                         # CLI installer (installs arcus-integrate)
└── uninstall.sh                           # CLI uninstaller
```

## Tech Stack

| Category | Technology | Evidence                                                       |
|----------|-----------|----------------------------------------------------------------|
| **Primary Language** | Bash / zsh | `integrate.sh`, `install-cli.sh`, `scripts/bash/*`             |
| **Configuration Format** | Markdown (.md) | All agents, prompts, templates, skills, guidelines |
| **Scripting** | Python 3 | Path calculation during integration (relative path logic)      |
| **Version Control** | Git | `.git/` folder, `.gitignore`                                   |
| **Package Mgmt** | Shell PATH | `install-cli.sh` installs to `/usr/local/bin/arcus-integrate`  |
| **Documentation** | Markdown | README, ARCUS_INTEGRATION_GUIDE, all agent/skill/prompt docs   |

## Entry Points

| Entry Point | Type | File Path | Purpose |
|-------------|------|-----------|---------|
| `arcus-integrate` | Shell command | `install-cli.sh` → `/usr/local/bin/arcus-integrate` | CLI for framework integration |
| `integrate.sh` | Bash script | `integrate.sh` | Main integration logic (symlinks + copies) |
| `install-cli.sh` | Bash script | `install-cli.sh` | Installs CLI command globally |
| `uninstall.sh` | Bash script | `uninstall.sh` | Removes CLI command |
| `check-prerequisites.sh` | Bash script | `scripts/bash/check-prerequisites.sh` | Validates system requirements |

## Key Components

### Integration System

| Component | Type | File Path | Purpose |
|-----------|------|-----------|---------|
| Integration Script | Bash | `integrate.sh` | Orchestrates symlinks, copies, validation, metadata writing |
| CLI Installer | Bash | `install-cli.sh` | Makes `arcus-integrate` globally available |
| Validation Logic | Bash | `integrate.sh` phase 3 | Checks symlinks resolve; verifies read-only permissions |
| Metadata Writer | Bash | `integrate.sh` phase 4 | Records integration state in `.arcus-metadata.json` |

### Agent Definitions

| Component | Type | File Path | Purpose |
|-----------|------|-----------|---------|
| Agent Metadata | Markdown | `agents/core/*.agent.md` | Defines role, scope, delegation model |
| Agent Prompt | Markdown | `prompts/core/*.prompt.md` | System prompt for agent execution |

### Skill System

| Component | Type | File Path | Purpose |
|-----------|------|-----------|---------|
| Skill Metadata | Markdown | `skills/**/SKILL.md` | Defines skill name, inputs, outputs, processing rules, contract |
| Skill Registry | Markdown | `registry/SKILLS_REGISTRY.md` | Index of all available skills |

### Template Library

| Component | Type | File Path | Purpose |
|-----------|------|-----------|---------|
| Specification Template | Markdown | `templates/spec-template.md` | Template for specification documents |
| Plan Template | Markdown | `templates/plan-template.md` | Template for project plans |
| Task Template | Markdown | `templates/tasks-template.md` | Template for task breakdown |
| Repo Scope Template | Markdown | `templates/repo_scope.template.md` | Template for repository scope context |
| Repo Map Template | Markdown | `templates/repo_map.template.md` | Template for repository map context |

### Guidelines Architecture

| Component | Type | File Path | Purpose |
|-----------|------|-----------|---------|
| Engineering Standards | Markdown | `guidelines/engineering/engineering-guidelines.md` | Code quality, patterns, design principles |
| Clean Code | Markdown | `guidelines/engineering/clean-code-guidelines.md` | SOLID principles, code clarity, maintainability |
| Architecture Principles | Markdown | `guidelines/architecture/architecture-guidelines.md` | System design, modularity, scalability |
| Language Guidelines | Markdown | `guidelines/languages/language-guidelines.md` | Language-specific standards and idioms |
| Language-Specific Guides | Markdown | `guidelines/languages/java.md`, `nodejs.md`, `python.md` | Java, Node.js, Python idioms and patterns |
| Infrastructure Patterns | Markdown | `guidelines/infra/infrastructure-guidelines.md` | Deployment, configuration, infrastructure |
| Testing Standards | Markdown | `guidelines/testing/testing-guidelines.md` | Test writing, coverage, test-driven development |
| TDD Guidelines | Markdown | `guidelines/testing/tdd-guidelines.md` | Test-driven development practices |
| Security Standards | Markdown | `guidelines/security/security.md` | Security principles, threat modeling, secure coding |

### Configuration

| Config File | Purpose | File Path |
|-------------|---------|-----------|
| VERSION | Framework version (semantic) | `VERSION` |
| .arcus-ignore | Ignore patterns for repository analysis | `.arcus-ignore` |
| .editorconfig | Editor configuration | `.editorconfig` |
| .gitignore | Git ignore rules | `.gitignore` |

## Build & Run Commands

| Action | Command | Source |
|--------|---------|--------|
| **Integrate target repo** | `arcus-integrate` | `install-cli.sh` (installs to PATH) |
| **Integrate with options** | `arcus-integrate --sync` | `integrate.sh` |
| **Remove framework** | `arcus-integrate --remove` | `integrate.sh` |
| **Non-interactive mode** | `arcus-integrate --yes` | `integrate.sh` (CI/CD) |
| **Install CLI** | `./install-cli.sh` | Project root |
| **Uninstall CLI** | `./uninstall.sh` | Project root |
| **Check prerequisites** | `./scripts/bash/check-prerequisites.sh` | `scripts/bash/` |

## Observability

| Signal | Implementation | Evidence |
|--------|----------------|----------|
| **Logging** | Bash echo statements | `integrate.sh` writes status messages to stdout |
| **Error Handling** | Bash set -e, conditional checks | `integrate.sh` phase validation, error exit codes |
| **Metadata** | JSON metadata file | `.arcus-metadata.json` records integration state |
| **Tracing** | Script phases (0-4) | `integrate.sh` documented in ARCUS_INTEGRATION_GUIDE.md |
| **Validation** | Symlink resolution checks | Phase 3 validates all symlinks and permissions |

## Module / Package Map

| Module                      | Purpose | Key Files                                                      |
|-----------------------------|---------|----------------------------------------------------------------|
| **Integration**             | Distribute framework to target repos | `integrate.sh`, `install-cli.sh`, `.arcus-metadata.json`       |
| **Agent System**            | Define and coordinate SDD agents | `agents/`, `prompts/`, `registry/AGENT_REGISTRY.md`            |
| **Skill System**            | Implement reusable capabilities | `skills/`, `registry/SKILLS_REGISTRY.md`                       |
| **Template Library**        | Provide artifact templates | `templates/`, `templates/stories/`                             |
| **Guidelines Architecture** | Distribute guidelines | `guidelines/` (all subdirs)                                  |
| **Automation**              | Scripting and helpers | `scripts/bash/`                                                |
| **Documentation**           | Framework guides and examples | `README.md`, `ARCUS_INTEGRATION_GUIDE.md`, `docs/`, `registry/` |

## Notable Patterns

### Hybrid Distribution Strategy

- **Symlinks** for read-only templates, scripts, guidelines (instant updates)
- **Copied files** for agents/prompts (IntelliJ agent discovery limitation)
- **Editable `.arcus-ignore`** allows per-project customization (copied once, never overwritten)
- **File permissions** enforce immutability (`chmod 444` on copies; `chmod a-w` on central sources)

### Skill Delegation Model

Agents do not implement features directly; instead they **delegate to skills**:

```
Agent (orchestrator, stateless) → calls skill → skill performs work → returns result
```

Benefits: Testable in isolation; reusable across agents; easy to enhance or replace.

### Phase-Based Integration Script

Integration happens in distinct phases:

1. **Phase 0**: Set central files read-only
2. **Phase 0.5**: Clean existing (if --sync)
3. **Phase 1**: Create symlinks
4. **Phase 2**: Copy agent/prompt files (read-only)
5. **Phase 2.5**: Copy .arcus-ignore (if new)
6. **Phase 3**: Validate symlinks and permissions
7. **Phase 4**: Write metadata

Each phase has clear entry/exit conditions and validation gates.

### Evidence-Based Context Generation

Skills like `repository-context-builder` and `flow-and-scope-discovery` follow strict rules:

- Analyze only code evidence (directory structure, build files, entry points)
- Prefer omission over weak inference
- Assign confidence levels (HIGH/MEDIUM/LOW) to findings
- Stop short of speculative flow inference

---

## Scan Coverage

| Aspect | Status | Notes                                                      |
|--------|--------|------------------------------------------------------------|
| Language | ✅ Detected | Bash/zsh, Markdown, Python                                 |
| Build System | ✅ Detected | Bash scripts + Git                                         |
| Entry Points | ✅ Detected | Integration scripts, CLI command                           |
| Components | ✅ Detected | Agents, skills, templates, guidelines                      |
| Configuration | ✅ Detected | VERSION, .arcus-ignore, .arcus-metadata.json               |
| Tests | ❌ Not found | No unit test framework; validation via skill quality gates |
| APIs | ❌ Not found | CLI-based, not networked; no HTTP/gRPC                     |
| Databases | ❌ Not found | Stateless; manifests + git history only                    |
| Events | ❌ Not found | No event producers/consumers                               |

---

## Quick Navigation

### Getting Started

- [../README.md](../README.md) — Project overview
- [../ARCUS_INTEGRATION_GUIDE.md](../ARCUS_INTEGRATION_GUIDE.md) — Integration guide & CLI reference
- [../registry/AGENT_REGISTRY.md](../registry/AGENT_REGISTRY.md) — All agents & capabilities

### Agents (10 total)

**Core (6)**:
- [sdd.specify](../agents/core/sdd.specify.agent.md) — Create specifications
- [sdd.clarify](../agents/core/sdd.clarify.agent.md) — Clarify requirements
- [sdd.plan](../agents/core/sdd.plan.agent.md) — Create project plans
- [sdd.tasks](../agents/core/sdd.tasks.agent.md) — Break down into tasks
- [sdd.analyze](../agents/core/sdd.analyze.agent.md) — Technical analysis
- [sdd.implement](../agents/core/sdd.implement.agent.md) — Implementation guidance

**Extensions (4)**:
- [sdd.groom](../agents/extensions/sdd.groom.agent.md) — Story grooming
- [sdd.context-builder](../agents/extensions/sdd.context-builder.agent.md) — Context building
- [sdd.instructions](../agents/extensions/sdd.instructions.agent.md) — Instruction architecture
- [sdd.close](../agents/extensions/sdd.close.agent.md) — Story closure, context refresh, archiving

### Skills (22 total)

By category:
- **Foundation**: [repository-context-builder](../skills/foundation/repository-context-builder/SKILL.md), [test-pattern-discovery](../skills/foundation/test-pattern-discovery/SKILL.md)
- **Discovery**: [flow-and-scope-discovery](../skills/discovery/flow-and-scope-discovery/SKILL.md)
- **Context**: [feature-context-pack-builder](../skills/context/feature-context-pack-builder/SKILL.md), [context-sync](../skills/context/context-sync/SKILL.md)
- **Artifact**: [artifact-modeling](../skills/artifact/artifact-modeling/SKILL.md), [artifact-patcher](../skills/artifact/artifact-patcher/SKILL.md), [markdown-generation](../skills/artifact/markdown-generation/SKILL.md), [markdown-validation](../skills/artifact/markdown-validation/SKILL.md)
- **Core**: [session-bootstrap](../skills/core/session-bootstrap/SKILL.md), [quality-gates](../skills/core/quality-gates/SKILL.md), [report-renderer](../skills/core/report-renderer/SKILL.md)
- **Session**: [checkpoint-manager](../skills/session/checkpoint-manager/SKILL.md)
- **Reasoning**: [coverage-analysis](../skills/reasoning/coverage-analysis/SKILL.md), [dependency-analysis](../skills/reasoning/dependency-analysis/SKILL.md), [design-synthesis](../skills/reasoning/design-synthesis/SKILL.md), [work-decomposition](../skills/reasoning/work-decomposition/SKILL.md)
- **Specialized**: [spec-authoring](../skills/specialized/spec/spec-authoring/SKILL.md), [ambiguity-detection](../skills/specialized/spec/ambiguity-detection/SKILL.md), [task-execution-controller](../skills/specialized/execution/task-execution-controller/SKILL.md), [progress-tracker](../skills/specialized/execution/progress-tracker/SKILL.md)
- **Formatting**: [format-enforcer](../skills/formatting/format-enforcer/SKILL.md)
- **Interaction**: [question-orchestration](../skills/interaction/question-orchestration/SKILL.md)

### Templates (11 total)

- [spec-template.md](../.arcus/templates/spec-template.md) · [plan-template.md](../.arcus/templates/plan-template.md) · [tasks-template.md](../.arcus/templates/tasks-template.md) · [checklist-template.md](../.arcus/templates/checklist-template.md)
- [user-story.template.md](../templates/user-story.template.md) · [software-design-document.template.md](../templates/software-design-document.template.md) · [agent-file-template.md](../.arcus/templates/agent-file-template.md)
- [instruction-template.md](../.arcus/templates/instruction-template.md) · [repo_scope.template.md](../.arcus/templates/repo_scope.template.md) · [repo_map.template.md](../.arcus/templates/repo_map.template.md) · [stories/groom-story-template.md](../templates/stories/groom-story-template.md)

### Guidelines

- [Engineering](../.arcus/guidelines/engineering/engineering-guidelines.md) · [Architecture](../.arcus/guidelines/architecture/architecture-guidelines.md) · [Languages](../.arcus/guidelines/languages/language-guidelines.md) · [Infrastructure](../.arcus/guidelines/infra/infrastructure-guidelines.md) · [Testing](../.arcus/guidelines/testing/testing-guidelines.md)

---

## Directory Summary

| Directory | Contents | Files |
|-----------|----------|-------|
| `/agents/core` | Core SDD agents (specify, clarify, plan, tasks, analyze, implement) | 6     |
| `/agents/extensions` | Extension agents (context-builder, groom, instructions, close) | 4     |
| `/skills` | 22 reusable skills organized by capability domain (includes new session/checkpoint-manager) | 22    |
| `/prompts/core` | Prompts for core agents | 6     |
| `/prompts/extensions` | Prompts for extension agents | 4     |
| `/templates` | Artifact templates and scaffolds | 11    |
| `/guidelines` | Engineering, architecture, language, infra, security, testing guidelines (6 domains, 9 files) | 9     |
| `/scripts/bash` | Integration and automation scripts | 5     |
| `/registry` | Agent registry and skill registry | 2     |
| `/examples` | Example specs and output guide | 2     |

## Key Files

| File | Purpose |
|------|---------|
| `integrate.sh` | Distributes framework to target repos (symlinks for `.arcus/`, read-only copies for agents/prompts) |
| `install-cli.sh` | Installs `arcus-integrate` CLI command globally |
| `uninstall.sh` | Removes `arcus-integrate` CLI command from `/usr/local/bin/` |
| `.arcus-ignore` | Ignore patterns for agent analysis—copied to target repos on first integration |
| `ARCUS_INTEGRATION_GUIDE.md` | Full integration guide and CLI reference |
| `registry/AGENT_REGISTRY.md` | All agents, capabilities, and workflow |
| `registry/SKILLS_REGISTRY.md` | All skills, domains, and reusability analysis |

---

## See Also

- [repo_scope.md](repo_scope.md) — Business capabilities, component responsibilities, integration model
- [flows/](./flows/) — Key execution flows and orchestration patterns
- [testing-patterns.md](testing-patterns.md) — How framework components are validated

