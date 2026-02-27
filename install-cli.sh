#!/bin/bash

# install-cli.sh — Install the `apex-integrate` CLI command globally
#
# Installs the SDD (Spec Driven Development) framework integration command.
# Run this ONCE from the central repo. After that, any target repo
# can simply run: apex-integrate
#
# Usage:
#   cd otto_apex-central
#   ./install-cli.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

INSTALL_DIR="/usr/local/bin"
COMMAND_NAME="apex-integrate"
CENTRAL_REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─── Validate ─────────────────────────────────────────────────────
if [[ ! -f "$CENTRAL_REPO/integrate.sh" ]]; then
    echo -e "${RED}[ERROR]${NC} integrate.sh not found. Run from inside the central repo."
    exit 1
fi

# ─── Create wrapper script ───────────────────────────────────────
TEMP_FILE=$(mktemp)

echo '#!/bin/bash' > "$TEMP_FILE"
echo "APEX_CENTRAL=\"$CENTRAL_REPO\"" >> "$TEMP_FILE"
echo 'exec bash "$APEX_CENTRAL/integrate.sh" "$(pwd)" "$@"' >> "$TEMP_FILE"

chmod +x "$TEMP_FILE"

if [[ -w "$INSTALL_DIR" ]]; then
    mv "$TEMP_FILE" "$INSTALL_DIR/$COMMAND_NAME"
else
    sudo mv "$TEMP_FILE" "$INSTALL_DIR/$COMMAND_NAME"
    sudo chmod +x "$INSTALL_DIR/$COMMAND_NAME"
fi

# ─── Verify ───────────────────────────────────────────────────────
if command -v "$COMMAND_NAME" &>/dev/null; then
    echo ""
    echo -e "${GREEN}✅ Installed!${NC}  You can now run from any target repo:"
    echo ""
    echo -e "    cd <your-project>"
    echo -e "    ${GREEN}apex-integrate${NC}          # integrate"
    echo -e "    ${GREEN}apex-integrate --sync${NC}   # re-sync"
    echo -e "    ${GREEN}apex-integrate --yes${NC}    # non-interactive"
    echo ""
else
    echo -e "${RED}❌ Install failed.${NC} Ensure $INSTALL_DIR is in your PATH."
    exit 1
fi

