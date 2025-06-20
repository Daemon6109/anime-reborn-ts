#!/bin/bash

set -e

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Run setup script from the same directory
bash "$SCRIPT_DIR/setup.sh"

PROJECT_NAME=$(basename "$(pwd)")

echo "Generating sourcemap..."
npm run build
rojo sourcemap default.project.json -o sourcemap.json
echo "Building with rojo..."
rojo build default.project.json -o "$PROJECT_NAME.rbxl"; # Cross-platform file open
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    open "$PROJECT_NAME.rbxl"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" || "$OSTYPE" == "cygwin" ]]; then
    # Windows
    start "$PROJECT_NAME.rbxl"
fi
echo "Cleaning up..."
