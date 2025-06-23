import { expect, describe, it, beforeEach, jest } from "@rbxts/jest-globals";
import { BattlepassService } from "server/services/battlepass.service";
import { DataService } from "server/services/data.service";

// Mock DataService
const mockDataService = {
	getCache: jest.fn(),
	setCache: jest.fn(),
} as unknown as DataService;

describe("BattlepassService", () => {
	let battlepassService: BattlepassService;

	beforeEach(() => {
		jest.clearAllMocks();
		battlepassService = new BattlepassService(mockDataService);
	});

	describe("Initialization", () => {
		it("should initialize with correct version", () => {
			expect(battlepassService.version).toEqual({ major: 1, minor: 0, patch: 0 });
		});
	});

	describe("Reward System", () => {
		it("should get rewards for tier 1", () => {
			const rewards = battlepassService.getRewardsForTier(1);
			expect(rewards).toBeDefined();
			expect(rewards?.free).toBeDefined();
			expect(rewards?.premium).toBeDefined();
		});

		it("should return undefined for invalid tier", () => {
			const rewards = battlepassService.getRewardsForTier(999);
			expect(rewards).toBeUndefined();
		});

		it("should have different free and premium rewards", () => {
			const rewards = battlepassService.getRewardsForTier(1);
			if (rewards && rewards.free && rewards.premium) {
				expect(rewards.free).toBeDefined();
				expect(rewards.premium).toBeDefined();
				// They should be different objects
				expect(rewards.free === rewards.premium).toBe(false);
			}
		});
	});

	describe("Season Management", () => {
		it("should get current season", () => {
			const currentSeason = battlepassService.getCurrentSeason();
			expect(currentSeason).toBeDefined();
			expect(typeIs(currentSeason, "string")).toBe(true);
		});
	});

	describe("Configuration", () => {
		it("should have version information", () => {
			expect(battlepassService.version.major).toBe(1);
			expect(battlepassService.version.minor).toBe(0);
			expect(battlepassService.version.patch).toBe(0);
		});

		it("should accept configuration", () => {
			const testConfig = {
				seasonName: "Test Season",
				maxTier: 50,
				xpPerTier: 500,
				premiumCost: 1000,
				rewards: {},
			};

			battlepassService.setConfig(testConfig);
			expect(battlepassService.getCurrentSeason()).toBe("Test Season");
		});
	});

	describe("Tier System", () => {
		it("should have rewards for various tiers", () => {
			const tier1 = battlepassService.getRewardsForTier(1);
			const tier10 = battlepassService.getRewardsForTier(10);

			expect(tier1).toBeDefined();
			expect(tier10).toBeDefined();
		});

		it("should handle invalid tier numbers", () => {
			const invalidTier = battlepassService.getRewardsForTier(-1);
			expect(invalidTier).toBeUndefined();
		});
	});

	describe("Reward Structure", () => {
		it("should have Gold rewards", () => {
			const rewards = battlepassService.getRewardsForTier(1);
			expect(rewards?.free?.Gold).toBeDefined();
			expect(rewards?.premium?.Gold).toBeDefined();
		});

		it("should have progressive rewards", () => {
			const tier1 = battlepassService.getRewardsForTier(1);
			const tier10 = battlepassService.getRewardsForTier(10);

			if (tier1?.free?.Gold !== undefined && tier10?.free?.Gold !== undefined) {
				expect(tier10.free.Gold).toBeGreaterThan(tier1.free.Gold);
			}
		});
	});
});
