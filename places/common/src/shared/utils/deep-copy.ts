// Deep copy utility for immutable data operations

export function deepCopy<T>(obj: T): T {
	if (typeOf(obj) !== "table") {
		return obj;
	}

	const copy = {} as Record<string, unknown>;
	const objTable = obj as Record<string, unknown>;

	for (const [key, value] of pairs(objTable)) {
		if (typeOf(value) === "table") {
			copy[key] = deepCopy(value);
		} else {
			copy[key] = value;
		}
	}

	return copy as T;
}
