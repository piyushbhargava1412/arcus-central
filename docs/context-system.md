# Context System: Repository-Aware Agent Architecture

## The Most Expensive Question

The highest token cost in LLM-powered development is answering: "What's the structure of this codebase?"

Most frameworks solve this by **reading the entire codebase on every request**. This is:
- **Expensive**: Thousands of tokens per invocation on medium+ codebases
- **Noisy**: 90% of the code is irrelevant to the current task
- **Inconsistent**: Token limits force truncation; agents hallucinate about code they didn't see

ARCUS solves this with **context engineering**: building repository-level intelligence once, maintaining it incrementally, and feeding only what's relevant to each agent.

## Two-Level Context Hierarchy

### Level 1: Shared Context (`.context/`)

Built once per repository, updated incrementally by detecting file changes via git diff.

| Artifact | Purpose | Scope |
|----------|---------|-------|
| `repo_scope.md` | Business capabilities, components, integration model | Repository-wide |
| `repo_map.md` | Technical topology: tech stack, architectural layers, key files | Repository-wide |
| `flows/*.md` | Execution flows: payment processing, auth, notification, etc. | Per-domain |
| `testing-patterns.md` | How tests are structured in this repo: unit/integration/e2e strategy | Repository-wide |

**Why this split?**
- `repo_scope.md` and `repo_map.md` change infrequently (architecture is stable)
- `flows/*.md` changes only when the corresponding domain changes (payment flow updated → only `flows/payment.md` refreshed)
- `testing-patterns.md` changes rarely (test infrastructure is stable)

**Update strategy:**
When a new feature begins, the system computes:
```
git diff <verification-commit>..HEAD
```
This identifies exactly which files changed. Only the corresponding context artifacts are refreshed. A feature touching 3 files refreshes 3 flow files and possibly `repo_map.md`. Not everything.

**Verification commits:**
Each context artifact records the git commit hash at which it was last built:
```yaml
arcus-context-meta:
  built-at-commit: abc123def456
  built-by: sdd.context-builder
  built-at-timestamp: 2026-05-07T14:23:00Z
```

This enables drift detection: if the current commit is far ahead of the verification commit, the context is stale and should be refreshed.

### Level 2: Story Context (`context-pack.md`)

When a story is being worked on, an intelligent extract is built once and reused by all agents.

**What's included in a context-pack:**
- Story scope (user stories, acceptance criteria)
- Affected flows (only the flows this story touches)
- Affected components (only the components this story modifies)
- Affected files and directories
- Relevant testing patterns
- Relevant guardrails from `.github/copilot-instructions.md`

**Size:** Context-packs are typically **300-800 tokens** depending on feature complexity.

**Contrast:**
- Full codebase scan: 5,000-15,000+ tokens
- Context-pack: 300-800 tokens
- Information density: Higher (irrelevant code filtered out)

**Reuse:** The same context-pack is used by all agents working on this story:
- `sdd.specify` reads it when generating the spec
- `sdd.plan` reads it when designing architecture
- `sdd.tasks` reads it when decomposing work
- `sdd.implement` reads it when writing code

No redundant codebase scanning. One build, many uses.

## Drift Detection and Reconciliation

**The problem:** As a repository evolves, the `.context/` becomes stale. Changes in one domain (payment service refactoring) don't affect another domain (auth flows), but `.context/` doesn't know this automatically.

**The solution:**

When a story is completed, the post-implementation analysis phase runs `context-refresh`, which:

1. Computes `git diff <last-verification-commit>..HEAD` for the current story
2. Identifies which context artifacts are affected by those changes
3. For each affected artifact, performs incremental refresh (not full rebuild)
4. Records the new verification commit
5. Commits `.context/` changes with a message like: `context: refresh repo_map and flows/payment after Payment v2 implementation`

**Result:** Context drift is bounded. Over time, `.context/` stays synchronized with implementation.

## Selective Loading

Agents don't load all of `.context/`. They load selectively:

### For Specification Phase:
- Full `repo_scope.md` (understand business constraints)
- Relevant sections of `repo_map.md` (understand tech stack)
- Affected `flows/*.md` (understand the domain)
- Full `testing-patterns.md` (know how to write testable specs)

### For Planning Phase:
- Full `repo_map.md` (architectural decisions)
- Affected `flows/*.md` (understand dependencies)
- Relevant sections of guidelines (architecture patterns)

### For Implementation Phase:
- Affected `flows/*.md` (know what domain logic looks like)
- Relevant `testing-patterns.md` sections
- Full guidelines (coding standards, testing standards)

**This selectivity is crucial** because:
- It keeps token usage proportional to task scope
- It reduces hallucination (agents don't see conflicting code from unrelated domains)
- It enforces focus (agents implement what's relevant, not cargo-cult patterns from other parts of the codebase)

## Artifact Lineage

Every generated artifact (spec.md, plan.md, tasks.md) records its context:

```yaml
arcus-artifact-meta:
  artifact-id: PAYMENT-AUTH-001
  template-version: 1.2.0
  generated-by: sdd.specify
  generated-at-timestamp: 2026-05-07T10:15:00Z
  context-pack-version: 1
  context-pack-commit: abc123def456
  arcus-version: 0.8.0
```

This lineage enables:
- **Traceability**: Which agents generated which artifacts, when, from which context
- **Regeneration**: If template version changes, the artifact can be flagged for regeneration
- **Audit**: Historical record of what context was available when the decision was made

## Integration with Copilot Instructions

Each repository has `.github/copilot-instructions.md` generated from `.context/repo_scope.md` and `.context/repo_map.md`. This ensures:

- All agents follow the same guardrails
- Guardrails are derived from actual repository structure (not abstract guidelines)
- As repository evolves, guardrails are automatically updated

Example that gets generated:
```markdown
## Repository: Payment Service

### Business Scope
This repository handles payment processing, refunds, and billing.
Key integrations: Stripe, DynamoDB, SNS notifications.

### Architecture Constraints
- All state changes must be persisted to DynamoDB
- All external calls must be wrapped in circuit breakers
- Auth is delegated to external identity service
- Errors must be logged to CloudWatch

### Testing Strategy
- Unit tests live in __tests__ directories (Jest)
- Integration tests live in tests/integration
- E2E tests are in tests/e2e (Playwright)
- All tests run on every commit
```

Agents reading this guidance will generate code that respects these constraints automatically.

## Incremental Refresh Strategy

The key efficiency insight: **most changes are local**.

When you update the payment service:
- `flows/payment.md` changes
- `repo_map.md` might change (if new components were added)
- `testing-patterns.md` does NOT change
- `.context/` does NOT require full rebuild

This is computed via:
```bash
git diff <last-verification-commit>..HEAD --name-only \
  | xargs -I {} basename {} \
  | sort -u
```

If the output maps to "payment/", then only `flows/payment.md` is refreshed.

For a 500-file repository with 10 major domains:
- Full context rebuild: 30-60 seconds
- Incremental refresh of one domain: 3-5 seconds
- Context remains synchronized with implementation

## Verification Commits in Action

Example workflow:

```
1. Feature starts: PAYMENT-AUTH-001
   Payment authorization implementation
   verification-commit from last story: abc123 (3 weeks ago)

2. `sdd.specify` runs:
   → reads .context/ (still valid from abc123)
   → generates spec.md

3. Feature is implemented over 2 days:
   → 47 commits
   → payment service refactored
   → auth service updated

4. Post-implementation analysis runs:
   → git diff abc123..HEAD --name-only
   → Finds: payment/*.java, auth/*.java, tests/integration/payment-auth-test.sh
   → Marks: flows/payment.md, flows/auth.md, testing-patterns.md for refresh

5. Context is refreshed:
   → flows/payment.md regenerated (payment service code changed)
   → flows/auth.md regenerated (auth service code changed)
   → testing-patterns.md refreshed (new test files detected)
   → repo_map.md checked (no structural changes)

6. New verification-commit set: def4567890 (the merge commit)

7. Next feature starts:
   → Uses .context/ from def4567890
   → Context is current ✓
```

---

## See Also

- [Architecture](architecture.md) — Why ARCUS is designed this way
- [Philosophy](philosophy.md) — Why context matters to SDD
- [Glossary](glossary.md) — Definitions of context-related terms

