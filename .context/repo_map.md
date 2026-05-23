# Repository Map: ARCUS Central

<!-- arcus-context-meta
verification-commit: cc8d06ae9d0ee4b6a897ab41851e297f4df63e9e
generated-at: 2026-05-23T12:11:28Z
confidence: high
-->

---

## Overview

ARCUS Central is a Bash/Markdown framework repository with no build system or runtime process. All framework components are static Markdown files. Distribution is handled by shell scripts that create symlinks and copy files into target repositories.

## Top-Level Structure

```
arcus-central/
├── agents/            # Agent definitions (authoritative source)
│   ├── core/          # 6 core SDD agents
│   └── extensions/    # 4 extension agents
├── skills/            # Skill instruction sets (authoritative source)
│   ├── SKILLS_REGISTRY.md
│   └── <skill-name>/SKILL.md (x22)
├── prompts/           # Agent prompt files (authoritative source)
│   ├── core/
│   └── extensions/
├── templates/         # SDD artifact templates (7 files)
├── guidelines/        # Engineering standards (6 categories)
│   ├── architecture/
│   ├── engineering/
│   ├── infra/
│   ├── languages/
│   ├── security/
│   └── testing/
├── scripts/bash/      # Helper scripts for target repos
├── docs/              # Conceptual and reference documentation
├── registry/          # Agent registry (AGENT_REGISTRY.md)
├── integrate.sh       # Framework distribution script (entry point)
├── install-cli.sh     # Global CLI installer
├── uninstall.sh       # Framework removal script
├── VERSION            # Semantic version (currently 1.2.0)
├── .arcus-metadata.json  # Integration state metadata
├── .arcus-ignore      # ARCUS analysis exclusion patterns
└── .context/          # Shared ARCUS context artifacts (this directory)
```

## Key Packages / Modules

| Path                        | Responsibility                                                    |
|-----------------------------|-------------------------------------------------------------------|
| `agents/core/`              | 6 core agent definitions: specify, clarify, plan, tasks, analyze, implement |
| `agents/extensions/`        | 4 extension agents: close, context-builder, groom, instructions  |
| `skills/`                   | 22 skill instruction sets; each in own subdirectory with `SKILL.md` |
| `templates/`                | 7 SDD artifact templates referenced by agents                    |
| `guidelines/architecture/`  | Architecture principles                                           |
| `guidelines/engineering/`   | Clean code and engineering standards                              |
| `guidelines/languages/`     | Java, Node.js, Python idioms and language-agnostic conventions   |
| `guidelines/infra/`         | Infrastructure and deployment patterns                            |
| `guidelines/security/`      | Security standards and threat modeling                            |
| `guidelines/testing/`       | Testing guidelines and TDD practices                              |
| `scripts/bash/`             | `common.sh` (shared helpers), `create-new-feature.sh` (story scaffolding), `setup-plan.sh`, `check-prerequisites.sh` |
| `prompts/core/`             | Prompt files for 6 core agents                                   |
| `prompts/extensions/`       | Prompt files for 4 extension agents                              |
| `registry/`                 | `AGENT_REGISTRY.md` — machine-readable agent capability index    |

## Entry Surface Locations

| Type   | Path                                    | Notes                                               |
|--------|-----------------------------------------|-----------------------------------------------------|
| Script | `integrate.sh`                          | Main distribution script; also invoked via `arcus-integrate` CLI |
| Script | `install-cli.sh`                        | Installs `/usr/local/bin/arcus-integrate` shim      |
| Script | `uninstall.sh`                          | Removes managed artifacts from a target repo        |
| Script | `scripts/bash/create-new-feature.sh`    | Creates `.arcus/specs/<STORY-ID>/` in target repo  |
| Script | `scripts/bash/setup-plan.sh`            | Scaffolds plan artifact paths using `common.sh`     |
| Script | `scripts/bash/common.sh`               | Shared functions: `get_repo_root`, `get_current_branch`, `get_feature_paths` |

## Config Hotspots

- `.arcus-metadata.json` — Records integration state (timestamp, version, target/central paths, artifact locations)
- `.arcus-ignore` — ARCUS analysis exclusion patterns (editable per-project)
- `VERSION` — Framework version (`1.2.0`)
- `.editorconfig` — Editor formatting standards

## Integration / Adapter Areas

No external system integrations. The sole integration mechanism is file system operations:

- Symlink creation from target repo's `.arcus/` → central `templates/`, `scripts/`, `guidelines/`
- File copy (read-only) from central `agents/`, `prompts/`, `skills/` → target repo's `.github/`
- File copy (once) of `.arcus-ignore` to target repo root

## Test Locations

- No formal test suite for framework components


## Notable Patterns

- **Symlink-first distribution** — `templates/`, `scripts/`, `guidelines/` distributed as symlinks (instant central updates propagate to all integrated repos)
- **Copy-only for agent discovery** — `agents/`, `prompts/`, `skills/` distributed as `chmod 444` copies because IntelliJ agent tab does not follow symlinks
- **Read-only enforcement** — Central source files are `chmod a-w`; distributed copies are `chmod 444`
- **Single-entry orchestration** — `integrate.sh` drives all distribution logic; `install-cli.sh` wraps it in a system command
- **One-way pull model** — Target repos invoke `arcus-integrate` (or `integrate.sh`) from central; central never pushes
- **`.arcus-ignore` preserved on sync** — Allows per-project customisation without central overwrite
