// Deep copy utility for immutable data operations

export function deepCopy<T>(obj: T): T {
    const objType = typeOf(obj); // typeOf should correctly identify tables/arrays as "table"

    if (objType !== "table") { // Handles primitives, functions, nil (as per typeOf mock)
        return obj;
    }

    // Check if the object is actually a JavaScript array
    if (Array.isArray(obj)) {
        const arrCopy = [] as unknown as any[]; // Initialize as an array
        for (const item of obj as unknown as unknown[]) { // Iterate array elements
            arrCopy.push(deepCopy(item)); // Push deep copied elements
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
