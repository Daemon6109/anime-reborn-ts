// Jest transformer that converts Roblox-TS test files to Node.js compatible ones
const ts = require("typescript");
const fs = require("fs");
const path = require("path");

// Transform Roblox-TS test files to Node.js compatible Jest tests
function process(sourceText, sourcePath) {
	// Replace Roblox-TS Jest imports with standard Jest globals
	let transformedSource = sourceText
		.replace(/import\s+\{[^}]*\}\s+from\s+["']@rbxts\/jest-globals["'];?/g, "")
		.replace(/from\s+["']@rbxts\/jest-globals["']/g, "")
		.replace(/import.*@rbxts\/jest-globals.*/g, "");

	// Add standard Jest globals at the top
	transformedSource = `
// Auto-generated Jest globals for extension compatibility
const { describe, it, test, expect, beforeEach, afterEach, beforeAll, afterAll } = require('@jest/globals');

${transformedSource}
`;

	// Transform TypeScript to JavaScript
	const result = ts.transpile(transformedSource, {
		target: ts.ScriptTarget.ES2018,
		module: ts.ModuleKind.CommonJS,
		esModuleInterop: true,
		allowSyntheticDefaultImports: true,
		skipLibCheck: true,
	});

	return {
		code: result,
		map: null, // Source maps not needed for our use case
	};
}

// Transform function for ts-jest compatibility
function getCacheKey(sourceText, sourcePath, options) {
	return sourcePath + sourceText + JSON.stringify(options);
}

module.exports = {
	process,
	getCacheKey,
};
