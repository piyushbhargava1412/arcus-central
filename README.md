# APEX Central - Spec Driven Development Framework

Central **SDD (Spec Driven Development)** repository providing refined and hardened agents, prompts, templates, scripts, and instruction architecture that can be integrated with any repository for spec-driven development.

**APEX** is the team. **SDD** is the methodology. This framework distributes the SDD methodology to any codebase.

## Quick Start

```bash
# 1. Clone this repo (once per machine)
git clone <central-repo-url> ~/apex-central

# 2. Install the CLI command (once per machine)
cd ~/apex-central
./install-cli.sh

# 3. Integrate any target repo with SDD framework
cd ~/projects/my-service
apex-integrate
```

## CLI Commands

| Command                 | Description |
|-------------------------|-------------|
| `apex-integrate`        | Integrate current directory |
| `apex-integrate --sync` | Re-sync all symlinks |
| `apex-integrate --yes`  | Non-interactive (CI/CD) |

## Project Structure

**Agents** → Business logic for SDD workflow  
**Skills** → Reusable infrastructure (paths, templates, validation)  
**Templates** → Document templates for specs, plans, tasks  
**Prompts** → Integration with repo-intelligence (minimal - redirects to agents)  
**Instructions** → Engineering and architecture guidelines  

## Key Files

- [Integration Guide](APEX_INTEGRATION_GUIDE.md) — Full setup and usage
- [Repository Structure](STRUCTURE.md) — Central repo layout
- [Agent Registry](registry/AGENT_REGISTRY.md) — All agents and skills 
