import unitsDataRaw from "./units-data.json";

// Type definitions
export type UnitRarity = "Rare" | "Epic" | "Legendary" | "Mythical" | "Secret" | "Reborn" | "Exclusive";

export type UnitElement = "Light" | "Dark" | "Wind" | "Fire" | "Water" | "Fierce" | "Ice";

export type UnitType = "Ground" | "Hybrid" | "Hill" | "Air";

export type PlacementType = "Ground" | "Hill" | "Air";

export type AttackType = "Circle" | "Single" | "Line" | "AOE" | "Multi";

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
	PermanentDamageMulti?: string;
	[key: string]: string | undefined;
}

export interface UnitConfiguration {
	// Basic properties
	DisplayName?: string;
	Damage: number;
	Range: number;
	AttackSpeed: number;
	PlacementPrice: number;
	UpgradePrice: number;
	SellCost?: number;
	MaxUpgrades: number;
	MaxPlacementAmount: number;

	// Combat properties
	AttackType: AttackType;
	AttackSize?: number;
	AttackCriticalChance?: number;
	AttackCriticalDamage?: string;
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

	// Upgrades
	UpgradesInfo?: UpgradeInfo[];

	// Misc
	CanSell?: boolean;
	Money?: number;
	PermanentDamageMulti?: string;
}

export interface Unit {
	Released: boolean;
	Summonable: boolean;
	animations: UnitAnimations;
	configuration: UnitConfiguration;
}

export type UnitsData = Record<string, Unit>;

// Cast the imported data with proper typing
export const unitsData = unitsDataRaw as unknown as UnitsData;

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
		return this.getAllUnits().filter(
			(unit) => unit.configuration.Damage >= minDamage && unit.configuration.Damage <= maxDamage,
		);
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
		table.sort(units, (a, b) => a.configuration.Damage > b.configuration.Damage);
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
		table.sort(units, (a, b) => a.configuration.Range > b.configuration.Range);
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
		table.sort(units, (a, b) => a.configuration.AttackSpeed < b.configuration.AttackSpeed); // Lower is faster
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
			const type = unit.configuration.UnitType;
			typeCount[type] = (typeCount[type] !== undefined ? typeCount[type] : 0) + 1;
		}

		// Calculate averages
		let totalDamage = 0;
		let totalPrice = 0;
		let totalRange = 0;
		for (const unit of allUnits) {
			totalDamage += unit.configuration.Damage;
			totalPrice += unit.configuration.PlacementPrice;
			totalRange += unit.configuration.Range;
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
			efficiency: unit.configuration.Damage / unit.configuration.PlacementPrice,
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
			if (filters.minDamage !== undefined && unit.configuration.Damage < filters.minDamage) return false;
			if (filters.maxDamage !== undefined && unit.configuration.Damage > filters.maxDamage) return false;
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

// Export individual utility functions for convenience
export const {
	getAllUnits,
	getReleasedUnits,
	getSummonableUnits,
	getUnitsByRarity,
	getUnitsByElement,
	getUnitsByType,
	getUnitsByPlacementType,
	getEvolvableUnits,
	getEvolutionChains,
	getUnitsByPassive,
	getUnitsByGameTypeAffinity,
	getUnitsByDamageRange,
	getUnitsByPriceRange,
	getMostExpensiveUnits,
	getHighestDamageUnits,
	getLongestRangeUnits,
	getFastestUnits,
	getUnit,
	searchUnitsByName,
	getUnitStats,
	getDamagePerCostRanking,
	getUnitsWithSpecialAbilities,
	getUnitsWithAbilities,
	getAllPassives,
	getAllAbilities,
	getAllMapAffinities,
	canUnitEvolve,
	getEvolutionRequirements,
	getTotalUpgradeCost,
	getFilteredUnits,
} = UnitsDataUtils;
