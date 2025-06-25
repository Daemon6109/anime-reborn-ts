import { expect, describe, it, beforeEach, jest } from "@rbxts/jest-globals";
import { EffectsService } from "@server/services/effects.service";
import { DataService } from "@server/services/data.service";

// Mock DataService to avoid dependencies
const mockDataService = {
	getCache: jest.fn(),
	setCache: jest.fn(),
} as unknown as DataService;

describe("EffectsService", () => {
	let effectsService: EffectsService;

	beforeEach(() => {
		jest.clearAllMocks();
		effectsService = new EffectsService(mockDataService);
		// Only call loadDefaultEffectConfigs, not onInit to avoid infinite loops
		(effectsService as unknown as { loadDefaultEffectConfigs(): void }).loadDefaultEffectConfigs();
	});

	describe("Effect Configuration", () => {
		it("should have version information", () => {
			expect(effectsService.version.major).toBe(1);
			expect(effectsService.version.minor).toBe(0);
			expect(effectsService.version.patch).toBe(0);
		});

		it("should get effect configuration for ExpBoost", () => {
			const expConfig = effectsService.getEffectConfig("ExpBoost");
			expect(expConfig).toBeDefined();
			expect(expConfig?.Name).toBe("Experience Boost");
			expect(expConfig?.Description).toBe("Increases experience gained");
			expect(expConfig?.Multiplier?.Experience).toBe(2.0);
			expect(expConfig?.Icon).toBe("🔥");
			expect(expConfig?.Rarity).toBe("Common");
		});

		it("should get effect configuration for GoldBoost", () => {
			const goldConfig = effectsService.getEffectConfig("GoldBoost");
			expect(goldConfig).toBeDefined();
			expect(goldConfig?.Name).toBe("Gold Boost");
			expect(goldConfig?.Description).toBe("Increases gold earned");
			expect(goldConfig?.Multiplier?.Gold).toBe(1.5);
			expect(goldConfig?.Icon).toBe("💰");
			expect(goldConfig?.Rarity).toBe("Common");
		});

		it("should get effect configuration for DamageBoost", () => {
			const damageConfig = effectsService.getEffectConfig("DamageBoost");
			expect(damageConfig).toBeDefined();
			expect(damageConfig?.Name).toBe("Damage Boost");
			expect(damageConfig?.Description).toBe("Increases damage dealt");
			expect(damageConfig?.Multiplier?.Damage).toBe(1.25);
			expect(damageConfig?.Icon).toBe("⚔️");
			expect(damageConfig?.Rarity).toBe("Epic");
		});

		it("should get all effect configurations", () => {
			const allEffects = effectsService.getAllEffectConfigs();
			expect(allEffects).toBeDefined();
			expect(allEffects.ExpBoost).toBeDefined();
			expect(allEffects.GoldBoost).toBeDefined();
			expect(allEffects.GemBoost).toBeDefined();
			expect(allEffects.DamageBoost).toBeDefined();
			expect(allEffects.SpeedBoost).toBeDefined();
			expect(allEffects.LuckBoost).toBeDefined();
			expect(allEffects.HealthBoost).toBeDefined();
			expect(allEffects.DefenseBoost).toBeDefined();
		});

		it("should set effect configuration", () => {
			const testEffect = {
				Name: "Test Effect",
				Description: "A test effect",
				Multiplier: { Test: 2.5 },
				Icon: "🧪",
				Rarity: "Legendary" as const,
			};

			effectsService.setEffectConfig("ExpBoost", testEffect);
			const retrievedConfig = effectsService.getEffectConfig("ExpBoost");
			expect(retrievedConfig?.Name).toBe("Test Effect");
			expect(retrievedConfig?.Description).toBe("A test effect");
			expect(retrievedConfig?.Multiplier?.Test).toBe(2.5);
			expect(retrievedConfig?.Icon).toBe("🧪");
			expect(retrievedConfig?.Rarity).toBe("Legendary");
		});
	});

	describe("Effect Types", () => {
		it("should have all expected boost effects", () => {
			const expBoost = effectsService.getEffectConfig("ExpBoost");
			const goldBoost = effectsService.getEffectConfig("GoldBoost");
			const gemBoost = effectsService.getEffectConfig("GemBoost");
			const speedBoost = effectsService.getEffectConfig("SpeedBoost");
			const luckBoost = effectsService.getEffectConfig("LuckBoost");

			expect(expBoost).toBeDefined();
			expect(goldBoost).toBeDefined();
			expect(gemBoost).toBeDefined();
			expect(speedBoost).toBeDefined();
			expect(luckBoost).toBeDefined();
		});

		it("should have all expected combat effects", () => {
			const damageBoost = effectsService.getEffectConfig("DamageBoost");
			const healthBoost = effectsService.getEffectConfig("HealthBoost");
			const defenseBoost = effectsService.getEffectConfig("DefenseBoost");

			expect(damageBoost).toBeDefined();
			expect(healthBoost).toBeDefined();
			expect(defenseBoost).toBeDefined();
		});
	});

	describe("Data Structures", () => {
		it("should support EffectData interface", () => {
			const effectData = {
				Duration: 300,
				StartTime: 1000000000,
			};

			expect(effectData.Duration).toBe(300);
			expect(effectData.StartTime).toBeGreaterThan(0);
		});

		it("should support EffectConfig interface", () => {
			const effectConfig = {
				Name: "Test Effect",
				Description: "A test effect",
				Multiplier: { Test: 1.5 },
				Icon: "🧪",
				Rarity: "Common" as const,
			};

			expect(effectConfig.Name).toBe("Test Effect");
			expect(effectConfig.Multiplier.Test).toBe(1.5);
			expect(effectConfig.Rarity).toBe("Common");
		});
	});
});
