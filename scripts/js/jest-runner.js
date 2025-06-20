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
		const results = [];

		// Extract test name pattern from Jest's options or context
		let testPattern = "";

		// Check multiple possible sources for test pattern
		if (options.testNamePattern) {
			testPattern = options.testNamePattern.source || options.testNamePattern;
		} else if (this._globalConfig.testNamePattern) {
			testPattern = this._globalConfig.testNamePattern.source || this._globalConfig.testNamePattern;
		}

		for (const test of tests) {
			onStart(test);

			try {
				// Run our cloud test pipeline with optional test pattern
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
		// Parse the actual test structure from the TypeScript file
		const testStructure = this.parseTestStructure(testFilePath);

		// Parse test results from Jest-Lua output
		const lines = output.split("\n");
		let numPassedTests = 0;
		let numFailedTests = 0;
		let numSkippedTests = 0;
		let testResults = [];

		// Updated patterns to match actual Jest-Lua output format
		const testCountPattern =
			/Tests:\s+(?:(\d+)\s+skipped,\s*)?(?:(\d+)\s+failed,\s*)?(\d+)\s+passed,\s+(\d+)\s+total/;
		const passPattern = /PASS\s+.*test\.spec/;
		const failPattern = /FAIL\s+.*test\.spec/;
		let failureMessage = "";
		let foundTestResults = false;

		// Extract individual test outputs by parsing print statements
		const testOutputs = this.parseIndividualTestOutputs(output, testStructure.tests);

		lines.forEach((line) => {
			const testCountMatch = line.match(testCountPattern);
			if (testCountMatch) {
				numSkippedTests = parseInt(testCountMatch[1]) || 0;
				numFailedTests = parseInt(testCountMatch[2]) || 0;
				numPassedTests = parseInt(testCountMatch[3]) || 0;
				const totalTests = parseInt(testCountMatch[4]) || 0;
				foundTestResults = true;
			}

			// Check for pass/fail indicators
			if (passPattern.test(line)) {
				foundTestResults = true;
			}
			if (failPattern.test(line)) {
				foundTestResults = true;
				numFailedTests = Math.max(numFailedTests, 1); // Ensure we count failures
			}

			// Collect failure information
			if (line.includes("FAIL") || line.includes("✖") || line.includes("Error") || line.includes("failed")) {
				failureMessage += line + "\n";
			}
		});
		// If we didn't find proper test results, assume something went wrong
		if (!foundTestResults && output.trim().length > 0) {
			numFailedTests = testStructure.tests.length;
			numPassedTests = 0;
			failureMessage = "Could not parse test results from cloud output:\n" + output;
		} else if (!foundTestResults) {
			numFailedTests = testStructure.tests.length;
			numPassedTests = 0;
			failureMessage = "No output received from cloud test execution";
		}
		// Use the dynamically parsed test structure
		// For filtered runs, we need to return ALL tests but mark non-matching ones as skipped
		const actualTestResults = [];

		testStructure.tests.forEach((testInfo, index) => {
			// Get the output for this specific test
			const testOutput = testOutputs[index];

			// Determine if this specific test passed, failed, or was skipped based on the actual Jest output
			let status = "pending"; // Default to pending/skipped
			let testFailureMessage = "";

			if (foundTestResults) {
				// We have valid Jest results, determine test status based on overall results
				if (numFailedTests > 0 && failureMessage && failureMessage.trim()) {
					// There were failures - check if this test is mentioned in failure output
					const testNameInFailure =
						failureMessage.toLowerCase().includes(testInfo.name.toLowerCase()) ||
						failureMessage.toLowerCase().includes(testInfo.fullName.toLowerCase());

					if (testNameInFailure) {
						status = "failed";
						testFailureMessage = failureMessage;
					} else {
						// Not in failure output, check if it was skipped or passed
						// If we have a test pattern, use it to determine which tests should have run
						if (testPattern) {
							const testMatches =
								testInfo.name.toLowerCase().includes(testPattern.toLowerCase()) ||
								testInfo.fullName.toLowerCase().includes(testPattern.toLowerCase());
							status = testMatches ? "passed" : "pending";
						} else {
							status = numSkippedTests > 0 ? "pending" : "passed";
						}
					}
				} else if (numPassedTests > 0 && numFailedTests === 0) {
					// We have passed tests and no failures
					if (numSkippedTests > 0 && testPattern) {
						// For filtered runs, only tests matching the pattern should pass
						const testMatches =
							testInfo.name.toLowerCase().includes(testPattern.toLowerCase()) ||
							testInfo.fullName.toLowerCase().includes(testPattern.toLowerCase());
						status = testMatches ? "passed" : "pending";
					} else if (numSkippedTests > 0) {
						// Some tests were skipped - we need to figure out which ones
						// We'll assume the first numPassedTests in our list are the ones that passed
						const testIndex = testStructure.tests.indexOf(testInfo);
						status = testIndex < numPassedTests ? "passed" : "pending";
					} else {
						// All tests passed
						status = "passed";
					}
				} else if (numSkippedTests > 0 && numPassedTests === 0 && numFailedTests === 0) {
					// All tests were skipped
					status = "pending";
				} else {
					// No clear indication, mark as skipped
					status = "pending";
				}
			} else {
				// No results found at all, assume failure for all tests
				status = "failed";
				testFailureMessage = failureMessage || "Test failed in cloud execution";
			}

			// Always include all tests in results
			actualTestResults.push({
				ancestorTitles: testInfo.ancestorTitles,
				duration: status === "passed" ? 100 : 0,
				failureMessages:
					status === "failed"
						? [testFailureMessage || failureMessage || "Test failed in cloud execution"]
						: [],
				fullName: testInfo.fullName,
				location: {
					column: 1,
					line: testInfo.line,
				},
				status: status,
				title: testInfo.name,
				// Console output for individual test results
				console:
					testOutput && testOutput.trim() && !testOutput.includes("No specific output")
						? [
								{
									message: testOutput.trim(),
									origin: testFilePath + ":" + testInfo.line,
									type: "log",
								},
							]
						: [],
			});
		});

		return {
			numPassedTests,
			numFailedTests,
			numSkippedTests,
			testResults: actualTestResults,
			testOutputs: testOutputs,
			failureMessage: numFailedTests > 0 ? failureMessage : null,
		};
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
}

module.exports = RobloxTestRunner;
