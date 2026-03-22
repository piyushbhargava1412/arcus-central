# SDD Framework — Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                    APEX SDD WORKFLOW                                │
│                                                                     │
│  Skills (shared capability-based inventory — loaded on demand):    │
│  ┌─────────────┐ ┌──────────────┐ ┌──────────────┐ ┌───────────────┐ │
│  │ artifact/   │ │ reasoning/   │ │ interaction/ │ │ formatting/   │ │
│  │ (modeling,  │ │ (design,     │ │ (question-   │ │ (format-      │ │
│  │ patching,    │ │ decomposition,│ │ orchestration)│ │ enforcer)     │ │
│  │ markdown)    │ │ dependency,  │ │              │ │               │ │
│  │              │ │ coverage)    │ │              │ │               │ │
│  └─────┬────────┘ └────┬─────────┘ └─────┬────────┘ └────┬──────────┘ │
│        │                 │                  │                 │      │
│        └─────────────────┴──────────────────┴─────────────────┘      │
│                        Referenced by agents via                      │
│                         "Apply skill: skills/<domain>/<skill>"        │
│                        (copied into target as read-only)             │
└─────────────────────────────────────────────────────────────────────┘

══════════════════════════════════════════════════════════════════════
 PHASE 1: REPO ONBOARDING (one-time per repo)
══════════════════════════════════════════════════════════════════════

  ┌───────────────────────────────────┐
  │  Step 1: /sdd.repo-intelligence   │
  │  ─────────────────────────────── │
  │  Scan codebase → understand it    │
  │                                   │
  │  Skills: specialized/repository-analysis, artifact/markdown-generation,
  │          artifact/markdown-validation
  │                                   │
  │  Input:  codebase                 │
  │  Output: docs/repo_map.md         │
  │          docs/repo_scope.md       │
  └──────────────┬────────────────────┘
                 │
                 │ repo_map.md + repo_scope.md
                 │
                 ▼
  ┌───────────────────────────────────┐
  │  Step 2: /sdd.instructions        │
  │  ─────────────────────────────── │
  │  Create project copilot instructions and governance
  │                                   │
  │  Skills: specialized/repository-analysis, artifact/markdown-generation,
  │          artifact/markdown-validation
  │                                   │
  │  Input:  repo_map.md (tech stack) │
  │          repo_scope.md (business) │
  │  Output: .github/copilot-instructions.md
  └──────────────┬────────────────────┘
                 │
                 ▼

══════════════════════════════════════════════════════════════════════
 PHASE 2: FEATURE DEVELOPMENT (repeat per feature)
══════════════════════════════════════════════════════════════════════

  ┌───────────────────────────────────┐
  │  Step 3: /sdd.groom  [OPTIONAL]   │
  │  ─────────────────────────────── │
  │  Break vague requirements into    │
  │  structured user stories          │
  │                                   │
  │  Skills: artifact/markdown-generation,
  │          artifact/markdown-validation
  │                                   │
  │  Input:  requirement text         │
  │  Output: .apex/groom/<story>.md   │
  └──────────────┬────────────────────┘
                 │
                 ▼
  ┌───────────────────────────────────┐
  │  Step 4: /sdd.specify             │
  │  ─────────────────────────────── │
  │  Create feature spec (WHAT/WHY)   │
  │  No implementation details        │
  │                                   │
  │  Skills: artifact/markdown-generation,
  │          artifact/markdown-validation
  │                                   │
  │  Input:  feature description      │
  │  Output: .apex/specs/<ID>/        │
  │            spec.md                │
  │            requirements.md        │
  └──────────────┬────────────────────┘
                 │
                 ▼
  ┌───────────────────────────────────┐
  │  Step 5: /sdd.clarify             │
  │  ─────────────────────────────── │
  │  Resolve ambiguities (max 5 Q's)  │
  │  Interactive — one Q at a time    │
  │  Answers encoded back into spec   │
  │                                   │
  │  Skills: interaction/question-orchestration,
  │          artifact/artifact-patcher,
  │          artifact/markdown-validation
  │                                   │
  │  Input:  spec.md                  │
  │  Output: spec.md (updated)        │
  │          clarifications.md (opt)  │
  └──────────────┬────────────────────┘
                 │
                 ▼
  ┌───────────────────────────────────┐
  │  Step 6: /sdd.plan                │
  │  ─────────────────────────────── │
  │  Create implementation plan (HOW) │
  │  Architecture + design decisions  │
  │                                   │
  │  Skills: artifact/artifact-modeling,
  │          reasoning/design-synthesis,
  │          artifact/markdown-validation
  │                                   │
  │  Input:  spec.md + constitution   │
  │  Output: .apex/specs/<ID>/        │
  │            plan.md                │
  └──────────────┬────────────────────┘
                 │
                 ▼
  ┌───────────────────────────────────┐
  │  Step 7: /sdd.tasks               │
  │  ─────────────────────────────── │
  │  Generate task breakdown          │
  │  Organized by user story          │
  │                                   │
  │  Skills: artifact/artifact-modeling,
  │          reasoning/work-decomposition,
  │          reasoning/dependency-analysis,
  │          formatting/format-enforcer
  │                                   │
  │  Format:                          │
  │  - [ ] T001 [P] [US1] desc path   │
  │                                   │
  │  Input:  plan.md + spec.md        │
  │  Output: .apex/specs/<ID>/        │
  │            tasks.md               │
  └──────────────┬────────────────────┘
                 │
                 ▼
  ┌───────────────────────────────────┐
  │  Step 8: /sdd.analyze             │
  │  ─────────────────────────────── │
  │  Cross-artifact quality check     │
  │  *** READ-ONLY — no files modified***     │
  │                                   │
  │  Skills: artifact/artifact-modeling,
  │          reasoning/coverage-analysis,
  │          formatting/format-enforcer
  │                                   │
  │  Checks:                          │
  │  • Duplication across artifacts   │
  │  • Ambiguity / placeholders       │
  │  • Coverage gaps (req ↔ tasks)    │
  │  • Constitution violations        │
  │  • Terminology drift              │
  │                                   │
  │  Input:  spec + plan + tasks      │
  │  Output: chat report only         │
  │          (CRITICAL/HIGH/MED/LOW)  │
  └──────────────┬────────────────────┘
                 │
                 ▼
  ┌───────────────────────────────────┐
  │  Step 9: /sdd.implement           │
  │  ─────────────────────────────── │
  │  Execute tasks phase-by-phase     │
  │                                   │
  │  Skills: reasoning/coverage-analysis,
  │          reasoning/work-decomposition,
  │          reasoning/dependency-analysis,
  │          specialized/execution/task-execution-controller,
  │          specialized/execution/progress-tracker
  │                                   │
  │  • Validates checklists first     │
  │  • Phase 1: Setup                 │
  │  • Phase 2: Foundational          │
  │  • Phase 3+: User stories (P1→Pn) │
  │  • Final: Polish                  │
  │  • Marks tasks [X] on completion  │
  │                                   │
  │  Input:  tasks.md + plan.md       │
  │  Output: source code              │
  │          tasks.md (marked done)   │
  └───────────────────────────────────┘


══════════════════════════════════════════════════════════════════════
 ARTIFACT FLOW
══════════════════════════════════════════════════════════════════════

  repo-intelligence ──→ repo_map.md ──────────────┐
                   ──→ repo_scope.md ─────────────┤
                                                    ▼
  instructions ────→ copilot-instructions.md ──→ [CONSTITUTION]
       ▲                                           │
       │ reads repo_map.md + repo_scope.md         │
       │ (skips full repo scan if available)        │
                                                    ▼
  groom ───────────→ user stories ─────┐
                                       ▼
  specify ─────────→ spec.md ──────→ clarify ──→ spec.md (refined)
                      requirements.md               │
                                                    ▼
                                         plan ──→ plan.md
                                                    │
                                                    ▼
                                         tasks ──→ tasks.md
                                                    │
                                                    ▼
                                         analyze ─→ chat report
                                                    │
                                                    ▼
                                         implement → source code


══════════════════════════════════════════════════════════════════════
 SKILL DELEGATION MAP
══════════════════════════════════════════════════════════════════════

This matrix shows which capability-based skills are commonly used by each agent. A checkmark indicates primary/regular usage; agents may reference additional skills as needed.

| Agent              | artifact/* | reasoning/* | interaction/* | formatting/* | specialized/* |
|-------------------:|:----------:|:-----------:|:-------------:|:------------:|:-------------:|
| repo-intelligence  |     ✅     |      ✅     |       ✅      |      ✅      |       ✅      |
| instructions       |     ✅     |      ✅     |       ✅      |      ✅      |       ✅      |
| groom              |     ✅     |             |       ✅      |      ✅      |               |
| specify            |     ✅     |             |               |      ✅      |               |
| clarify            |     ✅     |             |       ✅      |      ✅      |               |
| plan               |     ✅     |      ✅     |               |      ✅      |               |
| tasks              |     ✅     |      ✅     |               |      ✅      |               |
| analyze            |     ✅     |      ✅     |               |      ✅      |               |
| implement          |           |      ✅     |               |             |       ✅      |

(Legend: ✅ primary usage)

``` 

