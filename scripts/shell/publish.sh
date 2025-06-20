#!/bin/bash

set -e

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

bash "$SCRIPT_DIR/setup.sh"

npm run build
echo "Generating sourcemap..."
rojo sourcemap default.project.json -o sourcemap.json
echo "Publishing with rojo..."
rojo upload default.project.json --api_key "$ROBLOX_API_KEY" --universe_id "$ROBLOX_UNIVERSE_ID" --asset_id "$ROBLOX_PLACE_ID"
echo "Cleaning up..."
