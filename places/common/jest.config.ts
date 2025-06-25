import { ReplicatedStorage } from "@rbxts/services";

export = {
	setupFilesAfterEnv: [ReplicatedStorage.FindFirstChild("jest_setup")],
	displayName: "COMMON",
	testMatch: ["**/src/tests/*.(spec|test)"],
	testPathIgnorePatterns: ["rbxts_include", "node_modules"],
};
