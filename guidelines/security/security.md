# Security — Best Practice Guidelines

> **Note**: These are generic best practice suggestions. The security posture, tooling, and controls already established in this repository take precedence. Do not change existing security patterns based on these guidelines unless the user explicitly requests it.

---

## Philosophy

Security is a design input, not a review gate. The cheapest time to fix a security issue is before the first line of code is written. Threat modelling, secure defaults, and least privilege are not afterthoughts — they are part of the specification and planning stages.

Every developer is responsible for security. It is not the sole domain of a security team or a final audit step.

---

## Threat Modelling

- Think about who might misuse the system before building it — not after
- For any new feature ask: what is the worst thing an attacker could do with this? What data could be exposed? What could be manipulated?
- Use simple frameworks: STRIDE (Spoofing, Tampering, Repudiation, Information disclosure, Denial of service, Elevation of privilege) as a starting checklist
- Document threats and mitigations in the spec or plan — not in a separate security document nobody reads
- Revisit threat model when the feature changes significantly

---

## Authentication and Authorisation

- Never implement custom authentication — use proven identity providers and standards (OAuth 2.0, OpenID Connect, SAML)
- Authenticate every request that touches protected resources — no implicit trust based on network location
- Authorise at the resource level, not just the route level — verify the caller has rights to the specific data they are requesting
- Apply the principle of least privilege — grant only the permissions actually needed, and no more
- Tokens and sessions must have appropriate expiry — shorter is safer
- Invalidate sessions server-side on logout — client-side deletion alone is not sufficient

---

## Input Validation and Output Encoding

- Validate all input at the system boundary — assume everything arriving from outside is hostile
- Use allowlists over denylists — define what is acceptable, reject everything else
- Never trust client-supplied data for security decisions — IDs, roles, prices
- Use parameterised queries or prepared statements for all database interactions — never concatenate user input into SQL
- Encode output appropriately for the context (HTML encoding for web output, JSON encoding for APIs) to prevent injection
- Validate content type, size, and format of file uploads — do not rely on the filename or MIME type provided by the client

---

## Secrets Management

- Never hardcode secrets — no API keys, passwords, tokens, or certificates in source code or config files
- Never commit secrets to version control — even in private repositories; they can leak through history
- Use environment variables or a secrets management system (Vault, AWS Secrets Manager, GCP Secret Manager) for runtime secrets
- Rotate secrets regularly and immediately when a leak is suspected
- Audit which services and people have access to secrets — least privilege applies to secrets too
- Use separate secrets per environment — development credentials must never be used in production

---

## Data Protection

- Identify what data in your system is sensitive (PII, financial data, health data, credentials) — treat it differently
- Encrypt sensitive data at rest using strong, modern algorithms — not custom encryption
- Enforce TLS for all data in transit — no plain HTTP for anything that carries sensitive data
- Hash passwords using a strong adaptive algorithm (bcrypt, Argon2, scrypt) — never store plain text or weakly hashed passwords
- Minimise data collection — only collect and retain data you actually need
- Define and enforce data retention periods — delete data you no longer need

---

## Dependency Security

- Keep dependencies up to date — outdated libraries are the most common source of known vulnerabilities
- Run automated vulnerability scanning against your dependency tree regularly (OWASP Dependency Check, Snyk, Grype, pip-audit)
- Review what you are importing — a dependency with excessive permissions or a poor maintenance track record is a risk
- Pin dependency versions in production — floating versions can introduce vulnerabilities on the next install
- Monitor for newly disclosed CVEs in your dependency tree — subscribe to security advisories for your key dependencies

---

## Logging and Monitoring

- Log security-relevant events: authentication attempts (success and failure), authorisation denials, sensitive data access, configuration changes
- Never log sensitive data — passwords, tokens, full card numbers, SSNs, private keys
- Log enough context to investigate an incident — who, what, when, from where — but not so much that logs become a data leak
- Protect log integrity — logs should be append-only and ideally shipped to a separate system
- Alert on anomalies — repeated authentication failures, unusual access patterns, unexpected errors at scale

---

## Secure Defaults

- Default to the most restrictive settings — open up explicitly only what is needed
- Disable or remove unused features, endpoints, and services — attack surface you don't need should not exist
- Use secure defaults for HTTP headers: `Content-Security-Policy`, `X-Frame-Options`, `X-Content-Type-Options`, `Strict-Transport-Security`
- Disable directory listing, server version headers, and other information-leaking defaults
- Fail securely — when something goes wrong, default to denying access, not granting it

---

## API Security

- Authenticate and authorise every API endpoint — no unauthenticated endpoints unless explicitly intended to be public
- Rate limit APIs — prevent brute force and denial-of-service
- Validate request payloads against a schema — reject malformed or oversized inputs early
- Return minimal error detail to the caller — do not expose stack traces, internal paths, or system details in API error responses
- Version your APIs — makes it possible to deprecate and remove insecure endpoints without breaking clients

---

## Code Review for Security

- Review every change for security implications — not just obvious security-labelled changes
- Flag: user input flowing into queries, commands, or file paths; new authentication or authorisation logic; new dependencies; hardcoded values; changes to cryptography
- Treat security review comments as bugs, not style preferences — they are not optional to address

---

## Incident Readiness

- Know how to rotate every secret your system uses — and have done it at least once in a non-emergency
- Know how to revoke access for a compromised credential or service account
- Have a plan for notifying affected users if a data breach occurs — regulatory requirements often mandate notification timelines
- Run periodic drills — a breach response plan that has never been tested is not a plan
