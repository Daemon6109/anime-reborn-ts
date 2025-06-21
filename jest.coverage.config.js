// Jest configuration specifically for coverage collection
// This config is designed to avoid Babel TypeScript parsing issues

const baseConfig = require("./jest.config.js");

module.exports = {
	...baseConfig,

	// Force local execution for coverage (override cloud runner)
	runner: "jest-runner", // Explicitly use the default Jest runner
	setupFilesAfterEnv: ["<rootDir>/scripts/js/jest-setup-roblox-mocks.js"], // Use Roblox mocks

	// Override coverage settings for targeted coverage collection
	collectCoverage: true,
	collectCoverageFrom: [
		// Include test files
		"places/*/src/tests/**/*.ts",

		// Include simple TypeScript files (runtime files should be basic)
		"places/*/src/**/runtime.*.ts",

		// Include module files
		"places/*/src/**/module.ts",

		// Exclude files that cause Babel parsing issues
		"!places/*/src/**/*.d.ts",
		"!places/*/src/**/jest.config.ts",
		"!**/node_modules/**",

		// Exclude complex TypeScript files that cause Babel errors
		"!places/*/src/**/data/**",
		"!places/*/src/**/factories/**",
		"!places/*/src/**/types/**",
		"!places/*/src/**/constants/**",
		"!places/*/src/**/utils/**",
		"!places/*/src/**/services/**", // Services have decorators
		"!places/*/src/**/components/**", // Components might have decorators
	],

	// Coverage thresholds - set to 0 for now since these files aren't directly tested
	coverageThreshold: {
		global: {
			branches: 0,
			functions: 0,
			lines: 0,
			statements: 0,
		},
	},

	// Override transform to use our custom transformer
	transform: {
		"^.+\\.(ts|tsx)$": "<rootDir>/scripts/js/jest-transformer.js",
	},

	// Coverage reporting
	coverageReporters: ["text", "html", "lcov"],
};
