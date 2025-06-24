const MINUTE_SECONDS = 60;
const HOUR_SECONDS = MINUTE_SECONDS * 60;
const DAY_SECONDS = HOUR_SECONDS * 24;

/**
 * Formats the given time remaining in seconds into a human-readable string.
 * Example: `formatTimeRemaining(3661)` -> `"1h 1m 1s"`
 * Example: `formatTimeRemaining(86400)` -> `"1d 0h 0m 0s"`
 * Example: `formatTimeRemaining(0)` -> `"0s"`
 *
 * @param timeRemainingInSeconds The time remaining in seconds. Must be greater than or equal to 0 and finite.
 * @returns A formatted string representing the time remaining in days, hours, minutes, and seconds.
 * @throws Error if timeRemainingInSeconds is negative or not finite.
 */
export function formatTimeRemaining(timeRemainingInSeconds: number): string {
	if (timeRemainingInSeconds < 0 || !Number.isFinite(timeRemainingInSeconds)) {
		throw new Error("timeRemainingInSeconds must be greater than or equal to 0 and finite.");
	}

	let remaining = timeRemainingInSeconds;

	const days = Math.floor(remaining / DAY_SECONDS);
	remaining -= days * DAY_SECONDS;

	const hours = Math.floor(remaining / HOUR_SECONDS);
	remaining -= hours * HOUR_SECONDS;

	const minutes = Math.floor(remaining / MINUTE_SECONDS);
	remaining -= minutes * MINUTE_SECONDS;

	// Ensure seconds are rounded to the nearest whole number if there are fractions
	// The original Luau script implicitly truncates due to math.floor earlier and then uses the remainder.
	// Here, `remaining` will be the seconds component.
	const seconds = Math.round(remaining);

	// Luau version implicitly rounds seconds by subtracting floored minutes.
	// If timeRemainingInSeconds was e.g. 59.9, seconds would be 59.
	// My version with Math.round(remaining) would make it 60s, which could then become 1m 0s.
	// Let's stick to the original logic more closely for seconds calculation.
	const finalSeconds = Math.floor(remaining);


	let str = `${finalSeconds}s`;

	if (minutes > 0 || hours > 0 || days > 0) {
		str = `${minutes}m ${str}`;
	}
	if (hours > 0 || days > 0) {
		str = `${hours}h ${str}`;
	}
	if (days > 0) {
		str = `${days}d ${str}`;
	}

	return str;
}

/**
 * An alternative version that only shows relevant units.
 * Example: `formatTimeRelevant(3661)` -> `"1h 1m 1s"`
 * Example: `formatTimeRelevant(86400)` -> `"1d"`
 * Example: `formatTimeRelevant(60)` -> `"1m"`
 * Example: `formatTimeRelevant(5)` -> `"5s"`
 * Example: `formatTimeRelevant(125)` -> `"2m 5s"`
 */
export function formatTimeRelevant(timeRemainingInSeconds: number): string {
	if (timeRemainingInSeconds < 0 || !Number.isFinite(timeRemainingInSeconds)) {
		throw new Error("timeRemainingInSeconds must be greater than or equal to 0 and finite.");
	}

	if (timeRemainingInSeconds === 0) {
		return "0s";
	}

	let remaining = timeRemainingInSeconds;
	const parts: string[] = [];

	const days = Math.floor(remaining / DAY_SECONDS);
	if (days > 0) {
		parts.push(`${days}d`);
		remaining -= days * DAY_SECONDS;
	}

	const hours = Math.floor(remaining / HOUR_SECONDS);
	if (hours > 0) {
		parts.push(`${hours}h`);
		remaining -= hours * HOUR_SECONDS;
	}

	const minutes = Math.floor(remaining / MINUTE_SECONDS);
	if (minutes > 0) {
		parts.push(`${minutes}m`);
		remaining -= minutes * MINUTE_SECONDS;
	}

	const seconds = Math.floor(remaining); // Use floor to match original logic more closely
	if (seconds > 0 || parts.length === 0) { // Always show seconds if it's the only unit or non-zero
		parts.push(`${seconds}s`);
	}

	return parts.join(" ");
}
