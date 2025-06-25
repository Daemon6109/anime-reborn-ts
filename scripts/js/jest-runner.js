// Custom Jest runner for Roblox cloud test execution
// This runner integrates with real Jest but executes tests via our cloud pipeline
//
// Features:
// - Dynamic test discovery from TypeScript files
// - Single test execution with filtering support
// - Cloud pipeline integration via shell scripts
// - Console output capture and mapping to individual tests
// - Cross-platform compatibility (Windows/Unix)
//
// Usage:
// - All tests: npx jest
// - Single test: npx jest --testNamePattern="test name"
// - Works with VS Code Jest extension for Test Explorer integration

const { execSync } = require("child_process");
const path = require("path");
const fs = require("fs");

class RobloxTestRunner {
	constructor(globalConfig, context) {
		this._globalConfig = globalConfig;
		this._context = context;
		this._cloudTestsExecuted = false; // Flag to prevent multiple executions
		this._cloudTestResults = null; // Store results from cloud execution

		// Detect if we're being called by VS Code Jest extension or other tools
		this._isVSCodeJest = this._detectVSCodeJest(globalConfig);
	}

	_detectVSCodeJest(globalConfig) {
		// Check for VS Code Jest extension patterns
		const argv = process.argv;
		const hasVSCodeReporter = argv.some((arg) => arg.includes("vscode-jest") && arg.includes("reporter.js"));
		const hasTempConfig = argv.some((arg) => arg.includes("/tmp/jest_runner_"));
		const hasVSCodeArgs = argv.includes("default") && argv.length > 5;

		return hasVSCodeReporter || hasTempConfig || hasVSCodeArgs;
	}

	// Parse test structure from TypeScript file
	parseTestStructure(testFilePath) {
		try {
			const fileContent = fs.readFileSync(testFilePath, "utf8");
			const lines = fileContent.split("\n");
			const testStructure = {
				describes: [],
				tests: [],
			};

			let currentDescribeStack = [];
			let currentDescribe = null;

			lines.forEach((line, lineIndex) => {
				const lineNumber = lineIndex + 1;

				// Check for describe blocks
				const describeMatch = line.match(/describe\s*\(\s*["'`]([^"'`]+)["'`]/);
				if (describeMatch) {
					const describeName = describeMatch[1];
					const indentLevel = line.match(/^\s*/)[0].length / 4 || 0; // Assuming 4-space indentation

					// Adjust the describe stack based on indentation
					currentDescribeStack = currentDescribeStack.slice(0, indentLevel);
					currentDescribeStack.push(describeName);
					currentDescribe = describeName;

					testStructure.describes.push({
						name: describeName,
						line: lineNumber,
						ancestorTitles: [...currentDescribeStack.slice(0, -1)],
						fullPath: [...currentDescribeStack],
					});
				}

				// Check for it/test blocks
				const testMatch = line.match(/(?:it|test)\s*\(\s*["'`]([^"'`]+)["'`]/);
				if (testMatch) {
					const testName = testMatch[1];
					testStructure.tests.push({
						name: testName,
						line: lineNumber,
						ancestorTitles: [...currentDescribeStack],
						fullName: [...currentDescribeStack, testName].join(" "),
					});
				}
			});

			return testStructure;
		} catch (error) {
			console.error(`[ERROR] Failed to parse test structure from ${testFilePath}:`, error.message);
			return {
				describes: [{ name: "Unknown", line: 1, ancestorTitles: [], fullPath: ["Unknown"] }],
				tests: [
					{ name: "Unknown test", line: 1, ancestorTitles: ["Unknown"], fullName: "Unknown Unknown test" },
				],
			};
		}
	}
	async runTests(tests, watcher, onStart, onResult, onFailure, options) {
		// If VS Code Jest extension is calling us, fall back to simpler behavior
		if (this._isVSCodeJest) {
			console.log(`Detected VS Code Jest extension - using individual test execution mode`);
			return this._runTestsForVSCode(tests, watcher, onStart, onResult, onFailure, options);
		}

		// Check if we're running in terminal mode (not VS Code)
		const isTerminalMode = !this._isVSCodeJest && process.stdout.isTTY;

		const results = [];

		// Extract test name pattern from Jest's options or context
		let testPattern = "";

		// Check multiple possible sources for test pattern
		if (options.testNamePattern) {
			testPattern = options.testNamePattern.source || options.testNamePattern;
		} else if (this._globalConfig.testNamePattern) {
			testPattern = this._globalConfig.testNamePattern.source || this._globalConfig.testNamePattern;
		}

		// Run cloud tests only once for all test files
		if (!this._cloudTestsExecuted) {
			console.log(`Running cloud tests once for ${tests.length} test files...`);

			if (isTerminalMode) {
				console.log(`🚀 Executing tests via Roblox OpenCloud...`);
			}

			try {
				// Execute cloud test pipeline once
				this._cloudTestResults = await this.runCloudTestsOnce(testPattern);
				this._cloudTestsExecuted = true;

				if (isTerminalMode) {
					console.log(`✅ Cloud test execution completed`);
				}
			} catch (error) {
				console.error(`Cloud test execution failed:`, error.message);
				if (isTerminalMode) {
					console.log(`❌ Cloud test execution failed: ${error.message}`);
				}
				this._cloudTestResults = {
					failed: true,
					error: error.message,
				};
				this._cloudTestsExecuted = true;
			}
		}

		// Process each test file and extract results from the single cloud execution
		for (const test of tests) {
			onStart(test);

			try {
				// Extract results for this specific test file from cloud results
				const result = this.extractTestResultFromCloud(test, testPattern);

				// Add better terminal output formatting
				if (isTerminalMode && result) {
					const testFileName = test.path.split("/").pop();
					if (result.numFailingTests > 0) {
						console.log(
							`❌ ${testFileName} - ${result.numFailingTests} failed, ${result.numPassingTests} passed`,
						);
					} else if (result.numPassingTests > 0) {
						console.log(`✅ ${testFileName} - ${result.numPassingTests} passed`);
					}
				}

				results.push(result);
				onResult(test, result);
			} catch (error) {
				if (isTerminalMode) {
					const testFileName = test.path.split("/").pop();
					console.log(`❌ ${testFileName} - Test execution error: ${error.message}`);
				}
				onFailure(test, error);
			}
		}

		return {
			numTotalTestSuites: tests.length,
			numPassedTestSuites: results.filter((r) => r.numFailingTests === 0).length,
			numFailedTestSuites: results.filter((r) => r.numFailingTests > 0).length,
			numPendingTestSuites: 0,
			testResults: results,
			snapshot: {
				added: 0,
				fileDeleted: false,
				matched: 0,
				unchecked: 0,
				uncheckedKeys: [],
				unmatched: 0,
				updated: 0,
			},
			startTime: Date.now(),
			success: results.every((r) => r.numFailingTests === 0),
		};
	}

	async runSingleTest(testPath, testPattern = "") {
		const startTime = Date.now();
		try {
			// Execute our cloud test script
			const scriptPath = path.join(__dirname, "..", "shell", "test-with-output.sh");
			const outputFile = path.join(__dirname, "..", "..", "test-output.log");

			// Clear any previous output file
			const fs = require("fs");
			if (fs.existsSync(outputFile)) {
				fs.unlinkSync(outputFile);
			}

			// Execute script and capture output properly
			let testOutput = "";
			let hasOutput = false;

			let scriptExitCode = 0;
			try {
				// Build command with optional test pattern
				const command = testPattern ? `"${scriptPath}" "${testPattern}"` : `"${scriptPath}"`;

				// Run the script and wait for completion
				execSync(command, {
					encoding: "utf8",
					cwd: path.join(__dirname, "..", ".."),
					stdio: ["pipe", "inherit", "inherit"], // Let output go to console
					shell: true,
					timeout: 120000, // 2 minute timeout
					windowsHide: false,
				});

				// Script succeeded (exit 0)
				scriptExitCode = 0;

				// Read output from file
				if (fs.existsSync(outputFile)) {
					testOutput = fs.readFileSync(outputFile, "utf8");
					hasOutput = true;
				}
			} catch (error) {
				// Script failed - capture the exit code
				scriptExitCode = error.status || 1;
				console.error(`[ERROR] Test script failed with exit code ${scriptExitCode}:`, error.message);

				// Try to read output file even if script failed
				if (fs.existsSync(outputFile)) {
					testOutput = fs.readFileSync(outputFile, "utf8");
					hasOutput = true;
				}

				// If script failed, we should treat this as test failure regardless of output parsing
				if (!hasOutput) {
					testOutput = `Test script execution failed: ${error.message}\nExit code: ${scriptExitCode}`;
				}
			}

			// Parse the Jest-Lua output to get actual results
			const parsedResults = this.parseJestOutput(testOutput, testPath.path, testPattern);

			// If script failed (non-zero exit code), force test failure regardless of output parsing
			if (scriptExitCode !== 0) {
				console.error(
					`[ERROR] Test script failed with exit code ${scriptExitCode} - treating all tests as failed`,
				);

				// Override parsed results to ensure failure is reported
				parsedResults.numFailedTests = Math.max(parsedResults.numFailedTests, 1);
				parsedResults.numPassedTests = 0; // No tests can pass if script failed

				// Ensure we have a failure message
				if (!parsedResults.failureMessage) {
					parsedResults.failureMessage = `Test execution failed with exit code ${scriptExitCode}`;
				}

				// Mark all test results as failed
				parsedResults.testResults = parsedResults.testResults.map((test) => ({
					...test,
					status: "failed",
					failureMessages:
						test.failureMessages.length > 0
							? test.failureMessages
							: [`Test execution failed with exit code ${scriptExitCode}`],
				}));
			}

			return {
				console:
					parsedResults.testOutputs && parsedResults.testOutputs.length > 0
						? parsedResults.testOutputs
								.filter((output) => output && output.trim() && !output.includes("No output captured"))
								.map((output) => ({
									message: output.trim(),
									origin: "",
									type: "log",
								}))
						: null,
				failureMessage: parsedResults.numFailedTests > 0 ? parsedResults.failureMessage : null,
				numFailingTests: parsedResults.numFailedTests,
				numPassingTests: parsedResults.numPassedTests,
				numPendingTests: parsedResults.numSkippedTests || 0,
				perfStats: {
					end: Date.now(),
					start: startTime,
				},
				skipped: false,
				snapshot: {
					added: 0,
					fileDeleted: false,
					matched: 0,
					unchecked: 0,
					uncheckedKeys: [],
					unmatched: 0,
					updated: 0,
				},
				sourceMaps: {},
				testFilePath: testPath.path,
				testResults: parsedResults.testResults,
			};
		} catch (error) {
			console.error(`Error running cloud tests:`, error.message);

			return {
				console: null,
				failureMessage: `Cloud test execution failed: ${error.message}`,
				numFailingTests: 1,
				numPassingTests: 0,
				numPendingTests: 0,
				perfStats: {
					end: Date.now(),
					start: startTime,
				},
				skipped: false,
				snapshot: {
					added: 0,
					fileDeleted: false,
					matched: 0,
					unchecked: 0,
					uncheckedKeys: [],
					unmatched: 0,
					updated: 0,
				},
				sourceMaps: {},
				testFilePath: testPath.path,
				testResults: [
					{
						ancestorTitles: [],
						duration: Date.now() - startTime,
						failureMessages: [error.message],
						fullName: "Cloud Test Execution",
						location: null,
						status: "failed",
						title: "Cloud Test Execution",
					},
				],
			};
		}
	}
	// Parse Jest output for a specific test file from multi-file cloud results
	parseJestOutputForFile(output, testFilePath, testPattern = "") {
		const testStructure = this.parseTestStructure(testFilePath);

		// Extract the test file name/pattern that Jest-Lua uses
		const filePattern = testFilePath.replace(/.*\/(places\/[^\/]+\/src\/tests\/[^\/]+\.spec)\.ts$/, "$1");

		// Initialize counters for this specific file
		let numPassedTests = 0;
		let numFailedTests = 0;
		let numSkippedTests = 0;
		let testResults = [];
		let failureMessage = "";
		let foundTestResults = false;

		const lines = output.split("\n");
		let inRelevantSection = false;
		let currentFileResults = [];

		// Look for this specific test file's results in the output
		for (let i = 0; i < lines.length; i++) {
			const line = lines[i];

			// Check if this line is about our test file
			if (line.includes(filePattern) || line.includes(testFilePath.split("/").pop().replace(".ts", ""))) {
				// Check for PASS/FAIL indicators for this file
				if (
					line.includes("PASS") &&
					(line.includes(filePattern) ||
						line.includes("AFK") ||
						line.includes("LOBBY") ||
						line.includes("COMMON") ||
						line.includes("GAMEPLAY"))
				) {
					foundTestResults = true;
					inRelevantSection = true;

					// Parse individual test results that follow
					for (let j = i + 1; j < lines.length; j++) {
						const testLine = lines[j];

						// Stop if we hit another file's results or summary
						if (testLine.match(/^\s*PASS|^\s*FAIL|Test Suites:/)) {
							break;
						}

						// Count individual test results
						if (testLine.includes("✓")) {
							numPassedTests++;
						} else if (testLine.includes("○")) {
							numSkippedTests++;
						} else if (testLine.includes("✗") || testLine.includes("✖")) {
							numFailedTests++;
						}
					}
				} else if (
					line.includes("FAIL") &&
					(line.includes(filePattern) ||
						line.includes("AFK") ||
						line.includes("LOBBY") ||
						line.includes("COMMON") ||
						line.includes("GAMEPLAY"))
				) {
					foundTestResults = true;
					inRelevantSection = true;
					numFailedTests = Math.max(numFailedTests, 1);

					// Collect failure information for this file
					for (let j = i; j < lines.length && j < i + 20; j++) {
						const failLine = lines[j];
						if (failLine.includes("PASS") || failLine.includes("Test Suites:")) {
							break;
						}
						if (failLine.includes("✖") || failLine.includes("Error") || failLine.includes("failed")) {
							failureMessage += failLine + "\n";
						}
					}
				}
			}
		}

		// If no specific results found, try to extract from overall summary
		if (!foundTestResults) {
			// Fall back to parsing overall results and distributing them
			const testCountPattern =
				/Tests:\s+(?:(\d+)\s+skipped,\s*)?(?:(\d+)\s+failed,\s*)?(\d+)\s+passed,\s+(\d+)\s+total/;
			lines.forEach((line) => {
				const testCountMatch = line.match(testCountPattern);
				if (testCountMatch) {
					// For now, assume this file has some of the overall results
					// This is a fallback - the above parsing should handle most cases
					const totalSkipped = parseInt(testCountMatch[1]) || 0;
					const totalFailed = parseInt(testCountMatch[2]) || 0;
					const totalPassed = parseInt(testCountMatch[3]) || 0;

					// Distribute results proportionally (rough estimate)
					const fileTestCount = testStructure.tests.length;
					const totalTests = parseInt(testCountMatch[4]) || 1;
					const ratio = fileTestCount / totalTests;

					numSkippedTests = Math.round(totalSkipped * ratio);
					numFailedTests = Math.round(totalFailed * ratio);
					numPassedTests = Math.round(totalPassed * ratio);
					foundTestResults = true;
				}
			});
		}

		// Build test results for this specific file
		testStructure.tests.forEach((testInfo, index) => {
			let status = "pending";
			let testFailureMessage = "";

			if (foundTestResults) {
				// Determine status based on what we found for this file
				if (numFailedTests > 0 && index < numFailedTests) {
					status = "failed";
					testFailureMessage = failureMessage;
				} else if (numPassedTests > 0 && index < numPassedTests) {
					status = "passed";
				} else {
					status = "pending";
				}
			}

			testResults.push({
				ancestorTitles: testInfo.ancestorTitles,
				duration: status === "passed" ? 100 : 0,
				failureMessages: status === "failed" ? [testFailureMessage || "Test failed in cloud execution"] : [],
				fullName: testInfo.fullName,
				location: {
					column: 1,
					line: testInfo.line,
				},
				status: status,
				title: testInfo.name,
			});
		});

		return {
			numPassedTests,
			numFailedTests,
			numSkippedTests,
			testResults: testResults,
			failureMessage: numFailedTests > 0 ? failureMessage : null,
		};
	}

	parseJestOutput(output, testFilePath, testPattern = "") {
		// Use the new file-specific parsing method
		return this.parseJestOutputForFile(output, testFilePath, testPattern);
	}

	async runTests(tests, watcher, onStart, onResult, onFailure, options) {
		// If VS Code Jest extension is calling us, fall back to simpler behavior
		if (this._isVSCodeJest) {
			console.log(`Detected VS Code Jest extension - using individual test execution mode`);
			return this._runTestsForVSCode(tests, watcher, onStart, onResult, onFailure, options);
		}

		// Check if we're running in terminal mode (not VS Code)
		const isTerminalMode = !this._isVSCodeJest && process.stdout.isTTY;

		const results = [];

		// Extract test name pattern from Jest's options or context
		let testPattern = "";

		// Check multiple possible sources for test pattern
		if (options.testNamePattern) {
			testPattern = options.testNamePattern.source || options.testNamePattern;
		} else if (this._globalConfig.testNamePattern) {
			testPattern = this._globalConfig.testNamePattern.source || this._globalConfig.testNamePattern;
		}

		// Run cloud tests only once for all test files
		if (!this._cloudTestsExecuted) {
			console.log(`Running cloud tests once for ${tests.length} test files...`);

			if (isTerminalMode) {
				console.log(`🚀 Executing tests via Roblox OpenCloud...`);
			}

			try {
				// Execute cloud test pipeline once
				this._cloudTestResults = await this.runCloudTestsOnce(testPattern);
				this._cloudTestsExecuted = true;

				if (isTerminalMode) {
					console.log(`✅ Cloud test execution completed`);
				}
			} catch (error) {
				console.error(`Cloud test execution failed:`, error.message);
				if (isTerminalMode) {
					console.log(`❌ Cloud test execution failed: ${error.message}`);
				}
				this._cloudTestResults = {
					failed: true,
					error: error.message,
				};
				this._cloudTestsExecuted = true;
			}
		}

		// Process each test file and extract results from the single cloud execution
		for (const test of tests) {
			onStart(test);

			try {
				// Extract results for this specific test file from cloud results
				const result = this.extractTestResultFromCloud(test, testPattern);

				// Add better terminal output formatting
				if (isTerminalMode && result) {
					const testFileName = test.path.split("/").pop();
					if (result.numFailingTests > 0) {
						console.log(
							`❌ ${testFileName} - ${result.numFailingTests} failed, ${result.numPassingTests} passed`,
						);
					} else if (result.numPassingTests > 0) {
						console.log(`✅ ${testFileName} - ${result.numPassingTests} passed`);
					}
				}

				results.push(result);
				onResult(test, result);
			} catch (error) {
				if (isTerminalMode) {
					const testFileName = test.path.split("/").pop();
					console.log(`❌ ${testFileName} - Test execution error: ${error.message}`);
				}
				onFailure(test, error);
			}
		}

		return {
			numTotalTestSuites: tests.length,
			numPassedTestSuites: results.filter((r) => r.numFailingTests === 0).length,
			numFailedTestSuites: results.filter((r) => r.numFailingTests > 0).length,
			numPendingTestSuites: 0,
			testResults: results,
			snapshot: {
				added: 0,
				fileDeleted: false,
				matched: 0,
				unchecked: 0,
				uncheckedKeys: [],
				unmatched: 0,
				updated: 0,
			},
			startTime: Date.now(),
			success: results.every((r) => r.numFailingTests === 0),
		};
	}

	async runSingleTest(testPath, testPattern = "") {
		const startTime = Date.now();
		try {
			// Execute our cloud test script
			const scriptPath = path.join(__dirname, "..", "shell", "test-with-output.sh");
			const outputFile = path.join(__dirname, "..", "..", "test-output.log");

			// Clear any previous output file
			const fs = require("fs");
			if (fs.existsSync(outputFile)) {
				fs.unlinkSync(outputFile);
			}

			// Execute script and capture output properly
			let testOutput = "";
			let hasOutput = false;

			let scriptExitCode = 0;
			try {
				// Build command with optional test pattern
				const command = testPattern ? `"${scriptPath}" "${testPattern}"` : `"${scriptPath}"`;

				// Run the script and wait for completion
				execSync(command, {
					encoding: "utf8",
					cwd: path.join(__dirname, "..", ".."),
					stdio: ["pipe", "inherit", "inherit"], // Let output go to console
					shell: true,
					timeout: 120000, // 2 minute timeout
					windowsHide: false,
				});

				// Script succeeded (exit 0)
				scriptExitCode = 0;

				// Read output from file
				if (fs.existsSync(outputFile)) {
					testOutput = fs.readFileSync(outputFile, "utf8");
					hasOutput = true;
				}
			} catch (error) {
				// Script failed - capture the exit code
				scriptExitCode = error.status || 1;
				console.error(`[ERROR] Test script failed with exit code ${scriptExitCode}:`, error.message);

				// Try to read output file even if script failed
				if (fs.existsSync(outputFile)) {
					testOutput = fs.readFileSync(outputFile, "utf8");
					hasOutput = true;
				}

				// If script failed, we should treat this as test failure regardless of output parsing
				if (!hasOutput) {
					testOutput = `Test script execution failed: ${error.message}\nExit code: ${scriptExitCode}`;
				}
			}

			// Parse the Jest-Lua output to get actual results
			const parsedResults = this.parseJestOutput(testOutput, testPath.path, testPattern);

			// If script failed (non-zero exit code), force test failure regardless of output parsing
			if (scriptExitCode !== 0) {
				console.error(
					`[ERROR] Test script failed with exit code ${scriptExitCode} - treating all tests as failed`,
				);

				// Override parsed results to ensure failure is reported
				parsedResults.numFailedTests = Math.max(parsedResults.numFailedTests, 1);
				parsedResults.numPassedTests = 0; // No tests can pass if script failed

				// Ensure we have a failure message
				if (!parsedResults.failureMessage) {
					parsedResults.failureMessage = `Test execution failed with exit code ${scriptExitCode}`;
				}

				// Mark all test results as failed
				parsedResults.testResults = parsedResults.testResults.map((test) => ({
					...test,
					status: "failed",
					failureMessages:
						test.failureMessages.length > 0
							? test.failureMessages
							: [`Test execution failed with exit code ${scriptExitCode}`],
				}));
			}

			return {
				console:
					parsedResults.testOutputs && parsedResults.testOutputs.length > 0
						? parsedResults.testOutputs
								.filter((output) => output && output.trim() && !output.includes("No output captured"))
								.map((output) => ({
									message: output.trim(),
									origin: "",
									type: "log",
								}))
						: null,
				failureMessage: parsedResults.numFailedTests > 0 ? parsedResults.failureMessage : null,
				numFailingTests: parsedResults.numFailedTests,
				numPassingTests: parsedResults.numPassedTests,
				numPendingTests: parsedResults.numSkippedTests || 0,
				perfStats: {
					end: Date.now(),
					start: startTime,
				},
				skipped: false,
				snapshot: {
					added: 0,
					fileDeleted: false,
					matched: 0,
					unchecked: 0,
					uncheckedKeys: [],
					unmatched: 0,
					updated: 0,
				},
				sourceMaps: {},
				testFilePath: testPath.path,
				testResults: parsedResults.testResults,
			};
		} catch (error) {
			console.error(`Error running cloud tests:`, error.message);

			return {
				console: null,
				failureMessage: `Cloud test execution failed: ${error.message}`,
				numFailingTests: 1,
				numPassingTests: 0,
				numPendingTests: 0,
				perfStats: {
					end: Date.now(),
					start: startTime,
				},
				skipped: false,
				snapshot: {
					added: 0,
					fileDeleted: false,
					matched: 0,
					unchecked: 0,
					uncheckedKeys: [],
					unmatched: 0,
					updated: 0,
				},
				sourceMaps: {},
				testFilePath: testPath.path,
				testResults: [
					{
						ancestorTitles: [],
						duration: Date.now() - startTime,
						failureMessages: [error.message],
						fullName: "Cloud Test Execution",
						location: null,
						status: "failed",
						title: "Cloud Test Execution",
					},
				],
			};
		}
	}
	parseJestOutput(output, testFilePath, testPattern = "") {
		// Use the new file-specific parsing method
		return this.parseJestOutputForFile(output, testFilePath, testPattern);
	}

	// Parse individual test outputs from the overall output
	parseIndividualTestOutputs(output, testInfos) {
		const testOutputs = [];

		// Since the current Jest-Lua output doesn't include individual test execution details
		// with emojis anymore, we'll use the overall test results and create generic outputs
		const lines = output.split("\n");

		// Look for the Jest summary line to understand overall results
		const testSummaryLine = lines.find((line) => line.includes("Tests:") && line.includes("total"));

		// Check if tests passed or failed based on PASS/FAIL indicators
		const hasPassIndicator = lines.some((line) => line.includes("PASS"));
		const hasFailIndicator = lines.some((line) => line.includes("FAIL"));

		// For each test, create appropriate output based on overall results
		return testInfos.map((testInfo) => {
			if (hasFailIndicator) {
				return `Test execution completed - check failure details in summary`;
			} else if (hasPassIndicator && testSummaryLine) {
				return `Test execution completed successfully - ${testSummaryLine.trim()}`;
			} else {
				return `No specific output captured for: ${testInfo.name}`;
			}
		});
	}

	async runCloudTestsOnce(testPattern = "") {
		console.log("Executing cloud test pipeline once for all tests...");

		try {
			// Execute our cloud test script
			const scriptPath = path.join(__dirname, "..", "shell", "test-with-output.sh");
			const outputFile = path.join(__dirname, "..", "..", "test-output.log");

			// Clear any previous output file
			const fs = require("fs");
			if (fs.existsSync(outputFile)) {
				fs.unlinkSync(outputFile);
			}

			// Execute script and capture output properly
			let testOutput = "";
			let hasOutput = false;
			let scriptExitCode = 0;

			try {
				// Build command with optional test pattern
				const command = testPattern ? `"${scriptPath}" "${testPattern}"` : `"${scriptPath}"`;

				// Run the script and wait for completion
				execSync(command, {
					encoding: "utf8",
					cwd: path.join(__dirname, "..", ".."),
					stdio: ["pipe", "inherit", "inherit"], // Let output go to console
					shell: true,
					timeout: 120000, // 2 minute timeout
					windowsHide: false,
				});

				// Script succeeded (exit 0)
				scriptExitCode = 0;

				// Read output from file
				if (fs.existsSync(outputFile)) {
					testOutput = fs.readFileSync(outputFile, "utf8");
					hasOutput = true;
				}
			} catch (error) {
				// Script failed - capture the exit code
				scriptExitCode = error.status || 1;
				console.error(`[ERROR] Test script failed with exit code ${scriptExitCode}:`, error.message);

				// Try to read output file even if script failed
				if (fs.existsSync(outputFile)) {
					testOutput = fs.readFileSync(outputFile, "utf8");
					hasOutput = true;
				}

				// If script failed, we should treat this as test failure
				if (!hasOutput) {
					testOutput = `Test script execution failed: ${error.message}\nExit code: ${scriptExitCode}`;
				}
			}

			return {
				testOutput,
				scriptExitCode,
				hasOutput,
				testPattern,
			};
		} catch (error) {
			console.error(`[ERROR] Cloud test execution failed:`, error.message);
			throw error;
		}
	}

	extractTestResultFromCloud(testPath, testPattern = "") {
		const startTime = Date.now();

		// If cloud tests failed to execute, return failure for this test
		if (this._cloudTestResults.failed) {
			return {
				console: null,
				failureMessage: `Cloud test execution failed: ${this._cloudTestResults.error}`,
				numFailingTests: 1,
				numPassingTests: 0,
				numPendingTests: 0,
				perfStats: {
					end: Date.now(),
					start: startTime,
				},
				skipped: false,
				snapshot: {
					added: 0,
					fileDeleted: false,
					matched: 0,
					unchecked: 0,
					uncheckedKeys: [],
					unmatched: 0,
					updated: 0,
				},
				sourceMaps: {},
				testFilePath: testPath.path,
				testResults: [
					{
						ancestorTitles: [],
						duration: 0,
						failureMessages: [this._cloudTestResults.error],
						fullName: "Cloud Test Execution",
						location: null,
						status: "failed",
						title: "Cloud Test Execution",
					},
				],
			};
		}

		// Parse the Jest-Lua output to get actual results for this specific test file
		const parsedResults = this.parseJestOutput(
			this._cloudTestResults.testOutput,
			testPath.path,
			this._cloudTestResults.testPattern,
		);

		// If script failed (non-zero exit code), force test failure regardless of output parsing
		if (this._cloudTestResults.scriptExitCode !== 0) {
			console.error(
				`[ERROR] Test script failed with exit code ${this._cloudTestResults.scriptExitCode} - treating tests as failed`,
			);

			// Override parsed results to ensure failure is reported
			parsedResults.numFailedTests = Math.max(parsedResults.numFailedTests, 1);
			parsedResults.numPassedTests = 0; // No tests can pass if script failed

			// Ensure we have a failure message
			if (!parsedResults.failureMessage) {
				parsedResults.failureMessage = `Test execution failed with exit code ${this._cloudTestResults.scriptExitCode}`;
			}

			// Mark all test results as failed
			parsedResults.testResults = parsedResults.testResults.map((test) => ({
				...test,
				status: "failed",
				failureMessages:
					test.failureMessages.length > 0
						? test.failureMessages
						: [`Test execution failed with exit code ${this._cloudTestResults.scriptExitCode}`],
			}));
		}

		return {
			console:
				parsedResults.testOutputs && parsedResults.testOutputs.length > 0
					? parsedResults.testOutputs
							.filter((output) => output && output.trim() && !output.includes("No output captured"))
							.map((output) => ({
								message: output.trim(),
								origin: "",
								type: "log",
							}))
					: null,
			failureMessage: parsedResults.numFailedTests > 0 ? parsedResults.failureMessage : null,
			numFailingTests: parsedResults.numFailedTests,
			numPassingTests: parsedResults.numPassedTests,
			numPendingTests: parsedResults.numSkippedTests || 0,
			perfStats: {
				end: Date.now(),
				start: startTime,
			},
			skipped: false,
			snapshot: {
				added: 0,
				fileDeleted: false,
				matched: 0,
				unchecked: 0,
				uncheckedKeys: [],
				unmatched: 0,
				updated: 0,
			},
			sourceMaps: {},
			testFilePath: testPath.path,
			testResults: parsedResults.testResults,
		};
	}

	async _runTestsForVSCode(tests, watcher, onStart, onResult, onFailure, options) {
		console.log(`VS Code Jest mode: Running ${tests.length} test files individually for better integration`);

		const results = [];

		// Extract test name pattern from Jest's options or context
		let testPattern = "";

		// Check multiple possible sources for test pattern
		if (options.testNamePattern) {
			testPattern = options.testNamePattern.source || options.testNamePattern;
		} else if (this._globalConfig.testNamePattern) {
			testPattern = this._globalConfig.testNamePattern.source || this._globalConfig.testNamePattern;
		}

		// For VS Code, run each test individually to maintain proper integration
		for (const test of tests) {
			onStart(test);

			try {
				// Run our cloud test pipeline for this specific test
				const result = await this.runSingleTest(test, testPattern);
				results.push(result);
				onResult(test, result);
			} catch (error) {
				onFailure(test, error);
			}
		}

		return {
			numTotalTestSuites: tests.length,
			numPassedTestSuites: results.filter((r) => r.numFailingTests === 0).length,
			numFailedTestSuites: results.filter((r) => r.numFailingTests > 0).length,
			numPendingTestSuites: 0,
			testResults: results,
			snapshot: {
				added: 0,
				fileDeleted: false,
				matched: 0,
				unchecked: 0,
				uncheckedKeys: [],
				unmatched: 0,
				updated: 0,
			},
			startTime: Date.now(),
			success: results.every((r) => r.numFailingTests === 0),
		};
	}
}

module.exports = RobloxTestRunner;
