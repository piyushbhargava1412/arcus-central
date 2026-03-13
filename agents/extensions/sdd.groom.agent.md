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

## 5. File Naming Strategy

Determine appropriate filenames based on story content.

Rules:

* For a **single story**: generate a descriptive filename from the requirement
  * Example: `user-authentication.md`, `payment-processing.md`
* For **multiple stories**: generate unique descriptive filenames for each story
  * Derive from the story's narrative or main capability
  * Use kebab-case format
  * Examples: `user-registration.md`, `password-reset.md`, `session-management.md`

Naming conventions:

* Use lowercase
* Use hyphens to separate words
* Keep names concise but descriptive (2-4 words)
* Avoid generic names like `story-1.md` or `feature.md`

---

## 6. Output

**Apply Markdown Generation Skills** (see `skills/markdown-generation/SKILL.md`)

Produce the final story document(s).

Requirements:

* **If single story**: Create one Markdown file with the story content
* **If multiple stories**: Create **separate Markdown files** for each story
  * Each file should contain only one complete story
  * Use the naming strategy from step 5

Output rules:

* Only output structured stories
* Do not include explanations
* Do not include commentary
* Do not generate code
* Each file must follow the story template exactly

**Apply Markdown Validation Skills** (see `skills/markdown-validation/SKILL.md`) to ensure each story document has proper structure, no broken links, and consistent formatting.

Create the file(s) in `.apex/groom/` directory and confirm the creation with a brief summary listing the created files.

---

# Key Rules

* Generate **story documents only**
* Do **not generate code**
* Operate strictly within **single repository scope**
* Do **not include cross-repository logic**
* Do **not ask clarification questions**
* Do **not output content outside structured stories**
* Follow the **story template exactly**
* Create **separate files for each story** when multiple stories are generated
* Use **descriptive, kebab-case filenames** derived from story content

---
