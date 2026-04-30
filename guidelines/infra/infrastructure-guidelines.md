# Infrastructure Guidelines

> **Note**: These are generic best practice suggestions. The infrastructure patterns and tooling already established in this repository take precedence. Do not propose infrastructure changes based on these guidelines unless the user explicitly requests it.

---

## Philosophy

Infrastructure is code. Apply the same engineering discipline to infrastructure that you apply to application code — version control, review, testing, and continuous improvement. The goal is a system that is reproducible, observable, and safe to change.

---

## Infrastructure as Code

- Manage infrastructure declaratively — describe the desired state, not the steps to get there
- Version control all infrastructure definitions — the same way you version application code
- Review infrastructure changes before applying them — an unreviewed infrastructure change is as risky as unreviewed application code
- Test infrastructure changes in a non-production environment before applying to production — especially changes to networking, IAM, or databases
- Make infrastructure changes auditable — know who changed what, when, and why

---

## Environment Management

- Environments should be as similar to each other as possible — the more production differs from staging, the less confidence you have that staging tests are meaningful
- Environment-specific configuration should be externalised — not hardcoded in application code or infrastructure definitions
- Environments should be reproducible — given the infrastructure definition and the application code, you should be able to recreate an environment from scratch
- Development environments should be easy to set up — a new team member should be productive within hours, not days
- Treat environments as cattle, not pets — if an environment is in an unknown state, recreate it rather than manually fixing it

---

## Deployment

- Deployments should be automated — manual deployment steps are error-prone and create knowledge silos
- Deploy small, deploy often — frequent small deployments are less risky than infrequent large ones
- Every deployment should be reversible — have a tested rollback plan before deploying anything to production
- Use deployment strategies that minimise downtime — rolling deployments, blue-green, or canary as appropriate for your system
- Separate deployment from release — feature toggles allow code to be deployed without being activated, reducing release risk
- Deployments should not require downtime for schema changes — plan migrations to be backwards-compatible with the current version of the application

---

## Observability

- Build observability in from the start — it is significantly harder to retrofit
- **Logs** — structured, centralised, with consistent correlation IDs that allow tracing a request across services. Log meaningful events, not noise
- **Metrics** — measure what matters: error rates, latency (at percentiles, not averages), saturation, and traffic. Technical metrics (CPU, memory) are supporting context, not primary signals
- **Tracing** — distributed tracing across service boundaries is essential for diagnosing issues in systems with multiple components
- **Alerting** — alert on symptoms that affect users, not on every internal metric that moves. Alert fatigue is as dangerous as no alerting

---

## Reliability and Resilience

- Design for failure — every external dependency will eventually be unavailable; decide in advance what your system does when that happens
- Use timeouts on all external calls — a slow dependency should not make your service slow or unavailable
- Apply circuit breakers where appropriate — prevent cascading failures when a dependency is struggling
- Define Recovery Time Objective (RTO) and Recovery Point Objective (RPO) — these drive decisions about replication, backup frequency, and failover strategies
- Test your failure modes — chaos engineering practices help verify that your resilience mechanisms actually work
- Have a runbook for every alert — if an alert fires and there is no documented response, the alert is not ready for production

---

## Security

- Use the principle of least privilege for all infrastructure access — services, humans, and automation should have only the permissions they actually need
- Rotate credentials and access keys regularly — and immediately when a leak is suspected
- Never use production credentials in non-production environments
- Scan container images and dependencies for known vulnerabilities as part of the build pipeline
- Network segmentation — services should only be able to communicate with what they need to communicate with
- Encrypt data in transit and at rest — this should be the default, not an afterthought

---

## Scalability

- Design for horizontal scaling where possible — adding more instances is usually safer and cheaper than adding more capacity to existing instances
- Measure before optimising — do not add caching, queuing, or sharding speculatively; measure where the actual bottlenecks are first
- Stateless services scale more easily than stateful ones — externalise state where it can be shared (cache, database) rather than holding it in the service
- Test under realistic load before production — performance problems that appear only under load should be discovered in testing, not in production incidents

---

## Cost

- Infrastructure cost is a product concern, not just an operations concern — involve the team in understanding the cost implications of architectural decisions
- Right-size resources based on actual usage data — over-provisioning is waste; under-provisioning is risk
- Set up cost alerting — unexpected cost spikes are often an early signal of a bug or a misconfiguration
- Review costs regularly — cloud usage patterns drift over time as the product evolves
