# otto_apex-central

Central SDD repository providing refined and hardened agents, prompts, templates, scripts, and constitution layers that can be integrated with any repository for spec-driven development.

## Quick Start

```bash
# 1. Clone this repo (once per machine)
git clone <central-repo-url> ~/speckit-central

# 2. Install the CLI command (once per machine)
cd ~/speckit-central
./install-cli.sh

# 3. Integrate any target repo
cd ~/projects/my-service
speckit-integrate
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
