#!/bin/bash

# integrate.sh — ARCUS SDD Framework Integration Script v5.0
#
# Distributes the SDD framework to a target repository.
# Run with --help for usage details.

set -e

# ─── Help ─────────────────────────────────────────────────────────
show_help() {
    cat <<'HELP'
Usage: integrate.sh [target-repo-path] [options]

Distributes the SDD framework to a target repository.

  .arcus/          → symlinks to central (templates, scripts, guidelines)
  .github/agents/ → read-only copies   (IntelliJ agent tab needs real files)
  .github/prompts/→ read-only copies   (IntelliJ agent tab needs real files)
  .arcus-ignore    → copied once        (tells agents which paths to skip)

Arguments:
  target-repo-path    Path to integrate (default: current directory)

Options:
  -h, --help          Show this help message
  -y, --yes           Skip confirmation prompts (for CI/CD)
  --sync              Re-create symlinks and re-copy agent/prompt files
  --remove            Remove managed integration artifacts (preserves .arcus/guidelines and .arcus/ directory)

Examples:
  cd my-project && ../bigfin_arcus-central/integrate.sh
  arcus-integrate --sync
  arcus-integrate --yes
  arcus-integrate --remove
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
SDD_DIR=".arcus"

# ─── Resolve absolute paths ──────────────────────────────────────
if [[ ! -d "$TARGET_REPO" ]]; then
    echo -e "${RED}[ERROR]${NC} Target repository not found: $TARGET_REPO"
    exit 1
fi

TARGET_REPO=$(cd "$TARGET_REPO" && pwd)

# Guard: don't integrate central into itself
#if [[ "$TARGET_REPO" == "$CENTRAL_REPO" ]]; then
#    echo -e "${RED}[ERROR]${NC} Cannot integrate central repo into itself."
#    echo "Run this script from inside your target project, or pass the target path:"
#    echo "  cd <your-project> && $0"
#    echo "  $0 <path-to-your-project>"
#    exit 1
#fi

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

# ─── Symlink helpers (for .arcus/) ─────────────────────────────────
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

# ─── Remove helpers (for cleanup/remove modes) ──────────────────
remove_md_files() {
    local dir="$1"
    local pattern="$2"
    local label="$3"
    local count=0
    if [[ -d "$dir" ]]; then
        while IFS= read -r -d '' file; do
            chmod u+w "$file" 2>/dev/null || true
            rm -f "$file"
            ((count++))
        done < <(find "$dir" \( -type f -o -type l \) -name "$pattern" -print0 2>/dev/null)
        if [[ "$count" -gt 0 ]]; then
            success "Removed: $count $label files from $(basename "$dir")/" >&2
        fi
    fi
    echo "$count"
}

validate_readonly_copies() {
    local dir="$1"
    local pattern="$2"
    local label="$3"
    log "$label:"
    for f in "$dir"/$pattern; do
        [[ -f "$f" ]] || continue
        if [[ -w "$f" ]]; then
            warning "  ⚠ $(basename "$f") (writable!)"
        else
            success "  ✓ $(basename "$f") (read-only)"
        fi
    done
    echo ""
}

# ─── Validation ───────────────────────────────────────────────────
validate_central_structure() {
     local central_path="$1"
     local required_dirs=("agents" "prompts" "skills" "templates" "scripts" "guidelines")
     for dir in "${required_dirs[@]}"; do
         if [[ ! -d "$central_path/$dir" ]]; then
             error "Missing required directory in central repo: $dir"
         fi
     done

     # Validate at least one skill folder with SKILL.md exists (flat structure)
     local skill_count=0
     # Find any SKILL.md directly under skills/{skill-name}/ (flat structure, no nested categories)
     while IFS= read -r -d '' skill_file; do
         ((skill_count++))
     done < <(find "$central_path/skills" -maxdepth 2 -type f -name "SKILL.md" -print0 2>/dev/null)

     if [[ $skill_count -eq 0 ]]; then
         error "No valid skills found (expected skills/{skill-name}/SKILL.md structure)"
     fi
     info "Found $skill_count skill(s)"

     success "Central repo structure valid"
 }

# ═══════════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════════
main() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════╗"
    if [[ "$REMOVE_MODE" == true ]]; then
        echo "║   ARCUS SDD Framework Integration v5.0 (REMOVE)          ║"
    elif [[ "$SYNC_MODE" == true ]]; then
        echo "║   ARCUS SDD Framework Integration v5.0 (SYNC)           ║"
    else
        echo "║   ARCUS SDD Framework Integration v5.0                  ║"
    fi
    echo "╚══════════════════════════════════════════════════════════╝"
    echo ""

    log "Target:  $(basename "$TARGET_REPO") ($TARGET_REPO)"
    log "Central: $(basename "$CENTRAL_REPO") ($CENTRAL_REPO)"
    log "Mode:    $(if [[ "$SYNC_MODE" == true ]]; then echo "SYNC"; else echo "INTEGRATE"; fi)"
    echo ""

    validate_central_structure "$CENTRAL_REPO"
    echo ""

    # ═════════════════════════════════════════════════════════════=
    # PHASE 1: .arcus/ — SYMLINKS for templates, scripts, guidelines
    # ═════════════════════════════════════════════════════════════=
    if [[ "$REMOVE_MODE" == true ]]; then
        log "Removing integration artifacts..."
        local removal_count=0

        # Remove symlinked directories inside .arcus/ (but preserve .arcus/ folder itself)
        # DO NOT remove .arcus/guidelines/ — developers may reference it in their copilot-instructions.md
        # Developers may have created local artifacts in .arcus/ that they want to keep
        local symlink_dirs=("templates" "scripts")
        for symdir in "${symlink_dirs[@]}"; do
            local sympath="$TARGET_REPO/$SDD_DIR/$symdir"
            if [[ -L "$sympath" ]]; then
                rm -f "$sympath"
                ((removal_count++))
                success "Removed: .arcus/$symdir (symlink)"
            fi
        done

        # Remove .github/agents/ files
        local agent_removals
        agent_removals=$(remove_md_files "$TARGET_REPO/.github/agents" "*.agent.md" "agent")
        ((removal_count += agent_removals))

        # Remove .github/prompts/ files
        local prompt_removals
        prompt_removals=$(remove_md_files "$TARGET_REPO/.github/prompts" "*.prompt.md" "prompt")
        ((removal_count += prompt_removals))

         # Remove .github/skills/ files (SKILL.md files and registry)
         local skill_removals
         skill_removals=$(remove_md_files "$TARGET_REPO/.github/skills" "SKILL.md" "skill")
         ((removal_count += skill_removals))

         # Also remove SKILLS_REGISTRY.md
         if [[ -f "$TARGET_REPO/.github/skills/SKILLS_REGISTRY.md" ]]; then
             rm -f "$TARGET_REPO/.github/skills/SKILLS_REGISTRY.md"
             ((removal_count++))
             success "Removed: .github/skills/SKILLS_REGISTRY.md"
         fi

        # Remove .arcus-ignore
        if [[ -f "$TARGET_REPO/.arcus-ignore" ]]; then
            rm -f "$TARGET_REPO/.arcus-ignore"
            ((removal_count++))
            success "Removed: .arcus-ignore"
        fi

        # Remove .arcus-metadata.json
        if [[ -f "$TARGET_REPO/.arcus-metadata.json" ]]; then
            rm -f "$TARGET_REPO/.arcus-metadata.json"
            ((removal_count++))
            success "Removed: .arcus-metadata.json"
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
        info "Note: .arcus/ folder preserved (may contain local developer artifacts)"
        echo ""
        success "Removal complete."
        exit 0
    fi
    log "Phase 0: Setting central source files read-only..."
    local readonly_count=0
    for dir in agents prompts skills templates scripts guidelines; do
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

        # Remove .arcus/ symlinks
        for name in templates scripts guidelines; do
            if [[ -L "$TARGET_REPO/$SDD_DIR/$name" ]] || [[ -e "$TARGET_REPO/$SDD_DIR/$name" ]]; then
                rm -rf "${TARGET_REPO:?}/${SDD_DIR:?}/$name"
                ((cleanup_count++))
                info "Removed: .arcus/$name"
            fi
        done

        # Remove .github/agents/ files (could be old symlinks or copies)
        local agent_cleanup
        agent_cleanup=$(remove_md_files "$TARGET_REPO/.github/agents" "*.agent.md" "agent")
        ((cleanup_count += agent_cleanup))

        # Remove .github/prompts/ files (could be old symlinks or copies)
        local prompt_cleanup
        prompt_cleanup=$(remove_md_files "$TARGET_REPO/.github/prompts" "*.prompt.md" "prompt")
        ((cleanup_count += prompt_cleanup))

        # Remove .github/skills/ SKILL.md files
        local skill_cleanup
        skill_cleanup=$(remove_md_files "$TARGET_REPO/.github/skills" "SKILL.md" "skill")
        ((cleanup_count += skill_cleanup))

        # Remove metadata file
        if [[ -f "$TARGET_REPO/.arcus-metadata.json" ]]; then
            rm -f "$TARGET_REPO/.arcus-metadata.json"
            ((cleanup_count++))
            info "Removed: .arcus-metadata.json"
        fi

        success "Phase 0.5 done: $cleanup_count items cleaned up"
        echo ""
    fi

    # ══════════════════════════════════════════════════════════════
    # PHASE 1: .arcus/ — SYMLINKS for templates, scripts, guidelines
    # ══════════════════════════════════════════════════════════════
    log "Phase 1: .arcus/ directory symlinks..."
    mkdir -p "$TARGET_REPO/$SDD_DIR"

    local SDD_DIRS=("templates" "scripts" "guidelines")
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

    # Copy all prompt files so IDEs can discover them (no allowlist).
    local prompt_count=0
    while IFS= read -r -d '' prompt_file; do
        local filename
        filename=$(basename "$prompt_file")
        if copy_file_readonly "$prompt_file" "$TARGET_REPO/.github/prompts/$filename"; then
            ((prompt_count++))
        fi
    done < <(find "$CENTRAL_REPO/prompts" -name "*.prompt.md" -type f -print0 2>/dev/null)
    info "$prompt_count prompt files copied to .github/prompts/"

    # Skills registry: copy SKILLS_REGISTRY.md (single source of truth for runtime skill discovery)
    mkdir -p "$TARGET_REPO/.github/skills"
    if [[ -f "$CENTRAL_REPO/skills/SKILLS_REGISTRY.md" ]]; then
        if copy_file_readonly "$CENTRAL_REPO/skills/SKILLS_REGISTRY.md" "$TARGET_REPO/.github/skills/SKILLS_REGISTRY.md"; then
            success "Skills registry copied to .github/skills/"
        fi
    else
        warning "SKILLS_REGISTRY.md not found in central — skipping"
    fi

    # Skills: copy all skill folders (flat structure) to .github/skills/
    mkdir -p "$TARGET_REPO/.github/skills"
    local skill_count=0
    while IFS= read -r -d '' skill_dir; do
        local skill_name=$(basename "$skill_dir")
        local dst_skill_dir="$TARGET_REPO/.github/skills/$skill_name"

        # Remove existing skill folder if syncing
        if [[ -d "$dst_skill_dir" ]]; then
            rm -rf "$dst_skill_dir"
        fi

        # Copy entire skill folder
        mkdir -p "$dst_skill_dir"
        cp -r "$skill_dir"/* "$dst_skill_dir/" 2>/dev/null || true

        # Set all files in skill folder to read-only
        find "$dst_skill_dir" -type f -exec chmod 444 {} \;

        ((skill_count++))
    done < <(find "$CENTRAL_REPO/skills" -maxdepth 1 -type d -not -path "$CENTRAL_REPO/skills" -print0 2>/dev/null)
    info "$skill_count skill folders copied to .github/skills/ (flat structure)"

    success "Phase 2 done: $agent_count agents, $prompt_count prompts, $skill_count skills copied"
    echo ""

    # ═════════════════════════════════════════════════════════════=
    # PHASE 2.5: .arcus-ignore — copy template (only if not exists)
    # ═════════════════════════════════════════════════════════════=
    if [[ -f "$CENTRAL_REPO/.arcus-ignore" ]]; then
        if [[ -f "$TARGET_REPO/.arcus-ignore" ]]; then
            info ".arcus-ignore already exists in target — keeping existing (user may have customized)"
            arcus_ignore_copied=false
        else
            cp "$CENTRAL_REPO/.arcus-ignore" "$TARGET_REPO/.arcus-ignore"
            success "Copied .arcus-ignore template to target"
            arcus_ignore_copied=true
        fi
    else
        warning ".arcus-ignore not found in central repo — skipping"
        arcus_ignore_copied=false
    fi
    echo ""

    # ═════════════════════════════════════════════════════════════=
    # PHASE 2.6: Update .gitignore with ARCUS integration entries
    # ═════════════════════════════════════════════════════════════=
    log "Phase 2.6: Updating .gitignore..."
    local gitignore_file="$TARGET_REPO/.gitignore"

    # ARCUS entries to add
    local arcus_entries=(
        "### ARCUS Integration ###"
        ".arcus*"
        ".github/agents"
        ".github/prompts"
        ".github/skills"
    )

    # Create .gitignore if it doesn't exist
    if [[ ! -f "$gitignore_file" ]]; then
        touch "$gitignore_file"
        info "Created new .gitignore file"
    fi

    # Check if ARCUS section already exists
    if grep -q "### ARCUS Integration ###" "$gitignore_file" 2>/dev/null; then
        info ".gitignore already contains ARCUS Integration section — skipping"
    else
        # Add ARCUS entries to .gitignore
        {
            echo ""
            for entry in "${arcus_entries[@]}"; do
                echo "$entry"
            done
        } >> "$gitignore_file"
        success "Added ARCUS Integration entries to .gitignore"
    fi
    echo ""

    # ══════════════════════════════════════════════════════════════
    # PHASE 3: Validate
    # ══════════════════════════════════════════════════════════════
    log "Phase 3: Validating integration..."
    echo ""

    log ".arcus/ (symlinks):"
    for name in "${SDD_DIRS[@]}"; do
        [[ -L "$TARGET_REPO/$SDD_DIR/$name" ]] && \
            validate_symlink "$TARGET_REPO/$SDD_DIR/$name" ".arcus/$name"
    done
    echo ""

    validate_readonly_copies "$TARGET_REPO/.github/agents" "*.agent.md" ".github/agents/ (read-only copies)"
    validate_readonly_copies "$TARGET_REPO/.github/prompts" "*.prompt.md" ".github/prompts/ (read-only copies)"

    log ".github/skills/:"
    validate_readonly_copies "$TARGET_REPO/.github/skills" "SKILL.md" ".github/skills/ (read-only copies)"
    echo ""


    # ══════════════════════════════════════════════════════════════
    # PHASE 4: Metadata
    # ══════════════════════════════════════════════════════════════
    local metadata_file="$TARGET_REPO/.arcus-metadata.json"
    cat > "$metadata_file" << EOF
{
  "integrated_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "central_repo": "$(basename "$CENTRAL_REPO")",
  "target_repo": "$(basename "$TARGET_REPO")",
  "framework": "SDD (Spec Driven Development)",
  "team": "ARCUS",
  "integration_type": "hybrid (symlinks + read-only copies)",
  "flow": "pull (target runs central script)",
  "sdd_framework": {
    "sdd_dir": "$SDD_DIR",
    "templates": "$SDD_DIR/templates (symlink)",
    "scripts": "$SDD_DIR/scripts (symlink)",
    "guidelines": "$SDD_DIR/guidelines (symlink)"
  },
  "ide_discovery": {
    "agents_dir": ".github/agents/ (read-only copies)",
    "prompts_dir": ".github/prompts/ (read-only copies)",
    "skills_dir": ".github/skills/ (read-only copies)",
    "agent_count": $agent_count,
    "prompt_count": $prompt_count,
    "skill_count": $skill_count,
    "reason": "IntelliJ agent tab does not follow symlinks"
  },
  "arcus_ignore": {
    "file": ".arcus-ignore",
    "copied": $arcus_ignore_copied,
    "note": "Tells sdd.instructions agent which paths to skip during analysis"
  },
  "version": "5.0"
}
EOF
    log "Metadata: .arcus-metadata.json"
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
    echo "  ── .arcus/ (symlinks → central) ──"
    for name in "${SDD_DIRS[@]}"; do
        [[ -L "$TARGET_REPO/$SDD_DIR/$name" ]] && \
            printf "    ${GREEN}✓${NC} .arcus/%-15s -> %s\n" "$name" "$(readlink "$TARGET_REPO/$SDD_DIR/$name")"
    done
    echo ""
    echo "  ── .github/ (read-only copies for IDE) ──"
    printf "    ${GREEN}✓${NC} agents/   (%d files, chmod 444)\n" "$agent_count"
    printf "    ${GREEN}✓${NC} prompts/  (%d files, chmod 444)\n" "$prompt_count"
    printf "    ${GREEN}✓${NC} skills/   (%d files, chmod 444)\n" "$skill_count"
    echo ""
    if [[ "$arcus_ignore_copied" == true ]]; then
        echo "  ── Configuration ──"
        printf "    ${GREEN}✓${NC} .arcus-ignore (template copied)\n"
        echo ""
    fi
    echo "  ── How to use ──"
        echo "    Sync:    arcus-integrate --sync"
    echo "    .arcus/:  symlinks — instant central updates"
    echo "    .github: read-only copies — run --sync to update"
    echo ""

    success "Integration complete."
}

main "$@"
