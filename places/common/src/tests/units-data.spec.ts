import { expect, it, describe } from "@rbxts/jest-globals";
import {
	getAllUnitNames,
	getExactUnit,
	getExactAnimations,
	getExactConfiguration,
	isValidUnitName,
	hasAnimation,
	getUnitsWithWings,
	getUnitsWithAnimation,
	getUnitDamage,
	getUnitRange,
	getUnitAttackSpeed,
	getUnitPrice,
	getUnitRarity,
	getUnitElement,
	getUnitDisplayName,
	getUnitsByRarity,
	getUnitsByElement,
	getReleasedUnits,
	getSummonableUnits,
	getTradableUnits,
	searchUnitsByName,
	compareUnitStats,
	getHighestDamageUnits,
	getLowestPriceUnits,
	getAverageDamageByRarity,
	getRandomUnit,
	getRandomUnitByRarity,
	filterUnitsByProperty,
	validateUnit,
	UnitName,
	ExactUnit,
	ExactAnimations,
	ExactConfiguration,
} from "@shared/data/units-data";

describe("Units Data - Core Functions", () => {
	it("should get all unit names", () => {
		const unitNames = getAllUnitNames();
		expect(unitNames.size()).toBeGreaterThan(0);
		expect(unitNames.includes("Aira" as UnitName)).toBe(true);
	});

	it("should validate unit names correctly", () => {
		expect(isValidUnitName("Aira")).toBe(true);
		expect(isValidUnitName("NonExistentUnit")).toBe(false);
		expect(isValidUnitName("")).toBe(false);
	});

	it("should get exact unit data", () => {
		const aira = getExactUnit("Aira");
		expect(aira).toBeDefined();
		expect(typeOf(aira!.Released)).toBe("boolean");
		expect(typeOf(aira!.Summonable)).toBe("boolean");
		expect(typeOf(aira!.Radius)).toBe("number");
	});

	it("should return undefined for non-existent units", () => {
		const nonExistent = getExactUnit("NonExistentUnit" as UnitName);
		expect(nonExistent).toBeUndefined();
	});
});

describe("Units Data - Exact Typing", () => {
	it("should get exact animations for specific units", () => {
		const airaAnimations = getExactAnimations("Aira");
		expect(airaAnimations).toBeDefined();
		expect(typeOf(airaAnimations.idle)).toBe("number");
		expect(typeOf(airaAnimations.walk)).toBe("number");
		// Aira should NOT have wings
		expect((airaAnimations as unknown as Record<string, unknown>).wings).toBeUndefined();
	});

	it("should get exact animations for units with wings", () => {
		// Find a unit that has wings first
		const unitsWithWings = getUnitsWithWings();
		if (unitsWithWings.size() > 0) {
			const unitWithWings = unitsWithWings[0];
			const animations = getExactAnimations(unitWithWings);
			expect(animations).toBeDefined();
			expect(typeOf((animations as unknown as Record<string, unknown>).wings)).toBe("number");
		}
	});

	it("should get exact configuration for specific units", () => {
		const airaConfig = getExactConfiguration("Aira");
		expect(airaConfig).toBeDefined();
		expect(typeOf(airaConfig.DisplayName)).toBe("string");
		expect(typeOf(airaConfig.Damage)).toBe("number");
		expect(typeOf(airaConfig.Range)).toBe("number");
		expect(typeOf(airaConfig.Rarity)).toBe("string");
		expect(typeOf(airaConfig.Element)).toBe("string");
	});
});

describe("Units Data - Animation Utilities", () => {
	it("should check if units have specific animations", () => {
		expect(hasAnimation("Aira", "idle")).toBe(true);
		expect(hasAnimation("Aira", "walk")).toBe(true);
		expect(hasAnimation("Aira", "wings")).toBe(false);
	});

	it("should get units with wings", () => {
		const unitsWithWings = getUnitsWithWings();
		expect(unitsWithWings).toBeDefined();
		// Verify each unit actually has wings
		for (const unitName of unitsWithWings) {
			expect(hasAnimation(unitName, "wings")).toBe(true);
		}
	});

	it("should get units with specific animations", () => {
		const unitsWithIdle = getUnitsWithAnimation("idle");
		expect(unitsWithIdle.size()).toBeGreaterThan(0);
		// All units should have idle animation
		for (const unitName of unitsWithIdle) {
			expect(hasAnimation(unitName, "idle")).toBe(true);
		}
	});
});

describe("Units Data - Stat Utilities", () => {
	it("should get unit damage", () => {
		const damage = getUnitDamage("Aira");
		expect(typeOf(damage)).toBe("number");
		expect(damage).toBeGreaterThan(0);
	});

	it("should get unit range", () => {
		const range = getUnitRange("Aira");
		expect(typeOf(range)).toBe("number");
		expect(range).toBeGreaterThan(0);
	});

	it("should get unit attack speed", () => {
		const attackSpeed = getUnitAttackSpeed("Aira");
		expect(typeOf(attackSpeed)).toBe("number");
		expect(attackSpeed).toBeGreaterThan(0);
	});

	it("should get unit price", () => {
		const price = getUnitPrice("Aira");
		expect(typeOf(price)).toBe("number");
		expect(price).toBeGreaterThanOrEqual(0);
	});

	it("should get unit rarity", () => {
		const rarity = getUnitRarity("Aira");
		expect(typeOf(rarity)).toBe("string");
		expect(rarity.size()).toBeGreaterThan(0);
	});

	it("should get unit element", () => {
		const element = getUnitElement("Aira");
		expect(typeOf(element)).toBe("string");
		expect(element.size()).toBeGreaterThan(0);
	});

	it("should get unit display name", () => {
		const displayName = getUnitDisplayName("Aira");
		expect(typeOf(displayName)).toBe("string");
		expect(displayName.size()).toBeGreaterThan(0);
	});
});

describe("Units Data - Filtering Utilities", () => {
	it("should filter units by rarity", () => {
		const mythicalUnits = getUnitsByRarity("Mythical");
		expect(mythicalUnits).toBeDefined();
		// Verify all units are actually Mythical
		for (const unitName of mythicalUnits) {
			expect(getUnitRarity(unitName)).toBe("Mythical");
		}
	});

	it("should filter units by element", () => {
		const lightUnits = getUnitsByElement("Light");
		expect(lightUnits).toBeDefined();
		// Verify all units are actually Light element
		for (const unitName of lightUnits) {
			expect(getUnitElement(unitName)).toBe("Light");
		}
	});

	it("should get released units", () => {
		const releasedUnits = getReleasedUnits();
		expect(releasedUnits.size()).toBeGreaterThan(0);
		// Verify all units are actually released
		for (const unitName of releasedUnits) {
			const unit = getExactUnit(unitName);
			expect(unit!.Released).toBe(true);
		}
	});

	it("should get summonable units", () => {
		const summonableUnits = getSummonableUnits();
		expect(summonableUnits.size()).toBeGreaterThan(0);
		// Verify all units are actually summonable
		for (const unitName of summonableUnits) {
			const unit = getExactUnit(unitName);
			expect(unit!.Summonable).toBe(true);
		}
	});

	it("should get tradable units", () => {
		const tradableUnits = getTradableUnits();
		expect(tradableUnits).toBeDefined();
		// Verify all units are actually tradable
		for (const unitName of tradableUnits) {
			const unit = getExactUnit(unitName);
			expect(unit!.Tradable).toBe(true);
		}
	});
});

describe("Units Data - Search Utilities", () => {
	it("should search units by name", () => {
		const searchResults = searchUnitsByName("Aira");
		expect(searchResults.size()).toBeGreaterThan(0);
		expect(searchResults.includes("Aira" as UnitName)).toBe(true);
	});

	it("should search units case-insensitively", () => {
		const searchResults = searchUnitsByName("aira");
		expect(searchResults.size()).toBeGreaterThan(0);
		expect(searchResults.includes("Aira" as UnitName)).toBe(true);
	});

	it("should return empty results for non-existent search", () => {
		const searchResults = searchUnitsByName("ThisUnitDoesNotExist123");
		expect(searchResults.size()).toBe(0);
	});
});

describe("Units Data - Comparison Utilities", () => {
	it("should compare unit stats", () => {
		const comparison = compareUnitStats("Aira", "Aira");
		expect(comparison.unitA).toBe("Aira");
		expect(comparison.unitB).toBe("Aira");
		expect(comparison.damageA).toBe(comparison.damageB);
		expect(comparison.rangeA).toBe(comparison.rangeB);
	});
});

describe("Units Data - Statistical Utilities", () => {
	it("should get highest damage units", () => {
		const highestDamage = getHighestDamageUnits(5);
		expect(highestDamage.size()).toBeGreaterThan(0);
		expect(highestDamage.size()).toBeLessThanOrEqual(5);

		// Verify sorted by damage (descending)
		for (let i = 1; i < highestDamage.size(); i++) {
			expect(highestDamage[i - 1].damage).toBeGreaterThanOrEqual(highestDamage[i].damage);
		}
	});

	it("should get lowest price units", () => {
		const lowestPrice = getLowestPriceUnits(5);
		expect(lowestPrice.size()).toBeGreaterThan(0);
		expect(lowestPrice.size()).toBeLessThanOrEqual(5);

		// Verify sorted by price (ascending)
		for (let i = 1; i < lowestPrice.size(); i++) {
			expect(lowestPrice[i - 1].price).toBeLessThanOrEqual(lowestPrice[i].price);
		}
	});

	it("should calculate average damage by rarity", () => {
		const avgDamage = getAverageDamageByRarity("Mythical");
		expect(typeOf(avgDamage)).toBe("number");
		expect(avgDamage).toBeGreaterThanOrEqual(0);
	});

	it("should return 0 for average damage of non-existent rarity", () => {
		const avgDamage = getAverageDamageByRarity("NonExistentRarity");
		expect(avgDamage).toBe(0);
	});
});

describe("Units Data - Random Utilities", () => {
	it("should get random unit", () => {
		const randomUnit = getRandomUnit();
		expect(randomUnit).toBeDefined();
		expect(isValidUnitName(randomUnit)).toBe(true);
	});

	it("should get random unit by rarity", () => {
		const randomMythical = getRandomUnitByRarity("Mythical");
		if (randomMythical) {
			expect(getUnitRarity(randomMythical)).toBe("Mythical");
		}
	});

	it("should return undefined for random unit of non-existent rarity", () => {
		const result = getRandomUnitByRarity("NonExistentRarity");
		expect(result).toBeUndefined();
	});
});

describe("Units Data - Filter Utilities", () => {
	it("should filter units by property", () => {
		const allUnits = getAllUnitNames();
		const firstUnit = allUnits[0];
		const targetRarity = getUnitRarity(firstUnit);

		const filteredUnits = filterUnitsByProperty([firstUnit], "Rarity", targetRarity);
		expect(filteredUnits.size()).toBe(1);
		expect(filteredUnits[0]).toBe(firstUnit);
	});
});

describe("Units Data - Validation Utilities", () => {
	it("should validate valid units", () => {
		const validation = validateUnit("Aira");
		expect(validation.isValid).toBe(true);
		expect(validation.errors.size()).toBe(0);
	});

	it("should validate units with proper stats", () => {
		const allUnits = getAllUnitNames();
		let validCount = 0;

		for (const unitName of allUnits) {
			const validation = validateUnit(unitName);
			if (validation.isValid) {
				validCount++;
			}
		}

		// Most units should be valid
		expect(validCount).toBeGreaterThan(0);
	});
});

describe("Units Data - Type Safety", () => {
	it("should maintain type safety for exact types", () => {
		// This test verifies TypeScript compilation rather than runtime behavior
		const airaUnit: ExactUnit<"Aira"> = getExactUnit("Aira")!;
		const airaAnimations: ExactAnimations<"Aira"> = getExactAnimations("Aira");
		const airaConfig: ExactConfiguration<"Aira"> = getExactConfiguration("Aira");

		expect(airaUnit).toBeDefined();
		expect(airaAnimations).toBeDefined();
		expect(airaConfig).toBeDefined();
	});

	it("should maintain animation key type safety", () => {
		// This test verifies TypeScript compilation
		// UnitAnimationKeys<"Aira"> should only include keys that exist for Aira
		const airaAnimations = getExactAnimations("Aira");
		const idleKey: keyof typeof airaAnimations = "idle";
		const walkKey: keyof typeof airaAnimations = "walk";

		expect(typeOf(airaAnimations[idleKey])).toBe("number");
		expect(typeOf(airaAnimations[walkKey])).toBe("number");
	});
});
