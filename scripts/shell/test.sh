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
    # Debug: Print environment variables received in Docker container
    echo "Debug: Environment variables in Docker container:"
    echo "ROBLOX_API_KEY length: ${#ROBLOX_API_KEY}"
    echo "ROBLOX_UNIVERSE_ID: '$ROBLOX_UNIVERSE_ID'"
    echo "ROBLOX_PLACE_ID: '$ROBLOX_PLACE_ID'"
fi

echo "---"
echo "Building all places..."
npm run build
echo "Generating sourcemap..."
rojo sourcemap default.project.json -o sourcemap.json
echo "Building with rojo..."
rojo build default.project.json -o dist.rbxl
echo "Uploading to Roblox..."

# Initialize exit code variable
PYTHON_EXIT_CODE=0
OVERALL_EXIT_CODE=0

echo "Running all Jest tests"

if command -v python3 &>/dev/null; then
    python3 "$PARENT_DIR/python/upload_and_run_task.py" dist.rbxl scripts/roblox/run-tests.server.luau "$TEST_PATTERN"
else
    python "$PARENT_DIR/python/upload_and_run_task.py" dist.rbxl scripts/roblox/run-tests.server.luau "$TEST_PATTERN"
fi

PYTHON_EXIT_CODE=$?
if [ $PYTHON_EXIT_CODE -ne 0 ]; then
    echo "❌ Tests failed"
    OVERALL_EXIT_CODE=$PYTHON_EXIT_CODE
else
    echo "✅ Tests passed"
fi

echo "Cleaning up..."

# Exit with the overall failure code if any tests failed
echo "Test script completed with exit code: $OVERALL_EXIT_CODE"
exit $OVERALL_EXIT_CODE
