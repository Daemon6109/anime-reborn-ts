import manifest from "@shared/configuration/field-privacy-manifest.json";

// Type derived directly from the JSON file
export type FieldPrivacyManifest = typeof manifest;

// Extract "Private" | "Public" from the values of the JSON object
export type PrivacyType = FieldPrivacyManifest[keyof FieldPrivacyManifest];

export const FIELD_PRIVACY_MANIFEST: FieldPrivacyManifest = manifest;

/**
 * Checks if a field is publicly accessible
 */
export function isFieldPublic(fieldName: keyof FieldPrivacyManifest): boolean {
	return FIELD_PRIVACY_MANIFEST[fieldName] === "Public";
}

/**
 * Filters data to only include public fields
 */
export function getPublicData<T extends Record<string, unknown>>(data: T): Partial<T> {
	const result: Partial<T> = {};

	for (const [key, value] of pairs(data)) {
		if (isFieldPublic(key as keyof FieldPrivacyManifest)) {
			result[key as keyof T] = value as T[keyof T];
		}
	}

	return result;
}
