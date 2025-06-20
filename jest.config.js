// Standard Jest configuration that uses our custom runner for cloud execution
module.exports = {
	// Standard Jest patterns that the extension expects
	testMatch: ["**/src/tests/**/*.(spec|test).(ts|tsx|js|jsx)", "**/src/**/*.(spec|test).(ts|tsx|js|jsx)"],
	testPathIgnorePatterns: ["/node_modules/", "/rbxts_include/"],

	// Standard Jest options
	roots: ["<rootDir>/src"],
	testEnvironment: "node",
	verbose: true,

	// File extensions Jest should handle
	moduleFileExtensions: ["ts", "tsx", "js", "jsx", "json"],

	// Transform TypeScript files so Jest can parse them
	transform: {
		"^.+\\.(ts|tsx)$": "<rootDir>/scripts/js/jest-transformer.js",
	},

	// Custom runner that routes to cloud execution
	runner: "<rootDir>/scripts/js/jest-runner.js",

	// Coverage
	collectCoverageFrom: ["src/**/*.(ts|tsx|js|jsx)", "!src/**/*.d.ts", "!src/tests/**"],
	coverageDirectory: "coverage",
};
