# Documentation Index

Welcome to the APEX SDD (Spec Driven Development) Framework documentation!

## Getting Started

- [README.md](../README.md) - Project overview and SDD framework introduction
- [STRUCTURE.md](../STRUCTURE.md) - Complete repository structure and layout
- [APEX_INTEGRATION_GUIDE.md](../APEX_INTEGRATION_GUIDE.md) - How to integrate SDD framework into your repos

## SDD Framework Components

### Agents

Complete documentation for all SDD agents:

### Core Agents
- [Specify Agent](../agents/core/sdd.specify.agent.md) - Create specifications
- [Clarify Agent](../agents/core/sdd.clarify.agent.md) - Clarify requirements
- [Plan Agent](../agents/core/sdd.plan.agent.md) - Create project plans
- [Tasks Agent](../agents/core/sdd.tasks.agent.md) - Break down into tasks
- [Analyze Agent](../agents/core/sdd.analyze.agent.md) - Technical analysis
- [Implement Agent](../agents/core/sdd.implement.agent.md) - Implementation guidance
- [Constitution Agent](../agents/core/sdd.constitution.agent.md) - Standards & guidelines

### Extension Agents
- [Groom Story Agent](../agents/extensions/sdd.groom-story.agent.md) - Story refinement
- [Review Agent](../agents/extensions/sdd.review.agent.md) - Code & spec review

## Prompts

Prompts used to guide agent behavior:

### Core Prompts
- [Specify Prompt](../prompts/core/sdd.specify.prompt.md)
- [Clarify Prompt](../prompts/core/sdd.clarify.prompt.md)
- [Plan Prompt](../prompts/core/sdd.plan.prompt.md)
- [Tasks Prompt](../prompts/core/sdd.tasks.prompt.md)
- [Analyze Prompt](../prompts/core/sdd.analyze.prompt.md)
- [Implement Prompt](../prompts/core/sdd.implement.prompt.md)
- [Constitution Prompt](../prompts/core/sdd.constitution.prompt.md)

### Extension Prompts
- [Groom Story Prompt](../prompts/extensions/sdd.groom-story.prompt.md)
- [Review Prompt](../prompts/extensions/sdd.review.prompt.md)

## Templates

Reusable templates for common documents (7 templates):

- [Software Design Document Template](../templates/software-design-document.template.md) - Complete SDD structure
- [User Story Template](../templates/user-story.template.md) - User story with acceptance criteria
- [Specification Template](../templates/spec-template.md) - Specification document template
- [Project Plan Template](../templates/plan-template.md) - Project planning template
- [Tasks Template](../templates/tasks-template.md) - Task breakdown and estimation template
- [Checklist Template](../templates/checklist-template.md) - Reusable checklist template
- [Agent File Template](../templates/agent-file-template.md) - Template for creating new agents

## Guidelines

Best practices and standards:

### Engineering
- [Engineering Guidelines](../instructions/engineering/engineering-guidelines.md)
  - Code quality standards
  - Testing best practices
  - Code review process
  - Documentation requirements
  - Git workflow

### Architecture
- [Architecture Guidelines](../instructions/architecture/architecture-guidelines.md)
  - Architecture principles
  - Design patterns
  - Technology decisions
  - Security architecture
  - Scalability planning
  - Disaster recovery

### Languages
- [Language Guidelines](../instructions/languages/language-guidelines.md)
  - Python
  - JavaScript/TypeScript
  - Java
  - Go
  - SQL

### Infrastructure
- [Infrastructure Guidelines](../instructions/infra/infrastructure-guidelines.md)
  - Environment management
  - Container & orchestration
  - Deployment strategies
  - Monitoring & logging
  - Network & security
  - Backup & disaster recovery
  - Infrastructure as Code

### Testing
- [Testing Guidelines](../instructions/testing/testing-guidelines.md)
  - Test pyramid
  - Unit testing
  - Integration testing
  - End-to-end testing
  - Performance testing
  - Security testing
  - Test coverage
  - Continuous testing

## Examples

Learn from real-world examples:

- [Orders Service](../examples/sandbox/orders-service/SPECIFICATION.md)
- [Notifications Service](../examples/sandbox/notifications-service/SPECIFICATION.md)
- [Example Outputs](../examples/outputs/README.md)

## Registry

- [Agent Registry](../registry/AGENT_REGISTRY.md) - Complete agent registry

## Scripts

Automation scripts (8 scripts):

- [setup-environment.sh](../scripts/bash/setup-environment.sh) - Setup development environment
- [build.sh](../scripts/bash/build.sh) - Build Docker images
- [test.sh](../scripts/bash/test.sh) - Run tests with coverage
- [check-prerequisites.sh](../scripts/bash/check-prerequisites.sh) - Check system requirements
- [create-new-feature.sh](../scripts/bash/create-new-feature.sh) - Feature creation helper
- [setup-plan.sh](../scripts/bash/setup-plan.sh) - Setup planning script
- [update-agent-context.sh](../scripts/bash/update-agent-context.sh) - Update agent context
- [common.sh](../scripts/bash/common.sh) - Shared utilities library

## Quick Links

- [Version](../VERSION)
- [Structure](../STRUCTURE.md) - Complete repository structure
- [Final Verification](../FINAL_VERIFICATION.md) - Setup verification and summary
- [Editor Config](../.editorconfig)
- [Git Ignore](../.gitignore)

