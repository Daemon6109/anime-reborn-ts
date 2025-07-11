import type { CalendarName } from "@shared/data/advent-calendar-data";

export interface AdventCalendarEntry {
	claimed: number[]; // Array of claimed day numbers
	onlineDays: number;
}

// Dictionary with calendar name + end date as key, and calendar data as value
export type AdventCalendarData = Map<CalendarName, AdventCalendarEntry>;
