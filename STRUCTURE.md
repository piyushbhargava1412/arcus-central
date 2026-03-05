# APEX SDD Framework — Repository Structure

**APEX** = Team name  
**SDD** = Spec Driven Development methodology  
**This repo** = Central distribution point for SDD framework components

## Repository Layout

```
otto_apex-central/
├── README.md                                      # Project overview
├── STRUCTURE.md                                   # This file — repo layout & quick links
├── APEX_INTEGRATION_GUIDE.md                      # Integration guide & CLI reference
├── VERSION                                        # Current version
├── integrate.sh                                   # Integration script (symlinks + read-only copies)
├── install-cli.sh                                 # CLI installer (apex-integrate command)
├── uninstall.sh                                   # CLI uninstaller (removes apex-integrate)
├── .apex-ignore                                   # Ignore patterns for sdd.instructions agent
├── .editorconfig                                  # Editor configuration
├── .gitignore                                     # Git ignore rules
│
├── agents/                                        # Agent definitions
│   ├── core/                                      # Core agents (7 files)
│   │   ├── sdd.specify.agent.md                   # Specification creation
│   │   ├── sdd.clarify.agent.md                   # Requirement clarification
│   │   ├── sdd.plan.agent.md                      # Project planning
│   │   ├── sdd.tasks.agent.md                     # Task decomposition
│   │   ├── sdd.analyze.agent.md                   # Technical analysis
│   │   ├── sdd.implement.agent.md                 # Implementation guidance
│   │   └── sdd.groom.agent.md                     # Story grooming (core)
│   │
   └── extensions/                                # Extension agents (3 files)
       ├── sdd.groom-story.agent.md               # Story grooming (extended)
       ├── sdd.instructions.agent.md              # Instruction architecture
       └── sdd.repo-intelligence.agent.md         # Repository intelligence
│
├── skills/                                        # Agent skills (skills-based abstraction)
│   └── instruction-architecture/             # Instruction architecture skill
│       └── SKILL.md                       # Skill definition (Copilot naming convention)
│
├── prompts/                                       # Agent prompts
│   ├── core/                                      # Core prompts (6 files)
│   │   ├── sdd.specify.prompt.md
│   │   ├── sdd.clarify.prompt.md
│   │   ├── sdd.plan.prompt.md
│   │   ├── sdd.tasks.prompt.md
│   │   ├── sdd.analyze.prompt.md
│   │   └── sdd.implement.prompt.md
│   │
│   └── extensions/                                # Extension prompts (3 files)
│       ├── sdd.groom.prompt.md
│       ├── sdd.instructions.prompt.md
│       └── sdd.repo-intelligence.prompt.md
│
├── templates/                                     # Reusable templates (9 files)
│   ├── spec-template.md                           # Specification template
│   ├── plan-template.md                           # Project plan template
│   ├── tasks-template.md                          # Task breakdown template
│   ├── checklist-template.md                      # Checklist template
│   ├── user-story.template.md                     # User story template
│   ├── software-design-document.template.md       # SDD template
│   ├── agent-file-template.md                     # New agent template
│   ├── instruction-template.md                    # Instruction architecture template
│   └── stories/
│       └── groom-story-template.md                # Groom story template
│
├── instructions/                                  # Best practices & guidelines
│   ├── engineering/
│   │   └── engineering-guidelines.md
│   ├── architecture/
│   │   └── architecture-guidelines.md
│   ├── languages/
│   │   └── language-guidelines.md
│   ├── infra/
│   │   └── infrastructure-guidelines.md
│   └── testing/
│       └── testing-guidelines.md
│
├── scripts/bash/                                  # Automation scripts (5 files)
│   ├── common.sh                                  # Shared utilities
│   ├── check-prerequisites.sh                     # System requirements check
│   ├── create-new-feature.sh                      # Feature creation helper
│   ├── setup-plan.sh                              # Planning setup
│   └── update-agent-context.sh                    # Agent context updater
│
├── registry/
│   └── AGENT_REGISTRY.md                          # Agent registry & capabilities
│
├── examples/
│   ├── sandbox/
│   │   ├── orders-service/SPECIFICATION.md
│   │   └── notifications-service/SPECIFICATION.md
│   └── outputs/
│       └── README.md
```

---

## Quick Links

### Getting Started

- [README.md](README.md) — Project overview
- [APEX_INTEGRATION_GUIDE.md](APEX_INTEGRATION_GUIDE.md) — Integration guide & CLI reference
- [registry/AGENT_REGISTRY.md](registry/AGENT_REGISTRY.md) — All agents & capabilities

### Agents

| Agent | Purpose |
|-------|---------|
| [sdd.specify](agents/core/sdd.specify.agent.md) | Create specifications |
| [sdd.clarify](agents/core/sdd.clarify.agent.md) | Clarify requirements |
| [sdd.plan](agents/core/sdd.plan.agent.md) | Create project plans |
| [sdd.tasks](agents/core/sdd.tasks.agent.md) | Break down into tasks |
| [sdd.analyze](agents/core/sdd.analyze.agent.md) | Technical analysis |
| [sdd.implement](agents/core/sdd.implement.agent.md) | Implementation guidance |
| [sdd.groom](agents/core/sdd.groom.agent.md) | Story grooming |
| [sdd.groom-story](agents/extensions/sdd.groom-story.agent.md) | Story grooming (extended) |
| [sdd.instructions](agents/extensions/sdd.instructions.agent.md) | Instruction architecture |
| [sdd.repo-intelligence](agents/extensions/sdd.repo-intelligence.agent.md) | Repository intelligence |

### Templates

- [Specification](templates/spec-template.md) · [Plan](templates/plan-template.md) · [Tasks](templates/tasks-template.md) · [Checklist](templates/checklist-template.md)
- [User Story](templates/user-story.template.md) · [SDD](templates/software-design-document.template.md) · [Agent File](templates/agent-file-template.md)
- [Instruction Architecture](templates/instruction-template.md) · [Groom Story](templates/stories/groom-story-template.md)

### Guidelines

- [Engineering](instructions/engineering/engineering-guidelines.md) · [Architecture](instructions/architecture/architecture-guidelines.md) · [Languages](instructions/languages/language-guidelines.md) · [Infrastructure](instructions/infra/infrastructure-guidelines.md) · [Testing](instructions/testing/testing-guidelines.md)

### Examples

- [Orders Service](examples/sandbox/orders-service/SPECIFICATION.md) · [Notifications Service](examples/sandbox/notifications-service/SPECIFICATION.md) · [Example Outputs](examples/outputs/README.md)

---

## Directory Summary

| Directory              | Contents                                                      | Files |
|------------------------|---------------------------------------------------------------|-------|
| `/agents/core`         | Core SDD agents                                               | 7     |
| `/agents/extensions`   | Extension agents                                              | 4     |
| `/prompts/core`        | Core agent prompts                                            | 6     |
| `/prompts/extensions`  | Extension agent prompts                                       | 5     |
| `/templates`           | Document templates (+ stories/ subfolder)                     | 11    |
| `/instructions`        | Engineering, architecture, language, infra, testing guidelines | 5     |
| `/scripts/bash`        | Automation scripts                                            | 5     |
| `/registry`            | Agent registry                                                | 1     |
| `/examples`            | Sandbox specs & output guide                                  | 3     |

## Key Files

| File | Purpose |
|------|---------|
| `integrate.sh` | Distributes framework to target repos (symlinks for `.apex/`, read-only copies for `.github/agents/` and `.github/prompts/`) |
| `install-cli.sh` | Installs `apex-integrate` CLI command globally |
| `uninstall.sh` | Removes `apex-integrate` CLI command from `/usr/local/bin/` |
| `.apex-ignore` | Ignore patterns for `sdd.instructions` agent — copied to target repos on first integration |
| `APEX_INTEGRATION_GUIDE.md` | Full integration guide and CLI reference |
| `registry/AGENT_REGISTRY.md` | All agents, their capabilities, and usage |

## Getting Started

1. Read [README.md](README.md)
2. Run `./install-cli.sh` to install the CLI
3. See [APEX_INTEGRATION_GUIDE.md](APEX_INTEGRATION_GUIDE.md) for integration details
4. Run `./uninstall.sh` to remove the CLI when no longer needed
5. Browse [registry/AGENT_REGISTRY.md](registry/AGENT_REGISTRY.md) for available agents
