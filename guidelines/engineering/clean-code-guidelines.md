# Clean Code Guidelines

> **Note**: These are generic best practice suggestions. The conventions and standards already established in this repository take precedence. Do not change existing patterns based on these guidelines unless the user explicitly requests it.

---

## Philosophy

Clean code is not about aesthetics. It is about reducing the cognitive load on the next person who reads, modifies, or debugs it — including yourself six months from now. Code is read far more often than it is written.

---

## Naming

- Names should reveal intent — a good name makes the code read like a sentence
- If a name needs a comment to explain it, the name should be improved
- Avoid abbreviations unless they are universally understood in your domain
- Use consistent naming patterns — if you call it `findById` in one place, do not call it `getUser` in another
- Boolean variables and functions should read as assertions: `isActive`, `hasExpired`, `canProcess`
- Functions should be named with verbs; classes and variables with nouns

---

## Functions

- A function should do one thing — if you need "and" to describe it, consider splitting it
- Keep functions short — the exact length depends on the language and context, but shorter is generally better
- Limit the number of parameters — many parameters are a signal that a function is doing too much or that related parameters should be grouped into a concept
- Avoid boolean flag parameters — they usually mean a function does two different things
- Return early — handle error cases and guard clauses at the top; let the happy path flow naturally at the bottom
- Functions should have no surprising side effects — if a function does something beyond what its name suggests, that is a design smell

---

## Classes and Modules

- A class should have one reason to change — if you can list multiple distinct responsibilities, consider splitting
- Avoid "God objects" that know too much about too many things
- Keep the public interface of a class small — expose only what callers actually need
- Do not expose internal state unnecessarily — the less others know about your internals, the more freedom you have to change them
- High cohesion within a module, low coupling between modules — things that change together should live together

---

## Comments

- Prefer self-documenting code over comments — a good name or a well-structured function eliminates the need for most comments
- Comment the **why**, not the **what** — the code already says what it does; explain the decision or constraint that led to it
- Outdated comments are worse than no comments — they actively mislead
- Remove commented-out code — version control remembers it; leaving it in the codebase creates noise and confusion
- TODO comments should include who owns the TODO and when it is expected to be addressed, otherwise they accumulate forever

---

## Error Handling

- Handle errors explicitly — do not ignore them or swallow them silently
- Errors should be informative — include the offending value and enough context to diagnose the problem
- Do not use exceptions for normal flow control — they are for exceptional conditions
- Fail fast at boundaries — validate inputs when they enter your system, not deep inside your business logic
- Distinguish between errors the caller can recover from and errors that indicate a programming mistake

---

## Duplication

- Duplication is a signal, not a crime — if you see duplication, ask why it exists before eliminating it
- Two pieces of code that look the same but change independently should not be forcibly abstracted
- Two pieces of code that look the same and always change together should be unified
- Wrong abstraction is worse than duplication — a bad abstraction couples things that should be independent

---

## Code Smells Worth Knowing

These patterns are not always problems, but they are worth examining when you encounter them:

- **Long method** — doing too much; consider extracting
- **Large class** — too many responsibilities; consider splitting
- **Long parameter list** — consider grouping related parameters into a meaningful concept
- **Divergent change** — one class changes for many different reasons
- **Shotgun surgery** — one change requires edits in many different places
- **Feature envy** — a method that is more interested in the data of another class than its own
- **Primitive obsession** — using primitive types to represent domain concepts that deserve their own type
- **Speculative generality** — code built for flexibility that is not needed yet
