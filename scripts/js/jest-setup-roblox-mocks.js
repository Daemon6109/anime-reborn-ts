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
