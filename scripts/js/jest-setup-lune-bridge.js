// Enhanced Jest setup with Lune bridge for real Roblox globals
// This replaces jest-setup-roblox-mocks.js with a hybrid approach
// Uses Lune for accurate Roblox runtime behavior

/* eslint-disable */

const { getLuneBridge } = require("./lune-bridge.service");

// Initialize Lune bridge
let luneBridge = null;

// Setup function to initialize bridge
async function setupLuneBridge() {
	if (!luneBridge) {
		luneBridge = getLuneBridge();
		await luneBridge.initialize();
	}
	return luneBridge;
}

// Enhanced Roblox globals that delegate to Lune when possible
// Fallback to simple mocks for non-critical operations

// Mock basic Roblox environment (for immediate access)
global.game = {
	GetService: jest.fn((serviceName) => {
		return {
			Name: serviceName,
		};
	}),
};

global.script = {
	Name: "MockScript",
};

global.workspace = {
	Name: "Workspace",
};

// Enhanced string methods
String.prototype.size = function () {
	return this.length;
};

Array.prototype.size = function () {
	return this.length;
};

// Lune-backed globals for accurate behavior
global.typeOf = jest.fn(async (value) => {
	if (!luneBridge) luneBridge = await setupLuneBridge();

	try {
		const result = await luneBridge.executeExpression(`typeof(${JSON.stringify(value)})`);
		return result;
	} catch (error) {
		// Fallback to simple mock
		const jsType = typeof value;
		if (value === null || value === undefined) return "nil";
		if (jsType === "object") return Array.isArray(value) ? "table" : "table";
		return jsType;
	}
});

// Create a synchronous version for compatibility
global.typeOfSync = jest.fn((value) => {
	const jsType = typeof value;
	if (value === null || value === undefined) return "nil";
	if (jsType === "object") return Array.isArray(value) ? "table" : "table";
	if (jsType === "function") return "function";
	if (jsType === "string") return "string";
	if (jsType === "number") return "number";
	if (jsType === "boolean") return "boolean";
	return jsType;
});

// Lune-backed pairs function
global.pairs = jest.fn(async (obj) => {
	if (!luneBridge) luneBridge = await setupLuneBridge();

	try {
		const code = `
			local obj = ${JSON.stringify(obj)}
			local result = {}
			for k, v in pairs(obj) do
				table.insert(result, {k, v})
			end
			result
		`;
		const result = await luneBridge.executeExpression(code);
		return result;
	} catch (error) {
		// Fallback implementation
		if (typeof obj !== "object" || obj === null) {
			return [];
		}
		if (Array.isArray(obj)) {
			return obj.map((value, index) => [index + 1, value]);
		}
		return Object.entries(obj);
	}
});

// Synchronous pairs fallback
global.pairsSync = jest.fn((obj) => {
	if (typeof obj !== "object" || obj === null) {
		return [];
	}
	if (Array.isArray(obj)) {
		return obj.map((value, index) => [index + 1, value]);
	}
	return Object.entries(obj);
});

// Lune-backed ipairs function
global.ipairs = jest.fn(async (arr) => {
	if (!luneBridge) luneBridge = await setupLuneBridge();

	try {
		const code = `
			local arr = ${JSON.stringify(arr)}
			local result = {}
			for i, v in ipairs(arr) do
				table.insert(result, {i, v})
			end
			result
		`;
		const result = await luneBridge.executeExpression(code);
		return result;
	} catch (error) {
		// Fallback implementation
		if (!Array.isArray(arr)) return [];
		return arr.map((value, index) => [index + 1, value]);
	}
});

// Math functions with Lune backing
global.math = {
	...Math, // Include JavaScript Math
	floor: jest.fn(async (value) => {
		if (!luneBridge) luneBridge = await setupLuneBridge();

		try {
			return await luneBridge.executeExpression(`math.floor(${value})`);
		} catch (error) {
			return Math.floor(value);
		}
	}),
	floorSync: jest.fn(Math.floor),
};

// Task library with Lune backing
global.task = {
	spawn: jest.fn(async (func, ...args) => {
		if (!luneBridge) luneBridge = await setupLuneBridge();

		try {
			// For testing, execute immediately
			if (typeof func === "function") return func(...args);
		} catch (error) {
			console.error("Error in task.spawn:", error);
		}
	}),

	defer: jest.fn(async (func, ...args) => {
		if (!luneBridge) luneBridge = await setupLuneBridge();

		try {
			// For testing, execute immediately
			if (typeof func === "function") return func(...args);
		} catch (error) {
			console.error("Error in task.defer:", error);
		}
	}),

	wait: jest.fn((seconds) => Promise.resolve()), // No actual waiting in tests
	cancel: jest.fn(),
};

// Other essential globals
global.print = jest.fn((...args) => {
	// In tests, we might want to capture prints for assertion
	// console.log(...args);
});

global.warn = jest.fn((...args) => {
	// In tests, we might want to capture warnings for assertion
	// console.warn(...args);
});

global.tick = jest.fn(() => {
	return Date.now() / 1000; // Convert to seconds like Roblox
});

global.wait = jest.fn((time) => {
	return new Promise((resolve) => setTimeout(resolve, (time || 0) * 1000));
});

// Coroutine library
global.coroutine = {
	running: jest.fn(() => ({ type: "mockThread" })),
	resume: jest.fn((thread, ...args) => [true]),
	yield: jest.fn(() => []),
	create: jest.fn((f) => {
		const co = {
			_f: f,
			_args: [],
			_status: "suspended",
			resume: function (...args) {
				if (this._status === "dead") return [false, "cannot resume dead coroutine"];
				this._status = "running";
				try {
					const result = this._f(...args);
					this._status = "dead";
					return [true, result];
				} catch (e) {
					this._status = "dead";
					return [false, e];
				}
			},
		};
		return co;
	}),
	wrap: jest.fn((f) => {
		const co = global.coroutine.create(f);
		return (...args) => {
			const result = co.resume(...args);
			if (!result[0]) throw result[1];
			return result[1];
		};
	}),
	status: jest.fn((co) => co?._status ?? "suspended"),
};

// Assert function
global.assert = jest.fn((condition, message) => {
	if (!condition) {
		throw new Error(message || "Assertion failed");
	}
});

// Utility function to execute Luau code directly in tests
global.executeLuau = async (code) => {
	if (!luneBridge) luneBridge = await setupLuneBridge();
	return await luneBridge.execute(code);
};

// Utility function to test Roblox globals directly
global.testRobloxGlobal = async (globalName, ...args) => {
	if (!luneBridge) luneBridge = await setupLuneBridge();
	return await luneBridge.testRobloxGlobal(globalName, ...args);
};

// Cleanup function for Jest teardown
global.cleanupLuneBridge = () => {
	if (luneBridge) {
		luneBridge.destroy();
		luneBridge = null;
	}
};

// Auto-cleanup on process exit
process.on("exit", () => {
	global.cleanupLuneBridge();
});

process.on("SIGINT", () => {
	global.cleanupLuneBridge();
	process.exit(0);
});

process.on("SIGTERM", () => {
	global.cleanupLuneBridge();
	process.exit(0);
});
