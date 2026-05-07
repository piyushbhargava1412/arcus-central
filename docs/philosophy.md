# ARCUS Philosophy: Why Process Beats Prompting

## The Problem with Vibe Coding

"Vibe coding" — writing prompts and hoping an LLM produces the right code — fails predictably:

1. **Consistency breaks down** — Ask the same agent the same question three times, get three different answers. For teams, this is a nightmare.

2. **Context drift accelerates** — An agent reads an entire codebase to answer one question, misses half of it due to token limits, and implements its best guess. Hours later, developers are debugging assumptions the agent made.

3. **Hallucination creates confidence** — Agents produce plausible-sounding specs that miss critical requirements. By the time hallucination is discovered (in code review, or worse, production), rework is expensive.

4. **No audit trail** — When something goes wrong, there's nothing to inspect. No spec. No design document. No decision record. You rebuild from memory.

5. **Collaboration becomes impossible** — Multiple developers working on the same codebase cannot easily coordinate. They each prompt their own agent, get different outputs, and spend more time reconciling conflicts than building features.

### Root Cause

The problem is not LLM capability. A 70B LLM is genuinely intelligent. The problem is **the absence of structure**. 

A skilled contractor without a written brief will produce confident, plausible work based on what they *assumed* you wanted. No amount of capability fixes that. What fixes it is a **process**.

## The Process

Spec Driven Development (SDD) gates implementation behind a structured sequence of artifacts:

```
Feature description
  → spec.md       (WHAT and WHY are we building this?)
  → plan.md       (HOW will we architect it?)
  → tasks.md      (WHO does WHAT, in WHAT ORDER?)
  → implementation (code, guided by tasks, constrained by spec and plan)
```

Each stage produces an artifact. Each artifact is validated. No stage begins without the previous one being complete.

### Why This Works

1. **Specification is source of truth** — Before any code is written, the team agrees on *what* the feature does and *why* it matters. This is documented, reviewable, and unchanging until explicitly refined.

2. **Design decisions are explicit** — The plan captures architecture, component responsibilities, and alternatives considered. Developers implement from this recipe, not from inference.

3. **Ambiguities are resolved early** — Rather than discovering in code review that a requirement was misunderstood, clarification happens during specification phase. One careful question beats hours of rework.

4. **Hallucination is caught before code** — Quality gates on spec, plan, and tasks verify structural correctness before implementation begins. A spec that violates requirements is rejected before it influences code.

5. **Auditability is built in** — Every feature has: spec (what), plan (why this design), tasks (decomposition), implementation (code), and analysis report (verification). The full chain is recoverable.

6. **Teams coordinate from shared context** — Not from prompts they each wrote. Everyone reads the same spec, follows the same plan, implements from the same task breakdown. New team members onboard faster.

## Context Engineering: The Missing Piece

SDD is valuable, but incomplete without **context engineering**.

Most LLM-powered tools make the same mistake: they read the entire codebase on every invocation. This is expensive (tokens) and ineffective (noise drowns signal).

ARCUS builds a **two-level context hierarchy**:

1. **Shared context** (`.context/`) — Repository-level intelligence built once:
   - `repo_scope.md` — Business capabilities, components, integration model
   - `repo_map.md` — Technical topology, tech stack, architectural layers
   - `flows/*.md` — Key execution flows (payment processing, auth, etc.)
   - `testing-patterns.md` — How tests are structured in this repo

   These are updated incrementally, proportional to what changed. A story that touches three files refreshes three flow files and possibly the repo map. Not the entire codebase.

2. **Story context** (`context-pack.md`) — Story-scoped extract:
   - Only the flows, components, and files relevant to this feature
   - Hundreds of tokens instead of thousands
   - Reused by all agents working on this story

**Result**: Agents read focused, accurate context proportional to task scope. Hallucination about architecture drops because the agent has seen the actual codebase, not an abstraction of it.

## Deterministic Workflows

When a workflow is deterministic — inputs produce the same outputs every time — teams can coordinate reliably.

ARCUS gates each stage with **quality gates**: concrete, checkable rules that verify artifact structure before persistence.

Example: A spec that passes `spec-gates` guarantees:
- All user stories have acceptance criteria in Given/When/Then format
- All requirements use normative language (MUST/SHOULD/MAY)
- No implementation details have leaked into requirements
- Success criteria are measurable

An LLM following ARCUS cannot accidentally produce a malformed spec. The gate catches it.

This means a junior developer working on their first ARCUS-managed feature gets the same guarantees as a senior developer. Process replaces experience.

## Human-in-Loop Philosophy

ARCUS does not replace engineering judgment. It focuses it.

- **QA Agents cannot make** — Strategic architecture decisions, business trade-offs, standards compliance
- **QA Agents are excellent at** — Generating candidates, checking structural rules, managing complexity

ARCUS reserves the high-judgment decisions for humans:
- Does this spec actually describe the right thing? (Humans review and approve spec)
- Is this architecture the right choice? (Humans review and approve plan)
- Are the tests sufficient? (Humans review test strategy)

Agents handle the rest: writing spec structure, generating design alternatives, decomposing work, implementing from tasks, verifying completeness.

## Why This Matters

For organizations building software with LLM agents:

- **You reduce cost** — Token efficiency from context engineering, fewer failed implementations from upfront specification
- **You reduce risk** — Auditable decision trails, quality gates catching structural problems, deterministic workflows
- **You improve velocity** — Clear specs mean implementation is faster, not slower. You spend time building, not reconciling assumptions
- **You enable scale** — Multiple agents, multiple developers, same codebase = coordination through shared context and process, not through hallucination recovery

ARCUS is the infrastructure for building reliably with agents.

---

## See Also

- [Architecture](architecture.md) — How ARCUS is designed to enable this
- [Context System](context-system.md) — How .context/ works
- [Quality Gates](quality-gates.md) — How ARCUS ensures determinism

