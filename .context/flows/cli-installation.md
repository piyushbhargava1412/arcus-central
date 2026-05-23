# Flow: CLI Installation

<!-- arcus-context-meta
verification-commit: cc8d06ae9d0ee4b6a897ab41851e297f4df63e9e
generated-at: 2026-05-23T12:11:28Z
confidence: high
-->

---

## Summary

A developer runs `install-cli.sh` once from inside the ARCUS Central repository to register a global `arcus-integrate` command at `/usr/local/bin/arcus-integrate`. After installation, users in any target repository can invoke the command without specifying the central repo path.

## Entry Point

- `install-cli.sh` — run directly from inside the `arcus-central` repo

## Execution Path

```
./install-cli.sh
  ├── Validate integrate.sh exists in CENTRAL_REPO
  ├── Create a temporary wrapper script:
  │     #!/bin/bash
  │     ARCUS_CENTRAL="<absolute-path-to-central>"
  │     exec bash "$ARCUS_CENTRAL/integrate.sh" "$(pwd)" "$@"
  ├── chmod +x on wrapper
  ├── Move wrapper to /usr/local/bin/arcus-integrate (sudo if needed)
  └── Verify: command -v arcus-integrate succeeds
```

## Scope

- `install-cli.sh` — sole implementor of this flow

## Notes

- The installed wrapper hardcodes `ARCUS_CENTRAL` as an absolute path at install time
- If the central repo is moved, the CLI must be reinstalled
- Removal: `uninstall.sh` or manually deleting `/usr/local/bin/arcus-integrate`
