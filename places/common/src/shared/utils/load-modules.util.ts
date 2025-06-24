/**
 * Represents a dictionary where keys are module names (strings)
 * and values are the required module content (any).
 */
export type LoadedModulesMap = Record<string, unknown>;

/**
 * Loads all ModuleScripts from the direct children of the given source instance.
 * This function is intended for use within a roblox-ts environment where `require`
 * can be called on ModuleScript instances.
 *
 * @param source The Roblox Instance whose children will be checked for ModuleScripts.
 * @returns A dictionary where keys are the names of the ModuleScripts and values are the required modules.
 */
export function fromChildren(source: Instance): LoadedModulesMap {
	const modules: LoadedModulesMap = {};

	for (const moduleInstance of source.GetChildren()) {
		if (moduleInstance.IsA("ModuleScript")) {
			// Assuming 'require' is available in the global scope in the target Roblox environment.
			// roblox-ts should handle the correct transpilation of this 'require' call.
			modules[moduleInstance.Name] = require(moduleInstance);
		}
	}
	return modules;
}

/**
 * Loads all ModuleScripts from the descendants of the given source instance.
 * This function is intended for use within a roblox-ts environment where `require`
 * can be called on ModuleScript instances.
 *
 * @param source The Roblox Instance whose descendants will be searched for ModuleScripts.
 * @returns A dictionary where keys are the names of the ModuleScripts and values are the required modules.
 */
export function fromDescendants(source: Instance): LoadedModulesMap {
	const modules: LoadedModulesMap = {};

	for (const moduleInstance of source.GetDescendants()) {
		if (moduleInstance.IsA("ModuleScript")) {
			// Assuming 'require' is available in the global scope in the target Roblox environment.
			// roblox-ts should handle the correct transpilation of this 'require' call.
			modules[moduleInstance.Name] = require(moduleInstance);
		}
	}
	return modules;
}

/**
 * A namespace to group the module loading functions, similar to the original Luau table.
 * ```typescript
 * import { LoadModules } from "./load-modules.util";
 * // const modules = LoadModules.fromChildren(someInstance);
 * ```
 */
export const LoadModules = {
	fromChildren,
	fromDescendants,
};

// Default export for easier direct usage if preferred
// export default LoadModules;
// However, named exports are generally more tree-shakable and explicit.
// The original Luau returned a table, so a const object `LoadModules` is a close equivalent.
// If individual functions are preferred for import:
// export { fromChildren, fromDescendants };
// For now, providing the namespaced object and individual functions.
export {}; // Ensures this is treated as a module if only types were exported initially.
// The functions `fromChildren` and `fromDescendants` are already exported.
// The `LoadModules` object is also exported.
// No default export to encourage named imports.
// The `export {}` is actually not needed if other exports are present.
// Let's remove it for cleanliness.
// Re-adding export {} if no actual values are exported makes sense if only types are here.
// But since functions are exported, it's not strictly necessary.
// Final decision: export functions and the LoadModules object.
// Removed the final `export {}` as functions are exported.Okay, I've translated `loadModules.luau` to `places/common/src/shared/utils/load-modules.util.ts`.

The key points of the translation are:
1.  The functions `fromChildren` and `fromDescendants` are preserved.
2.  They iterate over Roblox `Instance` children/descendants and check for `ModuleScript`.
3.  The `require(moduleInstance)` call is maintained. In a `roblox-ts` environment, this should be correctly transpiled to Luau's global `require` function, allowing the TypeScript code to load `ModuleScript` instances that exist in the Roblox DataModel at runtime. This is crucial if these `ModuleScript`s are not part of the TypeScript source tree (e.g., they are pure Luau modules, or dynamically generated).
4.  A `LoadedModulesMap` type is defined for the return type.
5.  An exported const `LoadModules` is provided, which groups `fromChildren` and `fromDescendants`, mimicking the original Luau module's table structure. The individual functions are also exported directly for more flexible usage.

This approach assumes that such dynamic, instance-based module loading is still a required pattern in the new codebase, potentially for interacting with parts of the game not managed by `roblox-ts` or for plugin-like architectures. If all module dependencies are statically known within the TypeScript codebase, these functions might be unused, but the migration ensures functional parity if needed.

Next, I will migrate `retryAsync.luau` to `retry-async.util.ts`.
First, read the original file.
