# Copilot Instruction Architecture: ARCUS Central
# Copilot Instruction Architecture: ARCUS Central

**Version**: 1.0.0  
**Last Updated**: 2026-05-23  
**Framework**: SDD (Spec Driven Development)
**Last Updated**: 2026-05-23  
**Framework**: SDD (Spec Driven Development)

---

## Project Context

### Repository Summary

| Field | Value |
|---|---|
| **Repository** | `arcus-central` |
| **Purpose** | Authoritative distribution hub for the ARCUS SDD framework — maintains and distributes agents, skills, templates, guidelines, and integration scripts to target repositories |
| **Stage** | Active development |
| **Architecture Style** | Framework distribution hub — no runtime process, no application code |
| **Primary Languages** | Bash (scripts), Markdown (all framework components) |
| **Authoritative Tech Docs** | [`.context/repo_map.md`](../.context/repo_map.md) · [`.context/repo_scope.md`](../.context/repo_scope.md) |

### Technology Stack

> **Full tech stack details**: See [`.context/repo_map.md` → Overview](../.context/repo_map.md#overview)

### Key Modules

> **Full module map**: See [`.context/repo_map.md` → Key Packages / Modules](../.context/repo_map.md#key-packages--modules)

---

## System Functionalities

> **Full responsibilities and boundaries**: See [`.context/repo_scope.md` → Core Responsibilities](.context/repo_scope.md#core-responsibilities)

---

## Business Flows

_Load only the flow relevant to your current task._

- [Framework distribution](../.context/flows/framework-distribution.md)
- [CLI installation](../.context/flows/cli-installation.md)
- [Framework removal](../.context/flows/framework-removal.md)
- [Feature story scaffolding](../.context/flows/feature-story-scaffolding.md)

---

## Testing Conventions

> **Repo testing conventions**: See [`.context/testing-patterns.md`](../.context/testing-patterns.md)

---

## Engineering Standards & Guidelines

All engineering principles, architecture guidelines, language standards, testing requirements, and infrastructure patterns are defined in the following guideline files:

**Engineering & Code Quality**:
- See [guidelines/engineering/engineering-guidelines.md](../guidelines/engineering/engineering-guidelines.md)
- See [guidelines/engineering/clean-code-guidelines.md](../guidelines/engineering/clean-code-guidelines.md)

**Architecture & System Design**:
- See [guidelines/architecture/architecture-guidelines.md](../guidelines/architecture/architecture-guidelines.md)

**Language & Coding Standards**:
- See [guidelines/languages/language-guidelines.md](../guidelines/languages/language-guidelines.md)
- Bash: N/A (no dedicated guideline file)
- Java: See [guidelines/languages/java.md](../guidelines/languages/java.md) — for target repos using Java; not applicable to this repository
- Node.js: See [guidelines/languages/nodejs.md](../guidelines/languages/nodejs.md) — for target repos using Node.js; not applicable to this repository
- Python: See [guidelines/languages/python.md](../guidelines/languages/python.md) — minor applicability (skill-builder helper scripts only)

**Testing & Quality Assurance**:
- See [guidelines/testing/testing-guidelines.md](../guidelines/testing/testing-guidelines.md)
- See [guidelines/testing/tdd-guidelines.md](../guidelines/testing/tdd-guidelines.md)

**Infrastructure & Deployment**:
- See [guidelines/infra/infrastructure-guidelines.md](../guidelines/infra/infrastructure-guidelines.md)

**Security**:
- See [guidelines/security/security.md](../guidelines/security/security.md)

### Language Guidelines

_These are best practice suggestions. Existing repository conventions take precedence._

- Bash: N/A (guideline not yet available)
- Python (minor): See [guidelines/languages/python.md](../guidelines/languages/python.md)

---

## Project-Specific Overrides

### Authoritative Source Directories

The following directories are the **authoritative sources** for all framework components:

- `agents/` — agent definitions (NOT `.github/agents/`)
- `skills/` — skill instruction sets (NOT `.github/skills/`)
- `prompts/` — agent prompts (NOT `.github/prompts/`)
- `templates/` — SDD artifact templates
- `guidelines/` — engineering standards

### Managed Read-Only Copies — MUST NOT Edit

`.github/agents/`, `.github/prompts/`, `.github/skills/` are read-only copies managed by `integrate.sh`. **Never edit these directly.** Changes must be made in the authoritative source directories above; run `arcus-integrate --sync` to propagate.

### No Application Code

This repository contains **no application code**. All Copilot analysis MUST be scoped to framework components only (agents, skills, templates, guidelines, scripts). Do not generate service code, REST endpoints, data models, or business logic.

### Skill Count

The authoritative `skills/` directory contains **22 skills**. The `skill-builder` skill exists only in `.github/skills/` (a managed copy). If adding a new skill, create it in `skills/` first.

### .arcus-ignore Compliance

Always check `.arcus-ignore` before analyzing. Excluded paths MUST NOT appear in any generated artifacts. Key excluded paths: `.github/agents/`, `.github/prompts/`, `.github/skills/`, `.arcus/scripts/`, `.arcus/templates/`.

---

## Conventions Override

> **Repository conventions always take precedence over generic guidelines.** The patterns, structure, and standards already established in this repository (as captured in `.context/`) are the authoritative source. Guideline files under `guidelines/` provide best practice suggestions to fill gaps — they must not be used to override or restructure existing repository conventions unless the user explicitly requests a change.
### No Application Code

This repository contains **no application code**. All Copilot analysis MUST be scoped to framework components only (agents, skills, templates, guidelines, scripts). Do not generate service code, REST endpoints, data models, or business logic.

### Skill Count

The authoritative `skills/` directory contains **22 skills**. The `skill-builder` skill exists only in `.github/skills/` (a managed copy). If adding a new skill, create it in `skills/` first.

### .arcus-ignore Compliance

Always check `.arcus-ignore` before analyzing. Excluded paths MUST NOT appear in any generated artifacts. Key excluded paths: `.github/agents/`, `.github/prompts/`, `.github/skills/`, `.arcus/scripts/`, `.arcus/templates/`.

---

## Conventions Override

> **Repository conventions always take precedence over generic guidelines.** The patterns, structure, and standards already established in this repository (as captured in `.context/`) are the authoritative source. Guideline files under `guidelines/` provide best practice suggestions to fill gaps — they must not be used to override or restructure existing repository conventions unless the user explicitly requests a change.

---

## Agent Behavioral Rules

### Repository Analysis

1. **ALWAYS** check `.arcus-ignore` before analyzing the repository
2. **ALWAYS** exclude paths matching `.arcus-ignore` patterns from all analysis and artifacts
3. **NEVER** mention `.github/agents/`, `.github/prompts/`, `.github/skills/` as sources of truth
4. **ONLY** document framework components in `agents/`, `skills/`, `prompts/`, `templates/`, `guidelines/`

### Editing Framework Components

1. **READ** the existing `SKILL.md` or agent file before editing it
2. **PRESERVE** the YAML frontmatter block at the top of every `SKILL.md`
3. **VALIDATE** that cross-references to other skills/templates remain accurate after edits
4. **NEVER** edit files under `.github/agents/`, `.github/prompts/`, `.github/skills/` directly

### Quality Assurance

1. **ENFORCE** no unexplained bracket tokens `[...]` remain in generated artifacts
2. **CHECK** all markdown links resolve to actual files before writing
3. **ENSURE** `arcus-context-meta` blocks are present in all `.context/` artifacts
1. **ALWAYS** check `.arcus-ignore` before analyzing the repository
2. **ALWAYS** exclude paths matching `.arcus-ignore` patterns from all analysis and artifacts
3. **NEVER** mention `.github/agents/`, `.github/prompts/`, `.github/skills/` as sources of truth
4. **ONLY** document framework components in `agents/`, `skills/`, `prompts/`, `templates/`, `guidelines/`

### Editing Framework Components

1. **READ** the existing `SKILL.md` or agent file before editing it
2. **PRESERVE** the YAML frontmatter block at the top of every `SKILL.md`
3. **VALIDATE** that cross-references to other skills/templates remain accurate after edits
4. **NEVER** edit files under `.github/agents/`, `.github/prompts/`, `.github/skills/` directly

### Quality Assurance

1. **ENFORCE** no unexplained bracket tokens `[...]` remain in generated artifacts
2. **CHECK** all markdown links resolve to actual files before writing
3. **ENSURE** `arcus-context-meta` blocks are present in all `.context/` artifacts

---

## Amendment Log

| Version | Date       | Change Summary                        | Type  |
|---------|------------|---------------------------------------|-------|
| 1.0.0   | 2026-05-23 | Initial creation from fresh context   | MAJOR |
| Version | Date       | Change Summary                        | Type  |
|---------|------------|---------------------------------------|-------|
| 1.0.0   | 2026-05-23 | Initial creation from fresh context   | MAJOR |

---

**Maintained by**: `sdd.instructions` agent  
**Next Review**: 2026-08-23
**Maintained by**: `sdd.instructions` agent  
**Next Review**: 2026-08-23
