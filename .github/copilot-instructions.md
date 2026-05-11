# ARCUS Central — Copilot Instructions

**Version**: 1.0.0  
**Last Updated**: 2026-04-29  
**Repository**: bigfin_arcus-central  
**Purpose**: Spec Driven Development (SDD) framework distribution hub

---

## Project Context

ARCUS Central is the authoritative distribution hub for the Spec Driven Development (SDD) methodology. It provides:
- **10 Agents** that guide specification, planning, analysis, and implementation workflows
- **23 Reusable Skills** that agents delegate to for focused capabilities
- **11 Document Templates** for specs, plans, tasks, and context artifacts
- **Instruction Architecture** (guidelines for engineering, architecture, languages, infrastructure, testing)
- **Integration Automation** (Bash scripts that distribute framework to target repositories)

The framework is **Bash/Markdown-based**; no business logic or application code exists in this repository.

## Architecture Style

**Distributed Agent/Skill Framework** — Agents orchestrate; skills implement. Modular, stateless, test-driven component architecture with evidence-based context generation.

---

## Core Principles (Project-Specific Governance)

### P1: Agent Governance — Mandatory

When **creating or modifying agents**:
- **MUST** follow the structure defined in `templates/agent-file-template.md`
- **MUST** update `registry/AGENT_REGISTRY.md` with agent metadata (name, role, scope, capabilities, delegation model)
- **MUST** refresh `.context/` after agent changes using `sdd.context-builder` agent
- **SHOULD** create an associated prompt file in `prompts/` and register in `registry/`
- **MUST** include: role, scope, delegation model, input/output specs, error handling

**Rationale**: Agents are the primary interface for the framework. Consistency in structure, registration, and context ensures discoverability and reliable delegation.

### P2: Skill Governance — Mandatory

When **creating or modifying skills**:
- **MUST** follow structure defined in `skills/[category]/SKILL.md` (metadata + implementation details)
- **MUST** include: input contract, output contract, processing rules, dependencies, error handling
- **MUST** update `skills/SKILLS_REGISTRY.md` with skill metadata (name, domain, inputs, outputs, reusability notes)
- **MUST** refresh `.context/` after skill changes using `sdd.context-builder` agent
- **SHOULD** organize skills by capability domain (foundation, discovery, context, artifact, core, reasoning, specialized, formatting, maintenance, interaction)

**Rationale**: Skills are the building blocks of agent orchestration. Proper registration and governance ensure skills can be discovered, composed, and reused reliably across agents.

### P3: Documentation Strategy — Mandatory

When **maintaining documentation**, follow this priority:
1. **ALWAYS** create/update `.context/` artifacts:
   - `.context/repo_scope.md` — Business capabilities, component responsibilities, integration model
   - `.context/repo_map.md` — Technical topology, directory structure, tech stack, entry points
   - `.context/flows/` — Key execution flows (integration, agent execution, skill delegation)
   - `.context/testing-patterns.md` — How framework components are validated

2. **ALWAYS** maintain core documentation:
   - `README.md` — Project overview and quick start
   - `ARCUS_INTEGRATION_GUIDE.md` — Integration guide and CLI reference
   - `registry/AGENT_REGISTRY.md` — All agents and their capabilities
   - `skills/SKILLS_REGISTRY.md` — All skills and domains
   - `docs/SDD-Flow-Diagram.md` — Visual workflow representation

3. **AVOID** creating additional how-to guides, tutorials, or comprehensive documentation unless explicitly requested

4. **MUST** review and update `.context/` artifacts after every significant change (new agents, skills, features)

5. **NEVER** generate auto-summaries, final summaries, or comprehensive summaries unless explicitly requested by the user

**Rationale**: ARCUS is a framework distribution hub. Over-documentation creates maintenance burden. `.context/` serves as the authoritative, concise guide; registry files enable discovery; core docs guide integration.

### P4: Context Refresh — Mandatory

**After any of the following changes**:
- New agent added or agent structure modified
- New skill added or skill interface changed
- New template added
- Integration model changed
- Distribution strategy changed
- New instruction file added

**Action**: Run `sdd.context-builder` agent to refresh `.context/repo_scope.md` and `.context/repo_map.md`

**Rationale**: Context drift leads to hallucinations and incorrect agent behavior. Keeping `.context/` aligned with implementation is non-negotiable.

---

## Engineering References

The following instruction files define reusable guidelines that target repositories inherit:

| Guideline | Purpose | Reference |
|-----------|---------|-----------|
| Engineering Standards | Code quality, patterns, design principles | `guidelines/engineering/engineering-guidelines.md` |
| Clean Code | SOLID principles, code clarity, maintainability | `guidelines/engineering/clean-code-guidelines.md` |
| Architecture Principles | System design, modularity, scalability, resilience | `guidelines/architecture/architecture-guidelines.md` |
| Language Conventions | Language-specific standards and idioms | `guidelines/languages/language-guidelines.md` |
| Language-Specific Guides | Java, Node.js, Python idioms and patterns | `guidelines/languages/java.md`, `guidelines/languages/nodejs.md`, `guidelines/languages/python.md` |
| Infrastructure Patterns | Deployment, configuration, infrastructure | `guidelines/infra/infrastructure-guidelines.md` |
| Testing Standards | Test writing, coverage, test-driven development | `guidelines/testing/testing-guidelines.md` |
| TDD Guidelines | Test-driven development practices | `guidelines/testing/tdd-guidelines.md` |
| Security Standards | Security principles, threat modeling, secure coding | `guidelines/security/security.md` |

---

## Repository Scope & Configuration

### Respecting `.arcus-ignore`

- **ALWAYS** check `.arcus-ignore` file before analyzing repository structure
- **ALWAYS** exclude paths matching `.arcus-ignore` patterns from analysis
- **NEVER** mention ignored paths in any artifacts, documentation, or instructions
- **TREAT** ignored paths as if they don't exist (especially `.arcus/`, `.github/agents/`, `.github/prompts/`, `.github/skills/`)

**Rationale**: `.arcus-ignore` defines framework components that are distributed infrastructure, not application code. Ignoring these prevents pollution of generated context artifacts and keeps analysis focused on actual application logic.

### Documentation Scope

- **Document:** Application code, business logic, actual features in non-ignored paths
- **Document:** Project-specific configuration, constraints, custom patterns
- **DO NOT Document:** Framework components (agents, skills, templates, scripts)
- **DO NOT Document:** Ignored paths or framework tooling

---

## Implementation Constraints

- **No business logic in this repository** — Framework components only (agents, skills, templates, guidelines)
- **No code generation in agents** — Agents guide implementation; they delegate to skills for generation
- **Bash/Markdown only** — No additional programming languages without explicit approval
- **Symlink-first distribution** — For templates, scripts, instructions (instant updates to integrated repos)
- **Copy-only for agents/prompts** — Due to IntelliJ agent discovery limitations
- **Read-only enforcement** — Central sources as `chmod a-w`; copies as `chmod 444`

---

## Agent Behavioral Rules

### Repository Analysis

1. **ALWAYS** check `.arcus-ignore` before analyzing repository structure
2. **ALWAYS** exclude paths matching `.arcus-ignore` patterns from all analysis
3. **NEVER** mention ignored paths in any artifacts or documentation
4. **ONLY** document application code found in non-ignored paths

### Framework Context Management

1. **ALWAYS** refresh `.context/` after structural changes using `sdd.context-builder`
2. **ALWAYS** validate artifacts generated are in scope for target repositories
3. **NEVER** generate or assume content beyond evidence from actual codebase
4. **ONLY** reference `.context/` as authoritative repository intelligence

---

## Quality Gates

Before merging changes to this repository:

1. ✅ **Agent/Skill Registration**: All new agents/skills registered in appropriate registry
2. ✅ **Structure Compliance**: Follows relevant template (agent, skill, instruction)
3. ✅ **Context Alignment**: `.context/` updated if scope/capabilities changed
4. ✅ **Cross-Reference Accuracy**: All registry links validate; no broken references
5. ✅ **Markdown Validation**: Valid Markdown syntax; no unresolved links
6. ✅ **Documentation Completeness**: Input/output contracts, error handling, dependencies documented

---

## Amendment Log

| Version | Date | Type | Summary |
|---------|------|------|---------|
| 1.0.1 | 2026-05-07 | MINOR | Added "Repository Scope & Configuration" and "Agent Behavioral Rules" sections. Explicitly documented `.arcus-ignore` patterns, repository analysis constraints, and framework context management rules per instruction-template.md. |
| 1.0.0 | 2026-04-29 | INIT | Initial copilot instructions created for ARCUS Central framework hub. Established agent governance (P1), skill governance (P2), documentation strategy (P3), and context refresh (P4) as mandatory principles. |

---

## See Also

- [Repository Scope](../.context/repo_scope.md) — Business capabilities, component architecture
- [Repository Map](../.context/repo_map.md) — Technical topology, directory structure
- [Agent Registry](../registry/AGENT_REGISTRY.md) — All agents and their capabilities
- [Skill Registry](../skills/SKILLS_REGISTRY.md) — All skills and domains
- [Integration Guide](../ARCUS_INTEGRATION_GUIDE.md) — CLI usage and integration workflow


