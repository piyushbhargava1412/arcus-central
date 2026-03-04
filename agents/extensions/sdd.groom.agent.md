---
description: Convert requirements into structured implementation-ready user stories for single repository context.
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

1. **Setup**: Receive the requirement text from user input.
   Set paths directly without running any commands:
  - `FEATURE_DIR = .apex/groom/`
  - Do not delete any existing files in the groom folder. Simply add a new file inside the groom folder with a name that reflects the requirement.
  - in that groom dir the .md file has to create
   - Extract core requirement concepts
   - Identify single repository scope
   - Do NOT process cross-repository logic
   - Validate requirement is scoped to single repository only

2. **Analyze requirement**: 
   - Parse user requirement description
   - Identify logical story boundaries
   - Determine if requirement splits into multiple stories or single story
   - Map requirement to repository context only

3. **Generate stories**: For each identified story:
   - Load `.apex/templates/stories/story-template.md` as strict format reference
   - Create comprehensive story following template structure
   - Fill ALL sections (no empty sections allowed)
   - Do NOT modify section names or order
   - Do NOT add extra commentary or sections
   - Do NOT include code blocks

4. **Story Splitting Decision**:
   - For complex features, automatically decompose into multiple independent, implementable stories.
   - Treat each logical action, workflow step, or AC scenario that can stand alone as a candidate for a separate story.
   - Avoid creating trivial stories (like handling validation errors); include these inside Acceptance Criteria only.
   - Ensure each story is independently testable and implementable.
   - For large features, aim for 2–5 stories per feature to maintain granularity.
   - Stories must remain cohesive; do not split if it breaks logical flow or dependencies.
5. **Output**: 
   - Generate single Markdown (.md) document
   - If multiple stories: all stories in same file with --- separator
   - Follow template format strictly
   - No explanatory text outside structured stories
   - Report: Output story document(s) to chat only

## Key Rules

- Create ONLY story document(s) - no code
- Operate within single repository context exclusively
- Do NOT include cross-repository logic
- Do NOT ask questions (make informed decisions)
- Do NOT request clarification
- Do NOT provide explanations outside stories
- Do NOT leave any section empty
- Do NOT remove any template sections
- Do NOT add extra sections
- Do NOT modify section names
- Do NOT generate code
- Follow template strictly
- Each story must follow exact format from story-template.md
- If requirement logically splits: create multiple stories in same file with --- separator
- Do NOT repeat section headings across stories

## Story Generation Rules

**Format Rules**:
- Each story must strictly follow template structure
- Section order MUST match template exactly
- Do NOT modify section names
- All sections MUST be filled (no empty sections)
- Do NOT include code blocks
- Do NOT add extra commentary

**Requirement Analysis**:
- Extract explicit requirements from input
- Make informed decisions for ambiguous aspects (do NOT ask questions)
- Identify test scenarios from requirement
- Map acceptance criteria to requirement intent
- Scope to single repository only

**Story Splitting Decision**:
- If requirement naturally separates into independent, testable units: create multiple stories
- If requirement is cohesive: create single story
- Each story must be independently implementable
- Place all stories in single output file with --- separator

**Content Rules**:
- Narrative: Standard "As a / I want / So that" format
- Context: Repository-specific details, background information
- Scope: Clear boundaries of what IS included
- Out of Scope: Clear boundaries of what IS NOT included
- Assumptions: Documented assumptions for unspecified details
- Tech Notes: Technology hints (framework, language references only, no implementation details)
- Test Plan: High-level testing approach
- Acceptance Criteria: BDD format (Given / When / Then)

## Story Output Format

```
---

Narrative:
As a ____
I / We want to ____
So that ____

Context:

Scope:

Out of Scope:

Assumptions:

Tech Notes:

Test Plan:

Acceptance Criteria:

Given ____
When ____
Then ____

---
```

Context for story generation: $ARGUMENTS

