# Test-Driven Development (TDD) Guidelines

> **Note**: These are generic best practice suggestions. The development practices already established in this repository take precedence. Do not change existing patterns based on these guidelines unless the user explicitly requests it.

---

## Philosophy

TDD is a design practice, not a testing technique. The primary benefit is not the tests themselves — it is the discipline of thinking about interfaces, contracts, and expected behaviour before writing any implementation. The test suite is a valuable by-product of that discipline.

Writing the test first forces clarity. You cannot write a test without understanding what the code should do, what it needs, and what it should return. That clarity shapes better designs.

---

## The Red-Green-Refactor Cycle

Every TDD session follows this loop:

1. **Red** — write a test for a specific, small piece of behaviour. Run it. It should fail because the behaviour does not exist yet. If it passes, the test is not testing anything new
2. **Green** — write the minimum code necessary to make the test pass. Do not write more than is needed. The goal here is to pass the test, not to write perfect code
3. **Refactor** — with the tests green, improve the code. Extract functions, rename things, remove duplication, simplify structure. Run the tests after every change. If they stay green, the refactoring is safe

Repeat this cycle in small increments. Each cycle adds one small, verified piece of behaviour.

---

## Writing the Test First

This is the discipline that makes TDD valuable:

- Write the test before any production code exists for that behaviour
- If you find yourself writing implementation and then writing tests to match it, you are writing tests — not doing TDD
- The test describes what the code should do; the implementation is how it does it. Getting the "what" right before the "how" leads to better interfaces
- A test written after the fact tends to confirm what the code does; a test written first tends to specify what the code should do — these are meaningfully different

---

## Test Granularity

- Each test should cover one specific piece of behaviour
- If a test fails, it should be immediately obvious what broke and why — a test that covers too much makes diagnosis harder
- Test edge cases and failure conditions explicitly — do not just test the happy path
- Name tests in terms of behaviour: `returns empty list when no items exist`, `throws error when input is invalid` — not `test method X`

---

## Refactoring with Confidence

The test suite is the safety net that makes refactoring safe. Rules for refactoring in TDD:

- Only refactor when the tests are green — never refactor and add behaviour at the same time
- Run the tests after every small refactoring step — do not accumulate many changes before running
- If a refactoring causes tests to fail, undo the refactoring — do not try to fix tests and refactor simultaneously
- Refactoring is not optional — skipping it after going green creates the technical debt that makes future TDD cycles harder

---

## What to Drive with TDD

TDD is most valuable for:

- **Business logic and domain rules** — any code that makes decisions, calculates values, or enforces constraints
- **Error handling** — explicitly specifying what should happen in failure cases before implementing them
- **Complex algorithms** — breaking them into small, verifiable steps
- **Public interfaces and APIs** — test-first ensures the interface serves its consumers

TDD is less critical for:

- **Trivial data transfer objects** — simple structures with no logic
- **Configuration and wiring** — how the framework assembles components
- **Exploratory work** — when you genuinely do not know yet what the code should do, write a spike first, then write the tests for the confirmed design

---

## Common Pitfalls

- **Writing implementation before tests** — this is writing tests after the fact, not TDD
- **Writing too large a test** — if a test requires extensive setup, it is testing too much at once; break it down
- **Not refactoring** — green without refactoring leads to messy code that makes the next test cycle harder
- **Testing implementation details** — if your test breaks when you rename an internal function, it is testing how the code works rather than what it does. Test behaviour, not structure
- **Skipping the red phase** — if you do not run the test and watch it fail before implementing, you do not know the test is actually testing anything

---

## Integration Tests and TDD

Integration tests verify that real components work together correctly. The TDD approach applies here too — define what the integration should do before implementing it — but the cycle is slower and the scope is larger.

A practical approach:

- Use TDD for unit-level behaviour
- Write integration tests after the units are implemented to verify the assembled system works correctly
- Do not drive integration tests with fine-grained TDD cycles — the feedback loop is too slow to be practical at that granularity

---

## The Broader Value

A codebase built with TDD tends to have:

- **Higher testability** — because each unit was designed to be testable from the start
- **Cleaner interfaces** — because the test author (you) is the first consumer of every interface
- **Lower defect rates** — because behaviour is specified and verified as it is built
- **Safer refactoring** — because the suite catches regressions immediately
- **Living documentation** — because tests describe expected behaviour in a form that is always in sync with the code
