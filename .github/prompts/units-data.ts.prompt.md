---
mode: agent
---

**Objective:**

Create a script to automate the extraction of unit data from the Luau source code and make it available to the TypeScript codebase.

**Instructions:**

1.  **Create a new Lune script file:** `scripts/lune/extract-units-data.luau`.

2.  **Implement the Lune script logic in `extract-units-data.luau`:**
    a. The script should traverse the `old_common/src/constants/Units/` directory.
    b. For each Luau `ModuleScript` found, it should parse the file to extract the required data:
    _ The unit's name (from the module's name).
    _ The `configuration` table.
    _ The `Released` boolean value (defaulting to `true` if absent).
    _ The `Summonable` boolean value (defaulting to `true` if absent). \* The `animations` table, if it exists.
    c. Aggregate the data from all unit modules into a single Lua table.
    d. Serialize the final table into a JSON string.
    e. Write the JSON string to a new file: `places/common/src/shared/data/units-data.json`.

3.  **Update the TypeScript data file:**
    a. Modify `places/common/src/shared/data/units-data.ts` to directly import the JSON file. The content of the file should be:
    ```typescript
    import unitsData from './units-data.json';

        export { unitsData };
        ```

4.  **Ensure TypeScript can import JSON:**
    a. Check the `places/common/tsconfig.json` file.
    b. If it's not already present, add `"resolveJsonModule": true` to the `compilerOptions`.

5.  **Execute the Lune script** to generate the `units-data.json` file.
