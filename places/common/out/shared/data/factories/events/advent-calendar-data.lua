-- Compiled with roblox-ts v2.3.0
-- Advent calendar data factory
local function createAdventCalendarData()
	return {
		Name = "",
		Claimed = {},
		OnlineDays = 0,
		DayNumber = 0,
	}
end
return {
	createAdventCalendarData = createAdventCalendarData,
}
