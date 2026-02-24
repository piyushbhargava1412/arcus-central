#!/bin/bash

# integrate.sh — Speckit Central Integration Script v4.0
#
# Centralized pull-model integration. Target repos run THIS script
# to obtain Speckit framework files as read-only symlinks.
#
# How target repos use it (no local scripts needed):
#
#   cd my-project
#   ../otto_speckit-central/integrate.sh              # current dir = target
#   ../otto_speckit-central/integrate.sh --sync       # re-link latest
#   ../otto_speckit-central/integrate.sh --yes        # non-interactive
#
# Or via Makefile in target repo:
#   speckit:
#       ../otto_speckit-central/integrate.sh --yes
#
# Creates (all read-only symlinks):
#   .speckit/templates      → central/templates
#   .speckit/scripts        → central/scripts
#   .speckit/instructions   → central/instructions
#   .github/agents/*.md     → central agent files (flat)
#   .github/prompts/*.md    → central prompt files (flat)
#   .github/copilot-instructions.md → constitution agent
#
# One-way: Central → Target. Writes through symlinks are denied.

set -e

# ─── Help ─────────────────────────────────────────────────────────
show_help() {
    cat <<'HELP'
Usage: integrate.sh [target-repo-path] [options]

Pulls the Speckit framework into a target repository as read-only symlinks.
Central repo is always auto-detected from the script's own location.

Arguments:
  target-repo-path    Path to integrate (default: current directory)

Options:
  -h, --help          Show this help message
  -y, --yes           Skip confirmation prompts (for CI/CD)
  --sync              Re-create all symlinks (replaces existing)

How target repos use it (run from inside your project):

  # One-liner from any target repo
  ../otto_speckit-central/integrate.sh

  # Non-interactive
  ../otto_speckit-central/integrate.sh --yes

  # Re-sync latest
  ../otto_speckit-central/integrate.sh --sync

  # In your Makefile
  speckit:
      ../otto_speckit-central/integrate.sh --yes

  # Explicit target path (from anywhere)
  /path/to/otto_speckit-central/integrate.sh /path/to/my-project

What gets created (all read-only symlinks):

  .speckit/
    ├── templates    → central/templates
    ├── scripts      → central/scripts
    └── instructions → central/instructions

  .github/
    ├── copilot-instructions.md → constitution agent
    ├── agents/*.agent.md       → central agent files (flat)
    └── prompts/*.prompt.md     → central prompt files (flat)

Protection: Source files in central are set read-only (chmod a-w).
Writing through symlinks → "permission denied".
HELP
    exit 0
}

# ─── Parse arguments ──────────────────────────────────────────────
AUTO_YES=false
SYNC_MODE=false
POSITIONAL_ARGS=()
for arg in "$@"; do
    case "$arg" in
        -h|--help) show_help ;;
        -y|--yes)  AUTO_YES=true ;;
        --sync)    SYNC_MODE=true; AUTO_YES=true ;;
        *)         POSITIONAL_ARGS+=("$arg") ;;
    esac
done

# ─── Colors ───────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ─── Central repo = always derived from this script's location ────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ "$(basename "$SCRIPT_DIR")" == "bash" && "$(basename "$(dirname "$SCRIPT_DIR")")" == "scripts" ]]; then
    CENTRAL_REPO="$(cd "$SCRIPT_DIR/../.." && pwd)"
else
    CENTRAL_REPO="$SCRIPT_DIR"
fi

# ─── Target repo = first arg, or current working directory ────────
TARGET_REPO="${POSITIONAL_ARGS[0]:-.}"
SPECKIT_DIR=".speckit"

# ─── Resolve absolute paths ──────────────────────────────────────
if [[ ! -d "$TARGET_REPO" ]]; then
    echo -e "${RED}[ERROR]${NC} Target repository not found: $TARGET_REPO"
    exit 1
fi

TARGET_REPO=$(cd "$TARGET_REPO" && pwd)
LOG_FILE="${TARGET_REPO}/speckit-integration.log"

# Guard: don't integrate central into itself
if [[ "$TARGET_REPO" == "$CENTRAL_REPO" ]]; then
    echo -e "${RED}[ERROR]${NC} Cannot integrate central repo into itself."
    echo "Run this script from inside your target project, or pass the target path:"
    echo "  cd <your-project> && $0"
    echo "  $0 <path-to-your-project>"
    exit 1
fi

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
        warning "Broken symlink: $label -> $(readlink "$link_path")"
        return 1
    fi
    if [[ -d "$link_path" ]]; then
        local writable
        writable=$(find "$link_path" -type f -perm +0222 2>/dev/null | wc -l | tr -d ' ')
        if [[ "$writable" -eq 0 ]]; then
            success "  ✓ $label -> $(readlink "$link_path") (all files read-only)"
        else
            warning "  ⚠ $label -> $(readlink "$link_path") ($writable files still writable)"
        fi
        return 0
    fi
    if [[ -w "$link_path" ]]; then
        warning "  ⚠ $label (writable through symlink!)"
        return 1
    fi
    success "  ✓ $label -> $(readlink "$link_path") (read-only)"
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
    if [[ "$SYNC_MODE" == true ]]; then
        echo "║   Speckit Central Integration v4.0 (SYNC)               ║"
    else
        echo "║        Speckit Central Integration v4.0                 ║"
    fi
    echo "╚══════════════════════════════════════════════════════════╝"
    echo ""

    true > "$LOG_FILE"

    log "Target:  $(basename "$TARGET_REPO") ($TARGET_REPO)"
    log "Central: $(basename "$CENTRAL_REPO") ($CENTRAL_REPO)"
    log "Mode:    $(if [[ "$SYNC_MODE" == true ]]; then echo "SYNC (re-link)"; else echo "INTEGRATE (fresh)"; fi)"
    echo ""

    validate_central_structure "$CENTRAL_REPO"
    echo ""

    # ══════════════════════════════════════════════════════════════
    # PHASE 0: Make central source files read-only
    # ══════════════════════════════════════════════════════════════
    log "Phase 0: Setting central source files read-only..."
    local readonly_count=0
    for dir in agents prompts templates scripts instructions; do
        find "$CENTRAL_REPO/$dir" -type f -exec chmod a-w {} \;
        local cnt
        cnt=$(find "$CENTRAL_REPO/$dir" -type f | wc -l | tr -d ' ')
        readonly_count=$((readonly_count + cnt))
    done
    success "Phase 0 done: $readonly_count files set read-only in central"
    echo ""

    # ══════════════════════════════════════════════════════════════
    # PHASE 1: .speckit/ — Symlink templates, scripts, instructions
    # ══════════════════════════════════════════════════════════════
    log "Phase 1: .speckit/ directory symlinks..."
    mkdir -p "$TARGET_REPO/$SPECKIT_DIR"

    local SPECKIT_DIRS=("templates" "scripts" "instructions")
    local speckit_count=0
    for name in "${SPECKIT_DIRS[@]}"; do
        if create_dir_symlink "$CENTRAL_REPO/$name" "$TARGET_REPO/$SPECKIT_DIR/$name"; then
            ((speckit_count++))
        fi
    done
    success "Phase 1 done: $speckit_count directory symlinks"
    echo ""

    # ══════════════════════════════════════════════════════════════
    # PHASE 2: .github/ — Flat file symlinks for IDE discovery
    # ══════════════════════════════════════════════════════════════
    log "Phase 2: .github/ flat file symlinks (IDE Copilot discovery)..."
    mkdir -p "$TARGET_REPO/.github/agents"
    mkdir -p "$TARGET_REPO/.github/prompts"

    local agent_count=0
    while IFS= read -r -d '' agent_file; do
        local filename
        filename=$(basename "$agent_file")
        if create_file_symlink "$agent_file" "$TARGET_REPO/.github/agents/$filename"; then
            ((agent_count++))
        fi
    done < <(find "$CENTRAL_REPO/agents" -name "*.agent.md" -print0 2>/dev/null)
    info "$agent_count agent symlinks in .github/agents/"

    local prompt_count=0
    while IFS= read -r -d '' prompt_file; do
        local filename
        filename=$(basename "$prompt_file")
        if create_file_symlink "$prompt_file" "$TARGET_REPO/.github/prompts/$filename"; then
            ((prompt_count++))
        fi
    done < <(find "$CENTRAL_REPO/prompts" -name "*.prompt.md" -print0 2>/dev/null)
    info "$prompt_count prompt symlinks in .github/prompts/"

    local copilot_instructions="$TARGET_REPO/.github/copilot-instructions.md"
    local constitution="$CENTRAL_REPO/agents/core/speckit.constitution.agent.md"
    if [[ -f "$constitution" ]]; then
        create_file_symlink "$constitution" "$copilot_instructions"
        info "copilot-instructions.md -> constitution agent"
    else
        warning "Constitution agent not found: $constitution"
    fi

    success "Phase 2 done: $agent_count agents, $prompt_count prompts, copilot-instructions"
    echo ""

    # ══════════════════════════════════════════════════════════════
    # PHASE 3: Validate
    # ══════════════════════════════════════════════════════════════
    log "Phase 3: Validating symlinks and read-only protection..."
    echo ""

    log ".speckit/:"
    for name in "${SPECKIT_DIRS[@]}"; do
        [[ -L "$TARGET_REPO/$SPECKIT_DIR/$name" ]] && \
            validate_symlink "$TARGET_REPO/$SPECKIT_DIR/$name" ".speckit/$name"
    done
    echo ""

    log ".github/agents/:"
    for f in "$TARGET_REPO/.github/agents"/*.agent.md; do
        [[ -L "$f" ]] && validate_symlink "$f" ".github/agents/$(basename "$f")"
    done
    echo ""

    log ".github/prompts/:"
    for f in "$TARGET_REPO/.github/prompts"/*.prompt.md; do
        [[ -L "$f" ]] && validate_symlink "$f" ".github/prompts/$(basename "$f")"
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
  "central_repo": "$(basename "$CENTRAL_REPO")",
  "target_repo": "$(basename "$TARGET_REPO")",
  "integration_type": "symlink (read-only source)",
  "flow": "pull (target runs central script)",
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
  "version": "4.0"
}
EOF
    log "Metadata: .speckit-metadata.json"
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
    printf "  Type:    READ-ONLY SYMLINKS (pull model)\n"
    echo ""
    echo "  ── .speckit/ ──"
    for name in "${SPECKIT_DIRS[@]}"; do
        [[ -L "$TARGET_REPO/$SPECKIT_DIR/$name" ]] && \
            printf "    ${GREEN}✓${NC} .speckit/%-15s -> %s\n" "$name" "$(readlink "$TARGET_REPO/$SPECKIT_DIR/$name")"
    done
    echo ""
    echo "  ── .github/ (IDE discovery) ──"
    [[ -L "$copilot_instructions" ]] && \
        printf "    ${GREEN}✓${NC} copilot-instructions.md\n"
    printf "    ${GREEN}✓${NC} agents/   (%d symlinks)\n" "$agent_count"
    printf "    ${GREEN}✓${NC} prompts/  (%d symlinks)\n" "$prompt_count"
    echo ""
    echo "  ── How to use ──"
    echo "    Sync:  ../$(basename "$CENTRAL_REPO")/integrate.sh --sync"
    echo "    Write protection: all source files are read-only"
    echo "    Zero duplication: symlinks point to central"
    echo ""

    success "Integration complete."
}

main "$@"
