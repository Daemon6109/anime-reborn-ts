// Data validation utilities for ensuring data integrity

import { DataTemplate, DEFAULT_DATA_TEMPLATE } from "../types/data-template";

export function validateDataSection<T>(data: unknown, templateFactory: () => T): [boolean, string?] {
	try {
		const template = templateFactory();

		if (typeOf(data) !== "table") {
			return [false, "Data must be a table"];
		}

		// Basic validation - check if required fields exist
		const dataTable = data as Record<string, unknown>;
		const templateTable = template as Record<string, unknown>;

		for (const [key, templateValue] of pairs(templateTable)) {
			const dataValue = dataTable[key];

			if (dataValue === undefined && templateValue !== undefined) {
				return [false, `Missing required field: ${key}`];
			}

			if (dataValue !== undefined && typeOf(dataValue) !== typeOf(templateValue)) {
				return [
					false,
					`Type mismatch for field ${key}: expected ${typeOf(templateValue)}, got ${typeOf(dataValue)}`,
				];
			}
		}

		return [true];
	} catch (error) {
		return [false, `Validation error: ${error}`];
	}
}

export function isValidDataTemplate(data: unknown): data is DataTemplate {
	const [isValid] = validateDataSection(data, () => DEFAULT_DATA_TEMPLATE);
	return isValid;
}
