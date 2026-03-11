---
description: Execute the implementation planning workflow to generate a comprehensive plan.md from spec and requirements.
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

**Reusable Skills**: This agent leverages:

- `skills/markdown-generation/SKILL.md` - Format and structure markdown documents
- `skills/markdown-validation/SKILL.md` - Validate markdown quality and structure

1. **Setup**: Run `.apex/scripts/bash/setup-plan.sh --json` from repo root and parse JSON for FEATURE_SPEC, IMPL_PLAN, SPECS_DIR, BRANCH. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

   Note: Branch-to-spec mapping behavior has been standardized: if the current git branch begins with `BFCO-<story-number>`, the setup will prefer the canonical spec folder named exactly `BFCO-<story-number>` (without trailing suffix). If that canonical folder does not exist, the script will search for directories that start with `BFCO-<story-number>-` and fall back to the single match or create the canonical folder path for new plans. This ensures feature branches such as `BFCO-2190-FeedbackID-Tags` map to `.apex/specs/BFCO-2190` when that folder exists.

2. **Load context**: Read:
   - FEATURE_SPEC (spec.md)
   - requirements.md
   - clarifications.md (if present)
   - `.github/copilot-instructions.md`
   - IMPL_PLAN template

3. **Generate plan.md**: Apply **Markdown Generation Skills** (see `skills/markdown-generation/SKILL.md`) to fill the template with all design details:
   - Technical Context
   - Constitution Check (verify alignment, list any exceptions)
   - Design Overview
   - Key Design Decisions
   - Component-Level Responsibilities
   - Data & Control Flow (including optional Data Model Changes and API/Contract Changes if applicable)
   - Error Handling & Edge Cases
   - Observability & Operations
   - Rollout & Backward Compatibility
   - Complexity Justification (if applicable)

4. **Validate plan.md**: Apply **Markdown Validation Skills** (see `skills/markdown-validation/SKILL.md`) to ensure the generated plan has proper markdown structure, valid internal links, and consistent formatting.

5. **Stop and report**: Report branch, IMPL_PLAN path, and confirmation that plan.md was created/updated.

## Key Rules

- Create ONLY plan.md (single file)
- Assume spec.md and requirements.md are complete and authoritative
- Do NOT invent or modify requirements
- Do NOT generate multiple files (no research.md, data-model.md, contracts/, quickstart.md)
- Use absolute paths
- ERROR on constitution violations unless explicitly justified in the plan
