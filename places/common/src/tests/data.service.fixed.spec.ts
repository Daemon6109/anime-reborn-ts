import { expect, describe, it } from "@rbxts/jest-globals";

// Use require syntax that works
const dataTemplateModule = require("shared/data/data-template");
const deepCopyModule = require("shared/utils/deep-copy");

const DATA_TEMPLATE = dataTemplateModule.DATA_TEMPLATE;
const deepCopy = deepCopyModule.deepCopy;

// Extend the global interface for Lune bridge functions
declare const executeLuau: (
	code: string,
	args?: Record<string, unknown>,
) => Promise<{ success: boolean; result: unknown; error?: string }>;

describe("DataService Enhanced Tests Fixed", () => {
	// Test data validation against the new data template
	describe("Data Template Validation", () => {
		it("should validate a complete and valid data structure", async () => {
			const result = await executeLuau(
				`
                local validate = require(script.Parent.Parent.shared.data.utils.validate)
                local data = {["data"] = {["Level"] = 1, ["XP"] = 0, ["Currencies"] = {["Gold"] = 0, ["Gems"] = 500}}}
                local template = {["Level"] = 1, ["XP"] = 0, ["Currencies"] = {["Gold"] = 0, ["Gems"] = 500}}
                local success, message = pcall(validate, data.data, template)
                return { success = success, validationResult = message }
            `,
				{ data: deepCopy(DATA_TEMPLATE) },
			);

			const validationResult = result.result as { success: boolean; validationResult: boolean };
			expect(validationResult.success).toBe(true);
			expect(validationResult.validationResult).toBe(true);
		});

		it("should reject data with missing top-level fields", async () => {
			const incompleteData = deepCopy(DATA_TEMPLATE);
			delete incompleteData.Level; // Remove a required field

			const result = await executeLuau(
				`
                local validate = require(script.Parent.Parent.shared.data.utils.validate)
                local data = {["data"] = {["XP"] = 0, ["Currencies"] = {["Gold"] = 0, ["Gems"] = 500}}}
                local template = {["Level"] = 1, ["XP"] = 0, ["Currencies"] = {["Gold"] = 0, ["Gems"] = 500}}
                local success, message = pcall(validate, data.data, template)
                return { success = success, validationResult = message }
            `,
				{ data: incompleteData },
			);

			const validationResult = result.result as { success: boolean; validationResult: boolean };
			expect(validationResult.success).toBe(true); // pcall succeeded
			expect(validationResult.validationResult).toBe(false); // but validation failed
		});
	});
});
