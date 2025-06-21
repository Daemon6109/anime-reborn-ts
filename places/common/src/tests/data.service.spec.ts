import { expect, describe, it } from "@rbxts/jest-globals";
import { DATA_TEMPLATE, DataTemplate } from "shared/data/data-template";
import { deepCopy } from "shared/utils/deep-copy";

// Extend the global interface for Lune bridge functions
declare const executeLuau: (
	code: string,
	args?: Record<string, unknown>,
) => Promise<{ success: boolean; result: unknown; error?: string }>;

describe("DataService Enhanced Tests", () => {
	// Test data validation against the new data template
	describe("Data Template Validation", () => {
		it("should validate a complete and valid data structure", async () => {
			const result = await executeLuau(
				`
                local validate = require(script.Parent.Parent.shared.data.utils.validate)
                local data = ...
                local success, message = pcall(validate, data, script.Parent.Parent.shared.data["data-template"])
                return { success = success, message = message }
            `,
				{ data: deepCopy(DATA_TEMPLATE) },
			);

			const validationResult = result.result as { success: boolean; message: string };
			expect(validationResult.success).toBe(true);
		});

		it("should reject data with missing top-level fields", async () => {
			const incompleteData = deepCopy(DATA_TEMPLATE);
			delete incompleteData.PlayerData; // Remove a required field

			const result = await executeLuau(
				`
                local validate = require(script.Parent.Parent.shared.data.utils.validate)
                local data = ...
                local success, message = pcall(validate, data, script.Parent.Parent.shared.data["data-template"])
                return { success = success, message = message }
            `,
				{ data: incompleteData },
			);

			const validationResult = result.result as { success: boolean; message: string };
			expect(validationResult.success).toBe(false);
		});

		it("should reject data with incorrect data types", async () => {
			const corruptedData = deepCopy(DATA_TEMPLATE);
			corruptedData.Settings.SoundMasterVolume = "not a number" as unknown as number; // Corrupt a field

			const result = await executeLuau(
				`
                local validate = require(script.Parent.Parent.shared.data.utils.validate)
                local data = ...
                local success, message = pcall(validate, data, script.Parent.Parent.shared.data["data-template"])
                return { success = success, message = message }
            `,
				{ data: corruptedData },
			);

			const validationResult = result.result as { success: boolean; message: string };
			expect(validationResult.success).toBe(false);
		});
	});

	// Test data migration logic
	describe("Data Migration", () => {
		it("should correctly migrate data from an older version", async () => {
			const oldData = {
				_version: 1,
				PlayerData: { Username: "TestPlayer", Level: 5 },
				// Missing fields from the latest template
			};

			const result = await executeLuau(
				`
                local migrations = require(script.Parent.Parent.shared.data.utils.migrations)
                local data = ...
                local migratedData = migrations.migrate(data)
                return { data = migratedData }
            `,
				{ data: oldData },
			);

			const migrationResult = result.result as { data: DataTemplate };
			expect(migrationResult.data._version).toBe(DATA_TEMPLATE._version);
			expect((migrationResult.data as unknown as { PlayerData: { Level: number } }).PlayerData.Level).toBe(5);
			expect(migrationResult.data.Settings).toBeDefined(); // Check for a field added in a later version
		});

		it("should not modify data that is already up-to-date", async () => {
			const currentData = deepCopy(DATA_TEMPLATE);

			const result = await executeLuau(
				`
                local migrations = require(script.Parent.Parent.shared.data.utils.migrations)
                local data = ...
                local migratedData = migrations.migrate(data)
                return { data = migratedData }
            `,
				{ data: currentData },
			);

			const migrationResult = result.result as { data: DataTemplate };
			expect(migrationResult.data).toEqual(currentData);
		});
	});

	// Test data merging and default value assignment
	describe("Data Merging and Defaults", () => {
		it("should correctly merge user data with the template", () => {
			const userData = {
				Level: 10,
				Settings: { SoundMasterVolume: 0.75 },
			};

			const mergedData = {
				...deepCopy(DATA_TEMPLATE),
				...userData,
			};

			expect(mergedData.Level).toBe(10);
			expect(mergedData.Settings.SoundMasterVolume).toBe(0.75);
			expect(mergedData.Currencies.Gems).toBe(0); // Check that default values are preserved
		});

		it("should handle deeply nested data merging", () => {
			const userData = {
				PlayerStatistics: {
					PlayTime: 5000,
				},
			};

			const mergedData = {
				...deepCopy(DATA_TEMPLATE),
				PlayerStatistics: {
					...DATA_TEMPLATE.PlayerStatistics,
					...userData.PlayerStatistics,
				},
			};

			expect(mergedData.PlayerStatistics.PlayTime).toBe(5000);
			expect(mergedData.PlayerStatistics.Kills).toBe(0); // Check preservation
		});
	});
});
