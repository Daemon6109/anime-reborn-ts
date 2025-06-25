import { ReplicatedStorage } from "@rbxts/services";

export = {
	clearmocks: true,
	setupFilesAfterEnv: [ReplicatedStorage.FindFirstChild("jest_setup")],
	displayName: "AFK",
	testMatch: ["**/src/tests/*.(spec|test)"],
	testPathIgnorePatterns: ["rbxts_include", "node_modules"],
};
