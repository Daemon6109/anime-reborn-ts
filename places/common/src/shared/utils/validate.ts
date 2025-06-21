// Data validation utilities for ensuring data integrity

import { DataTemplate, DATA_TEMPLATE } from "../data/data-template";

export function validateDataSection<T>(data: unknown, template: T): [boolean, string?] {
	if (typeIs(data, "table") && typeIs(template, "table")) {
		for (const [key, templateValue] of pairs(template)) {
			const dataValue = data[key as keyof typeof data];

			// Ensure the key exists in the data object
			if (dataValue === undefined) {
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
