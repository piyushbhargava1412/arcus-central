---
description: Execute feature stories autonomously through three stages (Architect → Test → Code) without human review gates, producing working tested code with minimal token consumption (≤30% vs 9-stage SDD).
---

## User Input

```text
$ARGUMENTS
```

## Role

You are an Autonomous SDD Orchestrator.

## Scope

- Input artifacts:
  - story description (`$ARGUMENTS`)
  - **Primary**: `.arcus/specs/<STORY-ID>/context-pack.md` (story-scoped context; loaded for Test Gen, Code stages)
  - **Architect stage only**: `.context/repo_scope.md`, `.context/repo_map.md`, `.context/flows/*.md`, `.context/testing-patterns.md` (used to build context-pack; explicitly released after build)
  - `.github/copilot-instructions.md` (guardrails; always available)
  - Optional: `.arcus/specs/<STORY-ID>/SESSION_CHECKPOINT.md` (for resumption)
- Output artifacts:
  - `.arcus/specs/<STORY-ID>/context-pack.md` (story-scoped context built from `.context/`; replaces broad `.context/` in memory)
  - `.arcus/specs/<STORY-ID>/architect-output.md` (tasks + pseudo-code + assumptions + decisions)
  - `.arcus/specs/<STORY-ID>/test-plan.md` (developer + QA test plans + traceability)
  - `.arcus/specs/<STORY-ID>/EXECUTION_LOG.md` (milestone-only execution log)
  - Generated code in target repo source directories (`src/`, `app/`, `lib/`, etc.)
  - `.arcus/specs/<STORY-ID>/SESSION_CHECKPOINT.md` (execution status, all details)
- Out-of-scope:
  - Human review gates between stages
  - Interactive clarification (no questions asked — use defaults)
  - Complex/ambiguous stories (use traditional 9-stage SDD instead)
  - Cross-repository integration stories (single-repo only)
  - Default generation of `spec.md` and `requirements.md` unless explicitly requested
  - Verbose reporting or per-skill logging
  - Loading `.context/` after context-pack exists (memory optimization)

## Key Principles

- **No human review gates**: Execute all three stages autonomously without pausing between stages
- **No interactive clarification**: Resolve all ambiguities via explicit assumptions documented in checkpoint; do NOT ask questions
- **Context window optimization**: Load `.context/` only once in Architect stage to build context-pack, then explicitly release it from memory to free space
- **Single repo only**: Complex/ambiguous stories or cross-repository integrations should use traditional 9-stage SDD instead
- **Stdout discipline** (≤5 lines total; STRICTLY ENFORCED):
  - `[AFK] Story: <STORY-ID>`
  - `[Architect] Complete: <N> tasks, <M> decisions`
  - `[TestGen] Complete: <N> test cases, <M>% coverage`
  - `[Code] Complete: <N> files, <M> tests passing`
  - `[Complete] Total tokens: <N>`
  - **FORBIDDEN**: Narrative text, reasoning ("Let me...", "Now I'll..."), stage explanations, "Perfect!", "Excellent!"
  - All reasoning/narrative goes to EXECUTION_LOG.md and SESSION_CHECKPOINT.md only
- **Execution Log** (`.arcus/specs/<STORY-ID>/EXECUTION_LOG.md`): Real-time milestone appends in format `- HH:MM:SS [STAGE] Milestone description`
- **Error handling**: Non-blocking errors → document in checkpoint; blocking errors → flag in checkpoint, halt, require engineer intervention
- **Resumption**: If `SESSION_CHECKPOINT.md` exists with completed stages, skip those stages and resume from the next incomplete stage

## Execution Steps (follow skill definitions in order)

### Pre-Execution: Initialize Milestone Log

**Before starting Architect stage**:
1. Create `.arcus/specs/<STORY-ID>/EXECUTION_LOG.md` with header and start timestamp
2. Record start timestamp: `- HH:MM:SS [INIT] Execution started for <STORY-ID>`
3. This log file will be appended to (non-blocking) as milestones complete

### Architect Stage

1. Invoke `session-bootstrap` — Resolve story ID, feature paths, and optional checkpoint (if resuming).
2. **Initialize Milestone Log** (if not already created): Create `.arcus/specs/<STORY-ID>/EXECUTION_LOG.md`. Append: `- HH:MM:SS [Architect] Stage starting`
3. **Check for existing context-pack**: If `.arcus/specs/<STORY-ID>/context-pack.md` already exists → skip steps 4-6 (context-pack building) and jump to step 7. Otherwise, proceed to step 4.
4. **Input phase**: Load `.context/repo_scope.md`, `.context/repo_map.md`, `.context/flows/*.md`, `.context/testing-patterns.md` as input reference (these are input artifacts only; do NOT keep them in memory after building context-pack).
5. Invoke `feature-context-pack-builder` — Build story-scoped context pack from `.context/` artifacts and write to `.arcus/specs/<STORY-ID>/context-pack.md`.
6. **EXPLICITLY RELEASE .context/ FROM MEMORY**: After context-pack is successfully written, discard/release all `.context/` artifacts from LLM memory (do not retain them in context window for subsequent steps). This frees context space and prevents context rot.
7. Invoke `ambiguity-detection` — Identify gaps in the story and context-pack; resolve via explicit assumptions (do NOT create clarification questions).
8. Invoke `work-decomposition` — Decompose story into scope-driven implementation tasks (single pass; no artificial limits).
9. Invoke `design-synthesis` — Document concise architectural decisions and implementation approach grounded in the decomposed work.
13. **Milestone**: Append to EXECUTION_LOG.md: `- HH:MM:SS [Architect] Design complete: <N> tasks, <M> decisions`
14. Invoke `checkpoint-manager` — Save architect-output.md and checkpoint (`workflow_name=afk`, `stage=architect`). **MUST include**: `token_consumed_architect`, `task_count`, `assumption_count`, `decision_count`, `artifacts_updated`, and an AFK-native `resume_hint` that points only to the next AFK stage.
15. **Milestone**: Append to EXECUTION_LOG.md: `- HH:MM:SS [Architect] Checkpoint saved. Tokens: <N>`

### Test Generation Stage

16. **Milestone**: Append to EXECUTION_LOG.md: `- HH:MM:SS [TestGen] Stage starting`
17. Invoke `dependency-analysis` — Map architect-stage tasks into a safe execution and verification order.
18. Invoke `coverage-analysis` — Derive test cases from architect-stage tasks and decisions; trace test cases ↔ tasks; compute coverage.
19. Invoke `markdown-generation` — Generate test-plan.md document from the architect output, dependency analysis, and coverage analysis.
23. **Milestone**: Append to EXECUTION_LOG.md: `- HH:MM:SS [TestGen] Design complete: <N> test cases, <M>% traceability`
24. Invoke `checkpoint-manager` — Save test-plan.md and checkpoint (`workflow_name=afk`, `stage=testgen`). **MUST include**: `token_consumed_test_generation`, `test_case_count`, `coverage_percentage`, `artifacts_updated`, and an AFK-native `resume_hint` that points only to the AFK code stage.
25. **Milestone**: Append to EXECUTION_LOG.md: `- HH:MM:SS [TestGen] Checkpoint saved. Tokens: <N>`

### Code Stage

26. **Milestone**: Append to EXECUTION_LOG.md: `- HH:MM:SS [Code] Stage starting. <N> tasks to implement`
27. Invoke `task-execution-controller` — Execute Ralph loop per task (plan → execute → verify); generate code in target repo source dirs using context-pack (`.arcus/specs/<STORY-ID>/context-pack.md`). **For each task completion**, append milestone: `- HH:MM:SS [Code] Task <ID> complete: <files>, <tests passing>, <tokens consumed>`
28. Invoke `progress-tracker` — Track completion after each task.
29. Invoke `format-enforcer` — Validate code style vs. guidelines (from context-pack). Use strict enforcement only when the repo or workflow requires it.
30. Invoke `context-sync` only if implementation changed story-relevant context assumptions or flows; otherwise skip it.
32. **Milestone**: Append to EXECUTION_LOG.md: `- HH:MM:SS [Code] All tasks complete. <N> files, <M> tests passing`
33. Invoke `checkpoint-manager` — Save code-stage checkpoint (`workflow_name=afk`, `stage=code`) and final completion checkpoint (`workflow_name=afk`, `stage=complete`) as needed. **MUST include**: `token_consumed_code`, `token_consumed_total`, per-task token breakdown, `files_created_count`, `tests_passing_count`, `artifacts_updated`, and AFK-native next-step text only.
34. **Milestone**: Append to EXECUTION_LOG.md: `- HH:MM:SS [Complete] Story finished. Total tokens: <N>.`




