# Language-Specific Guidelines

## Python
### Style Guide
- Follow PEP 8 for code style
- Use snake_case for variables and functions
- Use CONSTANT_CASE for constants
- Use type hints for function signatures

### Tools
- Use `black` for code formatting
- Use `pylint` or `flake8` for linting
- Use `mypy` for type checking
- Use `pytest` for testing

### Best Practices
- Use virtual environments for dependency management
- Use requirements.txt or pyproject.toml for dependency management
- Write comprehensive docstrings
- Use context managers for resource management

## JavaScript/TypeScript
### Style Guide
- Use camelCase for variables and functions
- Use PascalCase for classes and components
- Use CONSTANT_CASE for constants
- Use strict mode

### Tools
- Use `prettier` for code formatting
- Use `eslint` for linting
- Use `TypeScript` for type safety
- Use `jest` or `vitest` for testing

### Best Practices
- Use const by default, let when needed
- Avoid var
- Use arrow functions
- Use async/await over promises

## Java
### Style Guide
- Follow Google Java Style Guide
- Use camelCase for variables and methods
- Use PascalCase for classes
- Use CONSTANT_CASE for constants

### Tools
- Use Maven or Gradle for build management
- Use SLF4J for logging
- Use JUnit 4+ for testing
- Use SpotBugs for bug detection

### Best Practices
- Follow SOLID principles
- Use interfaces for abstractions
- Use immutable objects where possible
- Use try-with-resources for resource management

## Go
### Style Guide
- Follow Effective Go guidelines
- Use camelCase for exported identifiers
- Use simple names
- Document all public functions

### Tools
- Use `gofmt` for code formatting
- Use `golint` for linting
- Use `testing` package for tests
- Use `go test` for running tests

### Best Practices
- Handle errors explicitly
- Use interfaces for abstraction
- Keep functions simple and focused
- Use goroutines for concurrency

## SQL
### Best Practices
- Use meaningful table and column names
- Use uppercase for SQL keywords
- Add comments for complex queries
- Use indexes appropriately
- Normalize database design
- Use prepared statements to prevent SQL injection

