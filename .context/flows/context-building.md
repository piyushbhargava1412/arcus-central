# Flow: Context Building

## Entry Points

- **Manual**: User runs agent (e.g., `/sdd.specify`) → agent calls `session-bootstrap` skill to load/refresh context
- **Bootstrap**: User invokes `sdd.context-builder` agent to build context from scratch (first-time setup)
- **Maintenance**: `context-drift-and-reconcile` skill detects stale context and refreshes

## Core Path

### 1. Context Initialization
- User (or CI/CD) needs to build baseline repository context
- Invokes context-building workflow:
  - Run `repository-context-builder` skill (foundation stage)
  - Run `flow-and-scope-discovery` skill (discovery stage)
  - Run `test-pattern-discovery` skill (foundation stage)

### 2. Repository Context Building (repository-context-builder Skill)
- **Input**: Repository root path, optional `.arcus-ignore` patterns
- **Processing**:
  - Traverse repository structure (respecting ignore patterns)
  - Extract evidence from:
    - Directory layout
    - Build files (pom.xml, package.json, build.gradle, etc.)
    - Source/test/config root locations
    - Entry point classes/functions
    - Tech stack signals
  - Analyze business domain from:
    - Controller/handler definitions
    - Event producers/consumers
    - Database entities
    - External API integrations
  - Assign confidence (HIGH/MEDIUM/LOW) to each finding
- **Outputs**:
  - `.context/repo_scope.md` (business scope, capabilities, dependencies, APIs, events)
  - `.context/repo_map.md` (technical topology, directory structure, tech stack, components)

### 3. Flow Discovery (flow-and-scope-discovery Skill)
- **Input**: `.context/repo_scope.md` (generated above), `.context/repo_map.md` (generated above)
- **Processing**:
  - Identify entry surfaces (controllers, listeners, schedulers)
  - Group related entry points into flows
  - For each flow: trace path from entry → service → repository/events
  - Capture scope (packages/modules involved)
  - Assign confidence
  - Ensure flows are narrow (one execution path, not a subsystem)
- **Outputs**:
  - `.context/flows/<flow-name>.md` (one file per flow)
  - Each flow file includes: entry points, core path, data touchpoints, integrations, scope, tests

### 4. Testing Pattern Discovery (test-pattern-discovery Skill)
- **Input**: Repository root, `.context/repo_scope.md`, `.context/repo_map.md`
- **Processing**:
  - Identify test root locations (unit, integration, contract tests)
  - Inspect representative test files to find:
    - Test frameworks used (JUnit, Jest, etc.)
    - Mocking/stubbing style (Mockito, Jest mocks, etc.)
    - Assertion style (AssertJ, Chai, etc.)
    - Fixture/builder/factory patterns
    - Spring test patterns (if applicable)
  - Capture canonical example test files
  - Assign confidence
- **Outputs**:
  - `.context/testing-patterns.md` (test frameworks, naming conventions, mocking style, canonical examples)

### 5. Context Persistence
- Ensure `.context/` directory exists
- Write all generated files:
  - `repo_scope.md`
  - `repo_map.md`
  - `flows/*.md` (one per flow)
  - `testing-patterns.md`
- If files exist: update them (do not duplicate)
- Commit context to git (recommended)

### 6. Context Loading (at Agent Runtime)
- When agent executes, `session-bootstrap` skill loads:
  - `.context/repo_scope.md` (if present)
  - `.context/repo_map.md` (if present)
  - `.context/flows/*.md` (all files if dir exists)
  - `.context/testing-patterns.md` (if present)
- If context missing: agent operates with degraded capability (may ask user for context)
- Agent applies context to guide specification, planning, analysis

### 7. Context Maintenance
- `context-drift-and-reconcile` skill periodically checks:
  - Are `.context/` files stale relative to recent code changes?
  - Do flows still match current codebase?
  - Is testing pattern still accurate?
- If drift detected: signal to refresh context (via `repository-context-builder` again)

## Data Touchpoints

| Data | Type | Direction | Purpose |
|------|------|-----------|---------|
| Repository files | Files | Repo (read) | Source structure to analyze |
| Build config files | Config | Repo (read) | pom.xml, package.json, etc. |
| Source code | Code | Repo (read) | Controllers, services, repositories, tests |
| Ignore patterns | Config | `.arcus-ignore` (read) | Paths to exclude from analysis |
| repo_scope.md | Markdown | `.context/` (write) | Repository business scope |
| repo_map.md | Markdown | `.context/` (write) | Repository technical topology |
| flows/*.md | Markdown | `.context/flows/` (write) | One file per flow |
| testing-patterns.md | Markdown | `.context/` (write) | Test writing conventions |
| .context-metadata | Metadata | `.context/` (optional write) | Timestamp, version of context generation |

## Integrations

- **Repository Analysis**: Reads `.arcus-ignore` to exclude paths
- **Git**: Reads file history (optional; for drift detection)
- **Templates**: Uses `repo_scope.template.md` and `repo_map.template.md` as structure guides
- **Agent System**: Generated context is loaded by `session-bootstrap` skill
- **Skill Registry**: May call other skills to enhance analysis (e.g., dependency-analysis)

## Scope

| Scope | Items |
|-------|-------|
| **Skills Used** | 3 foundation skills: repository-context-builder, flow-and-scope-discovery, test-pattern-discovery |
| **Context Files** | 5 types: repo_scope.md, repo_map.md, flows/*.md, testing-patterns.md, optional metadata |
| **Input Repositories** | Any codebase: Java, Node.js, Python, Go, C#, etc. (analysis is language-agnostic) |
| **Evidence Sources** | Directory structure, build files, entry point classes, test patterns (no git history required) |
| **Exclusions** | Does not infer business flows without code anchors; does not generate speculative documentation |

## Tests

- **Validation**: Verify generated context files conform to templates
- **Drift Detection**: Test context-drift-and-reconcile skill against known stale contexts
- **Evidence Quality**: Ensure all findings in context have code evidence (no speculative content)

## Verification

**commit**: Unknown (context building system; not tied to specific commit)  
**confidence**: HIGH

Evidence:
- `repository-context-builder` SKILL.md with explicit processing rules and output contract
- `flow-and-scope-discovery` SKILL.md with narrow flow definitions and evidence-based inference
- `test-pattern-discovery` SKILL.md with test root identification and canonical examples
- Template files: `repo_scope.template.md` and `repo_map.template.md` show expected structure

---

## Context Quality Standards

### High Confidence Evidence

- Directory structure clearly maps to business function (e.g., `/orders/` → orders service)
- Build files explicitly declare tech stack (pom.xml, package.json declare dependencies)
- Entry point classes are discoverable and named meaningfully (@Controller, @RestController, handler functions)
- Test files follow standard naming (XyzTest, XyzServiceTest)
- Flows trace complete paths from entry → service → repository/event

### Medium Confidence Evidence

- Tech stack inferred from common file locations (src/main/java → Java, src/test/)
- Flows partially traced (entry point found but some hops unclear)
- Testing patterns seen in limited examples
- Business domain inferred from class/method names

### Low Confidence Evidence (Omitted)

- Speculative flow groupings without clear orchestration path
- Tech stack inferred from naming alone (folder named "python" may not mean Python)
- Testing patterns seen in only one example
- Business capabilities inferred from directory names without code evidence
- Flows that span multiple codebases (ecosystem context required)

---

## Related Flows

- [Skill Delegation](skill-delegation.md) — How repository-context-builder and other context skills are called
- [Agent Execution](agent-execution.md) — How agents use loaded context
- [Framework Integration](framework-integration.md) — How target repos get set up to receive context files

