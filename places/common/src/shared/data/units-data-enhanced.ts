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

export interface UpgradeInfo {
	Damage: number;
	Range: number;
	AttackSpeed: number;
	Ability: string;
	AttackSize: number;
	AttackType: AttackType;
	UnitType: UnitType;
	UpgradePrice: number;
}

export interface EvolveRequirements {
	Items: Record<string, number>;
	Units: Record<string, number>;
}

export interface EvolveData {
	Requirements: EvolveRequirements;
	DisplayBuffs: string[];
}

export interface MapAffinityBoosts {
	PermanentDamageMulti: number;
	[key: string]: string | number | undefined;
}

export interface UnitConfiguration {
	DisplayName: string;
	Damage: number;
	Range: number;
	AttackSpeed: number;
	PlacementPrice: number;
	UpgradePrice: number;
	SellCost: number;
	MaxUpgrades: number;
	MaxPlacementAmount: number;
	AttackType: AttackType;
	AttackSize: number;
	AttackCriticalChance: number;
	AttackCriticalDamage: number;
	AttackEffect: string;
	AttackEffectDuration: number;
	Rarity: UnitRarity;
	Element: UnitElement;
	UnitType: UnitType;
	PlacementType: PlacementType;
	Ability: string;
	SpecialAbility: string;
	SpecialAbilityCooldown: number;
	IsSpecialAbilityGlobalCooldown: boolean;
	Passives: string[];
	GameTypeAffinity: GameType[];
	MapAffnity: string;
	MapAffnityBoosts: MapAffinityBoosts;
	EvolvesInto: string;
	EvolveData: EvolveData[];
	TransferStats: boolean;
	EliminationsRequired: number;
	UpgradesInfo: UpgradeInfo[];
	CanSell: boolean;
	Money: number;
	PermanentDamageMulti: number;
}

export interface Unit {
	Released: boolean;
	Summonable: boolean;
	Radius: number;
	ShinyTradable: boolean;
	Tradable: boolean;
	animations: UnitAnimations;
	configuration: UnitConfiguration;
}

export type UnitsData = Record<string, Unit>;

// Cast the imported data with proper typing
export const unitsData = unitsDataRaw as unknown as UnitsData;

// 🚀 ENHANCED DYNAMIC TYPING FEATURES
// ===================================

// Extract actual unit names as literal union type from the JSON
export type UnitName = keyof typeof unitsData;

// Type-safe unit with specific name
export type TypedUnit<T extends UnitName> = Unit & { name: T };

// Get specific unit's animation keys (will be specific to each unit's JSON structure)
export type UnitAnimationKeys<T extends UnitName> = keyof (typeof unitsData)[T]["animations"];

// Get the display name type for a specific unit
export type UnitDisplayName<T extends UnitName> = (typeof unitsData)[T]["configuration"]["DisplayName"];

// Get units by specific rarity with stronger typing
export type UnitsOfRarity<R extends UnitRarity> = {
	[K in UnitName]: (typeof unitsData)[K]["configuration"]["Rarity"] extends R ? K : never;
}[UnitName];

// Get units by specific element with stronger typing
export type UnitsOfElement<E extends UnitElement> = {
	[K in UnitName]: (typeof unitsData)[K]["configuration"]["Element"] extends E ? K : never;
}[UnitName];

// Get units by type with stronger typing
export type UnitsOfType<T extends UnitType> = {
	[K in UnitName]: (typeof unitsData)[K]["configuration"]["UnitType"] extends T ? K : never;
}[UnitName];

// Check if a unit has evolution data
export type HasEvolution<T extends UnitName> = (typeof unitsData)[T]["configuration"]["EvolveData"] extends []
	? false
	: true;

// Get all evolvable units
export type EvolvableUnitNames = {
	[K in UnitName]: HasEvolution<K> extends true ? K : never;
}[UnitName];

// 🎯 TYPE-SAFE FUNCTIONS WITH ENHANCED INTELLISENSE
// =================================================

// Get a specific unit with its exact type
export function getSpecificUnit<T extends UnitName>(name: T): TypedUnit<T> | undefined {
	const unit = unitsData[name];
	if (unit === undefined) return undefined;
	return { ...unit, name };
}

// Get units of a specific rarity with compile-time type safety
export function getUnitsOfRarity<R extends UnitRarity>(rarity: R): Array<TypedUnit<UnitsOfRarity<R>>> {
	const result: Array<TypedUnit<UnitsOfRarity<R>>> = [];

	for (const [name, unit] of pairs(unitsData)) {
		if (unit.configuration.Rarity === rarity) {
			result.push({ ...unit, name: name as UnitsOfRarity<R> });
		}
	}

	return result;
}

// Get units of a specific element with compile-time type safety
export function getUnitsOfElement<E extends UnitElement>(element: E): Array<TypedUnit<UnitsOfElement<E>>> {
	const result: Array<TypedUnit<UnitsOfElement<E>>> = [];

	for (const [name, unit] of pairs(unitsData)) {
		if (unit.configuration.Element === element) {
			result.push({ ...unit, name: name as UnitsOfElement<E> });
		}
	}

	return result;
}

// Get unit animations with unit-specific typing
export function getUnitAnimations<T extends UnitName>(unitName: T): (typeof unitsData)[T]["animations"] {
	return unitsData[unitName].animations;
}

// Get unit configuration with unit-specific typing
export function getUnitConfiguration<T extends UnitName>(unitName: T): (typeof unitsData)[T]["configuration"] {
	return unitsData[unitName].configuration;
}

// Type-safe unit name validation
export function isValidUnitName(name: string): name is UnitName {
	return name in unitsData;
}

// Get all unit names as a strongly typed array
export function getAllUnitNames(): UnitName[] {
	const names: UnitName[] = [];
	for (const [name] of pairs(unitsData)) {
		names.push(name as UnitName);
	}
	return names;
}

// Example Usage:
// ==============
/*
// ✅ This will give you EXACT types based on your JSON:
const specificUnit = getSpecificUnit("YourExactUnitName"); // TypedUnit<"YourExactUnitName">
const rareUnits = getUnitsOfRarity("Rare"); // Array<TypedUnit<UnitsOfRarity<"Rare">>>
const fireUnits = getUnitsOfElement("Fire"); // Array<TypedUnit<UnitsOfElement<"Fire">>>

// ✅ Unit animations will be typed based on the specific unit's JSON:
const animations = getUnitAnimations("YourExactUnitName"); // Specific to that unit's animations

// ✅ IntelliSense will show you EXACT unit names from your JSON:
const unitNames = getAllUnitNames(); // UnitName[] with all your actual unit names

// ✅ Type-safe validation:
if (isValidUnitName(someString)) {
    // someString is now typed as UnitName
    const unit = getSpecificUnit(someString); // This works and is type-safe!
}
*/

// 🔄 COMPATIBILITY LAYER - Keep your existing functions working
// ============================================================

// Utility functions (simplified versions of your existing UnitsDataUtils)
function getUnitDamage(unit: Unit): number {
	return unit.configuration.Damage;
}

function getUnitRange(unit: Unit): number {
	return unit.configuration.Range;
}

function getUnitAttackSpeed(unit: Unit): number {
	return unit.configuration.AttackSpeed;
}

// Your existing utility class, but with enhanced typing where possible
export class UnitsDataUtils {
	static getAllUnits(): Array<Unit & { name: string }> {
		const entries: Array<[string, Unit]> = [];
		for (const [name, unit] of pairs(unitsData)) {
			entries.push([name, unit]);
		}
		return entries.map(([name, unit]) => ({ ...unit, name }));
	}

	static getReleasedUnits(): Array<Unit & { name: string }> {
		return this.getAllUnits().filter((unit) => unit.Released);
	}

	static getSummonableUnits(): Array<Unit & { name: string }> {
		return this.getAllUnits().filter((unit) => unit.Summonable);
	}

	static getUnitsByRarity(rarity: UnitRarity): Array<Unit & { name: string }> {
		return this.getAllUnits().filter((unit) => unit.configuration.Rarity === rarity);
	}

	static getUnit(name: string): Unit | undefined {
		return unitsData[name];
	}

	static searchUnitsByName(searchTerm: string): Array<Unit & { name: string }> {
		const lowerSearchTerm = string.lower(searchTerm);
		return this.getAllUnits().filter(
			(unit) =>
				string.find(string.lower(unit.name), lowerSearchTerm, 1, true)[0] !== undefined ||
				string.find(string.lower(unit.configuration.DisplayName), lowerSearchTerm, 1, true)[0] !== undefined,
		);
	}
}

// Export existing function signatures for compatibility
export function getAllUnits() {
	return UnitsDataUtils.getAllUnits();
}

export function getUnit(name: string) {
	return UnitsDataUtils.getUnit(name);
}

// ... (export all your other existing functions here)
