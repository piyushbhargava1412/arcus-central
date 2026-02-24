# Speckit Integration Guide

## Overview

The `integrate.sh` script links a target project repository to this central Speckit repository.
It creates **two sets of symlinks**:

1. **`.speckit/`** — Directory symlinks for full framework access (templates, scripts, instructions)
2. **`.github/`** — Flat file symlinks so IntelliJ IDEA and VS Code Copilot can discover agents and prompts

No files are copied. All projects share a single source of truth.

---

## Why Two Locations?

| Location | Purpose | Who reads it |
|----------|---------|-------------|
| `.speckit/templates/` | Spec, plan, task, SDD, story templates | Agents during generation |
| `.speckit/scripts/` | Bash utilities (check-prerequisites, setup-plan, etc.) | Agents that run shell commands |
| `.speckit/instructions/` | Architecture, engineering, testing guidelines | Agents for context |
| `.github/agents/*.agent.md` | **Flat** file symlinks — IntelliJ/VS Code Copilot agent discovery | **IDE Copilot plugin** |
| `.github/prompts/*.prompt.md` | **Flat** file symlinks — IntelliJ/VS Code Copilot prompt discovery | **IDE Copilot plugin** |
| `.github/copilot-instructions.md` | Global Copilot context (linked to constitution agent) | **IDE Copilot plugin** |

**No duplication:** Agents and prompts live only in `.github/`. Templates, scripts, and instructions live only in `.speckit/`.

IntelliJ and VS Code scan `.github/agents/` and `.github/prompts/` for `*.agent.md` and `*.prompt.md` files. They do **not** recurse into subdirectories like `core/` or `extensions/`. That's why the script creates flat individual file symlinks under `.github/`.

---

## Central Repository Structure

```
otto_speckit-central/
├── integrate.sh                                   ← Integration script (run this)
├── agents/
│   ├── core/
│   │   ├── speckit.analyze.agent.md
│   │   ├── speckit.clarify.agent.md
│   │   ├── speckit.constitution.agent.md
│   │   ├── speckit.implement.agent.md
│   │   ├── speckit.plan.agent.md
│   │   ├── speckit.specify.agent.md
│   │   └── speckit.tasks.agent.md
│   └── extensions/
│       ├── speckit.groom-story.agent.md
│       └── speckit.review.agent.md
├── prompts/
│   ├── core/
│   │   ├── speckit.analyze.prompt.md
│   │   ├── speckit.clarify.prompt.md
│   │   ├── speckit.constitution.prompt.md
│   │   ├── speckit.implement.prompt.md
│   │   ├── speckit.plan.prompt.md
│   │   ├── speckit.specify.prompt.md
│   │   └── speckit.tasks.prompt.md
│   └── extensions/
│       ├── speckit.groom-story.prompt.md
│       └── speckit.review.prompt.md
├── templates/
│   ├── agent-file-template.md
│   ├── checklist-template.md
│   ├── plan-template.md
│   ├── software-design-document.template.md
│   ├── spec-template.md
│   ├── tasks-template.md
│   └── user-story.template.md
├── scripts/
│   └── bash/
│       ├── check-prerequisites.sh
│       ├── common.sh
│       ├── create-new-feature.sh
│       ├── setup-plan.sh
│       └── update-agent-context.sh
├── instructions/
│   ├── architecture/architecture-guidelines.md
│   ├── engineering/engineering-guidelines.md
│   ├── infra/infrastructure-guidelines.md
│   ├── languages/language-guidelines.md
│   └── testing/testing-guidelines.md
├── registry/
│   └── AGENT_REGISTRY.md
├── docs/
│   └── INDEX.md
├── examples/
│   ├── outputs/README.md
│   └── sandbox/
│       ├── notifications-service/SPECIFICATION.md
│       └── orders-service/SPECIFICATION.md
├── README.md
├── STRUCTURE.md
├── VERSION
└── SPECKIT_INTEGRATION_GUIDE.md                   ← This file
```

---

## What Gets Created in the Target Repo

After running `integrate.sh`, the target repo gets:

```
<target-repo>/
│
├── .speckit/                                       ← Directory symlinks (no agents/prompts)
│   ├── templates    → ../../otto_speckit-central/templates
│   ├── scripts      → ../../otto_speckit-central/scripts
│   └── instructions → ../../otto_speckit-central/instructions
│
├── .github/
│   ├── copilot-instructions.md → ../../otto_speckit-central/agents/core/speckit.constitution.agent.md
│   │
│   ├── agents/                                    ← Flat file symlinks (IDE discovery)
│   │   ├── speckit.analyze.agent.md     → ../../../otto_speckit-central/agents/core/...
│   │   ├── speckit.clarify.agent.md     → ...
│   │   ├── speckit.constitution.agent.md → ...
│   │   ├── speckit.groom-story.agent.md → .../extensions/...
│   │   ├── speckit.implement.agent.md   → ...
│   │   ├── speckit.plan.agent.md        → ...
│   │   ├── speckit.review.agent.md      → .../extensions/...
│   │   ├── speckit.specify.agent.md     → ...
│   │   └── speckit.tasks.agent.md       → ...
│   │
│   ├── prompts/                                   ← Flat file symlinks (IDE discovery)
│   │   ├── speckit.analyze.prompt.md    → ...
│   │   ├── speckit.clarify.prompt.md    → ...
│   │   ├── speckit.constitution.prompt.md → ...
│   │   ├── speckit.groom-story.prompt.md → ...
│   │   ├── speckit.implement.prompt.md  → ...
│   │   ├── speckit.plan.prompt.md       → ...
│   │   ├── speckit.review.prompt.md     → ...
│   │   ├── speckit.specify.prompt.md    → ...
│   │   └── speckit.tasks.prompt.md      → ...
│   │
│   ├── pull_request_template.md                   ← Existing file (untouched)
│   └── workflows/                                 ← Existing dir (untouched)
│
├── .speckit-metadata.json                         ← Integration metadata
├── speckit-integration.log                        ← Execution log
└── (existing project files...)
```

**Total: 3 directory symlinks + 9 agent file symlinks + 9 prompt file symlinks + 1 copilot-instructions symlink = 22 symlinks**

**Zero duplication: each item is linked in exactly one location.**

---

## Prerequisites

- macOS or Linux
- Python 3 (used for relative path calculation)
- Both repositories cloned under the same parent directory

```
<workspace>/
├── otto_speckit-central/          ← Central repo
└── <target-repo>/                 ← Target repo
```

---

## How to Run

### 1. Make the script executable (first time only)

```bash
chmod +x <path-to>/otto_speckit-central/integrate.sh
```

### 2. Run integration

```bash
# Auto-detect central repo from script location
<path-to>/otto_speckit-central/integrate.sh <path-to>/<target-repo>

# Or specify both explicitly
<path-to>/otto_speckit-central/integrate.sh <path-to>/<target-repo> <path-to>/otto_speckit-central

# Non-interactive mode (for CI/CD — skips confirmation prompts)
<path-to>/otto_speckit-central/integrate.sh <path-to>/<target-repo> --yes
```

**Example:**

```bash
../otto_speckit-central/integrate.sh ../developer-joyofenergy-java
```

### 3. Verify

```bash
# Check .speckit/ directory symlinks
ls -la <target-repo>/.speckit/

# Check .github/agents/ flat file symlinks (what Copilot sees)
ls -la <target-repo>/.github/agents/

# Check .github/prompts/ flat file symlinks (what Copilot sees)
ls -la <target-repo>/.github/prompts/

# Read an agent through the symlink
cat <target-repo>/.github/agents/speckit.specify.agent.md

# Check metadata
cat <target-repo>/.speckit-metadata.json
```

### 4. Show help

```bash
./integrate.sh --help
```

---

## How Copilot Discovers Speckit

After integration, when you open the target project in IntelliJ IDEA or VS Code:

1. **Copilot reads `.github/copilot-instructions.md`** as global context for every interaction. This is the constitution agent — it sets the baseline rules and standards.

2. **Copilot scans `.github/agents/*.agent.md`** and lists them in the agent picker. You can invoke any speckit agent (e.g., `@speckit.specify`, `@speckit.plan`).

3. **Copilot scans `.github/prompts/*.prompt.md`** and lists them as reusable prompts. You can run any speckit prompt from the prompt picker.

All files are symlinks pointing to the central repo. Updating an agent in `otto_speckit-central` makes it immediately visible in every integrated project.

---

## What the Script Does (Step by Step)

| Phase | Action |
|-------|--------|
| **Validation** | Checks both repos exist and central has required directories |
| **Phase 1** | Creates `.speckit/` with 3 directory symlinks (templates, scripts, instructions) |
| **Phase 2a** | Finds all `*.agent.md` files in central `agents/core/` and `agents/extensions/`, creates flat symlinks in `.github/agents/` |
| **Phase 2b** | Finds all `*.prompt.md` files in central `prompts/core/` and `prompts/extensions/`, creates flat symlinks in `.github/prompts/` |
| **Phase 2c** | Links `speckit.constitution.agent.md` as `.github/copilot-instructions.md` |
| **Phase 3** | Validates every symlink resolves correctly |
| **Phase 4** | Writes `.speckit-metadata.json` with integration details |

---

## Symlink Type: Relative

All symlinks use relative paths:

```
.speckit/templates    → ../../otto_speckit-central/templates
.github/agents/speckit.specify.agent.md → ../../../otto_speckit-central/agents/core/speckit.specify.agent.md
```

Relative paths ensure the integration works on any machine as long as both repos share the same parent directory.

---

## Re-running / Repairing

The script is safe to re-run. It detects existing symlinks and prompts before replacing. Use `--yes` to auto-replace without prompts:

```bash
<path-to>/otto_speckit-central/integrate.sh <path-to>/<target-repo> --yes
```

---

## Integrating Additional Repositories

Run the same command for any project:

```bash
# Java project
./integrate.sh ../<java-project>

# Python project
./integrate.sh ../<python-service>

# Node.js project
./integrate.sh ../<node-app>
```

All integrated repos share the same central artifacts. Update once in `otto_speckit-central`, and every linked project sees the change immediately.
