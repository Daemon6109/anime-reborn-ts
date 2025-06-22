import AdventCalendar from "../../server/advent_calendar";
import Person from "../../server/person";
import { MockPlayer } from "@rbxts/jest-roblox";

// Mock Person and Network dependencies
jest.mock("@commonserver/person", () => {
	return {
		getForPlayer: jest.fn((player: Player) => {
			return {
				Await: jest.fn(() => ({
					player: player,
					dataCache: jest.fn((callback?: (data: any) => any) => {
						if (!rawMockData[player.UserId]) {
							rawMockData[player.UserId] = createMockData();
						}
						if (callback) {
							rawMockData[player.UserId] = callback(rawMockData[player.UserId]);
						}
						return rawMockData[player.UserId];
					}),
				})),
			};
		}),
		personAdded: {
			connect: jest.fn(),
		},
	};
});

jest.mock("@network/server", () => ({
	common: {
		ClaimAdventReward: {
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

let rawMockData: { [key: number]: any } = {};

const createMockData = () => ({
	AdventCalendarData: {
		Claimed: [],
		OnlineDays: 0,
		DayNumber: 0,
	},
	Currencies: {
		Gold: 0,
		Gems: 0,
	},
	Inventory: {
		Items: {},
	},
});

const mockConfig = {
	startYear: 2024,
	startMonth: 1, // Use January for easier testing with os.time
	startDay: 1,
	targetHour: 0,
	targetMin: 0,
	totalDays: 5,
	rewards: {
		[1]: { Gold: 100, Gems: 10 },
		[2]: { Gold: 150, Gems: 15 },
		[3]: { SpecialItem: "TestItem" },
		[4]: { Gold: 200 },
		[5]: { Gems: 20 },
	},
};

describe("AdventCalendar", () => {
	let mockPlayer: Player;
	let personInstance: any;

	beforeEach(() => {
		// Reset mocks and data
		jest.clearAllMocks();
		rawMockData = {};
		mockPlayer = MockPlayer();
		personInstance = Person.getForPlayer(mockPlayer).Await();

		// Initialize AdventCalendar with mock config
		AdventCalendar.setAdventCalendarConfig(table.clone(mockConfig));
		// Manually call init as it's usually called by a loader
		if (AdventCalendar.init) {
			AdventCalendar.init();
		}
		// Simulate personAdded event for data initialization
		const personAddedConnect = (Person.personAdded.connect as jest.Mock).mock.calls[0][0];
		if (personAddedConnect) {
			personAddedConnect(personInstance);
		}
	});

	it("should initialize with default config or set config", () => {
		expect(AdventCalendar.getCurrentDay).toBeDefined();
		const currentDay = AdventCalendar.getCurrentDay();
		// Depending on the test run date, this will vary.
		// For now, just check it returns a number.
		expect(typeIs(currentDay, "number")).toBe(true);
	});

	describe("getCurrentDay", () => {
		it("should return 0 if config is not loaded (though we load it in beforeEach)", () => {
			AdventCalendar.setAdventCalendarConfig(undefined as any); // Force undefined config
			expect(AdventCalendar.getCurrentDay()).toBe(0);
			AdventCalendar.setAdventCalendarConfig(table.clone(mockConfig)); // Restore
		});

		it("should calculate the current day correctly based on os.time", () => {
			// This test is sensitive to the actual date/time.
			// We'll check a known past date relative to the config.
			const configStartTime = os.time({
				year: mockConfig.startYear,
				month: mockConfig.startMonth,
				day: mockConfig.startDay,
				hour: mockConfig.targetHour,
				min: mockConfig.targetMin,
				sec: 0,
			});

			// Mock os.time to control current time for testing
			const mockOsTime = jest.fn();
			const originalOsTime = os.time;
			(os.time as any) = mockOsTime;

			// Day 1
			mockOsTime.mockReturnValue(configStartTime + 10); // A few seconds into day 1
			expect(AdventCalendar.getCurrentDay()).toBe(1);

			// Day 2
			mockOsTime.mockReturnValue(configStartTime + 86400 + 10); // 1 day and 10 seconds after start
			expect(AdventCalendar.getCurrentDay()).toBe(2);

			// Before start
			mockOsTime.mockReturnValue(configStartTime - 86400); // 1 day before start
			expect(AdventCalendar.getCurrentDay()).toBe(0);

			// After end
			mockOsTime.mockReturnValue(configStartTime + 86400 * (mockConfig.totalDays + 1));
			expect(AdventCalendar.getCurrentDay()).toBe(mockConfig.totalDays + 1); // Or how it handles post-event

			(os.time as any) = originalOsTime; // Restore original os.time
		});
	});

	describe("claimAdventReward", () => {
		beforeEach(() => {
			// Ensure player data is initialized for claiming
			AdventCalendar.updateAdventCalendarData(personInstance);
		});

		it("should not claim if day is not unlocked", () => {
			const mockOsTime = jest.fn(() => os.time({ year: 2024, month: 1, day: 1, hour: 1, min: 0, sec: 0 }));
			const originalOsTime = os.time;
			(os.time as any) = mockOsTime;

			personInstance.dataCache().AdventCalendarData.OnlineDays = 0; // Not enough online days
			const canClaim = AdventCalendar.canClaimAdventReward(personInstance, 1);
			expect(canClaim[0]).toBe(false);
			expect(canClaim[1]).toBe("Must be online for more days");

			const success = AdventCalendar.claimAdventReward(personInstance, 1);
			expect(success).toBe(false);
			expect(personInstance.dataCache().AdventCalendarData.Claimed).not.toContain(1);

			(os.time as any) = originalOsTime;
		});

		it("should allow claiming a reward if conditions are met", () => {
			const mockOsTime = jest.fn(() => os.time({ year: 2024, month: 1, day: 1, hour: 1, min: 0, sec: 0 }));
			const originalOsTime = os.time;
			(os.time as any) = mockOsTime;

			// Simulate player being online for day 1
			personInstance.dataCache().AdventCalendarData.OnlineDays = 1;
			personInstance.dataCache().AdventCalendarData.DayNumber = 1; // Manually set current day for player

			const canClaim = AdventCalendar.canClaimAdventReward(personInstance, 1);
			expect(canClaim[0]).toBe(true);

			const success = AdventCalendar.claimAdventReward(personInstance, 1);
			expect(success).toBe(true);
			expect(personInstance.dataCache().AdventCalendarData.Claimed).toContain(1);
			expect(personInstance.dataCache().Currencies.Gold).toBe(mockConfig.rewards[1].Gold);
			expect(personInstance.dataCache().Currencies.Gems).toBe(mockConfig.rewards[1].Gems);

			(os.time as any) = originalOsTime;
		});

		it("should not claim if already claimed", () => {
			const mockOsTime = jest.fn(() => os.time({ year: 2024, month: 1, day: 1, hour: 1, min: 0, sec: 0 }));
			const originalOsTime = os.time;
			(os.time as any) = mockOsTime;

			personInstance.dataCache().AdventCalendarData.OnlineDays = 1;
			personInstance.dataCache().AdventCalendarData.DayNumber = 1;

			AdventCalendar.claimAdventReward(personInstance, 1); // First claim
			const success = AdventCalendar.claimAdventReward(personInstance, 1); // Second claim
			expect(success).toBe(false);
			// Gold should not be double rewarded
			expect(personInstance.dataCache().Currencies.Gold).toBe(mockConfig.rewards[1].Gold);

			(os.time as any) = originalOsTime;
		});

		it("should handle special item rewards", () => {
			const mockOsTime = jest.fn(() => os.time({ year: 2024, month: 1, day: 3, hour: 1, min: 0, sec: 0 }));
			const originalOsTime = os.time;
			(os.time as any) = mockOsTime;

			personInstance.dataCache().AdventCalendarData.OnlineDays = 3;
			personInstance.dataCache().AdventCalendarData.DayNumber = 3;

			const success = AdventCalendar.claimAdventReward(personInstance, 3);
			expect(success).toBe(true);
			expect(personInstance.dataCache().Inventory.Items["TestItem"].Count).toBe(1);

			(os.time as any) = originalOsTime;
		});
	});

	it("should correctly update advent calendar data on personAdded", () => {
		const initialOnlineDays = personInstance.dataCache().AdventCalendarData.OnlineDays;
		// personAdded is already simulated in beforeEach
		// We can check if DayNumber got updated if it was different from getCurrentDay
		const currentDay = AdventCalendar.getCurrentDay();
		if (personInstance.dataCache().AdventCalendarData.DayNumber !== currentDay) {
			expect(personInstance.dataCache().AdventCalendarData.OnlineDays).toBe(initialOnlineDays + 1);
		} else {
			expect(personInstance.dataCache().AdventCalendarData.OnlineDays).toBe(initialOnlineDays);
		}
		expect(personInstance.dataCache().AdventCalendarData.DayNumber).toBe(currentDay);
	});

	it("isAdventCalendarActive should reflect config and current day", () => {
		const originalOsTime = os.time;
		const mockOsTime = jest.fn();
		(os.time as any) = mockOsTime;

		const configStartTime = os.time({
			year: mockConfig.startYear,
			month: mockConfig.startMonth,
			day: mockConfig.startDay,
		});

		// During event
		mockOsTime.mockReturnValue(configStartTime + 86400 * 2); // Day 3
		expect(AdventCalendar.isAdventCalendarActive()).toBe(true);

		// Before event
		mockOsTime.mockReturnValue(configStartTime - 86400);
		expect(AdventCalendar.isAdventCalendarActive()).toBe(false);

		// After event
		mockOsTime.mockReturnValue(configStartTime + 86400 * (mockConfig.totalDays + 1));
		expect(AdventCalendar.isAdventCalendarActive()).toBe(false);

		(os.time as any) = originalOsTime;
	});

	it("getTimeUntilNextDay should calculate correctly", () => {
		const originalOsTime = os.time;
		const mockOsTime = jest.fn();
		(os.time as any) = mockOsTime;

		const now = os.time({
			year: mockConfig.startYear,
			month: mockConfig.startMonth,
			day: mockConfig.startDay,
			hour: 10,
			min: 0,
			sec: 0,
		});
		mockOsTime.mockReturnValue(now);

		const nextUnlockHour = mockConfig.targetHour; // which is 0 for mockConfig
		let expectedSecondsUntilNextDay: number;
		if (nextUnlockHour <= 10) {
			// Next unlock is "tomorrow"
			expectedSecondsUntilNextDay = (24 - 10 + nextUnlockHour) * 3600;
		} else {
			// Next unlock is "today"
			expectedSecondsUntilNextDay = (nextUnlockHour - 10) * 3600;
		}
		// Our mock config has targetHour = 0, so next unlock is next day at 00:00
		// If current time is 10:00, then 14 hours remaining.
		expectedSecondsUntilNextDay = 14 * 3600;

		expect(AdventCalendar.getTimeUntilNextDay()).toBe(expectedSecondsUntilNextDay);

		(os.time as any) = originalOsTime;
	});
});

// Ensure AdventCalendar.start can be called for coverage, though its effects are harder to test in isolation here
// It sets up network listeners and periodic checks.
if (AdventCalendar.start) {
	AdventCalendar.start();
}
// Stop any potential loops from start if they were not cleaned up by jest's environment
// (This is a bit of a hack, ideally test environment handles this)
const tasks = getreg().filter((val: any) => typeIs(val, "thread") && coroutine.status(val) !== "dead");
tasks.forEach((thr: thread) => task.cancel(thr));

export {}; // Make it a module
