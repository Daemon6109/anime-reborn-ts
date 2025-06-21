console.log("🚀 Testing Lune Bridge Integration");

const { spawn } = require("child_process");
const path = require("path");

// Test the bridge directly
async function testBridge() {
	console.log("Testing bridge...");

	const bridgeScript = path.join(__dirname, "scripts/lune/test-bridge.luau");
	console.log("Bridge script path:", bridgeScript);

	return new Promise((resolve, reject) => {
		console.log("Spawning lune process...");
		const luneProcess = spawn("/home/node/.rokit/bin/lune", ["run", bridgeScript, "--execute", "return 42"], {
			cwd: __dirname,
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
			console.log("Process closed with code:", code);
			console.log("Stdout:", stdout);
			console.log("Stderr:", stderr);
			resolve({ stdout, stderr, code });
		});

		luneProcess.on("error", (error) => {
			console.error("Process error:", error);
			reject(error);
		});
	});
}

testBridge()
	.then((result) => {
		console.log("Bridge test completed:", result);
	})
	.catch((error) => {
		console.error("Bridge test failed:", error);
	});
