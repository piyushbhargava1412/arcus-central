# Testing Patterns

**Generated**: April 29, 2026  
**Source**: Framework structure analysis  
**Confidence**: HIGH

---

**Note**: Repository refreshed 2026-05-02 to reflect newly added extension agent `sdd.close`. Flow discovery added `story-closure` flow under `.context/flows/` and context/bootstrap artifacts were refreshed.

## Test Frameworks

| Framework | Purpose | Evidence |
|-----------|---------|----------|
| **Quality Gates** | Validate artifact readiness | `skills/quality-gates/SKILL.md` |
| **Markdown Validation** | Check format compliance | `skills/markdown-validation/SKILL.md` |
| **Artifact Modeling** | Ensure data structure integrity | `skills/artifact-modeling/SKILL.md` |
| **Manual Integration** | End-to-end workflow testing | No example repositories detected in this repository; run integration scenarios against a target repository |

---

## Test Types and Locations

### 1. Skill Quality Gates (Internal Validation)

**Location**: `skills/quality-gates/SKILL.md`  
**Type**: Validation gates within skill execution  
**Trigger**: Every skill execution includes validation checkpoints

Each skill implements validation gates before returning results:

| Gate | Purpose | Example |
|------|---------|---------|
| **Evidence Quality** | Ensure inferences are code-backed | repository-context-builder checks for directory structure, build files |
| **Structure Conformance** | Verify output matches template | spec-authoring output must match `spec-template.md` structure |
| **Completeness** | Check all required fields populated | repo_scope.md must have Overview, Capabilities, Dependencies |
| **Confidence Assignment** | All findings labeled HIGH/MEDIUM/LOW | Every inferred item in repo_scope.md has confidence |

**Pattern**: Every skill definition (SKILL.md) includes a "Validation Gates" section.

### 2. Markdown Validation

**Location**: `skills/markdown-validation/SKILL.md`  
**Type**: Format and structure checking  
**Trigger**: After artifact generation, before handoff

Validates:
- Markdown syntax (headers, lists, tables, code blocks)
- Template conformance (required sections present)
- Cross-reference validity (links to other docs)
- Asset references (images, files exist)

**Pattern**: Generated artifacts pass markdown validation before being written to disk.

### 3. Framework Integration Tests

**Location**: No packaged example repos detected in this repository.  
**Type**: End-to-end workflow (manual)  
**Manual**: Run integration scenarios by installing the CLI and executing `arcus-integrate` against a target repository (a local test repo or an intentionally prepared example repository).

**Test scenario (recommended)**:
1. Checkout this repository (`bigfin_arcus-central`) locally
2. Prepare a target repository (can be an empty directory initialized with git) to act as the integration target
3. From the framework repo, run `./install-cli.sh` or invoke `./integrate.sh` with the target repo path
4. In the target repo, open the Copilot agent picker and invoke `/sdd.specify` with a feature description
5. Verify generated `spec.md`, `plan.md`, and `tasks.md` appear under `.arcus/specs/<ID>/` and are well-formed
6. Verify `.context/` files were used by agents and updated as necessary (or generated if missing)

**Coverage**:
- Framework integration (`arcus-integrate` command)
- Agent discovery (Copilot can see `/sdd.specify` etc.)
- Context loading (`.context/repo_scope.md` loaded)
- Artifact generation (spec.md, plan.md, tasks.md created)
- Template compliance (artifacts match structure)

---

## Naming Conventions

### Agent Names

| Pattern | Purpose | Example |
|---------|---------|---------|
| `sdd.<action>.agent.md` | Core agents | `sdd.specify.agent.md`, `sdd.plan.agent.md` |
| `sdd.<action>-<modifier>.agent.md` | Extension agents | `sdd.groom-story.agent.md` |

---

## Quality Gate Patterns

### Spec Readiness Quality Gate

Checks specification before handoff:

```
✅ Overview present and clear
✅ Requirements are specific, testable
✅ No conflicting requirements
✅ Edge cases identified
✅ Dependencies mapped
✅ Entry points clear
❌ FAIL: Ambiguity in requirement #3
```

### Code Generation Quality Gate

Validates task implementation:

```
✅ All requirements implemented
✅ Tests pass (if provided)
✅ Code follows style guidelines
✅ No security issues detected
❌ WARN: Missing edge case handling
```

### Artifact Conformance Quality Gate

Ensures output matches template:

```
✅ Markdown syntax valid
✅ All required sections present
✅ Links resolve correctly
✅ Tables well-formed
❌ FAIL: Missing "Scope" section
```

---

## Test Data / Fixture Patterns

### Template Fixtures

All templates in `templates/` serve as both specification and test fixture:

- `spec-template.md` → spec artifacts must match this structure
- `plan-template.md` → plan artifacts must match this structure
- `repo_scope.template.md` → generated context must conform

**Testing Pattern**: Generate artifact → run markdown-validation → compare structure vs template

---

## Assertion Style

### Confidence-Based Assertions

All context generation findings are asserted with confidence levels:

```markdown
Finding: "Repository owns OrderService"
Confidence: HIGH
Evidence: "src/main/java/com/example/service/OrderService.java"

Finding: "Uses Spring Boot"
Confidence: HIGH
Evidence: "pom.xml declares spring-boot-starter-web"

Finding: "May use Kafka"
Confidence: MEDIUM
Evidence: "Folder /kafka/ exists but no references in main code"

Finding: "Business model unclear"
Confidence: LOW
Evidence: "Service name is generic; ambiguous business purpose"
→ OMIT (too weak to include in context)
```

### Validation Assertions

Quality gates assert artifact readiness:

```markdown
Assert: "Specification has no ambiguous language"
  - Search for: TBD, unclear, TK, ??, TBD
  - Pass if: None found
  - Fail if: 3+ instances

Assert: "Spec references identified flows"
  - For each flow in .context/flows/*.md
  - Verify: ≥1 reference in spec.md
  - Warn if: Flow mentioned but not clearly tied to story
```

---

## Verification

| Aspect | Confidence | Evidence |
|--------|-----------|----------|
| Quality Gates Pattern | HIGH | Every SKILL.md includes "Validation Gates" section |
| Markdown Validation Pattern | HIGH | `skills/markdown-validation/SKILL.md` explicitly defined |
| Artifact Conformance Pattern | HIGH | Templates in `templates/` define expected structure for all artifacts |
| Confidence-Based Assertions | HIGH | All skill definitions (e.g., `repository-context-builder`) require confidence levels |

---

## Non-Patterns (Notably Absent)

- ❌ No unit test framework detected (framework is definition-based, not code-based)
- ❌ No CI/CD test pipelines detected (validation happens via quality gates within skills)
- ❌ No mock test data files in repo
- ❌ No test assertion libraries (validation is implicit in markdown/markdown-validation skill)

---

## See Also

- [repo_scope.md](repo_scope.md) — Business ownership and constraints
- [repo_map.md](repo_map.md) — Technical structure and components
- [flows/context-bootstrap.md](flows/context-bootstrap.md) — Testing patterns are discovered and recorded by `test-pattern-discovery` skill

