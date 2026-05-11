# Skills and Agents: Architecture and Extension Guide

## Conceptual Model

ARCUS separates concerns into two roles:

| Role | Responsibility | Scope |
|------|-----------------|-------|
| **Agent** | Coordinate workflow for a pipeline stage | Orchestration |
| **Skill** | Execute a single, focused capability | Implementation |

An agent is like a **project manager**: it reads requirements, delegates tasks to specialists (skills), collects their outputs, and produces a final deliverable.

A skill is like a **specialist contractor**: it does one thing well, has explicit input/output contracts, and says "I'm done" when the contract is fulfilled.

## Agent Architecture

### What an Agent Does

An agent coordinates a single stage of the SDD pipeline.

**Example: sdd.specify**

```
Input: Feature description + .context/
│
├─ Skill: session-bootstrap
│  └─ Output: Session context (story ID, workspace, timestamp)
│
├─ Skill: feature-context-pack-builder
│  └─ Output: context-pack.md (story-scoped extract)
│
├─ Skill: spec-authoring
│  └─ Output: Candidate spec.md (requirements, user stories, acceptance criteria)
│
├─ Skill: ambiguity-detection
│  └─ Output: List of ambiguous statements (if any)
│
├─ Skill: quality-gates (spec-gates profile)
│  └─ Output: Validation report (pass/fail + recommendations)
│
└─ Skill: report-renderer
   └─ Output: Human-readable summary
```

The agent coordinates all of this, but implements nothing itself.

### Agent Execution Model

```
1. LOAD CONTEXT
   - Load: relevant sections of .context/
   - Validate: context is current (not stale)
   - Assemble: story-specific context-pack

2. DELEGATE TO SKILLS
   - For each skill in the orchestration chain:
     - Pass: required inputs (context, previous outputs)
     - Wait: for skill to complete
     - Collect: skill output
     - Handle: any errors from skill

3. VALIDATE CHAIN OUTPUT
   - Run: quality-gates skill with appropriate profile
   - If FAIL: recursively adjust and retry (or report for human review)
   - If PASS: proceed to next step

4. PERSIST ARTIFACT
   - Generate: arcus-artifact-meta (template version, timestamp, etc.)
   - Write: final artifact to persistent storage
   - Log: completion with metadata
```

### Agent Input/Output Contracts

Every agent has explicit input and output contracts.

**Example: sdd.specify**

```
INPUT:
  - feature-description: String (natural language requirement)
  - context-repo: Path to .context/ directory
  - story-id: String (e.g., "PAYMENT-AUTH-001")
  - optional--clarifications-from-human: Map (if agent is refining a spec)

OUTPUT:
  - spec.md: Markdown file with fixed structure:
    - Summary
    - User stories (with acceptance criteria in Given/When/Then)
    - Requirements (normative language: MUST/SHOULD/MAY)
    - Out of scope
    - Success criteria (measurable)
  - requirements.md: Extracted structured list for cross-referencing
  - context-pack.md: Story-scoped context summary
  - metadata: arcus-artifact-meta block

ERROR HANDLING:
  - If quality-gates FAIL: Report issues and suggested fixes
  - If context is stale: Refresh context and retry
  - If input is ambiguous: Request clarification from human
```

## Skill Architecture

### What a Skill Does

A skill is a reusable capability with an explicit contract.

**Example: quality-gates skill**

```
PURPOSE:
  Validate that an artifact meets structural requirements

INPUT:
  - artifact: Markdown file to validate
  - profile: Name of gate profile (e.g., "spec-gates", "plan-gates", "tasks-gates")
  - strict-mode: Boolean (if true, warnings become failures)

OUTPUT:
  - passes: Boolean
  - violations: Array of {severity, rule, details, line-numbers}
  - recommendations: Array of strings

CONTRACT:
  "If I pass the spec-gates profile, I guarantee:
   - All user stories have acceptance criteria in Given/When/Then format
   - All requirements use normative language (MUST/SHOULD/MAY)
   - No implementation details in requirements
   - Success criteria are measurable
```

### Skill Execution Model

Skills are **stateless and deterministic**: same input → same output, every time.

```
Skill Input Contract
  │
  ├─ Validate: Input conforms to contract
  │  └─ If invalid: Raise InputContractViolation
  │
├─ Execute: Core logic (no side effects)
  │
├─ Validate: Output conforms to contract
  │  └─ If invalid: Raise OutputContractViolation
  │
└─ Return: Output

Skills never modify external state (no writes to .context/, no git commits, etc.)
```

### Skill Categories

ARCUS skills are organized by domain:

| Category | Purpose | Examples |
|----------|---------|----------|
| **Core** | Foundational capabilities | session-bootstrap, quality-gates, report-renderer |
| **Artifact** | Markdown generation and validation | artifact-modeling, markdown-generation, markdown-validation |
| **Reasoning** | Analysis and decomposition | design-synthesis, dependency-analysis, coverage-analysis |
| **Discovery** | Repository analysis | flow-and-scope-discovery |
| **Context** | Context building and refresh | feature-context-pack-builder, context-refresh |
| **Interaction** | Human collaboration | question-orchestration |
| **Formatting** | Output formatting | format-enforcer |
| **Specialized** | Domain-specific logic | spec-authoring, ambiguity-detection, task-execution-controller |
| **Foundation** | Low-level utilities | repository-context-builder, test-pattern-discovery |
| **Maintenance** | Drift detection and reconciliation | context-drift-and-reconcile |

---

## Agent Lifecycle

### 1. Bootstrap Phase (One-Time per Repository)

```
arcus-integrate
  │
  └─ sdd.context-builder
     ├─ Skill: repository-context-builder
     │  └─ Generates: repo_scope.md, repo_map.md
     │
     ├─ Skill: flow-and-scope-discovery
     │  └─ Generates: flows/*.md
     │
     └─ Skill: test-pattern-discovery
        └─ Generates: testing-patterns.md
```

**Result:** `.context/` is built. Repository is initialized for development.

### 2. Development Phase (Repeat per Story)

```
loop:
  Feature description
    │
    ├─ sdd.specify → spec.md
    │
    ├─ sdd.clarify → refined spec.md (optional)
    │
    ├─ sdd.plan → plan.md
    │
    ├─ sdd.tasks → tasks.md
    │
    ├─ sdd.analyze (pre-impl) → readiness report
    │
    ├─ sdd.implement → source code + tests
    │
    ├─ sdd.analyze (post-impl) → verification report + context refresh
    │
    └─ sdd.close → archive + completion summary
```

Each agent executes once per story, producing its respective artifact.

### 3. Governance Phase (Continuous)

```
sdd.instructions
  └─ Reads: repo_scope.md + repo_map.md
     Generates: .github/copilot-instructions.md
     (enforced by all agents during execution)
```

---

## Extending ARCUS

### Adding a New Skill

**Step 1:** Define the skill in `skills/{category}/{skill-name}/SKILL.md`

```markdown
# Skill: Custom Analysis

## Purpose
Analyze code for a specific pattern (e.g., security issues, performance problems)

## Input Contract
- code-files: Array<Path>
- analysis-type: Enum["security", "performance", "style"]
- severity-threshold: Enum["critical", "high", "medium", "low"]

## Output Contract
- findings: Array<{file, line, severity, description, suggestion}>
- summary: String

## Dependencies
- Git access (read-only)
- Language-specific analyzer tools

## Error Handling
- If file not found: Report and continue
- If analyzer crashes: Catch and report with context
```

**Step 2:** Register in `skills/SKILLS_REGISTRY.md`

```markdown
| Custom Analysis | specialized | code-files, analysis-type | findings, summary | Detects pattern violations in code |
```

**Step 3:** Update agent(s) to call the skill

```markdown
# In sdd.implement or your agent:
- Skill: custom-analysis
  └─ Input: generated source files, analysis-type="security"
     Output: security-findings
```

**Step 4:** Update `.context/` if this is a significant framework change

```bash
arcus-integrate --sync
```

### Adding a New Agent

**Step 1:** Define agent structure in `agents/{core|extensions}/{agent-name}.agent.md`

Follow: `templates/agent-file-template.md`

**Step 2:** Register in `registry/AGENT_REGISTRY.md`

```markdown
| sdd.custom | core | Describe purpose, delegation model, inputs, outputs |
```

**Step 3:** Create corresponding prompt in `prompts/{core|extensions}/{agent-name}.prompt.md`

**Step 4:** Update workflow documentation (SDD-Flow-Diagram.md)

**Step 5:** Update `.context/` and test

```bash
arcus-integrate --sync
```

### Customizing a Skill

Skills have extension points. Common patterns:

**Pattern 1: Extend with new rules**
```markdown
# quality-gates skill

spec-gates profile:
  - Rule: All user stories have acceptance criteria
  - Rule: Requirements use normative language
  - Rule (custom): Requirements must reference existing architecture components
```

Add your custom rule to the skill's rule evaluation function.

**Pattern 2: Extend with new analysis types**
```markdown
# coverage-analysis skill

Supported analysis types:
  - test-coverage: Line/branch coverage metrics
  - requirement-coverage: Which requirements have tests
  - architecture-coverage (custom): Which architectural components are tested
```

Add your analysis type to the skill's implementation.

---

## Skill Composition Example

**Scenario:** Build a new agent for "security review"

```
sdd.security-review
├─ Skill: session-bootstrap (initialize context)
│
├─ Skill: custom-analysis (security scan for vulnerabilities)
│  └─ Input: source code files
│     Output: security-findings
│
├─ Skill: dependency-analysis (check for vulnerable dependencies)
│  └─ Input: package.json, requirements.txt, etc.
│     Output: dependency-vulnerabilities
│
├─ Skill: artifact-modeling (structure findings into a report)
│  └─ Input: security-findings + dependency-vulnerabilities
│     Output: security-review-report.md
│
├─ Skill: quality-gates (security-review-gates profile)
│  └─ Input: security-review-report.md
│     Output: validation report
│
└─ Skill: report-renderer (human-readable summary)
   └─ Output: Console output
```

This agent is built entirely by composing existing skills + adding one custom skill (`custom-analysis`).

---

## Important Design Principles

### 1. Skills Never Call Other Skills Directly
Skills are called only by agents. This prevents circular dependencies and makes the delegation chain traceable.

### 2. Skills Are Stateless
A skill never modifies external state (except producing its output). No git commits, no .context/ updates, no database writes.

### 3. Skills Have Explicit Contracts
Every input and output is defined. This enables testing, composition, and error handling.

### 4. Agents Are Orchestrators, Not Implementers
Agents coordinate skills but never contain business logic themselves. This keeps agents thin and composable.

### 5. Context Flows Through Skills
Agents pass context (repo info, story scope) to each skill. Skills use context to make informed decisions without re-analyzing the repository.

---

## Testing Skills

Each skill should have a test suite:

```bash
skills/{category}/{skill-name}/
├─ SKILL.md (specification and documentation)
├─ implementation/
│  └─ skill.js (or your language)
└─ tests/
   ├─ unit/
   │  ├─ input-contract.test.js
   │  ├─ output-contract.test.js
   │  └─ error-cases.test.js
   └─ integration/
      ├─ with-real-codebase.test.js
      └─ with-other-skills.test.js
```

Test categories:

1. **Input Contract**: Verify skill rejects invalid inputs
2. **Output Contract**: Verify skill produces valid outputs
3. **Core Logic**: Verify skill produces correct results
4. **Error Handling**: Verify skill handles edge cases gracefully
5. **Determinism**: Verify same input produces same output
6. **Composition**: Verify skill works with other skills

---

## See Also

- [Architecture](architecture.md) — Overall design principles
- [Quality Gates](quality-gates.md) — How gates validate artifacts
- [Agent Registry](../registry/AGENT_REGISTRY.md) — All agents and their specifications
- [Skill Registry](../skills/SKILLS_REGISTRY.md) — All skills and their contracts

