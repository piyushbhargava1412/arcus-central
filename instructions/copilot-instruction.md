# Wholesale Service - Copilot Instruction Architecture

**Version**: 1.0.0  
**Last Updated**: 2026-03-02  
**Repository**: wholesale-service  
**Technology Stack**: Java 21, Spring Boot 3.1.12, Maven, JavaFX, JUnit 5

---

## 1. Project Context

### Repository Summary
The **wholesale-service** is a full-fledged web service designed for testing the SDD (Specification-Driven Development) methodology. It provides a RESTful API backed by Spring Boot, with comprehensive testing infrastructure and architectural governance standards.

### Key Characteristics
- **Type**: Spring Boot REST Web Service + JavaFX UI Foundation
- **Primary Language**: Java 21
- **Build Tool**: Maven
- **Testing Framework**: JUnit 5 (JUnit Jupiter)
- **Architecture Style**: Layered (Presentation → Service → Domain → Repository)
- **Data Format**: JSON (stored in `data/wholesale-shop.json`)

### Core Modules
1. **WholesaleServiceApplication** - Spring Boot entry point
2. **domain/** - Domain models and entities (currently empty, ready for implementation)
3. **service/** - Business logic and service layer (currently empty, ready for implementation)
4. **resources/** - FXML UI templates and configuration files

### Technology Stack Details
```
Spring Boot 3.1.12
├── spring-boot-starter
├── spring-boot-starter-web (REST API support)
└── spring-boot-maven-plugin (build & packaging)

JavaFX 21.0.6
├── javafx-controls (UI components)
├── javafx-fxml (XML-based UI definitions)
└── javafx-maven-plugin (build integration)

Testing (JUnit 5)
├── junit-jupiter-api (test annotations)
└── junit-jupiter-engine (test execution)

Build & Compilation
├── maven-compiler-plugin (Java 21 compilation)
└── Java 21 (target/source)
```

### Data Schema
The service operates on wholesale shop inventory data:
```json
{
  "shopName": "string",
  "shopId": "string",
  "lastUpdated": "ISO-8601 date",
  "items": [
    {
      "id": "string",
      "name": "string",
      "price": "decimal",
      "quantity": "integer"
    }
  ]
}
```

---

## 2. System Functionalities

### Copilot Agents
The project utilizes a suite of SDD agents to enforce specification-driven development:

| Agent | Purpose | Trigger | Output |
|-------|---------|---------|--------|
| **sdd.instructions** | Creates and maintains architecture-aware instruction sets | User request `/sdd.instructions` | copilot-instruction.md with versioned amendments |
| **sdd.analyze** | Analyzes requirements and identifies scope | Analysis phase | Analysis report with identified features |
| **sdd.clarify** | Clarifies ambiguous requirements with user input | Clarification phase | Clarified requirements document |
| **sdd.specify** | Creates formal specifications from clarified requirements | Specification phase | Software Design Document (SDD) |
| **sdd.plan** | Breaks down specifications into implementation plans | Planning phase | Work breakdown structure and estimates |
| **sdd.groom** | Refines stories and tasks for implementation readiness | Grooming phase | Groomed tasks with acceptance criteria |
| **sdd.groom-story** | Focuses on refining individual user stories | Story grooming | Refined story with clear acceptance criteria |
| **sdd.implement** | Provides code implementation guidance | Implementation phase | Code templates and implementation patterns |
| **sdd.review** | Reviews code against specification and principles | Code review phase | Review comments with improvement suggestions |
| **sdd.tasks** | Generates task lists and work items | Task generation | Atomic, testable task items |

### Templates & Standards
- **spec-template.md** - Structure for formal specifications
- **plan-template.md** - Structure for implementation plans
- **tasks-template.md** - Structure for task breakdown
- **user-story.template.md** - Structure for user stories
- **software-design-document.template.md** - SDD format

### Key Scripts & Utilities
Located in `.apex/scripts/`:
- Build automation scripts
- Deployment helpers
- Validation scripts

---

## 3. Engineering Principles

### P1: Non-Negotiable Principles

#### P1.1 – Specification-Driven Development (SDD)
**Rule**: All features MUST be specified before implementation begins.
- **Why**: Specifications prevent scope creep, ensure alignment, and create testable acceptance criteria
- **How**: Follow the SDD workflow: Analyze → Clarify → Specify → Plan → Implement → Review
- **Evidence**: Every feature has a corresponding SDD file with acceptance criteria and test cases
- **Enforcement**: Code review MUST reference specification document; PRs without specs are rejected

#### P1.2 – Test-Driven Development (TDD)
**Rule**: Tests MUST be written before or concurrently with implementation; minimum 80% code coverage required.
- **Why**: TDD ensures code quality, documents expected behavior, and prevents regression
- **How**: For each feature, write unit tests first, then implementation code
- **Evidence**: Test files in `src/test/` mirror `src/main/` structure; coverage reports must show ≥80%
- **Enforcement**: Build fails if coverage drops below 80%; all code must have corresponding tests

#### P1.3 – SOLID Principles Compliance
**Rule**: All code MUST adhere to SOLID principles (Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion).
- **Why**: SOLID principles ensure maintainability, extensibility, and flexibility
- **How**: Use interfaces for abstractions, keep classes focused on single responsibility, depend on abstractions not concretions
- **Evidence**: Code review checklist includes SOLID verification; architecture guidelines define module boundaries
- **Enforcement**: Static analysis tools must pass; code review explicitly checks SOLID compliance

#### P1.4 – Layered Architecture Adherence
**Rule**: Code MUST respect the layered architecture: Presentation → Service → Domain → Repository.
- **Why**: Layering separates concerns, improves testability, and enables independent scaling
- **How**: Place code in appropriate packages; domain models in `domain/`, business logic in `service/`, REST controllers in presentation layer
- **Evidence**: Package structure mirrors architecture; dependencies flow downward only
- **Enforcement**: Code review verifies layer boundaries; dependency analysis tools flag violations

#### P1.5 – Security by Design
**Rule**: All security requirements MUST be implemented before code release; no exceptions for convenience.
- **Why**: Security vulnerabilities are costly to fix after release and pose legal risks
- **How**: Use Spring Security, HTTPS, input validation, prepared statements, least privilege access
- **Evidence**: Security scan reports pass with no critical findings; OWASP Top 10 risks are mitigated
- **Enforcement**: Build fails on high/critical security vulnerabilities; security review required before merge

### P2: Mandatory Principles

#### P2.1 – Code Quality Standards
**Rule**: Code MUST pass style checks, linting, and static analysis with zero warnings.
- **Standards**: Follow Google Java Style Guide for Java code
- **Tools**: Maven build enforces formatting and style checks
- **Coverage**: 80%+ code coverage with focus on branch coverage
- **Enforcement**: Build fails on warnings; code review enforces standards

#### P2.2 – API Documentation
**Rule**: All public APIs MUST be documented with purpose, parameters, return values, and examples.
- **Format**: JavaDoc for Java code, OpenAPI/Swagger for REST endpoints
- **Requirements**: Endpoint descriptions, request/response schemas, error codes, usage examples
- **Enforcement**: Code review verifies documentation completeness; API docs auto-generated for CI/CD

#### P2.3 – Database Design
**Rule**: Database schemas MUST be normalized and versioned; migrations MUST be tracked.
- **Standards**: Follow normalization rules; avoid data duplication
- **Versioning**: Each schema change is tracked in version control
- **Testing**: Database changes tested in integration tests
- **Enforcement**: Code review examines schema changes; migrations run in all environments

#### P2.4 – Error Handling & Logging
**Rule**: All exceptions MUST be caught and logged; errors MUST be user-friendly and non-revealing.
- **Logging**: Use SLF4J with appropriate log levels (DEBUG, INFO, WARN, ERROR)
- **Error Messages**: Never expose stack traces to users; log full details for debugging
- **Structured Logging**: Use JSON logging for centralized log aggregation
- **Enforcement**: Code review verifies proper error handling; logs must be clean without stack traces

#### P2.5 – Versioning & Compatibility
**Rule**: All public APIs MUST follow semantic versioning; backward compatibility MUST be maintained.
- **Format**: MAJOR.MINOR.PATCH (e.g., 1.0.0)
- **Rules**: MAJOR for incompatible changes, MINOR for backward-compatible additions, PATCH for bug fixes
- **Deprecation**: Deprecated APIs must be marked and documented; support for 2+ versions
- **Enforcement**: Changelog documents all changes; release notes explain breaking changes

### P3: Recommended Practices

#### P3.1 – Performance Optimization
**Recommendation**: Monitor performance metrics and optimize bottlenecks.
- **Tools**: Profilers, load testing, APM (Application Performance Monitoring)
- **Targets**: API response time <200ms, database queries <100ms
- **Review**: Performance benchmarks reviewed in code review

#### P3.2 – Documentation Excellence
**Recommendation**: Maintain comprehensive documentation beyond code comments.
- **Types**: Architecture diagrams, deployment guides, runbooks, API guides
- **Location**: README files in each module, centralized wiki
- **Updates**: Keep documentation in sync with code changes

#### P3.3 – Continuous Improvement
**Recommendation**: Regularly review and improve development processes.
- **Metrics**: Track code quality, deployment frequency, build times
- **Reviews**: Quarterly process reviews with team
- **Experiments**: Test new tools and methodologies in controlled settings

---

## 4. Architecture Guidelines

### Module Boundaries

#### Domain Layer (`domain/`)
**Purpose**: Encapsulates core business logic and data models  
**Responsibilities**:
- Define domain entities (e.g., `ShopItem`, `Inventory`)
- Business rules and validations
- Domain-specific exceptions
- No external dependencies (except Java standard library and Spring annotations)

**Example Structure**:
```
domain/
├── entity/
│   ├── ShopItem.java (domain entity with business rules)
│   └── Inventory.java
├── value/
│   ├── Price.java (value objects)
│   └── Quantity.java
├── repository/
│   └── InventoryRepository.java (interface only, no implementation)
└── service/
    └── InventoryService.java (domain services)
```

#### Service Layer (`service/`)
**Purpose**: Orchestrates business processes and coordinates between layers  
**Responsibilities**:
- Business logic and workflows
- Coordinate domain objects
- Transaction management
- Call external services
- Depends on domain layer and repositories

**Example Structure**:
```
service/
├── InventoryService.java (main business service)
├── PricingService.java (pricing logic)
└── notification/
    └── InventoryAlertService.java (send alerts)
```

#### Repository Layer (implicit)
**Purpose**: Data access abstraction  
**Responsibilities**:
- Database operations
- Data persistence
- Implement repository interfaces defined in domain layer
- Handle SQL queries or ORM mappings

#### Presentation Layer (REST Controllers)
**Purpose**: Exposes API endpoints and handles HTTP communication  
**Responsibilities**:
- REST endpoint definitions
- Request validation
- Response formatting
- Error handling and status codes
- Security (authentication, authorization)

**Package**: Usually `controller/` or `rest/`

### Dependency Rules

**Golden Rule**: Dependencies flow downward (Presentation → Service → Domain → Repository)

```
┌─────────────────────┐
│  Presentation       │  (REST Controllers)
│  (Web Layer)        │
└──────────┬──────────┘
           │ depends on
           ▼
┌─────────────────────┐
│  Service Layer      │  (Business Logic)
└──────────┬──────────┘
           │ depends on
           ▼
┌─────────────────────┐
│  Domain Layer       │  (Entities, Values, Rules)
└──────────┬──────────┘
           │ depends on
           ▼
┌─────────────────────┐
│  Repository Layer   │  (Data Access)
│  (Interfaces)       │
└─────────────────────┘
```

**Violations**:
- ❌ Domain layer importing from service/presentation
- ❌ Repository importing from service/presentation
- ❌ Circular dependencies between layers
- ❌ Skipping layers (e.g., presentation directly using repository)

### Package Structure

```
apex/sdd/wholesaleservice/
├── WholesaleServiceApplication.java (Spring Boot entry point)
├── domain/
│   ├── entity/
│   │   └── *.java (domain entities)
│   ├── value/
│   │   └── *.java (value objects)
│   ├── repository/
│   │   └── *Repository.java (repository interfaces)
│   └── exception/
│       └── *Exception.java (domain exceptions)
├── service/
│   ├── *Service.java (business services)
│   └── impl/
│       └── *ServiceImpl.java (implementations - optional if using Spring)
├── controller/
│   └── *Controller.java (REST endpoints)
├── dto/
│   ├── request/
│   │   └── *Request.java (incoming DTOs)
│   └── response/
│       └── *Response.java (outgoing DTOs)
├── config/
│   └── *.java (Spring configuration)
└── util/
    └── *.java (utility classes)
```

### Inter-Service Communication
- Use dependency injection (Spring's @Autowired) for service dependencies
- Use interfaces (@Service implementations) for loose coupling
- Avoid direct class instantiation; use Spring beans
- For external services, use RestTemplate or WebClient

### Data Access Patterns
- Use Spring Data JPA repositories (or custom implementations)
- Define repository interfaces in domain layer; implement in data layer
- Use query methods or @Query annotations
- Keep complex queries in repositories, not in services

---

## 5. Infrastructure Standards

### Environment Separation

#### Development Environment
- **Setup**: `mvn clean install` + local database (H2 or SQLite)
- **Config**: `application-dev.properties`
- **Database**: In-memory or local file-based
- **Logging**: DEBUG level
- **Monitoring**: None required

#### Staging Environment
- **Setup**: Docker container via `docker-compose up`
- **Config**: `application-staging.properties`
- **Database**: PostgreSQL (or production-like)
- **Logging**: INFO level
- **Monitoring**: Basic metrics collection

#### Production Environment
- **Setup**: Kubernetes or Docker Swarm deployment
- **Config**: Environment variables or Spring Cloud Config
- **Database**: Managed database service (AWS RDS, Azure Database)
- **Logging**: WARN level + structured JSON logging
- **Monitoring**: Full APM, alerting, dashboards

### Docker & Containerization

**Dockerfile Requirements**:
```dockerfile
FROM eclipse-temurin:21-jdk-jammy (or similar)
WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

**Docker Compose** (for local development):
```yaml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "8080:8080"
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: wholesale_db
      POSTGRES_PASSWORD: password
```

### Configuration Management

**Property Files by Environment**:
- `application.properties` - common settings
- `application-dev.properties` - development overrides
- `application-staging.properties` - staging overrides
- `application-prod.properties` - production overrides

**Active Profile Selection**:
```
mvn clean package -Dspring.profiles.active=dev
mvn clean package -Dspring.profiles.active=prod
```

**Sensitive Data**:
- Never commit passwords/keys to version control
- Use environment variables for secrets
- Use Spring Cloud Vault or AWS Secrets Manager for production

### Build & CI/CD

**Maven Build Lifecycle**:
```
mvn clean          # Remove build artifacts
mvn compile        # Compile source code
mvn test          # Run unit tests
mvn package       # Package as JAR
mvn install       # Install to local repo
mvn deploy        # Deploy to artifact repository
```

**Build Configuration**:
```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-compiler-plugin</artifactId>
  <configuration>
    <source>21</source>
    <target>21</target>
  </configuration>
</plugin>
```

### Deployment

**Staging Deployment**:
- Triggered on merge to `main` branch
- Automatic via GitHub Actions or similar
- Smoke tests run post-deployment

**Production Deployment**:
- Manual approval required
- Blue-green deployment strategy
- Automated rollback on health check failure
- Post-deployment verification

---

## 6. Language & Coding Standards

### Java Standards

#### Code Style
- **Style Guide**: Google Java Style Guide
- **Line Length**: 100 characters (soft limit), 120 (hard limit)
- **Indentation**: 2 spaces (not tabs)
- **Naming**:
  - Classes: `PascalCase` (e.g., `InventoryService`)
  - Methods/Variables: `camelCase` (e.g., `getInventoryItems()`)
  - Constants: `CONSTANT_CASE` (e.g., `MAX_RETRY_COUNT`)
  - Packages: lowercase dotted (e.g., `apex.sdd.wholesaleservice.domain`)

#### Code Formatting
- Use EditorConfig file (`.editorconfig`) for IDE consistency
- Enable auto-formatting on save in IDE
- Run `mvn fmt:format` to auto-format code

#### Javadoc Standards
```java
/**
 * Brief description of the class/method.
 * 
 * Longer description if needed, explaining behavior, side effects,
 * and important implementation details.
 *
 * @param paramName description of parameter
 * @return description of return value
 * @throws ExceptionType description of when thrown
 * @since 1.0.0
 */
```

#### Annotation Usage
- Use Spring annotations (@Service, @Repository, @Controller)
- Use @Nullable/@NonNull for optional parameters
- Document annotation purpose in code comments

### Markdown Standards (for documentation)

- **File Names**: Use kebab-case (e.g., `architecture-guidelines.md`)
- **Headers**: Use H1 for title, H2 for sections, H3 for subsections
- **Lists**: Use `- ` for unordered lists, `1. ` for ordered
- **Code Blocks**: Use triple backticks with language identifier ` ```java `
- **Line Length**: 100 characters (soft), no hard limit for tables

### Git & Version Control

#### Commit Message Format
```
[TYPE] Description (imperative mood, lowercase)

Optional body explaining the change:
- What changed and why
- Related issues/tickets
- Breaking changes if applicable
```

**Types**:
- `feat` - New feature
- `fix` - Bug fix
- `refactor` - Code refactoring (no behavior change)
- `test` - Test-related changes
- `docs` - Documentation changes
- `chore` - Build, dependencies, configuration

**Examples**:
```
feat: Add inventory management service

implement: Create InventoryService with CRUD operations
for wholesale items with transaction support.

Closes #123
```

```
fix: Resolve NPE in inventory validation

Check for null quantity before performing arithmetic
operations.

Fixes #456
```

#### Branching Strategy
- **Main Branch** (`main`): Production-ready code only
- **Feature Branches** (`feature/description`): New features
- **Bugfix Branches** (`bugfix/description`): Bug fixes
- **Release Branches** (`release/vX.Y.Z`): Release preparation
- **Hotfix Branches** (`hotfix/description`): Production hotfixes

**Branch Naming Rules**:
- Use lowercase and hyphens: `feature/user-authentication`
- Keep names descriptive but concise
- Include issue number if applicable: `feature/auth-123-oauth2`

---

## 7. Repository Governance

### Folder Responsibilities

```
wholesale-service/
├── .apex/                          # Governance & instructions
│   ├── instructions/               # Architecture guidance
│   │   ├── copilot-instruction.md  # THIS FILE - Golden reference
│   │   ├── architecture/           # Architecture guidelines
│   │   ├── engineering/            # Engineering standards
│   │   ├── languages/              # Language-specific rules
│   │   ├── testing/                # Testing standards
│   │   └── infra/                  # Infrastructure standards
│   ├── scripts/                    # Build & automation scripts
│   ├── templates/                  # Document templates
│   └── ...
├── .github/                        # GitHub-specific
│   ├── agents/                     # SDD agent definitions
│   ├── prompts/                    # Agent prompt files
│   └── workflows/                  # CI/CD workflows
├── src/
│   ├── main/
│   │   ├── java/apex/sdd/          # Source code
│   │   └── resources/              # Config files, FXML
│   └── test/
│       └── java/apex/sdd/          # Test code
├── data/                           # Test/sample data
├── pom.xml                         # Maven configuration
├── README.md                       # Project overview
└── .gitignore                      # Version control exclusions
```

### Registry Behavior (Agent Registry)

**Agent Registry Location**: `.github/agents/`

Each agent is defined in a `.agent.md` file:
- **Naming**: `sdd.[agent-name].agent.md`
- **Format**: Markdown with execution instructions
- **Updates**: Modified when agent responsibilities change

**Agent Lifecycle**:
1. Agent defined in `.agent.md`
2. Prompt template in `.github/prompts/sdd.[name].prompt.md`
3. Agent invoked via `/sdd.[name]` command
4. Agent output files stored in project

### Cross-Module Rules

#### No Duplication
- **Rule**: Do not duplicate code, logic, or configuration
- **How**: Extract to shared utilities, use inheritance/composition
- **Enforcement**: Code review checks for duplication

#### Dependency Management
- **Rule**: Manage all dependencies in `pom.xml`
- **Versions**: Pin versions; use properties for consistency
- **Updates**: Regular dependency updates with security scanning
- **Exclusions**: Document why dependencies are excluded

#### Configuration Management
- **Rule**: Centralize configuration in `application*.properties`
- **Secrets**: Never commit secrets; use environment variables
- **Consistency**: Use same keys across environments

### Amendment Procedures

#### Instruction Amendments
When requirements, architecture, or principles change:

1. **Identify Change Type**:
   - MAJOR: Breaking changes to principles or architecture
   - MINOR: New principles, expanded guidance
   - PATCH: Clarifications, wording fixes

2. **Update Instructions**:
   - Edit relevant sections in `copilot-instruction.md`
   - Update Amendment Log (see below)
   - Update version number

3. **Amendment Log Format**:
   ```markdown
   | Version | Date | Change Summary | Type |
   |---------|------|-----------------|------|
   | 1.0.0 | 2026-03-02 | Initial architecture and principles definition | MAJOR |
   | 1.1.0 | 2026-03-15 | Add microservices guidance | MINOR |
   | 1.1.1 | 2026-03-20 | Clarify dependency injection patterns | PATCH |
   ```

4. **Governance Review**:
   - Changes require team consensus
   - Document rationale for changes
   - Communicate updates to team

---

## 8. Agent Behavioral Rules

### Repository Awareness
**Rule**: All agents MUST analyze the target repository structure before making changes.
- **Action**: Read project files, understand architecture, identify module boundaries
- **Why**: Prevents violating existing patterns and maintains consistency
- **Enforcement**: sdd.instructions validates repository structure first

### Generation Rules

#### For Specifications (sdd.specify)
- **Must**: Include acceptance criteria
- **Must**: Define test cases
- **Must**: Reference architecture guidelines
- **Should**: Include performance requirements
- **Should**: Include security requirements

#### For Plans (sdd.plan)
- **Must**: Break down into atomic tasks
- **Must**: Estimate effort (story points or hours)
- **Must**: Identify dependencies
- **Should**: Define deployment strategy
- **Should**: Include rollback plan

#### For Tasks (sdd.tasks)
- **Must**: Be independent and testable
- **Must**: Include acceptance criteria
- **Must**: Reference specification
- **Should**: Include test strategy
- **Should**: Include estimation

#### For Implementation (sdd.implement)
- **Must**: Follow SOLID principles
- **Must**: Respect layer boundaries
- **Must**: Include tests (TDD)
- **Must**: Include documentation
- **Should**: Include performance considerations
- **Should**: Include security checks

### Mandatory Validations

#### Pre-Implementation Checklist
- [ ] Specification document exists with acceptance criteria
- [ ] Architecture review completed (no boundary violations)
- [ ] Test strategy defined
- [ ] Security scan completed (no high/critical findings)
- [ ] Performance analysis done (if applicable)

#### Pre-Code Review Checklist
- [ ] All unit tests pass (100% of test suite)
- [ ] Code coverage ≥80%
- [ ] Code style checks pass (Maven build)
- [ ] Documentation complete (JavaDoc, README)
- [ ] Specification acceptance criteria validated
- [ ] SOLID principles verified
- [ ] Layer boundaries respected

#### Pre-Merge Checklist
- [ ] Code review approved by ≥1 team member
- [ ] All CI/CD checks pass
- [ ] Specification document cross-referenced
- [ ] Amendment log updated (if applicable)
- [ ] Breaking changes documented (if applicable)

### Constitution Enforcement

**Definition**: "Constitution" refers to the principles and guidelines defined in this document.

**Enforcement Mechanism**:
1. **Automated Checks**:
   - Build fails if tests don't pass
   - Build fails if coverage < 80%
   - Build fails on security vulnerabilities
   - Code style checks enforced by Maven

2. **Manual Checks** (Code Review):
   - Verify SOLID principles followed
   - Verify layer boundaries respected
   - Verify documentation complete
   - Verify specification alignment

3. **Agent Validation**:
   - sdd.review agent checks specification compliance
   - sdd.instructions agent validates consistency
   - All agents reference copilot-instruction.md

---

## 9. Cross-Reference Enforcement

### Dependent Files & Sync Points

| File | Purpose | Sync Point | Status |
|------|---------|-----------|--------|
| `.apex/instructions/architecture/architecture-guidelines.md` | Architecture patterns | Layer definitions, module boundaries | ✅ Aligned |
| `.apex/instructions/engineering/engineering-guidelines.md` | Code quality standards | SOLID principles, testing requirements | ✅ Aligned |
| `.apex/instructions/languages/language-guidelines.md` | Java-specific rules | Naming conventions, style guides | ✅ Aligned |
| `.apex/instructions/testing/testing-guidelines.md` | Testing strategy | TDD requirement, 80% coverage target | ✅ Aligned |
| `.apex/instructions/infra/infrastructure-guidelines.md` | Deployment & DevOps | Environment separation, CI/CD | ✅ Aligned |
| `.github/agents/sdd.instructions.agent.md` | Agent definition | Instruction creation & maintenance | ✅ Aligned |
| `.apex/templates/spec-template.md` | SDD format | Specification structure | ✅ Aligned |
| `.apex/templates/plan-template.md` | Planning format | Work breakdown structure | ✅ Aligned |
| `.apex/templates/tasks-template.md` | Task format | Task specification | ✅ Aligned |
| `pom.xml` | Build configuration | Java version (21), dependencies | ✅ Aligned |
| `README.md` | Project overview | Purpose, setup instructions | ✅ Aligned |

### Conflict Resolution

If conflicts exist between this document and dependent files:
1. **Priority Order**: copilot-instruction.md (authority) → specific guidelines → templates
2. **Resolution**: Update conflicting files to align with copilot-instruction.md
3. **Escalation**: Document conflicts in Amendment Log

---

## 10. Amendment Log

| Version | Date | Change Summary | Type |
|---------|------|-----------------|------|
| 1.0.0 | 2026-03-02 | Initial architecture, principles, and SDD governance framework for wholesale-service | MAJOR |

---

## 11. Quality Assurance Checklist

**All agents and developers MUST verify:**

- [ ] No unexplained bracket tokens `[...]` remain in documentation
- [ ] All dates in ISO format (YYYY-MM-DD)
- [ ] All file paths use forward slashes and are relative to repo root
- [ ] Section hierarchy maintained (H1 → H2 → H3)
- [ ] Code examples are syntactically correct
- [ ] All cross-references point to valid files
- [ ] Principles are testable and measurable
- [ ] No circular governance rules exist
- [ ] Language is declarative (MUST/SHOULD/MAY clearly marked)
- [ ] Amendment log is up-to-date
- [ ] Version number follows semantic versioning

---

## 12. Quick Reference Guide

### Common Commands

```bash
# Build & Test
mvn clean package                    # Full build with tests
mvn test                            # Run tests only
mvn test -Dtest=ClassName          # Run specific test class
mvn clean test jacoco:report       # Generate coverage report

# Code Quality
mvn fmt:format                     # Auto-format code
mvn checkstyle:check               # Check code style
mvn spotbugs:check                 # Find bugs

# Deployment
mvn clean package spring-boot:repackage  # Build executable JAR
```

### Agent Invocations

```
/sdd.analyze        # Analyze requirements
/sdd.specify        # Create specification
/sdd.plan           # Create implementation plan
/sdd.implement      # Get implementation guidance
/sdd.review         # Review code against spec
/sdd.instructions   # Update instruction architecture
```

### Development Workflow

1. **Understand Requirements** → `/sdd.analyze`
2. **Clarify Ambiguities** → `/sdd.clarify`
3. **Create Specification** → `/sdd.specify`
4. **Plan Implementation** → `/sdd.plan`
5. **Groom Tasks** → `/sdd.groom`
6. **Implement Features** → `/sdd.implement` + TDD
7. **Code Review** → `/sdd.review` + manual review
8. **Merge & Deploy** → Run tests, verify acceptance criteria

---

## Appendix A: SOLID Principles Summary

| Principle | Definition | Example |
|-----------|-----------|---------|
| **S**ingle Responsibility | Class should have one reason to change | InventoryService handles inventory logic only |
| **O**pen/Closed | Open for extension, closed for modification | Use interfaces, not concrete implementations |
| **L**iskov Substitution | Subclasses should be substitutable for parent | All InventoryRepository implementations behave the same |
| **I**nterface Segregation | Clients should depend on small interfaces | Don't create god interfaces with 50 methods |
| **D**ependency Inversion | Depend on abstractions, not concretions | Use @Autowired(required=false) or interfaces |

---

## Appendix B: Glossary

- **SDD**: Specification-Driven Development - methodology requiring formal specs before implementation
- **TDD**: Test-Driven Development - writing tests before implementation
- **SOLID**: Set of five object-oriented design principles
- **Layer**: Logical grouping of code (Domain, Service, Presentation, etc.)
- **Entity**: Domain model representing a concept in the business domain
- **Value Object**: Immutable object defined by its attributes, not identity
- **DTO**: Data Transfer Object - used for API communication
- **Repository**: Data access abstraction layer
- **Service**: Business logic coordination layer
- **Amendment**: Versioned change to instruction architecture
- **Coverage**: Percentage of code executed by tests

---

**End of Copilot Instruction Architecture Document**

---

*This document is the authoritative reference for all copilot agents and developers working on the wholesale-service project. Deviations from these principles and guidelines require amendment (see Section 7). All agents MUST read this document before proceeding with their tasks.*


