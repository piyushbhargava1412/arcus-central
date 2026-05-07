# Quality Gates: Determinism Through Structural Validation

## Philosophy

Most AI frameworks treat validation as a **suggestion** ("the output doesn't follow best practices, you might want to fix it").

ARCUS treats validation as **enforcement** ("the output does not meet structural requirements; it will not be persisted until it passes").

This is the difference between:
- "My agent might produce bad code" (hope-based)
- "My agent cannot produce bad code" (structure-based)

## Core Principle

> A gate is a **named profile of concrete, checkable rules** that verify an artifact's structure before it is persisted.

Gates answer: "Does this artifact have the right shape?" They do NOT answer: "Is this artifact correct?"

**Example distinctions:**

| Question | Gate Can Answer? | Why |
|----------|-----------------|-----|
| Does spec have all requirements in normative language? | ✓ YES | Syntactic check |
| Are the requirements the *right* requirements? | ✗ NO | Semantic, needs human judgment |
| Does tasks.md have all required fields? | ✓ YES | Structural check |
| Are the task estimates accurate? | ✗ NO | Predictive, needs experience |
| Is test coverage measured? | ✓ YES | Syntactic check |
| Is test coverage sufficient? | ✗ NO | Domain-specific judgment |

Gates catch structural problems. Humans catch logical problems.

## Gate Profiles

ARCUS uses **named profiles**, not generic checklists. Each profile is a set of concrete rules.

### spec-gates Profile

A spec that passes `spec-gates` guarantees:

**Structure:**
- ✓ Has explicit sections: Summary, User Stories, Requirements, Out of Scope, Success Criteria
- ✓ All user stories have acceptance criteria in Given/When/Then format
- ✓ Each acceptance criterion references exactly one user story

**Language:**
- ✓ All requirements use normative language: MUST / SHOULD / MAY
- ✓ No instances of ambiguous language: "probably", "maybe", "usually", "roughly"
- ✓ No implementation details in requirements (e.g., "use Redis" is implementation, not requirement)
- ✓ No architectural decisions in acceptance criteria (e.g., "implement with microservices")

**Testability:**
- ✓ All success criteria are measurable (use specific numbers, not "good", "fast", "simple")
- ✓ All acceptance criteria are verifiable within a story's scope

**Completeness:**
- ✓ Out of Scope section exists and lists non-goals
- ✓ At least one user story exists
- ✓ Each user story has at least one acceptance criterion

**Metadata:**
- ✓ `arcus-artifact-meta` block present with required fields

### plan-gates Profile

A plan that passes `plan-gates` guarantees:

**Architecture:**
- ✓ Architecture decision is stated (monolithic, microservices, hybrid, etc.)
- ✓ Key components are identified and their responsibilities described
- ✓ Component dependencies are documented
- ✓ External integrations are identified

**Design:**
- ✓ Design decisions are explained with rationale
- ✓ Alternatives considered are documented (at least 2 alternatives per major decision)
- ✓ Trade-offs are explicit (what we gain, what we sacrifice)

**Phases:**
- ✓ Implementation phases are defined
- ✓ Phases have defined deliverables
- ✓ Phase dependencies are explicit (which phase must complete before next)

**Risk:**
- ✓ Technical risks are identified
- ✓ Each risk has mitigation strategy
- ✓ Critical path items are identified

**Metadata:**
- ✓ Traceability: Plan identifies which requirements it addresses
- ✓ `arcus-artifact-meta` block present

### tasks-gates Profile

A tasks.md that passes `tasks-gates` guarantees:

**Structure:**
- ✓ Each task has required fields: ID, phase, priority, description, path, acceptance criteria
- ✓ Task ID format is consistent (e.g., T001, T002, ...)
- ✓ Phase names match plan.md phases

**Dependencies:**
- ✓ Dependencies are explicitly stated (e.g., "T001 depends on T005")
- ✓ Dependency graph is acyclic (no circular dependencies)
- ✓ All dependencies are satisfiable (dependent task exists)

**Coverage:**
- ✓ All plan phases are represented by tasks
- ✓ All requirements from spec.md are addressed by at least one task
- ✓ All user stories have acceptance criteria in tasks

**Granularity:**
- ✓ Each task is estimable (not "build payment system", but "build payment service API with Stripe integration")
- ✓ Each task has a clear definition of done (acceptance criteria)

**Priority:**
- ✓ Tasks have explicit priority (P0/critical, P1/high, P2/medium, P3/low)
- ✓ At least some P0/critical tasks exist

**Metadata:**
- ✓ `arcus-artifact-meta` block present
- ✓ Traceability: Each task references spec requirements it implements

---

## Gate Enforcement Strategy

### During Generation

When an agent generates an artifact:

```
1. Agent generates candidate artifact
2. quality-gates skill validates against profile
3. If FAIL:
   - Report violations with line numbers
   - Return violations to agent
   - Agent refines artifact
   - Loop back to step 2
4. If PASS:
   - Add arcus-artifact-meta block
   - Persist artifact
   - Log: "spec.md passed spec-gates"
```

**Retry Strategy:**
The agent attempts to refine the artifact up to 3 times before reporting an error to the human.

### Before Integration

When a story is considered "ready for implementation":

```
run: sdd.analyze (pre-implementation)
├─ Load: spec.md, plan.md, tasks.md
├─ Validate:
│  ├─ Requirement-to-Task Traceability
│  │  └─ Each requirement has at least one implementing task
│  ├─ Acceptance Criteria Coverage
│  │  └─ Each acceptance criterion is verifiable via tasks
│  └─ Technical Readiness
│     └─ tasks.md has no blockers, dependencies are resolvable
├─ Report: Readiness assessment (🟢 Ready, 🟡 Questions Raised, 🔴 Blockers)
└─ If 🔴: Do not proceed to implementation until resolved
```

This is a **cross-artifact** gate, not a single-artifact gate. It ensures the entire pipeline is coherent.

### Post-Implementation

After code is written, a final gate runs:

```
run: sdd.analyze (post-implementation)
├─ Verify: All spec requirements are implemented
├─ Verify: All acceptance criteria are met (test coverage)
├─ Verify: No implementation details leaked back into spec
├─ Verify: No architectural changes that violate plan.md
├─ Result:
   ├─ 🟢 Release ready (all criteria met)
   ├─ 🟡 Acceptable with caveats (document trade-offs)
   └─ 🔴 Issues must be resolved
└─ Refresh: .context/ if needed (drift detection)
```

---

## Blocking vs. Advisory Gates

Gates can be **blocking** or **advisory**:

| Type | Behavior | When to Use |
|------|----------|-------------|
| **Blocking** | Artifact is rejected until it passes | Critical structural rules (e.g., all requirements have acceptance criteria) |
| **Advisory** | Artifact is persisted; gate reports warnings | Best-practice suggestions (e.g., "consider documenting this assumption") |

**spec-gates** is **100% blocking**: All rules must pass.

**plan-gates** is **mostly blocking** with **a few advisory** rules:
- Blocking: Architecture decision is stated, components identified, phases defined
- Advisory: "Consider explicitly mentioning security model", "Risk mitigation is brief"

This distinction lets teams move quickly for straightforward features while enforcing rigor for complex ones.

---

## Gate Override Strategy

Sometimes, a team needs to override a gate. ARCUS allows this, but with enforcement:

```
Gate Violation: "Requirement 'Fast payment processing' is not measurable"

Options:
1. REFINE: Update requirement to "Payment processing completes within 500ms"
2. OVERRIDE: Keep requirement as-is, document reason for override

If OVERRIDE:
  - Reason is logged in spec.md (as a comment block)
  - Override is flagged in arcus-artifact-meta
  - Override is noted in analysis report
  - Override is visible to reviewers
```

**Important:** Overrides are visible. They don't disappear. This acts as a "warning light" for decision tracking.

Example override block:
```markdown
<!-- ARCUS GATE OVERRIDE
Rule violated: "Success criteria must be measurable"
Override reason: "Fast payment processing" is inherently subjective; 
objective metrics added in tasks.md as acceptance criteria for individual tasks.
Overridden by: piyush (2026-05-07)
-->
```

---

## Validation Levels

Gates can run at different validation levels:

| Level | Strictness | Use Case |
|-------|-----------|----------|
| **Lint** | Basic syntax checks | Catch obvious errors (missing fields, typos) |
| **Strict** | Full rule validation | Before merging to main branch |
| **Pedantic** | Strict + advisory suggestions | Pre-release validation |

By default, gates run at **Strict** level.

Example usage:
```
sdd.specify --gate-level=lint      # Fast feedback while drafting
sdd.specify --gate-level=strict    # Before review (default)
sdd.specify --gate-level=pedantic  # Before release
```

---

## Custom Gate Profiles

Teams can define custom gates for special scenarios:

**Example: Payment Service Team**

```yaml
# In .github/copilot-instructions.md
custom-gates:
  payment-spec-gates:
    - All requirements reference payment flows (payment, refund, reconciliation)
    - PCI compliance constraints are documented
    - All integrations with Stripe API are explicit
    - Tax handling is covered
    
  payment-plan-gates:
    - Plan includes idempotency strategy
    - Plan includes error reconciliation strategy
    - Database schema changes are documented
```

These custom gates run in parallel with standard gates. Both must pass.

---

## Audit and Reporting

Every gate execution is logged:

```
sdd.specify
  Gate Profile: spec-gates
  Timestamp: 2026-05-07T14:23:00Z
  Result: PASS ✓
  
  Violations checked: 18
  Violations found: 0
  Warnings: 0
  Duration: 1.2s
  
  Artifact: spec.md
  Artifact ID: PAYMENT-AUTH-001
  Artifact Commit: abc123def456
```

This log is attached to the artifact for auditability.

---

## Benefits

**For developers:**
- Immediate feedback on structural issues (before context switch to human review)
- Clear rules (not subjective guidelines)
- Fast iteration (3-second gate runs, not hours of review cycles)

**For teams:**
- Consistency (all specs meet same standard, regardless of who wrote them)
- Auditability (every override is logged and visible)
- Quality assurance (gates catch 80% of structural problems before review)

**For organizations:**
- Risk reduction (malformed specs don't reach implementation)
- Onboarding (new team members' work passes same gates as seniors')
- Process visibility (every gate pass/fail is logged for compliance)

---

## See Also

- [Architecture](architecture.md) — How gates fit into ARCUS design
- [Skills and Agents](skills-and-agents.md) — quality-gates skill implementation
- [Glossary](glossary.md) — Gate-related terminology

