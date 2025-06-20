#!/bin/bash

set -e

# Get test pattern from first argument (optional)
TEST_PATTERN="$1"

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
# Get the parent directory (scripts folder)
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

bash "$SCRIPT_DIR/setup.sh"

# Source .env file if it exists, otherwise use environment variables
if [ -f .env ]; then
    echo "Loading environment from .env file..."
    if source .env 2>/dev/null; then
        echo "Successfully loaded .env file"
    else
        echo "Warning: Failed to source .env file, using environment variables..."
    fi
else
    echo "No .env file found, using environment variables..."
fi

# Debug: Print environment variables received in Docker container
echo "Debug: Environment variables in Docker container:"
echo "ROBLOX_API_KEY length: ${#ROBLOX_API_KEY}"
echo "ROBLOX_UNIVERSE_ID: '$ROBLOX_UNIVERSE_ID'"  
echo "ROBLOX_PLACE_ID: '$ROBLOX_PLACE_ID'"
echo "---"
npm run build
rojo sourcemap default.project.json -o sourcemap.json
echo "Building with rojo..."
rojo build default.project.json -o dist.rbxl
echo "Uploading to Roblox..."

# Initialize exit code variable
PYTHON_EXIT_CODE=0

if [ -n "$TEST_PATTERN" ]; then
    echo "Running specific test pattern: $TEST_PATTERN"
    if command -v python3 &>/dev/null; then
        python3 "$PARENT_DIR/python/upload_and_run_task.py" dist.rbxl tasks/run-tests.server.luau "$TEST_PATTERN"
        PYTHON_EXIT_CODE=$?
    else
        python "$PARENT_DIR/python/upload_and_run_task.py" dist.rbxl tasks/run-tests.server.luau "$TEST_PATTERN"
        PYTHON_EXIT_CODE=$?
    fi
else
    echo "Running all tests"
    if command -v python3 &>/dev/null; then
        python3 "$PARENT_DIR/python/upload_and_run_task.py" dist.rbxl tasks/run-tests.server.luau
        PYTHON_EXIT_CODE=$?
    else
        python "$PARENT_DIR/python/upload_and_run_task.py" dist.rbxl tasks/run-tests.server.luau
        PYTHON_EXIT_CODE=$?
    fi
fi

echo "Cleaning up..."

# Exit with the same code that the Python script returned
echo "Test script completed with exit code: $PYTHON_EXIT_CODE"
exit $PYTHON_EXIT_CODE
