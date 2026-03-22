```skill
name: repository-analysis
description: Repository analysis capabilities including ignore pattern processing, structure analysis, and codebase classification.
inputs:
  - repository_root
  - analysis_scope
outputs:
  - repository_model
  - analysis_results
```

# Repository Analysis

## Purpose

Analyze repository structure, respect ignore patterns, and classify codebases. Used by instructions and repo-intelligence agents.

## Inputs

- `repository_root`: root path of repository to analyze
- `analysis_scope`: what aspects to analyze (structure, tech stack, features)

## Processing Rules

1. Check for `.apex-ignore` file and parse patterns
2. Apply exclusion filters to analysis
3. Traverse repository structure respecting ignore patterns
4. Identify modules, architecture patterns, technology stack
5. Extract implementation details from actual code (not assumptions)
6. Build evidence-backed analysis with file path citations

## Output Contract

- Must return:
  - repository model with structure and components
  - analysis results with confidence levels and evidence
- Must not return:
  - ignored file references
  - speculative/assumed content

## Validation Gates

- [ ] All ignore patterns respected
- [ ] Only actual implementation documented
- [ ] Evidence cited for findings
- [ ] No assumptions in output

## Failure Modes

- `MISSING_ROOT`: stop and report unresolved repository root
- `PARSE_ERROR`: stop and report malformed content

