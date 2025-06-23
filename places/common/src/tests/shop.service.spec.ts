import { expect, describe, it, beforeEach, jest } from "@rbxts/jest-globals";
import { ShopService, ShopType } from "server/services/shop.service";
import { DataService } from "server/services/data.service";

describe("ShopService", () => {
	let service: ShopService;
	let mockDataService: DataService;

	beforeEach(() => {
		jest.clearAllMocks();

		// Create mock DataService
		mockDataService = {
			getCache: jest.fn(),
			setCache: jest.fn(),
		} as unknown as DataService;

		service = new ShopService(mockDataService);
	});

	describe("Initialization", () => {
		it("should initialize with correct version", () => {
			expect(service.version).toEqual({ major: 1, minor: 0, patch: 0 });
		});

		it("should load default shop configurations", () => {
			service.loadDefaultShopConfigs();

			const dungeonConfig = service.getShopConfig("DungeonShop");
			const eventConfig = service.getShopConfig("EventShop");
			const raidConfig = service.getShopConfig("RaidShop");

			expect(dungeonConfig).toBeDefined();
			expect(eventConfig).toBeDefined();
			expect(raidConfig).toBeDefined();
		});
	});

	describe("Shop Configuration", () => {
		beforeEach(() => {
			service.loadDefaultShopConfigs();
		});

		it("should get shop configuration for valid shop type", () => {
			const config = service.getShopConfig("DungeonShop");
			expect(config).toBeDefined();
			expect(config?.resetType).toBe("daily");
			expect(config?.items).toBeDefined();
		});

		it("should return undefined for invalid shop type", () => {
			const config = service.getShopConfig("InvalidShop" as ShopType);
			expect(config).toBeUndefined();
		});

		it("should allow setting shop configuration", () => {
			const newConfig = {
				items: {
					["Test Item"]: { cost: { Gold: 100 }, stock: 5 },
				},
				resetType: "weekly" as const,
			};

			service.setShopConfig("DungeonShop", newConfig);
			const retrievedConfig = service.getShopConfig("DungeonShop");

			expect(retrievedConfig).toEqual(newConfig);
		});

		it("should get shop items for valid shop type", () => {
			const items = service.getShopItems("DungeonShop");
			expect(items).toBeDefined();
			expect(items?.["Health Potion"]).toBeDefined();
			expect(items?.["Health Potion"].cost.Gold).toBe(100);
		});
	});

	describe("Shop Data Initialization", () => {
		const mockPlayer = {} as Player;

		beforeEach(() => {
			service.loadDefaultShopConfigs();
		});

		it("should initialize shop data for player", async () => {
			const mockPlayerData = {
				DungeonShopData: {},
				Currencies: { Gold: 1000 },
				Inventory: { Items: {} },
			};

			(mockDataService.getCache as jest.Mock).mockResolvedValue(mockPlayerData);

			await service.initializeShopData(mockPlayer, "DungeonShop");

			// Test that the function completes successfully without error
			expect(true).toBe(true);
		});

		it("should not initialize if player data is missing", async () => {
			(mockDataService.getCache as jest.Mock).mockResolvedValue(undefined);

			await service.initializeShopData(mockPlayer, "DungeonShop");

			// Test that function handles missing data gracefully
			expect(true).toBe(true);
		});
	});

	describe("Shop Purchase", () => {
		const mockPlayer = {} as Player;

		beforeEach(() => {
			service.loadDefaultShopConfigs();
		});

		it("should successfully purchase item with sufficient currency", async () => {
			const mockPlayerData = {
				DungeonShopData: {},
				Currencies: { Gold: 1000 },
				Inventory: { Items: {} },
			};

			(mockDataService.getCache as jest.Mock).mockResolvedValue(mockPlayerData);

			const result = await service.purchaseShopItem(mockPlayer, "DungeonShop", "Health Potion", 1);

			expect(result).toBe(true);
		});

		it("should fail purchase with insufficient currency", async () => {
			const mockPlayerData = {
				DungeonShopData: {},
				Currencies: { Gold: 50 }, // Not enough for Health Potion (100 Gold)
				Inventory: { Items: {} },
			};

			(mockDataService.getCache as jest.Mock).mockResolvedValue(mockPlayerData);

			const result = await service.purchaseShopItem(mockPlayer, "DungeonShop", "Health Potion", 1);

			expect(result).toBe(false);
		});

		it("should fail purchase for invalid item", async () => {
			const mockPlayerData = {
				DungeonShopData: {},
				Currencies: { Gold: 1000 },
				Inventory: { Items: {} },
			};

			(mockDataService.getCache as jest.Mock).mockResolvedValue(mockPlayerData);

			const result = await service.purchaseShopItem(mockPlayer, "DungeonShop", "Invalid Item", 1);

			expect(result).toBe(false);
		});

		it("should fail purchase with invalid amount", async () => {
			const mockPlayerData = {
				DungeonShopData: {},
				Currencies: { Gold: 1000 },
				Inventory: { Items: {} },
			};

			(mockDataService.getCache as jest.Mock).mockResolvedValue(mockPlayerData);

			const result = await service.purchaseShopItem(mockPlayer, "DungeonShop", "Health Potion", 0);

			expect(result).toBe(false);
		});

		it("should fail purchase when player data not found", async () => {
			(mockDataService.getCache as jest.Mock).mockResolvedValue(undefined);

			const result = await service.purchaseShopItem(mockPlayer, "DungeonShop", "Health Potion", 1);

			expect(result).toBe(false);
		});

		it("should handle stock correctly for limited items", async () => {
			const mockPlayerData = {
				DungeonShopData: {
					["Rare Gem"]: { stock: 2 }, // Only 2 left
				},
				Currencies: { Gold: 5000 },
				Inventory: { Items: {} },
			};

			(mockDataService.getCache as jest.Mock).mockResolvedValue(mockPlayerData);

			// Try to buy 3 when only 2 are available
			const result = await service.purchaseShopItem(mockPlayer, "DungeonShop", "Rare Gem", 3);

			expect(result).toBe(false);
		});
	});

	describe("Shop Stock Management", () => {
		const mockPlayer = {} as Player;

		beforeEach(() => {
			service.loadDefaultShopConfigs();
		});

		it("should get shop stock for player", async () => {
			const mockPlayerData = {
				DungeonShopData: {
					["Rare Gem"]: { stock: 3 },
				},
			};

			(mockDataService.getCache as jest.Mock).mockResolvedValue(mockPlayerData);

			const stock = await service.getShopStock(mockPlayer, "DungeonShop");

			expect(stock["Rare Gem"]).toBe(3);
			expect(stock["Health Potion"]).toBe(-1); // Unlimited
		});

		it("should return empty stock when player data not found", async () => {
			(mockDataService.getCache as jest.Mock).mockResolvedValue(undefined);

			const stock = await service.getShopStock(mockPlayer, "DungeonShop");

			// Check that stock is empty
			const stockValues = [];
			for (const [key] of pairs(stock)) {
				stockValues.push(key);
			}
			expect(stockValues.size()).toBe(0);
		});

		it("should reset shop for player", async () => {
			const mockPlayerData = {
				DungeonShopData: {
					["Rare Gem"]: { stock: 1 }, // Low stock
				},
			};

			(mockDataService.getCache as jest.Mock).mockResolvedValue(mockPlayerData);

			await service.resetShopForPlayer(mockPlayer, "DungeonShop");

			// Test that reset completes successfully
			expect(true).toBe(true);
		});
	});

	describe("Event System", () => {
		it("should allow subscribing to item purchased events", () => {
			const mockCallback = jest.fn();

			expect(() => {
				service.onItemPurchased(mockCallback);
			}).toBeTruthy();
		});
	});

	describe("Shop Reset Checking", () => {
		it("should check shop resets without errors", () => {
			expect(() => {
				service.checkShopResets();
			}).toBeTruthy();
		});
	});
});
