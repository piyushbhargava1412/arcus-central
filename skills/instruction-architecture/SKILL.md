---
name: instruction-architecture
description: Skills reference for instruction architecture management - provides detailed capabilities for repository analysis, instruction management, validation, documentation, version management, and output generation.
---

# Instruction Architecture Skills

This document defines the core capabilities and skills for creating and maintaining copilot instruction architecture, including repository analysis, instruction management, validation, documentation, version management, and output generation.

**Note**: This file is deployed to `.github/skills/instruction-architecture/SKILL.md` in target repositories for Copilot Skills discovery.

---

## Skill Categories

### 1. Repository Analysis Skills

#### 1.1 Ignore Pattern Processing

- **Check for .apex-ignore File**: Locate and read `.apex-ignore` file in project root
- **Parse Ignore Patterns**: Interpret gitignore-style syntax patterns
- **Apply Exclusion Filters**: Filter out all matching files and folders from analysis
- **Validate No Ignored References**: Ensure no ignored paths are mentioned in outputs

**Critical Rules**:

- Completely exclude matching files/folders from analysis
- Treat ignored paths as if they don't exist in the repository
- Common patterns: `node_modules/`, `dist/`, `.git/`, `build/`, `vendor/`, `.github/agents/`, `.apex/`

#### 1.2 Repository Structure Analysis

- **Scan Directory Tree**: Traverse repository structure respecting ignore patterns
- **Identify Modules**: Recognize application modules in non-ignored paths
- **Detect Architecture Style**: Infer architecture from actual code structure
- **Map Features to Modules**: Link implemented features to responsible modules
- **Extract Technology Stack**: Identify languages, frameworks, and tools from actual code

**Critical Rules**:

- ONLY document what actually exists (NEVER guess or assume)
- If no codebase found: Document as "No application code found"
- Respect existing architecture—do NOT violate module boundaries
- Distinguish between application code and framework/tooling code

#### 1.3 Codebase Classification

- **Classify Project Stage**: Determine if initial setup, active development, or no application code
- **Identify Architecture Pattern**: Recognize microservices, monolith, layered, etc.
- **List Application Modules**: Enumerate only APPLICATION modules (exclude framework paths)
- **Catalog Features**: Document only features with actual implementation

---

### 2. Instruction Management Skills

#### 2.1 Load and Parse Instructions

- **Read copilot-instructions.md**: Load primary reference document from `.github/`
- **Parse Version Number**: Extract current version from header `**Version**: X.Y.Z`
- **Identify Section Structure**: Map all sections (Project Context, Engineering Principles, etc.)
- **Extract Amendment Log**: Parse version history table
- **Check Cross-References**: Verify links to dependent instruction files

#### 2.2 Analyze User Input

- **Extract Requirements**: Parse user-provided new principles or amendments
- **Determine Change Scope**: Classify what changed (add/modify/remove)
- **Assess Context**: Extract relevant requirements and constraints
- **Classify Version Bump**: Decide MAJOR/MINOR/PATCH based on changes

**Version Bump Rules**:

- **MAJOR**: Principle removal, fundamental redefinition, backward-incompatible changes
- **MINOR**: New principle added, new mandatory check introduced, expanded guidance
- **PATCH**: Clarifications, wording fixes, typo corrections, non-semantic refinements

#### 2.3 Update Instructions Content

- **Keep Minimal**: Maintain copilot-instructions.md as lightweight project-specific index
- **Reference, Don't Duplicate**: Link to instruction files instead of repeating content
- **Document Only Actual Implementation**: Never invent, assume, or speculate
- **Use N/A for Empty Sections**: If no real data exists, use "N/A" or "Not applicable"

**Content Classification**:

**DO Document (project-specific only)**:

- Project Context: Repository name, purpose, actual tech stack
- System Functionalities: ONLY application features from actual code
- Key Modules: ONLY application modules (NOT framework paths)

**DON'T Document (reference instead)**:

- Engineering Principles → reference `engineering-guidelines.md`
- Architecture Guidelines → reference `architecture-guidelines.md`
- Language Standards → reference `language-guidelines.md`
- Infrastructure → reference `infrastructure-guidelines.md`
- Testing → reference `testing-guidelines.md`
- Agents/Templates/Scripts → NEVER document (in .apex-ignore)

#### 2.4 Manage Amendment Log

- **Generate New Entry**: Create amendment table row with version, date, summary, type
- **Preserve History**: Maintain all previous amendments in chronological order
- **Validate Dates**: Ensure ISO format (YYYY-MM-DD)
- **Link Changes to Rationale**: Document why each change was made

---

### 3. Validation Skills

#### 3.1 Cross-Reference Validation

- **Validate Engineering Guidelines**: Check `instructions/engineering/engineering-guidelines.md` alignment
- **Validate Architecture Guidelines**: Verify `instructions/architecture/architecture-guidelines.md` consistency
- **Validate Language Guidelines**: Check `instructions/languages/language-guidelines.md` standards
- **Validate Infrastructure Guidelines**: Verify `instructions/infra/infrastructure-guidelines.md` rules
- **Validate Testing Guidelines**: Check `instructions/testing/testing-guidelines.md` expectations
- **Validate Templates**: Ensure spec, plan, and tasks templates align with instruction requirements
- **Validate Agent Registry**: Check `registry/AGENT_REGISTRY.md` agent references

**Validation Output**:

- Flag conflicts with "⚠" marker
- Report consistency with "✅" marker
- Identify missing cross-references
- Note file existence issues (in validation report only, NOT in copilot-instructions.md)

#### 3.2 Quality Checks

- **No Unexplained Bracket Tokens**: Ensure all `[...]` placeholders are resolved
- **All Required Sections Present**: Verify document completeness
- **Version Incremented Correctly**: Validate semantic versioning logic
- **Amendment Log Updated**: Confirm new entry added
- **Valid Cross-References**: Check all file paths point to existing files
- **Testable Principles**: Ensure principles are enforceable and measurable
- **No Circular Rules**: Verify governance rules don't contradict
- **Declarative Language**: Confirm MUST/SHOULD/MAY clearly marked

#### 3.3 Consistency Checks

- **No Principle Conflicts**: Ensure new principles don't contradict existing ones
- **Governance Alignment**: Verify rules align across all instruction files
- **Template Compatibility**: Check templates support instruction requirements
- **Agent Behavior Alignment**: Ensure agent rules match instruction expectations

---

### 4. Documentation Skills

#### 4.1 Generate Sync Validation Report

- **Document Version Change**: Show old → new with bump justification
- **List Section Changes**: Enumerate added/modified/removed sections
- **Count Principles**: Provide P1/P2/P3 breakdown
- **Reference Agents**: Count core + extension agents
- **Reference Templates**: List template files referenced
- **Review Dependencies**: Report validation results (✅ / ⚠)
- **Note TODOs**: Document deferred critical information

**Report Format**:

```
## Sync Validation Report

**Version Change**: X.Y.Z → A.B.C ([MAJOR|MINOR|PATCH])

**Sections Modified**:
- [Section Name] (added|modified|removed)

**Principles Updated**:
- [Count]: [P1] non-negotiable, [P2] mandatory, [P3] recommended

**Cross-Reference Validation**:
- [file.md] ✅ consistent / ⚠ requires attention

**Files Updated**:
- [list of files]

**Suggested Commit Message**:
docs(instructions): update copilot architecture vA.B.C - [summary]

**Next Steps**:
- [follow-up actions]
```

#### 4.2 Write Instruction Documents

- **Format Markdown Correctly**: Use proper headers, tables, lists
- **Apply Template Structure**: Follow instruction-template.md layout
- **Exclude Meta-Information**: Don't include validation status or file existence tables
- **Write Clean Content**: Only project-specific content, no framework details
- **Maintain Readability**: Use clear language, logical flow, proper spacing

#### 4.3 Update Dependent Files

- **Update Engineering Guidelines**: Add cross-references if principles changed
- **Update Core Agents**: Add governance links if governance changed
- **Update Prompts**: Add validation rules if enforcement changed
- **Document Changes**: Track which files were updated and why

---

### 5. Version Management Skills

#### 5.1 Semantic Versioning

- **Classify Change Impact**: Determine breaking vs. additive vs. fixes
- **Apply Version Rules**: Increment MAJOR.MINOR.PATCH correctly
- **Justify Version Bump**: Document rationale for version change
- **Preserve Version History**: Maintain complete amendment log

#### 5.2 Change Tracking

- **Compare Versions**: Identify differences between old and new
- **Document Changes**: Record what changed, why, and when
- **Link to Amendments**: Reference amendment log entries
- **Generate Commit Messages**: Create semantic commit messages

---

### 6. Output Generation Skills

#### 6.1 Produce Final Summary

- **Display Validation Report**: Show sync validation results to user
- **List Updated Files**: Enumerate all modified files
- **Suggest Commit Message**: Generate semantic commit message
- **Document Follow-up Actions**: List any required next steps
- **Confirm Readiness**: Validate instruction file is ready for agent use

#### 6.2 Format Output

- **Structure Report Clearly**: Use headers, lists, and formatting
- **Highlight Critical Items**: Mark important issues with "⚠"
- **Confirm Success**: Use "✅" for completed validations
- **Provide Actionable Next Steps**: Give clear guidance for next actions

---

## Skill Application Guidelines

### When to Use Each Skill

1. **Repository Analysis**: Always first step before any instruction creation/update
2. **Instruction Management**: Core workflow for loading, updating, and writing instructions
3. **Validation**: After every content change, before writing to file
4. **Documentation**: When producing reports or writing instruction documents
5. **Version Management**: Whenever instructions are modified
6. **Output Generation**: Final step to communicate results to user

### Skill Dependencies

- Repository Analysis → must complete before Instruction Management
- Instruction Management → must complete before Validation
- Validation → must complete before Documentation
- Documentation → prerequisites for Output Generation
- Version Management → runs in parallel with Instruction Management

### Success Criteria

- ✅ All ignore patterns respected
- ✅ Only actual implementation documented
- ✅ All cross-references validated
- ✅ Quality checks passed
- ✅ Version incremented correctly
- ✅ Amendment log updated
- ✅ Dependent files synchronized
- ✅ Validation report generated
