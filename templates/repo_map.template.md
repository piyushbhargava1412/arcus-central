# Repository Map: [REPO NAME]

**Generated**: [DATE]  
**Generator**: `/sdd.repo-intelligence`  
**Confidence**: [HIGH | MEDIUM | LOW]

---

## Overview

<!-- 2-3 sentences: what this repo is, primary language/framework, deployment target.
     TECHNICAL ONLY — do NOT describe business domain or user roles here.
     Business context belongs in repo_scope.md → Overview. -->

## Directory Structure

<!-- Top-level directory tree (depth 2-3). Use actual paths. -->

```
[repo-name]/
├── ...
```

## Tech Stack

| Category       | Technology     | Version    | Evidence                        |
|----------------|----------------|------------|---------------------------------|
| Language       |                |            | `[file path]`                   |
| Framework      |                |            | `[file path]`                   |
| Build Tool     |                |            | `[file path]`                   |
| Test Framework |                |            | `[file path]`                   |
| Database       |                |            | `[file path or config]`         |
| Messaging      |                |            | `[file path or config]`         |

## Entry Points

<!-- Application entry points: main class, Lambda handler, CLI entry, etc. -->

| Entry Point         | Type                | File Path                       |
|----------------------|---------------------|---------------------------------|
|                      |                     |                                 |

## Key Components

<!-- Controllers, services, handlers, consumers, repositories — the structural backbone -->

| Component            | Type                | File Path                       | Purpose                         |
|----------------------|---------------------|---------------------------------|---------------------------------|
|                      |                     |                                 |                                 |

## Contracts & Schemas

<!-- Schema FILES only: OpenAPI specs, Avro/Protobuf schemas, GraphQL schemas, JSON schemas.
     List the file path and format — do NOT list individual API endpoints here.
     Logical API operations (methods, paths) belong in repo_scope.md → APIs. -->

| Contract             | Format              | File Path                       |
|----------------------|---------------------|---------------------------------|
|                      |                     |                                 |

<!-- If none found: "No contracts detected. Checked: [list of directories searched]" -->

## Configuration

<!-- Key config files: application.yml, .env, docker-compose, terraform, etc. -->

| Config File          | Purpose             | File Path                       |
|----------------------|---------------------|---------------------------------|
|                      |                     |                                 |

## Build & Run Commands

<!-- Discovered from build files, scripts, Makefile, package.json, etc. -->

| Action      | Command                          | Source                          |
|-------------|----------------------------------|---------------------------------|
| Build       |                                  | `[file path]`                   |
| Test        |                                  | `[file path]`                   |
| Run         |                                  | `[file path]`                   |
| Lint        |                                  | `[file path]`                   |

<!-- If not discoverable: "Not found — checked: [files searched]" -->

## Observability

<!-- Logging, metrics, tracing, health checks — if visible in code/config -->

| Signal       | Implementation       | Evidence                        |
|--------------|----------------------|---------------------------------|
| Logging      |                      | `[file path]`                   |
| Metrics      |                      | `[file path]`                   |
| Tracing      |                      | `[file path]`                   |
| Health Check |                      | `[file path]`                   |

<!-- If not found: "No observability hooks detected." -->

## Module / Package Map

<!-- Logical grouping of code by module or package -->

| Module / Package     | Purpose                          | Key Files                       |
|----------------------|----------------------------------|---------------------------------|
|                      |                                  |                                 |

---

## Scan Coverage

<!-- Simple checklist of what was detected vs not found during scanning.
     Do NOT include confidence ratings or analysis here.
     Full confidence analysis + human confirmation lives ONLY in repo_scope.md → Confidence & Unknowns. -->

| Aspect | Status | Notes |
|--------|--------|-------|
|        | ✅ Detected / ❌ Not found |       |

> **See also**: [repo_scope.md](repo_scope.md) for business ownership, interface boundaries, and full confidence analysis.

