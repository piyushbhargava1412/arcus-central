# ARCUS SDD Framework Integration Guide

## Overview

**ARCUS** (**A**ny **R**epo **C**an **U**se **S**DD) is the brand. **SDD (Spec Driven Development)** is the methodology. This guide shows how to integrate the SDD framework into any target repository.

The integration uses a **hybrid approach**:

| What | How | Why |
|------|-----|-----|
| `.arcus/` (templates, scripts, guidelines) | **Symlinks** to central repo | Zero duplication, instant updates |
| `.github/agents/` and `.github/prompts/` | **Read-only copies** (chmod 444) | IntelliJ agent tab does not follow symlinks |
| `.arcus-ignore` | **Copied once** (never overwritten) | Tells agents which paths to skip during analysis |

**One-way flow:** Central → Target. Pull model — target repos run the central script.

---

## Quick Start (3 steps)

### Step 1: Clone the central repo (once per machine)

```bash
git clone <central-repo-url> ~/bigfin_arcus-central
```

### Step 2: Install the CLI command (once per machine)

```bash
cd ~/bigfin_arcus-central
./install-cli.sh
```

This installs `arcus-integrate` to `/usr/local/bin/`.

### Step 3: Integrate any target repo (from inside the repo)

```bash
cd ~/projects/my-java-service
arcus-integrate
```

That's it. Works for 1 repo or 100 repos — same single command.

---

## CLI Reference

| Command                    | Description                                       |
| -------------------------- | ------------------------------------------------- |
| `arcus-integrate`           | Integrate current directory                       |
| `arcus-integrate --sync`    | Re-create symlinks and re-copy agent/prompt files |
| `arcus-integrate --remove`  | Remove managed integration artifacts (preserves `.arcus/guidelines`) |
| `arcus-integrate --yes`     | Skip confirmation prompts (CI/CD mode)            |

---

## Scaling to Multiple Repos

No per-repo setup needed. The same command works everywhere:

```bash
cd ~/projects/orders-service     && arcus-integrate
cd ~/projects/payments-service   && arcus-integrate
cd ~/projects/notifications-api  && arcus-integrate
cd ~/projects/frontend-app       && arcus-integrate
```

`.arcus/` symlinks share central files — instant updates.
`.github/` copies need `arcus-integrate --sync` to pull latest agent/prompt changes.
`.arcus-ignore` is copied once on first integration — customize it per project.

---

## How Protection Works

**Symlinks (`.arcus/`):** Central source files are set `chmod a-w`. Writing through symlinks → `permission denied`.

**Copies (`.github/`):** Agent and prompt files are copied with `chmod 444`. Cannot be edited in any IDE.

```
$ echo "test" >> .github/agents/sdd.specify.agent.md
zsh: permission denied
```

---

## What Gets Created

| Location                      | Type                 | Points To                               | Contents |
| ----------------------------- | -------------------- | --------------------------------------- | -------- |
| `.arcus/templates`             | Dir symlink          | `central/templates`                     | 11 artifact templates |
| `.arcus/scripts`               | Dir symlink          | `central/scripts`                       | Bash automation scripts |
| `.arcus/instructions`          | Dir symlink          | `central/guidelines`                  | Engineering guidelines |
| `.github/agents/*.agent.md`   | Read-only copies (chmod 444) | `central/agents/` (core + extensions)  | 9 SDD agents |
| `.github/prompts/*.prompt.md` | Read-only copies (chmod 444) | `central/prompts/` (core + extensions) | 8 SDD prompts |
| `.github/skills/`             | Dir symlink          | `central/skills`                        | 22 reusable skills (10 domains) |
| `.arcus-ignore`                | Copied once        | `central/.arcus-ignore`                  | Editable (user-owned) |

All source files are read-only. All symlinks use relative paths.

---

## Target Repo After Integration

```
<target-repo>/
│
├── .arcus/                                       ← Symlinks to central
│   ├── templates    → ../../arcus-central/templates
│   ├── scripts      → ../../arcus-central/scripts
│   └── instructions → ../../arcus-central/guidelines
│
├── .github/
│   ├── agents/                                  ← Read-only copies (chmod 444)
│   │   ├── sdd.analyze.agent.md
│   │   ├── sdd.clarify.agent.md
│   │   ├── sdd.context-builder.agent.md
│   │   ├── sdd.groom.agent.md
│   │   ├── sdd.implement.agent.md
│   │   ├── sdd.instructions.agent.md
│   │   ├── sdd.plan.agent.md
│   │   ├── sdd.specify.agent.md
│   │   └── sdd.tasks.agent.md
│   ├── prompts/                                 ← Read-only copies (chmod 444)
│   │   ├── sdd.analyze.prompt.md
│   │   ├── sdd.clarify.prompt.md
│   │   ├── sdd.groom.prompt.md
│   │   ├── sdd.implement.prompt.md
│   │   ├── sdd.instructions.prompt.md
│   │   ├── sdd.plan.prompt.md
│   │   ├── sdd.specify.prompt.md
│   │   └── sdd.tasks.prompt.md
│   ├── skills/                                  ← Directory symlink (22 reusable skills)
│   ├── copilot-instructions.md                  ← Generated during bootstrap (Stage 2)
│   ├── pull_request_template.md                 ← Existing (untouched)
│   └── workflows/                               ← Existing (untouched)
│
├── .context/                                    ← Generated during bootstrap (Stage 1)
│   ├── repo_scope.md
│   ├── repo_map.md
│   ├── flows/
│   │   ├── <flow-1>.md
│   │   ├── <flow-2>.md
│   │   └── ...
│   └── testing-patterns.md
│
├── .arcus-ignore                                ← Copied once (editable per project)
└── .arcus-metadata.json
```

---

## Understanding the Integrated Framework

### Bootstrap Artifacts (`.context/`)

After integration, the framework requires **two bootstrap stages** to be run once per repository:

- **Stage 1: Context Building** (`/sdd.context-builder`) — Scans the target repo to generate:
  - `.context/repo_scope.md` (business capabilities)
  - `.context/repo_map.md` (technical topology)
  - `.context/flows/*.md` (business flows)
  - `.context/testing-patterns.md` (testing conventions)

- **Stage 2: Instructions Creation** (`/sdd.instructions`) — Uses context to generate:
  - `.github/copilot-instructions.md` (repo-specific guardrails)

These `.context/` artifacts are **read-only** (generated by the framework) and **shared** across the team. They enable agents to work efficiently without scanning the entire repository each time.

### Agent & Prompt Files

The `.github/agents/` and `.github/prompts/` directories contain **read-only copies** (chmod 444) of all SDD agents and prompts:

- **9 Agents** (6 core + 3 extensions): `specify`, `clarify`, `plan`, `tasks`, `analyze`, `implement`, `context-builder`, `groom`, `guidelines`
- **8 Prompts** (6 core + 2 extensions): Corresponding prompts for agents (no separate prompt for `context-builder`)

These are **read-only** to prevent accidental modification while maintaining IDE/Copilot discoverability.

### Shared Templates, Scripts, Guidelines & Skills

The `.arcus/` symlinks and `.github/skills/` symlink provide **read-only access** to shared framework components:

- **Templates** (11): Specification, plan, tasks, checklist, and other artifact templates
- **Guidelines** (5): Engineering, architecture, language, infrastructure, and testing guidelines
- **Scripts**: Bash automation scripts for common tasks
- **Skills** (22): Reusable capability-based skills organized across 10 domains (core, artifact, reasoning, discovery, context, interaction, formatting, maintenance, foundation, specialized)

All skills are available for agents to delegate to during analysis and implementation phases.

---

## .arcus-ignore

The `.arcus-ignore` file tells the `sdd.context-builder` agent which paths to skip when analyzing repository structure during Stage 1 (Context Building). It works like `.gitignore` — one pattern per line.

- Copied from central on **first integration only** — never overwritten
- Users can **customize** it per project (e.g. add project-specific exclusions)
- Re-running `arcus-integrate --sync` does **not** replace an existing `.arcus-ignore`

Default exclusions include: `node_modules/`, `dist/`, `build/`, `.idea/`, `.git/`, `.arcus/`, `.github/agents/`, `.github/prompts/`, `vendor/`, `target/`, etc.

Used during: **Stage 1** (Context Building) to exclude irrelevant paths from analysis

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
| **Phase 1**   | Creates `.arcus/` with 3 directory symlinks                             |
| **Phase 2**   | Copies agent/prompt files into `.github/` as read-only (chmod 444)     |
| **Phase 2.5** | Copies `.arcus-ignore` template (only if not already present)           |
| **Phase 3**   | Validates symlinks resolve and copied files are read-only              |
| **Phase 4**   | Writes `.arcus-metadata.json`                                           |

---

## Removing the Framework

To remove all integration artifacts from a target repository:

```bash
cd ~/projects/my-service
arcus-integrate --remove
```

**What gets removed:**
- ✅ `.arcus/templates/` (symlink)
- ✅ `.arcus/scripts/` (symlink)
- ✅ `.github/agents/*.agent.md` (copied agent files)
- ✅ `.github/prompts/*.prompt.md` (copied prompt files)
- ✅ `.arcus-ignore` (configuration file)
- ✅ `.arcus-metadata.json` (metadata)

**What is preserved:**
- ✅ `.arcus/instructions/` (symlink) — developers may reference this in their `.github/copilot-instructions.md`
- ✅ `.arcus/` folder itself (in case you've added local artifacts)
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
arcus-integrate --remove --yes
```

---

## Installer Management

### Install

```bash
cd <arcus-central-repo>
./install-cli.sh
```

### Uninstall

```bash
cd <arcus-central-repo>
./uninstall.sh
```

This removes the `arcus-integrate` command from `/usr/local/bin/`.

### If central repo moves

Re-run the installer from the new location:

```bash
cd <new-location>/arcus-central
./install-cli.sh
```
