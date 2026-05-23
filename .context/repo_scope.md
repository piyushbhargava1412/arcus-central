# Repository Scope: ARCUS Central

<!-- arcus-context-meta
verification-commit: cc8d06ae9d0ee4b6a897ab41851e297f4df63e9e
generated-at: 2026-05-23T12:11:28Z
confidence: high
-->

---

## Purpose

ARCUS Central is the authoritative distribution hub for the SDD (Spec Driven Development) framework. It owns all framework components — agents, skills, templates, guidelines, and integration scripts — and distributes them to target repositories via Bash scripts. This is a framework tooling repository, not a business service.

## Core Responsibilities

- Maintain and version 10 agent definitions (markdown files) that guide the SDD lifecycle in target repos
- Maintain 23 reusable skill instruction sets that agents delegate to
- Maintain 7 document templates for SDD artifacts (spec, plan, tasks, story, checklist, agent, instruction)
- Maintain 6 categories of engineering guidelines (architecture, engineering, language, infra, security, testing)
- Distribute all framework components to target repositories via `integrate.sh` / `arcus-integrate` CLI
- Provide `install-cli.sh` to register `arcus-integrate` as a global system command
- Provide `uninstall.sh` to remove managed framework artifacts from a target repository
- Provide helper scripts for feature story scaffolding in target repositories

## Major Implementation Areas

- **Agents** (`agents/`) — 10 agent markdown files; `core/` (6: specify, clarify, plan, tasks, analyze, implement) and `extensions/` (4: close, context-builder, groom, instructions)
- **Skills** (`skills/`) — 23 reusable skill instruction sets, each with a `SKILL.md` defining input contract, processing rules, and output contract
- **Templates** (`templates/`) — 7 SDD artifact templates used by agents in target repositories
- **Guidelines** (`guidelines/`) — Engineering, architecture, language (Java/Node.js/Python), infra, security, and testing standards; symlinked into target repos
- **Integration toolchain** — `integrate.sh` (framework distributor), `install-cli.sh` (CLI installer), `uninstall.sh` (cleanup); helper scripts in `scripts/bash/`
- **Prompts** (`prompts/`) — 10 agent prompt files paired with agent definitions for IDE discovery
- **Registry** (`registry/`) — `AGENT_REGISTRY.md` for agent discovery and capability reference; `skills/SKILLS_REGISTRY.md` for skills
- **Documentation** (`docs/`) — Conceptual docs covering philosophy, architecture, workflow, glossary, and quality gates

## Key Entry Surfaces

| Type   | Location                                | Purpose                                               |
|--------|-----------------------------------------|-------------------------------------------------------|
| Script | `integrate.sh`                          | Distribute framework to a target repo                 |
| Script | `install-cli.sh`                        | Install `arcus-integrate` global CLI command          |
| Script | `uninstall.sh`                          | Remove managed framework artifacts from a target repo |
| Script | `scripts/bash/create-new-feature.sh`    | Scaffold feature story directory in a target repo     |
| Script | `scripts/bash/setup-plan.sh`            | Scaffold plan artifact structure in a target repo     |

## Tech Stack Signals

| Category | Technology     | Evidence                                                               |
|----------|----------------|------------------------------------------------------------------------|
| Language | Bash           | `integrate.sh`, `install-cli.sh`, `uninstall.sh`, `scripts/bash/*.sh` |
| Format   | Markdown       | All agents, skills, templates, guidelines, prompts                     |
| Config   | JSON           | `.arcus-metadata.json`                                                 |
| Build    | None           | No build system; framework is Bash + Markdown                          |

## Source / Test / Config Roots

- Source: `agents/`, `skills/`, `prompts/`, `templates/`, `guidelines/`
- Scripts: `integrate.sh`, `install-cli.sh`, `uninstall.sh`, `scripts/bash/`
- Config: `.arcus-metadata.json`, `.arcus-ignore`, `VERSION`, `.editorconfig`
- Tests: No formal test suite
- Registry: `registry/AGENT_REGISTRY.md`, `skills/SKILLS_REGISTRY.md`

## Distribution Model

| Artifact                                  | Method                                           | Mutability                                           |
|-------------------------------------------|--------------------------------------------------|------------------------------------------------------|
| `templates/`, `scripts/`, `guidelines/`   | Symlinked into `.arcus/` in target repo          | Read-only via symlinks                               |
| `agents/`, `prompts/`, `skills/`          | Copied as read-only files to `.github/` in target | `chmod 444`; refreshed on `--sync`                  |
| `.arcus-ignore`                           | Copied once on first integration                 | Editable per-project; never overwritten on `--sync` |
| `.arcus-metadata.json`                    | Written to target repo root                      | Updated on each integration or `--sync`             |

## Boundaries / Exclusions

- Does not implement business logic, HTTP endpoints, databases, or event brokers
- Does not generate production code (agents guide implementation; they do not emit code)
- Does not own CI/CD pipeline definitions or deployment infrastructure
- `.github/agents/`, `.github/prompts/`, `.github/skills/`, `.arcus/scripts/`, `.arcus/templates/` are read-only distributed copies — excluded from ARCUS analysis per `.arcus-ignore`
- `.git/`, `.idea/`, `.venv/`, `.pytest_cache/`, `build/`, `dist/` excluded per `.arcus-ignore`
