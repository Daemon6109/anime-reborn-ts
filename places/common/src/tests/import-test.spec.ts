import { expect, describe, it } from "@rbxts/jest-globals";

describe("Simple Import Test", () => {
	it("should import modules correctly", () => {
		try {
			// Test the imports that are failing
			const dataTemplateModule = require("shared/data/data-template");
			const deepCopyModule = require("shared/utils/deep-copy");

			console.log("DATA_TEMPLATE:", dataTemplateModule.DATA_TEMPLATE);
			console.log("deepCopy:", deepCopyModule.deepCopy);

			expect(dataTemplateModule.DATA_TEMPLATE).toBeDefined();
			expect(deepCopyModule.deepCopy).toBeDefined();
		} catch (error) {
			console.error("Import error:", error);
			throw error;
		}
	});
});
