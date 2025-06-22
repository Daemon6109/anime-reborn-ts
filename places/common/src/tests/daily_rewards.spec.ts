import DailyRewards from "../../server/daily_rewards";
import Person from "../../server/person";
import { MockPlayer, MockPlayersService } from "@rbxts/jest-roblox";

// Mock dependencies
jest.mock("@commonserver/person", () => {
	return {
		getForPlayer: jest.fn((player: Player) => ({
			Await: jest.fn(() => mockPersonInstance),
		})),
		personAdded: {
			connect: jest.fn(),
		},
	};
});

jest.mock("@network/server", () => ({
	common: {
		ClaimDailyReward: {
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

let rawMockDrData: any = {};
const mockPersonInstance = {
	player: {} as Player,
	dataCache: jest.fn((callback?: (data: any) => any) => {
		if (callback) {
			rawMockDrData = callback(rawMockDrData);
		}
		return rawMockDrData;
	}),
};

const createMockDailyRewardsData = () => ({
	DailyRewardsData: {
		LastClaimedDay: 0,
		CurrentStreak: 0,
		CanClaim: false,
		TotalClaimed: 0,
	},
	Currencies: {
		Gold: 0,
		Gems: 0,
	},
});

// Mock Players service
const mockPlayers = new MockPlayersService();
(game as any).GetService = jest.fn((name: string) => {
	if (name === "Players") {
		return mockPlayers;
	}
	return game.GetService(name); // Fallback for other services
});

describe("DailyRewards", () => {
	let mockPlayer: Player;
	const originalOsTime = os.time;
	let mockCurrentTime: number;

	beforeEach(() => {
		jest.clearAllMocks();
		rawMockDrData = createMockDailyRewardsData();
		mockPlayer = MockPlayer();
		mockPlayers.AddPlayer(mockPlayer); // Add player to mock service
		mockPersonInstance.player = mockPlayer;

		// Mock os.time to control current time
		mockCurrentTime = originalOsTime(); // Set a base time for tests
		(os.time as any) = jest.fn(() => mockCurrentTime);

		// Manually call init
		if (DailyRewards.init) {
			DailyRewards.init();
		}
		// Simulate personAdded for checkDailyReset
		const personAddedCallback = (Person.personAdded.connect as jest.Mock).mock.calls[0]?.[0];
		if (personAddedCallback) {
			personAddedCallback(mockPersonInstance);
		}
	});

	afterEach(() => {
		(os.time as any) = originalOsTime; // Restore original os.time
		mockPlayers.ClearAllPlayers(); // Clear players from mock service
	});

	it("should initialize", () => {
		expect(DailyRewards.claimDailyReward).toBeDefined();
	});

	describe("checkDailyReset", () => {
		it("should set CanClaim to true and increment streak for a new day", () => {
			rawMockDrData.DailyRewardsData.LastClaimedDay = math.floor(mockCurrentTime / 86400) - 1; // Yesterday
			rawMockDrData.DailyRewardsData.CurrentStreak = 1;
			DailyRewards.checkDailyReset(mockPersonInstance as any);

			expect(rawMockDrData.DailyRewardsData.CanClaim).toBe(true);
			expect(rawMockDrData.DailyRewardsData.CurrentStreak).toBe(2);
			expect((DailyRewards.newDay as any).fire).toHaveBeenCalledWith({ player: mockPlayer, day: 2 });
		});

		it("should reset streak if more than one day has passed", () => {
			rawMockDrData.DailyRewardsData.LastClaimedDay = math.floor(mockCurrentTime / 86400) - 2; // Day before yesterday
			rawMockDrData.DailyRewardsData.CurrentStreak = 5;
			DailyRewards.checkDailyReset(mockPersonInstance as any);

			expect(rawMockDrData.DailyRewardsData.CanClaim).toBe(true);
			expect(rawMockDrData.DailyRewardsData.CurrentStreak).toBe(1); // Reset to 1
		});

		it("should not change streak or CanClaim if checked on the same day it was claimed", () => {
			rawMockDrData.DailyRewardsData.LastClaimedDay = math.floor(mockCurrentTime / 86400);
			rawMockDrData.DailyRewardsData.CurrentStreak = 3;
			rawMockDrData.DailyRewardsData.CanClaim = false; // Already claimed today
			DailyRewards.checkDailyReset(mockPersonInstance as any);

			expect(rawMockDrData.DailyRewardsData.CanClaim).toBe(false);
			expect(rawMockDrData.DailyRewardsData.CurrentStreak).toBe(3);
		});

		it("should cap streak at MAX_STREAK_DAYS (7)", () => {
			rawMockDrData.DailyRewardsData.LastClaimedDay = math.floor(mockCurrentTime / 86400) - 1;
			rawMockDrData.DailyRewardsData.CurrentStreak = 7; // Already at max
			DailyRewards.checkDailyReset(mockPersonInstance as any);
			expect(rawMockDrData.DailyRewardsData.CurrentStreak).toBe(7);
		});
	});

	describe("claimDailyReward", () => {
		it("should not claim if CanClaim is false", () => {
			rawMockDrData.DailyRewardsData.CanClaim = false;
			const success = DailyRewards.claimDailyReward(mockPersonInstance as any);
			expect(success).toBe(false);
		});

		it("should claim reward successfully if CanClaim is true", () => {
			rawMockDrData.DailyRewardsData.CanClaim = true;
			rawMockDrData.DailyRewardsData.CurrentStreak = 1;
			const initialGold = rawMockDrData.Currencies.Gold;

			const success = DailyRewards.claimDailyReward(mockPersonInstance as any);
			expect(success).toBe(true);
			expect(rawMockDrData.DailyRewardsData.CanClaim).toBe(false);
			expect(rawMockDrData.DailyRewardsData.LastClaimedDay).toBe(math.floor(mockCurrentTime / 86400));
			expect(rawMockDrData.DailyRewardsData.TotalClaimed).toBe(1);

			const reward = DailyRewards.calculateDailyReward(1);
			expect(rawMockDrData.Currencies.Gold).toBe(initialGold + (reward.Coins || 0));
			expect((DailyRewards.rewardClaimed as any).fire).toHaveBeenCalled();
		});

		it("should give correct rewards for streak day 3 (includes Gems)", () => {
			rawMockDrData.DailyRewardsData.CanClaim = true;
			rawMockDrData.DailyRewardsData.CurrentStreak = 3;
			const initialGems = rawMockDrData.Currencies.Gems;

			DailyRewards.claimDailyReward(mockPersonInstance as any);
			const reward = DailyRewards.calculateDailyReward(3);
			expect(rawMockDrData.Currencies.Gems).toBe(initialGems + (reward.Gems || 0));
		});

		it("should give correct rewards for streak day 7 (includes Gems and BonusCoins)", () => {
			rawMockDrData.DailyRewardsData.CanClaim = true;
			rawMockDrData.DailyRewardsData.CurrentStreak = 7;
			const initialGems = rawMockDrData.Currencies.Gems;
			const initialGold = rawMockDrData.Currencies.Gold;

			DailyRewards.claimDailyReward(mockPersonInstance as any);
			const reward = DailyRewards.calculateDailyReward(7);
			expect(rawMockDrData.Currencies.Gems).toBe(initialGems + (reward.Gems || 0));
			expect(rawMockDrData.Currencies.Gold).toBe(initialGold + (reward.Coins || 0) + (reward.BonusCoins || 0));
		});
	});

	describe("calculateDailyReward", () => {
		it("should calculate increasing coin rewards based on streak", () => {
			const rewardDay1 = DailyRewards.calculateDailyReward(1);
			const rewardDay2 = DailyRewards.calculateDailyReward(2);
			expect(rewardDay2.Coins).toBeGreaterThan(rewardDay1.Coins);
		});
	});

	describe("getDailyStatus", () => {
		it("should return correct status", () => {
			rawMockDrData.DailyRewardsData.CurrentStreak = 4;
			rawMockDrData.DailyRewardsData.CanClaim = true;
			rawMockDrData.DailyRewardsData.TotalClaimed = 10;

			const status = DailyRewards.getDailyStatus(mockPersonInstance as any);
			expect(status.currentDay).toBe(4);
			expect(status.canClaim).toBe(true);
			expect(status.totalClaimed).toBe(10);
		});
	});

	it("should register network event and periodic checks on start", () => {
		const claimHandler = Network.common.ClaimDailyReward.on as jest.Mock;
		DailyRewards.start();
		expect(claimHandler).toHaveBeenCalled();
		// Testing the task.spawn loop is more complex and might require specific async test utilities
	});

	it("should handle personAdded connection in init", () => {
		// This is implicitly tested by beforeEach calling init and then the callback
		expect(Person.personAdded.connect as jest.Mock).toHaveBeenCalled();
	});
});

// Cleanup tasks if any were started by the module
const tasks = getreg().filter((val: any) => typeIs(val, "thread") && coroutine.status(val) !== "dead");
tasks.forEach((thr: thread) => task.cancel(thr));

export {}; // Make it a module
