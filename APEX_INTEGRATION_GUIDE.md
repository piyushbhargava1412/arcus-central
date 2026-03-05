# APEX SDD Framework Integration Guide

## Overview

**APEX** is the team. **SDD (Spec Driven Development)** is the methodology. This guide shows how to integrate the SDD framework into any target repository.

The integration uses a **hybrid approach**:

| What | How | Why |
|------|-----|-----|
| `.apex/` (templates, scripts, instructions) | **Symlinks** to central repo | Zero duplication, instant updates |
| `.github/agents/` and `.github/prompts/` | **Read-only copies** (chmod 444) | IntelliJ agent tab does not follow symlinks |
| `.apex-ignore` | **Copied once** (never overwritten) | Tells agents which paths to skip during analysis |

**One-way flow:** Central → Target. Pull model — target repos run the central script.

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

| Command                    | Description                                       |
| -------------------------- | ------------------------------------------------- |
| `apex-integrate`           | Integrate current directory                       |
| `apex-integrate --sync`    | Re-create symlinks and re-copy agent/prompt files |
| `apex-integrate --remove`  | Remove managed integration artifacts (preserves `.apex/instructions`) |
| `apex-integrate --yes`     | Skip confirmation prompts (CI/CD mode)            |

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

`.apex/` symlinks share central files — instant updates.
`.github/` copies need `apex-integrate --sync` to pull latest agent/prompt changes.
`.apex-ignore` is copied once on first integration — customize it per project.

---

## How Protection Works

**Symlinks (`.apex/`):** Central source files are set `chmod a-w`. Writing through symlinks → `permission denied`.

**Copies (`.github/`):** Agent and prompt files are copied with `chmod 444`. Cannot be edited in any IDE.

```
$ echo "test" >> .github/agents/sdd.specify.agent.md
zsh: permission denied
```

---

## What Gets Created

| Location                      | Type                 | Points To                               |
| ----------------------------- | -------------------- | --------------------------------------- |
| `.apex/templates`             | Dir symlink          | `central/templates`                     |
| `.apex/scripts`               | Dir symlink          | `central/scripts`                       |
| `.apex/instructions`          | Dir symlink          | `central/instructions`                  |
| `.github/agents/*.agent.md`   | File symlinks (flat) | `central/agents/core/` + `extensions/`  |
| `.github/prompts/*.prompt.md` | File symlinks (flat) | `central/prompts/core/` + `extensions/` |
| `.github/skills/`             | Dir symlink          | `central/skills`                        |
| `.apex-ignore`                | Copied once        | `central/.apex-ignore`                  | Editable (user-owned)   |

All source files are read-only. All symlinks use relative paths.

---

## Target Repo After Integration

```
<target-repo>/
│
├── .apex/                                       ← Symlinks to central
│   ├── templates    → ../../apex-central/templates
│   ├── scripts      → ../../apex-central/scripts
│   └── instructions → ../../apex-central/instructions
│
├── .github/
│   ├── agents/                                  ← Read-only copies (chmod 444)
│   │   ├── sdd.analyze.agent.md
│   │   ├── sdd.clarify.agent.md
│   │   ├── sdd.groom.agent.md
│   │   ├── sdd.groom-story.agent.md
│   │   ├── sdd.implement.agent.md
│   │   ├── sdd.instructions.agent.md
│   │   ├── sdd.plan.agent.md
│   │   ├── sdd.repo-intelligence.agent.md
│   │   ├── sdd.specify.agent.md
│   │   └── sdd.tasks.agent.md
│   ├── prompts/                                   ← Flat file symlinks (SDD prompts)
│   │   ├── sdd.analyze.prompt.md
│   │   ├── sdd.clarify.prompt.md
│   │   ├── sdd.groom.prompt.md
│   │   ├── sdd.implement.prompt.md
│   │   ├── sdd.instructions.prompt.md
│   │   ├── sdd.plan.prompt.md
│   │   ├── sdd.repo-intelligence.prompt.md
│   │   ├── sdd.specify.prompt.md
│   │   └── sdd.tasks.prompt.md
│   ├── skills/                                    ← Directory symlink (Agent skills)
│   │   └── instruction-architecture.skills.md
│   ├── pull_request_template.md                   ← Existing (untouched)
│   └── workflows/                                 ← Existing (untouched)
│
├── .apex-ignore                                 ← Copied once (editable per project)
└── .apex-metadata.json
```

---

## .apex-ignore

The `.apex-ignore` file tells the `sdd.instructions` agent which paths to skip when analyzing a target repo's structure. It works like `.gitignore` — one pattern per line.

- Copied from central on **first integration only** — never overwritten
- Users can **customize** it per project (e.g. add project-specific exclusions)
- Re-running `apex-integrate --sync` does **not** replace an existing `.apex-ignore`

Default exclusions include: `node_modules/`, `dist/`, `build/`, `.idea/`, `.git/`, `.apex/`, `.github/agents/`, `.github/prompts/`, etc.

---

## Prerequisites

- macOS or Linux
- Python 3 (for relative path calculation)
- Both repositories cloned on the local machine

---

## How Copilot / IDE Discovers SDD Agents

1. **`.github/agents/*.agent.md`** — appear in the Copilot agent picker (`/sdd.specify`, `/sdd.plan`, etc.)
2. **`.github/prompts/*.prompt.md`** — available for SDD workflow prompts

These must be real files (not symlinks) for IntelliJ to discover them.

---

## What the Script Does

| Phase         | Action                                                                 |
| ------------- | ---------------------------------------------------------------------- |
| **Phase 0**   | Sets all central source files read-only (`chmod a-w`)                  |
| **Phase 0.5** | (Sync only) Cleans up existing symlinks and copied files               |
| **Phase 1**   | Creates `.apex/` with 3 directory symlinks                             |
| **Phase 2**   | Copies agent/prompt files into `.github/` as read-only (chmod 444)     |
| **Phase 2.5** | Copies `.apex-ignore` template (only if not already present)           |
| **Phase 3**   | Validates symlinks resolve and copied files are read-only              |
| **Phase 4**   | Writes `.apex-metadata.json`                                           |

---

## Removing the Framework

To remove all integration artifacts from a target repository:

```bash
cd ~/projects/my-service
apex-integrate --remove
```

**What gets removed:**
- ✅ `.apex/templates/` (symlink)
- ✅ `.apex/scripts/` (symlink)
- ✅ `.github/agents/*.agent.md` (copied agent files)
- ✅ `.github/prompts/*.prompt.md` (copied prompt files)
- ✅ `.apex-ignore` (configuration file)
- ✅ `.apex-metadata.json` (metadata)

**What is preserved:**
- ✅ `.apex/instructions/` (symlink) — developers may reference this in their `.github/copilot-instructions.md`
- ✅ `.apex/` folder itself (in case you've added local artifacts)
- ✅ Other `.github/` files and subdirectories (workflows, actions, etc.)
- ✅ Project source code and configuration
- ✅ Git history and other files

**Use cases:**
- Testing integration/removal workflows
- Cleaning up after evaluating the framework
- Switching integration strategies
- CI/CD cleanup tasks

**Non-interactive usage (CI/CD):**
```bash
apex-integrate --remove --yes
```

---

## Installer Management

### Install

```bash
cd <apex-central-repo>
./install-cli.sh
```

### Uninstall

```bash
cd <apex-central-repo>
./uninstall.sh
```

This removes the `apex-integrate` command from `/usr/local/bin/`.

### If central repo moves

Re-run the installer from the new location:

```bash
cd <new-location>/apex-central
./install-cli.sh
```
