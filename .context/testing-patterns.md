# Testing Patterns: ARCUS Central

<!-- arcus-context-meta
verification-commit: cc8d06ae9d0ee4b6a897ab41851e297f4df63e9e
generated-at: 2026-05-23T12:11:28Z
confidence: low
-->

---

## Summary

ARCUS Central is a Bash/Markdown framework repository. No formal automated test suite was found for the main framework components (agents, skills, templates, guidelines, integration scripts). Testing of distributed framework behavior occurs in target repositories, not here.

## Test Framework

None formally configured. No `Makefile`, `package.json`, `pytest.ini`, or test runner config found at repository root.

## Test Locations

| Location                                      | Type               | Notes                                      |
|-----------------------------------------------|--------------------|--------------------------------------------|
| `.pytest_cache/`                              | pytest cache       | Present from ad-hoc Python script invocation; no test files found |

## Observed Validation Patterns

### Manual Integration Validation (medium confidence)

- Integration is validated manually by inspecting:
  - Symlink presence in `.arcus/`
  - File presence in `.github/agents/`, `.github/prompts/`, `.github/skills/`
  - `chmod 444` on copied files
  - `.arcus-metadata.json` content
- No automated integration test found

### Agent/Skill Quality Gates (high confidence — framework-level)

- Each agent defines internal quality gates (pass/fail checks) for its output artifacts
- The `quality-gates` skill provides deterministic artifact validation (spec, plan, tasks)
- These are runtime checks within the SDD workflow, not automated test runs

## No Test Patterns Found For

- Bash integration scripts (`integrate.sh`, `install-cli.sh`, `uninstall.sh`)
- Markdown template validity
- Agent definition structure compliance
- Guidelines formatting

## Recommendation for Future Work

If automated testing is added, likely patterns would be:
- Bash-based integration tests using `bats` (Bash Automated Testing System)
- YAML/Markdown linting (e.g., `markdownlint`, `yamllint`)
- Python `pytest` for skill validation helpers
