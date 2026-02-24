# Speckit Integration Guide

## Overview

The `integrate.sh` script links a target project repository to this central Speckit repository using relative symlinks. All projects share a single source of truth — no files are copied, no duplication, and central updates are visible instantly.

---

## Central Repository Structure

```
otto_speckit-central/
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
│       ├── integrate.sh              ← Integration script
│       ├── check-prerequisites.sh
│       ├── common.sh
│       ├── create-new-feature.sh
│       ├── setup-plan.sh
│       └── update-agent-context.sh
├── instructions/
│   ├── architecture/
│   │   └── architecture-guidelines.md
│   ├── engineering/
│   │   └── engineering-guidelines.md
│   ├── infra/
│   │   └── infrastructure-guidelines.md
│   ├── languages/
│   │   └── language-guidelines.md
│   └── testing/
│       └── testing-guidelines.md
├── registry/
│   └── AGENT_REGISTRY.md
├── docs/
│   └── INDEX.md
├── examples/
│   ├── outputs/
│   │   └── README.md
│   └── sandbox/
│       ├── notifications-service/
│       │   └── SPECIFICATION.md
│       └── orders-service/
│           └── SPECIFICATION.md
├── README.md
├── STRUCTURE.md
├── VERSION
└── SPECKIT_INTEGRATION_GUIDE.md      ← This file
```

---

## What Gets Integrated

The script creates a `.speckit/` directory in the target repo with 5 relative symlinks:

| Symlink | Points To | Contents |
|---------|-----------|----------|
| `.speckit/agents` | `../../otto_speckit-central/agents` | 9 agent definitions (7 core + 2 extensions) |
| `.speckit/prompts` | `../../otto_speckit-central/prompts` | 9 prompt files (7 core + 2 extensions) |
| `.speckit/templates` | `../../otto_speckit-central/templates` | 7 output templates |
| `.speckit/scripts` | `../../otto_speckit-central/scripts` | 6 bash utility scripts |
| `.speckit/instructions` | `../../otto_speckit-central/instructions` | 5 guideline documents |

After integration, the target repo looks like:

```
developer-joyofenergy-java/
├── .speckit/
│   ├── agents       → ../../otto_speckit-central/agents
│   ├── prompts      → ../../otto_speckit-central/prompts
│   ├── templates    → ../../otto_speckit-central/templates
│   ├── scripts      → ../../otto_speckit-central/scripts
│   └── instructions → ../../otto_speckit-central/instructions
├── .speckit-metadata.json   ← Integration metadata
├── speckit-integration.log  ← Execution log
└── (existing project files)
```

---

## Prerequisites

- macOS or Linux
- Python 3 (used for relative path calculation)
- Both repositories cloned under the same parent directory

```
~/Desktop/
├── otto_speckit-central/          ← Central repo
└── developer-joyofenergy-java/    ← Target repo
```

---

## How to Run

### 1. Make the script executable (first time only)

```bash
chmod +x /path/to/otto_speckit-central/scripts/bash/integrate.sh
```

### 2. Run integration

```bash
/path/to/otto_speckit-central/scripts/bash/integrate.sh <target-repo> <central-repo>
```

**Example:**

```bash
/Users/swetha/Desktop/otto_speckit-central/scripts/bash/integrate.sh \
  /Users/swetha/Desktop/developer-joyofenergy-java \
  /Users/swetha/Desktop/otto_speckit-central
```

### 3. Verify

```bash
# Check symlinks
ls -la /Users/swetha/Desktop/developer-joyofenergy-java/.speckit/

# Read a file through the symlink
cat /Users/swetha/Desktop/developer-joyofenergy-java/.speckit/agents/core/speckit.analyze.agent.md

# Check metadata
cat /Users/swetha/Desktop/developer-joyofenergy-java/.speckit-metadata.json
```

---

## What the Script Does

1. **Validates** both repositories exist
2. **Validates** the central repo contains all required directories (`agents`, `prompts`, `templates`, `scripts`, `instructions`)
3. **Creates** `.speckit/` directory in the target repo
4. **Creates** 5 relative symlinks pointing back to the central repo
5. **Validates** every symlink resolves correctly and is not broken
6. **Tests** file access through the symlinks (e.g. `agents/core/`, `prompts/core/`)
7. **Generates** `.speckit-metadata.json` with integration details
8. **Generates** `speckit-integration.log` with execution trace

---

## Why Relative Symlinks

All symlinks use **relative paths**, not absolute:

```
agents → ../../otto_speckit-central/agents     ← Relative (used)
agents → /Users/swetha/Desktop/otto_speckit-central/agents  ← Absolute (not used)
```

| | Relative | Absolute |
|---|---|---|
| Portable across machines | ✅ | ❌ |
| Works in Docker / CI | ✅ | ❌ |
| Survives folder moves | ✅ | ❌ |
| Team collaboration | ✅ | ❌ |

The relative path `../../otto_speckit-central/agents` navigates:
- `..` → up from `.speckit/` to the target repo root
- `..` → up from the target repo to the shared parent directory
- `otto_speckit-central/agents` → down into the central repo

---

## Re-running / Repairing

The script is safe to re-run. It will detect existing symlinks and ask before replacing them:

```bash
/Users/swetha/Desktop/otto_speckit-central/scripts/bash/integrate.sh \
  /Users/swetha/Desktop/developer-joyofenergy-java \
  /Users/swetha/Desktop/otto_speckit-central
```

---

## Metadata File

After integration, `.speckit-metadata.json` is created in the target repo:

```json
{
  "integrated_at": "2026-02-24T06:04:00Z",
  "central_repo_name": "otto_speckit-central",
  "target_repo_name": "developer-joyofenergy-java",
  "symlink_type": "relative",
  "speckit_dir": ".speckit",
  "symlinks": {
    "agents": ".speckit/agents",
    "prompts": ".speckit/prompts",
    "templates": ".speckit/templates",
    "scripts": ".speckit/scripts",
    "instructions": ".speckit/instructions"
  },
  "version": "1.0",
  "integration_status": "success"
}
```

---

## Integrating Additional Repositories

Repeat the same command for any project:

```bash
# Python project
/Users/swetha/Desktop/otto_speckit-central/scripts/bash/integrate.sh \
  /Users/swetha/Desktop/my-python-service \
  /Users/swetha/Desktop/otto_speckit-central

# Node.js project
/Users/swetha/Desktop/otto_speckit-central/scripts/bash/integrate.sh \
  /Users/swetha/Desktop/my-node-app \
  /Users/swetha/Desktop/otto_speckit-central
```

All integrated repos share the same central artifacts. Update once in `otto_speckit-central`, and every linked project sees the change immediately.

