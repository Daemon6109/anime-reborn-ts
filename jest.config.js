// Standard Jest configuration that uses our custom runner for cloud execution
const isVSCodeJest =
	process.env.VSCODE_JEST_MODE === "true" ||
	process.argv.some(
		(arg) => arg.includes("vscode-jest") || arg.includes("/tmp/jest_runner_") || arg.includes("reporter.js"),
	);

// Filter out VS Code Jest extension arguments that shouldn't be treated as test patterns
if (isVSCodeJest) {
	const filteredArgs = process.argv.filter(
		(arg) => !arg.includes("/tmp/jest_runner_") && !arg.includes("reporter.js") && arg !== "default",
	);
	process.argv.length = 0;
	process.argv.push(...filteredArgs);
}

module.exports = {
	// Standard Jest patterns that the extension expects
	testMatch: ["**/src/tests/**/*.(spec|test).(ts|tsx|js|jsx)", "**/src/**/*.(spec|test).(ts|tsx|js|jsx)"],
	testPathIgnorePatterns: ["/node_modules/", "/rbxts_include/"],

	// Standard Jest options - updated to include all place directories
	roots: [
		"<rootDir>/places/common/src",
		"<rootDir>/places/lobby/src",
		"<rootDir>/places/gameplay/src",
		"<rootDir>/places/afk/src",
	],
	testEnvironment: "node",
	verbose: !isVSCodeJest, // Reduce verbosity for VS Code Jest extension

	// File extensions Jest should handle
	moduleFileExtensions: ["ts", "tsx", "js", "jsx", "json"],

	// Transform TypeScript files so Jest can parse them
	transform: {
		"^.+\\.(ts|tsx)$": "<rootDir>/scripts/js/jest-transformer.js",
	},

	// Coverage configuration - disabled for now due to Babel TypeScript parsing issues
	coverageDirectory: "coverage",
	coverageProvider: "v8",

	// Disable coverage collection to avoid Babel parsing errors
	collectCoverageFrom: [],

	// If coverage is explicitly requested, show a warning but don't collect
	...(process.argv.includes("--coverage")
		? {
				// Force empty collection to prevent errors
				collectCoverageFrom: [],
			}
		: {}),

	// Custom runner that routes to cloud execution (disabled for VS Code Jest)
	...(isVSCodeJest ? {} : { runner: "<rootDir>/scripts/js/jest-runner.js" }),

	// Setup file to use Lune bridge for real Roblox environment when using VS Code
	...(isVSCodeJest ? { setupFilesAfterEnv: ["<rootDir>/scripts/js/jest-setup-lune.js"] } : {}),

	// modulePaths: ["<rootDir>/places/common/src"], // Replaced by moduleNameMapper
	moduleNameMapper: {
		"^server/(.*)$": "<rootDir>/places/common/src/server/$1",
		"^common/(.*)$": "<rootDir>/places/common/src/$1",
		// Add a mapping for shared if needed, e.g., from places/common/src/shared
		"^shared/(.*)$": "<rootDir>/places/common/src/shared/$1",
		"^old_common/(.*)$": "<rootDir>/old_common/src/$1",
		// Mock @flamework/core itself
		"^@flamework/core$": "<rootDir>/scripts/js/jest-flamework-mock.js",
		// Mock @rbxts/services
		"^@rbxts/services$": "<rootDir>/scripts/js/jest-rbxts-services-mock.js",
		// Mock @rbxts/profile-store
		"^@rbxts/profile-store$": "<rootDir>/scripts/js/jest-profile-store-mock.js",
		// Keep .lua mock for any other direct .lua imports if they occur
		"\\.lua$": "<rootDir>/scripts/js/jest-empty-mock.js",
	},
};
