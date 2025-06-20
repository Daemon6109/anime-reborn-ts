// Field Privacy Manifest for data access control

export type PrivacyType = "Private" | "Public";

export interface FieldPrivacyManifest {
	Currencies: PrivacyType;
	SummoningData: PrivacyType;
	Level: PrivacyType;
	XP: PrivacyType;
	TeamEventData: PrivacyType;
	RobuxSpent: PrivacyType;
	Quests: PrivacyType;
	Slotbar: PrivacyType;
	CurrentTitle: PrivacyType;
	Inventory: PrivacyType;
	Settings: PrivacyType;
	IndexData: PrivacyType;
	MissionCompletionData: PrivacyType;
	ProductsBought: PrivacyType;
	RedeemedCodes: PrivacyType;
	ClaimedLevelRewards: PrivacyType;
	MerchantItemsBought: PrivacyType;
	PlayerStatistics: PrivacyType;
	Teams: PrivacyType;
	SlotsApplicable: PrivacyType;
	TraitPity: PrivacyType;
	Blessing: PrivacyType;
	Effects: PrivacyType;
}

export const FIELD_PRIVACY_MANIFEST: FieldPrivacyManifest = {
	Currencies: "Private",
	SummoningData: "Private",
	Level: "Public",
	XP: "Public",
	TeamEventData: "Public",
	RobuxSpent: "Private",
	Quests: "Private",
	Slotbar: "Public",
	CurrentTitle: "Public",
	Inventory: "Private",
	Settings: "Private",
	IndexData: "Private",
	MissionCompletionData: "Private",
	ProductsBought: "Public",
	RedeemedCodes: "Private",
	ClaimedLevelRewards: "Private",
	MerchantItemsBought: "Private",
	PlayerStatistics: "Public",
	Teams: "Private",
	SlotsApplicable: "Private",
	TraitPity: "Private",
	Blessing: "Public",
	Effects: "Private",
};

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
