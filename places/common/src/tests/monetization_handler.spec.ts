import MonetizationHandler from "../../server/monetization_handler";
import Person from "../../server/person";
import ProductsRegistry from "../../../shared/registry/products"; // Adjusted path
import WebhookLib from "../../shared/utils/webhook_lib"; // Adjusted path
import { MockPlayer, MockMarketplaceService, MockPlayersService } from "@rbxts/jest-roblox";

// Mock dependencies
jest.mock("@commonserver/person", () => ({
	getForPlayer: jest.fn((player: Player) => mockPersonInstance),
}));

jest.mock("../../../shared/registry/products", () => ({
	// Sample product data (ensure IDs are numbers as used in code)
	1001: {
		Id: 1001,
		Name: "Small Gold Pack",
		Price: 100,
		Type: "Currency",
		Rewards: { Currencies: { Gold: 1000 } },
	},
	1002: {
		Id: 1002,
		Name: "XP Boost Item",
		Price: 50,
		Type: "Item",
		Rewards: { Items: { XP_BOOST_ITEM_ID: 1 } },
	},
	2001: {
		// Gamepass example (though gamepass logic is simplified in handler)
		Id: 2001,
		Name: "VIP Gamepass",
		Price: 500,
		Type: "Gamepass",
		Rewards: { Perks: ["VIP_CHAT_TAG"] },
	},
}));

jest.mock("../../shared/utils/webhook_lib", () => ({
	send: jest.fn(),
}));

// Mock DataStoreService and its methods if they were used (not directly in this handler but good practice)
// jest.mock("@rbxts/services", () => {
//      const services = requireActual("@rbxts/services");
//      return {
//          ...services,
//          DataStoreService: {
//              GetDataStore: jest.fn().mockReturnValue({
//                  UpdateAsync: jest.fn((key, transform) => transform(undefined)),
//              }),
//          },
//      };
// });

let rawMockMonetizationData: any = {};
const mockPersonInstance = {
	player: {} as Player,
	dataCache: jest.fn((callbackOrNewData?: any) => {
		if (typeIs(callbackOrNewData, "function")) {
			rawMockMonetizationData = callbackOrNewData(rawMockMonetizationData);
		} else if (callbackOrNewData !== undefined) {
			rawMockMonetizationData = callbackOrNewData;
		}
		return rawMockMonetizationData;
	}),
};

const createMockPlayerDataForMonetization = () => ({
	Currencies: { Gold: 0, Gems: 0 },
	XP: 0,
	Level: 1,
	Inventory: { Items: {} },
	RobuxSpent: 0,
	ReceiptHistory: {}, // purchaseId: { ProductId, PlayerId, PurchaseId, CurrencySpent, Timestamp }
});

// Mock services
const mockMarketplaceService = new MockMarketplaceService();
const mockPlayersService = new MockPlayersService();
const mockReplicatedStorage = {
	Events: {
		NotifyPlayer_2: { FireClient: jest.fn() },
		UiCommunication: { FireClient: jest.fn() },
		FindFirstChild: (name: string) => mockReplicatedStorage.Events[name],
	},
	FindFirstChild: (name: string) => (mockReplicatedStorage as any)[name],
};

(game as any).GetService = jest.fn((name: string) => {
	if (name === "MarketplaceService") return mockMarketplaceService;
	if (name === "Players") return mockPlayersService;
	if (name === "ReplicatedStorage") return mockReplicatedStorage;
	// Allow other services to be fetched normally if needed by underlying modules
	const actualServices = require("@rbxts/services");
	return actualServices[name as keyof typeof actualServices];
});

describe("MonetizationHandler", () => {
	let mockPlayer: Player;
	let receiptInfo: any;

	beforeEach(() => {
		jest.clearAllMocks();
		rawMockMonetizationData = createMockPlayerDataForMonetization();
		mockPlayer = MockPlayer();
		mockPlayersService.AddPlayer(mockPlayer);
		mockPersonInstance.player = mockPlayer;

		receiptInfo = {
			PlayerId: mockPlayer.UserId,
			PlaceIdWherePurchased: 0, // Example place ID
			ProductId: 1001, // Small Gold Pack
			PurchaseId: `test-purchase-${DateTime.now().UnixTimestampMillis}`,
			CurrencySpent: ProductsRegistry[1001].Price,
			CurrencyType: Enum.CurrencyType.Robux,
		};

		// Initialize MonetizationHandler (calls MarketplaceService.ProcessReceipt = ...)
		if (MonetizationHandler.start) {
			MonetizationHandler.start();
		} else if (MarketplaceService.ProcessReceipt === undefined && MonetizationHandler.processProductPurchase) {
			// If start doesn't exist but processProductPurchase does, assign manually for test
			MarketplaceService.ProcessReceipt = MonetizationHandler.processProductPurchase;
		}
	});

	afterEach(() => {
		mockPlayersService.ClearAllPlayers();
		MarketplaceService.ProcessReceipt = undefined; // Reset
	});

	it("should initialize and set ProcessReceipt", () => {
		// Called in beforeEach
		expect(MarketplaceService.ProcessReceipt).toBeDefined();
		if (MonetizationHandler.processProductPurchase) {
			// if start() is not the one setting it
			expect(MarketplaceService.ProcessReceipt).toEqual(MonetizationHandler.processProductPurchase);
		}
	});

	describe("processProductPurchase", () => {
		it("should grant rewards for a valid product purchase", () => {
			const decision = MonetizationHandler.processProductPurchase(receiptInfo);
			expect(decision).toBe(Enum.ProductPurchaseDecision.PurchaseGranted);

			const productInfo = ProductsRegistry[receiptInfo.ProductId];
			expect(rawMockMonetizationData.Currencies.Gold).toBe(productInfo.Rewards.Currencies.Gold);
			expect(rawMockMonetizationData.RobuxSpent).toBe(productInfo.Price);
			expect(rawMockMonetizationData.ReceiptHistory[receiptInfo.PurchaseId]).toBeDefined();
			expect(WebhookLib.send).toHaveBeenCalled();
			expect(mockReplicatedStorage.Events.NotifyPlayer_2.FireClient).toHaveBeenCalledWith(
				mockPlayer,
				expect.objectContaining({ Type: "PurchaseSuccess", Product: productInfo.Name }),
			);
		});

		it("should return NotProcessedYet if player is not found", () => {
			const invalidReceipt = { ...receiptInfo, PlayerId: -1 };
			const decision = MonetizationHandler.processProductPurchase(invalidReceipt);
			expect(decision).toBe(Enum.ProductPurchaseDecision.NotProcessedYet);
		});

		it("should return NotProcessedYet if product info is not found", () => {
			const invalidReceipt = { ...receiptInfo, ProductId: 9999 };
			const decision = MonetizationHandler.processProductPurchase(invalidReceipt);
			expect(decision).toBe(Enum.ProductPurchaseDecision.NotProcessedYet);
		});

		it("should return PurchaseGranted if purchaseId was already processed", () => {
			// First purchase
			MonetizationHandler.processProductPurchase(receiptInfo);
			// Second attempt with same purchaseId
			const decision = MonetizationHandler.processProductPurchase(receiptInfo);
			expect(decision).toBe(Enum.ProductPurchaseDecision.PurchaseGranted);
			// Ensure rewards are not granted twice
			expect(rawMockMonetizationData.Currencies.Gold).toBe(
				ProductsRegistry[receiptInfo.ProductId].Rewards.Currencies.Gold,
			);
		});

		it("should handle item rewards", () => {
			const itemReceipt = {
				...receiptInfo,
				ProductId: 1002, // XP Boost Item
				CurrencySpent: ProductsRegistry[1002].Price,
			};
			const decision = MonetizationHandler.processProductPurchase(itemReceipt);
			expect(decision).toBe(Enum.ProductPurchaseDecision.PurchaseGranted);
			expect(rawMockMonetizationData.Inventory.Items["XP_BOOST_ITEM_ID"]).toBe(1);
		});
	});

	describe("handleGamepass", () => {
		it("should return true and apply benefits if player owns the gamepass", () => {
			const gamepassId = 2001;
			mockMarketplaceService.SetPlayerOwnsAsset(mockPlayer, gamepassId, true); // Player owns it

			const owns = MonetizationHandler.handleGamepass(mockPersonInstance as any, gamepassId);
			expect(owns).toBe(true);
			// Further tests would depend on how gamepass benefits are applied within handleGamepass
		});

		it("should return false if player does not own the gamepass", () => {
			const gamepassId = 2001;
			mockMarketplaceService.SetPlayerOwnsAsset(mockPlayer, gamepassId, false); // Player does not own it

			const owns = MonetizationHandler.handleGamepass(mockPersonInstance as any, gamepassId);
			expect(owns).toBe(false);
		});

		it("should handle errors from UserOwnsGamePassAsync gracefully", () => {
			const gamepassId = 2001;
			mockMarketplaceService.SetUserOwnsGamePassAsyncError(true, "Mock error");

			const owns = MonetizationHandler.handleGamepass(mockPersonInstance as any, gamepassId);
			expect(owns).toBe(false);
			mockMarketplaceService.SetUserOwnsGamePassAsyncError(false); // Reset error state
		});
	});

	describe("GiftData (Placeholder)", () => {
		// These are simple store/get, so basic tests suffice
		it("should store and retrieve gift data", () => {
			const giftData = { Recipient: "FriendPlayer", Gift: "GoldPack", Amount: 1 };
			MonetizationHandler.storeGiftData(mockPlayer, giftData);
			const retrieved = MonetizationHandler.getStoredGiftData(mockPlayer);
			expect(retrieved).toEqual(giftData);
		});
	});
});

export {}; // Make it a module
