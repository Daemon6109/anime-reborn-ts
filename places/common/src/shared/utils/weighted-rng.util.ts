/**
 * Performs weighted random selection from a map or record of options.
 *
 * @param weightedMap A Map or Record where keys are the items to be selected
 *                    and values are their corresponding positive numerical weights.
 * @returns The randomly selected key (item).
 * @template T The type of the items (keys in the weightedMap).
 *
 * @throws Error if the total weight is not greater than 0, or if the map is empty.
 *
 * Example:
 * ```ts
 * const options = new Map<string, number>([
 *   ["CommonItem", 60],
 *   ["RareItem", 30],
 *   ["EpicItem", 10],
 * ]);
 * const result = weightedRandomSelect(options);
 * console.log(result); // e.g., "CommonItem"
 *
 * const optionsRecord: Record<string, number> = {
 *   A: 1,
 *   B: 1,
 *   C: 8,
 * };
 * const resultRecord = weightedRandomSelect(optionsRecord);
 * console.log(resultRecord); // More likely "C"
 * ```
 */
export function weightedRandomSelect<T>(
	weightedItems: ReadonlyMap<T, number> | Readonly<Record<string | number | symbol, number>>,
): T {
	let totalWeight = 0;
	const itemsArray: Array<{ item: T; weight: number }> = [];

	if (weightedItems instanceof Map) {
		if (weightedItems.size === 0) {
			throw new Error("Weighted item map cannot be empty.");
		}
		weightedItems.forEach((weight, item) => {
			if (weight < 0) throw new Error(`Weight for item "${String(item)}" must be non-negative.`);
			totalWeight += weight;
			itemsArray.push({ item, weight });
		});
	} else {
		const keys = Object.keys(weightedItems) as Array<Extract<keyof typeof weightedItems, string>>;
		if (keys.length === 0) {
			throw new Error("Weighted item record cannot be empty.");
		}
		for (const key of keys) {
			const weight = weightedItems[key];
			if (typeof weight !== "number" || weight < 0) {
				throw new Error(`Weight for item "${String(key)}" must be a non-negative number.`);
			}
			totalWeight += weight;
			itemsArray.push({ item: key as unknown as T, weight });
		}
	}

	if (totalWeight <= 0) {
		throw new Error("Total weight must be greater than 0.");
	}

	const randomValue = Math.random() * totalWeight;
	let currentWeight = 0;

	// Iterate through the collected items
	for (const entry of itemsArray) {
		currentWeight += entry.weight;
		if (randomValue <= currentWeight) {
			return entry.item;
		}
	}

	// Fallback: should theoretically not be reached if totalWeight > 0 and items exist.
	// This could happen if all weights are 0, but that's caught by totalWeight <= 0.
	// Or if randomValue is exactly totalWeight and there's a floating point precision issue.
	// Returning the last item in such an edge case is a reasonable fallback.
	if (itemsArray.length > 0) {
		return itemsArray[itemsArray.length - 1].item;
	}

	// This case should be impossible given the earlier checks.
	throw new Error("Weighted random selection failed due to an unexpected state.");
}

/**
 * Alias for weightedRandomSelect for brevity if preferred.
 */
export const weightedRNG = weightedRandomSelect;
