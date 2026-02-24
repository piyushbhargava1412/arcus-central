#!/bin/bash

# integrate.sh — Speckit Central Integration Script v2.1
#
# Integrates the central Speckit framework into a target repository by creating:
#
#   .speckit/              — Templates, scripts, instructions (not discovered by IDE)
#   .github/agents/        — Flat file symlinks for IntelliJ/VS Code Copilot agent discovery
#   .github/prompts/       — Flat file symlinks for IntelliJ/VS Code Copilot prompt discovery
#   .github/copilot-instructions.md — Constitution linked as global Copilot instructions
#
# No duplication: agents & prompts live ONLY in .github/ (IDE discovery).
# Templates, scripts, instructions live ONLY in .speckit/ (framework access).
#
# Usage:
#   ./integrate.sh <target-repo-path> [central-repo-path]
#   ./integrate.sh <target-repo-path>                       (auto-detects central from script location)
#   ./integrate.sh --help
#
# Examples:
#   ./integrate.sh /Users/swetha/Desktop/developer-joyofenergy-java
#   ./integrate.sh /Users/swetha/Desktop/developer-joyofenergy-java /Users/swetha/Desktop/otto_speckit-central
#   ./integrate.sh /Users/swetha/Desktop/developer-joyofenergy-java --yes

set -e

# ─── Help ─────────────────────────────────────────────────────────
show_help() {
    cat <<'HELP'
Usage: ./integrate.sh <target-repo-path> [central-repo-path] [options]

Integrates the central Speckit framework into a target repository so that
IntelliJ IDEA and VS Code with GitHub Copilot can discover all agents and prompts.

Arguments:
  target-repo-path    Path to the project repository to integrate
  central-repo-path   Path to otto_speckit-central (default: auto-detected from script location)

Options:
  -h, --help          Show this help message
  -y, --yes           Skip confirmation prompts (for CI/CD)

What gets created in the target repo:

  .speckit/                              Directory symlinks (no agents/prompts here)
    ├── templates    → central/templates
    ├── scripts      → central/scripts
    └── instructions → central/instructions

  .github/                               Flat file symlinks (IDE discovery)
    ├── copilot-instructions.md          → constitution agent (global Copilot context)
    ├── agents/
    │   ├── speckit.analyze.agent.md     → central agent files (flat)
    │   ├── speckit.clarify.agent.md
    │   └── ...
    └── prompts/
        ├── speckit.analyze.prompt.md    → central prompt files (flat)
        ├── speckit.clarify.prompt.md
        └── ...

Why this split?
  .speckit/  — Templates, scripts, instructions that the IDE does not need to discover
  .github/   — Agents and prompts that IntelliJ/VS Code Copilot scans for discovery
               (requires FLAT structure — no core/extensions/ subdirectories)
HELP
    exit 0
}

# ─── Parse arguments ──────────────────────────────────────────────
AUTO_YES=false
POSITIONAL_ARGS=()
for arg in "$@"; do
    case "$arg" in
        -h|--help) show_help ;;
        -y|--yes)  AUTO_YES=true ;;
        *)         POSITIONAL_ARGS+=("$arg") ;;
    esac
done

# ─── Colors ───────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ─── Resolve central repo from script location ───────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# If script is in scripts/bash/, central is two levels up
# If script is at repo root, central is the script dir itself
if [[ "$(basename "$SCRIPT_DIR")" == "bash" && "$(basename "$(dirname "$SCRIPT_DIR")")" == "scripts" ]]; then
    SCRIPT_CENTRAL="$(cd "$SCRIPT_DIR/../.." && pwd)"
else
    SCRIPT_CENTRAL="$SCRIPT_DIR"
fi

# ─── Configuration ────────────────────────────────────────────────
TARGET_REPO="${POSITIONAL_ARGS[0]:-.}"
CENTRAL_REPO="${POSITIONAL_ARGS[1]:-$SCRIPT_CENTRAL}"
SPECKIT_DIR=".speckit"

# ─── Resolve absolute paths FIRST (before any file operations) ────
if [[ ! -d "$TARGET_REPO" ]]; then
    echo -e "${RED}[ERROR]${NC} Target repository not found: $TARGET_REPO"
    exit 1
fi
if [[ ! -d "$CENTRAL_REPO" ]]; then
    echo -e "${RED}[ERROR]${NC} Central repository not found: $CENTRAL_REPO"
    exit 1
fi

TARGET_REPO=$(cd "$TARGET_REPO" && pwd)
CENTRAL_REPO=$(cd "$CENTRAL_REPO" && pwd)
LOG_FILE="${TARGET_REPO}/speckit-integration.log"

# ─── Helper functions ─────────────────────────────────────────────
log()     { echo -e "${GREEN}[INFO]${NC} $1"    | tee -a "$LOG_FILE"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"     | tee -a "$LOG_FILE"; exit 1; }
warning() { echo -e "${YELLOW}[WARN]${NC} $1"   | tee -a "$LOG_FILE"; }
success() { echo -e "${GREEN}[OK]${NC} $1"      | tee -a "$LOG_FILE"; }
info()    { echo -e "${BLUE}[DEBUG]${NC} $1"     | tee -a "$LOG_FILE"; }

confirm_or_skip() {
    if [[ "$AUTO_YES" == true ]]; then return 0; fi
    read -p "$1 (y/n) " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

get_relative_path() {
    python3 -c "import os.path; print(os.path.relpath('$2', '$1'))"
}

# ─── Symlink helpers ──────────────────────────────────────────────
create_dir_symlink() {
    local target="$1"
    local link_name="$2"

    if [[ ! -d "$target" ]]; then
        warning "Source directory not found: $target"
        return 1
    fi

    if [[ -e "$link_name" ]] || [[ -L "$link_name" ]]; then
        if confirm_or_skip "  $(basename "$link_name") exists. Replace?"; then
            rm -rf "$link_name"
        else
            return 1
        fi
    fi

    local rel_path
    rel_path=$(get_relative_path "$(dirname "$link_name")" "$target")
    ln -s "$rel_path" "$link_name"
    info "Symlink: $(basename "$link_name") -> $rel_path"
}

create_file_symlink() {
    local target="$1"
    local link_name="$2"

    if [[ ! -f "$target" ]]; then
        warning "Source file not found: $target"
        return 1
    fi

    if [[ -e "$link_name" ]] || [[ -L "$link_name" ]]; then
        if confirm_or_skip "  $(basename "$link_name") exists. Replace?"; then
            rm -f "$link_name"
        else
            return 1
        fi
    fi

    local rel_path
    rel_path=$(get_relative_path "$(dirname "$link_name")" "$target")
    ln -s "$rel_path" "$link_name"
}

validate_symlink() {
    local link_path="$1"
    local label="$2"
    if [[ ! -L "$link_path" ]]; then
        warning "Not a symlink: $label"
        return 1
    fi
    if [[ ! -e "$link_path" ]]; then
        error "Broken symlink: $label -> $(readlink "$link_path")"
        return 1
    fi
    success "  ✓ $label -> $(readlink "$link_path")"
}

# ─── Validation ───────────────────────────────────────────────────
validate_central_structure() {
    local central_path="$1"
    local required_dirs=("agents" "prompts" "templates" "scripts" "instructions")

    for dir in "${required_dirs[@]}"; do
        if [[ ! -d "$central_path/$dir" ]]; then
            error "Missing required directory in central repo: $dir"
        fi
    done
    success "Central repo structure valid"
}

# ═══════════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════════
main() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║        Speckit Central Integration Script v2.1          ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo ""

    > "$LOG_FILE"

    log "Target:  $TARGET_REPO"
    log "Central: $CENTRAL_REPO"
    echo ""

    validate_central_structure "$CENTRAL_REPO"
    echo ""

    # ══════════════════════════════════════════════════════════════
    # PHASE 1: .speckit/ — Templates, scripts, instructions ONLY
    #          (agents & prompts go to .github/ in Phase 2)
    # ══════════════════════════════════════════════════════════════
    log "Phase 1: .speckit/ directory symlinks (templates, scripts, instructions)..."
    mkdir -p "$TARGET_REPO/$SPECKIT_DIR"

    local SPECKIT_DIRS=("templates" "scripts" "instructions")
    local speckit_count=0
    for name in "${SPECKIT_DIRS[@]}"; do
        if create_dir_symlink "$CENTRAL_REPO/$name" "$TARGET_REPO/$SPECKIT_DIR/$name"; then
            ((speckit_count++))
        fi
    done
    success "Phase 1 done: $speckit_count directory symlinks in .speckit/"
    echo ""

    # ══════════════════════════════════════════════════════════════
    # PHASE 2: .github/ — IDE Copilot discovery (flat file symlinks)
    #
    # IntelliJ and VS Code GitHub Copilot scan:
    #   .github/agents/*.agent.md       — agent definitions
    #   .github/prompts/*.prompt.md     — reusable prompts
    #   .github/copilot-instructions.md — global instructions
    #
    # They do NOT recurse into subdirectories (core/, extensions/).
    # So we create flat individual file symlinks.
    # ══════════════════════════════════════════════════════════════
    log "Phase 2: .github/ flat file symlinks (IDE Copilot discovery)..."
    mkdir -p "$TARGET_REPO/.github/agents"
    mkdir -p "$TARGET_REPO/.github/prompts"

    # 2a. Agent files — flatten core/ and extensions/ into .github/agents/
    local agent_count=0
    while IFS= read -r -d '' agent_file; do
        local filename
        filename=$(basename "$agent_file")
        if create_file_symlink "$agent_file" "$TARGET_REPO/.github/agents/$filename"; then
            ((agent_count++))
        fi
    done < <(find "$CENTRAL_REPO/agents" -name "*.agent.md" -print0 2>/dev/null)
    info "$agent_count agent files linked in .github/agents/"

    # 2b. Prompt files — flatten core/ and extensions/ into .github/prompts/
    local prompt_count=0
    while IFS= read -r -d '' prompt_file; do
        local filename
        filename=$(basename "$prompt_file")
        if create_file_symlink "$prompt_file" "$TARGET_REPO/.github/prompts/$filename"; then
            ((prompt_count++))
        fi
    done < <(find "$CENTRAL_REPO/prompts" -name "*.prompt.md" -print0 2>/dev/null)
    info "$prompt_count prompt files linked in .github/prompts/"

    # 2c. copilot-instructions.md — link constitution agent as global Copilot context
    local constitution="$CENTRAL_REPO/agents/core/speckit.constitution.agent.md"
    local copilot_instructions="$TARGET_REPO/.github/copilot-instructions.md"
    if [[ -f "$constitution" ]]; then
        create_file_symlink "$constitution" "$copilot_instructions"
        info "copilot-instructions.md -> constitution agent"
    else
        warning "Constitution agent not found at: $constitution"
    fi

    success "Phase 2 done: $agent_count agents, $prompt_count prompts, copilot-instructions.md"
    echo ""

    # ══════════════════════════════════════════════════════════════
    # PHASE 3: Validate all symlinks
    # ══════════════════════════════════════════════════════════════
    log "Phase 3: Validating symlinks..."
    echo ""

    log ".speckit/ directory symlinks:"
    for name in "${SPECKIT_DIRS[@]}"; do
        [[ -L "$TARGET_REPO/$SPECKIT_DIR/$name" ]] && \
            validate_symlink "$TARGET_REPO/$SPECKIT_DIR/$name" ".speckit/$name"
    done
    echo ""

    log ".github/agents/ file symlinks:"
    for symlink in "$TARGET_REPO/.github/agents"/*.agent.md; do
        [[ -L "$symlink" ]] && validate_symlink "$symlink" ".github/agents/$(basename "$symlink")"
    done
    echo ""

    log ".github/prompts/ file symlinks:"
    for symlink in "$TARGET_REPO/.github/prompts"/*.prompt.md; do
        [[ -L "$symlink" ]] && validate_symlink "$symlink" ".github/prompts/$(basename "$symlink")"
    done
    echo ""

    [[ -L "$copilot_instructions" ]] && \
        validate_symlink "$copilot_instructions" ".github/copilot-instructions.md"
    echo ""

    # ══════════════════════════════════════════════════════════════
    # PHASE 4: Metadata
    # ══════════════════════════════════════════════════════════════
    local metadata_file="$TARGET_REPO/.speckit-metadata.json"
    cat > "$metadata_file" << EOF
{
  "integrated_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "central_repo": "$CENTRAL_REPO",
  "central_repo_name": "$(basename "$CENTRAL_REPO")",
  "target_repo": "$TARGET_REPO",
  "target_repo_name": "$(basename "$TARGET_REPO")",
  "symlink_type": "relative",
  "framework": {
    "speckit_dir": "$SPECKIT_DIR",
    "templates": "$SPECKIT_DIR/templates",
    "scripts": "$SPECKIT_DIR/scripts",
    "instructions": "$SPECKIT_DIR/instructions"
  },
  "ide_discovery": {
    "copilot_instructions": ".github/copilot-instructions.md",
    "agents_dir": ".github/agents/",
    "prompts_dir": ".github/prompts/",
    "agent_count": $agent_count,
    "prompt_count": $prompt_count
  },
  "version": "2.1",
  "integration_status": "success"
}
EOF
    log "Metadata written: $metadata_file"
    echo ""

    # ══════════════════════════════════════════════════════════════
    # Summary
    # ══════════════════════════════════════════════════════════════
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                  INTEGRATION SUMMARY                    ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo ""
    printf "  Status:  ${GREEN}SUCCESS${NC}\n"
    printf "  Target:  %s\n" "$(basename "$TARGET_REPO")"
    printf "  Central: %s\n" "$(basename "$CENTRAL_REPO")"
    echo ""
    echo "  ── .speckit/ (full framework) ──"
    for name in "${SPECKIT_DIRS[@]}"; do
        [[ -L "$TARGET_REPO/$SPECKIT_DIR/$name" ]] && \
            printf "    ${GREEN}✓${NC} .speckit/%-15s -> %s\n" "$name" "$(readlink "$TARGET_REPO/$SPECKIT_DIR/$name")"
    done
    echo ""
    echo "  ── .github/ (IDE Copilot discovery) ──"
    [[ -L "$copilot_instructions" ]] && \
        printf "    ${GREEN}✓${NC} copilot-instructions.md\n"
    printf "    ${GREEN}✓${NC} agents/   (%d .agent.md files, flat)\n" "$agent_count"
    printf "    ${GREEN}✓${NC} prompts/  (%d .prompt.md files, flat)\n" "$prompt_count"
    echo ""
    echo "  ── Files ──"
    echo "    Metadata: $metadata_file"
    echo "    Log:      $LOG_FILE"
    echo ""
    echo "  ── How Copilot finds speckit ──"
    echo "    IntelliJ/VS Code scans .github/agents/ and .github/prompts/"
    echo "    Each speckit agent appears in the Copilot agent picker"
    echo "    copilot-instructions.md provides global context for all interactions"
    echo ""

    success "Integration complete."
}

main "$@"

