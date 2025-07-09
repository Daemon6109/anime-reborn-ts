import { describe, it, expect } from "@rbxts/jest-globals";
import { GameMath, GAME_CONFIG } from "../shared/utils/tower-defense.utils";

describe("Tower Defense System", () => {
	it("should have proper component types", () => {
		// Test that our component interfaces are properly typed
		expect(true).toBe(true); // Placeholder test
	});

	it("should calculate damage correctly", () => {
		// Test damage calculation with armor
		const baseDamage = 100;
		const armor = 10;
		const expectedDamage = 100 * (1 - 10 / (10 + 100)); // ~90.9

		const actualDamage = GameMath.calculateDamage(baseDamage, armor);
		expect(actualDamage).toBeCloseTo(90.9, 1);
	});

	it("should calculate distance correctly", () => {
		const a = new Vector3(0, 0, 0);
		const b = new Vector3(3, 4, 0);
		const distance = GameMath.distance(a, b);

		expect(distance).toBe(5); // 3-4-5 triangle
	});

	it("should generate valid spawn positions", () => {
		const spawnPos = GameMath.getRandomSpawnPosition();

		// Should be at the edge of the map (50 units from center)
		const distanceFromCenter = spawnPos.Magnitude;
		expect(distanceFromCenter).toBeGreaterThanOrEqual(50);
	});
});

describe("Tower Defense Configuration", () => {
	it("should have valid tower configurations", () => {
		// Check that all tower types have valid configs
		expect(GAME_CONFIG.towers.Archer).toBeDefined();
		expect(GAME_CONFIG.towers.Mage).toBeDefined();
		expect(GAME_CONFIG.towers.Cannon).toBeDefined();
		expect(GAME_CONFIG.towers.Support).toBeDefined();

		// Check that archer has reasonable stats
		expect(GAME_CONFIG.towers.Archer.cost).toBeGreaterThan(0);
		expect(GAME_CONFIG.towers.Archer.damage).toBeGreaterThan(0);
		expect(GAME_CONFIG.towers.Archer.range).toBeGreaterThan(0);
	});

	it("should have valid enemy configurations", () => {
		// Check that all enemy types have valid configs
		expect(GAME_CONFIG.enemies.Goblin).toBeDefined();
		expect(GAME_CONFIG.enemies.Orc).toBeDefined();
		expect(GAME_CONFIG.enemies.Troll).toBeDefined();
		expect(GAME_CONFIG.enemies.Boss).toBeDefined();

		// Check that goblin has reasonable stats
		expect(GAME_CONFIG.enemies.Goblin.health).toBeGreaterThan(0);
		expect(GAME_CONFIG.enemies.Goblin.speed).toBeGreaterThan(0);
		expect(GAME_CONFIG.enemies.Goblin.reward).toBeGreaterThan(0);
	});

	it("should have valid wave configurations", () => {
		// Check that we have waves
		expect(GAME_CONFIG.waves.size()).toBeGreaterThan(0);

		// Check first wave
		const firstWave = GAME_CONFIG.waves[0];
		expect(firstWave.wave).toBe(1);
		expect(firstWave.enemies.size()).toBeGreaterThan(0);
		expect(firstWave.delay).toBeGreaterThanOrEqual(0);
	});
});
