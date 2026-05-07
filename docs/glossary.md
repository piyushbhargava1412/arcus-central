# Glossary: ARCUS Terminology

## A

**Acceptance Criteria**
Specific, testable conditions that define when a user story is complete. In ARCUS, acceptance criteria must be written in Given/When/Then format and must be verifiable within the scope of the story. Example:
- Given a user has a valid payment method
- When they complete checkout
- Then payment processes within 500ms

**Agent**
An intelligent orchestrator that coordinates the SDD workflow for a single pipeline stage. ARCUS has 10 agents (6 core + 4 extensions). Agents delegate to skills to implement capabilities. Example: `sdd.specify` coordinates the specification generation stage.

**Ambiguity Detection**
A skill that identifies unclear language in a spec. Examples: vague requirements ("should be fast"), missing context ("after login"), contradictions ("required in both scenarios X and Y"). ARCUS flags ambiguities so they can be resolved during the clarify phase.

**Arcus-Artifact-Meta**
Metadata block embedded in every generated artifact. Records: which template was used, which agent generated it, when, using which version of ARCUS, from which context commit. Enables verifiability, regeneration, and audit trails.

**Architecture**
The structural design of a system: components, their responsibilities, and how they interact. In ARCUS, this is captured in `plan.md` and includes decisions about scaling, reliability, and technology choices.

---

## C

**Clarify (Agent)**
The second stage of SDD pipeline. Resolves high-impact ambiguities in a spec by asking targeted questions. Maximum 5 questions. Answers are incorporated back into `spec.md`. Human-driven, not automatic.

**Context Drift**
The phenomenon where repository `.context/` becomes stale because the codebase has evolved. ARCUS detects drift via verification commits and reconciles it incrementally.

**Context Pack**
A story-scoped extract from shared context (`.context/`). Contains only the flows, components, and guidelines relevant to the current feature. Typically 300-800 tokens. Reused by all agents working on the story. Solves token budget problems by eliminating irrelevant codebase scanning.

**Context Refresh**
The process of updating `.context/` artifacts to align with code changes. ARCUS performs selective refresh: only affected artifacts are regenerated, determined by `git diff` against verification commit.

**Context System**
ARCUS's two-level context hierarchy: shared context (`.context/`) and story context (context-pack). Enables efficient, accurate agent decisions without full codebase scans.

---

## D

**Dependency Analysis**
A skill that identifies explicit and implicit dependencies between tasks. Used to order tasks in `tasks.md` so that parallel work is possible but all prerequisites are resolved first.

**Design Synthesis**
A skill that generates architecture alternatives for a feature and evaluates them against requirements. Produces multiple candidate plans for human review.

**Deterministic Workflow**
A workflow where the same inputs always produce the same outputs. ARCUS achieves this through quality gates: there is no ambiguity about what passes or fails.

**Drift Detection**
The automatic mechanism that identifies when repository code has changed in ways that affect `.context/`. Based on verification commits and git diff.

---

## E

**Execution Controller**
A skill that manages the implementation phase, respecting task dependencies and tracking progress. Ensures tasks are executed in the right order and reports blockers.

---

## G

**Given/When/Then Format**
A standard format for writing acceptance criteria in a way that is testable and unambiguous:
- **Given**: Preconditions, setup state
- **When**: Action taken
- **Then**: Expected outcome

Example: "Given user has valid payment method, When they complete checkout, Then order is created and payment processes within 500ms"

**Gate (Quality Gate)**
A set of concrete, checkable rules that verify an artifact's structure before it is persisted. Gates enforce determinism. Example: `spec-gates` ensures all requirements use normative language and have measurable success criteria.

**Gate Profile**
A named collection of rules for a specific gate. Examples: `spec-gates`, `plan-gates`, `tasks-gates`. Each profile defines what constitutes a valid artifact.

**Glossary**
This document. Defines ARCUS terminology for readers unfamiliar with the framework.

**Groom (Agent)**
An extension agent that converts high-level requirements into structured, implementation-ready user stories. Fills the gap between requirements and spec.

---

## H

**Hallucination**
When an LLM produces plausible-sounding output that is incorrect or inferred rather than specified. ARCUS reduces hallucination by using specs and plans as constraints during implementation.

**Human-in-Loop**
A design principle where humans make high-judgment decisions (strategy, trade-offs, correctness) while agents handle generation and validation. Humans review and approve specs and plans before implementation proceeds.

---

## I

**Integration Guide**
Documentation on how to integrate ARCUS into a new repository using `arcus-integrate`. Located in `ARCUS_INTEGRATION_GUIDE.md`.

**Incremental Refresh**
Context refresh that is proportional to what changed, not to codebase size. Achieved by comparing current code against verification commits and updating only affected `.context/` artifacts.

---

## L

**Lineage (Artifact Lineage)**
The chain of artifacts connecting a requirement to code: spec.md → plan.md → tasks.md → implementation. Every artifact is linked to the next, enabling full auditability.

---

## M

**Markdown Validation**
A skill that checks if a Markdown file is syntactically valid and follows ARCUS conventions (headers, formatting, structure).

---

## N

**Normative Language**
Language that expresses obligations or requirements using: MUST (absolute requirement), SHOULD (strong recommendation), MAY (optional). Used in specs to eliminate ambiguity. Example: "User MUST authenticate before accessing dashboard" is unambiguous; "User should authenticate" is not.

---

## O

**Out of Scope**
An explicit section in `spec.md` that lists non-goals. Clarifies what the feature does NOT do, reducing assumption-based hallucination.

**Orchestrate / Orchestration**
The act of coordinating multiple skills to accomplish a goal. Agents orchestrate skills. Example: `sdd.specify` orchestrates session-bootstrap, spec-authoring, ambiguity-detection, quality-gates, and report-rendering skills.

---

## P

**Phase (Implementation Phase)**
A grouping of related tasks in `plan.md` and `tasks.md`. Phases define logical sequencing and deliverables. Example: Phase 1 (API design), Phase 2 (authentication), Phase 3 (payment processing), Phase 4 (testing & deployment).

**Philosophy**
ARCUS's worldview on how to build reliably with LLMs. Core idea: process beats prompting; structure beats capability. Documented in [philosophy.md](philosophy.md).

**Plan (plan.md)**
An artifact that captures how a feature will be implemented: architecture, design decisions, phases, components, dependencies, and alternatives considered. Generated by `sdd.plan` agent.

**Quality Gate**
See Gate.

---

## R

**Repo Map**
One of the shared context artifacts. Documents technical topology: tech stack, architectural layers, key directories and their purposes, component interactions, infrastructure. Updated incrementally when code structure changes.

**Repo Scope**
One of the shared context artifacts. Documents business capabilities, components, integration model, key flows, and domain-specific constraints. Updated rarely; typically only when organizational structure changes.

**Requirement**
A statement of what the system must do. In ARCUS, requirements are always written in normative language (MUST/SHOULD/MAY) and must be distinct from acceptance criteria or implementation details.

---

## S

**SDD (Spec Driven Development)**
A development methodology that gates implementation behind a structured pipeline: spec → plan → tasks → implementation. Each artifact is validated before the next stage begins. Pioneered by GitHub Spec-Kit; extended by ARCUS with context engineering.

**Self-Hosting Principle**
The principle that ARCUS should be developed using ARCUS itself. If ARCUS cannot describe its own development, it is not production-grade. The arcus-central repository demonstrates this.

**Selective Loading**
The practice of loading only relevant portions of context (repo_map, flows, guidelines) rather than the entire `.context/` directory. Reduces token usage and noise.

**Session Bootstrap**
A skill that initializes a session: creates story ID, establishes workspace, loads relevant context. Required by every agent.

**Skill**
A reusable, single-purpose capability with explicit input/output contracts. Skills are called by agents, not by other skills. Examples: quality-gates, artifact-modeling, dependency-analysis. ARCUS has 22 skills organized into 10 categories.

**Spec (spec.md)**
An artifact that defines WHAT a feature does and WHY it matters: user stories, requirements, acceptance criteria, success criteria, out of scope. Generated by `sdd.specify` agent. The most important artifact for preventing hallucination.

**Specify (Agent)**
The first stage of SDD pipeline. Generates a spec.md from a feature description. Uses context to ground decisions in repository-level constraints.

**Story Context**
See Context Pack.

**Success Criteria**
Measurable conditions that define when a feature is complete. Example: "Payments process within 500ms 99% of the time". Must be quantifiable, not subjective.

---

## T

**Task**
A granular unit of work in `tasks.md`. Each task has: ID, phase, priority, description, affected paths, acceptance criteria, and dependencies. Sized to be estimable and implementable.

**Template**
A Markdown template for generating artifacts (spec-template.md, plan-template.md, tasks-template.md). Ensures consistent structure across all artifacts.

**Testing Patterns**
One of the shared context artifacts. Documents how this repository structures tests: unit, integration, e2e; where test files live; what frameworks are used; what coverage expectations are. Updated when test infrastructure changes.

**Token**
A unit of text consumed by an LLM. ARCUS optimizes token usage by selective context loading instead of full codebase scans.

**Traceability**
The ability to trace a requirement through plan → tasks → implementation. ARCUS enables this through artifact lineage and cross-reference links.

---

## U

**User Story**
A description of a feature from the user's perspective: "As a [role], I want to [action], so that [benefit]". In ARCUS, every user story has acceptance criteria in Given/When/Then format.

---

## V

**Verification Commit**
The git commit hash at which a `.context/` artifact was last built. Used to detect drift and enable selective context refresh. Stored in each artifact's arcus-artifact-meta block.

**Vibe Coding**
Informal development where specifications are implicit or unwritten, and developers/agents infer requirements from conversations or examples. Leads to hallucination, inconsistency, and rework. ARCUS is designed to eliminate vibe coding.

---

## W

**Work Decomposition**
A skill that breaks down a large feature into granular, manageable tasks. Produces the task breakdown that becomes `tasks.md`.

---

## X-Z

*No entries*

---

## See Also

- [Architecture](architecture.md) — How ARCUS is designed
- [Philosophy](philosophy.md) — Why ARCUS matters
- [Context System](context-system.md) — How context engineering works

