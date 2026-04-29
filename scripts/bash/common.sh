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

# Get current branch, with fallback for non-git repositories
get_current_branch() {
    # First check if SPECIFY_FEATURE environment variable is set
    if [[ -n "${SPECIFY_FEATURE:-}" ]]; then
        echo "$SPECIFY_FEATURE"
        return
    fi

    # Then check git if available
    if git rev-parse --abbrev-ref HEAD >/dev/null 2>&1; then
        git rev-parse --abbrev-ref HEAD
        return
    fi

    # For non-git repos, try to find the latest feature directory
    local repo_root
    repo_root=$(get_repo_root)
    local specs_dir="$repo_root/.arcus/specs"

    if [[ -d "$specs_dir" ]]; then
        local latest_feature=""
        local highest=0

        for dir in "$specs_dir"/*; do
            if [[ -d "$dir" ]]; then
                local dirname
                dirname=$(basename "$dir")
                # Support BFCO-<story>-name and numeric prefixes like 001-
                if [[ "$dirname" =~ ^BFCO-([0-9]+)- ]]; then
                    local number=${BASH_REMATCH[1]}
                    number=$((10#$number))
                    if [[ "$number" -gt "$highest" ]]; then
                        highest=$number
                        latest_feature=$dirname
                    fi
                elif [[ "$dirname" =~ ^([0-9]{3})- ]]; then
                    local number=${BASH_REMATCH[1]}
                    number=$((10#$number))
                    if [[ "$number" -gt "$highest" ]]; then
                        highest=$number
                        latest_feature=$dirname
                    fi
                fi
            fi
        done

        if [[ -n "$latest_feature" ]]; then
            echo "$latest_feature"
            return
        fi
    fi

    echo "main"  # Final fallback
}

# Check if we have git available
has_git() {
    git rev-parse --show-toplevel >/dev/null 2>&1
}

check_feature_branch() {
    local branch="$1"
    local has_git_repo="$2"

    # Require a git repository for branch validation
    if [[ "$has_git_repo" != "true" ]]; then
        echo "[specify] ERROR: Git repository not detected; branch validation requires a git repo" >&2
        return 1
    fi

    # Detect detached HEAD or missing branch
    if [[ -z "$branch" || "$branch" == "HEAD" ]]; then
        echo "ERROR: Detached HEAD or no branch detected. Please checkout a branch." >&2
        return 1
    fi

    # Preferred branch name pattern: 3-4 letters, a hyphen, then digits (e.g., abc-123 or abcd-123)
    if [[ "$branch" =~ ^[A-Za-z]{3,4}-[0-9]+$ ]]; then
        echo "[specify] Branch name '$branch' matches preferred pattern ^[A-Za-z]{3,4}-[0-9]+$." >&2
        return 0
    fi

    # Branch name does not match preferred pattern — warn but continue
    echo "[specify] WARNING: Branch name '$branch' does not follow the recommended pattern '[abcd]-123'." >&2
    echo "[specify] Recommended: three or four letters, a hyphen, then an issue number (e.g., abc-123 or abcd-456). Proceeding anyway." >&2
    return 0
}

get_feature_dir() { echo "$1/.arcus/specs/$2"; }

# Find feature directory by prefix (BFCO-<num>- or numeric) instead of exact branch match
find_feature_dir_by_prefix() {
    local repo_root="$1"
    local branch_name="$2"
    local specs_dir="$repo_root/.arcus/specs"

    # If branch uses BFCO-<num> prefix, derive canonical spec dir name BFCO-<num>
    if [[ "$branch_name" =~ ^BFCO-([0-9]+)(-|$) ]]; then
        local story_num=${BASH_REMATCH[1]}
        local canonical_dir="BFCO-${story_num}"
        # If exact canonical dir exists, prefer it
        if [[ -d "$specs_dir/$canonical_dir" ]]; then
            echo "$specs_dir/$canonical_dir"
            return
        fi
        # Otherwise fall back to searching for directories that start with BFCO-<num>-
        local prefix="BFCO-${story_num}-"
        local matches=()
        if [[ -d "$specs_dir" ]]; then
            for dir in "$specs_dir"/${prefix}*; do
                if [[ -d "$dir" ]]; then
                    matches+=("$(basename "$dir")")
                fi
            done
        fi
        if [[ ${#matches[@]} -eq 1 ]]; then
            echo "$specs_dir/${matches[0]}"
            return
        elif [[ ${#matches[@]} -gt 1 ]]; then
            echo "ERROR: Multiple spec directories found with prefix '$prefix': ${matches[*]}" >&2
            echo "Please ensure only one spec directory exists per story prefix." >&2
            echo "$specs_dir/$branch_name"
            return
        fi
        # No matches found; prefer canonical path even if it doesn't exist (so setup creates canonical)
        echo "$specs_dir/$canonical_dir"
        return
    fi

    # Fallback to numeric prefix (e.g., 001-)
    if [[ "$branch_name" =~ ^([0-9]{3})- ]]; then
        local prefix_num="${BASH_REMATCH[1]}"
        local matches=()
        if [[ -d "$specs_dir" ]]; then
            for dir in "$specs_dir"/${prefix_num}-*; do
                if [[ -d "$dir" ]]; then
                    matches+=("$(basename "$dir")")
                fi
            done
        fi
        if [[ ${#matches[@]} -eq 1 ]]; then
            echo "$specs_dir/${matches[0]}"
            return
        elif [[ ${#matches[@]} -gt 1 ]]; then
            echo "ERROR: Multiple spec directories found with prefix '$prefix_num': ${matches[*]}" >&2
            echo "Please ensure only one spec directory exists per numeric prefix." >&2
            echo "$specs_dir/$branch_name"
            return
        fi
    fi

    # No recognized prefix; return exact canonical prefixless path under specs by branch name
    # Strip characters that are illegal in file names if any (safety)
    local safe_branch_name
    safe_branch_name=$(echo "$branch_name" | tr -cd '[:alnum:]._-')
    echo "$specs_dir/$safe_branch_name"
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

    # Validate branch naming
    check_feature_branch "$current_branch" "$has_git_repo" || exit 1

    # Use prefix-based lookup to support multiple branches per spec
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
