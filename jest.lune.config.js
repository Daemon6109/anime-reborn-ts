// Jest configuration for Lune-enhanced testing
// This config uses Lune bridge for accurate Roblox runtime behavior

/* eslint-disable */

module.exports = {
	// Standard Jest patterns
	testMatch: ["**/src/tests/**/*.(spec|test).(ts|tsx|js|jsx)", "**/src/**/*.(spec|test).(ts|tsx|js|jsx)"],
	testPathIgnorePatterns: ["/node_modules/", "/rbxts_include/"],

	// Test roots - include all place directories
	roots: [
		"<rootDir>/places/common/src",
		"<rootDir>/places/lobby/src",
		"<rootDir>/places/gameplay/src",
		"<rootDir>/places/afk/src",
	],
	testEnvironment: "node",
	verbose: false,

	// File extensions Jest should handle
	moduleFileExtensions: ["ts", "tsx", "js", "jsx", "json"],

	// Transform TypeScript files
	transform: {
		"^.+\\.(ts|tsx)$": "<rootDir>/scripts/js/jest-transformer.js",
	},

	// Use Lune bridge setup instead of basic mocks
	setupFilesAfterEnv: ["<rootDir>/scripts/js/jest-setup-lune-bridge.js"],

	// Module name mapping
	moduleNameMapper: {
		"^server/(.*)$": "<rootDir>/places/common/src/server/$1",
		"^common/(.*)$": "<rootDir>/places/common/src/$1",
		"^shared/(.*)$": "<rootDir>/places/common/src/shared/$1",
		// Mock external dependencies
		"^@flamework/core$": "<rootDir>/scripts/js/jest-flamework-mock.js",
		"^@rbxts/services$": "<rootDir>/scripts/js/jest-rbxts-services-mock.js",
		"^@rbxts/profile-store$": "<rootDir>/scripts/js/jest-profile-store-mock.js",
		"\\.lua$": "<rootDir>/scripts/js/jest-empty-mock.js",
	},

	// Global setup
	globals: {
		"ts-jest": {
			tsconfig: {
				lib: ["ES2015", "DOM"],
				types: ["node", "@rbxts/types"],
			},
		},
	},

	// Coverage configuration
	collectCoverageFrom: ["places/*/src/**/*.(ts|tsx|js|jsx)", "!places/*/src/**/*.d.ts", "!places/*/src/tests/**"],
	coverageDirectory: "coverage",

	// Test timeout - increased for Lune communication
	testTimeout: 10000,

	// Setup and teardown
	globalSetup: "<rootDir>/scripts/js/jest-global-setup.js",
	globalTeardown: "<rootDir>/scripts/js/jest-global-teardown.js",
};
