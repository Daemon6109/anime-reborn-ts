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

# Define the places to test
PLACES=("Common" "Gameplay" "Lobby" "AFK")

# Function to check if a place has test files
check_place_has_tests() {
    local place_name="$1"
    local test_pattern="$2"

    # Convert place name to lowercase for directory matching
    local place_dir=$(echo "$place_name" | tr '[:upper:]' '[:lower:]')
    local test_dir="places/$place_dir/src/tests"

    # Check if test directory exists
    if [ ! -d "$test_dir" ]; then
        echo "⏭️  Skipping $place_name: no test directory found at $test_dir"
        return 1
    fi

    # Check if there are any test files
    local test_files=$(find "$test_dir" -name "*.spec.ts" -o -name "*.test.ts" 2>/dev/null | wc -l)
    if [ "$test_files" -eq 0 ]; then
        echo "⏭️  Skipping $place_name: no test files found in $test_dir"
        return 1
    fi

    # If test pattern is specified, check if any test files match
    if [ -n "$test_pattern" ]; then
        local matching_files=$(find "$test_dir" -name "*.spec.ts" -o -name "*.test.ts" 2>/dev/null | xargs grep -l "$test_pattern" 2>/dev/null | wc -l)
        if [ "$matching_files" -eq 0 ]; then
            echo "⏭️  Skipping $place_name: no test files match pattern '$test_pattern'"
            return 1
        fi
    fi

    return 0
}

# Run Jest separately for each place to avoid runtime conflicts
if [ -n "$TEST_PATTERN" ]; then
    echo "Running Jest with test pattern: $TEST_PATTERN"
    for PLACE in "${PLACES[@]}"; do
        echo ""
        echo "========================================"
        echo "Checking $PLACE for tests matching pattern: $TEST_PATTERN"
        echo "========================================"

        # Check if this place has relevant tests
        if ! check_place_has_tests "$PLACE" "$TEST_PATTERN"; then
            continue
        fi

        echo "Running tests for $PLACE with pattern: $TEST_PATTERN"

        if command -v python3 &>/dev/null; then
            python3 "$PARENT_DIR/python/upload_and_run_task.py" dist.rbxl tasks/run-tests.server.luau "$TEST_PATTERN" "$PLACE"
        else
            python "$PARENT_DIR/python/upload_and_run_task.py" dist.rbxl tasks/run-tests.server.luau "$TEST_PATTERN" "$PLACE"
        fi

        PYTHON_EXIT_CODE=$?
        if [ $PYTHON_EXIT_CODE -ne 0 ]; then
            echo "❌ Tests failed for $PLACE"
            OVERALL_EXIT_CODE=$PYTHON_EXIT_CODE
        else
            echo "✅ Tests passed for $PLACE"
        fi
    done
else
    echo "Running all Jest tests"
    for PLACE in "${PLACES[@]}"; do
        echo ""
        echo "========================================"
        echo "Checking $PLACE for tests"
        echo "========================================"

        # Check if this place has any tests
        if ! check_place_has_tests "$PLACE" ""; then
            continue
        fi

        echo "Running tests for $PLACE"

        if command -v python3 &>/dev/null; then
            python3 "$PARENT_DIR/python/upload_and_run_task.py" dist.rbxl tasks/run-tests.server.luau "" "$PLACE"
        else
            python "$PARENT_DIR/python/upload_and_run_task.py" dist.rbxl tasks/run-tests.server.luau "" "$PLACE"
        fi

        PYTHON_EXIT_CODE=$?
        if [ $PYTHON_EXIT_CODE -ne 0 ]; then
            echo "❌ Tests failed for $PLACE"
            OVERALL_EXIT_CODE=$PYTHON_EXIT_CODE
        else
            echo "✅ Tests passed for $PLACE"
        fi
    done
fi

echo "Cleaning up..."

# Exit with the overall failure code if any tests failed
echo "Test script completed with exit code: $OVERALL_EXIT_CODE"
exit $OVERALL_EXIT_CODE
