// Jest configuration specifically for VS Code Jest extension
// This config uses the default Jest runner and sets up proper Roblox type handling

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
	verbose: false, // This reduces the individual test output

	// File extensions Jest should handle
	moduleFileExtensions: ["ts", "tsx", "js", "jsx", "json"],

	// Transform TypeScript files so Jest can parse them
	transform: {
		"^.+\\.(ts|tsx)$": "<rootDir>/scripts/js/jest-transformer.js",
	},

	// Setup file to mock Roblox environment for Node.js with Lune bridge
	setupFilesAfterEnv: [
		"<rootDir>/scripts/js/jest-setup-roblox-mocks.js", // Added this line
		"<rootDir>/scripts/js/jest-setup-lune.js"
	],

	// No custom runner for VS Code - use default Jest runner
	// runner: "<rootDir>/scripts/js/jest-runner.js", // DISABLED for VS Code

	// Global setup to handle Roblox types
	globals: {
		"ts-jest": {
			tsconfig: {
				// Enable Node.js types alongside Roblox types
				lib: ["ES2015", "DOM"],
				types: ["node", "@rbxts/types"],
			},
		},
	},
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

	// Coverage - updated paths
	collectCoverageFrom: ["places/*/src/**/*.(ts|tsx|js|jsx)", "!places/*/src/**/*.d.ts", "!places/*/src/tests/**"],
	coverageDirectory: "coverage",
};
