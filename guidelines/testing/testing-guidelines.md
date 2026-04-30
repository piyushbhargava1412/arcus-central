# Testing Guidelines

> **Note**: These are generic best practice suggestions. The testing conventions and patterns already established in this repository take precedence. Do not change existing testing approaches based on these guidelines unless the user explicitly requests it.

---

## Philosophy

Tests are not a quality gate at the end of development — they are a design tool throughout it. Writing a test before writing the code forces you to think about the interface, the inputs, and the expected behaviour before you think about the implementation. A suite of tests that you trust gives you the freedom to change the code without fear.

A test that you do not trust is worse than no test — it gives false confidence.

---

## The Testing Pyramid

The pyramid describes the relative volume, speed, and scope of test types:

- **Unit tests** — the base; fast, isolated, numerous. Test individual units of logic in isolation. These should run in milliseconds and require no external dependencies
- **Integration tests** — the middle; test that components work together correctly (service + database, service + external API). Slower and fewer than unit tests
- **End-to-end tests** — the tip; test complete user journeys through the real system. Expensive, slow, brittle — use sparingly for the most critical paths only

Invert this pyramid and you get a slow, expensive, fragile suite that developers stop trusting. Favour unit tests; use integration and E2E tests where they add value that unit tests cannot provide.

---

## Writing Good Tests

- **Tests should describe behaviour, not implementation** — name tests in terms of what the system does, not how it does it. A test named `shouldReturnEmptyListWhenNoOrdersFound` is far more useful than `testGetOrders`
- **One logical assertion per test** — a test that checks ten things tells you almost nothing when it fails. A test that checks one thing tells you exactly what broke
- **Arrange, Act, Assert** — structure every test with clear setup, execution, and verification phases. It makes tests easier to read and reason about
- **Tests should be deterministic** — a test that sometimes passes and sometimes fails is not a test; it is noise. Eliminate randomness, time dependencies, and network calls from unit tests
- **Tests should be independent** — no test should depend on another test having run first, or on shared mutable state
- **A hard-to-write test is a design signal** — if writing a test is painful, the code under test probably has too many responsibilities, too many hidden dependencies, or both

---

## Test-Driven Development

TDD is a design practice that happens to produce tests, not a testing technique. The cycle:

1. **Red** — write a test for the behaviour you want; run it and watch it fail
2. **Green** — write the minimum code to make the test pass
3. **Refactor** — clean up the code while keeping the tests green

The discipline of writing the test first forces you to think about the interface before the implementation. It also produces code that is inherently testable — because it was written to be tested from the very first line.

TDD is most valuable for new behaviour and complex logic. It is less critical for straightforward glue code or trivial transformations.

---

## What to Test

Focus testing effort where it provides the most value:

- Business logic and domain rules — these are where bugs have the most impact
- Error handling and edge cases — these are where bugs are most likely to hide
- Integration points — the boundaries between your code and external systems
- Public APIs and interfaces — what callers depend on

Less critical to test exhaustively:
- Simple data transfer objects or value objects
- Trivial getters and setters
- Generated code

100% coverage of the wrong things is worth less than 70% coverage of the right things.

---

## Mocking and Test Doubles

- Mock at system boundaries — external services, databases, message queues, file systems, clocks
- Do not mock what you own — mocking your own internal collaborators creates tests that are tightly coupled to implementation and break whenever you refactor
- A test that requires extensive mocking to set up is usually a sign that the code has too many dependencies
- Prefer real objects over mocks where the real object is fast and has no side effects — over-mocking hides integration bugs

---

## Test Data

- Use realistic test data — contrived data (id=1, name="test") produces tests that pass for the wrong reasons
- Do not use production data in tests — it creates privacy and compliance risks and makes tests environment-dependent
- Use builders or factories for complex test objects — they make tests readable and reduce setup duplication
- Clean up test data after each test — do not rely on test ordering or shared state

---

## Integration and End-to-End Testing

- Integration tests should verify that components actually work together — not that the framework wires things up correctly
- End-to-end tests should cover the most critical user journeys — the flows where failure would be immediately visible and costly
- Keep E2E tests stable — flaky E2E tests are the fastest way to erode team confidence in the test suite
- Run E2E tests against a production-like environment — tests that pass in an artificial environment and fail in production are not useful

---

## Performance Testing

- Test performance where it matters — not everywhere, but for the paths where latency and throughput are critical
- Define what "good" looks like before testing — a number without a target is just a number
- Performance tests should be repeatable and run against consistent infrastructure — otherwise you cannot distinguish signal from noise
- Test under realistic load, not just peak theoretical load — the distribution of requests matters as much as the volume

---

## Continuous Testing

- Run unit tests on every commit — they should be fast enough that this is not burdensome
- Run integration tests on every merge to the main branch
- Reserve E2E tests for pre-release or scheduled runs — running them on every commit is usually too slow to be practical
- A broken test suite should stop the line — treat it with the same urgency as a production incident
