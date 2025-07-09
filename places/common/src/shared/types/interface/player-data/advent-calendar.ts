// Configuration
import adventCalendarDataRaw from "@shared/configuration/advent-calendar-data.json";
// Performance-optimized exact typing from JSON
export const adventCalendarData = adventCalendarDataRaw as typeof adventCalendarDataRaw;

// Extract actual calendar names as literal union type from the JSON
export type CalendarName = keyof typeof adventCalendarData;

// Utility function to get calendar names as a tuple for runtime validation
export const getCalendarNames = () => {
	const keys: (keyof typeof adventCalendarData)[] = [];
	for (const [key] of pairs(adventCalendarData)) {
		keys.push(key as keyof typeof adventCalendarData);
	}
	return keys;
};

export interface AdventCalendarEntry {
	claimed: number[]; // Array of claimed day numbers
	onlineDays: number;
}

// Dictionary with calendar name + end date as key, and calendar data as value
export type AdventCalendarData = Map<CalendarName, AdventCalendarEntry>;
