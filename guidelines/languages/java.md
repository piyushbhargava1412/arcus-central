# Java — Best Practice Guidelines

> **Note**: These are generic best practice suggestions. The conventions, tooling, and structure already established in this repository take precedence. Do not change existing patterns based on these guidelines unless the user explicitly requests it.

---

## Naming

- Name classes after what they **are**, not what they do (`OrderRepository`, not `OrderDataHandler`)
- Name methods with verb phrases that describe what they do (`findById`, `calculateTotal`)
- Boolean methods should read as assertions (`isActive`, `hasExpired`, `canProcess`)
- Avoid abbreviations — prefer `customerId` over `cid`, `retryCount` over `n`
- If a name needs a comment to explain it, the name should be improved instead

---

## Design

- Favour composition over inheritance — deep class hierarchies are hard to reason about and test
- Program to interfaces, not implementations — depend on abstractions at module boundaries
- Prefer immutable objects — make fields `final` unless mutation is required
- Apply the Single Responsibility Principle — a class that does too many things is hard to test and change
- Avoid primitive obsession — wrap meaningful domain concepts in value objects (`CustomerId`, `Money`)
- Tell objects what to do rather than querying their state and deciding externally

---

## Methods

- A method should do one thing
- Avoid boolean flag parameters — they signal a method doing two things
- Return early to avoid deep nesting — handle guard clauses at the top
- Never return `null` for collections — return an empty collection instead
- Prefer `Optional<T>` to signal the intentional absence of a value in a public API

---

## Error Handling

- Catch specific exceptions — not bare `Exception` unless there is a clear reason
- Provide error messages that include the offending value: `"Order not found: " + orderId`
- Never swallow exceptions silently — at minimum log with meaningful context
- Wrap third-party exceptions in domain exceptions at integration boundaries

---

## Testing

- Tests should describe behaviour, not implementation — name them accordingly
- One logical assertion per test — a test that checks many things is hard to diagnose when it fails
- Mock at system boundaries — not internal collaborators
- A test that is hard to write is often a signal that the design needs improvement

---

## General

- Keep dependencies minimal — each dependency is a maintenance and security liability
- Run dependency vulnerability scanning regularly
- Log with a structured logger using parameterised messages — not string concatenation
- Never log sensitive data — passwords, tokens, PII
