// Lune Bridge Service for Jest Tests
// This service manages communication between Node.js Jest and Lune runtime
// Provides real Roblox global execution instead of mocking

/* eslint-disable */

const { spawn } = require("child_process");
const path = require("path");

class LuneBridge {
	constructor() {
		this.luneProcess = null;
		this.isReady = false;
		this.pendingCommands = new Map();
		this.commandId = 0;
	}

	// Initialize the Lune bridge process
	async initialize() {
		if (this.isReady) return;

		const scriptPath = path.join(__dirname, "../lune/test-bridge.luau");

		// Spawn Lune process
		this.luneProcess = spawn("lune", ["run", scriptPath], {
			stdio: ["pipe", "pipe", "pipe"],
			cwd: path.join(__dirname, "../.."),
		});

		// Handle process events
		this.luneProcess.on("error", (error) => {
			console.error("Lune bridge process error:", error);
			this.isReady = false;
		});

		this.luneProcess.on("exit", (code) => {
			console.log(`Lune bridge process exited with code ${code}`);
			this.isReady = false;
		});

		// Set up communication
		this.setupCommunication();

		// Wait for ready signal
		await this.waitForReady();
		this.isReady = true;
	}

	setupCommunication() {
		let buffer = "";

		this.luneProcess.stdout.on("data", (data) => {
			buffer += data.toString();

			// Process complete lines
			const lines = buffer.split("\n");
			buffer = lines.pop() || ""; // Keep incomplete line in buffer

			for (const line of lines) {
				if (line.trim()) {
					this.handleLuneOutput(line.trim());
				}
			}
		});

		this.luneProcess.stderr.on("data", (data) => {
			console.error("Lune stderr:", data.toString());
		});
	}

	handleLuneOutput(line) {
		if (line.includes("Lune Test Bridge - Ready")) {
			this.readyResolve && this.readyResolve();
			return;
		}

		try {
			const result = JSON.parse(line);
			// For now, we'll handle results synchronously
			// In a more advanced implementation, we could use command IDs
			if (this.currentResolve) {
				this.currentResolve(result);
				this.currentResolve = null;
			}
		} catch (error) {
			console.error("Failed to parse Lune output:", line, error);
		}
	}

	waitForReady() {
		return new Promise((resolve) => {
			this.readyResolve = resolve;
		});
	}

	// Execute Luau code in Lune runtime
	async execute(code) {
		if (!this.isReady) {
			await this.initialize();
		}

		return new Promise((resolve, reject) => {
			this.currentResolve = resolve;

			const command = JSON.stringify({ code });

			// Send command to Lune
			this.luneProcess.stdin.write(command + "\n");

			// Set timeout
			setTimeout(() => {
				if (this.currentResolve === resolve) {
					this.currentResolve = null;
					reject(new Error("Lune execution timeout"));
				}
			}, 5000);
		});
	}

	// Execute a simple expression and return the result
	async executeExpression(expression) {
		const code = `
			local result = ${expression}
			setTestResult(result)
		`;

		const result = await this.execute(code);

		if (result.success) {
			return result.result;
		} else {
			throw new Error(`Lune execution error: ${result.error}`);
		}
	}

	// Execute a function with arguments
	async executeFunction(functionCode, ...args) {
		const serializedArgs = args.map((arg) => JSON.stringify(arg)).join(", ");
		const code = `
			local func = ${functionCode}
			local result = func(${serializedArgs})
			setTestResult(result)
		`;

		const result = await this.execute(code);

		if (result.success) {
			return result.result;
		} else {
			throw new Error(`Lune execution error: ${result.error}`);
		}
	}

	// Test a Roblox global function
	async testRobloxGlobal(globalName, ...args) {
		const serializedArgs = args.map((arg) => JSON.stringify(arg)).join(", ");
		const code = `
			local result = ${globalName}(${serializedArgs})
			setTestResult(result)
		`;

		const result = await this.execute(code);

		if (result.success) {
			return result.result;
		} else {
			throw new Error(`Roblox global test error: ${result.error}`);
		}
	}

	// Clean up
	destroy() {
		if (this.luneProcess) {
			this.luneProcess.stdin.write("exit\n");
			this.luneProcess.kill();
			this.luneProcess = null;
		}
		this.isReady = false;
	}
}

// Singleton instance
let bridgeInstance = null;

function getLuneBridge() {
	if (!bridgeInstance) {
		bridgeInstance = new LuneBridge();
	}
	return bridgeInstance;
}

module.exports = {
	LuneBridge,
	getLuneBridge,
};
