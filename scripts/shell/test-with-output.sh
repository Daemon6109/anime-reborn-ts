#!/bin/bash

# Wrapper script that redirects output to a file for Jest to read
set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Output file for Jest to read
OUTPUT_FILE="$SCRIPT_DIR/../../test-output.log"

# Clear previous output
>"$OUTPUT_FILE"

# Run the actual test script and capture output, passing all arguments
{
    bash "$SCRIPT_DIR/test.sh" "$@" 2>&1
    echo "Script completed with exit code: $?"
} | tee "$OUTPUT_FILE"

# Ensure we exit with the same code as the test script
exit ${PIPESTATUS[0]}
