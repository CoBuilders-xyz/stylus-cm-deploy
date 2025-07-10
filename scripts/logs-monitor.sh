#!/bin/bash

# Simple module log monitor - supports multiple modules with OR logic
# Usage: ./logs-monitor.sh [-v verbosity] [-m module1] [-m module2] ...
# Verbosity levels: LOG (LOG+WARN+ERROR) or DEBUG (DEBUG+LOG+WARN+ERROR)
# If no modules are provided, it will monitor all modules.

# Initialize variables
VERBOSITY=""
MODULES=()

# Parse command line arguments
while getopts "v:m:" opt; do
    case $opt in
        v)
            if [ "$OPTARG" = "LOG" ] || [ "$OPTARG" = "DEBUG" ]; then
                VERBOSITY="$OPTARG"
            else
                echo "Error: Verbosity must be LOG or DEBUG"
                exit 1
            fi
            ;;
        m)
            MODULES+=("$OPTARG")
            ;;
        \?)
            echo "Usage: $0 [-v LOG|DEBUG] [-m module1] [-m module2] ..."
            exit 1
            ;;
    esac
done

# If no modules specified, monitor all
if [ ${#MODULES[@]} -eq 0 ]; then
    MODULES=("")
fi

echo "🔍 ${MODULES[*]} Logs (Press Ctrl+C to stop)"
if [ -n "$VERBOSITY" ]; then
    echo "📊 Verbosity: $VERBOSITY"
fi
echo "----------------------------------------"

# Build grep pattern for OR logic (any module can be present)
GREP_PATTERN=""
for module in "${MODULES[@]}"; do
    if [ -z "$GREP_PATTERN" ]; then
        GREP_PATTERN="$module"
    else
        GREP_PATTERN="$GREP_PATTERN|$module"
    fi
done

# Build verbosity pattern
VERBOSITY_PATTERN=""
if [ "$VERBOSITY" = "LOG" ]; then
    VERBOSITY_PATTERN="(LOG|WARN|ERROR)"
elif [ "$VERBOSITY" = "DEBUG" ]; then
    VERBOSITY_PATTERN="(DEBUG|LOG|WARN|ERROR)"
fi

# Run docker logs and apply filters
if [ -n "$VERBOSITY_PATTERN" ] && [ -n "$GREP_PATTERN" ]; then
    docker logs scm-backend --follow | grep -E "$GREP_PATTERN" | grep -E "$VERBOSITY_PATTERN"
elif [ -n "$VERBOSITY_PATTERN" ]; then
    docker logs scm-backend --follow | grep -E "$VERBOSITY_PATTERN"
else
    docker logs scm-backend --follow | grep -E "$GREP_PATTERN"
fi 