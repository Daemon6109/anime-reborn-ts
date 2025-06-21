// Jest setup file to mock Roblox environment when running in Node.js
// This file is loaded by jest.vscode.config.js to make Roblox tests work in VS Code

// Mock Roblox global objects
global.game = {
	GetService: (serviceName) => {
		return {
			Name: serviceName
		};
	}
};

// Mock Roblox string methods
String.prototype.size = function() {
	return this.length;
};

// Mock Roblox array methods if needed
Array.prototype.size = function() {
	return this.length;
};

// Mock other common Roblox globals that might be needed
global.script = {
	Name: "MockScript"
};

global.workspace = {
	Name: "Workspace"
};

// Mock wait function
global.wait = (time) => {
	return new Promise(resolve => setTimeout(resolve, (time || 0) * 1000));
};

// Mock 'print'
global.print = jest.fn((...args) => {
    // console.log(...args); // Optionally log to Jest console
});

// Mock 'tick'
global.tick = jest.fn(() => {
    return Date.now() / 1000; // Return seconds like Roblox's tick()
});

// Mock 'task' library (for task.spawn, task.defer, etc.)
global.task = {
    spawn: jest.fn((func, ...args) => {
        // In a test environment, we might want to execute immediately
        // or provide a way to control execution if testing async logic.
        // For simplicity, let's try immediate execution.
        try {
            if (typeof func === "function") func(...args);
        } catch (e) {
            // console.error("Error in task.spawn mock:", e);
        }
    }),
    defer: jest.fn((func, ...args) => {
        // Similar to spawn, could be immediate or controlled.
        // Make defer synchronous for simpler test execution
        if (typeof func === "function") func(...args);
    }),
    wait: jest.fn((seconds) => Promise.resolve()), // Waits resolve immediately
    // Add other task functions if needed e.g. task.cancel
    cancel: jest.fn(),
};

// Mock 'coroutine' library (if used directly, though task is more common now)
// DataService uses coroutine.running() and coroutine.yield() via coroutine.resume()
global.coroutine = {
    running: jest.fn(() => ({ type: "mockThread" })), // Return an identifiable mock thread
    resume: jest.fn((thread, ...args) => [true]), // Assume success, no real execution
    yield: jest.fn(() => []), // Yield immediately returns, no actual async pause
    create: jest.fn(f => {
        const co = {
            _f: f,
            _args: [], // Removed TS type annotation
            _status: "suspended",
            resume: function(...args) { // Removed TS type annotation
                if (this._status === "dead") return [false, "cannot resume dead coroutine"];
                this._status = "running";
                try {
                    const result = this._f(...args); // Execute the function
                    this._status = "dead";
                    return [true, result];
                } catch (e) {
                    this._status = "dead";
                    return [false, e];
                }
            }
        };
        return co;
    }),
    wrap: jest.fn(f => {
        const co = global.coroutine.create(f);
        return (...args) => { // Removed TS type annotation
            const result = co.resume(...args);
            if (!result[0]) throw result[1]; // Throw error if resume failed
            return result[1]; // Return the actual result
        };
    }),
    status: jest.fn((co) => co?._status ?? "suspended"), // Default status
};

// Mock assert
global.assert = jest.fn((condition, message) => {
    if (!condition) {
        throw new Error(message || "Assertion failed");
    }
});

// Mock pairs (used in DataService for iterating over tables)
global.pairs = jest.fn((obj) => {
    if (typeof obj !== 'object' || obj === null) {
        // Roblox `pairs` would error on non-tables (nil, boolean, etc.)
        // For simplicity in mock, return empty or could throw.
        // Matching error behavior might be too complex for mock.
        return [];
    }
    if (Array.isArray(obj)) {
        // Simulate Lua's 1-based indexing for arrays if obj is a JS array
        return obj.map((value, index) => [index + 1, value]);
    }
    // For plain objects, Object.entries is a good equivalent
    return Object.entries(obj);
});

// Mock typeOf (used in DataService)
global.typeOf = jest.fn((value) => {
    const jsType = typeof value;
    if (value === null) return "nil"; // Roblox `nil` is like JS `null`
    if (jsType === "undefined") return "nil";
    if (jsType === "object") {
        if (Array.isArray(value)) return "table"; // Roblox arrays are tables
        return "table"; // Roblox objects are tables
    }
    if (jsType === "function") return "function";
    if (jsType === "string") return "string";
    if (jsType === "number") return "number";
    if (jsType === "boolean") return "boolean";
    return jsType; // Fallback, should cover most cases
});

// Mock math.floor (used in DataService migrations)
global.math = {
    ...global.math, // Preserve existing math functions if any
    floor: jest.fn(Math.floor),
};

// Mock 'warn'
global.warn = jest.fn((...args) => {
    // console.warn(...args); // Optionally log to Jest console
});
