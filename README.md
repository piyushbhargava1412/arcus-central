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

## Documentation

- [Integration Guide](APEX_INTEGRATION_GUIDE.md) — Full setup and usage details
- [Repository Structure](STRUCTURE.md) — Central repo layout
- [Docs Index](docs/INDEX.md) — All documentation
