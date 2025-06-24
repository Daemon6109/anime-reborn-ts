interface LargeNumberFormat {
	denom: number;
	letter: string;
}

const FORMATS: LargeNumberFormat[] = [
	{
		denom: 1_000_000_000_000,
		letter: "T",
	},
	{
		denom: 1_000_000_000,
		letter: "B",
	},
	{
		denom: 1_000_000,
		letter: "M",
	},
	{
		denom: 1_000,
		letter: "K",
	},
];

/**
 * Formats a large number into a more readable string with an appropriate suffix.
 *
 * @param num The number to format.
 * @returns The formatted number as a string (e.g., "1.23M", "543K", "123").
 */
export function formatLargeNumber(num: number): string {
	for (const format of FORMATS) {
		if (num >= format.denom) {
			// Format to 2 decimal places, but remove .00 if it's a whole number after division.
			// Also, remove trailing 0s from decimals, e.g., 1.20M -> 1.2M
			const value = num / format.denom;
			let formattedValue = value.toFixed(2);
			if (formattedValue.endsWith(".00")) {
				formattedValue = value.toFixed(0);
			} else if (formattedValue.endsWith("0")) {
				formattedValue = value.toFixed(1);
			}
			return `${formattedValue}${format.letter}`;
		}
	}

	// For numbers less than 1000, or if it's 0, convert to string.
	// If it's a whole number, ensure no decimal places.
	if (Number.isInteger(num)) {
		return num.toString();
	}
	// For consistency, numbers like 999.123 should probably also be handled.
	// The original Luau code just did tostring(num).
	// Let's decide if we want to round or truncate for < 1000 with decimals.
	// For now, matching Luau:
	return num.toString();
}

/**
 * An alternative version that aims for more Roblox-like formatting,
 * typically showing up to 3 significant digits and then a suffix.
 * Example: 1,234 -> 1.23K; 12,345 -> 12.3K; 123,456 -> 123K; 1,234,567 -> 1.23M
 * This version is more complex and might not be what the original intended,
 * but is common in Roblox games.
 *
 * For now, the above `formatLargeNumber` function matches the original Luau script.
 * This function is provided as an alternative if more typical Roblox formatting is desired.
 */
export function formatLargeNumberRobloxStyle(num: number): string {
	if (num === 0) return "0";

	const abbreviations = ["", "K", "M", "B", "T", "Qd", "Qn", "Sx", "Sp", "Oc", "No", "Dc"]; // Add more if needed
	let i = 0;
	let value = num;

	while (value >= 1000 && i < abbreviations.length - 1) {
		value /= 1000;
		i++;
	}

	if (i === 0) {
		// No abbreviation, just format the number (e.g. 123, 12.3, 1.23)
		if (Number.isInteger(value)) return value.toString();
		if (value < 10) return value.toFixed(2);
		if (value < 100) return value.toFixed(1);
		return value.toFixed(0); // Should be 100-999
	}

	// With abbreviation
	if (value < 10) {
		return `${value.toFixed(2)}${abbreviations[i]}`;
	} else if (value < 100) {
		return `${value.toFixed(1)}${abbreviations[i]}`;
	} else {
		// value >= 100 && value < 1000
		return `${value.toFixed(0)}${abbreviations[i]}`;
	}
}
