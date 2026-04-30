# ARCUS Central - Spec Driven Development Framework

Central **SDD (Spec Driven Development)** repository providing refined and hardened agents, prompts, templates, scripts, and instruction architecture that can be integrated with any repository for spec-driven development.

**ARCUS** is the initiative (Any Repository Can Use SDD). **SDD** is the methodology. This framework distributes the SDD methodology to any codebase.

## Quick Start

```bash
# 1. Clone this repo (once per machine)
git clone <central-repo-url> ~/arcus-central

# 2. Install the CLI command (once per machine)
cd ~/arcus-central
./install-cli.sh

# 3. Integrate any target repo with SDD framework
cd ~/projects/my-service
arcus-integrate
```

## CLI Commands

| Command                    | Description                 |
|----------------------------|-----------------------------|
| `arcus-integrate`          | Integrate current directory |
| `arcus-integrate --sync`   | Re-sync all symlinks        |
| `arcus-integrate --remove` | Remove all copied files     |
| `arcus-integrate --yes`    | Non-interactive (CI/CD)     |

## Project Structure

**Agents** → Business logic for SDD workflow  
**Skills** → Reusable, focused capabilities used by agents. Each Skill implements a small unit of functionality (e.g., path and template resolution, repository analysis, markdown generation/validation, session bootstrap, quality gates, and formatting). Skills are the building blocks agents call to perform specific tasks across repositories.
**Templates** → Document templates for specs, plans, tasks  
**Prompts** → Provides purpose and bounds to associated agents   
**Guidelines** → Engineering and architecture guidelines  

## Key Files

- [Integration Guide](ARCUS_INTEGRATION_GUIDE.md) — Full setup and usage
- [Repository Structure](.context/repo_map.md) — Central repo layout and navigation
- [Agent Registry](registry/AGENT_REGISTRY.md) — All agents and workflow
- [Skill Registry](registry/SKILLS_REGISTRY.md) — All skills and domains 
