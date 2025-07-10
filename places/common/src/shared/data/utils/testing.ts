// Data Testing Utilities for TypeScript

import { DataTemplate, DATA_TEMPLATE } from "../data-template";
import { deepCopy } from "../../utils/deep-copy.util";

interface DiffEntry {
	old: unknown;
	new: unknown;
}

export interface DataDifferences {
	[path: string]: DiffEntry;
}

/**
 * Creates mock player data for testing purposes
 */
export function mockPlayerData(): DataTemplate {
	// Create a lightweight copy for testing
	const mockData = deepCopy(DATA_TEMPLATE);

	// Add some test values
	mockData.Level = 10;
	mockData.XP = 5000;
	mockData.Currencies.Gold = 10000;
	mockData.Currencies.Gems = 1000;

	return mockData;
}

/**
 * Validates that data structure matches the expected template
 */
export function validateStructure(data: unknown, template: unknown): [boolean, string?] {
	if (typeOf(data) !== "table") {
		return [false, "Data is not a table"];
	}

	const dataTable = data as Record<string, unknown>;
	const templateTable = template as Record<string, unknown>;

	for (const [key, value] of pairs(templateTable)) {
		if (dataTable[key] === undefined) {
			return [false, `Missing field: ${key}`];
		}

		if (typeOf(value) === "table" && typeOf(dataTable[key]) === "table") {
			const [isValid, errorMessage] = validateStructure(dataTable[key], value);
			if (!isValid && errorMessage) {
				return [false, `In ${key}: ${errorMessage}`];
			}
		}
	}

	return [true];
}

/**
 * Compare two data structures and return differences
 */
export function diffData(data1: unknown, data2: unknown, path = ""): DataDifferences {
	const differences: DataDifferences = {};

	if (typeOf(data1) !== "table" || typeOf(data2) !== "table") {
		if (data1 !== data2) {
			differences[path === "" ? "root" : path] = { old: data1, new: data2 };
		}
		return differences;
	}

	const data1Table = data1 as Record<string, unknown>;
	const data2Table = data2 as Record<string, unknown>;

	// Check for fields in data1 that differ from data2
	for (const [key, value1] of pairs(data1Table)) {
		const currentPath = path === "" ? key : `${path}.${key}`;
		const value2 = data2Table[key];

		if (value2 === undefined) {
			differences[currentPath] = { old: value1, new: undefined };
		} else if (typeOf(value1) === "table" && typeOf(value2) === "table") {
			const nestedDifferences = diffData(value1, value2, currentPath);
			for (const [diffPath, diffValue] of pairs(nestedDifferences)) {
				differences[diffPath] = diffValue;
			}
		} else if (typeOf(value1) !== typeOf(value2) || value1 !== value2) {
			differences[currentPath] = { old: value1, new: value2 };
		}
	}

	// Check for fields in data2 that don't exist in data1
	for (const [key, value2] of pairs(data2Table)) {
		const currentPath = path !== "" ? `${path}.${key}` : key;
		if (data1Table[key] === undefined) {
			differences[currentPath] = { old: undefined, new: value2 };
		}
	}

	return differences;
}

/**
 * Prints a summary of data for debugging
 */
export function printDataSummary(data: DataTemplate): void {
	print("---- Data Summary ----");
	print(`Player Level: ${data.Level}`);
	print(`XP: ${data.XP}`);
	print("Currencies:");
	for (const [name, amount] of pairs(data.Currencies)) {
		print(`  ${name}: ${amount}`);
	}
	print("Inventory:");

	// Count units and items using pairs iteration
	let unitCount = 0;
	let itemCount = 0;

	for (const [,] of pairs(data.Inventory.Units)) {
		unitCount++;
	}

	for (const [,] of pairs(data.Inventory.Items)) {
		itemCount++;
	}

	print(`  Units: ${unitCount}`);
	print(`  Items: ${itemCount}`);
	print("--------------------");
}

/**
 * Creates test data with specific values for validation testing
 */
export function createTestData(overrides: Partial<DataTemplate> = {}): DataTemplate {
	const baseData = deepCopy(DATA_TEMPLATE);

	// Apply overrides
	for (const [key, value] of pairs(overrides)) {
		(baseData as Record<string, unknown>)[key] = value;
	}

	return baseData;
}

/**
 * Validates that all required fields exist in the data
 */
export function validateRequiredFields(data: DataTemplate): [boolean, string[]] {
	const missingFields: string[] = [];
	const template = DATA_TEMPLATE;

	function checkFields(dataObj: Record<string, unknown>, templateObj: Record<string, unknown>, prefix = ""): void {
		for (const [key, templateValue] of pairs(templateObj)) {
			const fullKey = prefix === "" ? key : `${prefix}.${key}`;
			const dataValue = dataObj[key];

			if (dataValue === undefined) {
				missingFields.push(fullKey);
			} else if (typeOf(templateValue) === "table" && typeOf(dataValue) === "table") {
				checkFields(dataValue as Record<string, unknown>, templateValue as Record<string, unknown>, fullKey);
			}
		}
	}

	checkFields(data as Record<string, unknown>, template as Record<string, unknown>);

	return [missingFields.size() === 0, missingFields];
}
