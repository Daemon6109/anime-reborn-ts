// Advent calendar data factory
export interface AdventCalendarData {
	Name: string;
	Claimed: number[]; // Array of claimed day numbers
	OnlineDays: number;
	DayNumber: number;
}

export function createAdventCalendarData(): AdventCalendarData {
	return {
		Name: "",
		Claimed: [],
		OnlineDays: 0,
		DayNumber: 0,
	};
}
