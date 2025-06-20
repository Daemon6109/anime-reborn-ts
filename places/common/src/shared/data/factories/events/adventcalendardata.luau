export type AdventCalendarData = {
	Name: string,
	Claimed: { number }, -- Array of claimed day numbers
	OnlineDays: number,
	DayNumber: number,
}

local function createAdventCalendarData(): AdventCalendarData
	return {
		Name = "",
		Claimed = {},
		OnlineDays = 0,
		DayNumber = 0,
	}
end

return createAdventCalendarData
