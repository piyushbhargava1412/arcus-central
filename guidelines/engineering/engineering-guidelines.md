# Engineering Guidelines

> **Note**: These are generic best practice suggestions. The conventions and standards already established in this repository take precedence. Do not change existing patterns based on these guidelines unless the user explicitly requests it.

---

## Philosophy

Good engineering is not about following rules — it is about understanding why the rules exist and applying good judgment when they conflict. Write code as a form of communication. The primary audience for your code is the next engineer who reads it, not the compiler.

---

## Code Quality

- **Clarity over cleverness** — code that is obvious is better than code that is impressive. If you need to explain what a piece of code does, it should probably be simpler
- **Small, focused units** — functions, classes, and modules should do one thing well. If you need "and" to describe what something does, it is doing too much
- **Meaningful names** — names should reveal intent. If a name needs a comment to explain it, the name should be improved instead
- **DRY** — avoid duplication, but do not over-abstract. Two similar things that change together should be abstracted; two similar things that change independently should not be forced together
- **YAGNI** — do not add functionality until it is actually needed. Speculative generality creates complexity without value
- **Low coupling, high cohesion** — things that change together should live together; things that are unrelated should be separated

---

## Design

- Apply SOLID principles as defaults, not rules — they exist to make code more maintainable and testable, not as ends in themselves
- Favour composition over inheritance — deep class hierarchies are hard to reason about, test, and change
- Depend on abstractions at module boundaries — makes it possible to change implementations without changing callers
- Prefer immutability — mutable shared state is the most common source of subtle bugs
- Fail fast — validate inputs at system boundaries; do not let bad data propagate inward
- Design for testability from the start — code that is hard to test is usually code with too many responsibilities or too many hidden dependencies

---

## Code Review

Code review is a collaborative learning exercise, not a gatekeeping ceremony.

- Review for correctness, clarity, and design — not just style
- Distinguish between blocking issues (correctness, security, design) and suggestions (style, preference)
- Leave reviews you would want to receive — specific, actionable, kind
- A design disagreement in review is a signal that the design conversation should have happened earlier — in the spec or plan stage
- Approve when you are satisfied, not when you are exhausted

---

## Documentation

- The best documentation is readable code — names, structure, and tests that explain intent
- Comment the **why**, not the **what** — the code already says what it does
- Outdated documentation is worse than no documentation — keep it close to the code it describes so it stays current
- Public APIs and interfaces should document their contract: inputs, outputs, errors, and side effects
- Architecture decisions should be recorded with their rationale — a decision with no recorded reasoning will be reversed or repeated

---

## Version Control

- Commit frequently — small, focused commits are easier to review, bisect, and revert
- Write commit messages that explain why the change was made, not just what changed
- Keep branches short-lived — long-lived branches accumulate conflicts and delay integration
- Merge to the main branch frequently — trunk-based development reduces integration risk
- Do not commit secrets, credentials, or environment-specific configuration — ever

---

## Continuous Integration

- Every commit should leave the codebase in a releasable state
- The build should be fast — a slow build is a tax on every developer every day
- Fix broken builds immediately — a broken main branch is a team problem, not an individual one
- Do not commit code that you know breaks tests — run them locally first

---

## Technical Debt

- Not all technical debt is bad — sometimes a shortcut is the right trade-off given time and risk constraints
- Make debt explicit — note it, track it, and pay it down deliberately rather than letting it accumulate silently
- Refactor incrementally — improve the code you are already touching rather than scheduling large rewrites
- A large rewrite is usually riskier than incremental improvement; prefer the latter unless the codebase is genuinely beyond repair
