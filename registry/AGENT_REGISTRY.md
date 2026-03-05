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
- **Reusable Skills**: Uses 3 reusable skills:
  - `repository-analysis/SKILL.md` - Repository analysis and ignore pattern processing (reusable by any agent)
  - `markdown-validation/SKILL.md` - Validate file paths, links, and markdown quality (reusable by any agent)
  - `markdown-generation/SKILL.md` - Format and structure markdown documents (reusable by any agent)
- **Deployment**: Skills deployed to `.github/skills/{skill-name}/SKILL.md` in target repos
- **Purpose**: Create or update the copilot instruction architecture and ensure all dependent components stay in sync with governance standards
- **Architecture**: Uses reusable skills for generic capabilities; instruction-specific procedures are inline in agent file
- **Key Capabilities**:
  - Repository structure analysis (via repository-analysis skill)
  - Ignore pattern processing (via repository-analysis skill)
  - Instruction file loading and parsing
  - Content classification and version management
  - Cross-reference validation (via markdown-validation skill)
  - Markdown formatting and generation (via markdown-generation skill)
  - Amendment log management
  - Semantic versioning (MAJOR/MINOR/PATCH)
  - Sync validation report generation
  - Dependent file updates
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
