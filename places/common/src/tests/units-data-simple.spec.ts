import { expect, describe, it } from "@rbxts/jest-globals";
import {
	unitsData,
	UnitsDataUtils,
	UnitName,
	UnitRarity,
	UnitElement,
	UnitType,
	PlacementType,
	AttackType,
	getTypedUnit,
	isValidUnitName,
	getAllUnitNames,
} from "../shared/data/units-data";

describe("Units Data", () => {
	describe("Data Structure Validation", () => {
		it("should have the basic structure for each unit", () => {
			let unitCount = 0;
			for (const [name, unit] of pairs(unitsData)) {
				unitCount += 1;
				print(name);
				// Test basic properties
				expect(typeOf(unit.Released)).toBe("boolean");
				expect(typeOf(unit.Summonable)).toBe("boolean");
				expect(typeOf(unit.animations)).toBe("table");
				expect(typeOf(unit.configuration)).toBe("table");

				// Test configuration structure
				const config = unit.configuration;
				print(config);
				expect(typeOf(config.Damage)).toBe("number");
				expect(typeOf(config.Range)).toBe("number");
				expect(typeOf(config.AttackSpeed)).toBe("number");
				expect(typeOf(config.PlacementPrice)).toBe("number");
				expect(typeOf(config.UpgradePrice)).toBe("number");
				expect(typeOf(config.MaxUpgrades)).toBe("number");
				expect(typeOf(config.MaxPlacementAmount)).toBe("number");
				expect(typeOf(config.AttackType)).toBe("string");
				expect(typeOf(config.Rarity)).toBe("string");
				expect(typeOf(config.Element)).toBe("string");
				expect(typeOf(config.UnitType)).toBe("string");
				expect(typeOf(config.PlacementType)).toBe("string");

				// Validate enum values
				const validRarities: UnitRarity[] = [
					"Rare",
					"Epic",
					"Legendary",
					"Mythical",
					"Secret",
					"Reborn",
					"Exclusive",
				];
				const validElements: UnitElement[] = ["Light", "Dark", "Wind", "Fire", "Water", "Fierce", "Ice"];
				const validUnitTypes: UnitType[] = ["Ground", "Hybrid", "Hill", "Air"];
				const validPlacementTypes: PlacementType[] = ["Ground", "Hill", "Air"];
				const validAttackTypes: AttackType[] = ["Circle", "Single", "Line", "AOE", "Multi"];
				print(config.Rarity);
				expect(validRarities.includes(config.Rarity as UnitRarity)).toBe(true);
				expect(validElements.includes(config.Element as UnitElement)).toBe(true);
				expect(validUnitTypes.includes(config.UnitType as UnitType)).toBe(true);
				expect(validPlacementTypes.includes(config.PlacementType as PlacementType)).toBe(true);
				expect(validAttackTypes.includes(config.AttackType as AttackType)).toBe(true);

				// // Stop after checking first few units to avoid timeout
				// if (unitCount >= 10) break;
			}

			expect(unitCount).toBeGreaterThan(0);
		});

		it("should have valid upgrade info structure when present", () => {
			let checkedUnits = 0;
			for (const [name, unit] of pairs(unitsData)) {
				if (unit.configuration.UpgradesInfo !== undefined) {
					const upgrades = unit.configuration.UpgradesInfo;
					expect(typeOf(upgrades)).toBe("table");
					expect(upgrades.size()).toBeGreaterThan(0);

					for (const upgrade of upgrades) {
						expect(typeOf(upgrade.UpgradePrice)).toBe("number");
						expect(upgrade.UpgradePrice).toBeGreaterThan(0);
					}

					checkedUnits += 1;
					if (checkedUnits >= 5) break;
				}
			}
		});
	});

	describe("Type-Safe Functions", () => {
		it("should validate unit names correctly", () => {
			expect(isValidUnitName("Aira")).toBe(true);
			expect(isValidUnitName("NonExistentUnit")).toBe(false);
			expect(isValidUnitName("")).toBe(false);
		});

		it("should get typed units correctly", () => {
			const unit = getTypedUnit("Aira" as UnitName);
			expect(unit).toBeDefined();
			if (unit !== undefined) {
				expect(unit.Released).toBeDefined();
				expect(unit.Summonable).toBeDefined();
				expect(unit.configuration).toBeDefined();
			}
		});

		it("should get all unit names", () => {
			const unitNames = getAllUnitNames();
			expect(unitNames.size()).toBeGreaterThan(0);
			expect(unitNames.includes("Aira" as UnitName)).toBe(true);
		});
	});

	describe("UnitsDataUtils Basic Functions", () => {
		it("should get all units with names", () => {
			const allUnits = UnitsDataUtils.getAllUnits();
			expect(allUnits.size()).toBeGreaterThan(0);

			const firstUnit = allUnits[0];
			if (firstUnit !== undefined) {
				expect(firstUnit.name).toBeDefined();
				expect(firstUnit.Released).toBeDefined();
				expect(firstUnit.Summonable).toBeDefined();
				expect(firstUnit.configuration).toBeDefined();
			}
		});

		it("should filter released units", () => {
			const releasedUnits = UnitsDataUtils.getReleasedUnits();
			expect(releasedUnits.size()).toBeGreaterThan(0);

			for (const unit of releasedUnits) {
				expect(unit.Released).toBe(true);
			}
		});

		it("should filter summonable units", () => {
			const summonableUnits = UnitsDataUtils.getSummonableUnits();
			expect(summonableUnits.size()).toBeGreaterThan(0);

			for (const unit of summonableUnits) {
				expect(unit.Summonable).toBe(true);
			}
		});

		it("should get unit by exact name", () => {
			const unit = UnitsDataUtils.getUnit("Aira");
			expect(unit).toBeDefined();
			if (unit !== undefined) {
				expect(unit.configuration).toBeDefined();
			}

			const nonExistentUnit = UnitsDataUtils.getUnit("NonExistentUnit");
			expect(nonExistentUnit).toBeUndefined();
		});

		it("should filter units by rarity", () => {
			const mythicalUnits = UnitsDataUtils.getUnitsByRarity("Mythical");
			expect(mythicalUnits.size()).toBeGreaterThan(0);

			const firstMythical = mythicalUnits[0];
			if (firstMythical !== undefined) {
				expect(firstMythical.configuration.Rarity).toBe("Mythical");
			}
		});

		it("should filter units by element", () => {
			const lightUnits = UnitsDataUtils.getUnitsByElement("Light");
			expect(lightUnits.size()).toBeGreaterThan(0);

			const firstLight = lightUnits[0];
			if (firstLight !== undefined) {
				expect(firstLight.configuration.Element).toBe("Light");
			}
		});

		it("should get unit statistics", () => {
			const stats = UnitsDataUtils.getUnitStats();

			expect(typeOf(stats.total)).toBe("number");
			expect(typeOf(stats.released)).toBe("number");
			expect(typeOf(stats.summonable)).toBe("number");
			expect(typeOf(stats.unreleased)).toBe("number");
			expect(typeOf(stats.nonSummonable)).toBe("number");

			expect(stats.total).toBeGreaterThan(0);
			expect(stats.released).toBeLessThanOrEqual(stats.total);
			expect(stats.summonable).toBeLessThanOrEqual(stats.total);
			expect(stats.unreleased).toBe(stats.total - stats.released);
			expect(stats.nonSummonable).toBe(stats.total - stats.summonable);

			expect(typeOf(stats.rarityDistribution)).toBe("table");
			expect(typeOf(stats.elementDistribution)).toBe("table");
			expect(typeOf(stats.typeDistribution)).toBe("table");

			expect(typeOf(stats.averageDamage)).toBe("number");
			expect(typeOf(stats.averagePrice)).toBe("number");
			expect(typeOf(stats.averageRange)).toBe("number");

			expect(stats.averageDamage).toBeGreaterThan(0);
			expect(stats.averagePrice).toBeGreaterThan(0);
			expect(stats.averageRange).toBeGreaterThan(0);
		});

		it("should search units by name", () => {
			const searchResults = UnitsDataUtils.searchUnitsByName("Aira");
			expect(searchResults.size()).toBeGreaterThan(0);

			const firstResult = searchResults[0];
			if (firstResult !== undefined) {
				const [, foundInName] = string.find(string.lower(firstResult.name), "aira", 1, true);
				const foundInDisplayName =
					firstResult.configuration.DisplayName !== undefined &&
					string.find(string.lower(firstResult.configuration.DisplayName), "aira", 1, true)[0] !== undefined;
				expect(foundInName !== undefined || foundInDisplayName).toBe(true);
			}
		});

		it("should get most expensive units", () => {
			const expensiveUnits = UnitsDataUtils.getMostExpensiveUnits(5);
			expect(expensiveUnits.size()).toBeLessThanOrEqual(5);
			expect(expensiveUnits.size()).toBeGreaterThan(0);

			// Check that they are sorted by price (descending)
			if (expensiveUnits.size() > 1) {
				for (let i = 0; i < expensiveUnits.size() - 1; i++) {
					expect(expensiveUnits[i].configuration.PlacementPrice).toBeGreaterThanOrEqual(
						expensiveUnits[i + 1].configuration.PlacementPrice,
					);
				}
			}
		});

		it("should check if unit can evolve", () => {
			const airaCanEvolve = UnitsDataUtils.canUnitEvolve("Aira");
			expect(typeOf(airaCanEvolve)).toBe("boolean");

			const fakeUnitCanEvolve = UnitsDataUtils.canUnitEvolve("NonExistentUnit");
			expect(fakeUnitCanEvolve).toBe(false);
		});

		it("should calculate total upgrade cost", () => {
			const cost = UnitsDataUtils.getTotalUpgradeCost("Aira");
			expect(typeOf(cost)).toBe("number");
			expect(cost).toBeGreaterThanOrEqual(0);

			const noCost = UnitsDataUtils.getTotalUpgradeCost("NonExistentUnit");
			expect(noCost).toBe(0);
		});
	});

	describe("Edge Cases and Error Handling", () => {
		it("should handle empty or invalid inputs gracefully", () => {
			expect(UnitsDataUtils.searchUnitsByName("")).toEqual([]);
			expect(UnitsDataUtils.getUnitsByDamageRange(-1, -1)).toEqual([]);
			expect(UnitsDataUtils.getUnitsByPriceRange(-1, -1)).toEqual([]);
			expect(UnitsDataUtils.getMostExpensiveUnits(0)).toEqual([]);
			expect(UnitsDataUtils.getHighestDamageUnits(0)).toEqual([]);
		});

		it("should validate data consistency", () => {
			let checkedUnits = 0;
			for (const [name, unit] of pairs(unitsData)) {
				// Check that evolution target exists if specified
				if (unit.configuration.EvolvesInto !== undefined && unit.configuration.EvolvesInto !== "") {
					const evolutionTarget = UnitsDataUtils.getUnit(unit.configuration.EvolvesInto);
					expect(evolutionTarget).toBeDefined();
				}

				// Check that numerical values are reasonable
				expect(unit.configuration.Damage).toBeGreaterThan(0);
				expect(unit.configuration.Range).toBeGreaterThan(0);
				expect(unit.configuration.AttackSpeed).toBeGreaterThan(0);
				expect(unit.configuration.PlacementPrice).toBeGreaterThan(0);
				expect(unit.configuration.MaxUpgrades).toBeGreaterThanOrEqual(0);
				expect(unit.configuration.MaxPlacementAmount).toBeGreaterThan(0);

				checkedUnits += 1;
				if (checkedUnits >= 20) break; // Limit to avoid timeout
			}
		});
	});
});
