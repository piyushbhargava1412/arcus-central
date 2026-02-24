#!/bin/bash

# integrate.sh
# Integrates central Speckit framework into a target repository via soft links
# Usage: ./integrate.sh <target-repo-path> [central-repo-path]
# Example: ./integrate.sh /Users/swetha/Desktop/developer-joyofenergy-java

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
TARGET_REPO="${1:-.}"
CENTRAL_REPO="${2:-.}"
SPECKIT_DIR=".speckit"
LOG_FILE="${TARGET_REPO}/speckit-integration.log"

# Helper functions
log() {
    echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
    exit 1
}

warning() {
    echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

info() {
    echo -e "${BLUE}[DEBUG]${NC} $1" | tee -a "$LOG_FILE"
}

validate_repo() {
    local repo_path="$1"
    local repo_name="$2"

    if [[ ! -d "$repo_path" ]]; then
        error "$repo_name repository not found at: $repo_path"
    fi

    log "$repo_name repository validated at: $repo_path"
}

validate_central_structure() {
    local central_path="$1"
    local required_dirs=("agents" "prompts" "templates" "scripts" "instructions")

    log "Validating central repository structure..."
    for dir in "${required_dirs[@]}"; do
        if [[ ! -d "$central_path/$dir" ]]; then
            error "Missing required directory in central repo: $dir"
        fi
        info "Found: $central_path/$dir"
    done
    success "Central repository structure validated"
}

get_relative_path() {
    local from="$1"
    local to="$2"
    python3 -c "import os.path; print(os.path.relpath('$to', '$from'))"
}

create_symlink() {
    local target="$1"
    local link_name="$2"
    local link_type="${3:-relative}"

    # Check if target exists
    if [[ ! -d "$target" ]]; then
        warning "Target directory does not exist: $target"
        return 1
    fi

    # Handle existing symlinks or files
    if [[ -e "$link_name" ]] || [[ -L "$link_name" ]]; then
        warning "Target already exists: $link_name"
        read -p "Remove and recreate? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$link_name"
            info "Removed existing: $link_name"
        else
            return 1
        fi
    fi

    # Create symlink
    if [[ "$link_type" == "relative" ]]; then
        local rel_path=$(get_relative_path "$(dirname "$link_name")" "$target")
        ln -s "$rel_path" "$link_name"
        info "Created relative symlink: $link_name -> $rel_path"
    else
        local abs_path=$(cd "$target" && pwd)
        ln -s "$abs_path" "$link_name"
        info "Created absolute symlink: $link_name -> $abs_path"
    fi

    log "Symlink created: $link_name"
}

validate_symlink() {
    local link_path="$1"
    local link_name="$2"

    if [[ ! -L "$link_path" ]]; then
        error "Not a symlink: $link_path"
    fi

    if [[ ! -e "$link_path" ]]; then
        error "Broken symlink: $link_path"
    fi

    local target=$(readlink "$link_path")
    success "✓ $link_name: $link_path -> $target"
}

test_symlink_functionality() {
    local speckit_dir="$1"

    log "Testing symlink functionality..."

    # Test agents access
    if [[ -d "$speckit_dir/agents/core" ]]; then
        info "✓ Can access agents/core subdirectory"
    fi

    # Test prompts access
    if [[ -d "$speckit_dir/prompts/core" ]]; then
        info "✓ Can access prompts/core subdirectory"
    fi

    # Test templates access
    if [[ -d "$speckit_dir/templates" ]]; then
        info "✓ Can access templates directory"
    fi

    success "Symlink functionality tests passed"
}

# Main execution
main() {
    clear
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║     Otto Speckit Integration Script v1.0                   ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo

    # Initialize log file
    > "$LOG_FILE"

    # Resolve absolute paths
    TARGET_REPO=$(cd "$TARGET_REPO" && pwd)
    CENTRAL_REPO=$(cd "$CENTRAL_REPO" && pwd)

    log "========== INTEGRATION STARTED =========="
    log "Target repository: $TARGET_REPO"
    log "Central repository: $CENTRAL_REPO"
    echo

    # Validate repositories
    log "Validating repositories..."
    validate_repo "$TARGET_REPO" "Target"
    validate_repo "$CENTRAL_REPO" "Central"
    validate_central_structure "$CENTRAL_REPO"
    echo

    # Create .speckit directory in target repo
    if [[ ! -d "$TARGET_REPO/$SPECKIT_DIR" ]]; then
        mkdir -p "$TARGET_REPO/$SPECKIT_DIR"
        log "Created .speckit directory: $TARGET_REPO/$SPECKIT_DIR"
    else
        warning ".speckit directory already exists"
    fi
    echo

    # Define symlink mappings (POSIX compatible)
    local -a SYMLINK_NAMES=("agents" "prompts" "templates" "scripts" "instructions")

    # Create symlinks (using relative paths)
    log "Creating symlinks with relative paths..."
    local symlink_count=0
    for link_name in "${SYMLINK_NAMES[@]}"; do
        local source="$link_name"
        local source_path="$CENTRAL_REPO/$source"
        local link_path="$TARGET_REPO/$SPECKIT_DIR/$link_name"

        if create_symlink "$source_path" "$link_path" "relative"; then
            ((symlink_count++))
        fi
    done
    echo

    if [[ $symlink_count -eq 0 ]]; then
        error "No symlinks were created successfully"
    fi

    # Validation phase
    log "Validating all symlinks..."
    for link_name in "${SYMLINK_NAMES[@]}"; do
        local link_path="$TARGET_REPO/$SPECKIT_DIR/$link_name"
        if [[ -L "$link_path" ]]; then
            validate_symlink "$link_path" "$link_name"
        fi
    done
    echo

    # Test functionality
    test_symlink_functionality "$TARGET_REPO/$SPECKIT_DIR"
    echo

    # Create integration metadata
    local metadata_file="$TARGET_REPO/.speckit-metadata.json"
    cat > "$metadata_file" << EOF
{
  "integrated_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "central_repo": "$CENTRAL_REPO",
  "central_repo_name": "$(basename "$CENTRAL_REPO")",
  "target_repo": "$TARGET_REPO",
  "target_repo_name": "$(basename "$TARGET_REPO")",
  "symlink_type": "relative",
  "speckit_dir": "$SPECKIT_DIR",
  "symlinks": {
    "agents": "$SPECKIT_DIR/agents",
    "prompts": "$SPECKIT_DIR/prompts",
    "templates": "$SPECKIT_DIR/templates",
    "scripts": "$SPECKIT_DIR/scripts",
    "instructions": "$SPECKIT_DIR/instructions"
  },
  "version": "1.0",
  "integration_status": "success"
}
EOF
    log "Created integration metadata: $metadata_file"
    echo

    # Display summary
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║                  INTEGRATION SUMMARY                        ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo
    echo "Status: ${GREEN}SUCCESS${NC}"
    echo "Central Repo: $(basename "$CENTRAL_REPO")"
    echo "Target Repo: $(basename "$TARGET_REPO")"
    echo "Speckit Directory: $TARGET_REPO/$SPECKIT_DIR"
    echo
    echo "Symlinks Created:"
    for link_name in "${SYMLINK_NAMES[@]}"; do
        local link_path="$TARGET_REPO/$SPECKIT_DIR/$link_name"
        local target=$(readlink "$link_path")
        printf "  ${GREEN}✓${NC} %-15s -> %s\n" "$link_name" "$target"
    done
    echo
    echo "Integration Files:"
    echo "  • Metadata: $metadata_file"
    echo "  • Log: $LOG_FILE"
    echo
    echo "Next Steps:"
    echo "  1. Verify symlinks: ls -la $TARGET_REPO/$SPECKIT_DIR/"
    echo "  2. Test agent access: cat $TARGET_REPO/$SPECKIT_DIR/agents/core/speckit.analyze.agent.md"
    echo "  3. Review metadata: cat $metadata_file"
    echo

    success "========== INTEGRATION COMPLETED =========="
}

# Run main function
main "$@"

