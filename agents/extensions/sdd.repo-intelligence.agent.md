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

## Execution Flow

### 1. Confirm Output Paths

Ask the user to confirm where to write outputs. Default paths:

```
<repo-root>/repo_map.md
<repo-root>/repo_scope.md
```

If user specifies different paths, use those. Proceed once confirmed.

### 2. Load Templates

Read the templates that define the required structure:

- `.apex/templates/repo_map.template.md`
- `.apex/templates/repo_scope.template.md`

If templates aren't found via `.apex/`, check the current repo's `templates/` directory.

### 3. Scan Repository (Smart, Not Exhaustive)

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

### 4. Generate `repo_map.md`

Fill the `repo_map.template.md` structure with findings from the scan:

- **Overview**: 2-3 sentences about what this repo is
- **Directory Structure**: actual tree (depth 2-3)
- **Tech Stack**: with version + file path evidence
- **Entry Points**: main class, handler, CLI entry
- **Key Components**: controllers, services, handlers, repos — with file paths
- **Contracts & Schemas**: with format + file paths
- **Configuration**: key config files
- **Build & Run Commands**: discovered from build files
- **Observability**: logging, metrics, tracing evidence
- **Module / Package Map**: logical grouping
- **Confidence & Unknowns**: what was found, what wasn't, what needs human confirmation

Write to confirmed output path.

### 5. Generate `repo_scope.md`

Using the `repo_map.md` output + deeper analysis, fill the `repo_scope.template.md` structure:

- **Overview**: business domain context
- **Business Capabilities**: owned vs out-of-scope
- **Events**: produced/consumed with topic names, schema paths, handler paths
- **APIs**: exposed/consumed with methods, paths, spec references
- **Data Ownership**: entities, stores, data flow
- **Dependencies**: upstream (this repo depends on) / downstream (depends on this repo)
- **Non-Functional Constraints**: if documented or inferable
- **Confidence & Unknowns**: what was found, what wasn't, what needs human confirmation

Write to confirmed output path.

### 6. Report Completion

Output a concise summary to chat:

```
## Repo Intelligence Generated

✓ repo_map.md  → [path]
✓ repo_scope.md → [path]

### Confidence Summary
- Tech Stack: HIGH (found pom.xml with versions)
- Entry Points: HIGH (found @SpringBootApplication)
- Events: MEDIUM (found Kafka config but no schema files)
- APIs: HIGH (found OpenAPI spec at ...)
- Business Scope: LOW (no architecture docs found)

### Items Needing Human Confirmation
1. [item] — [reason]
2. [item] — [reason]
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

- **ALWAYS** confirm output paths before writing
- **ALWAYS** generate `repo_map.md` first, then `repo_scope.md`
- **ALWAYS** include the Confidence & Unknowns section in both outputs
- **NEVER** create files beyond `repo_map.md` and `repo_scope.md`
- **NEVER** modify existing code or configuration files
- **NEVER** run build commands or install dependencies
- **PREFER** tables over prose for structured data
- **CITE** file paths as evidence for every finding
