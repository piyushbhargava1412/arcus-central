# ARCUS SDD Framework — Workflow Diagram

**Framework**: 9 agents (6 core + 3 extensions), 22 reusable skills, 11 templates  
**Goal**: Reduce hallucinations, optimize token utilization, improve selective context loading

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      ARCUS SDD AGENTS (9 total)                         │
│                                                                         │
│  Core Agents (6):        Extensions (3):                               │
│  ┌─────────────┐         ┌──────────────────┐                          │
│  │ specify     │         │ context-builder  │ ← Bootstraps context     │
│  │ clarify     │         │ groom            │ ← Story grooming         │
│  │ plan        │         │ instructions     │ ← Governance             │
│  │ tasks       │                                                       │
│  │ analyze     │                                                       │
│  │ implement   │                                                       │
│  └─────────────┘         └──────────────────┘                          │
│                                                                         │
│  All agents delegate to reusable skills (22 total) across 10 domains   │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│              SKILLS SYSTEM (22 reusable, capability-based)              │
│                                                                         │
│  🟢 Core (3):           🟦 Artifact (4):      🟨 Multi-Use (5):        │
│  • session-bootstrap    • artifact-modeling   • feature-context-pack   │
│  • quality-gates        • artifact-patcher    • question-orchestration │
│  • report-renderer      • markdown-gen        • context-drift-reconcile│
│                         • markdown-validation • format-enforcer        │
│                                                                         │
│  🟦 Reasoning (4):      🟦 Foundation (2):   🟪 Specialized (8):       │
│  • design-synthesis     • repo-context-build  • spec-authoring         │
│  • work-decomposition   • flow-discovery      • ambiguity-detection    │
│  • dependency-analysis  • test-pattern-disc   • task-execution-control │
│  • coverage-analysis                          • + interaction, maint   │
│                                                                         │
│  Loaded on-demand by agents, NOT shipped to target repos               │
└─────────────────────────────────────────────────────────────────────────┘

═════════════════════════════════════════════════════════════════════════════
 PHASE A: BOOTSTRAP (One-Time per Target Repository)
═════════════════════════════════════════════════════════════════════════════

  ┌──────────────────────────────────────────────────┐
  │  Stage 1: /sdd.context-builder                   │
  │  ─────────────────────────────────────────────── │
  │  Initialize repository context                   │
  │                                                  │
  │  What it does:                                   │
  │  • Analyzes target repository structure          │
  │  • Generates .context/repo_scope.md (business)   │
  │  • Generates .context/repo_map.md (technical)    │
  │  • Discovers flows → .context/flows/*.md         │
  │  • Analyzes tests → .context/testing-patterns.md │
  │                                                  │
  │  Skills: repository-context-builder,             │
  │          flow-and-scope-discovery,               │
  │          test-pattern-discovery                  │
  │                                                  │
  │  Output: .context/ (5 artifacts)                 │
  └────────────────┬─────────────────────────────────┘
                   │
                   ▼
  ┌──────────────────────────────────────────────────┐
  │  Stage 2: /sdd.instructions                      │
  │  ─────────────────────────────────────────────── │
  │  Create project copilot instructions             │
  │                                                  │
  │  What it does:                                   │
  │  • Reads .context/repo_scope.md + repo_map.md    │
  │  • Synthesizes repo-specific guardrails          │
  │  • Generates .github/copilot-instructions.md     │
  │                                                  │
  │  Output: Copilot instructions (enforces          │
  │          consistency across all agents)          │
  └────────────────┬─────────────────────────────────┘
                   │
                   ▼ Ready for feature development

═════════════════════════════════════════════════════════════════════════════
 PHASE B: FEATURE DEVELOPMENT (Repeat per Story/Requirement)
═════════════════════════════════════════════════════════════════════════════
              9-Stage Workflow: Specify→Clarify→Plan→Tasks→Analyze→Implement→Analyze

  ┌──────────────────────────────────────────────────┐
  │  Stage 3: /sdd.specify                           │
  │  ─────────────────────────────────────────────── │
  │  Create feature specification (WHAT/WHY)         │
  │  No implementation details                       │
  │                                                  │
  │  Skills: session-bootstrap, feature-context-pack │
  │          spec-authoring, ambiguity-detection,    │
  │          quality-gates, report-renderer          │
  │                                                  │
  │  Input:  Feature description + .context/        │
  │  Output: .arcus/specs/<ID>/                      │
  │           • spec.md (requirements)               │
  │           • requirements.md (testable list)      │
  │           • context-pack.md (story context)      │
  └────────────────┬─────────────────────────────────┘
                   │
                   ▼
  ┌──────────────────────────────────────────────────┐
  │  Stage 4: /sdd.clarify                           │
  │  ─────────────────────────────────────────────── │
  │  Resolve ambiguities (max 5 questions)           │
  │  Interactive — one Q at a time                   │
  │  Answers encoded back into spec                  │
  │                                                  │
  │  Skills: session-bootstrap, ambiguity-detection, │
  │          question-orchestration,                 │
  │          artifact-patcher,                       │
  │          markdown-validation, quality-gates      │
  │                                                  │
  │  Input:  spec.md from Stage 3                    │
  │  Output: spec.md (refined), clarifications noted │
  └────────────────┬─────────────────────────────────┘
                   │
                   ▼
  ┌──────────────────────────────────────────────────┐
  │  Stage 5: /sdd.plan                              │
  │  ─────────────────────────────────────────────── │
  │  Create implementation plan (HOW)                │
  │  Architecture + design decisions + phases        │
  │                                                  │
  │  Skills: session-bootstrap, artifact-modeling,   │
  │          design-synthesis, dependency-analysis,  │
  │          quality-gates, report-renderer          │
  │                                                  │
  │  Input:  spec.md + .context/repo_map.md          │
  │  Output: plan.md (phased approach)               │
  └────────────────┬──────────────────────────────────┘
                   │
                   ▼
  ┌──────────────────────────────────────────────────┐
  │  Stage 6: /sdd.tasks                             │
  │  ─────────────────────────────────────────────── │
  │  Generate granular task breakdown                │
  │  Organized by phase + user story                 │
  │  Includes acceptance criteria per task           │
  │                                                  │
  │  Skills: session-bootstrap, artifact-modeling,   │
  │          work-decomposition,                     │
  │          dependency-analysis,                    │
  │          coverage-analysis, format-enforcer,     │
  │          quality-gates, report-renderer          │
  │                                                  │
  │  Format: - [ ] T001 [Phase] [P1] desc [path]    │
  │                                                  │
  │  Input:  plan.md + spec.md                       │
  │  Output: tasks.md (dependency-ordered)           │
  └────────────────┬─────────────────────────────────┘
                   │
                   ▼
  ┌──────────────────────────────────────────────────┐
  │  Stage 7: /sdd.analyze (PRE-IMPLEMENTATION)      │
  │  ─────────────────────────────────────────────── │
  │  Cross-artifact quality check (READ-ONLY)        │
  │  *** Does NOT modify any files ***               │
  │                                                  │
  │  Skills: session-bootstrap, artifact-modeling,   │
  │          coverage-analysis, dependency-analysis, │
  │          format-enforcer, quality-gates,         │
  │          report-renderer                         │
  │                                                  │
  │  Checks:                                         │
  │  • Requirement → Task traceability               │
  │  • Test coverage strategy                        │
  │  • Dependency completeness                       │
  │  • Technical readiness                           │
  │                                                  │
  │  Input:  spec.md + plan.md + tasks.md            │
  │  Output: Analysis report (CRITICAL/HIGH/MED/LOW) │
  └────────────────┬─────────────────────────────────┘
                   │
                   ▼
  ┌──────────────────────────────────────────────────┐
  │  Stage 8: /sdd.implement                         │
  │  ─────────────────────────────────────────────── │
  │  Execute tasks phase-by-phase                    │
  │                                                  │
  │  Skills: session-bootstrap, coverage-analysis,   │
  │          work-decomposition, dependency-analysis,│
  │          task-execution-controller,              │
  │          quality-gates, report-renderer          │
  │                                                  │
  │  Process:                                        │
  │  • Validate implementation readiness             │
  │  • Execute phases in order (respecting deps)     │
  │  • Mark tasks [X] as completed                   │
  │  • Track progress + errors                       │
  │                                                  │
  │  Input:  tasks.md + guidelines from .context/    │
  │  Output: Source code + tests + updated tasks.md  │
  └────────────────┬─────────────────────────────────┘
                   │
                   ▼
  ┌──────────────────────────────────────────────────┐
  │  Stage 9: /sdd.analyze (POST-IMPLEMENTATION)     │
  │  ─────────────────────────────────────────────── │
  │  Verify implementation completeness              │
  │  Alignment with specification                    │
  │  *** ALSO: Detect context drift & refresh ***    │
  │                                                  │
  │  Skills: session-bootstrap, coverage-analysis,   │
  │          dependency-analysis,                    │
  │          context-refresh-from-implementation,    │
  │          format-enforcer, quality-gates,         │
  │          report-renderer                         │
  │                                                  │
  │  Verifies:                                       │
  │  • All spec requirements implemented             │
  │  • All acceptance criteria met                   │
  │  • Test coverage sufficient                      │
  │  • No integration regressions                     │
  │  • *** Code changes vs .context/ alignment ***   │
  │  • *** Suggests context updates if needed ***    │
  │                                                  │
  │  Output:                                         │
  │  • Verification report                           │
  │  • Updated .context/ (if drift detected)         │
  │  • Release readiness assessment                  │
  │                                                  │
  │  Input:  Implementation + tests + spec.md        │
  │  Output: Verification report + release readiness │
  └──────────────────────────────────────────────────┘


═════════════════════════════════════════════════════════════════════════════
 ARTIFACT & CONTEXT FLOW
═════════════════════════════════════════════════════════════════════════════

  BOOTSTRAP:
  ┌────────────────────────┐
  │ context-builder        │  Analyzes target repo once
  └──────────┬─────────────┘
             │
             │ Generates (read by agents):
             ├─→ .context/repo_scope.md ────────────────┐
             ├─→ .context/repo_map.md ──────────────────┤
             ├─→ .context/flows/*.md ────────────────────┤
             └─→ .context/testing-patterns.md           │
                                                         │
  ┌────────────────────────┐                            │
  │ instructions           │◄───────────────────────────┘
  │ (reads repo_scope      │
  │  + repo_map once)      │  Generates (enforces via agents):
  └──────────┬─────────────┘
             │
             └─→ .github/copilot-instructions.md ──→ [GOVERNANCE]


  FEATURE DEVELOPMENT:
  ┌────────────────────────┐
  │ specify                │ ◄────────── Feature description + .context/
  ├──────────────────────────────────────┐
  │ spec.md + requirements.md + context   │
  └────────────────────────┬──────────────┘
             │
             ▼
  ┌────────────────────────┐
  │ clarify                │ ◄────────── Interactive Q&A (max 5 Q's)
  ├──────────────────────────────────────┐
  │ spec.md (refined)                    │
  └────────────────────────┬──────────────┘
             │
             ▼
  ┌────────────────────────┐
  │ plan                   │ ◄────────── Architecture + phases
  ├──────────────────────────────────────┐
  │ plan.md                              │
  └────────────────────────┬──────────────┘
             │
             ▼
  ┌────────────────────────┐
  │ tasks                  │ ◄────────── Granular decomposition
  ├──────────────────────────────────────┐
  │ tasks.md (dependency-ordered)        │
  └────────────────────────┬──────────────┘
             │
             ▼
  ┌────────────────────────┐
  │ analyze (pre-impl)     │ ◄────────── Quality check (READ-ONLY)
  ├──────────────────────────────────────┐
  │ Analysis report                      │
  └────────────────────────┬──────────────┘
             │
             ▼
  ┌────────────────────────┐
  │ implement              │ ◄────────── Execute phase-by-phase
  ├──────────────────────────────────────┐
  │ Source code + tests                  │
  └────────────────────────┬──────────────┘
             │
             ▼
  ┌────────────────────────┐
  │ analyze (post-impl)    │ ◄────────── Verification (READ-ONLY)
  ├──────────────────────────────────────┐
  │ Verification report + release ok     │
  └────────────────────────────────────────┘


═════════════════════════════════════════════════════════════════════════════
 SKILL DELEGATION MAP (Which Skills Each Agent Uses)
═════════════════════════════════════════════════════════════════════════════

| Agent              | Core | Artifact | Reasoning | Context | Interaction | Formatting | Specialized |
|--------------------|:----:|:--------:|:---------:|:-------:|:-----------:|:---------:|:-----------:|
| context-builder    |  2   |    1     |     -     |    2    |      -      |     -     |      -      |
| instructions       |  2   |    1     |     -     |    -    |      1      |     1     |      -      |
| groom              |  2   |    2     |     -     |    -    |      1      |     1     |      -      |
| specify            |  3   |    1     |     -     |    1    |      -      |     1     |      1      |
| clarify            |  3   |    2     |     -     |    1    |      1      |     1     |      1      |
| plan               |  3   |    1     |     1     |    -    |      -      |     1     |      -      |
| tasks              |  3   |    1     |     3     |    -    |      -      |     1     |      -      |
| analyze            |  3   |    1     |     2     |    -    |      -      |     1     |      -      |
| implement          |  3   |    -     |     3     |    -    |      -      |     -     |      1      |

Legend:
- Core (3): session-bootstrap, quality-gates, report-renderer
- Artifact (4): artifact-modeling, artifact-patcher, markdown-gen, markdown-validation
- Reasoning (4): design-synthesis, work-decomposition, dependency-analysis, coverage-analysis
- Context (2): feature-context-pack-builder, context-drift-and-reconcile
- Interaction (1): question-orchestration
- Formatting (1): format-enforcer
- Specialized (8): repo-context-builder, flow-discovery, test-pattern-discovery, spec-authoring, ambiguity-detection, task-execution-controller, + others
```

