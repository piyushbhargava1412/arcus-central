# Flow: Development Workflow (9-Stage Process)

## Overview

ARCUS development follows a **stage-driven workflow** with 9 distinct stages:
- **2 bootstrap stages** (one-time per target repository)
- **7 feature development stages** (per story/requirement)

Each stage has defined entry/exit criteria, applicable agents, and quality gates to ensure reliable agentic development while reducing hallucinations and optimizing token utilization.

---

## Entry Points

- **Bootstrap**: User runs `arcus-integrate` in target repo (framework integration)
- **Feature Development**: User/PO provides feature description → workflow starts at Specify stage

## Core Path

### Phase A: Bootstrap (One-Time Setup)

#### Stage 1: Context Building

**Purpose**: Establish repository boundaries and selective context loading  
**Entry Criteria**:
- Target repository integrated with `arcus-integrate`
- `.context/` directory initialized

**Agent**: `sdd.context-builder`

**Delegation Model**:
1. `session-bootstrap` → Load repository structure
2. `repository-context-builder` → Generate `.context/repo_scope.md` + `.context/repo_map.md`
3. `flow-and-scope-discovery` → Generate `.context/flows/*.md`
4. `test-pattern-discovery` → Generate `.context/testing-patterns.md`
5. `quality-gates` → Validate context artifacts
6. `report-renderer` → Format initialization report

**Processing**:
1. Agent loads repository root and applies `.arcus-ignore` patterns
2. Delegates to foundation skills to generate context artifacts
3. All artifacts are evidence-based with confidence levels assigned
4. Output: 5 context artifacts ready for downstream agents

**Exit Criteria**:
- ✅ All 5 context artifacts exist
- ✅ Context is evidence-based (no speculation)
- ✅ Confidence levels assigned (HIGH/MEDIUM/LOW)

**Output**: Ready for agent execution with selective context loading

---

#### Stage 2: Copilot Instructions Creation

**Purpose**: Establish repo-specific guardrails and guidelines  
**Entry Criteria**:
- Context files created (Stage 1 complete)

**Agent**: `sdd.instructions`

**Processing**:
1. Load repository instructions from `.arcus/instructions/`
2. Load repo-specific constraints (from `.context/repo_scope.md`)
3. Synthesize `.github/copilot-instructions.md` with:
   - Engineering guidelines
   - Architecture patterns
   - Testing standards
   - Security/compliance constraints (if applicable)
   - Team-specific conventions

**Exit Criteria**:
- ✅ `.github/copilot-instructions.md` exists
- ✅ All subsequent agents inherit these guardrails
- ✅ Reduces hallucinations by constraining LLM behavior

**Output**: Topic guidance available to all downstream agents

---

### Phase B: Feature Development (Per Story/Requirement)

#### Stage 3: Specify

**Purpose**: Create comprehensive, unambiguous specification from feature description  
**Entry Criteria**:
- Feature description from PO/user
- Context files available (from bootstrap)
- Copilot instructions available

**Agent**: `sdd.specify`

**Delegation Model**:
1. `session-bootstrap` → Load `.context/`, templates, `.github/copilot-instructions.md`
2. `feature-context-pack-builder` → Build story-local context
3. `spec-authoring` → Write specification from feature description
4. `ambiguity-detection` → Find gaps, unclear requirements
5. `quality-gates` → Validate spec readiness
6. `report-renderer` → Format and present specification

**Inputs**:
- Feature description (narrative or user story format)
- `.context/repo_scope.md`, `.context/repo_map.md` (selective context loading)
- Templates: `spec-template.md`

**Outputs**:
- `.arcus/specs/<STORY-ID>/spec.md` — Complete specification
- `.arcus/specs/<STORY-ID>/requirements.md` — List of testable requirements
- `.arcus/specs/<STORY-ID>/context-pack.md` — Story-specific context
- Quality gates report

**Exit Criteria**:
- ✅ No ambiguous language (no TBDs, TKs, ??)
- ✅ All requirements are testable
- ✅ No conflicting requirements
- ✅ Dependencies identified
- ✅ Success criteria defined
- ✅ Quality gates: PASS

**Quality Gates**:
- Ambiguity detection (finds unclear language)
- Requirement completeness (all requirements have acceptance criteria)
- Traceability (requirements trace to business flows)

---

#### Stage 4: Clarify

**Purpose**: Remove remaining ambiguities and confirm interpretation  
**Entry Criteria**:
- Specification complete (Stage 3: PASS)

**Agent**: `sdd.clarify`

**Processing**:
1. Load spec from Stage 3
2. Identify ambiguities (unclear requirements, edge cases, assumptions)
3. Generate clarification questions for stakeholder confirmation
4. Incorporate feedback into spec
5. Update context pack if new assumptions discovered

**Inputs**:
- Specification from Stage 3
- Ambiguity detection results

**Outputs**:
- Clarification questions (with suggested answers)
- Updated `spec.md` (if clarifications change requirements)
- Confirmation checklist

**Exit Criteria**:
- ✅ All ambiguities resolved
- ✅ Stakeholder confirmation obtained
- ✅ Specification is frozen (no more changes without re-specification)

**Quality Gates**:
- All questions answered
- Stakeholder sign-off confirmed

---

#### Stage 5: Plan

**Purpose**: Create phased execution plan that respects business flows  
**Entry Criteria**:
- Specification confirmed (Stage 4: confirmed)

**Agent**: `sdd.plan`

**Delegation Model**:
1. `session-bootstrap` → Load context
2. `design-synthesis` → Determine architecture/phases
3. Plan authoring → Create phase breakdowns
4. `dependency-analysis` → Identify inter-phase dependencies
5. `quality-gates` → Validate plan achievability
6. `report-renderer` → Format plan

**Inputs**:
- Specification (Stage 3)
- `.context/repo_map.md` (technical structure)
- `.context/flows/*.md` (business flows to respect)
- Templates: `plan-template.md`

**Outputs**:
- `.arcus/plans/<PLAN-ID>/plan.md` with:
  - Phases (typically 3-5 milestones)
  - Phase entry/exit criteria
  - Technical approach per phase
  - Dependency matrix (what blocks what)
  - Effort estimate (if applicable)
  - Risk mitigations

**Exit Criteria**:
- ✅ Plan contains 2+ phases
- ✅ Each phase has clear acceptance criteria
- ✅ Dependencies identified between phases (if any)
- ✅ Plan is achievable without blocking other teams
- ✅ Quality gates: PASS

**Quality Gates**:
- Phase independence (can phases be done in parallel?)
- Dependency resolution (no circular dependencies)
- Scope containment (each phase focused)

---

#### Stage 6: Tasks

**Purpose**: Decompose plan into granular, testable tasks  
**Entry Criteria**:
- Plan complete (Stage 5: PASS)

**Agent**: `sdd.tasks`

**Delegation Model**:
1. `session-bootstrap` → Load context
2. `work-decomposition` → Break plan into tasks
3. Task authoring → Create detailed task list with acceptance criteria
4. `coverage-analysis` → Ensure tasks cover all spec requirements
5. `quality-gates` → Validate task completeness
6. `report-renderer` → Format tasks

**Inputs**:
- Plan from Stage 5
- Specification from Stage 3
- Templates: `tasks-template.md`

**Outputs**:
- `.arcus/tasks/<TASK-ID>/tasks.md` with:
  - Task list (granular: 1 task = 1-2 day effort)
  - Acceptance criteria per task
  - Dependencies (task B blocks task A)
  - Test approach per task
  - Definition of done checklist

**Exit Criteria**:
- ✅ Task count adequate (typically 5-15 tasks per phase)
- ✅ Each task has clear acceptance criteria
- ✅ All spec requirements mapped to ≥1 task
- ✅ Task dependencies identified
- ✅ Quality gates: PASS

**Quality Gates**:
- Requirement coverage (all spec requirements → tasks)
- Task granularity (no task > 3 days effort)
- Acceptance criteria specificity (verifiable, testable)

---

#### Stage 7: Pre-Implementation Analyze

**Purpose**: Assess scope, dependencies, risks, and effort before implementation  
**Entry Criteria**:
- Tasks defined (Stage 6: PASS)

**Agent**: `sdd.analyze`

**Delegation Model**:
1. `session-bootstrap` → Load context
2. `dependency-analysis` → Identify all upstream/downstream dependencies
3. `coverage-analysis` → Confirm test coverage strategy
4. `design-synthesis` → Review technical approach
5. Analysis reporting → Generate findings
6. `quality-gates` → Validate analysis completeness
7. `report-renderer` → Format report

**Inputs**:
- Tasks from Stage 6
- Plan from Stage 5
- Specification from Stage 3
- `.context/repo_scope.md` (dependencies)
- `.context/flows/*.md` (integration points)

**Outputs**:
- `.arcus/analysis/<ANALYSIS-ID>/pre-implementation-report.md` with:
  - Scope summary (what's changing)
  - Dependencies (what other services/teams affected)
  - Risks (technical, schedule, integration)
  - Estimated effort per task
  - Testing strategy (unit, integration, e2e)
  - Deployment considerations

**Exit Criteria**:
- ✅ All dependencies identified
- ✅ Risks documented with mitigations
- ✅ Testing strategy covers all requirements
- ✅ Deployment plan drafted
- ✅ Quality gates: PASS

**Quality Gates**:
- Dependency completeness (no surprise dependencies found mid-implementation)
- Risk mitigation (all identified risks have mitigations)
- Testing coverage (strategy covers all acceptance criteria)

---

#### Stage 8: Implement

**Purpose**: Guided implementation following plan, architecture, and testing standards  
**Entry Criteria**:
- Analysis complete (Stage 7: PASS)

**Agent**: `sdd.implement`

**Delegation Model**:
1. `session-bootstrap` → Load context, guidelines
2. `design-synthesis` → Provide architectural guidance
3. Implementation guide generation → Code structure recommendations
4. `context-refresh-from-implementation` → Update context if code reveals unknowns
5. `quality-gates` → Validate code quality, test coverage
6. `report-renderer` → Format implementation guide

**Inputs**:
- Pre-implementation analysis from Stage 7
- Tasks from Stage 6
- Specification from Stage 3
- `.arcus/instructions/` (engineering/architecture/testing guidelines)
- `.context/testing-patterns.md` (repo testing conventions)

**Outputs**:
- Implementation guidance:
  - Code structure recommendations
  - Pattern examples
  - API design notes
  - Error handling strategy
  - Logging/observability patterns
  - Test skeleton (unit test templates)
  - Database migration guidance (if applicable)
  - Configuration examples

**Implementation Work** (by engineer, guided by above):
- Write code following guidance
- Write tests adhering to testing patterns
- Update `.context/` if code reveals unknowns
- Commit frequently with clear messages

**Exit Criteria**:
- ✅ All tasks implemented
- ✅ Tests pass
- ✅ Code follows style guidelines (from `.arcus/instructions/`)
- ✅ No security issues flagged by quality gates
- ✅ Integration with other flows successful (if applicable)

**Quality Gates**:
- Code style compliance
- Test coverage (typically ≥80%)
- No high-risk vulnerabilities
- All acceptance criteria verified by tests

---

#### Stage 9: Post-Implementation Analyze

**Purpose**: Verify implementation completeness and alignment with specification  
**Entry Criteria**:
- Implementation complete (Stage 8)
- All tests passing
- Code reviewed and merged

**Agent**: `sdd.analyze` (re-run)

**Delegation Model**:
1. `session-bootstrap` → Load context
2. `coverage-analysis` → Verify test coverage against spec requirements
3. `dependency-analysis` → Confirm all integration points working
4. Verification analysis → Trace code back to spec requirements
5. `context-refresh-from-implementation` → Detect context drift (code vs `.context/`) and refresh impacted artifacts
6. `quality-gates` → Validate completeness
7. `report-renderer` → Format verification report

**Processing**:
- Verifies all spec requirements are implemented
- Confirms all acceptance criteria met and tested
- Checks test coverage against targets
- **Detects context drift**: Analyzes code changes against `.context/` to identify any misalignments
- **Refreshes context**: Updates `.context/` artifacts if implementation reveals changes to business/technical topology
- Suggests context updates if data models, flows, or tech stack changed during implementation

**Inputs**:
- Implementation (committed code)
- Test results + coverage reports
- Specification from Stage 3
- Pre-implementation analysis from Stage 7

**Outputs**:
- `.arcus/analysis/<ANALYSIS-ID>/post-implementation-report.md` with:
  - Completeness checklist (all spec requirements → implementation)
  - Test coverage summary
  - Integration verification (flows still work)
  - Performance notes (if applicable)
  - All acceptance criteria verified
  - Release readiness assessment
  - **Context Drift Analysis**: Changes detected & refreshed in `.context/` (if any)
  - **Context Update Suggestions**: Recommendations for `.context/` updates if implementation revealed unknowns

**Exit Criteria**:
- ✅ All spec requirements implemented
- ✅ All acceptance criteria verified by tests
- ✅ Test coverage ≥ target (typically 80%)
- ✅ No integration regressions
- ✅ Context drift detected and refreshed (if any)
- ✅ Ready for deployment
- ✅ Quality gates: PASS

**Quality Gates**:
- Requirement completeness (spec → implementation traceability)
- Test coverage
- Integration health (no regressions in dependent flows)
- Context drift detection (code vs `.context/` alignment)

---

## Data Touchpoints

| Data | Flow | Direction | Purpose |
|------|------|-----------|---------|
| Feature description | Stage 3 entry | User → Agent | Initial requirement |
| Specification | Stages 3-7 | Generated → Stages 4-7 | Authoritative requirement source |
| Plan | Stages 5-7 | Generated → Stages 6-7 | Phased execution approach |
| Tasks | Stages 6-8 | Generated → Stages 7-8 | Task-level work breakdown |
| Context files | All stages | `.context/` (read) | Selective context loading |
| Copilot instructions | All stages | `.github/copilot-instructions.md` (read) | Guardrails for agents |
| Implementation | Stage 8 | Engineer (write) | Code + tests |
| Test results | Stage 9 | Test framework (read) | Verification of completeness |

---

## Integrations

- **Copilot**: Agents invoked via agent picker (`/sdd.specify`, etc.)
- **Git**: Specs, plans, tasks, analysis reports committed for audit trail
- **Code Repository**: Implementation in real source files; tests run against implementation
- **Testing Framework**: Tests verify all acceptance criteria
- **Context System**: All stages leverage `.context/` for selective, efficient context loading

---

## Scope

| Aspect | Scope |
|--------|-------|
| **Stages** | 9 stages (2 bootstrap + 7 feature) |
| **Target Repos** | Any codebase (language agnostic) |
| **Frequency** | Bootstrap: once per repo; Stages 3-9: once per story/feature |
| **Typical Timeline** | Bootstrap: 1-2 hours; Feature: 2-4 weeks (depending on complexity) |
| **Agents Required Per Feature** | 5-6 agents (specify, clarify, plan, tasks, analyze x2, implement) |
| **Skills Invoked Per Feature** | 30-50 skill calls across all stages (stage 1 uses 6 skills; stages 3-9 use foundation, context, artifact, reasoning, specialized skills) |
| **Quality Gates** | Present at Stage 1, 3, 5, 6, 7, 9 (no stage passes without quality validation) |

---

## Tests

- **Stage Transitions**: Verify Stage N output feeds Stage N+1 input
- **Quality Gates**: Each stage's gate must PASS before proceeding
- **Traceability**: Feature description → Spec → Plan → Tasks → Implementation → Tests
- **Context Loading**: Verify only `.context/` is loaded (not entire repo)
- **Token Efficiency**: Measure average tokens used per stage (goal: minimize without losing quality)

---

## Verification

**commit**: Unknown (workflow design; not tied to specific commit)  
**confidence**: HIGH

Evidence:
- 9-stage structure documented in strategic objectives section
- All stage definitions have entry/exit criteria, agents, quality gates
- Agents (`sdd.specify`, `sdd.plan`, `sdd.tasks`, `sdd.analyze`, `sdd.implement`) exist in `agents/`
- Templates exist for all major artifacts (spec, plan, tasks)
- Skills support each stage (context-builder, spec-authoring, ambiguity-detection, quality-gates, etc.)

---

## Related Flows

- [Context Building](context-building.md) — Stage 1 in detail
- [Agent Execution](agent-execution.md) — How agents execute stages
- [Skill Delegation](skill-delegation.md) — How agents invoke skills
- [Framework Integration](framework-integration.md) — Stage 0 (integration prerequisite)

