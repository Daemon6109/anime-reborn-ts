-- Compiled with roblox-ts v2.3.0
-- Player basic data factory
local function createPlayerBasicData()
	return {
		Level = 1,
		XP = 0,
		RobuxSpent = 0,
		CurrentTitle = "",
		EquippedMount = "",
		SlotsApplicable = 3,
		Easter2025Score = 0,
		WinsWithSpeed = 0,
	}
end
return {
	createPlayerBasicData = createPlayerBasicData,
}
