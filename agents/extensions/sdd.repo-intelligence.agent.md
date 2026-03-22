---
description: Scan a repository and generate repo_map.md (technical topology) and repo_scope.md (ownership + interfaces) for onboarding and cross-repo reasoning.
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Purpose

Generate two repo-level intelligence artefacts that help SDD agents and engineers work accurately:

- **`repo_map.md`** — structural + technical map (repo anatomy: what's here, how it's organized)
- **`repo_scope.md`** — business + interface ownership summary (repo responsibility: what it owns, how it interacts)

**Rule of thumb:**

- `repo_map` helps a dev/agent **navigate code**
- `repo_scope` helps **grooming and cross-repo reasoning**

**Reusable Skills**: This agent leverages:

- `skills/repository-analysis/SKILL.md` - Repository scanning with .apex-ignore support
- `skills/markdown-generation/SKILL.md` - Format and structure markdown documents
- `skills/markdown-validation/SKILL.md` - Validate file paths, links, and markdown quality

## Operating Constraints

**CRITICAL - NO CODE IMPLEMENTATION**: This agent MUST NEVER implement, write, or generate any application code, regardless of user phrasing. This agent's sole purpose is to analyze repository structure and generate documentation.

**User Intent Interpretation**: When users say "implement" while using this agent, they mean "analyze and document the repository" — NOT "write code now." Code implementation occurs ONLY in the `/sdd.implement` agent after all preparatory phases are complete.

## Execution Flow

### 1. Output Paths

Write outputs to the `docs/` directory by default:

```
<repo-root>/docs/repo_map.md
<repo-root>/docs/repo_scope.md
```

Create the `docs/` directory if it doesn't exist. Do NOT ask the user for path confirmation — proceed immediately.

### 2. Load Templates

Read the templates that define the required structure:

- `.apex/templates/repo_map.template.md`
- `.apex/templates/repo_scope.template.md`

If templates aren't found via `.apex/`, check the current repo's `templates/` directory.

### 3. Scan Repository (Smart, Not Exhaustive)

**Apply Repository Analysis Skills** (see `skills/repository-analysis/SKILL.md`)

Do NOT read every file. Use a targeted scan strategy:

**Phase 3a — Directory structure:**

- List top-level directories (depth 2-3)
- Identify language/framework from file patterns

**Phase 3b — Build & config files (read these):**

- `pom.xml`, `build.gradle`, `package.json`, `Cargo.toml`, `go.mod`, `requirements.txt`, `Gemfile`, `*.csproj`
- `application.yml`, `application.properties`, `.env`, `docker-compose.yml`, `Dockerfile`
- `Makefile`, `Taskfile.yml`, `justfile`
- `terraform/`, `helm/`, `k8s/`

**Phase 3c — Entry points:**

- Search for `main` class/function, `@SpringBootApplication`, Lambda handler, CLI entry
- Check `src/main/`, `cmd/`, `app/`, `lib/`, `index.*`

**Phase 3d — Key components (scan directories, read selectively):**

- Controllers/routes: `**/controller/**`, `**/routes/**`, `**/handler/**`, `**/api/**`
- Services: `**/service/**`, `**/services/**`, `**/usecase/**`
- Repositories/DAOs: `**/repository/**`, `**/dao/**`, `**/store/**`
- Event handlers: `**/consumer/**`, `**/listener/**`, `**/subscriber/**`, `**/producer/**`, `**/publisher/**`
- Models/entities: `**/model/**`, `**/entity/**`, `**/domain/**`

**Phase 3e — Contracts & schemas:**

- OpenAPI: `**/openapi*`, `**/swagger*`, `**/*.yaml` (with openapi field), `**/api-docs/**`
- Avro: `**/*.avsc`
- Protobuf: `**/*.proto`
- JSON Schema: `**/*.schema.json`
- GraphQL: `**/*.graphql`, `**/*.gql`

**Phase 3f — Observability:**

- Search for logging config, metrics endpoints, tracing setup
- Check for `/actuator`, health check endpoints, Prometheus config

**Phase 3g — Existing docs:**

- `README.md`, `ARCHITECTURE.md`, `docs/`, `ADR/`, `CHANGELOG.md`

### 4. Generate `docs/repo_map.md`

**Apply Markdown Generation Skills** (see `skills/markdown-generation/SKILL.md`)

Fill the `repo_map.template.md` structure with findings from the scan:

- **Overview**: 2-3 sentences about what this repo is
- **Directory Structure**: actual tree (depth 2-3)
- **Tech Stack**: with version + file path evidence
- **Entry Points**: main class, handler, CLI entry
- **Key Components**: class names, types, file paths, purpose
- **Contracts & Schemas**: with format + file paths
- **Configuration**: key config files
- **Build & Run Commands**: discovered from build files
- **Observability**: logging, metrics, tracing evidence
- **Module / Package Map**: logical grouping
- **Scan Coverage**: brief status table of what was detected vs not found

**Apply Markdown Validation Skills** (see `skills/markdown-validation/SKILL.md`) to validate the generated document.

Write to `docs/repo_map.md`.

### 5. Generate `docs/repo_scope.md`

**Apply Markdown Generation Skills** (see `skills/markdown-generation/SKILL.md`)

Using the `repo_map.md` output + deeper analysis, fill the `repo_scope.template.md` structure:

- **Overview**: business domain context (NOT a repeat of repo_map overview — focus on domain, users, business role)
- **Business Capabilities**: owned vs out-of-scope
- **Events**: produced/consumed with topic names, schema paths, handler paths
- **APIs**: exposed/consumed with methods, paths, spec references
- **Data Ownership**: entities, stores, data flow
- **Dependencies**: upstream (this repo depends on) / downstream (depends on this repo)
- **Non-Functional Constraints**: if documented or inferable
- **Confidence & Unknowns**: the **single source of truth** for confidence analysis across both files

**Apply Markdown Validation Skills** (see `skills/markdown-validation/SKILL.md`) to validate the generated document.

Write to `docs/repo_scope.md`.

### 5.5. Prompt Confirmation Questions to User

After generating both files, you will have identified items under "Needs Human Confirmation" in `docs/repo_scope.md`.

**You MUST prompt these questions to the user interactively in the chat.** Do not just list them in the file and move on.

Procedure:

1. Present ALL confirmation questions to the user in a numbered list in the chat
2. Ask the user to answer each one (they can answer all at once or say "skip" for any)
3. For each answer received, update the **Needs Human Confirmation** table in `docs/repo_scope.md`:
   - Set the **Answer** column to the user's response
   - Set the **Status** column to `✅ Confirmed`
4. For any unanswered/skipped items, keep status as `⏳ Pending`
5. Save the updated `docs/repo_scope.md`

Example interaction:

```
I've identified the following items that need your confirmation:

1. **Business scope expansion** — Is this repo intended to remain console-only or evolve to REST API?
2. **Persistence requirements** — Should data persist across restarts?
3. **Multi-user support** — Is concurrent access planned?

Please provide answers for each (you can skip any with "skip"):
```

After receiving answers, update the table in `docs/repo_scope.md`:

```markdown
| #   | Question                                             | Answer                          | Status       |
| --- | ---------------------------------------------------- | ------------------------------- | ------------ |
| 1   | Business scope expansion — console-only or REST API? | "Will evolve to REST API in Q2" | ✅ Confirmed |
| 2   | Persistence requirements — should data persist?      | "Yes, PostgreSQL planned"       | ✅ Confirmed |
| 3   | Multi-user support — concurrent access planned?      | skip                            | ⏳ Pending   |
```

### 6. Report Completion

Output a concise summary to chat:

```
## Repo Intelligence Generated

✓ docs/repo_map.md  → [path] (technical topology)
✓ docs/repo_scope.md → [path] (business ownership + confirmed answers)

### Confidence Summary
- Tech Stack: HIGH (found pom.xml with versions)
- Entry Points: HIGH (found @SpringBootApplication)
- Events: MEDIUM (found Kafka config but no schema files)
- APIs: HIGH (found OpenAPI spec at ...)
- Business Scope: LOW (no architecture docs found)

### Human Confirmation
- X of Y questions confirmed ✅
- Z questions still pending ⏳
```

## Behavioral Rules

**Apply Repository Analysis Skills** (see `skills/repository-analysis/SKILL.md`) for ignore pattern handling.

**Output Generation:**

- **ALWAYS** write outputs to `docs/` directory (create it if needed) — do NOT ask for path confirmation
- **ALWAYS** generate `repo_map.md` first, then `repo_scope.md`
- **ALWAYS** prompt the user with confirmation questions after generating both files — do NOT silently list them
- **ALWAYS** record user's answers back into `docs/repo_scope.md` before reporting completion
- **ALWAYS** keep `repo_map.md` technical-only and `repo_scope.md` business-only — zero content overlap
- **NEVER** put Confidence & Unknowns in `repo_map.md` — that section lives only in `repo_scope.md`
- **NEVER** repeat tech stack, directory tree, build commands, or test structure in `repo_scope.md`
- **NEVER** list build dependencies (JUnit, AssertJ, etc.) as "upstream dependencies" in `repo_scope.md`
- **NEVER** add sections not in the template (e.g., "Sample Data", "Test Structure", "CI/CD" as separate sections)
- **NEVER** create files beyond `repo_map.md` and `repo_scope.md`
- **NEVER** modify existing code or configuration files
- **NEVER** run build commands or install dependencies
- **PREFER** tables over prose for structured data
- **CITE** file paths as evidence for every finding
