#!/bin/bash

# uninstall.sh — Remove the `arcus-integrate` CLI command
#
# Removes the globally installed SDD (Spec Driven Development) framework integration command.
#
# Usage:
#   cd bigfin_arcus-central
#   ./uninstall.sh

set -e

GREEN='\033[0;32m'
NC='\033[0m'

INSTALL_DIR="/usr/local/bin"
COMMAND_NAME="arcus-integrate"

# ─── Uninstall ────────────────────────────────────────────────────
if [[ -f "$INSTALL_DIR/$COMMAND_NAME" ]]; then
    sudo rm -f "$INSTALL_DIR/$COMMAND_NAME"
    echo -e "${GREEN}✓${NC} '$COMMAND_NAME' removed."
else
    echo "Not installed."
fi
