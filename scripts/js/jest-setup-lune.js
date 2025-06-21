/**
 * Jest setup with Lune bridge for real Roblox runtime behavior
 * This replaces manual mockin// Enhanced typeOf function with proper Roblox behavior
global.typeOf = async function(value) {
    if (checkLuneSync()) {
        try {
            let luaValue;
            if (Array.isArray(value)) {
                // Convert JavaScript arrays to Lua table syntax
                luaValue = '{' + value.map(v => JSON.stringify(v)).join(', ') + '}';
            } else if (typeof value === 'object' && value !== null) {
                // Convert JavaScript objects to Lua table syntax
                const pairs = Object.entries(value).map(([k, v]) => `[${JSON.stringify(k)}] = ${JSON.stringify(v)}`);
                luaValue = '{' + pairs.join(', ') + '}';
            } else {
                luaValue = JSON.stringify(value);
            }
            
            const code = `local value = ${luaValue}; return typeof(value)`;
            const result = await luneBridge.execute(code);
            if (!result.success) {
                console.warn('Lune typeOf failed with error:', result.error);
                return "unknown";
            }
            return result.result;
        } catch (error) {
            console.warn('Lune typeOf failed, falling back to mock:', error.message);
        }
    }
    
    // Fallback mock
    if (value === null || value === undefined) return "nil";
    if (typeof value === "object" && Array.isArray(value)) return "table";
    if (typeof value === "object") return "table";
    return typeof value;
};

// Alias for async version for compatibility
global.typeOfAsync = global.typeOf;execution via Lune
 */

const { spawn } = require("child_process");
const path = require("path");

// Lune Bridge Class
class LuneBridge {
	constructor() {
		this.lunePath = "/home/node/.rokit/bin/lune";
		this.bridgeScript = path.join(__dirname, "../lune/test-bridge-simple.luau");
		this.processCache = new Map(); // Cache for reusing processes
	}

	async execute(code) {
		return new Promise((resolve, reject) => {
			const luneProcess = spawn(this.lunePath, ["run", this.bridgeScript, "--execute", code], {
				cwd: path.dirname(this.bridgeScript),
			});

			let stdout = "";
			let stderr = "";

			luneProcess.stdout.on("data", (data) => {
				stdout += data.toString();
			});

			luneProcess.stderr.on("data", (data) => {
				stderr += data.toString();
			});

			luneProcess.on("close", (code) => {
				try {
					if (stdout.trim()) {
						const result = JSON.parse(stdout.trim());
						resolve(result);
					} else if (stderr.trim()) {
						resolve({
							success: false,
							error: stderr.trim(),
							result: null,
						});
					} else {
						resolve({
							success: false,
							error: "No output from Lune process",
							result: null,
						});
					}
				} catch (parseError) {
					resolve({
						success: false,
						error: `Failed to parse Lune output: ${parseError.message}. Raw output: ${stdout}`,
						result: null,
					});
				}
			});

			luneProcess.on("error", (error) => {
				reject(new Error(`Failed to start Lune process: ${error.message}`));
			});
		});
	}

	async checkAvailability() {
		try {
			const result = await this.execute('return "lune_available"');
			return result.success && result.result === "lune_available";
		} catch (error) {
			return false;
		}
	}
}

// Global bridge instance
const luneBridge = new LuneBridge();
let luneAvailable = null; // null means not checked yet

// Function to check Lune availability synchronously on demand
function checkLuneSync() {
	if (luneAvailable !== null) {
		return luneAvailable;
	}

	try {
		// Try a simple synchronous check to see if Lune binary exists
		const { execSync } = require("child_process");
		execSync("lune --version", { stdio: "ignore", timeout: 2000 });
		luneAvailable = true;
	} catch (error) {
		luneAvailable = false;
	}

	return luneAvailable;
}

// Enhanced typeOf that uses Lune (renamed from typeof to avoid conflicts)
// For backward compatibility, we'll make this sync by default and async as a separate function
global.typeOf = function (value) {
	// Sync fallback for compatibility with existing tests
	if (value === null || value === undefined) return "nil";
	if (typeof value === "object" && Array.isArray(value)) return "table";
	if (typeof value === "object") return "table";
	return typeof value;
};

// Async version that uses Lune for real behavior
global.typeOfAsync = async function (value) {
	if (checkLuneSync()) {
		try {
			let luaValue;
			if (Array.isArray(value)) {
				// Convert JavaScript arrays to Lua table syntax
				luaValue = "{" + value.map((v) => JSON.stringify(v)).join(", ") + "}";
			} else if (typeof value === "object" && value !== null) {
				// Convert JavaScript objects to Lua table syntax
				const pairs = Object.entries(value).map(([k, v]) => `[${JSON.stringify(k)}] = ${JSON.stringify(v)}`);
				luaValue = "{" + pairs.join(", ") + "}";
			} else {
				luaValue = JSON.stringify(value);
			}

			const code = `local value = ${luaValue}; return typeof(value)`;
			const result = await luneBridge.execute(code);
			if (!result.success) {
				console.warn("Lune typeOf failed with error:", result.error);
				return "unknown";
			}
			return result.result;
		} catch (error) {
			console.warn("Lune typeOf failed, falling back to mock:", error.message);
		}
	}

	// Fallback mock
	if (value === null || value === undefined) return "nil";
	if (typeof value === "object" && Array.isArray(value)) return "table";
	if (typeof value === "object") return "table";
	return typeof value;
};

// Synchronous version of typeOf for compatibility
global.typeOfSync = function (value) {
	if (value === null || value === undefined) return "nil";
	if (typeof value === "object" && Array.isArray(value)) return "table";
	if (typeof value === "object") return "table";
	return typeof value;
};

// Enhanced tick function
global.tick = async function () {
	if (checkLuneSync()) {
		try {
			const result = await luneBridge.execute("return tick()");
			return result.success ? result.result : Date.now() / 1000;
		} catch (error) {
			console.warn("Lune tick failed, falling back to mock:", error.message);
		}
	}

	// Fallback mock
	return Date.now() / 1000;
};

// Synchronous version of tick for compatibility
global.tickSync = function () {
	return Date.now() / 1000;
};

// Enhanced wait function
global.wait = async function (duration = 0) {
	if (checkLuneSync()) {
		try {
			const result = await luneBridge.execute(`return wait(${duration})`);
			return result.success ? result.result : 0;
		} catch (error) {
			console.warn("Lune wait failed, falling back to mock:", error.message);
		}
	}

	// Fallback mock (no actual waiting in tests)
	return 0;
};

// Enhanced task library
global.task = {
	spawn: function (func, ...args) {
		if (checkLuneSync()) {
			// For Lune, we'll execute the function immediately in tests
			try {
				func(...args);
				return { _luneExecuted: true };
			} catch (error) {
				console.warn("Task spawn error:", error);
				return { _luneExecuted: false };
			}
		} else {
			// Fallback mock
			try {
				func(...args);
				return {};
			} catch (error) {
				console.warn("Mock task.spawn error:", error);
				return {};
			}
		}
	},

	defer: function (func, ...args) {
		if (checkLuneSync()) {
			// For Lune, we'll defer with setTimeout but execute immediately in tests
			setTimeout(() => {
				try {
					func(...args);
				} catch (error) {
					console.warn("Task defer error:", error);
				}
			}, 0);
			return { _luneExecuted: true };
		} else {
			// Fallback mock
			setTimeout(() => {
				try {
					func(...args);
				} catch (error) {
					console.warn("Mock task.defer error:", error);
				}
			}, 0);
			return {};
		}
	},

	wait: async function (duration = 0) {
		if (checkLuneSync()) {
			try {
				const result = await luneBridge.execute(`return task.wait(${duration})`);
				return result.success ? result.result : 0;
			} catch (error) {
				console.warn("Lune task.wait failed, falling back to mock:", error.message);
			}
		}

		// Fallback mock
		return 0;
	},
};

// Mock Roblox services and other globals
global.game = {
	GetService: (serviceName) => {
		return {
			Name: serviceName,
		};
	},
};

global.script = {
	Name: "MockScript",
	Parent: {
		Parent: {
			shared: {
				data: {
					utils: {
						validate: function (data, template) {
							// Simple validation: check if all template keys exist in data
							if (!data || !template) return false;
							for (const key in template) {
								if (!(key in data)) return false;
							}
							return true;
						},
					},
					"data-template": {
						Level: 1,
						XP: 0,
						RobuxSpent: 0,
						CurrentTitle: "",
						EquippedMount: "",
						SlotsApplicable: 3,
						PlayerStatistics: {
							Kills: 0,
							TotalDamage: 0,
							GamesPlayed: 0,
							PlayTime: 0,
						},
						Currencies: {
							Gold: 0,
							Gems: 500,
						},
						Settings: {},
						Inventory: {
							Units: {},
							Items: {},
							MaxUnitStorage: 100,
						},
						_version: 6,
					},
				},
			},
		},
	},
};

global.workspace = {
	Name: "Workspace",
};

// Mock print function
global.print = jest.fn((...args) => {
	// console.log(...args); // Optionally log to Jest console
});

// Utility function to execute arbitrary Luau code
global.executeLuau = async function (code, data = null) {
	if (!checkLuneSync()) {
		throw new Error("Lune bridge not available. Cannot execute Luau code.");
	}

	// If data is provided, we need to inject it into the code
	if (data) {
		// Convert JavaScript object to Lua table syntax
		function jsToLuaTable(obj) {
			if (obj === null || obj === undefined) return "nil";
			if (typeof obj === "string") return `"${obj.replace(/"/g, '\\"')}"`;
			if (typeof obj === "number" || typeof obj === "boolean") return String(obj);
			if (Array.isArray(obj)) {
				const items = obj.map((item) => jsToLuaTable(item)).join(", ");
				return `{${items}}`;
			}
			if (typeof obj === "object") {
				const pairs = Object.entries(obj)
					.map(([k, v]) => `["${k}"] = ${jsToLuaTable(v)}`)
					.join(", ");
				return `{${pairs}}`;
			}
			return "nil";
		}

		const luaData = jsToLuaTable(data);
		// Replace the ... (varargs) with the actual data
		const modifiedCode = code.replace(/local\s+(\w+)\s*=\s*\.\.\./, `local $1 = ${luaData}`);
		return await luneBridge.execute(modifiedCode);
	}

	return await luneBridge.execute(code);
};

// Utility to check if Lune is available in tests
global.isLuneAvailable = function () {
	return checkLuneSync();
};

// Mock require function for module loading in tests
global.require = function (modulePath) {
	const fs = require("fs");
	const path = require("path");

	// Handle script.Parent.Parent... style paths
	if (typeof modulePath === "object" && modulePath.toString) {
		const pathStr = modulePath.toString();

		// Parse script paths like "script.Parent.Parent.shared.data.utils.validate"
		if (pathStr.includes("script.Parent")) {
			// Extract the module path parts
			const parts = pathStr.split(".");
			const moduleIndex = parts.findIndex((part) => part === "script");

			if (moduleIndex !== -1) {
				// Remove "script" and "Parent" parts, build actual file path
				const moduleParts = parts.slice(moduleIndex + 1).filter((part) => part !== "Parent");

				// Try to find the file in the common place
				const possiblePaths = [
					path.join(process.cwd(), "places", "common", "src", ...moduleParts) + ".ts",
					path.join(process.cwd(), "places", "common", "src", ...moduleParts) + ".lua",
					path.join(process.cwd(), "places", "common", "src", ...moduleParts) + ".luau",
					path.join(process.cwd(), "old_common", "src", ...moduleParts) + ".lua",
					path.join(process.cwd(), "old_common", "src", ...moduleParts) + ".luau",
				];

				for (const filePath of possiblePaths) {
					if (fs.existsSync(filePath)) {
						try {
							// For TypeScript files, try to require the compiled version or mock it
							if (filePath.endsWith(".ts")) {
								// Mock the module export based on file name
								if (filePath.includes("validate")) {
									return function (data, template) {
										// Simple validation mock
										return typeof data === "object" && data !== null;
									};
								}
								if (filePath.includes("data-template")) {
									return {
										_version: 2,
										// Mock template structure
									};
								}
							}

							// For Lua files, read and return as string for now
							if (filePath.endsWith(".lua") || filePath.endsWith(".luau")) {
								const content = fs.readFileSync(filePath, "utf8");
								// Return a mock function for now
								return function () {
									return true;
								};
							}
						} catch (error) {
							console.warn(`Failed to load module ${filePath}:`, error.message);
						}
					}
				}
			}
		}
	}

	// Fallback - return a mock function
	return function () {
		return true;
	};
};

// Mock require function for Roblox-style module loading
global.require = function (modulePath) {
	// Handle script.Parent.Parent.shared.data.utils.validate type paths
	if (typeof modulePath === "object" && modulePath.toString) {
		const pathStr = modulePath.toString();
		if (pathStr.includes("validate")) {
			// Return a mock validate function that actually works
			return function (data, template) {
				// Simple validation: check if all template keys exist in data
				if (!data || !template) return false;

				// Check if data has all required keys from template
				for (const key in template) {
					if (!(key in data)) return false;
				}
				return true;
			};
		}
		if (pathStr.includes("data-template")) {
			// Return the actual data template from our mock script object
			return global.script.Parent.Parent.shared.data["data-template"];
		}
	}

	// Fallback for other modules
	return {};
};

// Mock pairs and ipairs functions for tests that expect them
global.pairs = function (obj) {
	if (typeof obj === "object" && obj !== null) {
		return Object.entries(obj);
	}
	return [];
};

global.pairsSync = function (obj) {
	if (typeof obj === "object" && obj !== null) {
		return Object.entries(obj);
	}
	return [];
};

global.ipairs = function (arr) {
	if (Array.isArray(arr)) {
		return arr.map((value, index) => [index + 1, value]); // 1-based indexing
	}
	return [];
};

global.ipairsSync = function (arr) {
	if (Array.isArray(arr)) {
		return arr.map((value, index) => [index + 1, value]); // 1-based indexing
	}
	return [];
};

// Export the bridge for direct access if needed
global.getLuneBridge = function () {
	return luneBridge;
};

// Add Roblox-specific methods to JavaScript objects for compatibility
// Add .size() method to arrays (mimics Roblox table behavior)
if (!Array.prototype.size) {
	Array.prototype.size = function () {
		return this.length;
	};
}

// Add .size() method to strings (mimics Roblox string behavior)
if (!String.prototype.size) {
	String.prototype.size = function () {
		return this.length;
	};
}

console.log("🚀 Jest setup with Lune bridge initialized");
