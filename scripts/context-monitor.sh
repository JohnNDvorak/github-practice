#!/bin/bash

# Context Monitor for Claude Code
# Warns when conversation context is approaching limits
# and prompts to commit progress

CONTEXT_WARNING_THRESHOLD=30  # Warn at 30% context usage
CONTEXT_FILE="$HOME/.claude/context-state.json"
LOG_FILE="$HOME/.claude/context-monitor.log"

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to log messages
log_message() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Function to estimate context usage
estimate_context() {
    # Count lines in recent conversation
    # This is a rough estimate - adjust based on your needs
    local conversation_length=0

    # Check if Claude state file exists
    if [ -f "$HOME/.claude.json" ]; then
        # Count conversation turns (rough estimate)
        conversation_length=$(wc -l < "$HOME/.claude.json" 2>/dev/null || echo 0)
    fi

    echo "$conversation_length"
}

# Function to calculate percentage
calculate_percentage() {
    local current=$1
    local max=2000  # Approximate max conversation depth
    echo $(( (current * 100) / max ))
}

# Main monitoring logic
main() {
    local context_lines=$(estimate_context)
    local context_percentage=$(calculate_percentage "$context_lines")

    log_message "Context check - Lines: $context_lines, Estimated %: $context_percentage"

    if [ "$context_percentage" -ge "$CONTEXT_WARNING_THRESHOLD" ]; then
        echo -e "${YELLOW}⚠️  CONTEXT WARNING${NC}" >&2
        echo -e "${YELLOW}Conversation context at ~${context_percentage}%${NC}" >&2
        echo -e "${YELLOW}Recommended actions:${NC}" >&2
        echo -e "  1. Commit current work" >&2
        echo -e "  2. Document progress and next steps" >&2
        echo -e "  3. Consider clearing context window" >&2
        echo "" >&2

        log_message "WARNING: Context threshold exceeded ($context_percentage%)"

        # Save state
        echo "{\"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\", \"percentage\": $context_percentage, \"lines\": $context_lines}" > "$CONTEXT_FILE"

        return 1
    else
        echo -e "${GREEN}✓ Context usage: ~${context_percentage}%${NC}" >&2
        log_message "INFO: Context check passed ($context_percentage%)"
        return 0
    fi
}

# Run main function
main
