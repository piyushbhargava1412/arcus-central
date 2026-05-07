# ARCUS Architecture: Design Principles and Rationale

## Five Core Design Decisions

### 1. Agents Orchestrate, Skills Execute

**Design:**
- **Agents** coordinate the SDD workflow (specify → clarify → plan → tasks → implement → analyze)
- **Skills** are reusable, single-purpose capabilities that agents delegate to

**Example:**
```
sdd.specify
  ├─ calls: session-bootstrap (initialize context)
  ├─ calls: spec-authoring (generate requirements)
  ├─ calls: ambiguity-detection (find unclear language)
  ├─ calls: quality-gates (verify spec structure)
  └─ calls: report-renderer (generate output)
```

**Why this matters:**
- Skills can be improved independently. Upgrading `spec-authoring` doesn't touch `sdd.specify`
- The same skill is reused by multiple agents. `quality-gates` validates specs, plans, and tasks using the same mechanism
- Agents remain focused on orchestration, not implementation details
- New capabilities can be added by creating new skills, not by modifying existing agents

**Scalability benefit:** With 10 agents and 23 skills, you have exponential composition power. A new agent can be built by combining existing skills rather than starting from scratch.

### 2. Context Hierarchy: Shared → Story → Task

**Design:**
- **Shared context** (`.context/`) — Repository-level intelligence, built once, maintained incrementally
- **Story context** (`context-pack.md`) — Story-scoped extract, reused by all agents working on this feature
- **Task context** — Embedded in each task.md entry, specifying exactly which files are affected

**Token cost progression:**
```
Full codebase scan:        5,000 - 20,000+ tokens
Shared context:            300 - 800 tokens (depends on repo size)
Story context-pack:        200 - 600 tokens (depends on feature scope)
Task context (embedded):   50 - 150 tokens per task
```

**Why this matters:**
- Token cost is controlled and proportional to task scope
- Agents have accurate, focused information instead of entire codebase
- Context remains synchronized with implementation via incremental refresh
- Hallucinations about architecture decrease because agents see actual code structure

**Design trade-off accepted:** Slightly more complex build pipeline (generating `.context/`) for dramatically better efficiency and accuracy.

### 3. Verification Commits for Drift Detection

**Design:**
Each `.context/` artifact records the git commit at which it was built:
```yaml
arcus-context-meta:
  verification-commit: abc123def456
  built-at-timestamp: 2026-05-07T14:23:00Z
```

When a new story begins, the system computes `git diff <verification-commit>..HEAD` to determine exactly which files changed, and refreshes only the affected context artifacts.

**Why this matters:**
- Context refresh is proportional to what actually changed, not to codebase size
- The system detects drift automatically (current commit far ahead of verification commit = stale context)
- Over time, `.context/` stays synchronized without manual intervention
- You avoid the "cargo cult" problem where agents implement patterns from outdated context

**Example efficiency gain:**
- Full context rebuild: 60 seconds
- Incremental refresh of 3 affected flows: 5 seconds
- For a team running 10+ stories/week: 550 seconds saved (9+ minutes per day)

### 4. Quality Gates as First-Class Artifacts

**Design:**
Every pipeline stage ends with a named quality gate before the artifact is persisted:

```
spec.md → [quality-gates profile: "spec-gates"] → validation report → persisted or rejected
```

Gates are defined as **profiles**, not checklists. A profile is a set of concrete, checkable rules:

**spec-gates profile:**
- ✓ All user stories have acceptance criteria in Given/When/Then format
- ✓ All requirements use normative language (MUST/SHOULD/MAY)
- ✓ No implementation details have leaked into requirements
- ✓ Success criteria are measurable
- ✓ No architectural decisions in acceptance criteria

**Why this matters:**
- Structural problems are caught before they influence implementation
- Agents cannot bypass gates; the artifact is rejected until it passes
- Teams have deterministic assurance that all specs meet the same standard
- A junior developer's spec passes the same gates as a senior's; process replaces experience

**Important constraint:** Gates verify *structure*, not *correctness*. A gate will catch a malformed spec but not a *wrong* spec. Human review is still required for strategic decisions (this is intentional; see human-in-loop philosophy).

### 5. Distribution by Integration, Not by Forking

**Design:**
ARCUS ships to target repositories in one command:
```bash
arcus-integrate
```

- **Agents and skills** are copied as read-only files (so each repo has its own copy)
- **Templates, guidelines, scripts** are symlinked to the central repo (so updates propagate instantly)
- **Outputs** (`.context/`, `.arcus/`) are generated per-repo and never synced back to central

**Why this matters:**
- Updates to framework components propagate to all integrated repos without manual intervention
- Each repo maintains its own `.context/` (customizable per project)
- No "version drift" (all repos run the same agent version)
- Central repo evolves independently; doesn't break downstream repos

**Implementation note:**
Copy-only for agents/skills is necessary because IntelliJ's agent discovery mechanism cannot follow symlinks reliably. Symlink-for-templates works because they're just text includes.

### 6. Artifact Versioning and Lineage

**Design:**
Every generated artifact embeds metadata:
```yaml
arcus-artifact-meta:
  artifact-id: PAYMENT-AUTH-001
  template-version: 1.2.0
  generated-by: sdd.specify
  generated-at-timestamp: 2026-05-07T10:15:00Z
  context-pack-commit: abc123def456
  arcus-version: 0.8.0
```

This enables:
- **Traceability**: Which code was generated from which artifacts, when, by which agents
- **Regeneration**: If template.version changes and artifact.template-version is older, the artifact should be regenerated
- **Audit**: Full history of what decisions were made and when

**Why this matters:**
- When ARCUS releases a breaking change, you can identify which artifacts were generated from old templates
- You have a complete audit trail connecting code to spec to plan to requirements
- Integration compliance: reviewers can trace a code change back to the requirement that justified it

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                     ARCUS Agents (10)                       │
│  ┌────────┬────────┬────────┐  ┌──────┬──────┬──────┐      │
│  │specify │ clarify│  plan  │  │ tasks│close │groom │  ... │
│  └────────┴────────┴────────┘  └──────┴──────┴──────┘      │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       │ delegates to
                       ▼
┌─────────────────────────────────────────────────────────────┐
│             Skills (23 reusable capabilities)               │
│                                                             │
│  Core (3)          Artifact (4)      Reasoning (4)          │
│  ├─ session        ├─ artifact       ├─ design             │
│  ├─ quality-gates  ├─ patcher        ├─ decompose          │
│  └─ renderer       ├─ markdown-gen   ├─ dependency         │
│                    └─ validation     └─ coverage           │
│                                                             │
│  ... (10 more skill categories)                            │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       │ uses
                       ▼
┌─────────────────────────────────────────────────────────────┐
│         Context Hierarchy (Per Repository)                  │
│                                                             │
│  Shared Context (.context/)     Story Context              │
│  ├─ repo_scope.md               └─ context-pack.md         │
│  ├─ repo_map.md                    (story-scoped extract)   │
│  ├─ flows/*.md                                             │
│  └─ testing-patterns.md                                    │
│                                                             │
│  Updated incrementally via git diff (not full rebuilds)    │
└─────────────────────────────────────────────────────────────┘
```

---

## Quality Gates Flow

```
Feature Description
    │
    ▼ (sdd.specify)
Candidate Spec
    │
    ├─→ [quality-gates: spec-gates] ← Validates structure
    │
    ├─ FAIL → Regenerate (agent refines spec)
    │
    └─ PASS → spec.md (persisted) ✓
         │
         ▼ (sdd.clarify, optional)
    Refined Spec
         │
         └─→ spec.md (updated)
```

Each stage has its own gate profile:
- **spec-gates**: Verify requirements structure
- **plan-gates**: Verify architecture decisions and completeness
- **tasks-gates**: Verify task decomposition, dependencies, and coverage

---

## Skills Delegation Pattern

Every agent follows the same delegation pattern:

```
sdd.{agent}
├─ Load: Relevant context from .context/
├─ Execute:
│  ├─ Skill 1: Input validation / bootstrap
│  ├─ Skill 2: Analysis / generation
│  ├─ Skill 3: Refinement
│  ├─ Skill 4: Quality verification
│  └─ Skill N: Output rendering
└─ Persist: Artifact with metadata
```

This consistency makes it easy to:
- Predict agent behavior
- Test agents individually
- Upgrade skills without changing agent behavior
- Add new agents by following the same pattern

---

## Design Trade-Offs and Rationale

### Why Explicit Artifacts Over Implicit State?

**Trade-off:** Artifacts are more verbose than keeping state in memory.

**Rationale:**
- Auditability (reviewable decision records)
- Collaboration (multiple agents can read the same artifact)
- Resumability (if a story is interrupted, you can resume from the last artifact)
- Human oversight (humans can review and edit artifacts before next stage)

### Why Skills Over LLM Function Calling?

**Trade-off:** Skills are manually implemented rather than LLM-generated.

**Rationale:**
- Predictability (skills produce deterministic output)
- Reliability (no hallucination in skill output)
- Testability (skills can be unit tested)
- Reusability (same skill can be used by multiple agents)

### Why Incremental Context Refresh Over Full Rebuilds?

**Trade-off:** Requires git diff logic and incremental refresh definitions.

**Rationale:**
- Efficiency (proportional to changes, not codebase size)
- Accuracy (context stays synchronized with implementation)
- Scalability (works on codebases of any size)

---

## See Also

- [Context System](context-system.md) — How context hierarchy works
- [Skills and Agents](skills-and-agents.md) — How to extend or customize
- [Quality Gates](quality-gates.md) — How gates enforce determinism
- [Philosophy](philosophy.md) — Why these choices matter

