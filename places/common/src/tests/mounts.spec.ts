import Mounts from "../../server/mounts";
import Person from "../../server/person";
import { MockPlayer, MockPlayersService, MockReplicatedStorage, MockHttpService } from "@rbxts/jest-roblox"; // MockHttpService might not be needed directly but good for completeness if loadModules used it.
import loadModules from "../../shared/utils/load_modules"; // Adjusted path

// Mock dependencies
jest.mock("@commonserver/person", () => ({
	getForPlayer: jest.fn((player: Player) => ({
		Await: jest.fn(() => mockPersonInstance),
		Unwrap: jest.fn(() => mockPersonInstance),
	})),
	personAdded: { connect: jest.fn() },
	personRemoved: { connect: jest.fn() },
}));

jest.mock("@network/server", () => ({
	common: {
		EquipMount: { on: jest.fn() },
		UnequipMount: { on: jest.fn() },
	},
}));

jest.mock("@pkgs/shingo", () => ({
	new: () => ({
		fire: jest.fn(),
		connect: jest.fn(),
	}),
}));

// Mock loadModules and the MountsRegistry structure it would load
// This is a simplified mock. A real scenario might involve mocking ReplicatedStorage contents.
jest.mock("../../shared/utils/load_modules", () => ({
	fromChildren: jest.fn(() => ({
		DragonMount: {
			Name: "DragonMount",
			GetModel: () => {
				const model = new Instance("Model");
				model.Name = "DragonMountModel";
				// Add a dummy Motor6D for attachment logic test
				const motor = new Instance("Motor6D");
				motor.Name = "HumanoidRootPart"; // Assuming it attaches to HumanoidRootPart
				motor.Parent = model;
				return model;
			},
		},
		HorseMount: {
			Name: "HorseMount",
			GetModel: () => {
				const model = new Instance("Model");
				model.Name = "HorseMountModel";
				const motor = new Instance("Motor6D");
				motor.Name = "HumanoidRootPart";
				motor.Parent = model;
				return model;
			},
		},
	})),
}));

let rawMockMountsData: any = {};
const mockPersonInstance = {
	player: {} as Player,
	dataCache: jest.fn((callback?: (data: any) => any) => {
		if (callback) {
			rawMockMountsData = callback(rawMockMountsData);
		}
		return rawMockMountsData;
	}),
};

const createMockPlayerDataForMounts = () => ({
	Inventory: {
		Mounts: {}, // { [mountName]: { Count: number } }
	},
	EquippedMount: "",
});

// Mock services
const mockPlayers = new MockPlayersService();
const mockReplicatedStorageGlobal = new MockReplicatedStorage();
// Setup ReplicatedStorage.Registry.Mounts for loadModules mock if it were more direct
const registryFolder = new Instance("Folder");
registryFolder.Name = "Registry";
const mountsFolder = new Instance("Folder");
mountsFolder.Name = "Mounts";
mountsFolder.Parent = registryFolder;
mockReplicatedStorageGlobal.SetInstance(registryFolder);

(game as any).GetService = jest.fn((name: string) => {
	if (name === "Players") return mockPlayers;
	if (name === "ReplicatedStorage") return mockReplicatedStorageGlobal;
	// Fallback for other services
	const actualServices = require("@rbxts/services");
	return actualServices[name as keyof typeof actualServices];
});

describe("Mounts", () => {
	let mockPlayer: Player;
	let mockCharacter: Model;

	beforeEach(() => {
		jest.clearAllMocks();
		rawMockMountsData = createMockPlayerDataForMounts();
		mockPlayer = MockPlayer();
		mockPlayers.AddPlayer(mockPlayer);
		mockPersonInstance.player = mockPlayer;

		// Create a mock character for the player
		mockCharacter = new Instance("Model");
		mockCharacter.Name = "TestCharacter";
		const hrp = new Instance("Part");
		hrp.Name = "HumanoidRootPart";
		hrp.Parent = mockCharacter;
		mockPlayer.Character = mockCharacter;

		// Manually call init
		if (Mounts.init) {
			Mounts.init();
		}
	});

	afterEach(() => {
		mockPlayers.ClearAllPlayers();
		if (mockPlayer.Character) {
			mockPlayer.Character.Destroy();
		}
	});

	it("should initialize", () => {
		expect(Mounts.giveMount).toBeDefined();
	});

	describe("giveMount", () => {
		it("should give a mount to the player's inventory", () => {
			Mounts.giveMount(mockPersonInstance as any, "DragonMount", 1);
			expect(rawMockMountsData.Inventory.Mounts["DragonMount"]).toBeDefined();
			expect(rawMockMountsData.Inventory.Mounts["DragonMount"].Count).toBe(1);

			Mounts.giveMount(mockPersonInstance as any, "DragonMount"); // Give another (defaults to 1)
			expect(rawMockMountsData.Inventory.Mounts["DragonMount"].Count).toBe(2);
		});

		it("should not give an invalid mount", () => {
			Mounts.giveMount(mockPersonInstance as any, "InvalidMount");
			expect(rawMockMountsData.Inventory.Mounts["InvalidMount"]).toBeUndefined();
		});
	});

	describe("equipMount", () => {
		beforeEach(() => {
			// Give player a mount to equip
			Mounts.giveMount(mockPersonInstance as any, "DragonMount", 1);
		});

		it("should equip a mount if owned and valid", () => {
			const success = Mounts.equipMount(mockPersonInstance as any, "DragonMount");
			expect(success).toBe(true);
			expect(rawMockMountsData.EquippedMount).toBe("DragonMount");
			expect(mockPlayer.Character?.FindFirstChild("DragonMountModel")).toBeDefined();
			expect(mockPlayer.Character?.FindFirstChild("MountObject")).toBeDefined();
			expect((mockPlayer.Character?.FindFirstChild("MountObject") as ObjectValue)?.Value?.Name).toBe(
				"DragonMountModel",
			);
			expect((Mounts.mountEquipped as any).fire).toHaveBeenCalledWith({
				player: mockPlayer,
				mountName: "DragonMount",
			});
		});

		it("should not equip if mount is not in registry", () => {
			const success = Mounts.equipMount(mockPersonInstance as any, "FakeMountNotInRegistry");
			expect(success).toBe(false);
		});

		it("should not equip if player does not own the mount", () => {
			const success = Mounts.equipMount(mockPersonInstance as any, "HorseMount"); // Not given yet
			expect(success).toBe(false);
		});

		it("should unequip previous mount before equipping a new one", () => {
			Mounts.equipMount(mockPersonInstance as any, "DragonMount");
			expect(mockPlayer.Character?.FindFirstChild("DragonMountModel")).toBeDefined();

			Mounts.giveMount(mockPersonInstance as any, "HorseMount", 1);
			Mounts.equipMount(mockPersonInstance as any, "HorseMount");

			expect(rawMockMountsData.EquippedMount).toBe("HorseMount");
			expect(mockPlayer.Character?.FindFirstChild("DragonMountModel")).toBeUndefined(); // Old one destroyed
			expect(mockPlayer.Character?.FindFirstChild("HorseMountModel")).toBeDefined(); // New one present
		});

		it("should handle cases where character doesn't exist", () => {
			mockPlayer.Character = undefined;
			const success = Mounts.equipMount(mockPersonInstance as any, "DragonMount");
			expect(success).toBe(false);
			mockPlayer.Character = mockCharacter; // Restore
		});
	});

	describe("unequipMount", () => {
		beforeEach(() => {
			Mounts.giveMount(mockPersonInstance as any, "DragonMount", 1);
			Mounts.equipMount(mockPersonInstance as any, "DragonMount");
		});

		it("should unequip the current mount", () => {
			expect(rawMockMountsData.EquippedMount).toBe("DragonMount");
			expect(mockPlayer.Character?.FindFirstChild("DragonMountModel")).toBeDefined();

			Mounts.unequipMount(mockPersonInstance as any);

			expect(rawMockMountsData.EquippedMount).toBe(""); // Or specific "none" value
			expect(mockPlayer.Character?.FindFirstChild("DragonMountModel")).toBeUndefined();
			expect((Mounts.mountUnequipped as any).fire).toHaveBeenCalledWith({ player: mockPlayer });
		});

		it("should do nothing if no mount is equipped", () => {
			Mounts.unequipMount(mockPersonInstance as any); // Unequip first time
			const initialData = { ...rawMockMountsData };
			Mounts.unequipMount(mockPersonInstance as any); // Try again
			expect(rawMockMountsData).toEqual(initialData); // Should not have changed or errored
			expect((Mounts.mountUnequipped as any).fire).toHaveBeenCalledTimes(2); // Event still fires
		});
	});

	describe("equipMountFromData", () => {
		it("should equip the mount stored in player data", () => {
			Mounts.giveMount(mockPersonInstance as any, "HorseMount", 1);
			rawMockMountsData.EquippedMount = "HorseMount"; // Simulate data load

			Mounts.equipMountFromData(mockPersonInstance as any);
			expect(mockPlayer.Character?.FindFirstChild("HorseMountModel")).toBeDefined();
			expect(rawMockMountsData.EquippedMount).toBe("HorseMount"); // Stays the same
		});

		it("should do nothing if no mount is saved in data", () => {
			rawMockMountsData.EquippedMount = "";
			Mounts.equipMountFromData(mockPersonInstance as any);
			expect(
				mockPlayer.Character?.FindFirstChild("MountObject")?.IsA("ObjectValue")
					? (mockPlayer.Character?.FindFirstChild("MountObject") as ObjectValue).Value
					: undefined,
			).toBeUndefined();
		});
	});

	it("should register network handlers on start", () => {
		const equipHandler = Network.common.EquipMount.on as jest.Mock;
		const unequipHandler = Network.common.UnequipMount.on as jest.Mock;
		Mounts.start();
		expect(equipHandler).toHaveBeenCalled();
		expect(unequipHandler).toHaveBeenCalled();
	});

	it("should connect to person events on init", () => {
		// init() called in beforeEach
		expect(Person.personAdded.connect as jest.Mock).toHaveBeenCalled();
		expect(Person.personRemoved.connect as jest.Mock).toHaveBeenCalled();
	});

	// Test _handleCharacterAdded (private, called by personAdded callback)
	// This requires invoking the callback obtained from Person.personAdded.connect
});

export {}; // Make it a module
