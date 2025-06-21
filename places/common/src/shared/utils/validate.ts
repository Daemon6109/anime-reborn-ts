// Data validation utilities for ensuring data integrity

import { DataTemplate, DATA_TEMPLATE } from "../data/data-template";

export function validateDataSection<T>(data: unknown, template: T): [boolean, string?] {
	if (typeIs(data, "table") && typeIs(template, "table")) {
		for (const [key, templateValue] of pairs(template)) {
			const dataValue = data[key as keyof typeof data];

			// Skip validation for missing non-essential fields (like numeric dictionary keys that might be empty)
			if (dataValue === undefined) {
				// Allow missing numeric keys or numeric string keys in objects (like Traits: {1: "", 2: "", 3: ""})
				if (typeIs(key, "number") || (typeIs(key, "string") && (key === "1" || key === "2" || key === "3"))) {
					continue; // Skip validation for known numeric keys
				}
				return [false, `Missing required field: ${key}`];
			}

			const [isValid, message] = validateDataSection(dataValue, templateValue);
			if (!isValid) {
				return [false, `Invalid field ${key}: ${message}`];
			}
		}
		return [true];
	} else if (typeOf(data) !== typeOf(template)) {
		return [false, `Type mismatch: expected ${typeOf(template)}, got ${typeOf(data)}`];
	}
	return [true];
}

export function isValidDataTemplate(data: unknown): data is DataTemplate {
	const [isValid] = validateDataSection(data, DATA_TEMPLATE);
	return isValid;
}
