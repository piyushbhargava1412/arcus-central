--- 
description: Convert requirements into structured implementation-ready user stories for a single repository context.
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

---

**Reusable Skills**: This agent leverages:
- `skills/markdown-generation/SKILL.md` - Format and structure markdown documents
- `skills/markdown-validation/SKILL.md` - Validate markdown quality and structure

# Groom Agent Workflow

## 1. Setup

Receive the requirement text from user input and prepare the grooming workspace.

Set paths directly (do not execute commands):

* `FEATURE_DIR = .apex/groom/`

Rules:

* Do **NOT** delete any existing files in the groom directory.
* Create a new `.md` file inside `.apex/groom/` with a filename derived from the requirement.
* Operate strictly within the current repository context.

---

## 2. Requirement Analysis

Analyze the provided requirement and determine how it should be represented as user stories.

Tasks:

* Parse the requirement description
* Identify the primary goal of the feature
* Determine logical story boundaries
* Detect whether the requirement should produce:

  * a **single story**, or
  * **multiple independent stories**

Constraints:

* Operate **only within the current repository**
* Ignore cross-repository considerations
* Make informed decisions without asking follow-up questions

---

## 3. Story Generation

Generate stories based on the analyzed requirement.

Rules:

* Use the template located at
  `.apex/templates/stories/story-template.md`
* Follow the template **exactly**
* Fill **all template sections**
* Do **not modify section names or structure**

Story generation guidelines are provided by the **story-generation skill**.

---

## 4. Story Splitting Decision

Determine whether the requirement should be split into multiple stories.

Guidelines:

* Split stories when the feature contains **multiple independent capabilities**
* Ensure each story is:

  * independently implementable
  * logically cohesive
  * testable

Avoid:

* creating trivial stories for small validations or edge cases
* splitting stories if it breaks the logical feature flow

Typical decomposition:

* Complex feature → **2–5 stories**
* Simple feature → **single story**

---

## 5. Output

**Apply Markdown Generation Skills** (see `skills/markdown-generation/SKILL.md`)

Produce the final story document.

Requirements:

* Generate a **single Markdown document**
* If multiple stories are created:

  * place them in the **same file**
  * separate stories using `---`

Output rules:

* Only output structured stories
* Do not include explanations
* Do not include commentary
* Do not generate code

**Apply Markdown Validation Skills** (see `skills/markdown-validation/SKILL.md`) to ensure the story document has proper structure, no broken links, and consistent formatting.

Return the story document content directly in the response.

---

# Key Rules

* Generate **story documents only**
* Do **not generate code**
* Operate strictly within **single repository scope**
* Do **not include cross-repository logic**
* Do **not ask clarification questions**
* Do **not output content outside structured stories**
* Follow the **story template exactly**
* Story generation logic is handled by the **story-generation skill**

---
