# Apex Integration Guide

## Overview

The `apex-integrate` CLI command creates **read-only symlinks** from any target repository into the central Speckit repository. Source files in central are set read-only (`chmod a-w`) so that writing through symlinks is denied.

**One-way flow:** Central → Target. Zero file duplication. Instant updates.  
**Pull model:** Target repos pull apex — no bootstrap scripts needed in each repo.

---

## Quick Start (3 steps)

### Step 1: Clone the central repo (once per machine)

```bash
git clone <central-repo-url> ~/apex-central
```

### Step 2: Install the CLI command (once per machine)

```bash
cd ~/apex-central
./install-cli.sh
```

This installs `apex-integrate` to `/usr/local/bin/`.

### Step 3: Integrate any target repo (from inside the repo)

```bash
cd ~/projects/my-java-service
apex-integrate
```

That's it. Works for 1 repo or 100 repos — same single command.

---

## CLI Reference

| Command | Description |
|---------|-------------|
| `apex-integrate` | Integrate current directory |
| `apex-integrate --sync` | Re-create all symlinks (re-pull latest) |
| `apex-integrate --yes` | Skip confirmation prompts (CI/CD mode) |

### CI/CD Usage

Add to your project's `Makefile`:

```makefile
apex:
	apex-integrate --yes
```

Or in a CI pipeline step:

```yaml
- name: Integrate apex
  run: apex-integrate --yes
```

---

## Scaling to Multiple Repos

No per-repo setup needed. The same command works everywhere:

```bash
cd ~/projects/orders-service     && apex-integrate
cd ~/projects/payments-service   && apex-integrate
cd ~/projects/notifications-api  && apex-integrate
cd ~/projects/frontend-app       && apex-integrate
```

All repos share the same central source files. Update once in central, every linked repo sees it instantly.

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
| `.specify/templates` | Dir symlink | `central/templates` |
| `.specify/scripts` | Dir symlink | `central/scripts` |
| `.specify/instructions` | Dir symlink | `central/instructions` |
| `.github/agents/*.agent.md` | File symlinks (flat) | `central/agents/core/` + `extensions/` |
| `.github/prompts/*.prompt.md` | File symlinks (flat) | `central/prompts/core/` + `extensions/` |
| `.github/copilot-instructions.md` | File symlink | `central/agents/core/speckit.constitution.agent.md` |

All source files are read-only. All symlinks use relative paths.

---

## Target Repo After Integration

```
<target-repo>/
│
├── .specify/                                       ← Directory symlinks
│   ├── templates    → ../../speckit-central/templates
│   ├── scripts      → ../../speckit-central/scripts
│   └── instructions → ../../speckit-central/instructions
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
├── .specify-metadata.json
└── speckit-integration.log
```

---

## Prerequisites

- macOS or Linux
- Python 3 (for relative path calculation)
- Both repositories cloned on the local machine (any location)

---

## How Copilot / IntelliJ Discovers apex

1. **`.github/copilot-instructions.md`** — read automatically as global context
2. **`.github/agents/*.agent.md`** — appear in the Copilot agent picker (`@speckit.specify`, etc.)
3. **`.github/prompts/*.prompt.md`** — appear in the Copilot prompt picker

---

## What the Script Does

| Phase | Action |
|-------|--------|
| **Phase 0** | Sets all central source files read-only (`chmod a-w`) |
| **Phase 1** | Creates `.specify/` with 3 directory symlinks |
| **Phase 2** | Creates flat file symlinks in `.github/agents/` and `.github/prompts/` + `copilot-instructions.md` |
| **Phase 3** | Validates every symlink resolves and is read-only |
| **Phase 4** | Writes `.specify-metadata.json` |

---

## Installer Management

### Install

```bash
cd <apex-central-repo>
./install-cli.sh
```


### Uninstall

```bash
./install-cli.sh --uninstall
```

### If central repo moves

Re-run the installer from the new location:

```bash
cd <new-location>/apex-central
./install-cli.sh
```
