import unitsDataRaw from "@shared/configuration/units-data.json";

// Type definitions
export type UnitRarity = "Rare" | "Epic" | "Legendary" | "Mythical" | "Secret" | "Reborn" | "Exclusive";

export type UnitElement = "Light" | "Dark" | "Wind" | "Fire" | "Water" | "Fierce" | "Ice";

export type UnitType = "Ground" | "Hybrid" | "Hill" | "Air";

export type PlacementType = "Ground" | "Hill" | "Air";

export type AttackType = "Circle" | "Single" | "Line" | "AOE" | "Multi" | "Cone";

export type GameType = "Portal" | "Raid" | "Story" | "Infinite" | "Tournament";

export interface UnitAnimations {
	idle: string;
	walk: string;
	wings: string;
	[key: string]: string | undefined;
}

// Cast the imported data with proper typing
export const unitsData = unitsDataRaw as unknown as UnitsData;

// More Dynamic Typing Enhancements
// ================================

// Extract actual unit names as literal union type from the data
export type UnitName = keyof typeof unitsData;

// Type-safe unit with specific name
export type TypedUnit<T extends UnitName> = Unit & {
	name: T;
	// You can extend this to include unit-specific properties
};

// Get specific unit's animation keys (will be specific to each unit if JSON varies)
export type UnitAnimationKeys<T extends UnitName> = keyof (typeof unitsData)[T]["animations"];

// Template literal type for unit display names
export type UnitDisplayName<T extends UnitName> = (typeof unitsData)[T]["configuration"]["DisplayName"];

// Conditional type for evolvable units
export type EvolvableUnit<T extends UnitName> =
	(typeof unitsData)[T]["configuration"]["EvolveData"] extends readonly unknown[]
		? (typeof unitsData)[T]["configuration"]["EvolveData"]["length"] extends 0
			? never
			: T
		: never;

// Get all evolvable unit names as a union
export type EvolvableUnitNames = {
	[K in UnitName]: EvolvableUnit<K>;
}[UnitName];

// Unit rarity mapping
export type UnitsByRarity = {
	[K in UnitName]: (typeof unitsData)[K]["configuration"]["Rarity"];
};

// Get units by specific rarity
export type UnitsOfRarity<R extends UnitRarity> = {
	[K in UnitName]: (typeof unitsData)[K]["configuration"]["Rarity"] extends R ? K : never;
}[UnitName];

// Advanced: Get units with specific passives
export type UnitsWithPassive<P extends string> = {
	[K in UnitName]: P extends (typeof unitsData)[K]["configuration"]["Passives"][number] ? K : never;
}[UnitName];

// Type-safe getters with more specific return types
export function getSpecificUnit<T extends UnitName>(name: T): TypedUnit<T> | undefined {
	const unit = unitsData[name];
	if (!unit) return undefined;
	return { ...unit, name } as TypedUnit<T>;
}

// Get units of specific rarity with compile-time checking
export function getUnitsOfRarity<R extends UnitRarity>(rarity: R): Array<TypedUnit<UnitsOfRarity<R>>> {
	const result: Array<TypedUnit<UnitsOfRarity<R>>> = [];

	for (const [name, unit] of pairs(unitsData)) {
		if (unit.configuration.Rarity === rarity) {
			result.push({ ...unit, name } as TypedUnit<UnitsOfRarity<R>>);
		}
	}

	return result;
}

// Get all unit names as a strongly typed array (already exists, but keeping for reference)
export function getAllUnitNames(): UnitName[] {
	const names: UnitName[] = [];
	for (const [name] of pairs(unitsData)) {
		names.push(name as UnitName);
	}
	return names;
}

// Type predicate for checking if a string is a valid unit name
export function isUnitName(name: string): name is UnitName {
	return name in unitsData;
}

// Get unit animations with specific typing
export function getUnitAnimations<T extends UnitName>(unitName: T): (typeof unitsData)[T]["animations"] | undefined {
	const unit = unitsData[unitName];
	return unit?.animations;
}

// Example usage with IntelliSense:
// const unit = getSpecificUnit("SpecificUnitName"); // Type will be TypedUnit<"SpecificUnitName">
// const rareUnits = getUnitsOfRarity("Rare"); // Type will be Array<TypedUnit<UnitsOfRarity<"Rare">>>

// Extract unit names as literal types for better type safety (keeping existing)
export type UnitName = keyof typeof unitsData;
