// Standard Jest configuration that uses our custom runner for cloud execution
module.exports = {
	// Standard Jest patterns that the extension expects
	testMatch: ["**/src/tests/**/*.(spec|test).(ts|tsx|js|jsx)", "**/src/**/*.(spec|test).(ts|tsx|js|jsx)"],
	testPathIgnorePatterns: ["/node_modules/", "/rbxts_include/"],

	// Standard Jest options - updated to include all place directories
	roots: [
		"<rootDir>/places/common/src",
		"<rootDir>/places/lobby/src", 
		"<rootDir>/places/gameplay/src",
		"<rootDir>/places/afk/src"
	],
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

	// Coverage - updated paths
	collectCoverageFrom: [
		"places/*/src/**/*.(ts|tsx|js|jsx)", 
		"!places/*/src/**/*.d.ts", 
		"!places/*/src/tests/**"
	],
	coverageDirectory: "coverage",
};
