// Deep copy utility for immutable data operations

export function deepCopy<T>(obj: T): T {
	const objType = typeOf(obj); // typeOf should correctly identify tables/arrays as "table"

	if (objType !== "table") {
		// Handles primitives, functions, nil (as per typeOf mock)
		return obj;
	}

	// Check if the object is actually an array (Lua array: integer keys starting from 1)
	if (objType === "table" && isArray(obj)) {
		const arrCopy = [] as unknown[]; // Initialize as an array
		for (const [index, item] of pairs(obj as Record<number, unknown>)) {
			// Iterate array elements using pairs instead of ipairs
			arrCopy[(index as number) - 1] = deepCopy(item); // Push deep copied elements (Lua arrays are 1-indexed)
		}
		return arrCopy as T;
	} else {
		// It's a table-like object (dictionary)
		const objCopy = {} as Record<string, unknown>;
		// Use pairs for iterating, assuming it handles object key-value iteration correctly
		for (const [key, value] of pairs(obj as Record<string, unknown>)) {
			objCopy[key as string] = deepCopy(value); // Deep copy nested values
		}
		return objCopy as T;
	}
}

// Helper to check if a table is an array (Lua idiom: all keys are consecutive integers starting from 1)
function isArray(value: unknown): value is unknown[] {
	if (typeOf(value) !== "table") return false;
	let i = 1;
	for (const _ of pairs(value as object)) {
		if ((value as Record<number, unknown>)[i] === undefined) {
			return false;
		}
		i++;
	}
	return true;
}
