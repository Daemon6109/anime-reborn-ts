import Battlepass from "../../server/battlepass";
import Person from "../../server/person";
import { MockPlayer } from "@rbxts/jest-roblox";

// Mock Person and Network dependencies
jest.mock("@commonserver/person", () => {
	return {
		getForPlayer: jest.fn((player: Player) => {
			return {
				Await: jest.fn(() => mockPersonInstance), // عمومی
				Unwrap: jest.fn(() => mockPersonInstance), // عمومی
			};
		}),
	};
});

jest.mock("@network/server", () => ({
	common: {
		ClaimBattlepassReward: {
			on: jest.fn(),
		},
		PurchasePremiumBattlepass: {
			on: jest.fn(),
		},
	},
}));

jest.mock("@pkgs/shingo", () => ({
	new: () => ({
		fire: jest.fn(),
		connect: jest.fn(),
	}),
}));

let rawMockBpData: any = {};
const mockPersonInstance = {
	player: {} as Player,
	dataCache: jest.fn((callback?: (data: any) => any) => {
		if (callback) {
			rawMockBpData = callback(rawMockBpData);
		}
		return rawMockBpData;
	}),
};

const createMockBattlepassData = () => ({
	BattlepassData: {
		Exp: 0,
		Level: 1,
		HasPremium: false,
		ClaimedFree: 0,
		ClaimedPremium: 0,
		BattlepassName: "TestSeason1",
	},
	Currencies: {
		Gold: 10000, // Start with enough for premium purchase test
		Gems: 10000,
	},
});

// Constants from battlepass module (if not exported, replicate them here for tests)
const XP_PER_TIER = 1000;
const MAX_TIER = 100;
const PREMIUM_COST = 1200; // Assuming this is in Gems based on implementation

describe("Battlepass", () => {
	let mockPlayer: Player;

	beforeEach(() => {
		jest.clearAllMocks();
		rawMockBpData = createMockBattlepassData();
		mockPlayer = MockPlayer();
		mockPersonInstance.player = mockPlayer; // Assign current mockPlayer

		// Manually call init if it exists, as it's usually called by a loader
		if (Battlepass.init) {
			Battlepass.init();
		}
	});

	it("should initialize", () => {
		expect(Battlepass.addBattlepassXP).toBeDefined();
	});

	describe("addBattlepassXP", () => {
		it("should add XP and update tier correctly", () => {
			Battlepass.addBattlepassXP(mockPersonInstance as any, 500);
			expect(rawMockBpData.BattlepassData.Exp).toBe(500);
			expect(rawMockBpData.BattlepassData.Level).toBe(1); // Tier 1 (0-999 XP)

			Battlepass.addBattlepassXP(mockPersonInstance as any, 600); // Total 1100 XP
			expect(rawMockBpData.BattlepassData.Exp).toBe(1100);
			expect(rawMockBpData.BattlepassData.Level).toBe(2); // Tier 2 (1000-1999 XP)

			// Check tierUnlockedEvent signal (mocked Shingo)
			expect((Battlepass.tierUnlocked as any).fire).toHaveBeenCalledWith({
				player: mockPlayer,
				tier: 2,
			});
			expect((Battlepass.xpGained as any).fire).toHaveBeenCalledTimes(2);
		});

		it("should cap tier at MAX_TIER", () => {
			Battlepass.addBattlepassXP(mockPersonInstance as any, XP_PER_TIER * (MAX_TIER + 5));
			expect(rawMockBpData.BattlepassData.Level).toBe(MAX_TIER);
		});
	});

	describe("claimBattlepassReward", () => {
		it("should not claim if tier is not unlocked", () => {
			const success = Battlepass.claimBattlepassReward(mockPersonInstance as any, 5, false);
			expect(success).toBe(false);
		});

		it("should not claim premium reward if not premium", () => {
			rawMockBpData.BattlepassData.Level = 5;
			const success = Battlepass.claimBattlepassReward(mockPersonInstance as any, 1, true); // Tier 1, premium
			expect(success).toBe(false);
		});

		it("should claim free reward successfully", () => {
			rawMockBpData.BattlepassData.Level = 1; // Unlock tier 1
			const initialGold = rawMockBpData.Currencies.Gold;

			const success = Battlepass.claimBattlepassReward(mockPersonInstance as any, 1, false);
			expect(success).toBe(true);
			expect(rawMockBpData.BattlepassData.ClaimedFree & (2 ^ (1 - 1))).not.toBe(0);

			const reward = Battlepass.getBattlepassReward(1, false);
			expect(rawMockBpData.Currencies.Gold).toBe(initialGold + (reward?.Gold || 0));
			expect((Battlepass.rewardClaimed as any).fire).toHaveBeenCalled();
		});

		it("should claim premium reward successfully if premium", () => {
			rawMockBpData.BattlepassData.Level = 1;
			rawMockBpData.BattlepassData.HasPremium = true;
			const initialGold = rawMockBpData.Currencies.Gold;

			const success = Battlepass.claimBattlepassReward(mockPersonInstance as any, 1, true);
			expect(success).toBe(true);
			expect(rawMockBpData.BattlepassData.ClaimedPremium & (2 ^ (1 - 1))).not.toBe(0);

			const reward = Battlepass.getBattlepassReward(1, true);
			expect(rawMockBpData.Currencies.Gold).toBe(initialGold + (reward?.Gold || 0));
		});

		it("should not claim if already claimed", () => {
			rawMockBpData.BattlepassData.Level = 1;
			Battlepass.claimBattlepassReward(mockPersonInstance as any, 1, false); // First claim
			const success = Battlepass.claimBattlepassReward(mockPersonInstance as any, 1, false); // Second claim
			expect(success).toBe(false);
		});
	});

	describe("purchasePremiumBattlepass", () => {
		it("should not purchase if already premium", () => {
			rawMockBpData.BattlepassData.HasPremium = true;
			const success = Battlepass.purchasePremiumBattlepass(mockPersonInstance as any);
			expect(success).toBe(false);
		});

		it("should not purchase if not enough currency (Gems)", () => {
			rawMockBpData.Currencies.Gems = PREMIUM_COST - 1;
			const success = Battlepass.purchasePremiumBattlepass(mockPersonInstance as any);
			expect(success).toBe(false);
		});

		it("should purchase premium successfully", () => {
			rawMockBpData.Currencies.Gems = PREMIUM_COST;
			const initialGems = rawMockBpData.Currencies.Gems;

			const success = Battlepass.purchasePremiumBattlepass(mockPersonInstance as any);
			expect(success).toBe(true);
			expect(rawMockBpData.BattlepassData.HasPremium).toBe(true);
			expect(rawMockBpData.Currencies.Gems).toBe(initialGems - PREMIUM_COST);
		});
	});

	describe("getBattlepassReward", () => {
		it("should return correct reward structure", () => {
			const reward = Battlepass.getBattlepassReward(1, false);
			expect(reward).toHaveProperty("Gold");

			const premiumReward = Battlepass.getBattlepassReward(2, true);
			expect(premiumReward).toHaveProperty("Gems");

			const nonExistentReward = Battlepass.getBattlepassReward(999, false);
			expect(nonExistentReward).toBeUndefined();
		});
	});

	describe("resetBattlepass", () => {
		it("should reset XP, Level, and claimed status", () => {
			rawMockBpData.BattlepassData.Exp = 1500;
			rawMockBpData.BattlepassData.Level = 2;
			rawMockBpData.BattlepassData.HasPremium = true; // Premium should be reset as per code
			rawMockBpData.BattlepassData.ClaimedFree = 1;
			rawMockBpData.BattlepassData.ClaimedPremium = 1;

			Battlepass.resetBattlepass(mockPersonInstance as any, "Season2");

			expect(rawMockBpData.BattlepassData.Exp).toBe(0);
			expect(rawMockBpData.BattlepassData.Level).toBe(1);
			expect(rawMockBpData.BattlepassData.HasPremium).toBe(false);
			expect(rawMockBpData.BattlepassData.ClaimedFree).toBe(0);
			expect(rawMockBpData.BattlepassData.ClaimedPremium).toBe(0);
			expect(rawMockBpData.BattlepassData.BattlepassName).toBe("Season2");
		});
	});

	it("should provide current tier, XP, and premium status correctly", () => {
		rawMockBpData.BattlepassData.Level = 5;
		rawMockBpData.BattlepassData.Exp = 4500;
		rawMockBpData.BattlepassData.HasPremium = true;

		expect(Battlepass.getCurrentTier(mockPersonInstance as any)).toBe(5);
		expect(Battlepass.getCurrentXP(mockPersonInstance as any)).toBe(4500);
		expect(Battlepass.hasPremium(mockPersonInstance as any)).toBe(true);
	});

	// Test network event handlers registration in start()
	it("should register network event handlers on start", () => {
		const claimRewardHandler = (Network.common.ClaimBattlepassReward.on as jest.Mock);
		const purchasePremiumHandler = (Network.common.PurchasePremiumBattlepass.on as jest.Mock);

		Battlepass.start(); // Call start to register handlers

		expect(claimRewardHandler).toHaveBeenCalled();
		expect(purchasePremiumHandler).toHaveBeenCalled();

		// Optionally, invoke the handlers to test their internal logic if not too complex
		// For example, for ClaimBattlepassReward:
		// const claimCallback = claimRewardHandler.mock.calls[0][0];
		// claimCallback(mockPlayer, { tier: 1, isPremium: false });
		// ... then assert effects of claimBattlepassReward
	});
});

export {}; // Make it a module
