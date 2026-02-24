# Speckit-Central Repository Structure

## Complete Folder & File Layout

```
otto_speckit-central/
├── README.md                                      # Main project documentation
├── CHANGELOG.md                                   # Version history and changes
├── CONTRIBUTING.md                                # Contribution guidelines
├── FINAL_VERIFICATION.md                          # Setup verification document
├── STRUCTURE.md                                   # This file - repository structure
├── VERSION                                        # Version file (1.0.0)
├── .editorconfig                                  # Editor configuration
├── .gitignore                                     # Git ignore rules
│
├── agents/                                        # Agent specifications
│   ├── core/                                      # Core agents (7 files)
│   │   ├── speckit.specify.agent.md              # Specification creation agent
│   │   ├── speckit.clarify.agent.md              # Requirement clarification agent
│   │   ├── speckit.plan.agent.md                 # Project planning agent
│   │   ├── speckit.tasks.agent.md                # Task decomposition agent
│   │   ├── speckit.analyze.agent.md              # Technical analysis agent
│   │   ├── speckit.implement.agent.md            # Implementation guidance agent
│   │   └── speckit.constitution.agent.md         # Standards & guidelines agent
│   │
│   └── extensions/                                # Extension agents (2 files)
│       ├── speckit.groom-story.agent.md          # Story grooming agent
│       └── speckit.review.agent.md               # Review agent
│
├── prompts/                                       # Agent prompts
│   ├── core/                                      # Core prompts (7 files)
│   │   ├── speckit.specify.prompt.md             # Prompt for specify agent
│   │   ├── speckit.clarify.prompt.md             # Prompt for clarify agent
│   │   ├── speckit.plan.prompt.md                # Prompt for plan agent
│   │   ├── speckit.tasks.prompt.md               # Prompt for tasks agent
│   │   ├── speckit.analyze.prompt.md             # Prompt for analyze agent
│   │   ├── speckit.implement.prompt.md           # Prompt for implement agent
│   │   └── speckit.constitution.prompt.md        # Prompt for constitution agent
│   │
│   └── extensions/                                # Extension prompts (2 files)
│       ├── speckit.groom-story.prompt.md         # Prompt for groom-story agent
│       └── speckit.review.prompt.md              # Prompt for review agent
│
├── templates/                                     # Reusable templates (7 files)
│   ├── software-design-document.template.md      # SDD template
│   ├── user-story.template.md                    # User story template
│   ├── spec-template.md                          # Specification template
│   ├── plan-template.md                          # Project plan template
│   ├── tasks-template.md                         # Task breakdown template
│   ├── checklist-template.md                     # Checklist template
│   └── agent-file-template.md                    # Agent file template
│
├── instructions/                                  # Best practices & guidelines (5 files)
│   ├── engineering/
│   │   └── engineering-guidelines.md             # Code quality, testing, review, documentation
│   │
│   ├── architecture/
│   │   └── architecture-guidelines.md            # Architecture patterns, design, scalability
│   │
│   ├── languages/
│   │   └── language-guidelines.md                # Python, JS/TS, Java, Go, SQL guidelines
│   │
│   ├── infra/
│   │   └── infrastructure-guidelines.md          # DevOps, deployment, monitoring, security
│   │
│   └── testing/
│       └── testing-guidelines.md                 # Test strategies, coverage, CI/CD
│
├── scripts/                                       # Automation scripts
│   ├── bash/                                      # Bash scripts (5 files)
│   │   ├── check-prerequisites.sh                # Check system requirements
│   │   ├── create-new-feature.sh                 # Feature creation helper
│   │   ├── setup-plan.sh                         # Setup planning script
│   │   ├── update-agent-context.sh               # Update agent context
│   │   └── common.sh                             # Shared utilities library
│
├── registry/                                      # Agent & resource registry
│   └── AGENT_REGISTRY.md                         # Complete agent registry with capabilities
│
├── examples/                                      # Example specifications & outputs
│   ├── sandbox/
│   │   ├── orders-service/
│   │   │   └── SPECIFICATION.md                  # Orders service API specification example
│   │   │
│   │   └── notifications-service/
│   │       └── SPECIFICATION.md                  # Notifications service specification example
│   │
│   └── outputs/
│       └── README.md                             # Guide to example outputs and workflows
│
└── docs/                                          # Documentation
    └── INDEX.md                                  # Documentation index & quick links
```

## Directory Summary

| Directory | Purpose | File Count | Contents |
|-----------|---------|-----------|----------|
| `/agents` | Agent specifications | 9 | 7 core + 2 extension agents |
| `/prompts` | Agent prompts | 9 | 7 core + 2 extension prompts |
| `/templates` | Document templates | 7 | Reusable templates (SDD, stories, specs, plans, tasks, checklists, agent templates) |
| `/instructions` | Guidelines & best practices | 5 | Engineering, architecture, languages, infrastructure, testing guidelines |
| `/scripts/bash` | Automation scripts | 8 | Setup, build, test, prerequisites, feature creation, planning, context update, common lib |
| `/registry` | Central registry | 1 | Complete agent registry with all capabilities |
| `/examples` | Reference examples | 3 | Orders service, notifications service, outputs documentation |
| `/docs` | Documentation | 1 | Documentation index and quick links |
| **Root** | Project configuration | 8 | README, Changelog, Contributing, Verification, Structure, Version, Editor config, Git ignore |

## Key Files

| File | Purpose |
|------|---------|
| `README.md` | Main project documentation |
| `CHANGELOG.md` | Version history and changes |
| `CONTRIBUTING.md` | Contribution guidelines |
| `FINAL_VERIFICATION.md` | Setup verification and summary |
| `STRUCTURE.md` | This file - complete repository structure |
| `VERSION` | Current version (1.0.0) |
| `.editorconfig` | Editor configuration for consistent formatting |
| `.gitignore` | Git ignore patterns |

## Getting Started

1. Read [README.md](README.md) for project overview
2. Check [docs/INDEX.md](docs/INDEX.md) for documentation index
3. Review [registry/AGENT_REGISTRY.md](registry/AGENT_REGISTRY.md) for available agents
4. Follow [CONTRIBUTING.md](CONTRIBUTING.md) to set up development environment
5. Explore [examples/](examples/) for reference implementations

## Architecture

**Agents** → **Prompts** → **Guidelines** → **Templates** → **Examples** → **Outputs**

Each agent is guided by prompts and follows guidelines to produce specifications and documentation based on templates, with examples showing best practices.

## Repository Statistics

| Metric | Count |
|--------|-------|
| **Total Directories** | 16 |
| **Total Files** | 43 |
| **Agents (core + extension)** | 9 |
| **Prompts (core + extension)** | 9 |
| **Templates** | 7 |
| **Guidelines** | 5 |
| **Automation Scripts** | 8 |
| **Example Services** | 2 |
| **Root Configuration Files** | 8 |

## Directory Organization

```
Root Level
├── Configuration & Documentation (8 files)
├── agents/ (9 files)
├── prompts/ (9 files)
├── templates/ (7 files)
├── instructions/ (5 files)
├── scripts/bash/ (8 files)
├── registry/ (1 file)
├── examples/ (3 files)
└── docs/ (1 file)
```

## File Organization Summary

- **Documentation**: 8 root files + 1 index = 9 files
- **Agents**: 9 agent files (7 core + 2 extension)
- **Prompts**: 9 prompt files (7 core + 2 extension)
- **Templates**: 7 reusable templates
- **Guidelines**: 5 comprehensive guideline suites
- **Automation**: 8 bash scripts and utilities
- **Registry**: 1 central registry
- **Examples**: 3 example specifications

**Total: 43 files across 16 directories**

