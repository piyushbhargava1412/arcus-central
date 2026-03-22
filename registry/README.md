# Registry Folder — Framework Discovery & Integration Hub

**Purpose**: Central location for discovering, documenting, and integrating SDD framework components.

**Location**: `/registry/` in the central `otto_apex-central` repository

---

## What is the Registry Folder?

The registry folder serves as the **single source of truth for framework component discovery**. It helps developers, tools, and integration scripts understand:
- What agents are available and what they do
- What skills are available and how they relate to agents
- How to use the framework
- Version compatibility

---

## How Does It Support SDD Framework Deployment?

### 1. **Automated Integration & Discovery**

When integrating the framework into a target repository via `integrate.sh`:

```
target-repo$ apex-integrate

[Reads from central registry]
↓
Discovers all agents in AGENT_REGISTRY.md
↓
Discovers all skills in SKILLS_REGISTRY.md
↓
Validates skill dependencies
↓
Distributes agents, skills, and templates to target repo
↓
Creates `.apex-metadata.json` with integration info
```

### 2. **Onboarding & Documentation**

New developers joining a project read the registry first:
```
New Dev: "What agents can I use?"
↓
Opens: registry/AGENT_REGISTRY.md
↓
Sees all 9 agents with descriptions, roles, commands
↓
Sees the recommended workflow
↓
Ready to start using SDD process
```

### 3. **Tool & CLI Support**

Future CLI tools can programmatically read the registry:

```bash
# Hypothetical future usage
apex-framework list-agents        # reads AGENT_REGISTRY.md
apex-framework search-skill coverage-analysis   # reads SKILLS_REGISTRY.md
apex-framework validate-integration             # reads both for validation
apex-framework check-compatibility <version>    # version checks
```

### 4. **Version Compatibility**

The registry documents which versions of framework work with what:

```yaml
# Future extension: version tracking in registry
agents:
  sdd.specify:
    added_in: v1.0.0
    breaking_changes_in:
    deprecated_in:
    
skills:
  core/session-bootstrap:
    added_in: v1.0.0
    modified_in: [v1.0.1, v1.1.0]
    stable_since: v1.1.0
```

### 5. **Integration Validation**

`integrate.sh` can validate completeness:
```
Check: All agents in AGENT_REGISTRY.md exist in agents/
Check: All skills in SKILLS_REGISTRY.md exist in skills/
Check: No circular skill dependencies
Check: All referenced skills have valid I/O contracts
Check: Skill versions match framework version
✅ Integration validated
```

---

## Registry Structure

```
registry/
├── AGENT_REGISTRY.md         # 9 agents with skill chains and capabilities
├── SKILLS_REGISTRY.md        # 19 skills organized by domain
└── README.md                 # This file
```

---

## AGENT_REGISTRY.md

**What it contains**:
- All 9 agents (6 core + 3 extensions)
- Agent file paths and prompt paths
- Agent commands and purposes
- Agent roles (personas)
- Skill chains (ordered list of skills used by each agent)
- Key capabilities per agent
- Guardrails and constraints
- Typical SDD workflow diagram
- Registry statistics

**Who uses it**:
- Developers: to discover available agents
- Tools: to find agent file paths and commands
- Integration scripts: to validate agent presence

**Example entry**:
```markdown
### sdd.specify
- File: agents/core/sdd.specify.agent.md
- Command: /sdd.specify <feature description>
- Skill Chain:
  1. core/session-bootstrap
  2. specialized/spec/spec-authoring
  3. specialized/spec/ambiguity-detection
  4. core/quality-gates
  5. core/report-renderer
```

---

## SKILLS_REGISTRY.md

**What it contains**:
- All 19 skills organized by capability domain
- Skill file paths and purposes
- Skill inputs and outputs
- Which agents use each skill (reusability info)
- Reusability levels (🟢 core, 🟦 shared, 🟨 multi-use, 🟪 specialized)
- Skill responsibilities and capabilities
- Reusability matrices and statistics
- Overall skill ecosystem health

**Who uses it**:
- Developers: to find skills for a new stage
- Architects: to understand skill reusability and dependencies
- Tools: to validate skill presence and contracts
- Future stage developers: to reuse existing skills

**Example entry**:
```markdown
### core/session-bootstrap
- File: skills/core/session-bootstrap/SKILL.md
- Used By: All 6 core agents
- Reusability: ⭐⭐⭐⭐⭐ (6/6 agents)
- Key Responsibilities:
  - Extract story ID from user input
  - Build canonical feature directory path
  - Resolve template paths
```

---

## Key Information in Registries

### AGENT_REGISTRY.md provides

✅ **Discovery**: Find agents by name/command  
✅ **Capability matrix**: See what each agent does  
✅ **Skill dependencies**: See which skills each agent uses  
✅ **Workflow**: Understand the recommended SDD sequence  
✅ **Integration points**: Know which files to distribute  
✅ **Statistics**: Overall framework size and scope  

### SKILLS_REGISTRY.md provides

✅ **Reusability analysis**: Which skills work with multiple agents  
✅ **Capability domains**: Understand skill organization  
✅ **I/O contracts**: Know skill inputs and outputs  
✅ **Relationships**: Which agents use which skills  
✅ **Usage patterns**: See cross-stage dependencies  
✅ **Health metrics**: Overall skill ecosystem statistics  

---

## Why Two Registries?

**Option 1: Single registry** (agents only)
- ❌ Skills buried in agent descriptions
- ❌ Hard to find reusable skills
- ❌ No skill-to-skill relationships visible
- ❌ Discoverability problem for future stages

**Option 2: Separate registries** (agents + skills)
- ✅ Clear agent workflow discovery
- ✅ Clear skill reusability discovery
- ✅ Both can be read independently
- ✅ Tools can read skill ecosystem
- ✅ Easier to add new stages (just add to SKILLS_REGISTRY if reusing existing skills)
- ✅ Aligns with skills-first architecture

**We chose Option 2** because skills are now first-class framework components, not just utilities.

---

## How to Use the Registries

### As a Developer

**To start an SDD workflow:**
1. Open `registry/AGENT_REGISTRY.md`
2. See recommended workflow sequence
3. Read first agent (`sdd.specify`) description and command
4. Run `/sdd.specify <your feature description>`

**To understand a specific agent:**
1. Find agent in `AGENT_REGISTRY.md`
2. Read its purpose, role, and capabilities
3. See its skill chain (which skills it uses)
4. Check if skills are reusable (in `SKILLS_REGISTRY.md`)

**To understand skills for a new stage:**
1. Open `registry/SKILLS_REGISTRY.md`
2. Filter by reusability level (🟢 core = use always, 🟦 shared = reuse if applicable)
3. See which agents already use each skill
4. Decide which skills to reuse for your new stage

### As an Architect

**To evaluate skill reusability:**
1. Check `SKILLS_REGISTRY.md` reusability matrix
2. See which skills span multiple stages
3. Identify redundancy or gaps
4. Plan new skills or consolidations

**To understand framework health:**
1. Check statistics in both registries
2. Total agents: 9 (6 core + 3 extensions)
3. Total skills: 19 (13 reusable + 6 specialized)
4. Reusability: 68% of skills used by 2+ agents

### As a Tool/Integration Script

**To discover available agents:**
```
Read AGENT_REGISTRY.md
Extract agent list: specify, clarify, plan, tasks, analyze, implement, groom, instructions, repo-intelligence
For each agent, extract:
  - File path (agents/core/* or agents/extensions/*)
  - Skill chain (list of skills it uses)
```

**To discover available skills:**
```
Read SKILLS_REGISTRY.md
Extract skill list by domain: core (3), artifact (4), reasoning (4), interaction (1), formatting (1), specialized (6)
For each skill, extract:
  - File path (skills/domain/skill/)
  - I/O contract (inputs, outputs)
  - Used by (which agents)
```

**To validate framework integrity:**
```
For each agent in AGENT_REGISTRY:
  ✓ Check file exists at specified path
  ✓ Check prompt file exists
For each skill in skill chain:
  ✓ Check skill exists in SKILLS_REGISTRY
  ✓ Check skill file exists at specified path
For each skill in SKILLS_REGISTRY:
  ✓ Check "Used By" agents actually reference this skill
```

---

## Maintenance & Updates

### When to Update AGENT_REGISTRY.md

- ✅ New agent created (add entry)
- ✅ Agent command changes
- ✅ Agent skill chain changes
- ✅ Agent role or purpose changes

### When to Update SKILLS_REGISTRY.md

- ✅ New skill created (add entry)
- ✅ Skill moved to different domain folder
- ✅ Skill is now used by additional agent
- ✅ Skill I/O contract changes

### Update Frequency

- **Immediately**: When agents/skills change
- **Periodically (quarterly)**: Review reusability metrics and statistics

---

## Future Enhancements

The registries support future extensions:

### Planned Features

1. **Version tracking**: Record when skills/agents added, modified, deprecated
2. **Dependency graph**: Visualize skill-to-agent and skill-to-skill relationships
3. **Performance metrics**: Track average execution time per agent
4. **Compatibility matrix**: Track framework versions and compatibility
5. **Skill marketplace**: Community contributions to agent/skill registry
6. **Graphical dashboard**: UI for browsing registry and visualizing workflows

### Extensibility

Registries are markdown-based, so they support:
- YAML frontmatter for metadata
- Structured tables for relationships
- Embeddable diagrams (Mermaid)
- Version history (Git)
- Automated generation from agent/skill files

---

## Summary

The **registry folder is the framework's discovery hub** that helps developers and tools understand:

| Question | Answer Location |
|----------|-----------------|
| What agents can I use? | `AGENT_REGISTRY.md` |
| What workflow should I follow? | `AGENT_REGISTRY.md` workflow diagram |
| What skills are available? | `SKILLS_REGISTRY.md` |
| Is skill X reusable? | `SKILLS_REGISTRY.md` reusability matrix |
| Which agents use skill Y? | `SKILLS_REGISTRY.md` skill entry |
| Is this framework integrated? | Check if registry files are present |

The dual-registry approach supports **skills-first architecture** while maintaining **agent-centric workflow discovery**.

---

## See Also

- [AGENT_REGISTRY.md](./AGENT_REGISTRY.md) — Complete agent registry
- [SKILLS_REGISTRY.md](./SKILLS_REGISTRY.md) — Complete skills registry
- [../SKILLS_FOLDER_MIGRATION.md](../SKILLS_FOLDER_MIGRATION.md) — How skills are organized
- [../SKILLS_REUSABILITY_MATRIX.md](../SKILLS_REUSABILITY_MATRIX.md) — Detailed reusability analysis
