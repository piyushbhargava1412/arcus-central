# Architecture Guidelines

> **Note**: These are generic best practice suggestions. The architecture already established in this repository takes precedence. Do not propose architectural changes based on these guidelines unless the user explicitly requests it.

---

## Philosophy

Good architecture maximises the number of decisions that do not need to be made yet. Defer decisions as long as possible — the longer you wait, the more information you have. Prefer reversible decisions over irreversible ones. The goal is not to produce a perfect upfront design; it is to keep the system easy to change.

---

## Core Principles

- **Simplicity first** — the simplest architecture that meets actual requirements is the right one. Complexity needs to earn its place
- **Evolutionary design** — design for the needs you have now, with the seams in place to grow. Do not design for hypothetical future needs that may never materialise
- **Defer irreversible decisions** — the later you decide on something hard to change (data store, communication protocol, deployment model), the more information you have
- **Make the implicit explicit** — hidden constraints, assumptions, and coupling are the most dangerous. Name them, document them, surface them
- **Fitness functions** — define what "good" means for your architecture (latency, coupling, security posture) and measure it continuously, not just at the point of design

---

## Modularity and Boundaries

- Define clear boundaries between modules — a good boundary has a small, stable interface and hides a large, changeable implementation
- Dependencies should flow in one direction — avoid circular dependencies between modules
- Domain logic should not depend on infrastructure — keep the business rules independent of how they are delivered (HTTP, queues, databases)
- High cohesion within a boundary, low coupling across boundaries — things that change together should live together
- If a change to one module always requires changes to another, they are not well-separated

---

## API Design

- Design APIs before implementation — an API-first approach forces clarity about what is needed before implementation details get in the way
- APIs should be designed for their consumers — understand what callers need, not what is convenient to implement
- Be conservative in what you send, liberal in what you accept — backwards compatibility is easier to maintain with this principle
- Version APIs explicitly — removing or changing a contract is a breaking change regardless of whether callers currently exist
- Error responses should be as informative as success responses — callers need to know what went wrong and ideally how to fix it

---

## Data

- Own your data — avoid direct access to another service's database; go through its API
- Choose data stores based on access patterns — relational, document, graph, time-series, and key-value stores each have different strengths
- Consider consistency requirements carefully — strong consistency has a cost; eventual consistency is often sufficient and more scalable
- Plan for data at scale from the design stage — retrofitting a data model for scale is significantly harder than designing for it early
- Data migrations should be safe to run multiple times (idempotent) and should not require downtime wherever possible

---

## Resilience

- Assume failures will happen — design for graceful degradation rather than assuming everything will work
- Fail fast — detect and surface failures quickly rather than letting them propagate silently
- Use timeouts and circuit breakers on all external calls — a slow dependency should not make your service slow
- Design for idempotency where possible — make it safe to retry operations without unintended side effects
- Have a plan for what happens when each dependency fails — this should be a design-time decision, not a production-incident decision

---

## Observability

- Build observability in from the start — logging, metrics, and tracing are not features you add later
- Structure your logs — unstructured logs are hard to query and aggregate at scale
- Trace requests across service boundaries — a single user action often touches multiple services; being able to correlate them is essential for diagnosis
- Define and measure the things that actually matter — not just technical metrics (CPU, memory) but business and user-facing metrics (error rates, latency at the Nth percentile)

---

## Decision Making

- Document architecture decisions with their rationale — a decision recorded without its reasoning will be reversed without understanding the trade-offs
- Make trade-offs explicit — every architecture decision involves trade-offs; naming them helps future decisions
- Use the Thoughtworks Technology Radar mindset: Adopt, Trial, Assess, Hold — have a considered opinion on the technologies you use and why
- Prefer proven solutions to novel ones for infrastructure concerns — innovation is valuable in product features, not in the plumbing that keeps things running

---

## When Complexity Is Warranted

Introduce architectural complexity only when the simpler alternative has a concrete cost:

- Microservices over a monolith when independent deployment or scaling is a genuine requirement — not because it is fashionable
- Event-driven patterns when temporal decoupling or fan-out is needed — not because it is interesting
- CQRS when read and write models genuinely diverge — not as a default pattern
- Caching when measured performance data shows a bottleneck — not speculatively

If you cannot articulate the specific problem a pattern solves for this system, it probably does not belong here yet.
