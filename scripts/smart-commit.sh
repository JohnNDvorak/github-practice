#!/bin/bash

# Smart Commit - Auto-commit progress at context thresholds
# Integrates with context monitoring

set -e

REPO_PATH="${1:-$PWD}"
CONTEXT_CHECK_SCRIPT="$(dirname "$0")/context-monitor.sh"

cd "$REPO_PATH"

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Not a git repository. Skipping commit." >&2
    exit 0
fi

# Run context check
if [ -f "$CONTEXT_CHECK_SCRIPT" ]; then
    if ! "$CONTEXT_CHECK_SCRIPT"; then
        # Context warning triggered
        echo ""
        echo "🤖 Attempting to auto-commit progress..."

        # Check if there are changes to commit
        if ! git diff-index --quiet HEAD -- 2>/dev/null; then
            # Get list of changed files
            changed_files=$(git diff --name-only HEAD)

            # Create auto-commit
            git add -A
            git commit -m "chore: auto-commit progress before context reset

Context threshold reached. Saving work-in-progress state.

Changed files:
${changed_files}

🤖 Auto-generated commit" || echo "No changes to commit"

            echo "✓ Progress committed. Safe to clear context."
            echo ""
            echo "Next steps:"
            echo "  1. Document remaining tasks in TODO.md or comments"
            echo "  2. Push to remote: git push"
            echo "  3. Clear context and continue"
        else
            echo "✓ No uncommitted changes. Safe to clear context."
        fi
    fi
fi
