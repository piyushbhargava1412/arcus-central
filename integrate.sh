#!/bin/bash

# integrate.sh — APEX SDD Framework Integration Script v5.0
#
# Distributes the SDD (Spec Driven Development) framework to target repos.
# Centralized pull-model integration.
#
# Strategy:
#   .apex/          → SYMLINKS (templates, scripts, instructions)
#                     Zero duplication, instant central updates.
#   .github/agents/ → READ-ONLY COPIES of agent files
#   .github/prompts/→ READ-ONLY COPIES of prompt files
#                     Copies required because IntelliJ agent tab
#                     does not follow symlinks for IDE discovery.
#   .apex-ignore    → COPIED (only if not already present)
#                     Tells sdd.instructions agent which paths to skip.
#
# Usage:
#   cd my-project && ../otto_apex-central/integrate.sh
#   apex-integrate              # if CLI installed
#   apex-integrate --sync       # re-sync everything
#   apex-integrate --yes        # non-interactive (CI/CD)

set -e

# ─── Help ─────────────────────────────────────────────────────────
show_help() {
    cat <<'HELP'
Usage: integrate.sh [target-repo-path] [options]

Distributes the SDD framework to a target repository.

  .apex/          → symlinks to central (templates, scripts, instructions)
  .github/agents/ → read-only copies   (IntelliJ agent tab needs real files)
  .github/prompts/→ read-only copies   (IntelliJ agent tab needs real files)
  .apex-ignore    → copied once        (tells agents which paths to skip)

Arguments:
  target-repo-path    Path to integrate (default: current directory)

Options:
  -h, --help          Show this help message
  -y, --yes           Skip confirmation prompts (for CI/CD)
  --sync              Re-create symlinks and re-copy agent/prompt files
  --remove            Remove all integration artifacts (.apex/, .github/agents, .github/prompts, .apex-ignore, .apex-metadata.json)

Examples:
  cd my-project && ../otto_apex-central/integrate.sh
  apex-integrate --sync
  apex-integrate --yes
  apex-integrate --remove
HELP
    exit 0
}

# ─── Parse arguments ──────────────────────────────────────────────
AUTO_YES=false
SYNC_MODE=false
REMOVE_MODE=false
POSITIONAL_ARGS=()
for arg in "$@"; do
    case "$arg" in
        -h|--help) show_help ;;
        -y|--yes)  AUTO_YES=true ;;
        --sync)    SYNC_MODE=true; AUTO_YES=true ;;
        --remove)  REMOVE_MODE=true; AUTO_YES=true ;;
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
SDD_DIR=".apex"

# ─── Resolve absolute paths ──────────────────────────────────────
if [[ ! -d "$TARGET_REPO" ]]; then
    echo -e "${RED}[ERROR]${NC} Target repository not found: $TARGET_REPO"
    exit 1
fi

TARGET_REPO=$(cd "$TARGET_REPO" && pwd)

# Guard: don't integrate central into itself
if [[ "$TARGET_REPO" == "$CENTRAL_REPO" ]]; then
    echo -e "${RED}[ERROR]${NC} Cannot integrate central repo into itself."
    echo "Run this script from inside your target project, or pass the target path:"
    echo "  cd <your-project> && $0"
    echo "  $0 <path-to-your-project>"
    exit 1
fi

# ─── Helper functions ─────────────────────────────────────────────
log()     { echo -e "${GREEN}[INFO]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }
warning() { echo -e "${YELLOW}[WARN]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
info()    { echo -e "${BLUE}[DEBUG]${NC} $1"; }

confirm_or_skip() {
    if [[ "$AUTO_YES" == true ]]; then return 0; fi
    read -p "$1 (y/n) " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

get_relative_path() {
    python3 -c "import os.path; print(os.path.relpath('$2', '$1'))"
}

# ─── Symlink helpers (for .apex/) ─────────────────────────────────
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

# ─── Copy helpers (for .github/agents & prompts) ─────────────────
copy_file_readonly() {
    local src_file="$1"
    local dst_file="$2"

    if [[ ! -f "$src_file" ]]; then
        warning "Source file not found: $src_file"
        return 1
    fi

    if [[ -e "$dst_file" ]] || [[ -L "$dst_file" ]]; then
        if confirm_or_skip "  $(basename "$dst_file") exists. Replace?"; then
            chmod u+w "$dst_file" 2>/dev/null || true
            rm -f "$dst_file"
        else
            return 1
        fi
    fi

    mkdir -p "$(dirname "$dst_file")"
    cp "$src_file" "$dst_file"
    chmod 444 "$dst_file"
    return 0
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
    if [[ "$REMOVE_MODE" == true ]]; then
        echo "║   APEX SDD Framework Integration v5.0 (REMOVE)          ║"
    elif [[ "$SYNC_MODE" == true ]]; then
        echo "║   APEX SDD Framework Integration v5.0 (SYNC)           ║"
    else
        echo "║   APEX SDD Framework Integration v5.0                  ║"
    fi
    echo "╚══════════════════════════════════════════════════════════╝"
    echo ""


    log "Target:  $(basename "$TARGET_REPO") ($TARGET_REPO)"
    log "Central: $(basename "$CENTRAL_REPO") ($CENTRAL_REPO)"
    log "Mode:    $(if [[ "$SYNC_MODE" == true ]]; then echo "SYNC"; else echo "INTEGRATE"; fi)"
    echo ""

    validate_central_structure "$CENTRAL_REPO"
    echo ""

    # ══════════════════════════════════════════════════════════════
    # REMOVE MODE: Exit early if --remove flag was used
    # ══════════════════════════════════════════════════════════════
    if [[ "$REMOVE_MODE" == true ]]; then
        log "Removing integration artifacts..."
        local removal_count=0

        # Remove symlinked directories inside .apex/ (but preserve .apex/ folder itself)
        # DO NOT remove .apex/instructions/ — developers may reference it in their copilot-instructions.md
        # Developers may have created local artifacts in .apex/ that they want to keep
        local symlink_dirs=("templates" "scripts")
        for symdir in "${symlink_dirs[@]}"; do
            local sympath="$TARGET_REPO/$SDD_DIR/$symdir"
            if [[ -L "$sympath" ]]; then
                rm -f "$sympath"
                ((removal_count++))
                success "Removed: .apex/$symdir (symlink)"
            fi
        done

        # Remove .github/agents/ files
        if [[ -d "$TARGET_REPO/.github/agents" ]]; then
            local agent_removals=0
            while IFS= read -r -d '' file; do
                chmod u+w "$file" 2>/dev/null || true
                rm -f "$file"
                ((agent_removals++))
            done < <(find "$TARGET_REPO/.github/agents" -name "*.agent.md" -type f -print0 2>/dev/null)
            if [[ "$agent_removals" -gt 0 ]]; then
                ((removal_count += agent_removals))
                success "Removed: $agent_removals agent files from .github/agents/"
            fi
        fi

        # Remove .github/prompts/ files
        if [[ -d "$TARGET_REPO/.github/prompts" ]]; then
            local prompt_removals=0
            while IFS= read -r -d '' file; do
                chmod u+w "$file" 2>/dev/null || true
                rm -f "$file"
                ((prompt_removals++))
            done < <(find "$TARGET_REPO/.github/prompts" -name "*.prompt.md" -type f -print0 2>/dev/null)
            if [[ "$prompt_removals" -gt 0 ]]; then
                ((removal_count += prompt_removals))
                success "Removed: $prompt_removals prompt files from .github/prompts/"
            fi
        fi

        # Remove .apex-ignore
        if [[ -f "$TARGET_REPO/.apex-ignore" ]]; then
            rm -f "$TARGET_REPO/.apex-ignore"
            ((removal_count++))
            success "Removed: .apex-ignore"
        fi

        # Remove .apex-metadata.json
        if [[ -f "$TARGET_REPO/.apex-metadata.json" ]]; then
            rm -f "$TARGET_REPO/.apex-metadata.json"
            ((removal_count++))
            success "Removed: .apex-metadata.json"
        fi

        echo ""
        echo "╔══════════════════════════════════════════════════════════╗"
        echo "║                   REMOVAL SUMMARY                       ║"
        echo "╚══════════════════════════════════════════════════════════╝"
        echo ""
        printf "  Status:  ${GREEN}SUCCESS${NC}\n"
        printf "  Target:  %s\n" "$(basename "$TARGET_REPO")"
        echo ""
        printf "  ${GREEN}✓${NC} Removed $removal_count framework artifacts\n"
        echo ""
        info "Note: .apex/ folder preserved (may contain local developer artifacts)"
        echo ""
        success "Removal complete."
        exit 0
    fi
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
    # PHASE 0.5: Cleanup existing integration (if sync mode)
    # ══════════════════════════════════════════════════════════════
    if [[ "$SYNC_MODE" == true ]]; then
        log "Phase 0.5: Cleaning up existing integration artifacts..."
        local cleanup_count=0

        # Remove .apex/ symlinks
        for name in templates scripts instructions; do
            if [[ -L "$TARGET_REPO/$SDD_DIR/$name" ]] || [[ -e "$TARGET_REPO/$SDD_DIR/$name" ]]; then
                rm -rf "${TARGET_REPO:?}/${SDD_DIR:?}/$name"
                ((cleanup_count++))
                info "Removed: .apex/$name"
            fi
        done

        # Remove .github/agents/ files (could be old symlinks or copies)
        if [[ -d "$TARGET_REPO/.github/agents" ]]; then
            while IFS= read -r -d '' file; do
                chmod u+w "$file" 2>/dev/null || true
                rm -f "$file"
                ((cleanup_count++))
            done < <(find "$TARGET_REPO/.github/agents" \( -type f -o -type l \) -name "*.agent.md" -print0 2>/dev/null)
            if [[ "$cleanup_count" -gt 0 ]]; then
                info "Removed agent files from .github/agents/"
            fi
        fi

        # Remove .github/prompts/ files (could be old symlinks or copies)
        if [[ -d "$TARGET_REPO/.github/prompts" ]]; then
            while IFS= read -r -d '' file; do
                chmod u+w "$file" 2>/dev/null || true
                rm -f "$file"
                ((cleanup_count++))
            done < <(find "$TARGET_REPO/.github/prompts" \( -type f -o -type l \) -name "*.prompt.md" -print0 2>/dev/null)
            if [[ "$cleanup_count" -gt 0 ]]; then
                info "Removed prompt files from .github/prompts/"
            fi
        fi

        # Remove metadata file
        if [[ -f "$TARGET_REPO/.apex-metadata.json" ]]; then
            rm -f "$TARGET_REPO/.apex-metadata.json"
            ((cleanup_count++))
            info "Removed: .apex-metadata.json"
        fi

        success "Phase 0.5 done: $cleanup_count items cleaned up"
        echo ""
    fi

    # ══════════════════════════════════════════════════════════════
    # PHASE 1: .apex/ — SYMLINKS for templates, scripts, instructions
    # ══════════════════════════════════════════════════════════════
    log "Phase 1: .apex/ directory symlinks..."
    mkdir -p "$TARGET_REPO/$SDD_DIR"

    local SDD_DIRS=("templates" "scripts" "instructions")
    local sdd_count=0
    for name in "${SDD_DIRS[@]}"; do
        if create_dir_symlink "$CENTRAL_REPO/$name" "$TARGET_REPO/$SDD_DIR/$name"; then
            ((sdd_count++))
        fi
    done
    success "Phase 1 done: $sdd_count directory symlinks"
    echo ""

    # ══════════════════════════════════════════════════════════════
    # PHASE 2: .github/ — READ-ONLY COPIES for IDE agent discovery
    #          IntelliJ agent tab does NOT follow symlinks,
    #          so we must copy agent and prompt files here.
    # ══════════════════════════════════════════════════════════════
    log "Phase 2: .github/ read-only copies (IDE agent discovery)..."
    mkdir -p "$TARGET_REPO/.github/agents"
    mkdir -p "$TARGET_REPO/.github/prompts"

    local agent_count=0
    while IFS= read -r -d '' agent_file; do
        local filename
        filename=$(basename "$agent_file")
        if copy_file_readonly "$agent_file" "$TARGET_REPO/.github/agents/$filename"; then
            ((agent_count++))
        fi
    done < <(find "$CENTRAL_REPO/agents" -name "*.agent.md" -type f -print0 2>/dev/null)
    info "$agent_count agent files copied to .github/agents/"

    local prompt_count=0
    while IFS= read -r -d '' prompt_file; do
        local filename
        filename=$(basename "$prompt_file")
        if copy_file_readonly "$prompt_file" "$TARGET_REPO/.github/prompts/$filename"; then
            ((prompt_count++))
        fi
    done < <(find "$CENTRAL_REPO/prompts" -name "*.prompt.md" -type f -print0 2>/dev/null)
    info "$prompt_count prompt files copied to .github/prompts/"

    success "Phase 2 done: $agent_count agents, $prompt_count prompts"
    echo ""

    # ══════════════════════════════════════════════════════════════
    # PHASE 2.5: .apex-ignore — copy template (only if not exists)
    #            Users may customize this file, so never overwrite.
    # ══════════════════════════════════════════════════════════════
    local apex_ignore_copied=false
    if [[ -f "$CENTRAL_REPO/.apex-ignore" ]]; then
        if [[ -f "$TARGET_REPO/.apex-ignore" ]]; then
            info ".apex-ignore already exists in target — keeping existing (user may have customized)"
        else
            cp "$CENTRAL_REPO/.apex-ignore" "$TARGET_REPO/.apex-ignore"
            apex_ignore_copied=true
            success "Copied .apex-ignore template to target"
        fi
    else
        warning ".apex-ignore not found in central repo — skipping"
    fi
    echo ""

    # ══════════════════════════════════════════════════════════════
    # PHASE 2.6: Update .gitignore with APEX integration entries
    # ══════════════════════════════════════════════════════════════
    log "Phase 2.6: Updating .gitignore..."
    local gitignore_file="$TARGET_REPO/.gitignore"
    local gitignore_updated=false

    # APEX entries to add
    local apex_entries=(
        "### APEX Integration ###"
        ".apex-ignore"
        ".apex-metadata.json"
        ".apex/"
        ".github/"
        "sdd-integration.log"
    )

    # Create .gitignore if it doesn't exist
    if [[ ! -f "$gitignore_file" ]]; then
        touch "$gitignore_file"
        info "Created new .gitignore file"
    fi

    # Check if APEX section already exists
    if grep -q "### APEX Integration ###" "$gitignore_file" 2>/dev/null; then
        info ".gitignore already contains APEX Integration section — skipping"
    else
        # Add APEX entries to .gitignore
        {
            echo ""
            echo "### APEX Integration ###"
            echo ".apex-ignore"
            echo ".apex-metadata.json"
            echo ".apex/"
            echo ".github/"
            echo "sdd-integration.log"
        } >> "$gitignore_file"
        gitignore_updated=true
        success "Added APEX Integration entries to .gitignore"
    fi
    echo ""

    # ══════════════════════════════════════════════════════════════
    # PHASE 3: Validate
    # ══════════════════════════════════════════════════════════════
    log "Phase 3: Validating integration..."
    echo ""

    log ".apex/ (symlinks):"
    for name in "${SDD_DIRS[@]}"; do
        [[ -L "$TARGET_REPO/$SDD_DIR/$name" ]] && \
            validate_symlink "$TARGET_REPO/$SDD_DIR/$name" ".apex/$name"
    done
    echo ""

    log ".github/agents/ (read-only copies):"
    for f in "$TARGET_REPO/.github/agents"/*.agent.md; do
        [[ -f "$f" ]] || continue
        if [[ -w "$f" ]]; then
            warning "  ⚠ $(basename "$f") (writable!)"
        else
            success "  ✓ $(basename "$f") (read-only)"
        fi
    done
    echo ""

    log ".github/prompts/ (read-only copies):"
    for f in "$TARGET_REPO/.github/prompts"/*.prompt.md; do
        [[ -f "$f" ]] || continue
        if [[ -w "$f" ]]; then
            warning "  ⚠ $(basename "$f") (writable!)"
        else
            success "  ✓ $(basename "$f") (read-only)"
        fi
    done
    echo ""

    # ══════════════════════════════════════════════════════════════
    # PHASE 4: Metadata
    # ══════════════════════════════════════════════════════════════
    local metadata_file="$TARGET_REPO/.apex-metadata.json"
    cat > "$metadata_file" << EOF
{
  "integrated_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "central_repo": "$(basename "$CENTRAL_REPO")",
  "target_repo": "$(basename "$TARGET_REPO")",
  "framework": "SDD (Spec Driven Development)",
  "team": "APEX",
  "integration_type": "hybrid (symlinks + read-only copies)",
  "flow": "pull (target runs central script)",
  "sdd_framework": {
    "sdd_dir": "$SDD_DIR",
    "templates": "$SDD_DIR/templates (symlink)",
    "scripts": "$SDD_DIR/scripts (symlink)",
    "instructions": "$SDD_DIR/instructions (symlink)"
  },
  "ide_discovery": {
    "agents_dir": ".github/agents/ (read-only copies)",
    "prompts_dir": ".github/prompts/ (read-only copies)",
    "agent_count": $agent_count,
    "prompt_count": $prompt_count,
    "reason": "IntelliJ agent tab does not follow symlinks"
  },
  "apex_ignore": {
    "file": ".apex-ignore",
    "copied": $apex_ignore_copied,
    "note": "Tells sdd.instructions agent which paths to skip during analysis"
  },
  "version": "5.0"
}
EOF
    log "Metadata: .apex-metadata.json"
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
    echo "  ── .apex/ (symlinks → central) ──"
    for name in "${SDD_DIRS[@]}"; do
        [[ -L "$TARGET_REPO/$SDD_DIR/$name" ]] && \
            printf "    ${GREEN}✓${NC} .apex/%-15s -> %s\n" "$name" "$(readlink "$TARGET_REPO/$SDD_DIR/$name")"
    done
    echo ""
    echo "  ── .github/ (read-only copies for IDE) ──"
    printf "    ${GREEN}✓${NC} agents/   (%d files, chmod 444)\n" "$agent_count"
    printf "    ${GREEN}✓${NC} prompts/  (%d files, chmod 444)\n" "$prompt_count"
    echo ""
    if [[ "$apex_ignore_copied" == true ]]; then
        echo "  ── Configuration ──"
        printf "    ${GREEN}✓${NC} .apex-ignore (template copied)\n"
        echo ""
    fi
    echo "  ── How to use ──"
    echo "    Sync:    apex-integrate --sync"
    echo "    .apex/:  symlinks — instant central updates"
    echo "    .github: read-only copies — run --sync to update"
    echo ""

    success "Integration complete."
}

main "$@"
