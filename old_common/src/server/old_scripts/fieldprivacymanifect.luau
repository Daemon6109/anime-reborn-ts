local Manifest = {
	Currencies = "Private" :: PrivacyType,
	SummoningData = "Private" :: PrivacyType,
	Level = "Public" :: PrivacyType,
	XP = "Public" :: PrivacyType,
	TeamEventData = "Public" :: PrivacyType,
	RobuxSpent = "Private" :: PrivacyType,
	Quests = "Private" :: PrivacyType,
	Slotbar = "Public" :: PrivacyType,
	CurrentTitle = "Public" :: PrivacyType,
	Inventory = "Private" :: PrivacyType,
	Settings = "Private" :: PrivacyType,

	IndexData = "Private" :: PrivacyType,

	MissionCompletionData = "Private" :: PrivacyType,
	ProductsBought = "Public" :: PrivacyType,
	RedeemedCodes = "Private" :: PrivacyType,
	ClaimedLevelRewards = "Private" :: PrivacyType,
	MerchantItemsBought = "Private" :: PrivacyType,
	PlayerStatistics = "Public" :: PrivacyType,
	Teams = "Private" :: PrivacyType,
	SlotsApplicable = "Private" :: PrivacyType,
	TraitPity = "Private" :: PrivacyType,
	Blessing = "Public" :: PrivacyType,
	Effects = "Private" :: PrivacyType,
}

export type PrivacyType = "Public" | "Private"

return Manifest
