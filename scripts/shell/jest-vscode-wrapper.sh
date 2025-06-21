#!/bin/bash

# VS Code Jest wrapper script
# This script filters out VS Code-specific arguments before calling Jest

# Filter out VS Code Jest extension arguments but preserve important ones
FILTERED_ARGS=()
VSCODE_REPORTER=""
for arg in "$@"; do
    if [[ "$arg" == *"/tmp/jest_runner_"* ]] && [[ "$arg" != *".json" ]]; then
        # Skip the jest runner temp file, but NOT output JSON files
        continue
    elif [[ "$arg" == "default" ]]; then
        # Skip the "default" argument
        continue
    elif [[ "$arg" == *"reporter.js"* ]]; then
        # Save the VS Code reporter path but don't add it yet
        VSCODE_REPORTER="$arg"
        continue
    else
        # Keep all other arguments (including --testLocationInResults, --outputFile, etc.)
        FILTERED_ARGS+=("$arg")
    fi
done

# Only add VS Code config if no config was specified and this is not a VS Code call
HAS_CONFIG=false
for arg in "${FILTERED_ARGS[@]}"; do
    if [[ "$arg" == "--config"* ]] || [[ "$arg" == "-c" ]]; then
        HAS_CONFIG=true
        break
    fi
done

# Force VS Code to use the vscode config
if [ -n "$VSCODE_REPORTER" ] && [ "$HAS_CONFIG" = false ]; then
    FILTERED_ARGS+=("--config" "jest.vscode.config.js")
elif [ "$HAS_CONFIG" = false ]; then
    FILTERED_ARGS+=("--config" "jest.vscode.config.js")
fi

# Add the VS Code reporter back if it was provided and exists
if [ -n "$VSCODE_REPORTER" ]; then
    if [ -f "$VSCODE_REPORTER" ]; then
        FILTERED_ARGS+=("--reporters" "default" "--reporters" "$VSCODE_REPORTER")
    else
        # VS Code reporter was specified but doesn't exist, use default only
        FILTERED_ARGS+=("--reporters" "default")
    fi
fi

# Run Jest with filtered arguments
echo "=== JEST WRAPPER DEBUG ===" >>/tmp/jest-debug.log
echo "Date: $(date)" >>/tmp/jest-debug.log
echo "VSCODE_REPORTER: $VSCODE_REPORTER" >>/tmp/jest-debug.log
echo "All args: $@" >>/tmp/jest-debug.log
echo "Filtered args: ${FILTERED_ARGS[@]}" >>/tmp/jest-debug.log
echo "============================" >>/tmp/jest-debug.log

if [ -n "$VSCODE_REPORTER" ]; then
    # VS Code mode - run with the VS Code config
    echo "VS Code Jest detected - using jest.vscode.config.js"
    npx jest "${FILTERED_ARGS[@]}"
else
    # Normal mode for manual runs
    echo "Running Jest with filtered args: ${FILTERED_ARGS[@]}"
    npx jest "${FILTERED_ARGS[@]}"
fi
