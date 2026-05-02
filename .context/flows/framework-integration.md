# Flow: Framework Integration

## Entry Points

- **CLI**: User runs `arcus-integrate` command in target repository root
- **Script**: Integration orchestrator invokes `integrate.sh` with optional flags (`--sync`, `--remove`, `--yes`)

## Core Path

### Phase 0: Pre-flight (Permission Setup)
- Set all central framework files `chmod a-w` (read-only at source)
- Ensures symlinks cannot be written through

### Phase 0.5: Cleanup (Sync Only)
- If `--sync` flag: Remove existing symlinks and copied agent/prompt files
- Preserve `.arcus/instructions/` (may be referenced in repo)
- Preserve `.arcus/` folder itself (custom local artifacts may exist)
- Do NOT overwrite `.arcus-ignore` (user-edited)

### Phase 1: Create Symlinks
- Create `.arcus/` directory (if missing)
- Create symlink `.arcus/templates` → central `templates/`
- Create symlink `.arcus/scripts` → central `scripts/`
- Create symlink `.arcus/instructions` → central `instructions/`
- Use relative paths for portability (symlinks work after repo moves)

### Phase 2: Copy Agent & Prompt Files
- Copy all agent files from `agents/core/` and `agents/extensions/` → `.github/agents/` (flat structure)
- Set copied agent files `chmod 444` (read-only)
- Copy all prompt files from `prompts/core/` and `prompts/extensions/` → `.github/prompts/` (flat structure)
- Set copied prompt files `chmod 444` (read-only)
- Reason: IntelliJ agent picker does not follow symlinks; must be real files

### Phase 2.5: Copy .arcus-ignore Template
- If `.arcus-ignore` does NOT exist in target repo:
  - Copy central `.arcus-ignore` template to target repo root
  - This template contains default ignore patterns for agent analysis
- If `.arcus-ignore` already exists:
  - Skip copy (preserve user-edited version)
  - This ensures re-running `arcus-integrate --sync` respects custom patterns

### Phase 3: Validation
- Verify all symlinks in `.arcus/` resolve correctly
- Verify copied agent/prompt files have `chmod 444` (read-only)
- Verify `.arcus-ignore` exists
- Exit with error if validation fails

### Phase 4: Metadata Write
- Write `.arcus-metadata.json` with:
  - Integration timestamp
  - Framework version (from central `VERSION` file)
  - Central repo path (absolute)
  - Integration flags used

## Data Touchpoints

| Data | Type | Direction | Purpose |
|------|------|-----------|---------|
| Central framework files | Files (R/O) | Central → Target | Templates, scripts, instructions |
| Agent definitions | Markdown | Central → Target | Copied to `.github/agents/` |
| Prompt definitions | Markdown | Central → Target | Copied to `.github/prompts/` |
| Skill definitions | Markdown | Central → Target | Symlinked in `.github/skills/` |
| `.arcus-ignore` | Config | Central → Target | Copied once; never overwritten |
| `.arcus-metadata.json` | Metadata | Target (written) | Records integration state |

## Integrations

- **CLI Interface**: User invokes via `arcus-integrate` shell command (installed by `install-cli.sh`)
- **Bash/Shell**: Integration logic entirely in shell (`integrate.sh`)
- **Python 3**: Relative path calculation for portability
- **Git**: Framework versioning via `VERSION` file

## Scope

| Scope | Files |
|-------|-------|
| **Central Framework Location** | Root of bigfin_arcus-central |
| **Integration Script** | `integrate.sh`, `install-cli.sh`, `uninstall.sh` |
| **Framework Components** | All in `agents/`, `prompts/`, `skills/`, `templates/`, `instructions/`, `scripts/`, `registry/` |
| **Target Repo Structure** | `.arcus/`, `.github/agents/`, `.github/prompts/`, `.github/skills/`, `.arcus-ignore`, `.arcus-metadata.json` |
| **Ignore Patterns** | `.arcus-ignore` (applied during repository analysis by agents) |

## Tests

- **Integration validation**: Phase 3 checks symlinks resolve and permissions are set
- **Smoke test**: User can run `arcus-integrate --help` to verify CLI is installed
- **End-to-end**: User invokes `/sdd.specify` in Copilot after integration; agent should find `.context/repo_scope.md`, `.context/repo_map.md`

## Verification

**commit**: Unknown (framework repo; commit tracking not in scope)  
**confidence**: HIGH

Evidence:
- `integrate.sh` with explicit phases and validation gates
- `ARCUS_INTEGRATION_GUIDE.md` documents the entire process
- `.arcus-metadata.json` records integration state
- Symlink structure and file permissions enforce immutability

---

## Related Flows

- [Agent Execution](agent-execution.md) — How agents run in target repos after integration
- [Skill Delegation](skill-delegation.md) — How agents call skills
- [Context Building](context-building.md) — How repository context is discovered and persisted

