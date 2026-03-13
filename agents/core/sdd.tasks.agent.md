---
description: Generate an actionable, dependency-ordered tasks.md for the feature based on available design artifacts.
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

## Operating Constraints

**CRITICAL - NO CODE IMPLEMENTATION**: This agent MUST NEVER implement, write, or generate any application code, regardless of user phrasing. This agent's sole purpose is to generate task breakdowns and execution plans.

**User Intent Interpretation**: When users say "implement" while using this agent, they mean "create the task breakdown" — NOT "write code now." Code implementation occurs ONLY in the `/sdd.implement` agent after all preparatory phases are complete.

1. **Setup**: Run `.apex/scripts/bash/check-prerequisites.sh --json` from repo root and parse FEATURE_DIR and AVAILABLE_DOCS list. All paths must be absolute. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

2. **Load design documents**: Read from FEATURE_DIR:

- **Required**: plan.md (tech stack, libraries, structure), spec.md (user stories with priorities)
- **Optional**: data-model.md (entities), contracts/ (API endpoints), research.md (decisions), quickstart.md (test scenarios)
- Note: Not all projects have all documents. Generate tasks based on what's available.

3. **Execute task generation workflow**:

- Load plan.md and extract tech stack, libraries, project structure
- Load spec.md and extract user stories with their priorities (P1, P2, P3, etc.)
- If data-model.md exists: Extract entities and map to user stories
- If contracts/ exists: Map endpoints to user stories
- If research.md exists: Extract decisions for setup tasks
- Generate tasks organized by user story (see Task Generation Rules below)
- Generate dependency graph showing user story completion order
- Create parallel execution examples per user story
- Validate task completeness (each user story has all needed tasks, independently testable)

4. **Generate tasks.md**: Apply **Markdown Generation Skills** (see `skills/markdown-generation/SKILL.md`) to use `.apex/templates/tasks-template.md` as structure, fill with:

- Correct feature name from plan.md
- Phase 1: Setup tasks (project initialization)
- Phase 2: Foundational tasks (blocking prerequisites for all user stories)
- Phase 3+: One phase per user story (in priority order from spec.md)
- Each phase includes: story goal, independent test criteria, tests (if requested), implementation tasks
- Final Phase: Polish & cross-cutting concerns
- All tasks must follow the strict checklist format (see Task Generation Rules below)
- Clear file paths for each task
- Dependencies section showing story completion order
- Parallel execution examples per story
- Implementation strategy section (MVP first, incremental delivery)

5. **Validate tasks.md**: Apply **Markdown Validation Skills** (see `skills/markdown-validation/SKILL.md`) to ensure the generated tasks follow proper markdown structure, checklist format is correct, and all file paths are valid.

6. **Report**: Output ONLY tasks.md as a new file in .apex/specs/<STORY_ID>/tasks.md:

- Display total task count in chat
- Display task count per user story in chat
- Display parallel opportunities identified in chat
- Display independent test criteria for each story in chat
- Display suggested MVP scope in chat (typically just User Story 1)
- Display format validation results in chat (Confirm ALL tasks follow the checklist format - checkbox, ID, labels, file paths)
- **CRITICAL**: Only create tasks.md file
  - DO NOT create INDEX.md, ANALYSIS.md, or any other \*-SUMMARY.md files
- All reporting must be via chat output only

Context for task generation: $ARGUMENTS

The tasks.md should be immediately executable - each task must be specific enough that an LLM can complete it without additional context.

## Task Generation Rules

**CRITICAL**: Tasks MUST be organized by user story to enable independent implementation and testing.

**Tests are OPTIONAL**: Only generate test tasks if explicitly requested in the feature specification or if user requests TDD approach.

### Checklist Format (REQUIRED)

Every task MUST strictly follow this format:

```text
- [ ] [TaskID] [P?] [Story?] Description with file path
```

**Format Components**:

1. **Checkbox**: ALWAYS start with `- [ ]` (markdown checkbox)
2. **Task ID**: Sequential number (T001, T002, T003...) in execution order
3. **[P] marker**: Include ONLY if task is parallelizable (different files, no dependencies on incomplete tasks)
4. **[Story] label**: REQUIRED for user story phase tasks only

- Format: [US1], [US2], [US3], etc. (maps to user stories from spec.md)
- Setup phase: NO story label
- Foundational phase: NO story label
- User Story phases: MUST have story label
- Polish phase: NO story label

5. **Description**: Clear action with exact file path

**Examples**:

- ✅ CORRECT: `- [ ] T001 Create project structure per implementation plan`
- ✅ CORRECT: `- [ ] T005 [P] Implement authentication middleware in src/middleware/auth.py`
- ✅ CORRECT: `- [ ] T012 [P] [US1] Create User model in src/models/user.py`
- ✅ CORRECT: `- [ ] T014 [US1] Implement UserService in src/services/user_service.py`
- ❌ WRONG: `- [ ] Create User model` (missing ID and Story label)
- ❌ WRONG: `T001 [US1] Create model` (missing checkbox)
- ❌ WRONG: `- [ ] [US1] Create User model` (missing Task ID)
- ❌ WRONG: `- [ ] T001 [US1] Create model` (missing file path)

### Task Organization

1. **From User Stories (spec.md)** - PRIMARY ORGANIZATION:

- Each user story (P1, P2, P3...) gets its own phase
- Map all related components to their story:
  - Models needed for that story
  - Services needed for that story
  - Endpoints/UI needed for that story
  - If tests requested: Tests specific to that story
- Mark story dependencies (most stories should be independent)

2. **From Contracts**:

- Map each contract/endpoint → to the user story it serves
- If tests requested: Each contract → contract test task [P] before implementation in that story's phase

3. **From Data Model**:

- Map each entity to the user story(ies) that need it
- If entity serves multiple stories: Put in earliest story or Setup phase
- Relationships → service layer tasks in appropriate story phase

4. **From Setup/Infrastructure**:

- Shared infrastructure → Setup phase (Phase 1)
- Foundational/blocking tasks → Foundational phase (Phase 2)
- Story-specific setup → within that story's phase

### Phase Structure

- **Phase 1**: Setup (project initialization)
- **Phase 2**: Foundational (blocking prerequisites - MUST complete before user stories)
- **Phase 3+**: User Stories in priority order (P1, P2, P3...)
  - Within each story: Tests (if requested) → Models → Services → Endpoints → Integration
  - Each phase should be a complete, independently testable increment
- **Final Phase**: Polish & Cross-Cutting Concerns

## Key Rules

- Create ONLY tasks.md (single file)
- **CRITICAL**: Only create tasks.md file
  - DO NOT create any additional file like INDEX.md, ANALYSIS.md, or any other \*-SUMMARY.md files
