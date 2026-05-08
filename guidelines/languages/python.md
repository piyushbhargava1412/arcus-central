# Python — Best Practice Guidelines

> **Note**: These are generic best practice suggestions. The conventions, tooling, and structure already established in this repository take precedence. Do not change existing patterns based on these guidelines unless the user explicitly requests it.

---

## Naming

- Use `snake_case` for variables, functions, and modules; `PascalCase` for classes; `SCREAMING_SNAKE_CASE` for constants
- Functions named with verbs: `calculate_total()`, `find_order_by_id()`
- Boolean variables and functions as assertions: `is_active`, `has_expired`, `can_process()`
- Avoid abbreviations — `customer_id` not `cid`
- If a name needs a comment to explain it, the name should be improved instead

---

## Type Hints

- Add type annotations to all public function signatures — parameters and return types
- Use `Optional[T]` (or `T | None`) for values that may legitimately be absent
- Prefer typed dataclasses or models over raw dictionaries for structured data — they are self-documenting and type-checkable
- Avoid `Any` — use `Unknown` or narrow types explicitly where the type is genuinely uncertain

---

## Functions

- A function should do one thing
- Avoid mutable default arguments (`def fn(items=[])` is a well-known Python trap — use `None` and set inside)
- Avoid boolean flag parameters — they signal a function doing two things
- Return early — handle error and guard cases at the top; happy path flows below
- Prefer explicit over implicit — avoid side effects that are not obvious from the function signature

---

## Design

- Favour composition — Python's duck typing makes it straightforward to compose behaviours without inheritance
- Pass dependencies explicitly rather than importing global singletons — makes testing and reasoning easier
- Avoid global mutable state — it is a source of subtle bugs, especially across tests
- Validate inputs at system boundaries — don't let bad data propagate inward
- Keep infrastructure concerns (database, HTTP, queues) separate from business logic

---

## Error Handling

- Catch specific exceptions — never bare `except:` without a clear reason
- Provide meaningful error messages including the offending value: `f"Order not found: order_id={order_id}"`
- Define custom exception classes for domain errors rather than raising generic `ValueError` or `RuntimeError`
- Use context managers (`with`) for resource management — not bare `try/finally`
- Do not use exceptions for expected flow control — they are for exceptional conditions

---

## Testing

- Test names should describe behaviour: `test_returns_empty_list_when_no_orders_found`
- Mock only at system boundaries — not internal functions
- Tests should be fast, isolated, and deterministic — no network calls, no `time.sleep()`, no random values
- A test that is hard to write is often a signal that the design needs simplification

---

## General

- Keep dependencies minimal — each dependency is a maintenance and security liability
- Run dependency vulnerability scanning regularly
- Use a structured logger with parameterised messages — not `print()` in production code
- Never log sensitive data — passwords, tokens, PII
