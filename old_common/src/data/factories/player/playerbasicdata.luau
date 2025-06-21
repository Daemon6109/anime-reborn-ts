export type PlayerBasicData = {
	Level: number,
	XP: number,
	RobuxSpent: number,
	CurrentTitle: string,
	EquippedMount: string,
	SlotsApplicable: number,
	Easter2025Score: number,
	WinsWithSpeed: number,
}

local function createPlayerBasicData(): PlayerBasicData
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

return createPlayerBasicData
