// monetization_handler
--------------------------------------------------------------------------------

import { MarketplaceService, Players, ReplicatedStorage } from "@rbxts/services";
import { Person } from "@commonserver/person";
import { Products, ProductData } from "@registry/Products";
import { WebhookLib } from "@commonutils/WebhookLib";
// import createReceiptHistoryData from "@data/factories/receipthistorydata"; // This seems unused

const version = { major: 1, minor: 0, patch: 0 };

export interface ReceiptInfo {
	PlayerId: number;
	PlaceIdWherePurchased: number;
	ProductId: number;
	PurchaseId: string;
	CurrencySpent: number;
	CurrencyType: Enum.CurrencyType;
}

export interface StoredGiftData {
	Recipient: string;
	Gift: string;
	Amount: number;
}

interface ReceiptHistoryEntry {
	ProductId: number;
	PlayerId: number;
	PurchaseId: string;
	CurrencySpent: number;
	Timestamp: number;
}

interface MonetizationDataCache {
	Currencies: { [key: string]: number };
	XP: number;
	Level: number;
	Inventory: { Items: { [key: string]: number } };
	RobuxSpent: number;
	ReceiptHistory: { [key: string]: ReceiptHistoryEntry };
}

//[=[
//   Handler for monetization events including developer products, gamepasses, and gifts.
//
//   @class MonetizationHandler
//]=]
const MonetizationHandler = {
	version: version,
	products: Products,
	storedGiftData: new Map<Player, StoredGiftData>(),

	//[=[
	//   Processes a developer product purchase
	//
	//   @within MonetizationHandler
	//
	//   @param receiptInfo ReceiptInfo -- The purchase receipt information
	//
	//   @return Enum.ProductPurchaseDecision -- The purchase decision
	//]=]
	processProductPurchase(receiptInfo: ReceiptInfo): Enum.ProductPurchaseDecision {
		const player = Players.GetPlayerByUserId(receiptInfo.PlayerId);
		if (!player) {
			// Player left before purchase could be processed
			return Enum.ProductPurchaseDecision.NotProcessedYet;
		}

		const person = Person.getForPlayer(player);
		if (!person) {
			warn(`Person not found for player ${player.Name} during purchase processing`);
			return Enum.ProductPurchaseDecision.NotProcessedYet;
		}

		const productInfo = MonetizationHandler.products[receiptInfo.ProductId];
		if (!productInfo) {
			warn(`Unknown product ID: ${receiptInfo.ProductId}`);
			return Enum.ProductPurchaseDecision.NotProcessedYet;
		}

		// Check if this purchase was already processed
		if (MonetizationHandler.isPurchaseProcessed(person, receiptInfo.PurchaseId)) {
			return Enum.ProductPurchaseDecision.PurchaseGranted;
		}

		// Process the purchase
		const success = MonetizationHandler.grantProductRewards(person, productInfo);

		if (success) {
			// Record the purchase
			MonetizationHandler.recordPurchase(person, receiptInfo);

			// Send webhook notification
			MonetizationHandler.sendPurchaseWebhook(player, productInfo, receiptInfo);

			// Notify player
			const notifyPlayerRemote = ReplicatedStorage.FindFirstChild("Events")?.FindFirstChild("NotifyPlayer_2") as RemoteEvent | undefined;
			if (notifyPlayerRemote) {
				notifyPlayerRemote.FireClient(player, {
					Type: "PurchaseSuccess",
					Product: productInfo.Name,
				});
			}

			return Enum.ProductPurchaseDecision.PurchaseGranted;
		} else {
			warn(`Failed to grant rewards for product ${productInfo.Name} to player ${player.Name}`);
			return Enum.ProductPurchaseDecision.NotProcessedYet;
		}
	},

	//[=[
	//   Grants rewards for a purchased product
	//
	//   @within MonetizationHandler
	//
	//   @param person Person -- The person to grant rewards to
	//   @param productInfo ProductData -- The product information
	//
	//   @return boolean -- Whether the rewards were successfully granted
	//
	//   @private
	//]=]
	grantProductRewards(person: Person, productInfo: ProductData): boolean {
		person.dataCache((dataCache) => {
			const newCache = { ...dataCache } as MonetizationDataCache;

			// Process rewards based on product type
			for (const [rewardType, amount] of pairs(productInfo.Rewards)) {
				if (rewardType === "Currencies") {
					for (const [currencyType, currencyAmount] of pairs(amount as { [key: string]: number })) {
						if (newCache.Currencies[currencyType] !== undefined) {
							newCache.Currencies[currencyType] = newCache.Currencies[currencyType] + currencyAmount;
						}
					}
				} else if (rewardType === "XP" && typeIs(amount, "number")) {
					newCache.XP = newCache.XP + amount;
				} else if (rewardType === "Level" && typeIs(amount, "number")) {
					newCache.Level = newCache.Level + amount;
				} else if (rewardType === "Items") {
					// Handle item rewards
					for (const [itemId, itemAmount] of pairs(amount as { [key: string]: number })) {
						if (newCache.Inventory.Items[itemId] === undefined) {
							newCache.Inventory.Items[itemId] = 0;
						}
						newCache.Inventory.Items[itemId] = newCache.Inventory.Items[itemId] + itemAmount;
					}
				}
			}

			// Update robux spent tracking
			newCache.RobuxSpent = (newCache.RobuxSpent || 0) + productInfo.Price;

			return newCache;
		});

		return true;
	},

	//[=[
	//   Checks if a purchase has already been processed
	//
	//   @within MonetizationHandler
	//
	//   @param person Person -- The person to check
	//   @param purchaseId string -- The purchase ID to check
	//
	//   @return boolean -- Whether the purchase was already processed
	//
	//   @private
	//]=]
	isPurchaseProcessed(person: Person, purchaseId: string): boolean {
		const dataCache = person.dataCache() as MonetizationDataCache;
		const receiptHistory = dataCache.ReceiptHistory;

		return receiptHistory[purchaseId] !== undefined;
	},

	//[=[
	//   Records a purchase in the player's receipt history
	//
	//   @within MonetizationHandler
	//
	//   @param person Person -- The person to record for
	//   @param receiptInfo ReceiptInfo -- The receipt information
	//
	//   @private
	//]=]
	recordPurchase(person: Person, receiptInfo: ReceiptInfo): void {
		person.dataCache((dataCache) => {
			const newCache = { ...dataCache } as MonetizationDataCache;

			newCache.ReceiptHistory[receiptInfo.PurchaseId] = {
				ProductId: receiptInfo.ProductId,
				PlayerId: receiptInfo.PlayerId,
				PurchaseId: receiptInfo.PurchaseId,
				CurrencySpent: receiptInfo.CurrencySpent,
				Timestamp: os.time(),
			};

			return newCache;
		});
	},

	//[=[
	//   Sends a webhook notification for a purchase
	//
	//   @within MonetizationHandler
	//
	//   @param player Player -- The player who made the purchase
	//   @param productInfo ProductData -- The product information
	//   @param receiptInfo ReceiptInfo -- The receipt information
	//
	//   @private
	//]=]
	sendPurchaseWebhook(player: Player, productInfo: ProductData, receiptInfo: ReceiptInfo): void {
		const [success, result] = pcall(() => {
			const webhookData = {
				content: "",
				embeds: [
					{
						title: "💰 Product Purchase",
						description: `${player.Name} purchased ${productInfo.Name}`,
						color: 0x00ff00,
						fields: [
							{
								name: "Player",
								value: `${player.Name} (${player.UserId})`,
								inline: true,
							},
							{
								name: "Product",
								value: `${productInfo.Name} (ID: ${productInfo.Id})`,
								inline: true,
							},
							{
								name: "Price",
								value: `${productInfo.Price} Robux`,
								inline: true,
							},
							{
								name: "Purchase ID",
								value: receiptInfo.PurchaseId,
								inline: false,
							},
						],
						timestamp: os.date("!%Y-%m-%dT%H:%M:%S.000Z"),
					},
				],
			};

			WebhookLib.send(webhookData);
		});

		if (!success) {
			warn(`Failed to send purchase webhook: ${result}`);
		}
	},

	//[=[
	//   Handles gamepass ownership checks and rewards
	//
	//   @within MonetizationHandler
	//
	//   @param person Person -- The person to check
	//   @param gamepassId number -- The gamepass ID to check
	//
	//   @return boolean -- Whether the player owns the gamepass
	//]=]
	async handleGamepass(person: Person, gamepassId: number): Promise<boolean> {
		const player = person.player;
		const [success, ownsGamepass] = await pcall(async () => {
			return MarketplaceService.UserOwnsGamePassAsync(player.UserId, gamepassId);
		});

		if (success && ownsGamepass) {
			// Apply gamepass benefits
			// This would be specific to each gamepass
			return true;
		}

		return false;
	},

	//[=[
	//   Stores gift data for a player
	//
	//   @within MonetizationHandler
	//
	//   @param player Player -- The player to store gift data for
	//   @param giftData StoredGiftData -- The gift data to store
	//]=]
	storeGiftData(player: Player, giftData: StoredGiftData): void {
		MonetizationHandler.storedGiftData.set(player, giftData);
	},

	//[=[
	//   Retrieves stored gift data for a player
	//
	//   @within MonetizationHandler
	//
	//   @param player Player -- The player to get gift data for
	//
	//   @return StoredGiftData | undefined -- The stored gift data or undefined
	//]=]
	getStoredGiftData(player: Player): StoredGiftData | undefined {
		return MonetizationHandler.storedGiftData.get(player);
	},

	//[=[
	//   Initializes the MonetizationHandler
	//
	//   @within MonetizationHandler
	//]=]
	start(): void {
		// Set up marketplace service callbacks
		MarketplaceService.ProcessReceipt = MonetizationHandler.processProductPurchase;

		print("MonetizationHandler started");
	},
};

export default MonetizationHandler;
