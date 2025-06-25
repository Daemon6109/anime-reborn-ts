---
mode: agent
---

**Objective:**

Create a script to automate the extraction of unit data from the Roblox game environment and update the `places/common/src/shared/data/units-data.ts` file.

**Instructions:**

1.  **Create a new script file:** `scripts/js/sync-units-data.ts`.

2.  **Implement the script logic in `sync-units-data.ts`:**

    a. **Connect to MCP Server:** Establish a connection to the MCP server to interact with the Roblox game instance.

    b. **Extract Unit Data:**
    _ Use the MCP server to execute Luau code that iterates through each `ModuleScript` in `ReplicatedStorage.Registry.Units`.
    _ For each module, the Luau script should return a JSON object containing:
    _ The unit's name (from the module's name).
    _ The `configuration` table.
    _ The `Released` boolean value (defaulting to `true` if absent).
    _ The `Summonable` boolean value (defaulting to `true` if absent).
    _ The `animations` table, if it exists.
    _ The final result from the MCP server should be a JSON array of these unit objects.

    c. **Generate TypeScript Code:**
    _ Read the JSON data returned from the MCP server.
    _ For each unit object in the JSON array, generate a corresponding TypeScript entry.

    d. **Update `units-data.ts`:**
    _ Read the existing content of `places/common/src/shared/data/units-data.ts`.
    _ Locate the `export const unitsData = { ... }` declaration.
    _ Replace the contents of the `unitsData` object with the newly generated TypeScript entries. Be careful to preserve any other code or comments in the file.
    _ Write the updated content back to `places/common/src/shared/data/units-data.ts`.

3.  **Execute the script** to perform the synchronization.
