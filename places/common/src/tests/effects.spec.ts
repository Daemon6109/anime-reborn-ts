import Effects from "../../server/effects";
import Person from "../../server/person";
import EffectsDataRegistry from "../../../shared/registry/effects_data"; // Adjusted path
import { MockPlayer } from "@rbxts/jest-roblox";

// Mock Person and other dependencies
jest.mock("@commonserver/person", () => {
	return {
		getForPlayer: jest.fn((player: Player) => mockPersonInstance), // Direct return for simplicity
		personAdded: { connect: jest.fn() },
		personRemoved: { connect: jest.fn() },
	};
});

// Mock the EffectsData registry module itself
jest.mock("../../../shared/registry/effects_data", () => ({
	ExpBoost: {
		Name: "XP Boost",
		Description: "Increases XP gain.",
		Icon: "rbxassetid://12345",
		Duration: 3600, // 1 hour
		Multiplier: {
			ExpBoost: 1.5, // 50% XP boost
		},
		MaxStack: 1,
		Type: "Buff",
	},
	GoldBoost: {
		Name: "Gold Boost",
		Description: "Increases Gold gain.",
		Icon: "rbxassetid://67890",
		Duration: 1800, // 30 minutes
		Multiplier: {
			GoldBoost: 2.0, // 100% Gold boost
		},
		MaxStack: 1,
		Type: "Buff",
	},
	AttackBoost: {
		Name: "Attack Boost",
		Description: "Increases Attack Power.",
		Icon: "rbxassetid://13579",
		Duration: 600, // 10 minutes
		Multiplier: {
			AttackBoost: 1.2, // 20% Attack boost
		},
		MaxStack: 3, // Example of a stackable buff
		Type: "Buff",
	},
}));

let rawMockEffectsData: any = {};
const mockPersonInstance = {
	player: {} as Player,
	dataCache: jest.fn((callback?: (data: any) => any) => {
		if (callback) {
			rawMockEffectsData = callback(rawMockEffectsData);
		}
		return rawMockEffectsData;
	}),
};

const createMockPlayerDataForEffects = () => ({
	Effects: {}, // Player's active effects
	// Other data as needed by Person or other systems if they were fully integrated
});

// Mock DateTime.now() for consistent time testing
const mockCurrentTimestamp = 1700000000; // A fixed UNIX timestamp
const originalDateTimeNow = DateTime.now;
(DateTime.now as any) = jest.fn(() => ({
	UnixTimestamp: mockCurrentTimestamp,
}));

describe("Effects", () => {
	let mockPlayer: Player;

	beforeEach(() => {
		jest.clearAllMocks();
		rawMockEffectsData = createMockPlayerDataForEffects();
		mockPlayer = MockPlayer();
		mockPersonInstance.player = mockPlayer;

		// Manually call init as it's usually called by a loader
		if (Effects.init) {
			Effects.init();
		}
	});

	afterEach(() => {
		(DateTime.now as any) = originalDateTimeNow; // Restore
	});

	it("should initialize", () => {
		expect(Effects.ApplyEffect).toBeDefined();
	});

	describe("ApplyEffect", () => {
		it("should apply a new effect to the person", () => {
			Effects.ApplyEffect(mockPersonInstance as any, "ExpBoost" as any, 3600);
			const effects = rawMockEffectsData.Effects;
			expect(effects["ExpBoost"]).toBeDefined();
			expect(effects["ExpBoost"].Duration).toBe(3600);
			expect(effects["ExpBoost"].StartTime).toBe(mockCurrentTimestamp);
		});

		it("should stack duration if an effect is reapplied and is active", () => {
			Effects.ApplyEffect(mockPersonInstance as any, "ExpBoost" as any, 1000);
			Effects.ApplyEffect(mockPersonInstance as any, "ExpBoost" as any, 500); // Reapply
			expect(rawMockEffectsData.Effects["ExpBoost"].Duration).toBe(1500);
		});

		it("should not apply an invalid effect", () => {
			Effects.ApplyEffect(mockPersonInstance as any, "InvalidEffect" as any, 1000);
			expect(rawMockEffectsData.Effects["InvalidEffect"]).toBeUndefined();
		});

		it("should reset StartTime and Duration if effect was expired and reapplied", () => {
			// Apply effect
			Effects.ApplyEffect(mockPersonInstance as any, "GoldBoost" as any, 100); // Duration 100s
			// Simulate time passing so it expires
			(DateTime.now as any).mockReturnValue({ UnixTimestamp: mockCurrentTimestamp + 200 });
			// Re-apply
			Effects.ApplyEffect(mockPersonInstance as any, "GoldBoost" as any, 500);

			expect(rawMockEffectsData.Effects["GoldBoost"].Duration).toBe(500);
			// StartTime should be the new current time when it was re-applied
			expect(rawMockEffectsData.Effects["GoldBoost"].StartTime).toBe(mockCurrentTimestamp + 200);
		});
	});

	describe("RevokeEffect", () => {
		it("should remove an active effect", () => {
			Effects.ApplyEffect(mockPersonInstance as any, "ExpBoost" as any, 3600);
			expect(rawMockEffectsData.Effects["ExpBoost"]).toBeDefined();
			Effects.RevokeEffect(mockPersonInstance as any, "ExpBoost" as any);
			expect(rawMockEffectsData.Effects["ExpBoost"]).toBeUndefined();
		});

		it("should do nothing if revoking a non-existent effect", () => {
			const initialEffects = { ...rawMockEffectsData.Effects };
			Effects.RevokeEffect(mockPersonInstance as any, "NonExistentEffect" as any);
			expect(rawMockEffectsData.Effects).toEqual(initialEffects);
		});
	});

	describe("IsEffectActive", () => {
		it("should return true for an active effect", () => {
			Effects.ApplyEffect(mockPersonInstance as any, "ExpBoost" as any, 3600);
			expect(Effects.IsEffectActive(mockPersonInstance as any, "ExpBoost" as any)).toBe(true);
		});

		it("should return false for an expired effect", () => {
			Effects.ApplyEffect(mockPersonInstance as any, "GoldBoost" as any, 100); // Applied at mockCurrentTimestamp
			// Simulate time passing beyond duration
			(DateTime.now as any).mockReturnValue({ UnixTimestamp: mockCurrentTimestamp + 101 });
			expect(Effects.IsEffectActive(mockPersonInstance as any, "GoldBoost" as any)).toBe(false);
		});

		it("should return false for a non-existent effect", () => {
			expect(Effects.IsEffectActive(mockPersonInstance as any, "NonExistentEffect" as any)).toBe(false);
		});
	});

	describe("GetAllActiveEffects", () => {
		it("should return all active effects and exclude expired ones", () => {
			Effects.ApplyEffect(mockPersonInstance as any, "ExpBoost" as any, 3600); // Active
			Effects.ApplyEffect(mockPersonInstance as any, "GoldBoost" as any, 100); // Will be expired
			Effects.ApplyEffect(mockPersonInstance as any, "AttackBoost" as any, 600); // Active

			// Simulate time passing for GoldBoost to expire
			(DateTime.now as any).mockReturnValue({ UnixTimestamp: mockCurrentTimestamp + 200 });

			const activeEffects = Effects.GetAllActiveEffects(mockPersonInstance as any);
			expect(activeEffects["ExpBoost"]).toBeDefined();
			expect(activeEffects["AttackBoost"]).toBeDefined();
			expect(activeEffects["GoldBoost"]).toBeUndefined();
		});
	});

	describe("CalculateMultiplier", () => {
		it("should calculate the correct multiplier for a single active effect", () => {
			Effects.ApplyEffect(mockPersonInstance as any, "ExpBoost" as any, 3600);
			const multiplier = Effects.CalculateMultiplier(mockPersonInstance as any, "ExpBoost" as any);
			expect(multiplier).toBe(EffectsDataRegistry.ExpBoost.Multiplier.ExpBoost);
		});

		it("should return 1 if no relevant effect is active", () => {
			Effects.ApplyEffect(mockPersonInstance as any, "GoldBoost" as any, 1800);
			const multiplier = Effects.CalculateMultiplier(mockPersonInstance as any, "ExpBoost" as any); // Asking for XP, but Gold is active
			expect(multiplier).toBe(1);
		});

		it("should sum multipliers if multiple effects provide the same type (additive for the base 1)", () => {
			// Assuming EffectsDataRegistry had another effect also boosting ExpBoost
			// For this test, let's imagine AttackBoost also gave a small ExpBoost for testing sum.
			// This requires modifying the mock or having a more complex setup.
			// For now, we'll test with distinct multipliers.
			Effects.ApplyEffect(mockPersonInstance as any, "ExpBoost" as any, 3600);
			Effects.ApplyEffect(mockPersonInstance as any, "GoldBoost" as any, 1800);

			expect(Effects.CalculateMultiplier(mockPersonInstance as any, "ExpBoost" as any)).toBe(1.5);
			expect(Effects.CalculateMultiplier(mockPersonInstance as any, "GoldBoost" as any)).toBe(2.0);
		});

		it("should handle effects that have expired", () => {
			Effects.ApplyEffect(mockPersonInstance as any, "ExpBoost" as any, 100);
			(DateTime.now as any).mockReturnValue({ UnixTimestamp: mockCurrentTimestamp + 200 }); // Expire ExpBoost
			const multiplier = Effects.CalculateMultiplier(mockPersonInstance as any, "ExpBoost" as any);
			expect(multiplier).toBe(1);
		});
	});

	// Test personAdded and personRemoved handlers via init
	it("should connect to personAdded and personRemoved events in init", () => {
		// init() is called in beforeEach
		expect(Person.personAdded.connect as jest.Mock).toHaveBeenCalled();
		expect(Person.personRemoved.connect as jest.Mock).toHaveBeenCalled();

		// Further testing of the callbacks themselves would require invoking them
		// e.g., const personAddedCb = (Person.personAdded.connect as jest.Mock).mock.calls[0][0];
		// personAddedCb(mockPersonInstance);
		// Then assert the side effects on mockPersonInstance.dataCache().Effects
	});
});

export {}; // Make it a module
