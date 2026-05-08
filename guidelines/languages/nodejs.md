# Node.js / TypeScript — Best Practice Guidelines

> **Note**: These are generic best practice suggestions. The conventions, tooling, and structure already established in this repository take precedence. Do not change existing patterns based on these guidelines unless the user explicitly requests it.

---

## TypeScript

- Enable `strict: true` — it catches entire classes of bugs at compile time
- Avoid `any` — use `unknown` and narrow explicitly where the type is genuinely uncertain
- Prefer `interface` for object shapes that may be extended; `type` for unions, intersections, and aliases
- Use `readonly` on properties that should not be mutated after construction
- Model domain concepts as named types — `type CustomerId = string` over bare `string` throughout

---

## Naming

- `camelCase` for variables and functions; `PascalCase` for classes, interfaces, and types; `SCREAMING_SNAKE_CASE` for constants
- Functions named with verbs: `calculateTotal()`, `findOrderById()`
- Boolean variables and functions as assertions: `isActive`, `hasExpired`, `canProcess()`
- Event handlers prefixed with `on` or `handle`: `onOrderPlaced`, `handlePaymentFailed`
- Avoid abbreviations — `customerId` not `custId`

---

## Functions

- Prefer `async/await` over raw Promise chains — they read sequentially and handle errors more cleanly
- A function should do one thing
- Avoid boolean flag parameters — they signal a function doing two things
- Return early — guard clauses at the top, happy path flows naturally below
- Use `Promise.all()` for independent concurrent operations — not sequential `await` in a loop

---

## Design

- Pass dependencies explicitly rather than importing singletons — makes testing and reasoning easier
- Keep business logic free of framework and infrastructure imports — inject them at the edges
- Favour pure functions — given the same inputs, return the same output with no side effects
- Avoid global mutable state — it is a source of subtle bugs, especially across tests
- Validate inputs at system boundaries — don't let bad data propagate inward

---

## Error Handling

- Never throw raw strings — throw `Error` instances or typed custom error classes
- Define typed error classes for domain errors: `class OrderNotFoundError extends Error { ... }`
- Never swallow errors in `catch` blocks — at minimum log with context
- Handle all Promise rejections explicitly — unhandled rejections crash Node.js processes
- Provide meaningful error messages including the offending value: `` `Order not found: orderId=${orderId}` ``

---

## Testing

- Test names describe behaviour: `it('returns empty array when no orders found')`
- Mock only at system boundaries — not internal functions
- Tests must be deterministic — no `Date.now()`, `Math.random()`, or real network calls in unit tests
- A test that is hard to write is often a signal that the design needs simplification

---

## General

- Commit your lockfile — always
- Keep `dependencies` (runtime) and `devDependencies` (build/test/lint) cleanly separated
- Run dependency vulnerability scanning regularly
- Use a structured logger — not `console.log()` in production code
- Never log sensitive data — passwords, tokens, PII
- Set timeouts on all external calls — never let a hanging request block indefinitely
