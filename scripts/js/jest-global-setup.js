// Global setup for Lune bridge Jest tests
/* eslint-disable */

module.exports = async () => {
	console.log("🌙 Initializing Lune bridge for enhanced Roblox testing...");

	// Pre-warm the Lune bridge if needed
	// This could include checking if Lune is available, setting up shared resources, etc.

	// Check if Lune is available
	const { spawn } = require("child_process");

	try {
		const luneCheck = spawn("lune", ["--version"], { stdio: "pipe" });
		await new Promise((resolve, reject) => {
			luneCheck.on("close", (code) => {
				if (code === 0) {
					console.log("✅ Lune is available and ready");
					resolve();
				} else {
					reject(new Error(`Lune not available (exit code: ${code})`));
				}
			});
			luneCheck.on("error", reject);
		});
	} catch (error) {
		console.error("❌ Lune is not available. Falling back to basic mocks.");
		console.error("Install Lune with: cargo install lune --version 0.8.9");
		console.error("Or use rokit: rokit install");
	}
};
