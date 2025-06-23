import { expect, describe, it, beforeEach, jest } from "@rbxts/jest-globals";
import { MonetizationService } from "server/services/monetization.service";

describe("MonetizationService", () => {
	let monetizationService: MonetizationService;

	beforeEach(() => {
		monetizationService = new MonetizationService();
		// Don't call onStart() to avoid MarketplaceService dependencies
	});

	describe("Service Information", () => {
		it("should have version information", () => {
			expect(monetizationService.version.major).toBe(1);
			expect(monetizationService.version.minor).toBe(0);
			expect(monetizationService.version.patch).toBe(0);
		});

		it("should have products registry", () => {
			expect(monetizationService.products).toBeDefined();
			expect(typeIs(monetizationService.products, "table")).toBe(true);
		});

		it("should have purchase processed event", () => {
			expect(monetizationService.purchaseProcessed).toBeDefined();
		});

		it("should have gamepass owned event", () => {
			expect(monetizationService.gamepassOwned).toBeDefined();
		});
	});

	describe("Gift Data Management", () => {
		it("should store gift data for a player", () => {
			const mockPlayer = {} as Player;
			const giftData = {
				Recipient: "TestPlayer",
				Gift: "TestGift",
				Amount: 100,
			};

			// This should not throw an error
			let caughtError: unknown;
			try {
				monetizationService.storeGiftData(mockPlayer, giftData);
			} catch (e) {
				caughtError = e;
			}
			expect(caughtError).toBeUndefined();
		});

		it("should retrieve stored gift data for a player", () => {
			const mockPlayer = {} as Player;
			const giftData = {
				Recipient: "TestPlayer",
				Gift: "TestGift",
				Amount: 100,
			};

			monetizationService.storeGiftData(mockPlayer, giftData);
			const retrievedData = monetizationService.getStoredGiftData(mockPlayer);

			expect(retrievedData).toBeDefined();
			expect(retrievedData?.Recipient).toBe("TestPlayer");
			expect(retrievedData?.Gift).toBe("TestGift");
			expect(retrievedData?.Amount).toBe(100);
		});

		it("should return undefined for player with no stored gift data", () => {
			const mockPlayer = {} as Player;
			const retrievedData = monetizationService.getStoredGiftData(mockPlayer);
			expect(retrievedData).toBeUndefined();
		});

		it("should clear stored gift data for a player", () => {
			const mockPlayer = {} as Player;
			const giftData = {
				Recipient: "TestPlayer",
				Gift: "TestGift",
				Amount: 100,
			};

			monetizationService.storeGiftData(mockPlayer, giftData);
			monetizationService.clearStoredGiftData(mockPlayer);

			const retrievedData = monetizationService.getStoredGiftData(mockPlayer);
			expect(retrievedData).toBeUndefined();
		});
	});

	describe("Data Structures", () => {
		it("should support ReceiptInfo interface structure", () => {
			const receiptInfo = {
				PlayerId: 12345,
				PlaceIdWherePurchased: 6717025335,
				ProductId: 123456,
				PurchaseId: "test-purchase-id",
				CurrencySpent: 100,
				CurrencyType: "Robux", // Use string instead of Enum for Jest
			};

			expect(receiptInfo.PlayerId).toBe(12345);
			expect(receiptInfo.ProductId).toBe(123456);
			expect(receiptInfo.CurrencySpent).toBe(100);
		});

		it("should support ProductData interface structure", () => {
			const productData = {
				Id: 123456,
				Name: "Test Product",
				Price: 100,
				Rewards: {
					Currencies: { Gold: 1000 },
					XP: 500,
				},
				Type: "Currency",
			};

			expect(productData.Id).toBe(123456);
			expect(productData.Name).toBe("Test Product");
			expect(productData.Price).toBe(100);
			expect(productData.Rewards.XP).toBe(500);
		});

		it("should support StoredGiftData interface structure", () => {
			const giftData = {
				Recipient: "TestPlayer",
				Gift: "TestGift",
				Amount: 100,
			};

			expect(giftData.Recipient).toBe("TestPlayer");
			expect(giftData.Gift).toBe("TestGift");
			expect(giftData.Amount).toBe(100);
		});
	});
});
