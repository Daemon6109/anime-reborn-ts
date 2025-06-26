import unitsDataRaw from "./units-data.json";

// Type definitions
export type UnitRarity = "Rare" | "Epic" | "Legendary" | "Mythical" | "Secret" | "Reborn" | "Exclusive";

export type UnitElement = "Light" | "Dark" | "Wind" | "Fire" | "Water" | "Fierce" | "Ice";

export type UnitType = "Ground" | "Hybrid" | "Hill" | "Air";

export type PlacementType = "Ground" | "Hill" | "Air";

export type AttackType = "Circle" | "Single" | "Line" | "AOE" | "Multi" | "Cone";

export type GameType = "Portal" | "Raid" | "Story" | "Infinite" | "Tournament";

export interface UnitAnimations {
	idle?: string;
	walk?: string;
	wings?: string;
	[key: string]: string | undefined;
}

export interface UpgradeInfo {
	Damage?: number;
	Range?: number;
	AttackSpeed?: number;
	Ability?: string;
	AttackSize?: number;
	AttackType?: AttackType;
	UnitType?: UnitType;
	UpgradePrice: number;
}

export interface EvolveRequirements {
	Items?: Record<string, number>;
	Units?: Record<string, number>;
}

export interface EvolveData {
	Requirements: EvolveRequirements;
	DisplayBuffs: string[];
}

export interface MapAffinityBoosts {
	PermanentDamageMulti?: number;
	[key: string]: string | number | undefined;
}

export interface UnitConfiguration {
	// Basic properties
	DisplayName?: string;
	Damage: number | string;
	Range: number | string;
	AttackSpeed: number | string;
	PlacementPrice: number;
	UpgradePrice: number;
	SellCost?: number;
	MaxUpgrades: number;
	MaxPlacementAmount: number;

	// Combat properties
	AttackType: AttackType;
	AttackSize?: number | string;
	AttackCriticalChance?: number;
	AttackCriticalDamage?: number;
	AttackEffect?: string;
	AttackEffectDuration?: number;

	// Classification
	Rarity: UnitRarity;
	Element: UnitElement;
	UnitType: UnitType;
	PlacementType: PlacementType;

	// Special abilities
	Ability?: string;
	SpecialAbility?: string;
	SpecialAbilityCooldown?: number;
	IsSpecialAbilityGlobalCooldown?: boolean;

	// Passives and affinities
	Passives?: string[];
	GameTypeAffinity?: GameType[];
	MapAffnity?: string;
	MapAffnityBoosts?: MapAffinityBoosts;

	// Evolution
	EvolvesInto?: string;
	EvolveData?: EvolveData[];
	TransferStats?: boolean;
	EliminationsRequired?: number;

	// Upgrades
	UpgradesInfo?: UpgradeInfo[];

	// Misc
	CanSell?: boolean;
	Money?: number;
	PermanentDamageMulti?: number;
}

export interface Unit {
	Released: boolean;
	Summonable: boolean;
	Radius?: number;
	ShinyTradable?: boolean;
	Tradable?: boolean;
	animations: UnitAnimations;
	configuration: UnitConfiguration;
}

export type UnitsData = Record<string, Unit>;

// Cast the imported data with proper typing
export const unitsData = unitsDataRaw as unknown as UnitsData;

// Extract unit names as literal types for better type safety
export type UnitName = keyof typeof unitsData;

// Helper type to get a unit with its name
export type UnitWithName<T extends UnitName = UnitName> = Unit & { name: T };

// Type for getting specific unit data
export type GetUnitData<T extends UnitName> = (typeof unitsData)[T];

// Type-safe unit getter
export function getTypedUnit<T extends UnitName>(name: T): GetUnitData<T> | undefined {
	return unitsData[name];
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

// Utility functions
export class UnitsDataUtils {
	/**
	 * Get all units as an array with their names
	 */
	static getAllUnits(): Array<Unit & { name: string }> {
		const entries: Array<[string, Unit]> = [];
		for (const [name, unit] of pairs(unitsData)) {
			entries.push([name, unit]);
		}
		return entries.map(([name, unit]) => ({
			...unit,
			name,
		}));
	}

	/**
	 * Get units filtered by release status
	 */
	static getReleasedUnits(): Array<Unit & { name: string }> {
		return this.getAllUnits().filter((unit) => unit.Released);
	}

	/**
	 * Get units filtered by summonable status
	 */
	static getSummonableUnits(): Array<Unit & { name: string }> {
		return this.getAllUnits().filter((unit) => unit.Summonable);
	}

	/**
	 * Get units by rarity
	 */
	static getUnitsByRarity(rarity: UnitRarity): Array<Unit & { name: string }> {
		return this.getAllUnits().filter((unit) => unit.configuration.Rarity === rarity);
	}

	/**
	 * Get units by element
	 */
	static getUnitsByElement(element: UnitElement): Array<Unit & { name: string }> {
		return this.getAllUnits().filter((unit) => unit.configuration.Element === element);
	}

	/**
	 * Get units by unit type
	 */
	static getUnitsByType(unitType: UnitType): Array<Unit & { name: string }> {
		return this.getAllUnits().filter((unit) => unit.configuration.UnitType === unitType);
	}

	/**
	 * Get units by placement type
	 */
	static getUnitsByPlacementType(placementType: PlacementType): Array<Unit & { name: string }> {
		return this.getAllUnits().filter((unit) => unit.configuration.PlacementType === placementType);
	}

	/**
	 * Get units that have evolution data
	 */
	static getEvolvableUnits(): Array<Unit & { name: string }> {
		return this.getAllUnits().filter(
			(unit) => unit.configuration.EvolveData !== undefined && unit.configuration.EvolveData.size() > 0,
		);
	}

	/**
	 * Get evolution chains (base unit -> evolved forms)
	 */
	static getEvolutionChains(): Record<string, string[]> {
		const chains: Record<string, string[]> = {};

		for (const [name, unit] of pairs(unitsData)) {
			if (unit.configuration.EvolvesInto !== undefined && unit.configuration.EvolvesInto !== "") {
				const baseName = string.gsub(name, "%s*%[.*%]$", "")[0]; // Remove [Evo] suffix
				if (!chains[baseName]) {
					chains[baseName] = [name];
				}
				chains[baseName].push(unit.configuration.EvolvesInto);
			}
		}

		return chains;
	}

	/**
	 * Get units with specific passives
	 */
	static getUnitsByPassive(passive: string): Array<Unit & { name: string }> {
		return this.getAllUnits().filter((unit) => unit.configuration.Passives?.includes(passive));
	}

	/**
	 * Get units with game type affinity
	 */
	static getUnitsByGameTypeAffinity(gameType: GameType): Array<Unit & { name: string }> {
		return this.getAllUnits().filter((unit) => unit.configuration.GameTypeAffinity?.includes(gameType));
	}

	/**
	 * Get units by damage range
	 */
	static getUnitsByDamageRange(minDamage: number, maxDamage: number): Array<Unit & { name: string }> {
		return this.getAllUnits().filter((unit) => {
			const damage = getUnitDamage(unit);
			return damage >= minDamage && damage <= maxDamage;
		});
	}

	/**
	 * Get units by price range
	 */
	static getUnitsByPriceRange(minPrice: number, maxPrice: number): Array<Unit & { name: string }> {
		return this.getAllUnits().filter(
			(unit) => unit.configuration.PlacementPrice >= minPrice && unit.configuration.PlacementPrice <= maxPrice,
		);
	}

	/**
	 * Get the most expensive units to place
	 */
	static getMostExpensiveUnits(limit: number = 10): Array<Unit & { name: string }> {
		const units = this.getAllUnits();
		table.sort(units, (a, b) => a.configuration.PlacementPrice > b.configuration.PlacementPrice);
		const result: Array<Unit & { name: string }> = [];
		for (let i = 0; i < math.min(limit, units.size()); i++) {
			result.push(units[i]);
		}
		return result;
	}

	/**
	 * Get the highest damage units
	 */
	static getHighestDamageUnits(limit: number = 10): Array<Unit & { name: string }> {
		const units = this.getAllUnits();
		table.sort(units, (a, b) => getUnitDamage(a) > getUnitDamage(b));
		const result: Array<Unit & { name: string }> = [];
		for (let i = 0; i < math.min(limit, units.size()); i++) {
			result.push(units[i]);
		}
		return result;
	}

	/**
	 * Get the longest range units
	 */
	static getLongestRangeUnits(limit: number = 10): Array<Unit & { name: string }> {
		const units = this.getAllUnits();
		table.sort(units, (a, b) => getUnitRange(a) > getUnitRange(b));
		const result: Array<Unit & { name: string }> = [];
		for (let i = 0; i < math.min(limit, units.size()); i++) {
			result.push(units[i]);
		}
		return result;
	}

	/**
	 * Get the fastest attack speed units
	 */
	static getFastestUnits(limit: number = 10): Array<Unit & { name: string }> {
		const units = this.getAllUnits();
		table.sort(units, (a, b) => getUnitAttackSpeed(a) < getUnitAttackSpeed(b)); // Lower is faster
		const result: Array<Unit & { name: string }> = [];
		for (let i = 0; i < math.min(limit, units.size()); i++) {
			result.push(units[i]);
		}
		return result;
	}

	/**
	 * Get unit by exact name
	 */
	static getUnit(name: string): Unit | undefined {
		return unitsData[name];
	}

	/**
	 * Search units by partial name match
	 */
	static searchUnitsByName(searchTerm: string): Array<Unit & { name: string }> {
		const lowerSearchTerm = string.lower(searchTerm);
		return this.getAllUnits().filter(
			(unit) =>
				string.find(string.lower(unit.name), lowerSearchTerm, 1, true)[0] !== undefined ||
				(unit.configuration.DisplayName !== undefined &&
					string.find(string.lower(unit.configuration.DisplayName), lowerSearchTerm, 1, true)[0] !==
						undefined),
		);
	}

	/**
	 * Get unit statistics
	 */
	static getUnitStats() {
		const allUnits = this.getAllUnits();
		const releasedUnits = allUnits.filter((u) => u.Released);
		const summonableUnits = allUnits.filter((u) => u.Summonable);

		const rarityCount: Record<UnitRarity, number> = {} as Record<UnitRarity, number>;
		const elementCount: Record<UnitElement, number> = {} as Record<UnitElement, number>;
		const typeCount: Record<UnitType, number> = {} as Record<UnitType, number>;

		for (const unit of allUnits) {
			// Count rarities
			const rarity = unit.configuration.Rarity;
			rarityCount[rarity] = (rarityCount[rarity] !== undefined ? rarityCount[rarity] : 0) + 1;

			// Count elements
			const element = unit.configuration.Element;
			elementCount[element] = (elementCount[element] !== undefined ? elementCount[element] : 0) + 1;

			// Count types
			const unitType = unit.configuration.UnitType;
			typeCount[unitType] = (typeCount[unitType] !== undefined ? typeCount[unitType] : 0) + 1;
		}

		// Calculate averages
		let totalDamage = 0;
		let totalPrice = 0;
		let totalRange = 0;
		for (const unit of allUnits) {
			totalDamage += getUnitDamage(unit);
			totalPrice += unit.configuration.PlacementPrice;
			totalRange += getUnitRange(unit);
		}

		return {
			total: allUnits.size(),
			released: releasedUnits.size(),
			summonable: summonableUnits.size(),
			unreleased: allUnits.size() - releasedUnits.size(),
			nonSummonable: allUnits.size() - summonableUnits.size(),
			rarityDistribution: rarityCount,
			elementDistribution: elementCount,
			typeDistribution: typeCount,
			averageDamage: totalDamage / allUnits.size(),
			averagePrice: totalPrice / allUnits.size(),
			averageRange: totalRange / allUnits.size(),
		};
	}

	/**
	 * Get damage per cost efficiency ranking
	 */
	static getDamagePerCostRanking(limit: number = 20): Array<Unit & { name: string; efficiency: number }> {
		const units = this.getAllUnits().map((unit) => ({
			...unit,
			efficiency: getUnitDamage(unit) / unit.configuration.PlacementPrice,
		}));
		table.sort(units, (a, b) => a.efficiency > b.efficiency);
		const result: Array<Unit & { name: string; efficiency: number }> = [];
		for (let i = 0; i < math.min(limit, units.size()); i++) {
			result.push(units[i]);
		}
		return result;
	}

	/**
	 * Get units with special abilities
	 */
	static getUnitsWithSpecialAbilities(): Array<Unit & { name: string }> {
		return this.getAllUnits().filter(
			(unit) => unit.configuration.SpecialAbility !== undefined && unit.configuration.SpecialAbility !== "",
		);
	}

	/**
	 * Get units with abilities
	 */
	static getUnitsWithAbilities(): Array<Unit & { name: string }> {
		return this.getAllUnits().filter(
			(unit) => unit.configuration.Ability !== undefined && unit.configuration.Ability !== "",
		);
	}

	/**
	 * Get all unique passives
	 */
	static getAllPassives(): string[] {
		const passives = new Set<string>();
		for (const unit of this.getAllUnits()) {
			if (unit.configuration.Passives) {
				unit.configuration.Passives.forEach((passive) => passives.add(passive));
			}
		}
		const result: string[] = [];
		for (const passive of passives) {
			result.push(passive);
		}
		table.sort(result);
		return result;
	}

	/**
	 * Get all unique abilities
	 */
	static getAllAbilities(): string[] {
		const abilities = new Set<string>();
		for (const unit of this.getAllUnits()) {
			if (unit.configuration.Ability !== undefined && unit.configuration.Ability !== "") {
				abilities.add(unit.configuration.Ability);
			}
			if (unit.configuration.SpecialAbility !== undefined && unit.configuration.SpecialAbility !== "") {
				abilities.add(unit.configuration.SpecialAbility);
			}
		}
		const result: string[] = [];
		for (const ability of abilities) {
			result.push(ability);
		}
		table.sort(result);
		return result;
	}

	/**
	 * Get all unique map affinities
	 */
	static getAllMapAffinities(): string[] {
		const maps = new Set<string>();
		for (const unit of this.getAllUnits()) {
			if (unit.configuration.MapAffnity !== undefined && unit.configuration.MapAffnity !== "") {
				maps.add(unit.configuration.MapAffnity);
			}
		}
		const result: string[] = [];
		for (const map of maps) {
			result.push(map);
		}
		table.sort(result);
		return result;
	}

	/**
	 * Check if a unit can evolve
	 */
	static canUnitEvolve(unitName: string): boolean {
		const unit = this.getUnit(unitName);
		return !!(unit?.configuration.EvolveData && unit.configuration.EvolveData.size() > 0);
	}

	/**
	 * Get evolution requirements for a unit
	 */
	static getEvolutionRequirements(unitName: string): EvolveRequirements | undefined {
		const unit = this.getUnit(unitName);
		if (!unit?.configuration.EvolveData?.[0]) {
			return undefined;
		}
		return unit.configuration.EvolveData[0].Requirements;
	}

	/**
	 * Get total upgrade cost for a unit
	 */
	static getTotalUpgradeCost(unitName: string): number {
		const unit = this.getUnit(unitName);
		if (!unit?.configuration.UpgradesInfo) {
			return 0;
		}
		return unit.configuration.UpgradesInfo.reduce((total, upgrade) => total + upgrade.UpgradePrice, 0);
	}

	/**
	 * Get units by multiple filters
	 */
	static getFilteredUnits(filters: {
		rarity?: UnitRarity[];
		element?: UnitElement[];
		unitType?: UnitType[];
		minDamage?: number;
		maxDamage?: number;
		minPrice?: number;
		maxPrice?: number;
		released?: boolean;
		summonable?: boolean;
		hasEvolution?: boolean;
		hasPassives?: boolean;
		gameTypeAffinity?: GameType[];
	}): Array<Unit & { name: string }> {
		return this.getAllUnits().filter((unit) => {
			if (filters.rarity && !filters.rarity.includes(unit.configuration.Rarity)) return false;
			if (filters.element && !filters.element.includes(unit.configuration.Element)) return false;
			if (filters.unitType && !filters.unitType.includes(unit.configuration.UnitType)) return false;
			if (filters.minDamage !== undefined && getUnitDamage(unit) < filters.minDamage) return false;
			if (filters.maxDamage !== undefined && getUnitDamage(unit) > filters.maxDamage) return false;
			if (filters.minPrice !== undefined && unit.configuration.PlacementPrice < filters.minPrice) return false;
			if (filters.maxPrice !== undefined && unit.configuration.PlacementPrice > filters.maxPrice) return false;
			if (filters.released !== undefined && unit.Released !== filters.released) return false;
			if (filters.summonable !== undefined && unit.Summonable !== filters.summonable) return false;
			if (filters.hasEvolution && !(unit.configuration.EvolveData && unit.configuration.EvolveData.size() > 0))
				return false;
			if (filters.hasPassives && !(unit.configuration.Passives && unit.configuration.Passives.size() > 0))
				return false;
			if (
				filters.gameTypeAffinity &&
				!filters.gameTypeAffinity.some((gt) => unit.configuration.GameTypeAffinity?.includes(gt))
			)
				return false;

			return true;
		});
	}
}

// Utility functions for handling string expressions and numbers
function parseNumericValue(value: number | string): number {
	if (typeOf(value) === "number") {
		return value as number;
	}

	// Handle string expressions like "4700 / 2"
	const strValue = value as string;
	const [found] = string.find(strValue, "/");
	if (found !== undefined) {
		const parts = string.split(strValue, "/");
		if (parts.size() === 2) {
			const numeratorStr = string.gsub(parts[0], "^%s*(.-)%s*$", "%1")[0];
			const denominatorStr = string.gsub(parts[1], "^%s*(.-)%s*$", "%1")[0];
			const numerator = tonumber(numeratorStr);
			const denominator = tonumber(denominatorStr);
			if (numerator !== undefined && denominator !== undefined && denominator !== 0) {
				return numerator / denominator;
			}
		}
	}

	// Try to parse as regular number
	const parsed = tonumber(strValue);
	return parsed !== undefined ? parsed : 0;
}

function getUnitDamage(unit: Unit): number {
	return parseNumericValue(unit.configuration.Damage);
}

function getUnitRange(unit: Unit): number {
	return parseNumericValue(unit.configuration.Range);
}

function getUnitAttackSpeed(unit: Unit): number {
	return parseNumericValue(unit.configuration.AttackSpeed);
}

// Export individual utility functions for convenience
export function getAllUnits() {
	return UnitsDataUtils.getAllUnits();
}

export function getReleasedUnits() {
	return UnitsDataUtils.getReleasedUnits();
}

export function getSummonableUnits() {
	return UnitsDataUtils.getSummonableUnits();
}

export function getUnitsByRarity(rarity: UnitRarity) {
	return UnitsDataUtils.getUnitsByRarity(rarity);
}

export function getUnitsByElement(element: UnitElement) {
	return UnitsDataUtils.getUnitsByElement(element);
}

export function getUnitsByType(unitType: UnitType) {
	return UnitsDataUtils.getUnitsByType(unitType);
}

export function getUnitsByPlacementType(placementType: PlacementType) {
	return UnitsDataUtils.getUnitsByPlacementType(placementType);
}

export function getEvolvableUnits() {
	return UnitsDataUtils.getEvolvableUnits();
}

export function getEvolutionChains() {
	return UnitsDataUtils.getEvolutionChains();
}

export function getUnitsByPassive(passive: string) {
	return UnitsDataUtils.getUnitsByPassive(passive);
}

export function getUnitsByGameTypeAffinity(gameType: GameType) {
	return UnitsDataUtils.getUnitsByGameTypeAffinity(gameType);
}

export function getUnitsByDamageRange(minDamage: number, maxDamage: number) {
	return UnitsDataUtils.getUnitsByDamageRange(minDamage, maxDamage);
}

export function getUnitsByPriceRange(minPrice: number, maxPrice: number) {
	return UnitsDataUtils.getUnitsByPriceRange(minPrice, maxPrice);
}

export function getMostExpensiveUnits(limit?: number) {
	return UnitsDataUtils.getMostExpensiveUnits(limit);
}

export function getHighestDamageUnits(limit?: number) {
	return UnitsDataUtils.getHighestDamageUnits(limit);
}

export function getLongestRangeUnits(limit?: number) {
	return UnitsDataUtils.getLongestRangeUnits(limit);
}

export function getFastestUnits(limit?: number) {
	return UnitsDataUtils.getFastestUnits(limit);
}

export function getUnit(name: string) {
	return UnitsDataUtils.getUnit(name);
}

export function searchUnitsByName(searchTerm: string) {
	return UnitsDataUtils.searchUnitsByName(searchTerm);
}

export function getUnitStats() {
	return UnitsDataUtils.getUnitStats();
}

export function getDamagePerCostRanking(limit?: number) {
	return UnitsDataUtils.getDamagePerCostRanking(limit);
}

export function getUnitsWithSpecialAbilities() {
	return UnitsDataUtils.getUnitsWithSpecialAbilities();
}

export function getUnitsWithAbilities() {
	return UnitsDataUtils.getUnitsWithAbilities();
}

export function getAllPassives() {
	return UnitsDataUtils.getAllPassives();
}

export function getAllAbilities() {
	return UnitsDataUtils.getAllAbilities();
}

export function getAllMapAffinities() {
	return UnitsDataUtils.getAllMapAffinities();
}

export function canUnitEvolve(unitName: string) {
	return UnitsDataUtils.canUnitEvolve(unitName);
}

export function getEvolutionRequirements(unitName: string) {
	return UnitsDataUtils.getEvolutionRequirements(unitName);
}

export function getTotalUpgradeCost(unitName: string) {
	return UnitsDataUtils.getTotalUpgradeCost(unitName);
}

export function getFilteredUnits(filters: Parameters<typeof UnitsDataUtils.getFilteredUnits>[0]) {
	return UnitsDataUtils.getFilteredUnits(filters);
}
