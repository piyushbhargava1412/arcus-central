# Repository Scope: [REPO NAME]

**Generated**: [DATE]  
**Generator**: `/sdd.repo-intelligence`  
**Confidence**: [HIGH | MEDIUM | LOW]

---

## Overview

<!-- 2-3 sentences: what business domain this repo serves, its role in the ecosystem -->

## Business Capabilities

### Owned

<!-- What this repo is responsible for — business functions it implements -->

- [ capability ]

### Out of Scope

<!-- What this repo explicitly does NOT do — important for grooming boundaries -->

- [ capability — owned by X or not implemented ]

## Events

### Produced

<!-- Events/messages this repo publishes -->

| Event Name           | Topic / Queue        | Schema Path                     | Description                     |
|----------------------|----------------------|---------------------------------|---------------------------------|
|                      |                      |                                 |                                 |

<!-- If none found: "No event producers detected. Checked: [directories/files searched]" -->

### Consumed

<!-- Events/messages this repo subscribes to -->

| Event Name           | Topic / Queue        | Handler Path                    | Description                     |
|----------------------|----------------------|---------------------------------|---------------------------------|
|                      |                      |                                 |                                 |

<!-- If none found: "No event consumers detected. Checked: [directories/files searched]" -->

## APIs

### Exposed

<!-- REST/gRPC/GraphQL endpoints this repo serves -->

| API                  | Method / Type        | Path / Operation                | Spec Path                       |
|----------------------|----------------------|---------------------------------|---------------------------------|
|                      |                      |                                 |                                 |

<!-- If none found: "No exposed APIs detected. Checked: [directories/files searched]" -->

### Consumed

<!-- External APIs this repo calls -->

| Service              | API / Endpoint       | Client Path                     | Evidence                        |
|----------------------|----------------------|---------------------------------|---------------------------------|
|                      |                      |                                 |                                 |

<!-- If none found: "No consumed APIs detected. Checked: [directories/files searched]" -->

## Data Ownership

### Entities / Stores

<!-- Data models, database tables, or stores this repo owns -->

| Entity / Store       | Type (DB/Cache/File) | Location / Config               | Description                     |
|----------------------|----------------------|---------------------------------|---------------------------------|
|                      |                      |                                 |                                 |

### Data Flow

<!-- How data enters, transforms, and exits this repo -->

```
[source] → [this repo processing] → [destination]
```

## Dependencies

### Upstream (this repo depends on)

<!-- Services, APIs, data sources this repo requires -->

| Dependency           | Type (API/Event/DB)  | Evidence                        |
|----------------------|----------------------|---------------------------------|
|                      |                      |                                 |

### Downstream (depends on this repo)

<!-- Services that consume this repo's APIs or events -->

| Dependent            | Type (API/Event)     | Evidence                        |
|----------------------|----------------------|---------------------------------|
|                      |                      |                                 |

<!-- If unknown: "Downstream dependents not discoverable from repo alone — requires ecosystem documentation." -->

## Non-Functional Constraints

<!-- SLAs, throughput requirements, compliance, security posture — if documented or inferable -->

| Constraint           | Value / Target       | Evidence                        |
|----------------------|----------------------|---------------------------------|
|                      |                      |                                 |

<!-- If not found: "No non-functional constraints documented." -->

---

## Confidence & Unknowns

### Confidently Inferred

- [ item ]

### Needs Human Confirmation

- [ item — reason ]

### Not Found (checked but absent)

- [ item — directories/files searched ]

