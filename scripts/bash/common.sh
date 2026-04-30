#!/usr/bin/env bash
# Common functions and variables for all scripts

# Get repository root, with fallback for non-git repositories
get_repo_root() {
    if git rev-parse --show-toplevel >/dev/null 2>&1; then
        git rev-parse --show-toplevel
    else
        # Fall back to script location for non-git repos
        local script_dir
        script_dir="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        (cd "$script_dir/../../.." && pwd)
    fi
}

# Get current branch or story ID, with fallback for non-git repositories
get_current_branch() {
    # First check if SPECIFY_FEATURE environment variable is set (manual override)
    if [[ -n "${SPECIFY_FEATURE:-}" ]]; then
        echo "$SPECIFY_FEATURE"
        return
    fi

    # Then check git if available
    if git rev-parse --abbrev-ref HEAD >/dev/null 2>&1; then
        git rev-parse --abbrev-ref HEAD
        return
    fi

    # For non-git repos, find the most recently modified spec directory
    local repo_root
    repo_root=$(get_repo_root)
    local specs_dir="$repo_root/.arcus/specs"

    if [[ -d "$specs_dir" ]]; then
        # Return the most recently modified spec directory name
        local latest
        latest=$(ls -t "$specs_dir" 2>/dev/null | head -1)
        if [[ -n "$latest" ]]; then
            echo "$latest"
            return
        fi
    fi

    echo "main"  # Final fallback
}

# Check if we have git available
has_git() {
    git rev-parse --show-toplevel >/dev/null 2>&1
}

# Validate branch name — warn if it doesn't follow a recommended convention but never block
check_feature_branch() {
    local branch="$1"
    local has_git_repo="$2"

    # Require a git repository for branch validation
    if [[ "$has_git_repo" != "true" ]]; then
        echo "[arcus] WARNING: Git repository not detected; branch validation skipped." >&2
        return 0
    fi

    # Detect detached HEAD or missing branch
    if [[ -z "$branch" || "$branch" == "HEAD" ]]; then
        echo "ERROR: Detached HEAD or no branch detected. Please checkout a feature branch." >&2
        return 1
    fi

    # main / master / develop are not valid story branches
    if [[ "$branch" == "main" || "$branch" == "master" || "$branch" == "develop" ]]; then
        echo "ERROR: Branch '$branch' is not a feature branch. Please checkout a feature branch before running SDD agents." >&2
        return 1
    fi

    # Recommended pattern: <id>-<description> or <prefix>-<number> (e.g., PROJ-123, 001-feature-name)
    # This is a soft recommendation — any branch name is accepted
    if [[ "$branch" =~ ^[A-Za-z0-9]+-[A-Za-z0-9] ]]; then
        echo "[arcus] Branch '$branch' looks good." >&2
    else
        echo "[arcus] WARNING: Branch name '$branch' does not follow the recommended pattern '<id>-<description>'." >&2
        echo "[arcus] Recommended: use a ticket ID or short prefix followed by a hyphen and description (e.g., PROJ-123, 001-add-auth). Proceeding anyway." >&2
    fi

    return 0
}

get_feature_dir() { echo "$1/.arcus/specs/$2"; }

# Find feature directory for the given branch name
# Uses the branch name directly as the story ID — no format-specific parsing
find_feature_dir_by_prefix() {
    local repo_root="$1"
    local branch_name="$2"
    local specs_dir="$repo_root/.arcus/specs"

    # Sanitise branch name for use as a directory name
    # Remove characters illegal in file/directory names
    local safe_id
    safe_id=$(echo "$branch_name" | tr -cd '[:alnum:]._-')

    # Check if an exact match directory already exists
    if [[ -d "$specs_dir/$safe_id" ]]; then
        echo "$specs_dir/$safe_id"
        return
    fi

    # Check if any existing spec directory starts with the same prefix
    # (handles cases where the branch name was truncated or slightly differs)
    if [[ -d "$specs_dir" ]]; then
        local matches=()
        for dir in "$specs_dir"/${safe_id}*; do
            if [[ -d "$dir" ]]; then
                matches+=("$(basename "$dir")")
            fi
        done

        if [[ ${#matches[@]} -eq 1 ]]; then
            echo "$specs_dir/${matches[0]}"
            return
        elif [[ ${#matches[@]} -gt 1 ]]; then
            echo "ERROR: Multiple spec directories found matching '$safe_id': ${matches[*]}" >&2
            echo "Please ensure only one spec directory exists per story. Defaulting to exact path." >&2
        fi
    fi

    # Default: return the canonical path using the sanitised branch name
    echo "$specs_dir/$safe_id"
}

get_feature_paths() {
    local repo_root
    repo_root=$(get_repo_root)
    local current_branch
    current_branch=$(get_current_branch)
    local has_git_repo="false"

    if has_git; then
        has_git_repo="true"
    fi

    # Validate branch naming (warns but does not block)
    check_feature_branch "$current_branch" "$has_git_repo" || exit 1

    # Derive feature directory from branch name
    local feature_dir
    feature_dir=$(find_feature_dir_by_prefix "$repo_root" "$current_branch")

    cat <<EOF
REPO_ROOT='$repo_root'
CURRENT_BRANCH='$current_branch'
HAS_GIT='$has_git_repo'
FEATURE_DIR='$feature_dir'
FEATURE_SPEC='$feature_dir/spec.md'
IMPL_PLAN='$feature_dir/plan.md'
TASKS='$feature_dir/tasks.md'
RESEARCH='$feature_dir/research.md'
DATA_MODEL='$feature_dir/data-model.md'
QUICKSTART='$feature_dir/quickstart.md'
CONTRACTS_DIR='$feature_dir/contracts'
EOF
}

check_file() { [[ -f "$1" ]] && echo "  ✓ $2" || echo "  ✗ $2"; }
check_dir() { [[ -d "$1" && -n $(ls -A "$1" 2>/dev/null) ]] && echo "  ✓ $2" || echo "  ✗ $2"; }
