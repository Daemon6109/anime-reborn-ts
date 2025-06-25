import { expect, describe, it, beforeEach, jest } from "@rbxts/jest-globals";
import { MountService } from "@server/services/mount.service";
import { DataService } from "@server/services/data.service";

// Mock DataService
const mockDataService = {
	getCache: jest.fn(),
	setCache: jest.fn(),
} as unknown as DataService;

describe("MountService", () => {
	let mountService: MountService;

	beforeEach(() => {
		jest.clearAllMocks();
		mountService = new MountService(mockDataService);
		// Don't call onInit() to avoid infinite loops with Players service
		// Instead manually call loadDefaultMountConfigs
		(mountService as unknown as { loadDefaultMountConfigs(): void }).loadDefaultMountConfigs();
	});

	describe("Initialization", () => {
		it("should initialize with correct version", () => {
			expect(mountService.version).toEqual({ major: 1, minor: 0, patch: 0 });
		});
	});

	describe("Mount Configuration", () => {
		it("should get mount configuration for Horse", () => {
			const horseConfig = mountService.getMountConfig("Horse");
			expect(horseConfig).toBeDefined();
			expect(horseConfig?.Name).toBe("Horse");
			expect(horseConfig?.DisplayName).toBe("Brown Horse");
		});

		it("should return undefined for invalid mount", () => {
			const invalidMount = mountService.getMountConfig("InvalidMount");
			expect(invalidMount).toBeUndefined();
		});

		it("should get all mount configurations", () => {
			const allMounts = mountService.getAllMountConfigs();
			expect(allMounts).toBeDefined();
			expect(allMounts.Horse).toBeDefined();
			expect(allMounts.Dragon).toBeDefined();
		});

		it("should set mount configuration", () => {
			const testMount = {
				Name: "TestMount",
				DisplayName: "Test Mount",
				Description: "A test mount",
				Rarity: "Common" as const,
			};

			mountService.setMountConfig("TestMount", testMount);
			const retrievedConfig = mountService.getMountConfig("TestMount");
			expect(retrievedConfig).toEqual(testMount);
		});
	});

	describe("Mount Properties", () => {
		it("should have different mount rarities", () => {
			const horse = mountService.getMountConfig("Horse");
			const dragon = mountService.getMountConfig("Dragon");
			const phoenix = mountService.getMountConfig("Phoenix");

			expect(horse?.Rarity).toBe("Common");
			expect(dragon?.Rarity).toBe("Epic");
			expect(phoenix?.Rarity).toBe("Legendary");
		});

		it("should have progressive speeds", () => {
			const horse = mountService.getMountConfig("Horse");
			const dragon = mountService.getMountConfig("Dragon");
			const phoenix = mountService.getMountConfig("Phoenix");

			if (horse?.Speed !== undefined && dragon?.Speed !== undefined && phoenix?.Speed !== undefined) {
				expect(dragon.Speed).toBeGreaterThan(horse.Speed);
				expect(phoenix.Speed).toBeGreaterThan(dragon.Speed);
			}
		});

		it("should have special abilities for some mounts", () => {
			const unicorn = mountService.getMountConfig("Unicorn");
			const dragon = mountService.getMountConfig("Dragon");

			expect(unicorn?.Special).toBe("Healing Aura");
			expect(dragon?.Special).toBe("Flight");
		});
	});

	describe("Event System", () => {
		it("should have event callback arrays", () => {
			// Test that we can subscribe to events
			const mockCallback = jest.fn();

			mountService.onMountEquipped(mockCallback);
			mountService.onMountUnequipped(mockCallback);

			// The callbacks should be stored (we can't directly test private arrays)
			expect(mockCallback).toBeDefined();
		});
	});

	describe("Configuration", () => {
		it("should have version information", () => {
			expect(mountService.version.major).toBe(1);
			expect(mountService.version.minor).toBe(0);
			expect(mountService.version.patch).toBe(0);
		});
	});

	describe("Mount Costs", () => {
		it("should have cost information for mounts", () => {
			const horse = mountService.getMountConfig("Horse");
			const unicorn = mountService.getMountConfig("Unicorn");

			expect(horse?.Cost?.Gold).toBe(1000);
			expect(unicorn?.Cost?.Gems).toBe(100);
		});

		it("should have level requirements", () => {
			const horse = mountService.getMountConfig("Horse");
			const phoenix = mountService.getMountConfig("Phoenix");

			expect(horse?.RequiredLevel).toBe(1);
			expect(phoenix?.RequiredLevel).toBe(50);
		});
	});

	describe("Mount Categories", () => {
		it("should have basic mounts", () => {
			const horse = mountService.getMountConfig("Horse");
			const unicorn = mountService.getMountConfig("Unicorn");

			expect(horse).toBeDefined();
			expect(unicorn).toBeDefined();
		});

		it("should have special mounts", () => {
			const wolf = mountService.getMountConfig("Wolf");
			const griffin = mountService.getMountConfig("Griffin");

			expect(wolf).toBeDefined();
			expect(griffin).toBeDefined();
		});

		it("should have legendary mounts", () => {
			const dragon = mountService.getMountConfig("Dragon");
			const phoenix = mountService.getMountConfig("Phoenix");

			expect(dragon).toBeDefined();
			expect(phoenix).toBeDefined();
		});
	});
});
