import unitsDataRaw from "@shared/configuration/units-data.json";

// Performance-optimized exact typing from JSON
export const unitsData = unitsDataRaw as typeof unitsDataRaw;

// Extract actual unit names as literal union type from the JSON
export type UnitName = keyof typeof unitsData;

// Exact types - these give you perfect per-unit typing
export type ExactUnit<T extends UnitName> = (typeof unitsData)[T];
export type ExactAnimations<T extends UnitName> = (typeof unitsData)[T]["animations"];
export type ExactConfiguration<T extends UnitName> = (typeof unitsData)[T]["configuration"];

// Get specific unit's animation keys (exact - only the keys that exist for this unit)
export type UnitAnimationKeys<T extends UnitName> = keyof ExactAnimations<T>;

// Core exact typing functions
export function getExactUnit<T extends UnitName>(name: T): ExactUnit<T> | undefined {
	const unit = unitsData[name];
	if (unit === undefined) return undefined;
	return unit;
}

export function getExactAnimations<T extends UnitName>(unitName: T): ExactAnimations<T> {
	return unitsData[unitName].animations;
}

export function getExactConfiguration<T extends UnitName>(unitName: T): ExactConfiguration<T> {
	return unitsData[unitName].configuration;
}

// Type-safe unit name validation
export function isValidUnitName(name: string): name is UnitName {
	return name in unitsData;
}

// Get all unit names as a strongly typed array (cached for performance)
let cachedUnitNames: UnitName[] | undefined;
export function getAllUnitNames(): UnitName[] {
	if (cachedUnitNames) return cachedUnitNames;

	const names: UnitName[] = [];
	for (const [name] of pairs(unitsData)) {
		names.push(name as UnitName);
	}
	cachedUnitNames = names;
	return names;
}

// Utility functions - type-safe and optimized

// Animation utilities
export function hasAnimation<T extends UnitName>(unitName: T, animationKey: string): boolean {
	return animationKey in getExactAnimations(unitName);
}

export function getUnitsWithWings(): UnitName[] {
	const result: UnitName[] = [];
	for (const name of getAllUnitNames()) {
		if (hasAnimation(name, "wings")) {
			result.push(name);
		}
	}
	return result;
}

export function getUnitsWithAnimation(animationKey: string): UnitName[] {
	const result: UnitName[] = [];
	for (const name of getAllUnitNames()) {
		if (hasAnimation(name, animationKey)) {
			result.push(name);
		}
	}
	return result;
}

// Stat utilities with exact typing
export function getUnitStat<T extends UnitName, K extends keyof ExactConfiguration<T>>(
	unitName: T,
	statKey: K,
): ExactConfiguration<T>[K] {
	return getExactConfiguration(unitName)[statKey];
}

// Specific stat getters for common use cases
export function getUnitDamage<T extends UnitName>(unitName: T): ExactConfiguration<T>["Damage"] {
	return getExactConfiguration(unitName).Damage;
}

export function getUnitRange<T extends UnitName>(unitName: T): ExactConfiguration<T>["Range"] {
	return getExactConfiguration(unitName).Range;
}

export function getUnitAttackSpeed<T extends UnitName>(unitName: T): ExactConfiguration<T>["AttackSpeed"] {
	return getExactConfiguration(unitName).AttackSpeed;
}

export function getUnitPrice<T extends UnitName>(unitName: T): ExactConfiguration<T>["PlacementPrice"] {
	return getExactConfiguration(unitName).PlacementPrice;
}

export function getUnitRarity<T extends UnitName>(unitName: T): ExactConfiguration<T>["Rarity"] {
	return getExactConfiguration(unitName).Rarity;
}

export function getUnitElement<T extends UnitName>(unitName: T): ExactConfiguration<T>["Element"] {
	return getExactConfiguration(unitName).Element;
}

export function getUnitDisplayName<T extends UnitName>(unitName: T): ExactConfiguration<T>["DisplayName"] {
	return getExactConfiguration(unitName).DisplayName;
}

// Filtering utilities
export function getUnitsByRarity(rarity: string): UnitName[] {
	const result: UnitName[] = [];
	for (const name of getAllUnitNames()) {
		if (getUnitRarity(name) === rarity) {
			result.push(name);
		}
	}
	return result;
}

export function getUnitsByElement(element: string): UnitName[] {
	const result: UnitName[] = [];
	for (const name of getAllUnitNames()) {
		if (getUnitElement(name) === element) {
			result.push(name);
		}
	}
	return result;
}

export function getReleasedUnits(): UnitName[] {
	const result: UnitName[] = [];
	for (const name of getAllUnitNames()) {
		const unit = getExactUnit(name);
		if (unit && unit.Released) {
			result.push(name);
		}
	}
	return result;
}

export function getSummonableUnits(): UnitName[] {
	const result: UnitName[] = [];
	for (const name of getAllUnitNames()) {
		const unit = getExactUnit(name);
		if (unit && unit.Summonable) {
			result.push(name);
		}
	}
	return result;
}

export function getTradableUnits(): UnitName[] {
	const result: UnitName[] = [];
	for (const name of getAllUnitNames()) {
		const unit = getExactUnit(name);
		if (unit && unit.Tradable) {
			result.push(name);
		}
	}
	return result;
}

// Search utilities
export function searchUnitsByName(searchTerm: string): UnitName[] {
	const lowerSearchTerm = string.lower(searchTerm);
	const result: UnitName[] = [];

	for (const name of getAllUnitNames()) {
		const displayName = getUnitDisplayName(name);
		const nameMatch = string.find(string.lower(name), lowerSearchTerm, 1, true)[0] !== undefined;
		const displayNameMatch = string.find(string.lower(displayName), lowerSearchTerm, 1, true)[0] !== undefined;

		if (nameMatch || displayNameMatch) {
			result.push(name);
		}
	}

	return result;
}

// Comparison utility
export function compareUnitStats<T extends UnitName, U extends UnitName>(unitA: T, unitB: U) {
	const configA = getExactConfiguration(unitA);
	const configB = getExactConfiguration(unitB);

	return {
		unitA,
		unitB,
		damageA: configA.Damage,
		damageB: configB.Damage,
		rangeA: configA.Range,
		rangeB: configB.Range,
		speedA: configA.AttackSpeed,
		speedB: configB.AttackSpeed,
		priceA: configA.PlacementPrice,
		priceB: configB.PlacementPrice,
	};
}

// Statistical utilities
export function getHighestDamageUnits(limit = 10): Array<{ name: UnitName; damage: number }> {
	const units = getAllUnitNames().map((name) => ({
		name,
		damage: getUnitDamage(name),
	}));

	// Manual sort since Luau arrays don't have built-in sort
	for (let i = 0; i < units.size(); i++) {
		for (let j = i + 1; j < units.size(); j++) {
			if (units[j].damage > units[i].damage) {
				const temp = units[i];
				units[i] = units[j];
				units[j] = temp;
			}
		}
	}

	// Return top 'limit' units
	const result: Array<{ name: UnitName; damage: number }> = [];
	for (let i = 0; i < math.min(limit, units.size()); i++) {
		result.push(units[i]);
	}
	return result;
}

export function getLowestPriceUnits(limit = 10): Array<{ name: UnitName; price: number }> {
	const units = getAllUnitNames().map((name) => ({
		name,
		price: getUnitPrice(name),
	}));

	// Manual sort by price (ascending)
	for (let i = 0; i < units.size(); i++) {
		for (let j = i + 1; j < units.size(); j++) {
			if (units[j].price < units[i].price) {
				const temp = units[i];
				units[i] = units[j];
				units[j] = temp;
			}
		}
	}

	// Return lowest 'limit' units
	const result: Array<{ name: UnitName; price: number }> = [];
	for (let i = 0; i < math.min(limit, units.size()); i++) {
		result.push(units[i]);
	}
	return result;
}

export function getAverageDamageByRarity(rarity: string): number {
	const units = getUnitsByRarity(rarity);
	if (units.size() === 0) return 0;

	let totalDamage = 0;
	for (const unit of units) {
		totalDamage += getUnitDamage(unit);
	}

	return totalDamage / units.size();
}

// Random utilities
export function getRandomUnit(): UnitName {
	const allUnits = getAllUnitNames();
	const randomIndex = math.random(1, allUnits.size());
	return allUnits[randomIndex - 1];
}

export function getRandomUnitByRarity(rarity: string): UnitName | undefined {
	const units = getUnitsByRarity(rarity);
	if (units.size() === 0) return undefined;

	const randomIndex = math.random(1, units.size());
	return units[randomIndex - 1];
}

// Filter utility using exact types
export function filterUnitsByProperty<T extends UnitName, K extends keyof ExactConfiguration<T>>(
	units: T[],
	property: K,
	value: ExactConfiguration<T>[K],
): T[] {
	return units.filter((unit) => getExactConfiguration(unit)[property] === value);
}

// Validation utility
export function validateUnit<T extends UnitName>(unitName: T): { isValid: boolean; errors: string[] } {
	const errors: string[] = [];

	try {
		const unit = getExactUnit(unitName);
		if (!unit) {
			errors.push("Unit not found");
			return { isValid: false, errors };
		}

		const config = getExactConfiguration(unitName);

		if (config.Damage <= 0) errors.push("Damage must be positive");
		if (config.Range <= 0) errors.push("Range must be positive");
		if (config.AttackSpeed <= 0) errors.push("Attack speed must be positive");
		if (config.PlacementPrice < 0) errors.push("Placement price cannot be negative");
	} catch (error) {
		errors.push(`Validation error: ${error}`);
	}

	return {
		isValid: errors.size() === 0,
		errors,
	};
}

/*
 * Perfect per-unit typing examples:
 *
 * const airaAnimations = getExactAnimations("Aira");
 * // Type: { idle: number; walk: number } - only animations this unit has
 *
 * const aizenAnimations = getExactAnimations("AizenHogyoku [Evo]");
 * // Type: { idle: number; walk: number; wings: number } - includes wings
 *
 * type AiraKeys = UnitAnimationKeys<"Aira">; // "idle" | "walk"
 * type AizenKeys = UnitAnimationKeys<"AizenHogyoku [Evo]">; // "idle" | "walk" | "wings"
 */
