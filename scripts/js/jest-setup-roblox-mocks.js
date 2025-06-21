// Jest setup file to mock Roblox environment when running in Node.js
// This file is loaded by jest.vscode.config.js to make Roblox tests work in VS Code

// Mock Roblox global objects
global.game = {
	GetService: (serviceName) => {
		// Basic mock for GetService
		if (serviceName === "AnalyticsService") {
			// Provide a more specific mock if AnalyticsService is obtained via GetService
			return {
				Name: serviceName,
				LogCustomEvent: jest.fn(), // Mock methods used by older scripts
				ReportEvent: jest.fn(),    // Mock methods used by newer scripts/services
			};
		}
		return {
			Name: serviceName,
			// Add common methods if needed by other services obtained via GetService
		};
	},
	BindToClose: jest.fn((callback) => {
		// Store the callback to allow tests to simulate game closing if necessary
		// This can be exposed via a helper or another global for test control
		global.game._closeCallback = callback;
	}),
	_closeCallback: undefined, // Placeholder for the BindToClose callback
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
    min: jest.fn(Math.min),
    max: jest.fn(Math.max),
    abs: jest.fn(Math.abs),
    ceil: jest.fn(Math.ceil),
    round: jest.fn(Math.round), // Math.round is a common one too
    // Add other math functions as they become necessary
};

// Mock 'warn'
global.warn = jest.fn((...args) => {
    // console.warn(...args); // Optionally log to Jest console
});

// Mock os library
global.os = {
    time: jest.fn(() => Math.floor(Date.now() / 1000)), // Return seconds like os.time()
    date: jest.fn((format, timestamp) => { // Basic os.date mock
        const d = timestamp ? new Date(timestamp * 1000) : new Date();
        // Handle common format strings like *t, !*t, or specific date components
        if (format === "*t" || format === "!*t") {
            return {
                year: d.getFullYear(),
                month: d.getMonth() + 1, // Lua months are 1-12
                day: d.getDate(),
                hour: d.getHours(),
                min: d.getMinutes(),
                sec: d.getSeconds(),
                yday: Math.floor((d - new Date(d.getFullYear(), 0, 0)) / 86400000), // Day of year
                wday: d.getDay() + 1, // Lua wday is 1-7 (Sun-Sat)
                isdst: false, // Daylight Saving Time - simplified
            };
        }
        // For specific formats like "%Y-%m-%d", this mock would need to be more complex.
        // For now, return a simple string representation or ISO string for other formats.
        return d.toISOString(); // Fallback for unhandled formats
    }),
    // Add other os functions if they become necessary
};

// Mock Instance
global.Instance = jest.fn((className) => {
    const mockInstance = {
        ClassName: className,
            Name: "",
            Parent: undefined,
            Archivable: true,
            Children: [],
            IsA: jest.fn((type) => {
            if (mockInstance._specialIsA) return mockInstance._specialIsA(type);
            // Simple check, can be expanded for inheritance (e.g. BindableEvent IsA Instance)
            if (type === className) return true;
            if (type === "Instance") return true; // All instances are "Instance"
            // Add more complex IsA relationships if needed for specific tests
            if ((className === "BindableEvent" || className === "RemoteEvent") && type === "RBXScriptSignal") return true;
            return false;
        }),
        FindFirstChild: jest.fn((name) => mockInstance.Children.find(c => c.Name === name)),
        GetChildren: jest.fn(() => mockInstance.Children),
        Destroy: jest.fn(() => {
            if (mockInstance.Parent) {
                const parentChildren = mockInstance.Parent.GetChildren ? mockInstance.Parent.GetChildren() : mockInstance.Parent.Children;
                if (Array.isArray(parentChildren)) {
                     const index = parentChildren.indexOf(mockInstance);
                     if (index > -1) parentChildren.splice(index, 1);
                }
                mockInstance.Parent = undefined;
            }
        }),
        // Event handling logic
        _connections: [], // Store connections for event-like instances
        Connect: jest.fn(function(callback) { // Use function keyword for 'this' if needed, here 'mockInstance' is closure-captured
            mockInstance._connections.push(callback);
            let connected = true;
            return {
                Disconnect: jest.fn(() => {
                    if (!connected) return;
                    const index = mockInstance._connections.indexOf(callback);
                    if (index > -1) {
                        mockInstance._connections.splice(index, 1);
                    }
                    connected = false;
                }),
                Connected: connected, // RBXScriptConnection property
            };
        }),
        Fire: jest.fn(function(...args) { // Use function keyword for 'this'
            [...mockInstance._connections].forEach(callback => { // Iterate copy in case a callback disconnects others
                try {
                    callback(...args);
                } catch (e) {
                    // console.error("Error in mock event Fire:", e);
                }
            });
        }),
        // Allow setting custom properties directly for simplicity in tests
        _properties: {},
            // Special IsA handler for more complex scenarios (e.g. mock Player might be Instance and Player)
            _specialIsA: undefined,
        };

        // Specific mocks for common types
        if (className === "BindableEvent") {
            // Covered by default Fire/Connect
        } else if (className === "Folder") {
            // No specific props needed beyond default instance
        }
        // Add more specific class mocks as needed

        // Proxy to allow setting arbitrary properties on the mock instance
        return new Proxy(mockInstance, {
            get: (target, prop) => {
                if (prop in target) return target[prop];
                return target._properties[prop];
            },
            set: (target, prop, value) => {
                if (prop in target) {
                    target[prop] = value;
                } else {
                    target._properties[prop] = value;
                }
                return true;
            }
        });
    });

// For compatibility if some code uses Instance.new() as a static method
global.Instance.new = global.Instance;
