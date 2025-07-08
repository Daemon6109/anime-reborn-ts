// Configuration
import adventCalendarDataRaw from "@shared/configuration/advent-calendar-data.json";
// Performance-optimized exact typing from JSON
export const adventCalendarData = adventCalendarDataRaw as typeof adventCalendarDataRaw;

// Extract actual calendar names as literal union type from the JSON
export type CalendarName = keyof typeof adventCalendarData;

export interface AdventCalendarData {
	claimed: number[]; // Array of claimed day numbers
	onlineDays: number;
}
