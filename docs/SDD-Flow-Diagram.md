# SDD Framework — Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                    APEX SDD WORKFLOW                                │
│                                                                     │
│  Skills (shared infrastructure — loaded on demand):                 │
│  ┌──────────────────┐ ┌──────────────────┐ ┌────────────────────┐  │
│  │ markdown-        │ │ markdown-        │ │ repository-        │  │
│  │ generation       │ │ validation       │ │ analysis           │  │
│  │ (169 lines)      │ │ (72 lines)       │ │ (56 lines)         │  │
│  │                  │ │                  │ │                    │  │
│  │ • Headings       │ │ • Path checks    │ │ • .apex-ignore     │  │
│  │ • Tables         │ │ • Link checks    │ │ • Dir scanning     │  │
│  │ • Code blocks    │ │ • Placeholders   │ │ • Tech detection   │  │
│  │ • Formatting     │ │ • Structure      │ │ • Classification   │  │
│  └────────┬─────────┘ └────────┬─────────┘ └─────────┬──────────┘  │
│           │                    │                      │             │
│           └────────────┬───────┴──────────────────────┘             │
│                        │ referenced by agents via                   │
│                        │ "Apply Skills (see skills/...)"           │
│                        ▼                                            │
└─────────────────────────────────────────────────────────────────────┘

══════════════════════════════════════════════════════════════════════
 PHASE 1: REPO ONBOARDING (one-time per repo)
══════════════════════════════════════════════════════════════════════

  ┌───────────────────────────────────┐
  │  Step 1: /sdd.repo-intelligence   │
  │  ─────────────────────────────── │
  │  Scan codebase → understand it    │
  │                                   │
  │  Skills: repo-analysis            │
  │          md-generation            │
  │          md-validation            │
  │                                   │
  │  Input:  codebase                 │
  │  Output: docs/repo_map.md        │
  │          docs/repo_scope.md       │
  └──────────────┬────────────────────┘
                 │
                 ▼
  ┌───────────────────────────────────┐
  │  Step 2: /sdd.instructions        │
  │  ─────────────────────────────── │
  │  Create project constitution      │
  │                                   │
  │  Skills: repo-analysis            │
  │          md-generation            │
  │          md-validation            │
  │                                   │
  │  Input:  repo analysis + guides   │
  │  Output: .github/                 │
  │          copilot-instructions.md  │
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
  │  Skills: md-generation            │
  │          md-validation            │
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
  │  Skills: md-generation            │
  │          md-validation            │
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
  │  Skills: md-validation            │
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
  │  Skills: md-generation            │
  │          md-validation            │
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
  │  Skills: md-generation            │
  │          md-validation            │
  │                                   │
  │  Format:                          │
  │  - [ ] T001 [P] [US1] desc path  │
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
  │  *** READ-ONLY — no files ***     │
  │                                   │
  │  Skills: md-validation            │
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
  │  Skills: none (generates code)    │
  │                                   │
  │  • Validates checklists first     │
  │  • Phase 1: Setup                 │
  │  • Phase 2: Foundational          │
  │  • Phase 3+: User stories (P1→Pn)│
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
                                                   │
                                                   │ all agents
                                                   │ must align
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

                   markdown-    markdown-    repository-
  Agent            generation   validation   analysis
  ─────────────    ──────────   ──────────   ───────────
  repo-intelligence   ✅ (3)       ✅ (3)       ✅ (3)
  instructions        ✅ (3)       ✅ (3)       ✅ (2)
  groom               ✅ (2)       ✅ (2)         —
  specify             ✅ (3)       ✅ (2)         —
  clarify               —          ✅ (2)         —
  plan                ✅ (2)       ✅ (2)         —
  tasks               ✅ (2)       ✅ (2)         —
  analyze               —          ✅ (1)         —
  implement             —            —            —

  (number) = delegation points in agent file
```

