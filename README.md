# Why ARCUS - Spec Driven Development Distribution Framework

## The Problem

LLM-powered coding agents are remarkably capable but share a common failure mode: they produce confident, plausible output that drifts from what was actually intended. Left unconstrained, an agent will:

- Make architectural decisions that belong in a design review
- Implement what it infers rather than what was specified
- Scan the entire codebase on every invocation, consuming tokens on irrelevant context
- Produce different output each time for the same request, making collaboration difficult
- Leave no artifact trail — when something goes wrong, there is nothing to audit

The root cause is not model capability. It is the absence of structure. A powerful agent with no process is like a skilled contractor with no brief — the output depends entirely on what they assumed you wanted.

ARCUS is the process.

---

## What ARCUS Does

ARCUS (**A**ny **R**epository **C**an **U**se **S**DD) implements **Spec Driven Development** — a methodology that gates implementation behind a structured sequence of artifacts:

```
Feature description
    → spec.md          (WHAT and WHY — requirements, user stories, acceptance criteria)
    → plan.md          (HOW — architecture, design decisions, component responsibilities)
    → tasks.md         (WHO does WHAT, in WHAT ORDER — dependency-ordered task breakdown)
    → implementation   (code, guided by tasks, constrained by spec and plan)
```

Each artifact is produced by a dedicated agent, validated by quality gates, and used as input to the next stage. No stage begins without the previous one being complete.

The result is a traceable chain from business requirement to working code — with every decision recorded.

---

## Key Design Decisions

### 1. Context hierarchy over full repo scans

The most expensive thing an LLM can do is read an entire codebase to answer a question that a small, focused document could answer in one read.

ARCUS builds a two-level context hierarchy:

- **Shared context** (`.context/`) — repo-level intelligence built once: business scope, technical topology, business flows, testing patterns. Updated incrementally via git diff, not full rescans.
- **Story context** (`context-pack.md`) — a minimal, story-scoped extract from shared context. Each agent loads only what is relevant to the current feature.

An agent specifying a payment flow does not need to read the email service code. It reads the payment flow file and the relevant sections of the repo map. This keeps token usage proportional to task scope, not codebase size.

### 2. Skills over monolithic agents

Each agent in ARCUS delegates to a set of reusable skills — small, single-purpose capabilities with explicit input/output contracts. `sdd.specify` does not contain the logic for detecting ambiguities; it calls `specialized/spec/ambiguity-detection`. `sdd.tasks` does not contain dependency graph logic; it calls `reasoning/dependency-analysis`.

This has two benefits: skills can be improved without touching agents, and the same skill can be used by multiple agents without duplication. `core/quality-gates` validates spec, plan, and tasks artifacts using the same mechanism with different gate profiles.

### 3. Distribution by integration, not by forking

ARCUS ships to target repositories via a single CLI command (`arcus-integrate`). Agents and skills are copied as read-only files; templates, guidelines, and scripts are symlinked to the central repo.

This means:
- Updates to agents and skills propagate to all repos with `arcus-integrate --sync`
- Each repo keeps its own `.arcus-ignore` and generated `.context/` — customisable per project
- The central repo evolves independently of any target repo

No forking. No copy-paste maintenance. No version drift between repos.

### 4. Verification commits for drift detection

Every `.context/` artifact stores the git commit hash at which it was last updated. When `context/context-sync` runs at the start of a new story, it computes `git diff <verification-commit>..HEAD` to identify exactly which files changed — and updates only the context artifacts that were actually affected.

This makes context refresh proportional to what changed, not to the size of the repo. A story that touches three files refreshes at most three flow files and possibly `repo_map.md`. It does not rebuild everything.

### 5. Quality gates as first-class citizens

Every pipeline stage ends with a quality gate before its artifact is written. Gates are defined as named profiles (`spec-gates`, `plan-gates`, `tasks-gates`) with concrete, checkable rules — not vague checklists.

A spec that passes `spec-gates` guarantees: all user stories have acceptance criteria in Given/When/Then format, all requirements use normative language (MUST/SHOULD/MAY), no implementation details have leaked into requirements, and success criteria are measurable. An LLM cannot accidentally produce a spec that violates these — the gate catches it before the artifact is persisted.

### 6. Artifact versioning

Every generated artifact embeds an `arcus-artifact-meta` block recording which template it was generated from, which ARCUS version generated it, and when. This makes it possible to detect when an artifact was generated from an older template version — and flag it for regeneration rather than silently running outdated gates against it.

---

## Observed Benefits

These are not theoretical — they reflect the problems ARCUS was built to solve:

**Reduced hallucination in implementation** — agents implement from `tasks.md`, which was derived from `plan.md`, which was derived from `spec.md`. The chain is traceable. An agent cannot implement something that was never specified, because the task would not exist.

**Token efficiency** — context-pack loading means agents read hundreds of tokens of focused context rather than thousands of tokens of irrelevant code. For repos with large codebases, this difference is significant at scale.

**Auditability** — every design decision in `plan.md` has an alternatives-considered entry. Every override of a quality gate is logged in `tasks.md`. Every story is archived with a completion summary. The full history of a feature from requirement to deployment is recoverable.

**Team consistency** — when multiple developers work on the same repo, they all work from the same `.context/` artifacts and the same guideline files. A new team member specifying their first feature gets the same quality gates and the same context as a senior developer.

**Safe evolution** — because every agent delegates to skills, and skills have explicit contracts, the framework can be improved incrementally. Expanding the `spec-authoring` skill to add new generation rules does not require touching `sdd.specify`, `sdd.clarify`, or any other agent.

---

## What ARCUS Is Not

**ARCUS is not a replacement for engineering judgment.** Quality gates catch structural problems; they do not catch wrong requirements or bad architectural decisions. An LLM following ARCUS still needs a human to review the spec and plan before implementation begins.

**ARCUS is not prescriptive about technology.** The guideline files under `guidelines/` are generic best practice suggestions. The `.context/` artifacts capture what the repo actually uses. Agents respect existing conventions — they do not impose new ones.

**ARCUS is not a heavyweight process.** For a small, well-understood feature, the pipeline moves quickly: specify in minutes, clarify if needed, plan the design, generate tasks, implement. The artifacts are a by-product of thinking clearly, not bureaucracy for its own sake.

---

## The Self-Hosting Principle (Beta)

ARCUS is being developed using ARCUS. New features to the framework are developed using the same harness and context awareness that gets generated in any other target repository. This is the strongest test of the framework's validity: if it cannot describe its own development, it is not production-grade.

The central repo has integrated ARCUS on itself. The `.context/` folder you see in this repo is its understanding of itself.

## CLI Commands

| Command                    | Description                 |
|----------------------------|-----------------------------|
| `arcus-integrate`          | Integrate current directory |
| `arcus-integrate --sync`   | Re-sync all symlinks        |
| `arcus-integrate --remove` | Remove all copied files     |
| `arcus-integrate --yes`    | Non-interactive (CI/CD)     |

## Project Structure

**Agents** → Business logic for SDD workflow  
**Skills** → Reusable, focused capabilities used by agents. Each Skill implements a small unit of functionality (e.g., path and template resolution, repository analysis, markdown generation/validation, session bootstrap, quality gates, and formatting). Skills are the building blocks agents call to perform specific tasks across repositories.
**Templates** → Document templates for specs, plans, tasks  
**Prompts** → Provides purpose and bounds to associated agents   
**Guidelines** → Engineering and architecture guidelines  

## Further Reading

- [Integration Guide](ARCUS_INTEGRATION_GUIDE.md) — Full setup and usage
- [Agent Registry](registry/AGENT_REGISTRY.md) — All agents and workflow
- [Skill Registry](registry/SKILLS_REGISTRY.md) — All skills and domains 
