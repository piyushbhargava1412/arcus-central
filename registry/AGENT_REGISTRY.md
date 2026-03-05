# Agent Registry

This file maintains a registry of all available agents, their capabilities, and usage information.

## Core Agents

### sdd.specify

- **File**: `agents/core/sdd.specify.agent.md`
- **Purpose**: Create detailed specifications from requirements
- **Key Capabilities**:
  - Requirement analysis
  - Specification creation
  - Documentation generation
  - Requirement clarification

### sdd.clarify

- **File**: `agents/core/sdd.clarify.agent.md`
- **Purpose**: Clarify ambiguous requirements and specifications
- **Key Capabilities**:
  - Requirement clarification
  - Ambiguity resolution
  - Question generation
  - Scope definition

### sdd.plan

- **File**: `agents/core/sdd.plan.agent.md`
- **Purpose**: Create project plans and roadmaps
- **Key Capabilities**:
  - Project planning
  - Timeline estimation
  - Resource allocation
  - Risk planning
  - Milestone definition

### sdd.tasks

- **File**: `agents/core/sdd.tasks.agent.md`
- **Purpose**: Break down specifications into actionable tasks
- **Key Capabilities**:
  - Task decomposition
  - Task estimation
  - Task prioritization
  - Dependency analysis
  - Task assignment

### sdd.analyze

- **File**: `agents/core/sdd.analyze.agent.md`
- **Purpose**: Analyze specifications and identify potential issues
- **Key Capabilities**:
  - Technical analysis
  - Requirements analysis
  - Impact assessment
  - Quality analysis
  - Trade-off analysis

### sdd.implement

- **File**: `agents/core/sdd.implement.agent.md`
- **Purpose**: Provide implementation guidance and recommendations
- **Key Capabilities**:
  - Implementation planning
  - Code generation guidance
  - Architecture recommendations
  - Design pattern suggestions
  - Best practice enforcement

## Extension Agents

### sdd.groom-story

- **File**: `agents/extensions/sdd.groom-story.agent.md`
- **Purpose**: Refine and groom user stories for development
- **Key Capabilities**:
  - Story refinement
  - Acceptance criteria definition
  - Story estimation
  - Story validation
  - Definition of done

### sdd.review

- **File**: `agents/extensions/sdd.review.agent.md`
- **Purpose**: Review specifications, code, and deliverables
- **Key Capabilities**:
  - Code review
  - Specification review
  - Quality review
  - Compliance review
  - Feedback generation

### sdd.instructions

- **File**: `agents/extensions/sdd.instructions.agent.md`
- **Skills Reference**: `skills/instruction-architecture/SKILL.md` (deployed to `.github/skills/instruction-architecture/SKILL.md`)
- **Purpose**: Create or update the copilot instruction architecture and ensure all dependent components stay in sync with governance standards
- **Architecture**: Skills-based abstraction - delegates to specialized skill modules
- **Key Capabilities**:
  - Repository structure analysis (via Repository Analysis Skills)
  - Architecture style identification (via Repository Analysis Skills)
  - Module and layer mapping (via Repository Analysis Skills)
  - System functionality documentation (via Instruction Management Skills)
  - Engineering principle definition (via Instruction Management Skills)
  - Architecture guideline documentation (via Documentation Skills)
  - Infrastructure standards specification (via Documentation Skills)
  - Language & coding convention enforcement (via Validation Skills)
  - Repository governance definition (via Instruction Management Skills)
  - Agent behavioral rule enforcement (via Validation Skills)
  - Cross-reference validation (via Validation Skills)
  - Sync validation reporting (via Output Generation Skills)
  - Amendment tracking with MAJOR/MINOR/PATCH versioning (via Version Management Skills)
  - Dependent file synchronization (via Documentation Skills)
- **Skills Categories**:
  1. Repository Analysis Skills
  2. Instruction Management Skills
  3. Validation Skills
  4. Documentation Skills
  5. Version Management Skills
  6. Output Generation Skills
