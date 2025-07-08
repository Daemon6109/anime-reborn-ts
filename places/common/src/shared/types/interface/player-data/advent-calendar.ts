// Configuration
import adventCalendarDataRaw from "@shared/configuration/advent-calendar-data.json";
// Performance-optimized exact typing from JSON
export const adventCalendarData = adventCalendarDataRaw as typeof adventCalendarDataRaw;

// Extract actual calendar names as literal union type from the JSON
export type CalendarName = keyof typeof adventCalendarData;

export interface AdventCalendarEntry {
	claimed: number[]; // Array of claimed day numbers
	onlineDays: number;
}

// Dictionary with calendar name + end date as key, and calendar data as value
export type AdventCalendarData = Record<string, AdventCalendarEntry>;
