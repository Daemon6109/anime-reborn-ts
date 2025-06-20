-- Compiled with roblox-ts v2.3.0
-- Field Privacy Manifest for data access control
local FIELD_PRIVACY_MANIFEST = {
	Currencies = "Private",
	SummoningData = "Private",
	Level = "Public",
	XP = "Public",
	TeamEventData = "Public",
	RobuxSpent = "Private",
	Quests = "Private",
	Slotbar = "Public",
	CurrentTitle = "Public",
	Inventory = "Private",
	Settings = "Private",
	IndexData = "Private",
	MissionCompletionData = "Private",
	ProductsBought = "Public",
	RedeemedCodes = "Private",
	ClaimedLevelRewards = "Private",
	MerchantItemsBought = "Private",
	PlayerStatistics = "Public",
	Teams = "Private",
	SlotsApplicable = "Private",
	TraitPity = "Private",
	Blessing = "Public",
	Effects = "Private",
}
--[[
	*
	 * Checks if a field is publicly accessible
	 
]]
local function isFieldPublic(fieldName)
	return FIELD_PRIVACY_MANIFEST[fieldName] == "Public"
end
--[[
	*
	 * Filters data to only include public fields
	 
]]
local function getPublicData(data)
	local result = {}
	for key, value in pairs(data) do
		if isFieldPublic(key) then
			result[key] = value
		end
	end
	return result
end
return {
	isFieldPublic = isFieldPublic,
	getPublicData = getPublicData,
	FIELD_PRIVACY_MANIFEST = FIELD_PRIVACY_MANIFEST,
}
