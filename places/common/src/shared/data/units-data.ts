import unitsDataRaw from "./units-data.json";

// Type definitions
export type UnitRarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythical" | "Secret" | "Exclusive";

export type UnitElement =
	| "Light"
	| "Dark"
	| "Wind"
	| "Fire"
	| "Water"
	| "Earth"
	| "Fierce"
	| "Nature"
	| "Electric"
	| "Ice";

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
			(unit) => unit.configuration.EvolveData && unit.configuration.EvolveData.length > 0,
		);
	}

	/**
	 * Get evolution chains (base unit -> evolved forms)
	 */
	static getEvolutionChains(): Record<string, string[]> {
		const chains: Record<string, string[]> = {};

		for (const [name, unit] of Object.entries(unitsData)) {
			if (unit.configuration.EvolvesInto) {
				const baseName = name.replace(/\s*\[.*?\]$/, ""); // Remove [Evo] suffix
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
		return this.getAllUnits()
			.sort((a, b) => b.configuration.PlacementPrice - a.configuration.PlacementPrice)
			.slice(0, limit);
	}

	/**
	 * Get the highest damage units
	 */
	static getHighestDamageUnits(limit: number = 10): Array<Unit & { name: string }> {
		return this.getAllUnits()
			.sort((a, b) => b.configuration.Damage - a.configuration.Damage)
			.slice(0, limit);
	}

	/**
	 * Get the longest range units
	 */
	static getLongestRangeUnits(limit: number = 10): Array<Unit & { name: string }> {
		return this.getAllUnits()
			.sort((a, b) => b.configuration.Range - a.configuration.Range)
			.slice(0, limit);
	}

	/**
	 * Get the fastest attack speed units
	 */
	static getFastestUnits(limit: number = 10): Array<Unit & { name: string }> {
		return this.getAllUnits()
			.sort((a, b) => a.configuration.AttackSpeed - b.configuration.AttackSpeed) // Lower is faster
			.slice(0, limit);
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
		const lowerSearchTerm = searchTerm.toLowerCase();
		return this.getAllUnits().filter(
			(unit) =>
				unit.name.toLowerCase().includes(lowerSearchTerm) ||
				unit.configuration.DisplayName?.toLowerCase().includes(lowerSearchTerm),
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
			rarityCount[rarity] = (rarityCount[rarity] || 0) + 1;

			// Count elements
			const element = unit.configuration.Element;
			elementCount[element] = (elementCount[element] || 0) + 1;

			// Count types
			const type = unit.configuration.UnitType;
			typeCount[type] = (typeCount[type] || 0) + 1;
		}

		return {
			total: allUnits.length,
			released: releasedUnits.length,
			summonable: summonableUnits.length,
			unreleased: allUnits.length - releasedUnits.length,
			nonSummonable: allUnits.length - summonableUnits.length,
			rarityDistribution: rarityCount,
			elementDistribution: elementCount,
			typeDistribution: typeCount,
			averageDamage: allUnits.reduce((sum, u) => sum + u.configuration.Damage, 0) / allUnits.length,
			averagePrice: allUnits.reduce((sum, u) => sum + u.configuration.PlacementPrice, 0) / allUnits.length,
			averageRange: allUnits.reduce((sum, u) => sum + u.configuration.Range, 0) / allUnits.length,
		};
	}

	/**
	 * Get damage per cost efficiency ranking
	 */
	static getDamagePerCostRanking(limit: number = 20): Array<Unit & { name: string; efficiency: number }> {
		return this.getAllUnits()
			.map((unit) => ({
				...unit,
				efficiency: unit.configuration.Damage / unit.configuration.PlacementPrice,
			}))
			.sort((a, b) => b.efficiency - a.efficiency)
			.slice(0, limit);
	}

	/**
	 * Get units with special abilities
	 */
	static getUnitsWithSpecialAbilities(): Array<Unit & { name: string }> {
		return this.getAllUnits().filter(
			(unit) => unit.configuration.SpecialAbility && unit.configuration.SpecialAbility.length > 0,
		);
	}

	/**
	 * Get units with abilities
	 */
	static getUnitsWithAbilities(): Array<Unit & { name: string }> {
		return this.getAllUnits().filter((unit) => unit.configuration.Ability && unit.configuration.Ability.length > 0);
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
		return Array.from(passives).sort();
	}

	/**
	 * Get all unique abilities
	 */
	static getAllAbilities(): string[] {
		const abilities = new Set<string>();
		for (const unit of this.getAllUnits()) {
			if (unit.configuration.Ability && unit.configuration.Ability.length > 0) {
				abilities.add(unit.configuration.Ability);
			}
			if (unit.configuration.SpecialAbility && unit.configuration.SpecialAbility.length > 0) {
				abilities.add(unit.configuration.SpecialAbility);
			}
		}
		return Array.from(abilities).sort();
	}

	/**
	 * Get all unique map affinities
	 */
	static getAllMapAffinities(): string[] {
		const maps = new Set<string>();
		for (const unit of this.getAllUnits()) {
			if (unit.configuration.MapAffnity && unit.configuration.MapAffnity.length > 0) {
				maps.add(unit.configuration.MapAffnity);
			}
		}
		return Array.from(maps).sort();
	}

	/**
	 * Check if a unit can evolve
	 */
	static canUnitEvolve(unitName: string): boolean {
		const unit = this.getUnit(unitName);
		return !!(unit?.configuration.EvolveData && unit.configuration.EvolveData.length > 0);
	}

	/**
	 * Get evolution requirements for a unit
	 */
	static getEvolutionRequirements(unitName: string): EvolveRequirements | null {
		const unit = this.getUnit(unitName);
		if (!unit?.configuration.EvolveData?.[0]) {
			return null;
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
			if (filters.minDamage && unit.configuration.Damage < filters.minDamage) return false;
			if (filters.maxDamage && unit.configuration.Damage > filters.maxDamage) return false;
			if (filters.minPrice && unit.configuration.PlacementPrice < filters.minPrice) return false;
			if (filters.maxPrice && unit.configuration.PlacementPrice > filters.maxPrice) return false;
			if (filters.released !== undefined && unit.Released !== filters.released) return false;
			if (filters.summonable !== undefined && unit.Summonable !== filters.summonable) return false;
			if (filters.hasEvolution && !(unit.configuration.EvolveData && unit.configuration.EvolveData.length > 0))
				return false;
			if (filters.hasPassives && !(unit.configuration.Passives && unit.configuration.Passives.length > 0))
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
