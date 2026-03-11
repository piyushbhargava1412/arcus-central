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

**Deduplication rules for `repo_map.md`** — this file owns **technical structure only**:
- Do NOT include business capabilities, event ownership, API ownership tables, or dependency direction — those belong exclusively in `repo_scope.md`
- Do NOT include a "Confidence & Unknowns" section — that lives only in `repo_scope.md`
- Do NOT list service method signatures or internal API tables — `repo_scope.md` owns interface details
- Do NOT repeat library versions as "upstream dependencies" — tech stack table is sufficient here
- Do NOT add a "Test Structure" section — test files are visible in the directory tree and module map already

Write to `docs/repo_map.md`.

### 5. Generate `docs/repo_scope.md`

Using the `repo_map.md` output + deeper analysis, fill the `repo_scope.template.md` structure:

- **Overview**: business domain context (NOT a repeat of repo_map overview — focus on domain, users, business role)
- **Business Capabilities**: owned vs out-of-scope
- **Events**: produced/consumed with topic names, schema paths, handler paths
- **APIs**: exposed/consumed with methods, paths, spec references
- **Data Ownership**: entities, stores, data flow
- **Dependencies**: upstream (this repo depends on) / downstream (depends on this repo)
- **Non-Functional Constraints**: if documented or inferable
- **Confidence & Unknowns**: the **single source of truth** for confidence analysis across both files

**Deduplication rules for `repo_scope.md`** — this file owns **business responsibility and interfaces only**:
- Do NOT repeat the tech stack table — reference `repo_map.md` instead
- Do NOT repeat the directory tree or module package map
- Do NOT repeat build commands or observability details
- Do NOT list "External Libraries" as upstream dependencies — those are build dependencies in `repo_map.md`'s tech stack. Upstream dependencies here means **runtime service dependencies** (APIs, databases, message brokers this repo calls)
- Do NOT add a "Sample Data / Test Entities" section — that's test implementation detail belonging to code, not business scope

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
| # | Question | Answer | Status |
|---|----------|--------|--------|
| 1 | Business scope expansion — console-only or REST API? | "Will evolve to REST API in Q2" | ✅ Confirmed |
| 2 | Persistence requirements — should data persist? | "Yes, PostgreSQL planned" | ✅ Confirmed |
| 3 | Multi-user support — concurrent access planned? | skip | ⏳ Pending |
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

## Guardrails

- **No hallucination**: If event schemas or APIs aren't found, write `"Not detected. Checked: [list of directories/files searched]"` — NEVER invent them
- **File path evidence**: Always cite the file path where something was found (e.g., "OpenAPI spec found at `src/main/resources/openapi.yaml`")
- **Concise**: No essay-style documentation. Tables over paragraphs. Bullet points over prose.
- **Deterministic**: Running twice on the same repo should produce the same structure (content may vary if repo changed)
- **Template compliance**: Output MUST follow template headings/sections exactly — do not add or remove sections
- **Smart scanning**: Don't read every file. Target build files, config, directory listings, and key code directories.
- **Unknowns are OK**: It's better to say "unknown" with what was checked than to guess

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
