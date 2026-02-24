# Speckit Integration Guide

## Overview

The `integrate.sh` script creates **read-only symlinks** from a target project repository into the central Speckit repository. Source files in central are set read-only (`chmod a-w`) so that writing through symlinks is denied.

**One-way flow:** Central → Target. Zero file duplication. Instant updates.

---

## How Protection Works

Symlinks on macOS/Linux don't have their own permissions — writes go through to the target file. The script sets all central source files to `chmod a-w` (read-only), so:

```
$ echo "test" >> .github/agents/speckit.specify.agent.md
zsh: permission denied                  ← symlink → read-only source file
```

- Symlinks = zero duplication, changes in central are instantly visible
- Read-only source = writes through symlinks are denied
- No copies to drift out of sync

---

## What Gets Created

| Location | Type | Points To |
|----------|------|-----------|
| `.speckit/templates` | Dir symlink | `central/templates` |
| `.speckit/scripts` | Dir symlink | `central/scripts` |
| `.speckit/instructions` | Dir symlink | `central/instructions` |
| `.github/agents/*.agent.md` | File symlinks (flat) | `central/agents/core/` + `extensions/` |
| `.github/prompts/*.prompt.md` | File symlinks (flat) | `central/prompts/core/` + `extensions/` |
| `.github/copilot-instructions.md` | File symlink | `central/agents/core/speckit.constitution.agent.md` |

All source files are read-only. All symlinks use relative paths.

---

## Target Repo After Integration

```
<target-repo>/
│
├── .speckit/                                       ← Directory symlinks
│   ├── templates    → ../../otto_speckit-central/templates
│   ├── scripts      → ../../otto_speckit-central/scripts
│   └── instructions → ../../otto_speckit-central/instructions
│
├── .github/
│   ├── copilot-instructions.md                    → constitution agent
│   ├── agents/                                    ← Flat file symlinks
│   │   ├── speckit.analyze.agent.md
│   │   ├── speckit.clarify.agent.md
│   │   ├── speckit.constitution.agent.md
│   │   ├── speckit.groom-story.agent.md
│   │   ├── speckit.implement.agent.md
│   │   ├── speckit.plan.agent.md
│   │   ├── speckit.review.agent.md
│   │   ├── speckit.specify.agent.md
│   │   └── speckit.tasks.agent.md
│   ├── prompts/                                   ← Flat file symlinks
│   │   ├── speckit.analyze.prompt.md
│   │   ├── speckit.clarify.prompt.md
│   │   ├── speckit.constitution.prompt.md
│   │   ├── speckit.groom-story.prompt.md
│   │   ├── speckit.implement.prompt.md
│   │   ├── speckit.plan.prompt.md
│   │   ├── speckit.review.prompt.md
│   │   ├── speckit.specify.prompt.md
│   │   └── speckit.tasks.prompt.md
│   ├── pull_request_template.md                   ← Existing (untouched)
│   └── workflows/                                 ← Existing (untouched)
│
├── .speckit-metadata.json
└── speckit-integration.log
```

---

## Prerequisites

- macOS or Linux
- Python 3 (for relative path calculation)
- Both repositories cloned under the same parent directory

---

## How to Run

There are two ways to integrate. **Scenario 2 (Pull) is recommended.**

### Scenario 2: Pull Model (recommended)

The target repo pulls speckit from central. Developer only needs **read access** to central.

**1. Copy `speckit-setup.sh` into your project root:**

```bash
cp <path-to>/otto_speckit-central/scripts/speckit-setup.sh ./speckit-setup.sh
chmod +x speckit-setup.sh
```

**2. Run it from your project:**

```bash
./speckit-setup.sh                              # Auto-detect central as sibling
./speckit-setup.sh --central <path>             # Explicit path
./speckit-setup.sh --sync                       # Re-pull latest
./speckit-setup.sh --yes                        # Non-interactive (CI/CD)
```

**3. Add to your Makefile or setup script:**

```makefile
setup-speckit:
	./speckit-setup.sh --yes
```

Auto-detection looks for `otto_speckit-central/` as a sibling directory. You can also set `SPECKIT_CENTRAL_REPO` env var.

### Scenario 1: Push Model (alternative)

Central pushes into the target. Requires write access to the target repo.

```bash
<path-to>/otto_speckit-central/integrate.sh <path-to>/<target-repo>
<path-to>/otto_speckit-central/integrate.sh <path-to>/<target-repo> --yes
<path-to>/otto_speckit-central/integrate.sh <path-to>/<target-repo> --sync
```

### Comparison

| Feature | Scenario 1 (Push) | Scenario 2 (Pull) |
|---------|-------------------|-------------------|
| Who runs it | Central repo owner | Target repo developer |
| Access needed | Write to target | Read to central |
| Developer feel | "Pushed" update | "Pulled" dependency |
| CI/CD | Harder to automate | One line in Makefile |
| Recommended | For initial onboarding | For daily use |

---

## How Copilot Discovers Speckit

1. **`.github/copilot-instructions.md`** — read automatically as global context
2. **`.github/agents/*.agent.md`** — appear in the Copilot agent picker (`@speckit.specify`, etc.)
3. **`.github/prompts/*.prompt.md`** — appear in the Copilot prompt picker

---

## What the Script Does

| Phase | Action |
|-------|--------|
| **Phase 0** | Sets all central source files read-only (`chmod a-w`) |
| **Phase 1** | Creates `.speckit/` with 3 directory symlinks |
| **Phase 2** | Creates flat file symlinks in `.github/agents/` and `.github/prompts/` + `copilot-instructions.md` |
| **Phase 3** | Validates every symlink resolves and is read-only |
| **Phase 4** | Writes `.speckit-metadata.json` |

---

## Integrating Additional Repositories

```bash
./integrate.sh ../<java-project>
./integrate.sh ../<python-service>
./integrate.sh ../<node-app>
```

All repos share the same central source files. Update once in central, every linked repo sees it instantly.
