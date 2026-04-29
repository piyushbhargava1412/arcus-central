---
name: test-pattern-discovery
description: Analyze existing tests and persist shared repository test-writing conventions in .context/testing-patterns.md for downstream story and implementation work.
inputs:
  - repository_root
  - repo_scope
  - repo_map
outputs:
  - testing_patterns
---

# Test Pattern Discovery

## Purpose

Identify how tests are actually written in the repository and persist the shared testing conventions to:

- `.context/testing-patterns.md`

This artifact captures reusable repo-specific testing patterns for downstream story and implementation work.

## When To Use

- after repository context is built
- after major context refresh
- during baseline ARCUS initialization

## Non-Goals

Do not:
- generate story-specific test plans
- reconcile drift from git commits
- scan production code beyond what is needed to understand test patterns
- invent testing conventions that are not evidenced in the repository

## Inputs

- `repository_root`
- `repo_scope`
- `repo_map`

## Core Principle

Capture only recurring, evidence-backed test conventions that help future work follow the existing repository style.

## Processing Rules

### 1. Identify test roots

Use `repo_map` and repository structure to identify:
- unit test locations
- integration test locations
- contract or API test locations
- shared test utilities and fixtures

### 2. Inspect representative tests

Read a bounded but representative sample of test files to identify:
- test frameworks and libraries
- naming conventions
- test class structure
- mocking/stubbing style
- assertion style
- fixture/builder/factory usage
- Spring test styles
- database, messaging, or async testing patterns if evident

### 3. Identify recurring patterns

Capture only patterns that appear repeatedly or are clearly standard in the repo.

Prefer omission over weak inference.

### 4. Capture canonical examples

Record a small set of representative test files that future agents can mimic.

### 5. Assign confidence

- high: pattern clearly repeated across tests
- medium: pattern seen in limited but strong examples
- low: weak signal (prefer omission)

## Persistence Rules

1. Ensure directory exists:
    - `.context/`

2. Write file:
    - `.context/testing-patterns.md`

3. If file exists:
    - update it
    - do not duplicate

4. Keep content concise and evidence-backed.

## Output Contract

### testing_patterns

Persist a single markdown file at `.context/testing-patterns.md` containing:

- Test Frameworks
- Test Types and Locations
- Naming Conventions
- Mocking / Stubbing Style
- Assertion Style
- Test Data / Fixture Patterns
- Spring / Integration Test Patterns (if evident)
- Canonical Example Files
- Verification
    - commit
    - confidence

## Recommended Structure

```md
# Testing Patterns

## Test Frameworks
- ...

## Test Types and Locations
- ...

## Naming Conventions
- ...

## Mocking / Stubbing Style
- ...

## Assertion Style
- ...

## Test Data / Fixture Patterns
- ...

## Spring / Integration Test Patterns
- ...

## Canonical Example Files
- ...

## Verification
commit: <hash or unknown>
confidence: high | medium | low
```

## Validation Gates

- [ ] test roots identified
- [ ] recurring patterns evidenced from existing tests
- [ ] canonical examples included
- [ ] output written to `.context/testing-patterns.md`
- [ ] no invented conventions added

## Failure Modes

- MISSING_TESTS
- INSUFFICIENT_PATTERN_EVIDENCE
- OVER_GENERALIZATION

## Handoff

Used by:
- feature-context-pack-builder
- specify agent
- plan agent
- implement agent

Produces shared repository test-convention context only.
