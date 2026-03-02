# APEX SDD Framework - Repository Structure

**APEX** = Team name  
**SDD** = Spec Driven Development methodology  
**This repo** = Central distribution point for SDD framework components

## Complete Folder & File Layout

```
otto_apex-central/
├── README.md                                      # Main project documentation
├── CHANGELOG.md                                   # Version history and changes
├── CONTRIBUTING.md                                # Contribution guidelines
├── FINAL_VERIFICATION.md                          # Setup verification document
├── STRUCTURE.md                                   # This file - repository structure
├── VERSION                                        # Version file (1.1.0)
├── integrate.sh                                   # Core integration script
├── install-cli.sh                                 # CLI installer (installs apex-integrate command)
├── .editorconfig                                  # Editor configuration
├── .gitignore                                     # Git ignore rules
│
├── agents/                                        # Agent specifications
│   ├── core/                                      # Core agents (6 files)
│   │   ├── sdd.specify.agent.md              # Specification creation agent
│   │   ├── sdd.clarify.agent.md              # Requirement clarification agent
│   │   ├── sdd.plan.agent.md                 # Project planning agent
│   │   ├── sdd.tasks.agent.md                # Task decomposition agent
│   │   ├── sdd.analyze.agent.md              # Technical analysis agent
│   │   └── sdd.implement.agent.md            # Implementation guidance agent
│   │
│   └── extensions/                                # Extension agents (3 files)
│       ├── sdd.groom-story.agent.md          # Story grooming agent
│       ├── sdd.instructions.agent.md         # Instruction architecture agent
│       └── sdd.review.agent.md               # Review agent
│
├── prompts/                                       # Agent prompts
│   ├── core/                                      # Core prompts (6 files)
│   │   ├── sdd.specify.prompt.md             # Prompt for specify agent
│   │   ├── sdd.clarify.prompt.md             # Prompt for clarify agent
│   │   ├── sdd.plan.prompt.md                # Prompt for plan agent
│   │   ├── sdd.tasks.prompt.md               # Prompt for tasks agent
│   │   ├── sdd.analyze.prompt.md             # Prompt for analyze agent
│   │   └── sdd.implement.prompt.md           # Prompt for implement agent
│   │
│   └── extensions/                                # Extension prompts (3 files)
│       ├── sdd.groom-story.prompt.md         # Prompt for groom-story agent
│       ├── sdd.instructions.prompt.md        # Prompt for instructions agent
│       └── sdd.review.prompt.md              # Prompt for review agent
│
├── templates/                                     # Reusable templates (8 files)
│   ├── software-design-document.template.md      # SDD template
│   ├── user-story.template.md                    # User story template
│   ├── spec-template.md                          # Specification template
│   ├── plan-template.md                          # Project plan template
│   ├── tasks-template.md                         # Task breakdown template
│   ├── checklist-template.md                     # Checklist template
│   ├── agent-file-template.md                    # Agent file template
│   └── instruction-template.md                   # Instruction architecture template
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
| `/agents` | Agent specifications | 9 | 6 core + 3 extension agents |
| `/prompts` | Agent prompts | 9 | 6 core + 3 extension prompts |
| `/templates` | Document templates | 8 | Reusable templates (SDD, stories, specs, plans, tasks, checklists, agent templates, instruction architecture) |
| `/instructions` | Guidelines & best practices | 5 | Engineering, architecture, languages, infrastructure, testing guidelines |
| `/scripts/bash` | Automation scripts | 5 | Setup, build, test, prerequisites, common lib |
| `/registry` | Central registry | 1 | Complete agent registry with all capabilities |
| `/examples` | Reference examples | 3 | Orders service, notifications service, outputs documentation |
| `/docs` | Documentation | 1 | Documentation index and quick links |
| **Root** | Project configuration | 8 | README, Changelog, Contributing, Verification, Structure, Version, Editor config, Git ignore |

## Key Files

| File | Purpose |
|------|---------|
| `README.md` | Main project documentation |
| `integrate.sh` | Core integration script (creates symlinks in target repos) |
| `install-cli.sh` | CLI installer (installs `apex-integrate` command globally) |
| `APEX_INTEGRATION_GUIDE.md` | Full integration guide and CLI reference |
| `STRUCTURE.md` | This file - complete repository structure |
| `VERSION` | Current version |
| `.editorconfig` | Editor configuration for consistent formatting |
| `.gitignore` | Git ignore patterns |

## Getting Started

1. Read [README.md](README.md) for project overview and quick start
2. Run `./install-cli.sh` to install the `apex-integrate` CLI command
3. Check [APEX_INTEGRATION_GUIDE.md](APEX_INTEGRATION_GUIDE.md) for full integration details
4. Review [registry/AGENT_REGISTRY.md](registry/AGENT_REGISTRY.md) for available agents
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
| **Templates** | 8 |
| **Guidelines** | 5 |
| **Automation Scripts** | 5 |
| **Example Services** | 2 |
| **Root Configuration Files** | 8 |

## Directory Organization

```
Root Level
├── Configuration & Documentation (8 files)
├── agents/ (9 files)
├── prompts/ (9 files)
├── templates/ (8 files)
├── instructions/ (5 files)
├── scripts/bash/ (5 files)
├── registry/ (1 file)
├── examples/ (3 files)
└── docs/ (1 file)
```

## File Organization Summary

- **Documentation**: 8 root files + 1 index = 9 files
- **Agents**: 9 agent files (6 core + 3 extension)
- **Prompts**: 9 prompt files (6 core + 3 extension)
- **Templates**: 8 reusable templates
- **Guidelines**: 5 comprehensive guideline suites
- **Automation**: 5 bash scripts and utilities
- **Registry**: 1 central registry
- **Examples**: 3 example specifications

**Total: 43 files across 16 directories**

