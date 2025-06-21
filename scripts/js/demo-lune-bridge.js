// Demo script to test Lune bridge integration
// Run with: node scripts/js/demo-lune-bridge.js

const { spawn } = require("child_process");
const path = require("path");

class SimpleLuneBridge {
	constructor() {
		this.bridgeScript = path.join(__dirname, "../lune/test-bridge.luau");
	}

	async execute(code) {
		return new Promise((resolve, reject) => {
			const luneProcess = spawn("lune", ["run", this.bridgeScript, "--execute", code], {
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
}

// Demo function to test the bridge
async function demo() {
	console.log("🚀 Testing Lune Bridge Integration\n");

	const bridge = new SimpleLuneBridge();

	// Test 1: Basic typeof functionality
	console.log("📋 Test 1: typeof functionality");
	try {
		const result1 = await bridge.execute("return typeof({})");
		console.log("  typeof({}):", result1.success ? result1.result : result1.error);

		const result2 = await bridge.execute('return typeof("test")');
		console.log('  typeof("test"):', result2.success ? result2.result : result2.error);

		const result3 = await bridge.execute("return typeof(42)");
		console.log("  typeof(42):", result3.success ? result3.result : result3.error);
	} catch (error) {
		console.error("  Error:", error.message);
	}

	// Test 2: Roblox globals
	console.log("\n⏰ Test 2: Roblox globals");
	try {
		const result = await bridge.execute("return tick() > 0");
		console.log("  tick() > 0:", result.success ? result.result : result.error);
	} catch (error) {
		console.error("  Error:", error.message);
	}

	// Test 3: Complex data structures
	console.log("\n🗂️  Test 3: Complex data structures");
	try {
		const code = `
            local data = {
                player = {
                    name = "TestPlayer",
                    level = 42,
                    inventory = {1, 2, 3}
                },
                timestamp = tick()
            }
            return data
        `;
		const result = await bridge.execute(code);
		console.log("  Complex object:", result.success ? JSON.stringify(result.result, null, 2) : result.error);
	} catch (error) {
		console.error("  Error:", error.message);
	}

	// Test 4: Test a realistic data service scenario
	console.log("\n💾 Test 4: Data service scenario");
	try {
		const code = `
            local function deepCopy(obj)
                local objType = typeof(obj)
                if objType ~= "table" then
                    return obj
                end
                
                local objCopy = {}
                for key, value in pairs(obj) do
                    objCopy[key] = deepCopy(value)
                end
                return objCopy
            end
            
            local originalData = {
                PlayerData = { Username = "TestUser", Level = 5 },
                InventoryData = { Items = {"sword", "shield"} }
            }
            
            local copiedData = deepCopy(originalData)
            copiedData.PlayerData.Level = 10
            
            return {
                original_level = originalData.PlayerData.Level,
                copied_level = copiedData.PlayerData.Level,
                are_different = originalData.PlayerData.Level ~= copiedData.PlayerData.Level
            }
        `;
		const result = await bridge.execute(code);
		console.log("  Deep copy test:", result.success ? JSON.stringify(result.result, null, 2) : result.error);
	} catch (error) {
		console.error("  Error:", error.message);
	}

	console.log("\n✅ Demo completed!");
	console.log("\n💡 Usage in Jest tests:");
	console.log("   - Set JEST_USE_LUNE=true to enable Lune execution");
	console.log("   - Use luneBridge.execute(code) to run Luau code in real runtime");
	console.log("   - Get actual Roblox typeof, tick, and other globals behavior");
}

// Run the demo
demo().catch(console.error);
